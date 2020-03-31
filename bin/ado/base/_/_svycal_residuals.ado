*! version 1.1.0  14mar2018
program _svycal_residuals, rclass
	version 14
	syntax varlist(numeric fv) [if] [in],	///
		stub(name) wcal(name)		///
		[nsub(int 0) subuse(varname) pairs]

	* calibration settings
	quietly svyset
	if `"`r(calmethod)'"' == "" {
		di as err "svy calibration settings not found"
		exit 459
	}
	local calmodel	`"`r(calmodel)'"'
	local calopts	`"`r(calopts)'"'
	noConstant, `calopts'
	if `"`wcal'"' != "" {
		local wgt `"[aw=`wcal']"'
	}

	* preserve current results
	tempname ehold
	_est hold `ehold', restore nullok

	* turn off extra/unnecessary calculations
	set buildfvinfo off

	if "`subuse'" == "" {
		local i 0
		foreach y of local varlist {
			quietly						///
			_regress `y' `calmodel'				///
				`if' `in' `wgt',			///
				noheader				///
				notable					///
				`constant'
			local ++i
			quietly predict double `stub'`i', residual
			local rvarlist `rvarlist' `stub'`i'
		}
	}
	else if "`pairs'" != "" {
		tempname ystar
		quietly gen double `ystar' = . in 1

		if `nsub' < 1 {
			sum `subuse' `if' `in', meanonly
			local nsub = r(max)
		}

		local i 0
		while `"`varlist'"' != "" {
		  gettoken var1 varlist : varlist
		  gettoken var2 varlist : varlist
		  local pair `var1' `var2'
		  forval j = 1/`nsub' {
		    foreach y of local pair {
			quietly						///
			replace `ystar' = cond(`subuse'==`j', `y', 0)	///
				`if' `in'
			quietly						///
			_regress `ystar' `calmodel'			///
				`if' `in' `wgt',			///
				noheader				///
				notable					///
				`constant'
			local ++i
			quietly predict double `stub'`i'_`j', residual
			local rvarlist `rvarlist' `stub'`i'_`j'
		    }
		  }
		}
	}
	else {
		tempname ystar
		quietly gen double `ystar' = . in 1

		if `nsub' < 1 {
			sum `subuse' `if' `in', meanonly
			local nsub = r(max)
		}

		local i 0
		foreach y of local varlist {
		    local ++i
		    forval j = 1/`nsub' {
			quietly						///
			replace `ystar' = cond(`subuse'==`j', `y', 0)	///
				`if' `in'
			quietly						///
			_regress `ystar' `calmodel'			///
				`if' `in' `wgt',			///
				noheader				///
				notable					///
				`constant'
			quietly predict double `stub'`i'_`j', residual
			local rvarlist `rvarlist' `stub'`i'_`j'
		    }
		}
	}
	return local varlist `"`rvarlist'"'
end

program noConstant
	syntax [, * noCONStant]
	c_local constant `constant'
end

exit
