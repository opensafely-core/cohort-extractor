*! version 1.2.1  15oct2019
program _xtordinal, eclass sortpreserve byable(recall)
	version 13
	
	gettoken model 0 : 0
	
	syntax varlist(ts fv) [if] [in] [fw pw iw] , [ OFFset(varname) 	///
		noCONstant vce(passthru) INTMethod(string)		///
		noSKIP/*undoc*/	LRMODEL ///
		INTPoints(integer 12) OR NOLOg LOg noDISplay I(string) *]
	
	local 0_orig `0'
	
	if "`model'"=="oprobit" & "`or'"!="" {
		di as err "option {bf:or} not allowed"
		exit 198
	}
	
	_get_diopts diopts opts, `options'
	mlopts mlopts rest, `opts'
	local constr `s(constraints)'
	
	capture xtset
	if _rc xtset
	else local ivar `r(panelvar)'
	
	local vars `varlist'
	gettoken y xvars : varlist
	_fv_check_depvar `y'
	
	if "`constant'"!="" {
		di as err "option {bf:`constant'} not allowed"
		exit 198
	}

	marksample touse
	if "`offset'" != "" markout `touse' `offset'

	if "`weight'" != "" {
		tempvar wgt
		local mywgt `weight'
		local myexp `"`exp'"'
		capture gen double `wgt' `exp'
		if _rc {
			di as err "invalid `weight'"
			exit 198
		}
		capture by `touse' `ivar',sort: ///
			assert `wgt'==`wgt'[_n-1] if _n>1 & `touse'
		if _rc {
			di as err "weights not constant within groups "	///
				"defined by {bf:`ivar'}"
			exit 198		
		}		
		local wopt , `weight'(`wgt')
	}
	else local wopt

	local 0 , `intmethod'
	capture syntax [, GHermite MVaghermite]
	if _rc {
	    di as err "option {bf:intmethod()} invalid; {bf:`intmethod'} not allowed"
	    exit 198
	}
	local intm `ghermite'`mvaghermite'
	
	_vce_parse, opt(OIM Robust) argopt(Cluster) : , `vce'
	local clust `r(cluster)'
	local robus `r(robust)'
	if "`clust'`robus'" != "" {
		if "`clust'"=="" local clust `ivar'
		else _xtreg_chk_cl2 `clust' `ivar' `touse'
	}
	
	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constant' constr(`constr') ///
			options(`clust' `robus') indep(`xvars')
		local skip noskip
	}
	if "`skip'" != "" {
		if "`clust'`robus'" != "" {
			di as err ///
			"robust vce not allowed with option {bf:noskip}"
			exit 198
		}
		tempname model_0
		di
		di "{txt}Fitting constant-only model:"
		qui me`model' (`y' if `touse', off(`offset')) ///
			(`ivar':`wopt'), xtcmd
		est store `model_0'
		local ll_0 = `e(ll)'
		local rank0 = `e(rank)'
		local chi2type "LR"
	}
	else local chi2type "Wald"
	
	local m_eq (`vars' if `touse', off(`offset')) (`ivar':`wopt')
	local opts `opts' intm(`intm') intp(`intpoints') `vce'
	
	`by' me`model' `m_eq', `opts' notab nohead nolr `log' `nolog' xtcmd
	
	// massage ereturn list
	
	tempname tmp
	mat `tmp' = e(N_g)
	ereturn scalar N_g = `tmp'[1,1]
	mat `tmp' = e(g_min)
	ereturn scalar g_min = `tmp'[1,1]
	mat `tmp' = e(g_avg)
	ereturn scalar g_avg = `tmp'[1,1]
	mat `tmp' = e(g_max)
	ereturn scalar g_max = `tmp'[1,1]
	
	if "`clust'" != "" {
		if "`clust'" !=" `ivar'" {
			tempname T
			qui sort `touse' `clust'
			qui by `touse' `clust': gen `c(obs_t)' `T' = _N if `touse'
			qui summarize `T' if `touse' & `clust'!=`clust'[_n-1]
			ereturn scalar N_clust = r(N)
			ereturn local clustvar "`clust'"
		}
	}
	
	ereturn scalar sigma_u = sqrt(_b[sigma2_u:_cons])
	
	local n_quad = `e(n_quad)'
	ereturn local n_quad
	ereturn scalar n_quad = `n_quad'
	ereturn scalar k_aux = `e(k_cat)'
	ereturn hidden local diparm_opt`e(k_eq)' `"noprob ci(log)"'
	
	if "`skip'" != "" {
		qui lrtest `model_0' .
		ereturn scalar ll_0 = `ll_0'
		ereturn scalar rank0 = `rank0'
		ereturn scalar p = `r(p)'
		ereturn scalar chi2 = `r(chi2)'
	}
	
	if "`model'"=="oprobit" local m probit
	if "`model'"=="ologit" local m logistic
	
	ereturn local ivar "`ivar'"
	ereturn local distrib "Gaussian"
	ereturn local title "Random-effects ordered `m' regression"
	ereturn local cmdline xt`model' `0_orig'
	ereturn local cmd "meglm"
	ereturn local cmd2 "xt`model'"
	ereturn local predict "xt`model'_p"
	ereturn local estat_cmd
	ereturn local chi2type `chi2type'
	ereturn local marginsnotok
	ereturn local marginsok "xb pr pu0"
	if _caller() <= 14 ereturn local marginsdefault
	
	if `"`myexp'"' != `""' {
		gettoken EQUAL WEXP : myexp
		ereturn hidden local `mywgt'1 `"`:list retok WEXP'"'
		ereturn local marginswexp `"`myexp'"'
		ereturn hidden local wexp_robust `"`myexp'"'
	}

	ereturn local offset `e(offset1)'
	ereturn hidden local offset1 `e(offset1)'
	
	capture ereturn hidden scalar k_autoCns = e(k_autoCns)
	capture ereturn hidden scalar k_f = e(k_f)
	capture ereturn hidden scalar k_r = e(k_r)
	capture ereturn hidden scalar k_rc = e(k_rc)
	capture ereturn hidden scalar k_rs = e(k_rs)
	capture ereturn hidden scalar rank_c = e(rank_c)
	capture ereturn hidden scalar p_c = e(p_c)
	capture ereturn hidden scalar df_c = e(df_c)
	ereturn hidden local link `e(link)'
	ereturn hidden local family `e(family)'
	ereturn hidden local ivars `e(ivars)'
	ereturn hidden local model `e(model)'
	ereturn hidden local footnote `e(footnote)'
	ereturn hidden local method `e(method)'
	ereturn hidden local datasignaturevars `e(datasignaturevars)'
	ereturn hidden local datasignature `e(datasignature)'
	
	_xtordinal_display, `level' `or' `diopts' `display'

end
exit

