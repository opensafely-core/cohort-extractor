*! version 1.0.5  07feb2012
// parse and optionally generate variables for -graph twoway normgen-
program twoway__normgen_gen, rclass sortpreserve
	version 8.0

	local defmin 1e300
	local defmax -1e300
	local defn 300
	local defstddev -1
	local defstdrange -1
	local defmean 1e300
	syntax [varlist(numeric max=1 default=none)]	///
		[fw aw] [if] [,				///
		MIN(real `defmin')			///
		MAX(real `defmax')			///
		N(real `defn')				///
		STDdev(real `defstddev')		///
		STDRange(real `defstdrange')		///
		MEAN(real `defmean')			///
		AREA(real 1)				///
		Generate(string)			///
		/// MLE					/// not implemented yet
	]

	CheckGenOpt `generate'
	local generate `s(varlist)'
	if `"`generate'"' != "" & `"`s(replace)'"' == "" {
		confirm new var `generate'
	}

	if `n' < 1 {
		di as err "option n() requires a positive integer"
		exit 198
	}
	if `area' <= 0 {
		di as err "option area() expects a positive number"
		exit 198
	}

	// Saved results
	return scalar area = `area'
	return scalar n = `n'
	if "`varlist'" != "" {
		qui sum `varlist' [`weight'`exp'] `if'
		return scalar ///
			mean = cond(`mean' == `defmean', r(mean), `mean')
		return scalar ///
			sd = cond(`stddev' == `defstddev', r(sd), `stddev')
	}
	else {
		return scalar mean = cond(`mean' == `defmean', 0, `mean')
		return scalar sd = cond(`stddev' == `defstddev', 1, `stddev')
	}
	local r = cond(`stdrange' < 0 , 4, `stdrange')
	local umin  = return(mean) - `r'*return(sd)
	local umax  = return(mean) + `r'*return(sd)
	return scalar min  = cond(`min' == `defmin', `umin', `min')
	return scalar max  = cond(`max' == `defmax', `umax', `max')

	// parsing is finished, so exit if no variables to generate

	if _N < `n' {
		return local preserve preserve
	}

	if `"`generate'"' == "" {
		exit
	}

	/* check the current number of observations here instead of above; it
	 * is irrelevant if variables are not being generated
	 */

quietly {

	if _N < `n' {
		preserve , changed
		set obs `n'
	}

	if `n' == 1 {
		return scalar delta = .		// on purpose
	}
	else	return scalar delta = (return(max)-return(min))/(`n'-1)

	// generate variables
	tempvar y x
	gen double `x' = return(min) in 1
	if `n' >= 2 {
		replace `x' = `x'[_n-1] + return(delta) in 2/`n'
	}
	gen double ///
		`y' = normden(`x', return(mean), return(sd))*return(area) ///
		in 1/`n'

} // quietly

	// we wouldn't be here if `generate' was empty
	tokenize `generate'
	capture drop `1'
	capture drop `2'
	rename `y' `1'
	rename `x' `2'
end

/* parse the contents of the -generate- option:
 * generate(y x [, replace])
 */

program CheckGenOpt, sclass
	syntax [namelist] [, replace ]

	if `"`replace'`namelist'"' != "" {
		if 0`:word count `namelist'' != 2 {
			di as err "option generate() incorrectly specified"
			exit 198
		}
	}
	sreturn clear
	sreturn local varlist `namelist'
	sreturn local replace `replace'
end

exit
