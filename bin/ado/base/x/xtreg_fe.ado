*! version 2.1.0  03dec2018
program define xtreg_fe, byable(onecall) prop(xtbs)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtreg, panel mark(I CLuster) : `0'
	if "`s(exit)'" != "" {
		exit
	}
	if _caller() < 14 {
		`BY' xtreg_fe_13 `0'
		exit
	}
	local vv : display "version " string(_caller()) ":"
	version 14
	if replay() {
		if _by() {
			error 190
		}
		if `"`e(cmd)',`e(model)'"' != "xtreg,fe" {
			error 301
		}
		Display `0'
		exit
	}
	`vv' `BY' Estimate `0'
end

program Estimate, eclass sort byable(recall)
	local vv : display "version " string(_caller()) ":"
	version 14
	syntax varlist(fv ts) [if] [in] [aw fw pw] [,	///
		FE					/// ignored/assumed
		NONEST					/// ignored
		DFADJ	 				/// ignored 
		Robust					/// old syntax
		Cluster(passthru)			/// old syntax
		I(varname)				/// old syntax
		VCE(passthru)				///
		*					/// display options
	]

	xt_iis `i'
	local ivar "`s(ivar)'"

	_vce_parse,	argopt(CLuster)			///
			opt(CONVENTIONAL Robust)	///
			old				///
			: [`weight'`exp']		///
			, `vce' `robust' `cluster'
	if !inlist("`r(cluster)'", "", "`ivar'") | "`nonest'`dfadj'" != "" {
		// -nonest- and -dfadj- are NOT DOCUMENTED passthru
		// options for use when -cluster()- or
		// -vce(cluster ...)- are specified; only allowed by an
		// older/slower implementation.
		`vv' xtreg_fe_13 `0'
		exit
	}
	if "`r(cluster)'" != "" {
		local clopt	cluster(`r(cluster)')
		local cluster	"`r(cluster)'"
	}
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")

	_get_diopts diopts, `options'

	gettoken y xvars : varlist
	_fv_check_depvar `y'

	tempvar touse XB U Ti ehold r2c r2

	mark `touse' [`weight'`exp'] `if' `in'

	capture tsset, noquery
	if _rc == 0 {
		local ivar `r(panelvar)'
		local tvar `r(timevar)'
	}

	markout `touse' `ivar' `tvar' `varlist'

	if "`vce'" == "robust" {
		local clopt	cluster(`ivar')
		local cluster	"`ivar'"
		local vce	cluster
	}

	quietly count if `touse'
	if r(N) <= 1 {
		error 2001
	}
	if "`weight'" != "" {
		sort `ivar' `touse'
		local BY `"quietly by `ivar' `touse' :"'
		tempvar usrwgt
		quietly gen double `usrwgt' `exp'
		capture `BY' assert `usrwgt' == `usrwgt'[_N] if `touse'
		if _rc {
			di as err "weight must be constant within `ivar'"
			exit 199
		}
	}

	sort `ivar' `tvar'
	local BY `"quietly by `ivar' :"'
	`BY' gen long `Ti' = sum(`touse')
	`BY' replace `Ti' = cond(_n==_N,`Ti',.)
	quietly replace `Ti' = . if `Ti' == 0

	_regress `varlist'		///
		[`weight'`exp']		///
		if `touse'		///
		,			///
		noheader		///
		notable			///
		`clopt'			///
		fe			///
		absorb(`ivar')
	local dfb = e(df_m)
	if "`clopt'" == "" {
		ereturn scalar df_b = `dfb'
		ereturn scalar df_m = e(df_a) + `dfb'
	}
	else {
		_prefix_model_test
		ereturn scalar df_b = e(df_m)
		ereturn scalar df_m = `dfb'
	}

	local XVARS : colna e(b)
	local UCONS _cons
	local XVARS : list XVARS - UCONS

	_est hold `ehold'
	local hold = "`c(buildfvinfo)'"
	set buildfvinfo off
	quietly _regress `y' `XVARS' [`weight'`exp'] if `touse'
	local df_r = e(df_r)
	scalar `r2c' = e(r2)
	set buildfvinfo `hold'
	_est unhold `ehold'

	ereturn scalar r2_w = e(r2)

	ereturn hidden local absvar "`ivar'"
	ereturn local ivar "`ivar'"

	scalar `r2' = 1 - e(rss)/e(tss)
	if "`clopt'" == "" {
		ereturn scalar F_f =	///
			((`r2'-`r2c')/e(df_a)) / ((1-`r2')/e(df_r))
	}
	_post_vce_rank

	summ `Ti', meanonly
	ereturn scalar Tbar	= r(mean)
	ereturn scalar Tcon	= (r(min)==r(max))
	ereturn scalar g_min	= r(min)
	ereturn scalar g_avg	= r(mean)
	ereturn scalar g_max	= r(max)

	quietly count if `Ti'<.
	ereturn scalar N_g = r(N)
	local df_a = e(N_g) - 1

	`BY' replace `Ti' = `Ti'[_N]
	quietly _predict double `XB' if `touse', xb
	quietly gen double `U' = `y' - `XB'
	`BY' replace `U' = cond(_n==_N,sum(`U')/`Ti',.)
	quietly summ `U'
	ereturn hidden scalar ui = sqrt(r(Var))
	ereturn scalar sigma_u = sqrt(r(Var))
	`BY' replace `U' = `U'[_N]
	quietly corr `XB' `U'
	ereturn scalar corr = r(rho)

	quietly corr `y' `XB' if `touse'
	ereturn scalar r2_o = r(rho)^2

	`BY' replace `XB' = cond(_n==_N,sum(`XB')/`Ti',.)
	quietly replace `U' = cond(`touse', `y', .)
	`BY' replace `U' = cond(_n==_N,sum(`U')/`Ti',.)
	// handle one group
	quietly count if `U'<. & `XB'<.
	if r(N) == 0 {
		error 2000
	}
	else if r(N) == 1 {
		ereturn scalar r2_b = .
	}
	else {
		quietly corr `U' `XB'
		ereturn scalar r2_b = r(rho)^2
	}

	if "`clopt'" != "" {
		local dfe = `df_r' - `df_a'
		ereturn scalar sigma_e	= sqrt(e(rss)/`dfe')
	}
	else {
		ereturn scalar sigma_e	= sqrt(e(rss)/e(df_r))
	}
	ereturn scalar sigma	= sqrt(e(sigma_u)^2 + e(sigma_e)^2)
	ereturn scalar rho	= e(sigma_u)^2 / e(sigma)^2

	ereturn local vce `"`vce'"'
	ereturn local model fe
	ereturn local predict xtrefe_p
	ereturn local marginsnotok E U UE SCore STDP XBU
	ereturn hidden local marginsprop nolinearize
	ereturn local estat_cmd
	ereturn local cmd xtreg

	// Double save

	scalar S_E_sse	= e(rss)
	global S_E_mdf	= e(df_m)
	global S_E_tdf	= e(df_r)
	scalar S_E_sst	= e(tss)
	scalar S_E_nobs	= e(N)
	global S_E_dfb	= `dfb'
	scalar S_E_r2w	= e(r2_w)
	global S_E_ivar	= "`ivar'"
	global S_E_dfa	= e(df_a)
	global S_E_f	= e(F)
	scalar S_E_f2	= e(F_f)
	scalar S_E_T	= e(g_max)
	scalar S_E_Tbar	= e(Tbar)
	global S_E_Tcon	= e(Tcon)
	scalar S_E_n	= e(N_g)
	scalar S_E_ui	= e(sigma_u)
	scalar S_E_rho	= e(corr)
	scalar S_E_r2o	= e(r2_o)
	scalar S_E_r2b	= e(r2_b)
	global S_E_vl	= `"`xvars'"'
	global S_E_if	= `"`if'"'
	global S_E_depv	= `"`y'"'
	global S_E_cmd2	= "xtreg_fe"
	global S_E_cmd	= "xtreg"

	/* save p values */
	if !missing(e(chi2)) {
                ereturn scalar p = chi2tail(e(df_b),e(chi2))
        }
        else {
		ereturn scalar p = Ftail(e(df_b),e(df_r),e(F))
	}

	if "`e(vcetype)'" != "Robust" & "`e(prefix)'" != "bootstrap" {
		ereturn scalar p_f = fprob(e(df_a),e(df_r),e(F_f))
	}

	Display, `diopts'
end

program Display
	syntax [, *]
	_get_diopts diopts, `options'
	local cfmt `"`s(cformat)'"'

	if e(Tcon) {
		local Twrd "    T"
	}
	else	local Twrd "T-bar"

	if !missing(e(chi2)) {
		local p = chi2tail(e(df_b),e(chi2))
	}
	else	local p = Ftail(e(df_b),e(df_r),e(F))

	#delimit ;
        di _n as txt "Fixed-effects (within) regression"
                _col(49) as txt "Number of obs" _col(67) "="
                _col(69) as res %10.0fc e(N) ;
        di as txt "Group variable: " as res abbrev("`e(ivar)'",12) as txt
		_col(49) "Number of groups" _col(67) "="
                _col(69) as res %10.0fc e(N_g) _n ;
	di as txt "R-sq:" _col(49) as txt "Obs per group:" ;
	di as txt "     within  = " as res %6.4f e(r2_w)
		_col(63) as txt "min" _col(67) "="
		_col(69) as res %10.0fc e(g_min) ;
	di as txt "     between = " as res %6.4f e(r2_b)
		_col(63) as txt "avg" _col(67) "="
		_col(69) as res %10.1fc e(g_avg) ;
	di as txt "     overall = " as res %6.4f e(r2_o)
		_col(63) as txt "max" _col(67) "="
		_col(69) as res %10.0fc e(g_max) _n ;

	if !missing(e(chi2)) | "`e(df_r)'" == "" { ;
		di as txt _col(49) "Wald chi2(" as res e(df_b)
			as txt ")" _col(67) "=" _col(70) as res %9.2f e(chi2) ;
		di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
			as txt _col(49) "Prob > chi2" _col(67) "="
			_col(73) as res %6.4f `p' _n ;
	} ;
	else { ;
		if e(F) < . { ;
			di as txt _col(49) "F(" as res e(df_b) as txt ","
			as res e(df_r) as txt ")" _col(67) "=" _col(70)
			as res %9.2f e(F) ;
		} ;
		else { ;
			di _col(49)
			"{help j_robustsingular##|_new:F(`e(df_b)',`e(df_r)')}"
			_col(67) as txt "=" _col(70) as res %9.2f e(F) ;
		} ;
		di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
			as txt _col(49) "Prob > F" _col(67) "="
			_col(73) as res %6.4f `p' _n ;
	} ;
	#delimit cr

	_coef_table , plus `diopts'

	if c(noisily)==0 {
		exit
	}
	
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	if "`c1'"=="" {
		local c1 13
	}
	else {
		local c1 = int(`c1')
	}
	if "`w'"=="" {
		local w 78
	}
	else {
		local w = int(`w')
	}

	local c = `c1' - 1
	local rest = `w' - `c1' - 1
	if `"`cfmt'"' != "" {
		local rho	: display `cfmt' e(rho)
		local sigma_u	: display `cfmt' e(sigma_u)
		local sigma_e	: display `cfmt' e(sigma_u)
	}
	else {
		local rho	: display %10.0g e(rho)
		local sigma_u	: display %10.0g e(sigma_u)
		local sigma_e	: display %10.0g e(sigma_e)
	}
	di as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
	di as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
	di as txt %`c's "rho" " {c |} " as res %10s "`rho'" ////
		as txt "   (fraction of variance due to u_i)"
	di as txt "{hline `c1'}{c BT}{hline `rest'}"

	local p_f = -1
	if "`e(vcetype)'" != "Robust" & "`e(prefix)'" != "bootstrap" {
		local ff : di %8.2f e(F_f)
		local ff = trim("`ff'")
		#delimit ;
		di as txt "F test that all u_i=0: "
		"F(" as res e(df_a) as txt ", " as res e(df_r) as txt ") = "
			as res %8.2f "`ff'" _col(62) as txt "Prob > F = "
			as res %6.4f fprob(e(df_a),e(df_r),e(F_f)) ;
		#delimit cr
	}
end
