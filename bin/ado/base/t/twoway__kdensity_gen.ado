*! version 1.4.1  12mar2015
// parse and optionally generate variables for -graph twoway kdensity-
program twoway__kdensity_gen, rclass sortpreserve
	version 8.0

	syntax varname(numeric)			///
		[fw aw] [if] [in],		///
		Range(string asis)		///
		[				///
		N(integer 1)			///
		Width(real 0.0)			///
		BWidth(real 0.0)		///
		AREA(real 1)			///
		Generate(string)		///
		Kernel(string)			///
/*old syntax*/	BIweight			/// kernels
		COSine				///
		EPanechnikov			///
		epan2				///
		GAUssian			///
		PARzen				///
		RECtangle			///
		TRIangle			///
		boundary	]

	local y `varlist'
	local wgt [`weight'`exp']
	marksample touse

	CheckGenOpt `generate'
	local generate `s(varlist)'
	if `"`generate'"' != "" & `"`s(replace)'"' == "" {
		confirm new var `generate'
	}

	if `"`range'"' != "" {
		capture confirm name `range'
		if !_rc {
			capture confirm numeric var `range'
			local range_isvar 1
		}
		else if "`boundary'" == "" {
			CheckRange , range(`range')
			local range_isvar 0
		}
		else {
			opts_exclusive "range() boundary"
			exit 198
		}
	}

	local kernel_old	`biweight'	///
				`cosine'	///
				`epanechnikov'	///
				`epan2'		///
				`gaussian'	///
				`parzen'	///
				`rectable'	///
				`triangle'	///
				// blank

	if `n' < 1 {
		di as err "option n() requires a positive integer"
		exit 198
	}
	if `area' <= 0 {
		di as err "option area() expects a positive number"
		exit 198
	}
	if `bwidth' != 0 {
		if `width' != 0 {
			di as err ///
			     "options width() and bwidth() may not be combined"
			exit 198
		}
		local width = `bwidth'
	}

	if "`boundary'" != "" {
		// Calculate bandwidth
		local ix `"`varlist'"'
		if `"`weight'"' == "iweight" {
			quietly summ `ix' if `touse', detail
		}
		else {
			quietly summ `ix' `wgt' if `touse', detail
		}
		local ixmean = r(mean)
		local ixsd   = r(sd)

		local wwidth = `width'
		/*default bandwidth calculation */
		if `wwidth' == 0.0 { 
			local wwidth = min( r(sd) , (r(p75)-r(p25))/1.349)
			if `wwidth' <= 0.0 {
				local wwidth = r(sd)	
			}
			local wwidth = 0.9*`wwidth'/(r(N)^.20)
		}
		sum `range' if `touse', mean
		return scalar min = r(min) - `wwidth'
		return scalar max = r(max) + `wwidth'
		// range and boundary are mutually exclusive
		if `n' == 1 {
			return scalar delta = .		// on purpose
		}
		else	return scalar delta = (return(max)-return(min))/(`n'-1)
		return scalar area = `area'
		return scalar width = `width'
		return scalar n = `n'
		return local range `"`range'"'
		return local varname `"`y'"'
	}
	else {
		// Saved results
		if `range_isvar' {
			sum `range' if `touse', mean
			return scalar min = r(min)
			return scalar max = r(max)
		}
		else {
			tokenize `range'
			return scalar min = `1'
			return scalar max = `2'
		}
		if `n' == 1 {
			return scalar delta = .		// on purpose
		}
		else	return scalar delta = (return(max)-return(min))/(`n'-1)
		return scalar area = `area'
		return scalar width = `width'
		return scalar n = `n'
		return local range `"`range'"'
		return local varname `"`y'"'
	}
	if _N < `n' {
		return local preserve preserve
	}

	// parsing is finished, so exit if no variables to generate

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

	// generate variables
	tempvar y x
	gen double `x' = return(min) in 1
	if `n' >= 2 {
		replace `x' = `x'[_n-1] + return(delta) in 2/`n'
	}
	kdensity `return(varname)'	///
		`wgt' if `touse',	///
		at(`x')			///
		width(`return(width)')	///
		kernel(`kernel')	///
		`kernel_old'		///
		generate(`y')		///
		nograph			///
		// blank
	return local kernel `r(kernel)'
	replace `y' = `y'*`return(area)'

} // quietly

	// we wouldn't be here if `generate' was empty
	dropSafe `generate'
	tokenize `generate'
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

program CheckRange
	cap syntax , range(numlist min=2 max=2 sort)
	local rc = _rc
	if _rc {
		di as err ///
		"option range() requires two numbers"
		exit `rc'
	}
end

program dropSafe
	foreach var of local 0 {
		capture confirm var `var'
		if !_rc {
			unab fullVarName : `var'
			if "`fullVarName'" == "`var'" {
				drop `var'
			}
		}
	}
end

exit
