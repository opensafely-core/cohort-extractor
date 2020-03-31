*! version 1.1.6  22sep2004
program define lsens_7, rclass
	version 6.0, missing

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	tempvar touse p w sens spec
	lfit_p `touse' `p' `w' `0'
	local y "`s(depvar)'"
	return scalar N = `s(N)'
	global S_1 `s(N)'

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [, noGraph L1title(string) Symbol(string) Bands(string) /*
	*/ XLAbel(string) YLAbel(string) XLIne(string) YLIne(string) /*
	*/ GENSPec(string) GENSEns(string) GENProb(string) REPLACE * ]

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
	if `"`graph'"'   == `""' { /* set gr7 defaults */
		if `"`symbol'"'  == `""' { local symbol `"od"' }
		if `"`bands'"'   == `""' { local bands  `"10"' }
		if `"`xlabel'"'  == `""' { local xlabel `"0,.25,.5,.75,1"' }
		if `"`ylabel'"'  == `""' { local ylabel `"0,.25,.5,.75,1"' }
		if `"`xline'"'   == `""' { local xline  `".25,.5,.75"' }
		if `"`yline'"'   == `""' { local yline  `".25,.5,.75"' }
		if `"`l1title'"' == `""' {
			local l1title `"Sensitivity/Specificity"'
		}
	}
	local old_N = _N
	nobreak {
		capture noisily break {
			lsens_x `touse' `p' `w' `y' `sens' `spec'

			if `"`graph'"' == `""' {
				format `sens' `spec' `p' %4.2f
				#delimit ;
				gr7 `sens' `spec' `p',
					border c(ll) s(`symbol') bands(`bands')
					xlabel(`xlabel') ylabel(`ylabel')
					xline(`xline') yline(`yline')
					l1(`l1title') `options' ;
				#delimit cr
			}
		}
		local rc = _rc

		if _N > `old_N' /*
		*/ & (`rc' | `"`genspec'`gensens'`genprob'"'==`""') {
			qui drop if `touse' >= .
		}
		if `rc' { exit `rc' }
	}
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

