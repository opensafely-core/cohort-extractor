*! version 3.1.2  22oct2019
program levelsof
        version 15.0

	syntax varname [if] [in] [, Separate(str) MISSing Local(name local) ///
				    Clean MATROW(name) MATCELL(name)        ///
				    HEXadecimal ]

	if ("`missing'" == "") {
		marksample touse, strok
	}
        else {
        	marksample touse, strok novarlist
        }
        
        if (`"`separate'"' == "") {
        	local separate " "
        }
        
        // Options not allowed when string.

	local typ : type `varlist'

	if ("`typ'" == "strL" | substr("`typ'", 1, 3) == "str") {
	
		NoHexadecimal `hexadecimal'

		NoMatrow `matrow'
	}
	
	// Clear r() after checking syntax so behaves like an rclass command.

        mata: st_rclear() 

	// Different routines for strL, str, or numeric.

	if ("`typ'" == "strL") {
	
		LevelsOfStrL `varlist' if `touse', separate(`"`separate'"') ///
			`clean' matcell(`matcell')
	}
	else if (substr("`typ'", 1, 3) == "str") {

		local isclean = ("`clean'" != "")

		mata: LevelsOfString("`varlist'", "`touse'", ///
			`"`separate'"', `isclean', "`matcell'")
	}
	else { // numeric
	
		local isint = inlist("`typ'", "byte", "int", "long")

		// LevelsOfReal either bails out early and says use tabulate
		// or uses a table sort for integers or a mata sort().

		mata: LevelsOfReal("`varlist'", "`touse'", `"`separate'"', ///
			`isint', 1, "`matrow'", "`matcell'",               ///
			"`hexadecimal'" != "")

		if ("`usetab'" == "usetab") { // use tabulate

			cap LevelsOfTab `varlist' if `touse',       ///
			        `missing' separate(`"`separate'"')  ///
				matrow(`matrow') matcell(`matcell') ///
				`hexadecimal'

			if (_rc) { // tabulate failed

				mata: LevelsOfReal("`varlist'", "`touse'", ///
					`"`separate'"', `isint', 0,        ///
				        "`matrow'", "`matcell'",           ///
					"`hexadecimal'" != "")
			}
		}
	}

	if ("`local'" != "") {
		c_local `local' `"`r(levels)'"'
	}

	di as text `"`r(levels)'"'
end

program define NoHexadecimal
	
	if (`"`0'"' == "") {
		exit
	}
	
	di as error "option {bf:hexadecimal} not allowed with string variable"
	exit 198	
end

program define NoMatrow

	if (`"`0'"' == "") {
		exit
	}

	di as error "option {bf:matrow} not allowed with string variable"
	exit 198
end

program define LevelsOfStrL, rclass sortpreserve

	syntax varname(string) if/ [, SEPARATE(str) CLEAN MATCELL(name) ]

	local touse `if'

	quietly {
		count if `touse'

		if (r(N) == 0) {
			return scalar r = 0
			return scalar N = 0
			exit
		}

		local N `r(N)'

		tempvar n vfreq

		// This code only does one sort. Does not sort by `touse'
		// in case dataset already sorted by `varlist'.

		bysort `varlist': gen double `vfreq' = ///
					cond(_n == _N, sum(`touse'), .)

		gen double `n' = _n if `vfreq' > 0 & `vfreq' < .

		count if `n' < .
		local nr `r(N)'

		moveup `n' `vfreq', overwrite // puts nonmissing first
					      // without sorting
	}

        if (`"`separate'"' == "") {
        	local separate " "
        }

        // First value.

	local levels = `varlist'[`n'[1]]

	if ("`clean'" == "") {

		local separate = `"""' + "'" + `"`separate'"' + "`" + `"""'

		local levels = "`" + `"""' + `"`levels'"'
	}

	// Second to second last.

	local end = `nr' - 1

	forvalues i = 2/`end' {
		local levels `"`levels'`separate'`=`varlist'[`n'[`i']]'"'
	}
	
	// Last.

	if (`nr' > 1) {
		local lev = `varlist'[`n'[`nr']]

		if ("`clean'" == "" ) {
			local lev = `"`lev'"' + `"""' + "'"
		}

		local levels `"`levels'`separate'`lev'"'
	}
	else if ("`clean'" == "" ) {
	
		local levels `"`levels'"'"'
	}

	if ("`matcell'" != "") {

		tempname freq

		matrix `freq' = J(`nr', 1, .)

		forvalues i = 1/`nr' {
			matrix `freq'[`i', 1] = `vfreq'[`i']
		}

		MatrixRename `freq' `matcell'
	}

	return scalar r = `nr'
	return scalar N = `N'
	return local  levels `"`levels'"'
end

program define MatrixRename
	args A B
	cap matrix drop `B'
	matrix rename `A' `B'
end

program define LevelsOfTab, rclass

	syntax varname(numeric) if [, MISSING SEPARATE(str) ///
				      MATROW(name) MATCELL(name) HEXADECIMAL ]

	tempname row

	if ("`matcell'" != "") {
		tempname cell
	}

	qui tab `varlist' `if', `missing' matrow(`row') matcell(`cell')

	if (r(N) == 0) {
		return scalar r = 0
		return scalar N = 0
		exit
	}

	local n `r(r)'

        if (`"`separate'"' == "") {
        	local separate " "
        }
        
        if ("`hexadecimal'" == "") {  
        
        	// Use macro format for nonintegers.
        	// %21.0g for integers.

		forvalues i = 1/`n' {
			if (`row'[`i', 1] == int(`row'[`i', 1])) {
				local lev : di %21.0g `row'[`i', 1]
				local lev `lev'  // trim
			}
			else {
				local lev = `row'[`i', 1]
			}
			
			if (`i' == 1) {
				local levels `lev'
			}
			else {
				local levels `levels'`separate'`lev'
			}
		}
	}
	else {
		local levels : di %21x `row'[1, 1]

		forvalues i = 2/`n' {
			local lev : di %21x `row'[`i', 1]
			local levels `levels'`separate'`lev'
		}
	}

	if ("`matrow'"  != "") {
		MatrixRename `row' `matrow'
	}

	if ("`matcell'" != "") {
		MatrixRename `cell' `matcell'
	}

	return scalar r = r(r)
	return scalar N = r(N)
	return local  levels `levels'
end

// If #obs <= N_MATA_SORT, LevelsOfReal() is always used.
// Otherwise, tabulate may be used.

local N_MATA_SORT 2000

// N_SAMPLE is the target size of a random sample drawn to decide whether
// tabulate should be used.
//
// If the number of unique values in the sample is less than N_USE_TAB and
// the estimated multiplicity of the data is also less than N_USE_TAB, then
// tabulate is used.

local N_SAMPLE  200
local N_USE_TAB  50

version 15.0
mata:

void LevelsOfReal(string scalar varname,
	          string scalar touse,
	          string scalar sep,
	          real   scalar isint,
	          real   scalar tabok,
	          string scalar matrow,
	          string scalar matcell,
	          real   scalar hex)
{
	real scalar     wantfreq
	string          result
	real colvector  x, freq
	real matrix     levels

	st_view(x=., ., varname, touse)

	if (ZeroObs(x)) {
		return
	}

	if (tabok) { // may want to use tabulate

		if (UseTab(x)) {
			st_local("usetab", "usetab")
			return
		}
	}

	wantfreq = (matcell != "")

	if (isint) {
		levels = uniqrowsofinteger(x, wantfreq) // bypass check for
						        // integer values
	}
	else {
		levels = uniqrows(x, wantfreq)
	}

	if (wantfreq) {
		freq   = levels[., 2]
		levels = levels[., 1]
	}

	if (!isint) {
		isint = all(levels :== floor(levels))
	}
	
	if (!hex) {

		// Use invtokens for integers, otherwise run levels through
		// Stata macros if noninteger. No %fmt matches formatting
		// of macros when noninteger in all cases.

		if (isint) {
			result = invtokens(strofreal(levels', "%21.0g"), sep)
		}
		else {
			result = PutInMacro(levels, sep)
		}
	}
	else {
		result = invtokens(strofreal(levels', "%21x"), sep)
	}

	if (strlen(result) > c("macrolen")) {
		exit(error(920))
	}

	CreateMatrix(matcell, freq)
	CreateMatrix(matrow,  levels)

	st_rclear()
	st_numscalar("r(N)", length(x))
	st_numscalar("r(r)", length(levels))
	st_global("r(levels)", result)
}

real scalar ZeroObs(vector x)
{
	if (length(x) == 0) {
		st_rclear()
		st_numscalar("r(N)", 0)
		st_numscalar("r(r)", 0)
		return(1)
	}

	return(0)
}

void CreateMatrix(string scalar name, real colvector x)
{
	if (name == "") {
		return
	}

	if (c("max_matdim") < length(x)) {
		exit(error(915))
	}

	st_matrix(name, x)
}

real scalar UseTab(real colvector x)
{
	real scalar     N
	string scalar   state
	real colvector  y
	real matrix     t

	N = length(x)

	if (N <= `N_MATA_SORT') {
		return(0)
	}

	// Save random number state.

	state = rngstate()

	rseed(987654321)

	y = srswor(x, `N_SAMPLE')

	// Restore random number state.

	rngstate(state)

	// Do tabulation.

	t = uniqrows(y, 1)

	// Check number of unique values.

	if (rows(t) >= `N_USE_TAB') {
		return(0)
	}

	// Check estimated multiplicity.

	return(multiplicity(sum(t[., 2] :== 1), rows(t)) < `N_USE_TAB')
}

real scalar multiplicity(real scalar s, real scalar n)
{
/*
   Estimates multiplicity m of values in dataset based on

   s = # singletons in sample of size n

   uses approximation E(# singletons) = n*((m - 1)/m)^(n - 1)
*/
	return(1/(1 - (s/n)^(1/(n - 1))))
}

string scalar PutInMacro(real colvector x, string scalar sep)
{
	real   scalar  err, i
	string scalar  name

	name = st_tempname()

	st_local("sep", sep)

	for (i = 1; i <= length(x); ++i) {

		st_numscalar(name, x[i])

		err = _stata("local lev = " + name)

		if (err) {
			exit(error(err))
		}

		if (i == 1) {
			err = _stata("local levels " + "`" + "lev" + "'")
		}
		else {
			err = _stata("local levels " + "`" + "levels" + "'"
			             + "`" + "sep" + "'" + "`" + "lev" + "'")
		}

		if (err) {
			exit(error(err))
		}
	}

	return(st_local("levels"))
}

void LevelsOfString(string scalar varname,
	            string scalar touse,
	            string scalar sep,
	            real   scalar clean,
	            string scalar matcell)
{
	string            result
	string colvector  levels, x
	real   colvector  freq

	st_sview(x="", ., varname, touse)

	if (ZeroObs(x)) {
		return
	}

	if (matcell != "") {
		levels = uniqrowsfreq(x, freq=.)
	}
	else {
		levels = uniqrows(x)
	}

	if (!clean) {
		sep = `"""' + "'" + sep + "`" + `"""'
	}

	result = invtokens(levels', sep)

	if (!clean) {
		result = "`" + `"""' + result + `"""' + "'"
	}

	if (strlen(result) > c("macrolen")) {
		exit(error(920))
	}

	CreateMatrix(matcell, freq)

	st_rclear()
	st_numscalar("r(N)", length(x))
	st_numscalar("r(r)", length(levels))
	st_global("r(levels)", result)
}

end

