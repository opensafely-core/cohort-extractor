*! version 1.7.0  03dec2018
program define xtreg_be, eclass byable(onecall) prop(xtbs)
* touched by jwh -- double saves
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtreg, panel mark(I) : `0'
	if "`s(exit)'" != "" {
		exit
	}
	local vv : di "version " string(_caller()) ", missing:"
	version 6, missing
	if replay() {
		if _by() { error 190 }
		if "`e(model)'"!="be" { error 301 }
		Display `0'
		exit
	}
	`vv' `BY' Estimate  `0'
end

program Estimate, eclass sort byable(recall)
	version 6, missing
	syntax varlist(fv ts) [if] [in] [, Level(cilevel) I(varname) Wls /*
		*/ depname(string) be VCE(passthru) *]
	_get_diopts diopts, `options'
	_vce_parse, opt(CONVENTIONAL):, `vce'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")
	_xt, i(`i')
	local ivar "`r(ivar)'"
	local tvar "`r(tvar)'"

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if "`depname'" != "" {
		local depname "depname(`depname')"
	}	

	tempvar touse w T nobs XB tn
	tempname Tmax Tbar
	mark `touse' `if' `in'
	markout `touse' `varlist' `ivar'
	qui count if `touse'
	if r(N)<3 { 
		error cond(r(N)==0,2000,2001)
		/*NOTREACHED*/
	}
	preserve
	sort `ivar' `tvar' `touse'
	local depvar : word 1 of `varlist'
	if "`depname'" == "" {
		local depname "depname(`depvar')"
	}
	if `fvops' {
		fvexpand `varlist' if `touse'
		local ovlist `"`r(varlist)'"'
		fvrevar `ovlist'
		local varlist `r(varlist)'
		local fvopts findomitted buildfvinfo
	}
	else {
		local ovlist : copy local varlist
		tsrevar `varlist'
		local varlist `r(varlist)'
	}
	quietly {
		keep if `touse'
		keep `varlist' `ivar' `tvar'
		scalar `nobs' = _N
		tokenize `varlist'
		local i 1
		while "``i''"!="" {
			by `ivar': gen double `tn' = sum(``i'')/_n
			drop ``i''
			rename `tn' ``i''
			local i=`i'+1
		}
		by `ivar': gen `c(obs_t)' `T' = _N
		by `ivar': keep if _n==_N
		summ `T'
		scalar `Tbar' = r(mean)
		scalar `Tmax'  = r(max)

		local g1 = r(min)
		local g2 = r(mean)
		local g3 = r(max)

		if `Tmax'==r(min) { local Tcons 1 }
		else {
			local Tcons 0
			if "`wls'"!="" {
				local wgt "[aweight=`T']"
			}
		}
		_regress `varlist' `wgt', 
		est local cmd
		if "`wgt'" != "" {
			version 12: eret hidden local wexp "`e(wexp)'"
			version 12: eret hidden local wtype "`e(wtype)'"
		}

		tempname myb myV
		mat `myb'=e(b)
		mat `myV' = e(V)
		restore
		tempvar mysamp
		gen byte `mysamp' = `touse'
		local xvars : subinstr local ovlist "`depvar'" ""
		version 11: mat colnames `myb' = `xvars' _cons
		version 11: mat colnames `myV' = `xvars' _cons
		version 11: mat rownames `myV' = `xvars' _cons
		est post `myb' `myV' , `depname' noclear ///
			esample(`mysamp') `fvopts'
		_post_vce_rank
		
		est local estat_cmd
		est local ivar `ivar'
		global S_E_ivar "`ivar'"

		if "`wgt'"!="" {
			* global S_E_typ "WLS "
			est local typ "WLS "
		}

		est scalar N_g = e(N)
		est scalar N = `nobs'
		est scalar Tbar = `Tbar'
		est scalar Tcon = `Tcons'
		est scalar r2_b = e(r2)
		* est scalar df_m = e(df_m)
		* est scalar df_r = e(df_r)
		* est scalar df_F = e(df_F)
		* est scalar rmse = e(rmse)
		
		scalar S_E_nobs = e(N)
		scalar S_E_n = e(N_g)
		scalar S_E_Tbar = e(Tbar)
		global S_E_Tcon  `e(Tcon)'
		scalar S_E_r2b = e(r2_b)
		global S_E_mdf = e(df_m)
		global S_E_tdf = e(df_r)
		scalar S_E_f   = e(F)
		scalar S_E_rmse = e(rmse)

		_predict double `XB' if `touse', xb
		corr `XB' `depvar'
		est scalar r2_o = r(rho)^2
		scalar S_E_r2o = e(r2_o)
		est local depvar `depvar'

		tsrevar `depvar'
		local depvar `r(varlist)'
		sort `ivar' `touse'
		by `ivar' `touse': gen double `T'=/*
			*/ sum(`XB')/_N if `touse'
		by `ivar' `touse': replace `XB'=`XB'-`T'[_N] if `touse'
		drop `T'
		by `ivar' `touse': gen double `T'= /*
			*/ sum(`depvar')/_N if `touse'
		by `ivar' `touse': replace `T' = /*
			*/ `depvar'-`T'[_N] if `touse'
		corr `XB' `T'
		est scalar r2_w = r(rho)^2
		scalar S_E_r2w = e(r2_w)

		est scalar g_min = `g1'
		est scalar g_avg = `g2'
		est scalar g_max = `g3'

		est local vce     "`vce'"

		est local ivar	  `ivar'
		est local model   be
		est local marginstok XB default
		est local marginsnotok E U UE SCore STDP XBU
		est hidden local marginsprop nolinearize
		est local predict xtrefe_p
		est local cmd     xtreg
		local title "Between regression"
		local title "`title' (regression on group means)"
		est local title `title'
		
		global S_E_cmd2 "xtreg_be"
		global S_E_cmd "xtreg"
	}
	gettoken lhs xnames : ovlist
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

	Display, level(`level') `diopts'
end

program Display, eclass
	syntax [, depname(string) *]
	_get_diopts diopts, `options'
	if "`depname'" != "" {
		est local depvar `"`depname'"'
	}	

        #delimit ;
        di _n in gr "Between regression (regression on group means)"
                _col(49) in gr "Number of obs" _col(67) "="
                _col(69) in ye %10.0fc e(N) ;
        di in gr "Group variable: " in ye abbrev("`e(ivar)'",12) in gr
		_col(49) "Number of groups" _col(67) "="
                _col(69) in ye %10.0fc e(N_g) _n ;
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

	if !missing(e(chi2)) { ;
                est scalar p = chi2tail(e(df_m),e(chi2)) ;
        } ;
        else { ;
                est scalar p = fprob(e(df_m),e(df_r),e(F)) ;
        } ;


	if !missing(e(chi2)) { ;
       		di in gr _col(49) "Wald chi(" in ye e(df_m) 
       	        	in gr ")" _col(67) "=" _col(70) in ye %9.2f e(chi2) ;
       		di in gr "sd(u_i + avg(e_i.))" _col(16) "= " in ye %9.0g e(rmse)
       	        	in gr _col(49) "Prob > chi2" _col(67) "="
       	        	_col(73) in ye %6.4f chi2tail(e(df_m),e(chi2)) _n ;
	} ;
	else { ;
		di in gr _col(49) "F(" in ye e(df_m) in gr "," in ye e(df_r)
			in gr ")" _col(67) "=" _col(70) in ye %9.2f e(F) ;
		di in gr "sd(u_i + avg(e_i.))" _col(16) "= " in ye %9.0g e(rmse)
			in gr _col(49) "Prob > F" _col(67) "="
			_col(73) in ye %6.4f fprob(e(df_m),e(df_r),e(F)) _n ;
	} ;
        #delimit cr

	/* save p-value */
	if !missing(e(chi2)) { 
                est scalar p = chi2tail(e(df_m),e(chi2)) 
        } 
        else { 
                est scalar p = fprob(e(df_m),e(df_r),e(F)) 
        } 

	/*regress , noheader level(`level') */
	_coef_table, `diopts'
end

exit
