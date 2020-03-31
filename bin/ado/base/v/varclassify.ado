*! version 1.0.0  26apr2019
program varclassify, rclass
	version 16

	syntax varname(numeric) [if] [in]	      ///
		[, 			              ///
		CATegorical(passthru)		      ///
		UNCERtain(passthru)		      ///
		NSAMPLE(numlist integer max=1 >=1000) /// for timings
		]

	if ("`nsample'" == "") {
		local nsample 4000  // based on timings
	}

	CheckCutoffs, `categorical' `uncertain'
	local categorical `s(categorical)'
	local uncertain   `s(uncertain)'

	// When -if- or -in-, create a new variable to classify.

	if (`"`if'`in'"' != "") {

		marksample touse

		tempvar x

		qui gen double `x' = `varlist' if `touse'
	}
	else {
		local x `varlist'
	}

	// Do classifications:
	//
	//	r(class) = all missing
	//		   constant
	//		   noninteger
	//		   negative
	//		   big

	Summarize `x'
	return add

	if ("`return(class)'" != "") {
		exit
	}

	// Remaining classifications:
	//
	//	r(class) = categorical
	//		   uncertain
	//		   continuous integer

	if (_N <= `nsample') {

		// For small _N, use all observations.

		mata: Classify("`x'", `categorical', `uncertain')
	}
	else {
		// Classify starting with a random sample, then check results
		// against all observations using -inlist- if necessary.
		// When the check works, there is no need to perform a
		// tabulation algorithm on all observations and so is fast.

		Sample `x', categorical(`categorical') uncertain(`uncertain')
	}

	return add
end

program CheckCutoffs, sclass
	syntax [, categorical(numlist integer max=1 >=2 miss)   ///
		  uncertain(  numlist integer max=1 >=0 miss) ]

	local catset   1
	local uncerset 1

	if ("`categorical'" == "") {
		local categorical 10  // default
		local catset 0
	}

	if ("`uncertain'" == "") {
		local uncertain 100  // default
		local uncerset 0
	}
	else if (`uncertain' == 0) {
		local uncertain `categorical'  // no "uncertain" category
	}

	if (`uncertain' < `categorical') {

		di as err "{bf:uncertain()} must be greater than or equal " _c
		di as err "to {bf:categorical()}"

		if (!`catset') {
			di as err "{p 4 4 2}"
			di as err "{bf:categorical()} at default value"
			di as err "`categorical'."
			di as err "Set {bf:categorical()} to a lower value."
			di as err "{p_end}"
	    	}

		if (!`uncerset') {
			di as err "{p 4 4 2}"
			di as err "{bf:uncertain()} at default value"
			di as err "`uncertain'."
			di as err "Set {bf:uncertain()} to a higher value."
			di as err "{p_end}"
	    	}

		exit 198
	}

	sreturn local categorical `categorical'
	sreturn local uncertain   `uncertain'
end

program Summarize, rclass
	syntax varname(numeric)

//  Checks for (in this order):
//
//	r(class) = all missing	  all values missing
//		   constant	  constant
//		   noninteger	  one or more values noninteger
//		   negative	  integer and one or more values < 0
//		   big		  nonnegative integer and > 2^31 - 1

	su `varlist', meanonly
	return scalar sum  = r(sum)
	return scalar mean = r(mean)
	return scalar max  = r(max)
	return scalar min  = r(min)
	return scalar N    = r(N)

	// all missing

	if (r(N) == 0) {
		return local class "all missing"
		exit
	}

	// constant

	if (r(min) == r(max)) {

		// Set r(r) if nonnegative integer.

		if (floor(r(min)) == r(min) & r(min) >= 0) {
			return scalar r = 1
		}

		return local class "constant"
		exit
	}

	// noninteger

	cap assert `varlist' == floor(`varlist'), fast
	if (c(rc) == 9) {
		return local class "noninteger"
		exit
	}
	else if (c(rc)) {
		error c(rc)
	}

	// negative

	if (r(min) < 0) {
		return local class "negative"
		exit
	}

	// big

	local MAXFV 2147483647 // 2^31 - 1, maximum value of a factor variable

	if (r(max) > `MAXFV') {
		return local class "big"
	}
end

program Sample, rclass
	syntax varname(numeric), categorical(numlist integer miss) ///
				 uncertain(  numlist integer miss)

	mata: ClassifySample("`varlist'", `uncertain')
	if ("`r(class)'" != "") {
		return add
		exit
	}

	// If ClassifySample() left behind an -inlist- expression, see if it
	// contains all the values.

	if ("`r(inlist)'" != "") {

		local n      `r(r)'
		local inlist `r(inlist)'

		qui count if `inlist' | `varlist' >= .

		if (r(N) == _N) {

			return scalar r = `n'

			if (`n' <= `categorical') {
				return local class categorical
			}
			else {
				return local class uncertain
			}

			// `n' > `uncertain' already done

			exit
		}

		if (r(N) >= _N/2) {  // identified half or more of the data

			tempvar x

			qui gen double `x' = `varlist' ///
				if !`inlist' & `varlist' < .

			mata: ClassifyOutOfSample("`x'", `n', `categorical', ///
							      `uncertain')
			return add
			exit
		}
	}

	// If here, we must look at the whole variable.

	mata: Classify("`varlist'", `categorical', `uncertain')
	return add
end

/////////////////////////////////// Mata ////////////////////////////////////

local MAXINLIST 250  // maximum # of arguments to inlist()

version 16
mata:
mata set matastrict on

void Classify(string scalar varname, real scalar cat, real scalar uncer)
{
	real scalar    n
	real colvector x, y

	st_view(x=., ., varname)

	y = select(x, x :< .)  // so uniqrows() is faster when lots of missing
			       // x guaranteed to have some nonmissing values

	st_rclear()

	n = length(uniqrows(y))

	CategoricalUncertainContinuous(n, cat, uncer)
}

void CategoricalUncertainContinuous(real scalar n,
                                    real scalar cat,
                                    real scalar uncer)
{
	if (n <= cat) {
		st_numscalar("r(r)", n)
		st_global("r(class)", "categorical")
		return
	}

	if (n <= uncer) {
		st_numscalar("r(r)", n)
		st_global("r(class)", "uncertain")
		return
	}

	st_numscalar("r(bound)", uncer)
	st_global("r(class)", "continuous integer")
}

void ClassifySample(string scalar varname, real scalar uncer)
{
	real scalar    n, N
	string scalar  state
	real colvector sample, x

	// Save random number state.

	state = rngstate()

	// To draw the random sample, a seed is set based on the name of
	// the variable. Hence, different variables get different samples.
	// Although results are deterministic, if a fixed seed was used,
	// the same observations would be picked for all variables with the
	// same _N. A bad sample (e.g., one with lots of missings) might then
	// occur across multiple variables. (A bad sample is one in which the
	// -inlist- expression fails to contain most of the values of the
	// variable and forces a -uniqrows()- on the whole variable.)

	rseed(NameToSeed(varname))

	N = st_numscalar("c(N)")

	sample = srswor(1::N, 500)

	// Restore random number state.

	rngstate(state)

	x = st_data(sample, varname)

	x = select(x, x :< .)

	st_rclear()

	if (length(x) == 0) {  // sample was all missing
		return
	}

	x = uniqrows(x)  // guaranteed to have length() >= 1

	n = length(x)

	if (n > uncer) {
		st_numscalar("r(bound)", uncer)
		st_global("r(class)", "continuous integer")
		return
	}

	if (n < `MAXINLIST') {
		st_numscalar("r(r)", n)
		st_global("r(inlist)", "inlist(" + varname + "," +
			invtokens(strofreal(x', "%10.0f"), ",") + ")")
	}
}

void ClassifyOutOfSample(string scalar varname,
			 real scalar n,
     			 real scalar cat,
			 real scalar uncer)
{
	real scalar    nnew
	real colvector x, y

	st_view(x=., ., varname)

	y = select(x, x :< .)  // guaranteed to have length() >= 1

	st_rclear()

	nnew = length(uniqrows(y)) + n

	CategoricalUncertainContinuous(nnew, cat, uncer)
}

real scalar NameToSeed(string scalar name)
{
	real scalar    i, p, s
	real rowvector r

	p = 2147483647 // = 2^31 - 1, max set seed and Mersenne prime

	r = ascii(name)

	s = 0

	for (i = 1; i <= length(r); ++i) {
		s = mod(s + r[i], p)
	}

	return(s)
}

end

exit

Classifications are made in the following order:

	r(class) = all missing		all values missing
		   constant		constant
		   noninteger		one or more values noninteger
		   negative		integer and one or more values < 0
		   big			nonnegative integer and > 2^31 - 1
		   categorical		nonnegative integer and # distinct in [1, cat]
		   uncertain		nonnegative integer and # distinct in (cat, uncer]
		   continuous integer	nonnegative integer and # distinct > uncer

		   where cat = categorical(#) and uncer = uncertain(#)

It also sets

	r(r) = # distinct values, but only when <= uncer and nonnegative
	       integer; otherwise it is missing.

	r(N) = # nonmissing values
	r(min)
	r(max)
	r(mean)
	r(sum)

END OF FILE
