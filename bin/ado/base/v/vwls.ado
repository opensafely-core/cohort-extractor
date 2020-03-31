*! version 1.5.1  09feb2015
program define vwls, eclass byable(recall) sort
	local vv : display "version " string(_caller()) ", missing:"
	version 6, missing
	local options ""

	if replay() {
		if "`e(cmd)'"!="vwls" {
			error 301
		}
		if _by() {
			error 190
		}
		Display `0'
		exit
	}

	local cmdline : copy local 0
	syntax varlist(min=2 fv numeric) [if] [in] [fw] /*
	*/ [, Level(cilevel) SD(varname numeric) noCONstant *]
	if "`s(fvops)'" == "true" & _caller() < 11 {
		local vv "version 11:"
	}

	if "`sd'"!="" & "`weight'"!="" {
		di in red "weights not allowed with sd() option"
		error 101
	}

	_get_diopts diopts, `options'
	marksample doit
	markout `doit' `sd'

	tokenize `varlist'
	args y
	local yname `y'
	macro shift

	tempname b df nn nobs Q V
	tempvar ngroup order ybar w z newdoit
	quietly {
		if "`sd'"!="" {  /* we are given std dev for each y */
			capture assert `sd' > 0 if `doit'
			if _rc {
				di in red "zero or negative sd() not allowed"
				exit 499
			}
			/* compute weight = 1/(std err of y)^2 */
			gen double `w' = 1/(`sd'^2)

			gen byte `newdoit' = `doit'
		}
		else {  /* we have grouped data */
			unopvarlist `*'
			local unopvl `"`r(varlist)'"'
			if "`exp'"!="" {
				gen double `w'`exp' if `doit'
			}
			else gen double `w' = 1	if `doit'

			gen `c(obs_t)' `order' = _n
			sort `doit' `unopvl'

			/* compute std dev and ybar */

			by `doit' `unopvl': gen double `ngroup' = sum(`w') /*
			*/ if `doit'

			by `doit' `unopvl': gen double `ybar' = /*
			*/ sum(`w'*`y'/`ngroup'[_N]) if `doit'

			by `doit' `unopvl': replace `w' = /*
			*/ sum(`w'*(`y' - `ybar'[_N])^2) if `doit'

			by `doit' `unopvl': gen byte `newdoit' = /*
			*/ (`doit' & _n==_N & `w'>0 & `ngroup'>1)

			/* compute weight = (std err of ybar)^-2 */

			replace `w' = `ngroup'*(`ngroup' - 1)/`w' /*
			*/ if `newdoit'

			replace `ngroup' = sum(`newdoit'*`ngroup')
			scalar `nn' = `ngroup'[_N]
			local y "`ybar'"

			sort `order' /* restore sort order */
		}
		/* compute least-squares */
		count if `newdoit'
		local nobs = r(N)
		if `nobs'== 0 {
			if "`sd'"!="" {
				noi error 2000
			}
			else {
				di in red /*
		*/ "no groups with sufficient observations"
				exit 2000
			}
		}
		if `nobs'== 1 {
			if "`sd'"!="" {
				noi error 2001
			}
			else {
				di in red /*
		*/ "only one group with sufficient observations"
				exit 2001
			}
		}
		`vv' ///
		_regress `y' `*' [iw=`w'] if `newdoit', /*
		*/ mse1 `constan'
		matrix `b' = e(b)
		matrix `V' = e(V)
		scalar `df' = `nobs' - rowsof(`V') + diag0cnt(`V')
		estimates post `b' `V' [`weight'`exp'], ///
			depname(`yname') esample(`doit') buildfvinfo
		local xnames "`*'"
		fvexpand `xnames' if `newdoit'
		local xnames `r(varlist)'
		local coln : colnames e(b)
                local i 1
                foreach var of local coln {
                        local xname : word `i' of `xnames'
                        _ms_parse_parts `var'
                        if `r(omit)' {
                                _ms_parse_parts `xname'
                                if !`r(omit)' {
                                        noi di as txt "note: `xname' omitted" /*
                                                */ " because of collinearity"
                                }
                        }
                        local ++i
                }

		/* compute goodness-of-fit test */
		if `df' > 0 {
			_predict `z' if `newdoit'
			replace `z' = `y' - `z' if `newdoit'
			matrix accum `Q' = `z' [iw=`w'] /*
			*/ if `newdoit', noconstant
			est scalar chi2_gf = `Q'[1,1]
		}
		else	est scalar chi2_gf = .

		/* compute test of indepvars = 0 */
		test [#1]
		est scalar df_m = r(df)
		est scalar chi2 = r(chi2)

		/* save general stuff */
		est scalar df_gf = `df'

		if "`sd'"!="" {
			est scalar N = `nobs'
		}
		else    est scalar N = `nn'

		if "`weight'" != "" {
			est local wtype "`weight'"
			est local wexp "`exp'"
		}

		if _caller() >= 10 {
			est local predict "vwls_p"
		}
		est local depvar "`yname'"
		version 10: ereturn local cmdline `"vwls `cmdline'"'
		est local cmd "vwls"
		_post_vce_rank

		/* double saves */
		global S_E_gfc2 = e(chi2_gf)
		global S_E_mdf  = e(df_m)
		global S_E_chi2 = e(chi2)
		global S_E_gfdf = e(df_gf)
		global S_E_nobs = e(N)
		global S_E_depv `e(depvar)'
		global S_E_cmd  `e(cmd)'
	}

	Display, level(`level') `diopts'
end

program define Display
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	tempname pgf pm
	if e(df_gf) > 0 {
		scalar `pgf' = chiprob(e(df_gf), e(chi2_gf))
	}
	else scalar `pgf' = .
	scalar `pm' = chiprob(e(df_m), e(chi2))
	#delimit ;
	di _n in gr "Variance-weighted least-squares regression" _col(49)
		"Number of obs" _col(67) "= " in ye %10.0fc e(N) _n
		in gr "Goodness-of-fit chi2(" in ye  e(df_gf)
		in gr ")" _col(28) "= "
		in ye %7.2f e(chi2_gf) _col(49)
		in gr "Model chi2(" in ye e(df_m) in gr ")" _col(67) "= "
		in ye %10.2f e(chi2) _n
		in gr "Prob > chi2" _col(28) "= " in ye %7.4f `pgf' _col(49)
		in gr "Prob > chi2" _col(67) "= " in ye %10.4f `pm' ;
	#delimit cr
	_coef_table, level(`level') `diopts'
end
