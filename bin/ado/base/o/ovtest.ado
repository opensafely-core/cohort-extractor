*! version 2.6.1  02feb2012
program define ovtest, rclass
	version 6

	local ver : di "version " string(_caller()) ", missing :"

	_isfit cons anovaok

	/* `r' and `a' indicate the command line is to be run only for
	   regress and pre version 11 anova, respectively (modern anova
	   is treated more like regress) */
	if "`e(cmd)'" == "anova" && "`e(version)'"=="" {
		if _caller() >= 11 {
			// must call additional -anova- old style
			local ver "version 10.1, missing :"
		}
		local r "*"
	}
	else {
		local a "*"
	}

	syntax [, Rhs]

	if "`r'" == "" & "`rhs'" != "" {
		_ms_op_info e(b)
		if `r(tsops)' {
                	di in smcl as error ///
				"cannot use {opt rhs} option with " _c
                	di in smcl as error ///
				"models that contain time-series operators"
                	exit 321
		}
		if `r(fvops)' {
			// Code for modern anova or regress with fv operators
			// when -rhs- has been specified is separate from the
			// old code that handles all other cases
			`ver' Do_FV_Reg , `rhs'
			return add
			exit
		}
	}

	if "`rhs'" == "" {
		local freset "freset"
	}
	local rhs

	if "`e(wtype)'" != "" {
		tempvar wt
		qui gen float `wt' `e(wexp)'
		local wgtexp "[`e(wtype)'=`wt']"
	}

	tempvar use yh
	qui gen byte `use' = e(sample)

	local lhs "`e(depvar)'"
`r'	_getrhs varlist
`r'	_find_tsops `lhs' `varlist'
`r'	if `r(tsops)' & ("`freset'" == "") {
`r'		di in smcl as error "cannot use {opt rhs} option with " _c
`r'		di in smcl as error "models that contain time-series operators"
`r'		exit 321
`r'	}
`r'	tokenize `varlist'
`a'	anova_terms
`a'	local terms `r(rhs)'
`a'	local acont `r(continuous)'

	if "`a'"=="" & "`freset'"=="" {
		Check_rhs_anova "`acont'" "`terms'"
	}

	if "`freset'" == "" { 
		preserve		/* must be done before est hold */
	}

	quietly _predict double `yh' if `use'
	tempname ehold
	estimate hold `ehold'
	capture {
		if "`freset'" != "" {
			local subline "fitted values of `lhs'"
			tempvar yh2 yh3 yh4
			summ `yh'
			replace `yh' = (`yh'-r(min))/(r(max)-r(min))
			gen float `yh2' = `yh'*`yh'
			gen float `yh3' = `yh'*`yh'*`yh'
			gen float `yh4' = `yh'*`yh'*`yh'*`yh'
			local rhs "`yh2' `yh3' `yh4'"
`r'			`ver' _regress `lhs' `varlist' `rhs' `wgtexp' if `use'
`a'			local aopt cont(`acont' `rhs')
`a'			`ver' anova `lhs' `terms' `rhs' `wgtexp' if `use' , `aopt'
			if _se[`yh2']==0 & _se[`yh3']==0 & _se[`yh4']==0 {
				local problem 1
			}
			else {
				test `yh2' `yh3' `yh4'
				ret scalar df_r = r(df_r) 
				ret scalar df = r(df)
				ret scalar F = r(F)
`r'				ret scalar p = r(p)
`a'				ret scalar p = Ftail(r(df),r(df_r),r(F))
			}
			label var `yh2' "predicted `lhs'^2"
			label var `yh3' "predicted `lhs'^3"
			label var `yh4' "predicted `lhs'^4"
		}
		else {
			tempname min max
			* preserve
			keep if `use'
`r'			keep `lhs' `varlist' `wt' 

			local rhs
			local zlist
`a'			local aopt "cont(`acont' "
`a'			tokenize `acont'
			/* if regress, then `varlist' already tokenized*/
			while "`1'"!="" {
				summ `1'
				scalar `min' = r(min)
				scalar `max' = r(max)
				if `min'==`max' {
`r'					drop `1'
`a'					local problem 2
`a'					continue, break
				}
				else {
					label var `1' "`1'"
					capture assert `1'==0 | `1'==1
					if _rc==0 {
						compress `1'
`r'						local rhs "`rhs' `1'"
					}
					else {
						replace `1' = /*
						*/ (`1'-`min')/(`max'-`min')
`r'						local rhs "`rhs' `1'"
						compress `1'
						tempvar z2 z3 z4
						gen float `z2' = `1'*`1'
						compress `z2'
						gen float `z3' = `1'*`1'*`1'
						compress `z3'
						gen float `z4' = `1'*`1'*`1'*`1'
						compress `z4'
						local zlist /*
						*/ "`zlist' `z2' `z3' `z4'"
`a'						local aopt `aopt' `z2' `z3' `z4'
						label var `z2' "`1'^2"
						label var `z3' "`1'^3"
						label var `z4' "`1'^4"
					}
				}
				mac shift
			}
`a'			local aopt "`aopt')"
			if "`problem'"=="" {
				if "`zlist'"=="" {
					local problem 1
				}
				else {
`r'					`ver' _regress `lhs' `zlist' `rhs' `wgtexp'
`a'					`ver' anova `lhs' `zlist' `terms' `wgtexp' , `aopt'
					test `zlist'
`a'					local subline "continuous "
					local subline /*
					   */ "`subline'independent variables"
					ret scalar df_r = r(df_r)
					ret scalar df = r(df)
					ret scalar F = r(F)
`r'					ret scalar p = r(p)
`a'					ret scalar p = Ftail(r(df),r(df_r),r(F))
				}
			}
			local rhs "`rhs' `zlist'"
		}
		if "`problem'"=="" {
			tokenize `rhs'
			while "`1'" != "" {
				if _se[`1']==0 {
					local msg : variable label `1'
					noi di in gr /*
		*/ "(note:  `msg' dropped because of collinearity)"
				}
				mac shift
			}
		}
	}
	local rc = _rc 
	estimate unhold `ehold' 
	error `rc' 		/* noop if `rc'==0 */

	if "`problem'"=="1" { 
		if "`freset'" != "" {
			di in green "powers of fitted values collinear with explanatory variables"
		}
		else {
			di in green "powers of all explanatory variables collinear"
		}
		di in green "(typically because all explanatory variables are indicator variables)"
	}
	if "`problem'"!="" {
		if (1) {
			/* Double saves */
			global S_3 .
			global S_5 . 
			global S_6 .
		}
		di in red "test not possible"
		exit 499
	}

	if (1) {
		/* Double saves */
		global S_3 = return(df)
		global S_5 = return(df_r)
		global S_6 = return(F)
	}

	OutputResults `"`subline'"' `return(df)' `return(df_r)' `return(F)'
end

program OutputResults
	args subline df df_r F

	di 
	di in gr "Ramsey RESET test using powers of the `subline'"
	di in gr "       Ho:  model has no omitted variables"
	local ttl : display "F(" `df' ", " `df_r' ")"
	local skip = max(0,26-length("`ttl'"))
	di _skip(`skip') in gr "`ttl' = " in ye %9.2f `F'
	di _col(19) in gr "Prob > F =      " in ye /* 
		*/ %6.4f fprob(`df',`df_r',`F')
end


program define Check_rhs_anova
	args cvars terms

	/* error if no continuous variables in the anova */
	if "`cvars'" == "" {
		di as err /*
	  */ "rhs not allowed following anova with no continuous rhs variables"
		exit 198
	}

	/* error if the continuous vars are involved in interactions */
	foreach v of local cvars {
		foreach t of local terms {
			if "`t'" != "`v'" {
				local tnames : subinstr local t "*" " ", all
				foreach tn of local tnames {
					if "`tn'" == "`v'" {
						di as err /*
*/ "rhs not allowed when continuous vars are in interaction terms in the anova"
						exit 198
					}
				}
			}
		}
	}
end

// This program handles the -rhs- option when there are fv operators
program Do_FV_Reg, rclass

	if _caller() < 11 {
		local ver  "version 11, missing :"
	}
	else {
		local ver : di "version " string(_caller()) ", missing :"
	}

	if "`e(wtype)'" != "" {
		tempvar wt
		qui gen float `wt' `e(wexp)'
		local wgtexp "[`e(wtype)'=`wt']"
	}

	tempvar use yh
	qui gen byte `use' = e(sample)

	local lhs "`e(depvar)'"

	local varlist : colnames e(b)
	local varlist : subinstr local varlist "_cons" "", word

	preserve	// must be done before -_estimate hold-

	quietly _predict double `yh' if `use'
	tempname ehold min max
	_estimate hold `ehold'
	capture {
		keep if `use'
		unopvarlist `varlist'
		keep `lhs' `r(varlist)' `wt'
		local ckcnt 0
		foreach vv of local varlist {
			_ms_parse_parts `vv'

			if r(omit) { // base or omit
				local rhs `rhs' `vv'
			}
			else if "`r(type)'" == "factor" {
				local rhs `rhs' `vv'
				local ckdrp `ckdrp' `vv'
				local ++ckcnt
				local cklab`ckcnt' `vv'
			}
			else if "`r(type)'" == "interaction" {
				local rhs `rhs' `vv'
				local hasc 0
				forvalues i = 1/`r(k_names)' {
					if "`r(op`i')'" == "c" {
						local hasc 1
					}
				}
				if `hasc' { // continuous factors in interact.
					tempvar z1 z2 z3 z4

					gen double `z1' = `vv'
					compress `z1'

					capture assert `z1'==0|`z1'==1
					if _rc!=0 {
						summ `z1', meanonly
						scalar `min' = r(min)
						scalar `max' = r(max)
						replace `z1' = ///
						    (`z1'-`min')/(`max'-`min')
						compress `z1'
						gen float `z2'=`z1'*`z1'
						compress `z2'
						gen float `z3'=`z1'*`z1'*`z1'
						compress `z3'
						gen float `z4'= ///
							    `z1'*`z1'*`z1'*`z1'
						compress `z4'
						local zlist ///
							`zlist' `z2' `z3' `z4'
						local ckdrp ///
							`ckdrp' `z2' `z3' `z4'
						local ++ckcnt
						local cklab`ckcnt' (`vv')^2
						local ++ckcnt
						local cklab`ckcnt' (`vv')^3
						local ++ckcnt
						local cklab`ckcnt' (`vv')^4
					}
					drop `z1'
				}
				else { // no continuous factors in interaction
					local ckdrp `ckdrp' `vv'
					local ++ckcnt
					local cklab`ckcnt' `vv'
				}
			}
			else if "`r(type)'" == "variable" {
				local nm `r(name)'
				summ `nm', meanonly
				scalar `min' = r(min)
				scalar `max' = r(max)
				if `min' == `max' {
					drop `nm'
					local problem 2
					continue, break
				}
				else {
					local ckdrp `ckdrp' `nm'
					local ++ckcnt
					local cklab`ckcnt' `nm'
					capture assert `nm'==0|`nm'==1
					if _rc==0 {
						local rhs `rhs' `nm'
						compress `nm'
					}
					else {
						replace `nm' = ///
						    (`nm'-`min')/(`max'-`min')
						local rhs `rhs' `nm'
						compress `nm'
						tempvar z2 z3 z4
						gen float `z2'=`nm'*`nm'
						compress `z2'
						gen float `z3'=`nm'*`nm'*`nm'
						compress `z3'
						gen float `z4'= ///
							    `nm'*`nm'*`nm'*`nm'
						compress `z4'

						local zlist ///
							`zlist' `z2' `z3' `z4'
						local ckdrp ///
							`ckdrp' `z2' `z3' `z4'
						local ++ckcnt
						local cklab`ckcnt' `nm'^2
						local ++ckcnt
						local cklab`ckcnt' `nm'^3
						local ++ckcnt
						local cklab`ckcnt' `nm'^4
					}
				}

			}
			else { // type "product" or "error" should not happen
				di as err "r(type) `r(type)' not supported"
				exit 322
			}
		}

		if "`problem'" == "" {
			if "`zlist'"=="" {
				local problem 1
			}
			else {
				`ver' _regress `lhs' `zlist' `rhs' `wgtexp'
				test `zlist'
				ret scalar df_r = r(df_r)
				ret scalar df = r(df)
				ret scalar F = r(F)
				ret scalar p = r(p)
			}
		}

		if "`problem'" == "" {
			local cknum 0
			foreach ck of local ckdrp {
				local ++cknum
				if _se[`ck']==0 {
					noi di in gr ///
		      "(note:  `cklab`cknum'' dropped because of collinearity)"
				}
			}
		}
	} // end of -capture-
	local rc = _rc
	_estimate unhold `ehold'
	error `rc'

	if "`problem'"=="1" {
		di in green "powers of all explanatory variables collinear"
		di in green ///
	"(typically because all explanatory variables are indicator variables)"
	}
	if "`problem'"!="" {
		di as err "test not possible"
		exit 499
	}

	OutputResults "independent variables" ///
				`return(df)' `return(df_r)' `return(F)'
end

