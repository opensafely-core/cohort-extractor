*! version 1.2.0  21jun2018
program xtstreg, eclass byable(onecall) prop(xtbs)
	version 14

	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	
	`by' _vce_parserun xtstreg, panel : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"xtstreg `0'"'
		exit
	}

	if replay() {
		if _by() {
			error 190
		}	
		syntax [, Distribution(string) *]
		if "`distribution'"=="" {
			if "`e(cmd)'" != "xtstreg" & "`e(cmd2)'" != "xtstreg" {
				error 301
			}
			_me_display `0'
			exit
		}
	}
	`vv' `by' Estimate `0'
end

program Estimate, eclass sortpreserve byable(recall)
	
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	
	syntax [varlist(ts fv default=none)] [if] [in] [fw pw iw] ,	///
		Distribution(passthru) /*documented abbrev. -dist- */ 	///
		[ TIme /*documented abbrev. -time- */ OFFset(varname) 	///
		noCONstant INTMethod(string) INTPoints(integer 12) 	///
		vce(passthru) I(string) from(passthru) noSKIP/*undoc*/	///
	 	LRMODEL noDISplay noSHow noHR TRatio *]
	
	local 0_orig `0'

	capture xtset
	if _rc xtset
	else local ivar `r(panelvar)'

	st_is 2 analysis
	local xvars `varlist'
	local st_wt : char _dta[st_wt]

	marksample touse
	if "`offset'" != "" markout `touse' `offset'

	if "`weight'" != "" {
		tempvar wgt
		local mywgt `weight'
		local myexp `"`exp'"'
		capture gen double `wgt' `exp'
		if _rc {
			di "{err}invalid `weight'"
			exit 198
		}
		capture by `touse' `ivar', sort: ///
			assert `wgt'==`wgt'[_n-1] if _n>1 & `touse'
		if _rc {
			di as err "weights not constant within groups "	///
				"defined by `ivar'"
			exit 198		
		}		
		local wopt `weight'(`wgt')
	}
	else local wopt

	if !missing("`st_wt'") & missing("`wopt'") {
		di "{err}{bf:stset} weights not allowed"
		exit 459
	}

	_get_diopts diopts opts, `options'
	mlopts mlopts rest, `options'
	local cns `s(constraints)'
	
	local 0 , `intmethod'
	capture syntax [, GHermite MVaghermite]
	if _rc {
	    di "{err}intmethod() invalid -- {inp}`intmethod' {err}not allowed"
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

	if "`offset'" != "" local offopt offset(`offset')
	local fe_opt `constant' `offopt'

	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constant' constr(`cns') ///
			options(`clust' `robus') indep(`xvars')
		local skip "noskip"
	}
	else if  missing("`xvars'") {
		local skip
	}
	if "`skip'" != "" {
		if "`clust'`robus'" != "" {
			di "{err}robust vce not allowed with {bf:noskip} option"
			exit 198
		}
		tempname model_0
		di
		di "{txt}Fitting constant-only model:"
		qui mestreg _t if `touse', `fe_opt' || `ivar':, `wopt' ///
			`distribution' `time' xtcmd intm(`intm') 	///
			intp(`intpoints')
		est store `model_0'
		local ll_0 = `e(ll)'
		local rank0 = `e(rank)'
		local chi2type "LR"
	}
	else local chi2type "Wald"

	local m_eq _t `xvars' if `touse', `fe_opt' || `ivar':, `wopt' ///
		`distribution' `time'
	local opts `opts' intm(`intm') intp(`intpoints') `vce' `from'	///
		`hr' `tratio'

	st_show `show'

	`by' mestreg `m_eq' `opts' notab nohead nolr xtcmd noshow

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
	
	ereturn scalar sigma_u = sqrt(_b[/sigma2_u])
	
	local n_quad = `e(n_quad)'
	ereturn local n_quad
	ereturn scalar n_quad = `n_quad'
	ereturn hidden local diparm_opt`e(k_eq)' `"noprob ci(log)"'
	
	if "`skip'" != "" {
		qui lrtest `model_0' .
		ereturn scalar ll_0 = `ll_0'
		ereturn scalar rank0 = `rank0'
		ereturn scalar p = `r(p)'
		ereturn scalar chi2 = `r(chi2)'
	}

	if "`e(frm2)'" == "hazard" {
		local metric "PH"
	}
	else if "`e(frm2)'" == "time" {
		local metric "AFT"
	}

	ereturn local ivar "`ivar'"
	ereturn local title "Random-effects `e(model)' `metric' regression"
	ereturn local cmdline xt`model' `0_orig'
	ereturn local cmd "gsem"
	ereturn local cmd2 "xtstreg"
	ereturn local predict "xtstreg_p"
	ereturn local estat_cmd
	ereturn local chi2type `chi2type'
	ereturn local marginsnotok stdp
	ereturn local marginsok "xb mean mean0 median0 hazard surv"
	if _caller() > 14 ereturn local marginsdefault predict(mean)
	if `"`myexp'"' != `""' {
		gettoken EQUAL WEXP : myexp
		ereturn hidden local `mywgt'1 `"`WEXP'"'
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
	ereturn hidden local ivars `e(ivars)'
	ereturn hidden local footnote `e(footnote)'
	ereturn hidden local method `e(method)'
	ereturn hidden local datasignaturevars `e(datasignaturevars)'
	ereturn hidden local datasignature `e(datasignature)'

	_me_display, `level' `or' `diopts' `display' `hr' `tratio'
	
	if !missing("`st_wt'") & !missing("`wopt'") {
		di "{txt}Note: {bf:stset} weights ignored."
	}
end

exit
