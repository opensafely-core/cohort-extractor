*! version 3.1.2  31jul2018
program define cf, rclass
	version 8
	syntax varlist using/ [, 	///
		Verbose 		///	
		All 			///
		TOLerance(string)	///  undocumented
		]

	local obs = _N
	local dif "0"
	local Nsum = 0
	if _caller() < 10 {
		if "`all'"!="" {
			local verbose "verbose"
		}
		local qv = cond("`verbose'"=="", "*", "noisily")
	}
	else {
		local qv = cond("`all'"=="", "*", "noisily")
	}
	quietly describe using `"`using'"'
	if (r(N) != _N) {
		di in gr "master has " ///
			in ye "`obs'" ///
			in gr " obs., using " ///
			in ye r(N)
		exit 9
	}

	if "`varlist'" != "" {
		preserve
		keep `varlist'  /* reduce to a minimal set */

		local i 1
		foreach var of local varlist {
			capture confirm var `var'
			if !_rc {
				local abbrev`i' = abbrev("`var'", 16)
				tempname `i'
				rename `var' ``i''
			}
			
			local `++i'
		}

		tempfile tempcfm
		quietly save `"`tempcfm'"'

		qui use `"`using'"'
		/* note that the main and using data sets are switching roles. */

		/* Do a preliminary run-through to find minimal set of vars,
		i.e., the vars common to the two data sets.  */
		foreach var of local varlist {
			capture unab tmpname : `var'
			if !_rc & ("`tmpname'" == "`var'") {
				local comvars "`comvars' `var'"
			}
		}

		if "`comvars'" != "" {
			keep `comvars'  /* reduce to a minimal set */
			tempvar cf_merge
			quietly merge using `"`tempcfm'"', _merge(`cf_merge')
		}

		local i 1
		foreach var of local varlist {
			capture unab tmpname : `var'
			if _rc | ("`tmpname'" != "`var'") {
				di in gr %19s "`abbrev`i'':  " ///
					in ye "does not exist in using"
				local dif "9"
			}
			else {
				local tm : type ``i''
				local tu : type `var'
				local string = substr("`tm'",1,3)=="str" | ///
					substr("`tu'",1,3)=="str"	
				if "`tolerance'" != "" & !`string' {
					qui count if reldif(`var',``i'') > `tolerance'
				}
				else {
					capture count if `var' != ``i''
				}
				/* `var' is from the original using file.
				``i'' is from the original master file.
				(But the two have switched roles.) */
				if _rc {
					di in gr %19s "`abbrev`i'':  " ///
						in ye "`tm'" ///
						in gr " in master but " ///
						in ye "`tu'" ///
						in gr " in using"
					local dif "9"
				}
				else if r(N)==0 {
					`qv' di in gr %19s "`abbrev`i'':  " "match"
				}
				else {
					if r(N) > 1 {
						local es es
					}
					di in gr %19s "`abbrev`i'':  " ///
						in ye r(N) ///
						in gr " mismatch`es'"
					local Nsum = `Nsum' + r(N)
					if "`verbose'" != "" & _caller() >= 10 {
					local maxobslen = length("`=_N'")
					    forvalues j = 1/`=_N' {
						if `var'[`j'] != ``i''[`j'] {
						    di _col(20) ///
						       as txt "obs " ///
						       as res ///
						       %`maxobslen'.0f `j' ///
						       as txt ". " ///
						       as res ``i''[`j'] ///
						       as txt " in master; " ///
						       as res `var'[`j'] ///
						       as txt " in using"
						}
					    }
					}
					local dif "9"
				}
			}
			local `i++'
		}
		restore
	}
	return local Nsum = `Nsum'
	exit `dif'
end

