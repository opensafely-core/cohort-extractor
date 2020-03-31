*! version 1.3.2  16oct2015
program define lsens, rclass
	local vcaller = string(_caller())
	version 6.0, missing
	if _caller() < 8 {
		lsens_7 `0'
		return add
		exit
	}

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	if "`e(cmd)'" == "ivprobit" {
		local vv version `vcaller':
	}
	tempvar touse p w sens spec
	`vv' ///
	lfit_p `touse' `p' `w' `0'
	local y "`s(depvar)'"
	return scalar N = `s(N)'
	global S_1 `s(N)'

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [,			///
		GENSPec(string)		///
		GENSEns(string)		///
		GENProb(string)		///
		REPLACE			///
		noGraph			///
		*			/// graph opts
		]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	if `"`replace'"' != "" {
		ReplVar genspec `genspec'
		local genspec `"`r(varname)'"'
		ReplVar gensens `gensens'
		local gensens `"`r(varname)'"'
		ReplVar genprob `genprob'
		local genprob `"`r(varname)'"'
	}
	if `"`genspec'"' != `""' { confirm new variable `genspec' }
	if `"`gensens'"' != `""' { confirm new variable `gensens' }
	if `"`gensp'"'   != `""' { confirm new variable `genprob' }
	local old_N = _N

nobreak {
capture noisily break {

	lsens_x `touse' `p' `w' `y' `sens' `spec'

	if `"`graph'"' == `""' {
		format `sens' `spec' `p' %4.2f
		local xttl : var label `p'
		version 8: graph twoway				///
		(connected `sens' `spec' `p',			///
			ylabel(0(.25)1, grid)			///
			ytitle("Sensitivity/Specificity")	///
			xlabel(0(.25)1, grid)			///
			xtitle(`"`xttl'"')			///
			title(`""')				///
			`options'				///
		)						///
		|| `plot' || `addplot'				///
		// blank
	}

} // cap noi break

	local rc = _rc

	if _N > `old_N' /*
	*/ & (`rc' | `"`genspec'`gensens'`genprob'"'==`""') {
		qui drop if `touse' >= .
	}
	if `rc' { exit `rc' }

} // nobreak

	if _N > `old_N' & `"`genspec'`gensens'`genprob'"'!=`""' {
		di in blu `"obs was `old_N', now "' _N
	}
	if `"`genprob'"' != `""' {
		qui gen double `genprob' = `p'
		label variable `genprob' `"Probability cutoff"'
		format `genprob' %9.6f
	}
	if `"`gensens'"' != `""' {
		rename `sens' `gensens'
		format `gensens' %9.6f
	}
	if `"`genspec'"' != `""' {
		rename `spec' `genspec'
		format `genspec' %9.6f
	}
end

program define ReplVar, rclass
	local optname `"`1'"'
	macro shift
	local var `"`*'"'
	return local varname `"`var'"'
	if `"`var'"'==`""' { exit }
	local nvar : word count `var'
	if `nvar' > 1 {
		di in red `"too many variables specified in `optname'()"'
		exit 103
	}
	capture confirm variable `var'
	if _rc == 0 {
		unabbrev `var'
		return local varname `s(varlist)'
		drop `var'
	}
end

