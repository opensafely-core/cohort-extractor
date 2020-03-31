*! version 1.9.0  25sep2018
program define xtivreg, eclass sortpreserve byable(onecall) prop(xt xtbs)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtivreg, panel unparfirsteq ///
		equal unequalfirsteq noeqlist mark(I) jkopts(eclass): `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtivreg `0'"'
		exit
	}

	version 7.0, missing
	if replay() {
		if `"`e(cmd)'"' != "xtivreg"  { error 301 }
		if _by() { error 190 }
	
		syntax , [level(cilevel) *]

		_get_diopts diopts, `options'
		if "`e(model)'" == "fd" {
			DispFD , level(`level') `diopts'
		}
		else if "`e(model)'" == "fe" {
			DispFE , level(`level') `diopts'
		}	
		else if "`e(model)'" == "g2sls" | "`e(model)'" == "ec2sls" {
			if "`e(model)'" == "ec2sls" {
				local ec2sls "ec2sls"
			}	
			DispRE , level(`level') `ec2sls' `diopts'
		}	
		else if "`e(model)'" == "be" {
			DispBE , level(`level') `diopts'
		}	
		else {
			di as err "unknown model of xtivreg"
			error(198)
		}	
		DispI
		exit	
	}

	local vv : display "version " string(_caller()) ", missing:"
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"xtivreg `0'"'
end

program Estimate, eclass byable(recall)
	version 7.0, missing
	local n 0
	gettoken lhs 0 : 0, parse(" ,[") match(paren)
	IsStop `lhs'
	if `s(stop)' { error 198 }
	while `s(stop)'==0 { 
		if "`paren'"=="(" {
			local n = `n' + 1
			if `n'>1 { 
capture noi error 198 
di as err `"syntax is "(all instrumented variables = instrument variables)""'
exit 198
			}
			gettoken p lhs : lhs, parse(" =")
			while "`p'"!="=" {
				if "`p'"=="" {
capture noi error 198 
di as err `"syntax is "(all instrumented variables = instrument variables)""'
di as err `"the equal sign "=" is required"'
exit 198 
				}
				local end`n' `end`n'' `p'
				gettoken p lhs : lhs, parse(" =")
			}
			fvunab end`n' : `end`n''
			fvunab exog`n' : `lhs'
		}
		else {
			local exog `exog' `lhs'
		}
		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		IsStop `lhs'
	}
	local 0 `"`lhs' `0'"'

	fvunab exog : `exog'
	tokenize `exog'
	local lhs "`1'"
	local 1 " " 
	local exog `*'

	syntax [if] [in] [, FIRST noSA I(varname) /*
		*/ RE FE FD BE 	REGress THeta noConstant /* 
		*/ EC2sls SMall LM Level(cilevel) vce(string) *]

	_get_diopts diopts, `options'
	

	if "`fd'" != "" {
		_xt, i(`i') trequired
	}
	else {
		_xt, i(`i')
	}
	
	local id "`r(ivar)'"
	local t  "`r(tvar)'"
	
	////////////////////// Parsing vce options ////////////////////
	
	marksample touse
	
	local nvce: list sizeof vce
	local siclust = 0
	tempvar cuentas1


	if ("`vce'"=="conventional") {
		local nvce = 0
	}
	
	local wordone: word 1 of `vce'
	VceType, `wordone'
	
	
	if (`nvce' == 0) {
		local var = 1
		local clust = ""
		local tvce conventional
	}
	
	if (`nvce' == 1) {
		cap qui Variance , `vce'
		
		if _rc!=0 { 		
			display as error "invalid {bf:vce()} option"
			exit _rc
		}
		
		local var  = r(var)
		local clust = ""
		local tvce robust
		local type Robust
		local siclust = 2
	}

	if `nvce' == 2 {		
		local cluster: word 1 of `vce'
		local clustervar: word 2 of `vce'
		Clusters `clustervar', `cluster'
		local clust = e(clustervar)
		local var = e(var)
		local tvce cluster
		local type Robust
		_xtreg_chk_cl2 `clustervar' `id'
	}

	if  ("`weight'" == "pweight") {
		local var   = 2
		local clust = ""
		local tvce robust
		local type Robust
	}
	
	if `nvce'> 1 {
		local vce2 `vce' 
		local vce cluster
		local siclust = 1
	}
	else {
		local vce2 `vce'
	}

	local thetad `theta'
	
	if "`t'" != "" {
		local targ " t(`t') "
	}
	Check4FVars `exog' `exog1'
	local sfvops = "`s(fvops)'" == "true"
        local fvops = "`s(fvops)'" == "true" | _caller() >= 11
        if `fvops' {
		_fv_check_depvar `lhs' `end1'
		if "`fd'" != "" & `sfvops' {
			di as err "factor variables not allowed with" ///
			" first-differenced model"
			exit 198
		} 
		if _caller() < 11 {
                	local vv "version 11:"
		}
		else	local vv : display "version " string(_caller()) ":"
		markout `touse' `lhs' `exog' `exog1' `end1' `id' `t'

		`vv' ///
		_rmcoll `exog' if `touse', expand
		local exog "`r(varlist)'"
		`vv' ///
		_rmcoll `exog1' if `touse', expand
		local exog1 "`r(varlist)'"
		local fvopts findomitted buildfvinfo
	}
	else {
		_rmcoll `exog' 
		local nocoll "`r(varlist)'"
		_rmcoll `exog1'
		local nocoll "`nocoll' `r(varlist)'"
	
		foreach var of local exog {
			local n 0
			local temp : subinstr local nocoll "`var'" "`var'", /* 
				*/ word count( local n) 
			if `n' == 1 {
				local exog_n "`exog_n' `var'"
			}
		}
		local exog "`exog_n'"
		
		local exog : subinstr local exog "  " " ", all
	
		foreach var of local exog1 {
			local n 0
			local temp : subinstr local nocoll "`var'" "`var'", /* 
				*/ word count( local n) 
			if `n' == 1 {
				local exog1_n "`exog1_n' `var'" 
			}
		}
		local exog1 "`exog1_n'"
	}

	marksample touse
	markout `touse' `lhs' `exog' `exog1' `end1' `id' `t'

	local dups : list exog1 & lhs
	if "`dups'" != "" {
		di as error ///
"`lhs' specified as both dependent variable and instrument"
		exit 198
	}

	qui count if `touse'
	if r(N)==0 {
		error 2000
	}	

	qui xtsum `id' if `touse'
	if r(n) == r(N) {
		di as err "the sample specifies cross-sectional data"
di as err "{help xtivreg##|_new:xtivreg} is not designed for "	/*
			*/ "cross-sectional data"
di as err "use {help ivregress##|_new:ivregress} with cross-sectional data"
		exit 498
	}	

	Subtract inst : "`exog1'" "`exog'"
	local endo_ct : word count `end1'
	local ex_ct : word count `inst'
	if `endo_ct' > `ex_ct' {
		di as err "equation not identified; must have at " /*
		*/ "least as many instruments not in"
		di as err "the regression as there are "           /*
		*/ "instrumented variables"
		exit 481
	}


	if "`re'`be'`fe'`fd'" == "" {
		local model "re"
	}
	else {
		if "`re'`be'`fe'`fd'" !=  "`re'" /* 
			*/ & "`re'`be'`fe'`fd'" !=  "`fe'" /* 
			*/ & "`re'`be'`fe'`fd'" !=  "`be'" /* 
			*/ & "`re'`be'`fe'`fd'" !=  "`fd'" { 
			di as err "only one model may be specified "
			exit 198
		}
		else {
			local model "`re'`be'`fe'`fd'" 
		}	
	}

	if "`first'" != "" & "`regress'" != "" {
		di as err /*
		*/ "options first and regress may not be specified together"
		exit 198
	}	
	
		
	if "`model'" != "fd" & "`constant'" != "" {
		di as err "option noconstant invalid in `model' model"
		exit 198
	}	

	if "`model'" != "re" & "`ec2sls'" != "" {
		di as err "option ec2sls may not be specified with `model'"
		exit 198
	}	
	
	if "`model'" != "re" & "`nosa'" != "" {
		di as err "option nosa may not be specified with `model'"
		exit 198
	}	
	
	if "`model'" != "re" & "`theta'" != "" {
		di as err "option theta may not be specified with `model'"
		exit 198
	}	

	if "`end1'" == "" {
		di as err "no endogenous variables specified"
		exit 198
	}

	if "`regress'" != "" {
		local inst "`end1'"
	}	
			
	

	local names "`end1' `exog' "

	tsrevar `lhs', substitute
	local lhs_t "`r(varlist)'"

	fvrevar `end1', substitute
	local end1_t "`r(varlist)'"

	fvrevar `exog', substitute
	local exog_t "`r(varlist)'"

	fvrevar `inst', substitute
	local inst_t "`r(varlist)'"

	local allvar " `lhs_t' `end1_t' `exog_t' `inst_t' "

	local k : word count `exog' `endog'

	local xvars " `end1_t' `exog_t' " 

	local coefs_ts "`end1_t' `exog_t'"
	local coefs "`end1' `exog'"
	
	preserve 
		qui keep if `touse'


		if "`model'" == "fe" {

			tempvar res_r res_r2 ssr_ra ssr_ura

			
			local cnt 1
			foreach var in `end1_t' {
				tempname endp`cnt' endpb`cnt' xbt uit
				
				if `siclust'==1 {
					qui _regress `var' `exog_t'         ///
						`inst_t', cluster(`clust')
					qui predict double `endp`cnt'', xb
				}
				if `siclust'==2 {
					qui _regress `var' `exog_t'         ///
						`inst_t', robust
					qui predict double `endp`cnt'', xb
				}
				if `siclust'==0 {
					qui _regress `var' `exog_t'         ///
						`inst_t'
					qui predict double `endp`cnt'', xb
				}

 				qui xtreg `var' `exog_t' `inst_t',          /// 
					fe i(`id') vce(`vce2')
				qui predict double `xbt', xb
				qui predict double `uit', u
				qui gen double `endpb`cnt''=`xbt'+`uit'
				
				local end1_tpb " `end1_tpb' `endpb`cnt'' "
				local end1_tp " `end1_tp' `endp`cnt'' "
				local cnt = `cnt' + 1
			}
		

			if "`lm'" != "" {
				if `siclust'==1 {
					qui _regress `lhs_t' `exog_t'       ///
						`end1_t'                    ///
						( `exog_t' `inst_t'),       ///
						cluster(`clust')
					qui predict double `res_r', res
					qui gen double `res_r2'=`res_r'*`res_r'
					qui sum `res_r2'
					scalar `ssr_ra'=r(sum)
				}
				if `siclust'==2 {
					qui _regress `lhs_t' `exog_t'       ///
						`end1_t'                    ///
						( `exog_t' `inst_t'),       ///
						robust
					qui predict double `res_r', res
					qui gen double `res_r2'=`res_r'*`res_r'
					qui sum `res_r2'
					scalar `ssr_ra'=r(sum)
				}
				if `siclust'==0 {
					qui _regress `lhs_t' `exog_t'       ///
						`end1_t'                    ///
						( `exog_t' `inst_t')
					qui predict double `res_r', res
					qui gen double `res_r2'=`res_r'*`res_r'
					qui sum `res_r2'
					scalar `ssr_ra'=r(sum)
				}
				
				tempname xb_lm ui_lm yhat_lm yhat_lm2 
				tempname mss_lm tss_lm res_urlm
				tempname r2_lm res_r2  mss_lm tss_lm N_lm 
			
				qui xtreg `res_r' `end1_tpb' `exog_t' ,/*
					*/ fe i(`id') vce(`vce2')
				scalar `N_lm'=e(N)

				qui predict double `res_urlm', e
				qui replace `res_urlm'=`res_urlm'*`res_urlm'
				qui sum `res_urlm'
				scalar `ssr_ura'=r(sum)

				tempname lm_u
				scalar `lm_u'=`N_lm'*( `ssr_ra'-`ssr_ura') /*
					*/ /`ssr_ra'
			}

			/* now get rss_rlm rss_ulm  for F-test */

			tempname rss_rlm rss_ulm
			
			if `siclust'==1 {
				qui _regress `lhs_t' `end1_tpb' `exog_t', ///
					cluster(`clust')
				scalar `rss_rlm'=e(rss)
			}
			if `siclust'==2 {
				qui _regress `lhs_t' `end1_tpb' `exog_t', ///
					robust
				scalar `rss_rlm'=e(rss)
			}
			if `siclust'==0 {
				qui _regress `lhs_t' `end1_tpb' `exog_t'
				scalar `rss_rlm'=e(rss)
			}
			
			qui xtreg `lhs_t' `end1_tpb' `exog_t', fe i(`id')  ///
				vce(`vce2')
			scalar `rss_ulm'=e(rss)
			
		}	
		
	
		tempvar res_w res_b i_obs i_obs2 theta 
		tempname sig_u2 sig_e2 n N K ti_min ti_max ti_ave Tcon
		tempname Zi ubPub xpx xzx trmat tr 

		scalar `K'=`k'+2 
					/* Get group and time information */

		if "`model'" == "fd" {
			local obif " if _n > 1"
		}	
		qui sort `id' `t'
		qui by `id': gen long `i_obs'=1  `obif'
		qui by `id': gen long `i_obs2'=sum(`i_obs')  `obif'
		qui by `id': replace `i_obs'=cond(_n==_N,`i_obs2'[_N],.) /*
			*/  `obif'

		qui sum `i_obs' `obif'
		scalar `n'=r(N)			/* n = number of groups */
		scalar `ti_min'=r(min)
		scalar `ti_max'=r(max)
		scalar `ti_ave'=r(mean)

		if `ti_min' == `ti_max' {
			scalar `Tcon' = 1
		}
		else {
			scalar `Tcon' = 0
		}	

		qui by `id': replace `i_obs'=`i_obs'[_N]

							/* Do FD IV */
		if "`model'" == "fd" {
			
			if "`exog_t'" != "" {
				local exog_tl "exog_t( `exog_t' )" 
			}
			else {
				local exog_tl ""
			}	

			if "`first'" != "" {
				foreach yvar of local end1 {
					di
					di as text "First-stage first-"/*
						*/"differenced regression"
					if `siclust'== 1 {
						_regress d.`yvar'           ///
							d.(`exog' `inst') , ///
							`constant'          ///
							level(`level')      ///
							`diopts'            ///
							cluster(`clust')
					}
					if `siclust'== 2 {
						_regress d.`yvar'           ///
							d.(`exog' `inst') , ///
							`constant'          ///
							level(`level')      ///
							`diopts'            ///
							robust              
					}
					if `siclust'== 0 {
						_regress d.`yvar'           ///
							d.(`exog' `inst') , ///
							`constant'          ///
							level(`level')      ///
							`diopts'            
					}
				}	
			}		

			FirstD `lhs_t' , `exog_tl' end1_t(`end1_t') /*
				*/ inst_t(`inst_t') id(`id') /*
				*/ n_g(`n') t(`t') /*
				*/ i_obs(`i_obs') depvar(`lhs') /*
				*/ level(`level') coefs_ts(`coefs') /*
				*/ `constant' `small' vce(`vce2') /*
				*/ cluster(`siclust')  clustervar(`clust') /*
				*/ id(`id')

			tempname b V
			mat `b'=e(b)
			mat `V'=e(V)

			local names2 "`names'"
			foreach vart of local names2 {
				local names3 " `names3' d.`vart' "
			}

			if "`constant'" == "" {
				local const "_cons"
			}	
			mat colnames `b'=`names3' `const'
			mat colnames `V'=`names3' `const'
			mat rownames `V'=`names3' `const'
			
			restore

 			markout `touse' d.`lhs_t' d.(`end1_t' `exog_t') /*
				*/  d.(`exog_t' `inst_t') 
			est repost b = `b', rename esample(`touse') `fvopts'

			est scalar g_min = `ti_min'
			est scalar g_max = `ti_max'
			est scalar g_avg = `ti_ave'

			est local small "`small'"
			est local ivar "`id'"
			est local tvar "`t'"
			est local model "fd"
			est local depvar "d.`lhs'"

			local end1 `end1'
			est local instd "`end1'"
			local exog `exog'
			est local insts "`exog' `inst'"
			est hidden local clustepg "`siclust'"
			est local predict "xtivp_2"
			est local marginsok "XB default"

			est local cmd "xtivreg"
			DispFD , level(`level') `diopts'
			DispI
			exit
		}

						/* Do within 2sls */

		if "`first'" != ""  & "`model'" == "fe" {
			foreach yvar of local end1_t {
				`vv' qui xtreg `yvar' `exog_t' `inst_t', fe ///
					i(`id') vce(`vce2')
				tempname bw
				mat `bw'=e(b)
				`vv' ///
				mat colnames `bw' = `exog' `inst' _cons
				est repost b=`bw', rename findomitted ///
					buildfvinfo
				di
				di as text "First-stage within regression"
				`vv' xtreg , level(`level') `diopts'
			}	
		}		

		if "`exog_t'" != "" {
			local exogvs " exog_t(`exog_t') " 
		}	
		
		within `lhs_t' , `exogvs' end1_t(`end1_t') /*
			*/ inst_t(`inst_t') id(`id') /*
			*/ n_g(`n') res(`res_w') model(`model') /*
			*/ i_obs(`i_obs') depvar(`lhs') /*
			*/ level(`level') coefs_ts(`coefs_ts') `small' /*
			*/ vce(`vce2') cluster(`siclust')  /*
			*/ clustervar(`clust') id(`id')

		if "`model'" == "fe" {
			tempname b V
			mat `b'=e(b)
			mat `V'=e(V)

			`vv' ///
			mat colnames `b'=`names' _cons
			`vv' ///
			mat colnames `V'=`names' _cons
			`vv' ///
			mat rownames `V'=`names' _cons
			
			restore 
			est repost b = `b', rename esample(`touse') ///
				findomitted buildfvinfo


			est local vce "`tvce'"

			est scalar g_min = `ti_min'
			est scalar g_max = `ti_max'
			est scalar g_avg = `ti_ave'

			est local ivar "`id'"
			est local tvar "`t'"
			est local model "fe"
			est local depvar "`lhs'"

			est local predict "xtivp_1"
			est local marginsnotok "ue xbu u e"
			est local marginsok "XB default"

			tempname df_wald
			if "`small'" != "" {
				scalar `df_wald' = e(df_r)
			}
			else {
				scalar `df_wald' = e(df_rz)
			}

			est scalar F_f = ( (`rss_rlm'-`rss_ulm')/ e(rss) ) /*
				*/ *( `df_wald'/e(df_a) ) 
			est scalar F_fp =fprob(e(df_a), `df_wald' ,e(F_f)) 
			
			if "`lm'" ! = "" {
				est scalar lm_u=`lm_u'
				est scalar lm_up= 1-chi2(e(df_a),e(lm_u)) 
			}	

			local end1 `end1'
			local exog `exog'
			est local instd "`end1'"
			est local insts "`exog' `inst'"
			est hidden local version "1.1.4"
			est hidden local clustepg "`siclust'"
			est local cmd "xtivreg"
			DispFE , `lm' level(`level') `diopts' cluster(`siclust')
			DispI
			exit
		}


		tempname s_e rss_w df_rw
		scalar `rss_w' = e(rss)
		scalar `df_rw' = e(df_rz)

		scalar `s_e' = sqrt(`rss_w'/`df_rw')

		scalar `N'=e(N)

		qui replace `res_w'=`res_w'*`res_w'
		qui sum `res_w'

		if "`sa'" == "" { 
			if `Tcon'==1 {
				scalar `sig_e2' = `rss_w'/`df_rw'
			}
			else {
				scalar `sig_e2'=r(sum)/(`N'-`n'-`K'+1)
			}	
		}	
		else {
			scalar `sig_e2'=r(sum)/(`N'-`n')
		}	
	
		
							/* Do between 2sls */
		
		if "`exog_t'" != "" {
			local exog_tl " exog_t( `exog_t' )"
		}	
		else {
			local exog_tl ""
		}	
		 
		if "`first'" != "" & "`model'"=="be" {
			local i 1
			foreach vart of local end1_t {
				local dept2 : word `i' of `end1'
				if `siclust' == 1 {
					display as error ///
					"option {bf:first} and model " ///
					"{bf:between} may not be specified" ///
					" together with vce {bf:cluster}"
					exit 198
				}
				if `siclust' == 2 {
					display as error ///
					"option {bf:first} and model " ///
					"{bf:between} may not be specified" ///
					" together with vce {bf:robust}"
					exit 198
				}
				qui xtreg `vart' `exog_t' `inst_t',        ///
					be vce(`vce2')
					
				tempname bw
				mat `bw'=e(b)
				`vv' ///
				mat colnames `bw' = `exog' `inst' _cons
				est repost b=`bw', rename `fvopts'
				di
				di as text "First-stage between regression"
				xtreg , level(`level') depname(`dept2') /*
					*/ `diopts'
				local i = `i' + 1
			}
		}	
				
		between `lhs_t' , `exog_tl' end1_t(`end1_t') /*
			*/ inst_t(`inst_t') coefs_ts(`coefs_ts') id(`id') /*
			*/ n_g(`n') res(`res_b') i_obs(`i_obs') /*
			*/ model(`model') `small' /*
			*/ vce(`vce2') cluster(`siclust')  /*
			*/ clustervar(`clust') id(`id')

		
		scalar `K' = e(df_m) + 1

		if "`model'" == "be" {
			tempname b V
			mat `b'=e(b)
			mat `V'=e(V)

			`vv' ///
			mat colnames `b'=`names' _cons
			`vv' ///
			mat colnames `V'=`names' _cons
			`vv' ///
			mat rownames `V'=`names' _cons
			
			restore
			est repost b=`b', rename esample(`touse') `fvopts'

			est local vce "`tvce'"

			est scalar g_min = `ti_min'
			est scalar g_max = `ti_max'
			est scalar g_avg = `ti_ave'

			est scalar N = `N'
			
			local end1 `end1'
			local exog `exog'
			est local instd "`end1'"
			est local insts "`exog' `inst'"
			est local tvar "`t'"

			est hidden local version "1.1.4"
			est hidden local clustepg "`siclust'"
			est local cmd     xtivreg
			DispBE, level(`level') `diopts'
			DispI
			exit
		}	
		
						/* since the data is already
					   	   mean by group so are 
						   residuals
						*/
		tempname s_u
		scalar `s_u' = sqrt((e(rmse)^2) -`s_e'^2/`ti_ave')

		qui replace `res_b'=`res_b'*`res_b'
		qui sum `res_b'
		scalar `ubPub'=r(sum)

		if "`sa'" == "" {
						/* Get Swamy-Arora estimate
						   of sig_u2 
						*/
			if `Tcon'==1 {
				scalar `sig_u2' = `s_u'^2	
			}
			else {
				mat `Zi'=J(`ti_max',`ti_max',1)
	
				mat glsaccum `xpx'=`xvars' /*
					*/ [iweight = 1/`i_obs'] ,/*
					*/ group(`id') glsmat(`Zi') /*
					*/ row(`i_obs2')

				mat glsaccum `xzx'=`xvars', /*
					*/ group(`id') glsmat(`Zi')/* 
					*/ row(`i_obs2')
	
				mat `trmat'=syminv(`xpx')
	
				mat `trmat'=`trmat'*`xzx'
	
				scalar `tr' = trace(`trmat')
				scalar `sig_u2'=(`ubPub'-(`n'-`K')*`sig_e2') /*
					*/ / (`N'-`tr')
			}

		}
		else {
			scalar `sig_u2'=( (`ubPub'-`n'*`sig_e2')/`N' )
			
		}

		scalar `sig_u2' = max( 0, `sig_u2' )
							/* Compute Theta 
							   and make GLS 
							   tempvars 
							*/

		tempvar theta

		gen double `theta' = 1- /*
		 	*/ sqrt( `sig_e2'/(`sig_u2'*`i_obs' +`sig_e2' ) ) 
	
		qui sum `theta', detail
		tempname thta_min thta_5 thta_50 thta_95 thta_max

		scalar `thta_min' = r(min)
		scalar `thta_5'   = r(p5)
		scalar `thta_50'  = r(p50)
		scalar `thta_95'  = r(p95)
		scalar `thta_max' = r(max)

		tempname cons
		qui gen double `cons'=1-`theta'
								

		local lhs_tt ""
		local exog_tt ""
		local end1_tt ""
		local inst_tt ""

		tempname lhs_tt 
		Glsvar2 `lhs_t' , i(`id') names(`lhs_tt') theta(`theta') 

		if "`exog_t'" != "" {
			local j 1
			foreach vart of local exog_t {
				tempname gex`j' 
				local exog_tt " `exog_tt' `gex`j'' "
				local j = `j' + 1
			}
			Glsvar2 `exog_t' , i(`id') names(`exog_tt') /*
				*/  theta( `theta') 
		}

		local j 1
		foreach vart of local end1_t {
			tempname en`j' 
			local end1_tt " `end1_tt' `en`j'' "
			local j = `j' + 1
		}
		Glsvar2 `end1_t' , i(`id') names(`end1_tt') theta(`theta') 

		if "`ec2sls'" == "" {
			
			local j 1
			foreach vart of local inst_t {
				tempname ins`j' 
				local inst_tt " `inst_tt' `ins`j'' "
				local j = `j' + 1 
			}
			Glsvar2 `inst_t' , i(`id') names(`inst_tt') /*
				*/ theta(`theta') 

			local enumf 1
			if "`first'" != "" {
				foreach vart of local end1_tt {	
					if `siclust'== 1 {
					   tempvar clustf ngf nclf
					   quietly summarize `clust'
					   scalar `nclf'  = r(N)
					  quietly tab `clust'
					  scalar `ngf' = r(r)
					  if `nclf'==0 {
						qui `vv' destring `clust',  ///
							generate(`clustf')
						quietly tab `clustf'
						scalar `ngf'  = r(r)
					  }
					   `vv'	qui _regress `vart' `exog_tt' /*
						*/ `inst_tt' `cons', nocons /*
						*/  cluster(`clust')  
					}
					if `siclust'== 2 {
						`vv' qui _regress `vart' /*
						*/ `exog_tt' /*
						*/ `inst_tt' `cons', nocons /*
						*/  robust  					
					}
					if `siclust'== 0 {
						`vv' qui _regress `vart' /*
						 */ `exog_tt' /*
						*/ `inst_tt' `cons', nocons 					
					}
					local fdos = e(N) -e(df_m)
					local dgfs = e(df_m) - 1
					local laFu = e(mss)/`dgfs'
					local laFb = e(rss)/`fdos'
					local laF  = `laFu'/`laFb'
					local pvF  = ///
						Ftail(`dgfs', `fdos', `laF')
											
					local Nf =e(N)
					local depn : word `enumf' of `end1'

					tempname bw Vw
					mat `bw'=e(b)
					local finames "`exog' `inst' _cons"
					`vv' ///
					mat colnames `bw' = `finames'
					mat `Vw' =e(V)
					`vv' ///
					mat colnames `Vw' = `finames'
					`vv' ///
					mat rownames `Vw' = `finames'
					
					local dfci ""
					if ("`small'"!="") {
						local numdfci = e(df_r)
						local dfci "dof(`numdfci')"
					}

					est post `bw' `Vw', depname(`depn') /*
						*/ obs(`Nf') `fvopts' `dfci'
					_post_vce_rank
					quietly test `exog' `inst'		
					if ("`small'"=="") {
						di
						di as text "First-stage G2SLS"/*
						*/" regression"
						di _col(50) as text /*
						*/ "Number of obs" /*
						*/ _col(67) "=" as result /*
						*/ _col(69) %10.0fc e(N)
						di _col(50) as text /*
						*/ "Wald chi(" /*
						*/ as result r(df) /*
						*/ as text")" _col(67) "=" /*
						*/ as result _col(71) %8.2g /*
						*/ r(chi2)
						di _col(50) as text /*
						*/"Prob > chi2" /*
						*/ _col(67) "=" as result /*
						*/ _col(73) %6.4f r(p) _n			
						local enumf = `enumf' + 1
					}
					else {
						di
						di as text "First-stage G2SLS"/*
						*/" regression"
						di _col(50) as text /*
						*/ "Number of obs" /*
						*/ _col(67) "=" as result /*
						*/ _col(69) %10.0fc e(N)
						di as txt _col(50) 	///
						"F(" as res `dgfs' as	///
						txt "," as res `fdos'	///
						as txt ")" _col(67) "=" ///
						_col(70) as res %9.2f `laF' 
						di as txt _col(50) as txt ///
						_col(49) "Prob > F"	///
						_col(67) "=" ///
						_col(73) as res %6.4f `pvF'
						di ""			
					}	
					if `siclust'== 1 {
						est local vce "cluster"
						est local vcetype "Robust"
					     est local clustvar "`clustervar'"
					  	if `siclust'== 1 {
						`vv' ereturn scalar	///	
							N_g = `ngf'
						`vv' ereturn scalar 	///
							N_clust = `ngf' 
						}     
					}
					
					if `siclust'== 2 {
						est local vce "robust"
						est local vcetype "Robust"
					      est local clustvar "`clustervar'"
					}
					
					if `siclust'== 0 {
						est local vce "conventional"
					}				
					`vv' _coef_table, level(`level') ///
						`diopts'				
				}	
			}				
			
			if `siclust'> 0 {
				tempname modbase
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
					*/ `cons' ( `exog_tt' `inst_tt' /*
					*/ `cons' ) , nocons
				matrix `modbase' = e(V)	
			}
			if `siclust'== 1 {
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
					*/ `cons' ( `exog_tt' `inst_tt' /*
					*/ `cons' ) , nocons cluster(`clust')
			}
			if `siclust'== 2 {
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
					*/ `cons' ( `exog_tt' `inst_tt' /*
					*/ `cons' ) , nocons cluster(`id')
			}
			if `siclust'== 0 {
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
					*/ `cons' ( `exog_tt' `inst_tt' /*
					*/ `cons' ) , nocons
			}
		}
		else {

							/* demean inst */
	
			local j 1
			foreach vart of local inst_t {
				tempname ins`j'
				local inst_tt2 " `inst_tt2' `ins`j'' "
				local j = `j' + 1
			}
			dmean `inst_t' , i(`id') names(`inst_tt2')


							/* mean inst */
			local j 1				
			foreach vart of local inst_t {
				tempname insb`j' 
				local inst_tt3 " `inst_tt3' `insb`j'' "
				local j = `j' + 1
			}
			meanv `inst_t' , i(`id') names(`inst_tt3')

			local exog_tg "`exog_t' "	

							/* deman exog */
			if "`exog_t'" != "" {				
				local j 1
				foreach vart of local exog_tg {
					tempname exa`j'
					local exog_tt2 " `exog_tt2' `exa`j'' "
					local j = `j' + 1 
				}
				dmean `exog_tg' , i(`id') names(`exog_tt2')

								/* mean exog */
				local j 1				
				foreach vart of local exog_tg {
					tempname exb`j' 
					local exog_tt3 " `exog_tt3' `exb`j'' "
					local j = `j' + 1
				}
				meanv `exog_tg' , i(`id') names(`exog_tt3')
			}
							/*One Big Inst */
			
local inst_g2 " `inst_tt2' `inst_tt3' `exog_tt2' `exog_tt3'"

			
			if "`first'" != "" {
				foreach vart of local inst {
					local inst_d  "`inst_d' `vart'_d  "
					local inst_m  "`inst_m' `vart'_m  "
				}			
				
				foreach vart of local exog {
					local exog_d  "`exog_d' `vart'_d  "
					local exog_m  "`exog_m' `vart'_m  "
				}			

				
				local endnum 1
				foreach yvar of local end1_tt {

					if `siclust'>0 {
					tempname modbase
					qui _regress `yvar' `inst_g2' ///
						`cons', nocons 
					matrix `modbase' = e(V)	
					} 
					if `siclust'==1 {
					qui _regress `yvar' `inst_g2' ///
						`cons', nocons cluster(`clust')
					} 
					if `siclust'==2 {
					qui _regress `yvar' `inst_g2' ///
						`cons', nocons cluster(`id')
					} 
					if `siclust'==0 {
					qui _regress `yvar' `inst_g2' ///
						`cons', nocons 
					} 
					
					local Nf=e(N)
					
					tempname bw Vw
					mat `bw'=e(b)
local finames  "`inst_d' `inst_m' `exog_d' `exog_m' _cons"
					`vv' ///
					mat colnames `bw' = `finames' 
					mat `Vw'=e(V)
					`vv' ///
					mat colnames `Vw' =  `finames' 
					`vv' ///
					mat rownames `Vw' =  `finames' 
					local edep : word `endnum' of `end1'
					est post `bw' `Vw', depname(`edep')/*
						*/ obs(`Nf') `fvopts'
					_post_vce_rank
	
					qui test `inst_d' `inst_m' `exog_d' /*
						*/ `exog_m'
					
					di
					di as text "First-stage EC2SLS "/*
						*/" regression"
					di _col(50) as text "Number of obs" /*
						*/ _col(67) "=" as result /*
						*/ _col(69) %10.0fc e(N)
					di _col(50) as text "Wald chi(" /*
						*/ as result r(df) /*
						*/ as text")" _col(67) "=" /*
						*/ as result _col(71) %8.2g /*
						*/ r(chi2)
					di _col(50) as text "Prob > chi2" /*
						*/ _col(67) "=" as result /*
						*/ _col(73) %6.4f r(p) _n
					
					if `siclust'== 1 {
						est local vce "cluster"
						est local vcetype "Robust"
					     est local clustvar "`clustervar'"
					}
					
					if `siclust'== 2 {
						est local vce "robust"
						est local vcetype "Robust"
					      est local clustvar "`clustervar'"
					}
					
					if `siclust'== 0 {
						est local vce "conventional"
					}
					
					_coef_table, level(`level') `diopts'

					local endnum = `endnum' + 1
				}
		
				if `siclust'== 1 {
					est local vce "cluster"
					est local vcetype "Robust"
					est local clustvar "`clustervar'"
				}
				
				if `siclust'== 2 {
					est local vce "robust"
					est local vcetype "Robust"
					est local clustvar "`clustervar'"
				}
				
				if `siclust'== 0 {
					est local vce "conventional"
				}
			}		
		
							/* do regression */
			if `siclust'> 0 {
				tempname modbase
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
				*/	`cons' ( `inst_g2' `cons' ) , nocons
				matrix `modbase' = e(V)	
			}
			if `siclust'== 1 {
				 qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
				*/	`cons' ( `inst_g2' `cons' ) , nocons /*
				*/	cluster(`clust')
			}
			if `siclust'== 2 {
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
				*/	`cons' ( `inst_g2' `cons' ) , nocons /*
				*/	cluster(`id')
			}
			if `siclust'== 0 {
				qui _regress `lhs_tt' `end1_tt' `exog_tt' /*
				*/	`cons' ( `inst_g2' `cons' ) , nocons
			}				
		}	
	
						/* if here model must
							be RE 
						*/	
		tempname df_r df_m

		scalar `df_r' = e(df_r)+1
		scalar `df_m' = e(df_m)-1

		local depvar "`lhs_t'"
		tempname b V
		mat `b'=e(b)
		mat `V' = e(V)

		`vv' ///
		mat colnames `b' = `coefs_ts' _cons
		`vv' ///
		mat colnames `V' = `coefs_ts' _cons
		`vv' ///
		mat rownames `V' = `coefs_ts' _cons
		
		est post `b' `V' , depname(`lhs')
		_post_vce_rank
						
		tempvar XB U tmp
						
						/* obtain R^2 overall	*/
		qui _predict double `XB' if `touse', xb
		qui corr `XB' `depvar'
		est scalar r2_o = r(rho)^2

					/* obtain R^2 between */
		qui by `id' : gen double `U' =  cond(_n==_N , /*
			*/ sum(`XB'/_N), .)

		qui by `id': gen double `tmp' = cond(_n==_N , /*
			*/ sum(`depvar'/_N), .) 
		qui corr `U' `tmp'
		est scalar r2_b = r(rho)^2

						/* obtain R^2 within */
		qui by `id': replace `U' = `XB'-`U'[_N]
		qui by `id': replace `tmp'=`depvar'-`tmp'[_N]
		qui corr `U' `tmp'
		est scalar r2_w = r(rho)^2

		qui drop `U' `tmp'
			

		tempname b V

		mat `b'=e(b)
		mat `V'=e(V)

		`vv' ///
		mat colnames `b'=`names' _cons
		`vv' ///
		mat colnames `V'=`names' _cons
		`vv' ///
		mat rownames `V'=`names' _cons
			
		restore 	
		est repost b = `b', rename esample(`touse') `fvopts'

		if `siclust'== 1 {
			est local vce "cluster"
			est local vcetype "Robust"
			est local clustvar "`clustervar'"
		}
		
		if `siclust'== 2 {
			est local vce "robust"
			est local vcetype "Robust"
			est local clustvar "`id'"
		}
		
		if `siclust'== 0 {
			est local vce "conventional"
		}

		if `siclust'>0 {
			`vv' ///
			mat colnames `modbase' =`names' _cons
			`vv' ///
			mat rownames `modbase' =`names' _cons
			est matrix V_modelbased   = `modbase'
		}

		est scalar g_min = `ti_min'
		est scalar g_max = `ti_max'
		est scalar g_avg = `ti_ave'

		est scalar N = `N'
			
		est local ivar "`id'"
		est local tvar "`t'"
		if "`ec2sls'" == "" {
			est local model "g2sls"
		}
		else {
			est local model "ec2sls"
		}
		est local depvar "`depvar'"

		est local predict "xtivp_1"
		est local marginsnotok "ue xbu u e"
		est local marginsok "XB default"

		if "`small'" != "" {
			est scalar df_r    = `df_r'
			est local small "small"
		}	

		qui test `names'
		
		if "`small'" != "" {
			est scalar F = r(F)
		}	
		else {	
			est scalar chi2 =r(chi2)
			est local chi2type "Wald"
		}

		est scalar m_p = r(p)

		est scalar df_rz    = `df_r'
		est scalar df_m    = `df_m'
		est scalar N_g     = `n'
		if `siclust'== 1 {
			tempvar tidos tidos2
			marksample tousedos
			qui bysort `clustervar': generate `tidos' = 1 ///
								if (_n==_N)
			qui egen `tidos2' = sum(`tidos') if `tousedos'
			qui sum `tidos2', meanonly
			local ncluster = r(mean)                 /* # of clusters*/
			est scalar N_clust = `ncluster'
		}
		else {
			est scalar N_clust = `n'	
		}
		est scalar sigma_u = sqrt(`sig_u2')
		est scalar sigma_e = sqrt(`sig_e2')
		est scalar sigma   = sqrt(`sig_u2'+`sig_e2')
		est scalar rho     = `sig_u2'/(`sig_u2'+`sig_e2')
		est scalar Tcon    = `Tcon'
		if `Tcon' == 1 {
			est scalar theta = `thta_50'
		}
		else {
			est scalar thta_min = `thta_min'
			est scalar thta_5   = `thta_5'
			est scalar thta_50  = `thta_50'
			est scalar thta_95  = `thta_95'
			est scalar thta_max = `thta_max'
		}
		
		local end1 `end1'
		local exog `exog'
		est local instd "`end1'"
		est local insts "`exog' `inst'"

		est hidden local version "1.1.4"
		est local cmd "xtivreg"
		
		DispRE, level(`level') `thetad' `ec2sls' `diopts'
		DispI
end	


program define IsStop, sclass
				/* sic, must do tests one-at-a-time, 
				 * 0, may be very large */
	if `"`0'"' == "[" {		
		sret local stop 1
		exit
	}
	if `"`0'"' == "," {
		sret local stop 1
		exit
	}
	if `"`0'"' == "if" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "in" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "" {
		sret local stop 1
		exit
	}
	else	sret local stop 0
end

program define Subtract   /* <cleaned> : <full> <dirt> */
	args	    cleaned     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  full	/*  list to be cleaned 
		*/  dirt	/*  tokens to be cleaned from full */
	
	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	tokenize `full'			/* cleans up extra spaces */
	c_local `cleaned' `*'       
end

program define dmean
	syntax varlist , i(varlist) names(string)
	
	local k1 : word count `varlist'
	local k2 : word count `names'

	if `k1' != `k2' {
		di as err  " varlist and namelist have distinct " /*
			*/ "lengths in dmean"
		exit 198
	}	
	
	tokenize `varlist'

	local j 1
	while "``j''" != "" {
		tempname omean
		qui summ ``j''
		scalar `omean'=r(mean)
		
		tempvar mean 
		qui by `i': gen double `mean'=sum(``j'') 
		qui by `i': replace `mean' =`mean'[_N]/_N
		local var : word `j' of `names'
		qui gen double `var' = ``j''-`mean' + `omean'
	
		local j = `j' +1
	}	
end	

program define meanv
	syntax varlist , i(varlist) names(string) 
	
	local k1 : word count `varlist'
	local k2 : word count `names'

	if `k1' != `k2' {
		di as err  " varlist and namelist have distinct " /*
			*/ "lengths in dmean"
		exit 198
	}	
	
	tokenize `varlist'

	tempvar mean 
	local j 1
	while "``j''" != "" {
		capture drop `mean'
		qui by `i': gen double `mean'=sum(``j'') 
		qui by `i': replace `mean' =`mean'[_N]/_N

		local var : word `j' of `names'
		qui gen double `var' = `mean'
	
		local j = `j' +1
	}	

end	

program define Glsvar2
	syntax varlist , i(varlist) names(string)  theta(varlist)

	local k1 : word count `varlist'
	local k2 : word count `names'

	if `k1' != `k2' {
		di as err  " varlist and namelist have distinct " /*
			*/ "lengths in dmean"
		exit 198
	}	
	

	tokenize `varlist'
	
	tempname mean
	local j 1
	while "``j''" != "" {
		capture drop `mean'
		qui by `i': gen double `mean'=sum(``j'') 
		qui by `i': replace `mean' =`mean'[_N]/_N

		local var : word `j' of `names'

		qui gen double `var' =``j''-`theta'*`mean'
		
		local j = `j' +1
	}	
end	

program define between, eclass
	syntax varlist,  end1_t(varlist) /*
		*/ inst_t(varlist) id(varlist) coefs_ts(string) /*
		*/ n_g(string) i_obs(varlist) model(string) /*
		*/ [exog_t(varlist) res(string) level(cilevel) /*
		*/ small vce(string) /*
		*/ cluster(integer 0) clustervar(string) id(string)]

	local lhs_t "`varlist'"	
	local depvar "`lhs_t'"

	tempname lhs_tt 
	meanv `lhs_t' , i(`id') names(`lhs_tt')

	tempvar touse 
	gen byte `touse'=e(sample) 

	if "`exog_t'" != "" {
		local j 1
		foreach vart of local exog_t {
			tempname ex`j' 
			local exog_tt " `exog_tt' `ex`j'' "
			local j = `j' + 1
		}
		meanv `exog_t' , i(`id') names(`exog_tt')
	}
	else {
		local exog_tt ""
	}	

	local j 1
	foreach vart of local end1_t {
		tempname en`j' 
		local end1_tt " `end1_tt' `en`j'' "
		local j = `j' + 1
	}
	meanv `end1_t' , i(`id') names(`end1_tt')

	local j 1
	foreach vart of local inst_t {
		tempname ins`j' 
		local inst_tt " `inst_tt' `ins`j'' "
		local j = `j' + 1 
	}
	meanv `inst_t' , i(`id') names(`inst_tt')

	tempvar id1
	by `id': gen byte `id1'=(_n==1)
	
	if `cluster'>0 {
		tempname modbase
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  /*
		*/ ( `exog_tt' `inst_tt')  if `id1' 
		matrix `modbase' = e(V)
	}

	if `cluster'== 1 {
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  /*
		*/ ( `exog_tt' `inst_tt')  if `id1', cluster(`clustervar') 
	}
	if `cluster'== 2 {
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  /*
		*/ ( `exog_tt' `inst_tt')  if `id1', cluster(`id') 
	}
	if `cluster'== 0 {
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  /*
		*/ ( `exog_tt' `inst_tt')  if `id1' 
	}
	
	tempname N_g df_m F r2_b rmse mss rss df_r r2_a

	scalar `N_g' = e(N)
	scalar `df_m'  = e(df_m)
	scalar `df_r' = e(df_r)
	scalar `r2_b' = e(r2)
	scalar `rmse' = e(rmse)
	scalar `mss' = e(mss)
	scalar `rss' = e(rss)
	scalar `F'= e(F)
	scalar `r2_a' = e(r2_a) 
	
	if `cluster'== 1 {
		preserve
		tempvar tidos tidos2
		qui bysort `clustervar': generate `tidos' = 1 if ///
						(_n==_N & `touse'==1)
		qui egen `tidos2' = sum(`tidos')
		qui sum `tidos2', meanonly
		local ncluster = r(mean)                 /* # of clusters*/
		est scalar N_clust = `ncluster'
		restore
	}
	else {
		est scalar N_clust = `N_g'	
	}
	

	if "`res'" != "" {
		qui predict double `res', res
	}	
	
	tempname b V
	
	local testn "`coefs_ts'"

	local coefs "`coefs_ts' _cons "
	mat `b' =e(b)
	mat `V'=e(V)

	if `n_g'<=int(e(df_m))+1 {
		mat `V'=0*`V'
	}	
	else {
		mat `V'= ( e(df_r)/(`n_g'-e(df_m)-1 ) ) *`V'
	}	
	
	mat colnames `b'=`coefs'
	mat colnames `V'=`coefs'
	mat rownames `V'=`coefs'
	
	est post `b' `V', depname(`depvar')
	_post_vce_rank
	est local depvar "`depvar'"

	est scalar df_m = `df_m' 
	est scalar rmse = `rmse'
	
	if "`model'" == "be" {
		
		tempvar XB  touse 
		tempname ui sigma_u  r2_o r2_w T
	
		mark `touse'
		markout `touse' `varlist'  `exog_t' `end1_t' `inst_t' `id'
		
		qui _predict double `XB' , xb
		qui corr `XB' `depvar'
		est scalar r2_o = r(rho)^2

		qui by `id': gen double `T'= sum(`XB')/_N 
		qui by `id': replace `XB'=`XB'-`T'[_N] 
		qui drop `T'
		qui by `id': gen double `T'= sum(`depvar')/_N 
		qui by `id': replace `T' = `depvar'-`T'[_N] 
		qui corr `XB' `T'
		est scalar r2_w = r(rho)^2

		est scalar N_g  = `N_g' 
		if `cluster'== 1 {
			preserve
			tempvar tidos tidos2
			qui bysort `clustervar': generate `tidos' = 1 if ///
							(_n==_N & `touse'==1)
			qui egen `tidos2' = sum(`tidos')
			qui sum `tidos2', meanonly
			local ncluster = r(mean)             /* # of clusters*/
			est scalar N_clust = `ncluster'
			restore
		}
		else {
			est scalar N_clust = `n_g'	
		}
		est scalar df_rz = `df_r'
		est scalar r2_b = `r2_b'
		est scalar mss  = `mss' 
		est scalar rss  = `rss' 
		est scalar rs_a = `r2_a'
		
		if ("`small'" != "" & `cluster'==0) {
			est scalar df_r = `df_r'
			est scalar F    = `F'
		}		
		else {
			qui test `testn' 
			est scalar chi2 = r(chi2)
			est scalar chi2_p = r(p)
		}	
	
		est local small "`small'"
		est local ivar   `id'
		est local model   be
		est local predict "xtivp_1"
		est local marginsnotok "ue xbu u e"
		est local marginsok "XB default"
	}	
	
	if `cluster'>0 {
		est matrix V_modelbased = `modbase'
	}
	
	if `cluster'== 1 {
		est local vce "cluster"
		est local vcetype "Robust"
		est local clustvar "`clustervar'"
	}
	
	if `cluster'== 2 {
		est local vce "robust"
		est local vcetype "Robust"
		est local clustvar "`id'"
	}
end	

program define within, eclass
	syntax varlist,  end1_t(varlist) /*
		*/ inst_t(varlist) id(varlist) n_g(string) /*
		*/ coefs_ts(varlist) /*
		*/ [model(string) depvar(varlist ts) /* 
		*/ i_obs(varlist) res(string) level(cilevel) /* 
		*/  exog_t(varlist) small  vce(string) /*
		*/ cluster(integer 0) clustervar(string) id(string)]

	local lhs_t "`varlist'"	
	tempname lhs_tt 
	dmean `lhs_t' , i(`id') names(`lhs_tt')

	local j 1
	local kuno 0
	if "`exog_t'" != "" {
		foreach vart of local exog_t {
			tempname ex`j'
			local exog_tt " `exog_tt' `ex`j'' "
			local j = `j' +1 
			quietly xtsum `vart'
			if r(sd_w)>0 {
				local kuno = `kuno' + 1
			}
		}
		dmean `exog_t' , i(`id') names(`exog_tt')
	}

	local j 1 
	local kdos 0 
	foreach vart of local end1_t {
		tempname en`j'
		local end1_tt " `end1_tt' `en`j'' "
		local j = `j' + 1
		quietly xtsum `vart'
		if r(sd_w)>0 {
			local kdos = `kdos' + 1
		}
	}
	dmean `end1_t' , i(`id') names(`end1_tt')

	local j 1
	foreach vart of local inst_t {
		tempname ins`j' 
		local inst_tt " `inst_tt' `ins`j'' "
		local j = `j' + 1 
	}
	dmean `inst_t' , i(`id') names(`inst_tt')

	if (`cluster'== 1|`cluster'==2) {
		tempname modbase
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  		   ///
			( `exog_tt' `inst_tt')
		matrix `modbase' = e(V)
	}

	if `cluster'== 1 {
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  		   ///
			( `exog_tt' `inst_tt'), cluster(`clustervar')
	}	
	if `cluster'== 2 {	
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  		   ///
			( `exog_tt' `inst_tt'), cluster(`id') 
	}
	if `cluster'== 0 {
		qui _regress `lhs_tt' `end1_tt' `exog_tt'  		   ///
			( `exog_tt' `inst_tt')
	}

	tempvar touse
	gen byte `touse'=e(sample)

	if "`res'" != "" {
		qui predict double `res', res
	}

	tempvar XB
	tempname b V N F df_r df_m r2_w rss
	
	scalar `r2_w' = e(r2)
	scalar `rss' = e(rss) 
	
	local coefs_ts2 "`coefs_ts'"
	local coefs_ts "`coefs_ts' _cons "
	mat `b' =e(b)
	mat `V'=e(V)

	local kreg = `kuno' + `kdos' + 1

	if `cluster' == 0 {
		mat `V'= ( e(df_r)/(e(df_r)-`n_g'+1) )*`V'
		scalar `N' = e(N) 
		scalar `F'=( e(df_r) - `n_g'+1 )/( e(df_r) )* e(F) 
		scalar `df_m'=e(df_m)
		scalar `df_r' = e(df_r) -`n_g'+1
	}

	if `cluster'>0 {
		scalar `N' = e(N) 	
		scalar `F'= e(F) 
		scalar `df_m'=e(df_m) + 1
		scalar `df_r' = `N'-`kreg' -`n_g'+ 1 
	}

	mat colnames `b'=`coefs_ts'
	mat colnames `V'=`coefs_ts'
	mat rownames `V'=`coefs_ts'

	est post `b' `V', depname(`depvar')
	_post_vce_rank

	if "`small'" != "" {
		est scalar df_r =`df_r'
	}	

	est scalar df_rz=`df_r'
	est scalar N = `N'	
	est scalar rss = `rss'
	est scalar N_g = `n_g'
	
	if `cluster'== 1 {
		preserve
		tempvar tidos tidos2
		qui bysort `clustervar': generate `tidos' = 1 if ///
							(_n==_N & `touse'==1)
		qui egen `tidos2' = sum(`tidos')
		qui sum `tidos2', meanonly
		local ncluster = r(mean)                 /* # of clusters*/
		est scalar N_clust = `ncluster'
		restore
	}
	else {
		est scalar N_clust = `n_g'	
	}
	
	if "`model'" == "fe" {
		
		if ("`small'" != "" & `cluster'==0) {
			est scalar F= `F'
			est scalar F_p = fprob(`df_m',`df_r',e(F))
			est scalar df_r= `df_r'
		}
		
		if ("`small'" != "" & `cluster'>0) {	
			qui test `coefs_ts2', noconstant
			est scalar F= r(F)
			est scalar F_p = r(p)
			est scalar df_r=  r(df_r)
		}
		if ("`small'" == "") {
			qui test `coefs_ts'
			est scalar chi2 = r(chi2)
			est scalar chi2_p= r(p)
		}	
		

		tempvar U XB Ti dep_m xb_m
		tempname ui sigma_u 
	
		qui by `id': gen `Ti'=sum(`touse')
		qui by `id': replace `Ti'=`Ti'[_N]

	 	qui _predict double `XB' if `touse' , xb 
		qui sum `XB' if `touse'

		qui gen double `dep_m' = `depvar' if `touse'
		qui by `id': replace `dep_m'=sum(`dep_m')/`Ti' 
		
		qui gen double `xb_m' = `XB' if `touse'	
		qui by `id': replace `xb_m' = sum(`xb_m')/`Ti'

		qui by `id': gen double `U' = /*
				*/ cond(_n==_N, `dep_m'-`xb_m' ,.) 
		
		qui summ `U'
		est scalar sigma_u = sqrt(r(Var))

		qui by `id': replace `U' = `U'[_N]
		qui corr `XB' `U' if `touse' 
		est scalar corr = r(rho)

		qui corr `depvar' `XB' if `touse'
		est scalar r2_o = r(rho)^2

		qui by `id' : replace `XB' = /*
			*/ cond(_n==_N ,  `xb_m'[_N] ,.) 
		qui by `id' : replace `U' = /* 
			*/ cond(_n==_N , /*
			*/ `dep_m'[_N] ,.) 
		qui corr `U' `XB'
		est scalar r2_b = r(rho)^2

		local dfe = `df_r'

		est scalar sigma_e = sqrt(`rss'/`dfe') 
		est scalar sigma = sqrt(e(sigma_u)^2 + e(sigma_e)^2)
		est scalar rho   = e(sigma_u)^2 / e(sigma)^2
		est scalar r2_w= `r2_w'
		if ("`small'"!="") {
			est hidden scalar df_b = `df_m'
		}
		else {
			est scalar df_b = `df_m'		
		}
		est scalar df_m = `n_g' + `df_m' 	
		est scalar df_a = `n_g'-1	
					
		est local small "`small'"
	}
	if `cluster'>0 {
		mat colnames `modbase'=`coefs_ts'
		mat rownames `modbase'=`coefs_ts'
		est matrix V_modelbased = `modbase'
	}
	
	if `cluster'== 1 {
		est local vce "cluster"
		est local vcetype "Robust"
		est local clustvar "`clustervar'"
	}
	
	if `cluster'== 2 {
		est local vce "robust"
		est local vcetype "Robust"
		est local clustvar "`id'"
	}	
end	

program define FirstD, eclass
	syntax varlist,  end1_t(varlist) /*
		*/ inst_t(varlist) id(varname) n_g(string) /*
		*/ coefs_ts(string)  /* 
		*/ [exog_t(varlist) depvar(varlist ts) t(varlist) noConstant /* 
		*/ i_obs(varlist)  small level(cilevel) vce(string) /*
		*/ cluster(integer 0) clustervar(string) id(string)]
		
		
		if (`cluster'== 1|`cluster'==2) {
			tempvar modbase
			qui _regress d.`varlist' d.(`end1_t' `exog_t') /*
				*/ ( d.(`exog_t' `inst_t')) ,`constant' 
			matrix `modbase' = e(V)	
		}
		
		if `cluster'== 1 {
			qui _regress d.`varlist' d.(`end1_t' `exog_t') /*
				*/ ( d.(`exog_t' `inst_t')) ,`constant' /*
				*/ cluster(`clustervar')
		}
		
		if `cluster'== 2 {
			qui _regress d.`varlist' d.(`end1_t' `exog_t') /*
				*/ ( d.(`exog_t' `inst_t')) ,`constant' /*
				*/ cluster(`id')
		}
		
		if `cluster'== 0 {
			tempvar modbase
			qui _regress d.`varlist' d.(`end1_t' `exog_t') /*
				*/ ( d.(`exog_t' `inst_t')) ,`constant' 
			matrix `modbase' = e(V)	
		}
		
	tempvar touse touse2
	gen byte `touse'=e(sample) 
	gen byte `touse2'=e(sample) 

	tempvar XB
	tempname b V N F df_r df_m r2_w rss
	
	scalar `r2_w' = e(r2)
	scalar `rss' = e(rss) 

	scalar `F'= e(F)
	
	if "`constant'" == "" {
		local const "_cons"
	}	

	tokenize `varlist'

	local testn "`coefs_ts'"
	
	local coefs_ts "`coefs_ts' `const' "
	mat `b' =e(b)
	mat `V'=e(V)
	scalar `N' = e(N) 

	scalar `df_m'=e(df_m)
	scalar `df_r' = e(df_r) 	
	mat colnames `b'=`coefs_ts'
	mat colnames `V'=`coefs_ts'
	mat rownames `V'=`coefs_ts'

	est post `b' `V', depname(d.`depvar') esample(`touse2')
	_post_vce_rank
	est scalar N = `N'	
	est scalar rss = `rss'
	est scalar N_g = `n_g'	
	est scalar df_rz =`df_r'
	est scalar df_m  = `df_m'
	
	if `cluster'== 1 {
		preserve
		tempvar tidos tidos2
		sort `clustervar', stable
		qui bysort `clustervar': generate `tidos' = 1 if ///
							(_n==_N & e(sample))
		qui egen `tidos2' = sum(`tidos')
		qui sum `tidos2', meanonly
		noisily sum `tidos2', meanonly
		local ncluster = r(mean)                 /* # of clusters*/
		est scalar N_clust = `ncluster'
		restore 
	}
	else {
		est scalar N_clust = `n_g'	
	}
	
	if "`small'" != "" {
		est scalar df_r = `df_r'
		est scalar F = `F'
	}	
	else {
		qui test `testn'
		est scalar chi2 = r(chi2)
		est scalar chi2_p = r(p)
	}
		
	tempvar U XB tmp XB2 Ti
	tempname ui sigma_u 
		
		
 	qui _predict double `XB' if `touse' , xb 
	
	qui by `id': gen `Ti'=sum(`touse')
	qui by `id': replace `Ti'=`Ti'[_N] 
	
	qui gen double `XB2'=`XB'
	qui sum `XB2' if `touse'

	qui by `id': gen double `U' = sum(`depvar')/`Ti'/* 
		*/ -sum(`XB')/`Ti' if `touse' 

	qui by `id': replace `U' =cond(_n==_N, `U'[_N],.) 
		
	qui summ `U' 
	est scalar sigma_u = sqrt(r(Var))

	qui by `id': replace `U' = `U'[_N]
	qui corr `XB' `U' if `touse' 
	est scalar corr = r(rho)

	qui corr `depvar' `XB' if `touse'
	est scalar r2_o = r(rho)^2

	qui by `id' : replace `XB' = sum(`XB'/`Ti') if `touse'
	qui by `id' : replace `U' =  sum(`depvar'/`Ti') if `touse'
	qui corr `U' `XB'
	est scalar r2_b = r(rho)^2

						/* obtain R^2 within */
	drop `XB'


	qui by `id' : gen double `XB' = sum(`XB2') if `touse'
	qui by `id' : replace `XB' = `XB'[_N]/`Ti'	

	qui by `id': gen double `tmp' = sum(`depvar'/`Ti') if `touse' 
	
	qui by `id': replace `XB2' = `XB2'-`XB' 

	
	qui by `id': replace `tmp'=`depvar'-`tmp'[_N]
	qui corr `XB2' `tmp'
	est scalar r2_w = r(rho)^2

	local dfe = `df_r'

	est scalar sigma_e = sqrt(`rss'/`dfe') 
	est scalar sigma = sqrt(e(sigma_u)^2 + e(sigma_e)^2)
	est scalar rho   = e(sigma_u)^2 / e(sigma)^2
	if ("`small'"!="") {
		est hidden scalar df_b = `df_m'
	}
	else {
		est scalar df_b = `df_m'		
	}
	est scalar df_rz= `df_r'
	
	if `cluster' > 0 {
		est matrix V_modelbased = `modbase'
	}
	
	if `cluster'== 1 {
		est local vce "cluster"
		est local vcetype "Robust"
		est local clustvar "`clustervar'"
	}
	
	if `cluster'== 2 {
		est local vce "robust"
		est local vcetype "Robust"
		est local clustvar "`id'"
	}
		
end	


program define DispFE 
	syntax , [ LM level(cilevel) cluster(integer 0) *]

	_get_diopts diopts options, `options'
	local cfmt `"`s(cformat)'"'
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
	#delimit ;
        di _n as txt "Fixed-effects (within) IV regression"
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
	#delimit cr

	if "`e(vcetype)'" != "" {
		if !missing(e(df_r)) {
			local model as txt _n _col(49) "F(" ///
				as res %4.0f e(df_m) as txt "," ///
				as res %7.0f e(df_r) as txt ")" ///
				_col(67) "=" _col(69) as res %9.2f abs(e(F))
			local pvalue _col(49) as txt "Prob > F" ///
				_col(67) "=" as res ///
				_col(73) %6.4f Ftail(e(df_m),e(df_r),e(F)) _n
		}
		else {
			local model as txt _n _col(49) ///
				"Wald chi2(" ///
				as res e(df_b) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(chi2))
			local pvalue _col(49) as txt "Prob > chi2" ///
				_col(67) "=" as res ///
				_col(73) %6.4f chiprob(e(df_b),abs(e(chi2))) _n
		}
	#delimit ;
		di `model' ;
        	di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr) 
			`pvalue' ;
	#delimit cr
	}
	else if "`e(small)'" == "" {
	#delimit ;
        	di as txt _col(49) "Wald chi2(" as res e(df_b) as txt ")"
			_col(67) "=" _col(70) as res %9.2f e(chi2) ;
        	di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
                	as txt _col(49) "Prob > chi2" _col(67) "="
                	_col(73) as res %6.4f e(chi2_p) _n ;
	#delimit cr
	}
	else {
	#delimit ;
        	di as txt _col(49) "F(" as res e(df_m) as txt "," as res e(df_r)
                	as txt ")" _col(67) "=" _col(69) as res %9.2f e(F) ;
        	di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
                	as txt _col(49) "Prob > F" _col(67) "="
               		 _col(73) as res %6.4f e(F_p) _n;
	#delimit cr
	}

	_coef_table , level(`level') plus `diopts'
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
        di as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
        di as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
        di as txt %`c's "rho" " {c |} " as res %10s "`rho'" /*
		*/ as txt "   (fraction of variance due to u_i)"
	di as txt "{hline `c1'}{c BT}{hline `rest'}"
		
	if `cluster'== 0 {
		#delimit ;
	di as txt "F  test that all u_i=0:     " 
		"F(" as res e(df_a) as txt "," as res e(df_rz) as txt ") = " 
		as res %8.2f e(F_f) _col(59) as txt "Prob > F    = " 
		as res %6.4f fprob(e(df_a),e(df_rz),e(F_f)) ;
		#delimit cr
	
		if "`lm'" != "" {
			#delimit ;
			di as txt "LM test that all u_i=0:      " 
				"Chi2(" as res e(df_a) as txt ") = " 
			as res %8.2f e(lm_u) _col(59) as txt "Prob > Chi2 = " 
			as res %6.4f 1-chi2(e(df_a),e(lm_u)) ;
			#delimit cr
		}
		di as txt "{hline `w'}"
	}

end

program define DispBE
	syntax, level(cilevel) [*]
	_get_diopts diopts options, `options'
	 #delimit ;
        di _n as txt "Between-effects IV regression:"
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
        #delimit cr

	if "`e(vcetype)'" != "" {
		if !missing(e(df_r)) {
			local model as txt _n _col(49) "F(" ///
				as res %4.0f e(df_m) as txt "," ///
				as res %7.0f e(df_r) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(F))
			local pvalue _col(49) as txt "Prob > F" ///
				_col(67) "=" as res ///
				_col(73) %6.4f Ftail(e(df_m),e(df_r),e(F)) _n
		}
		else {
			local model as txt _n _col(49) ///
				"Wald chi2(" ///
				as res e(df_m) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(chi2))
			local pvalue _col(49) as txt "Prob > chi2" ///
				_col(67) "=" as res ///
				_col(73) %6.4f chiprob(e(df_m),abs(e(chi2))) _n
		}

	#delimit ;
		di `model' ;
        	di as txt "sd(u_i + avg(e_i.))" _col(16) "= "
			as res %9.0g e(rmse) `pvalue' ;
	#delimit cr
	}
	else if "`e(small)'" != "" {
		 #delimit ;
	        di as txt _col(49) "F(" as res e(df_m) as txt "," as res e(df_rz)
        	        as txt ")" _col(67) "=" _col(70) as res %9.2f e(F) ;
        	di as txt "sd(u_i + avg(e_i.))" _col(16) "= " as res %9.0g e(rmse)
                	as txt _col(49) "Prob > F" _col(67) "="
	                _col(73) as res %6.4f fprob(e(df_m),e(df_rz),e(F)) _n ;
        	#delimit cr
	}
	else {
		 #delimit ;
	        di as txt _col(49) "Wald chi2(" as res e(df_m) as txt 
        	        ")" _col(67) "=" _col(70) as res %9.2f e(chi2) ;
        	di as txt "sd(u_i + avg(e_i.))" _col(16) "= " as res %9.0g e(rmse)
                	as txt _col(49) "Prob > chi2" _col(67) "="
	                _col(73) as res %6.4f e(chi2_p) _n ;
	        #delimit cr
	}
	_coef_table ,level(`level') `diopts'

end


program define DispRE
	syntax, level(cilevel) [ THETAd  EC2sls *]

	_get_diopts diopts options, `options'
	local cfmt `"`s(cformat)'"'
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
	if "`ec2sls'" == "" {
		local gls "G2SLS"
	}
	else {
		local gls "EC2SLS"
	}	
		#delimit ;
	di _n as txt "`gls' random-effects IV regression" 
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

	#delimit cr
	if "`e(vcetype)'" != "" {
		if !missing(e(df_r)) {
			local model as txt _n _col(49) "F(" ///
				as res %4.0f e(df_m) as txt "," ///
				as res %7.0f e(df_r) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(F))
			local pvalue _col(49) as txt "Prob > F" ///
				_col(67) "=" as res ///
				_col(73) %6.4f Ftail(e(df_m),e(df_r),e(F))
		}
		else {
			local model as txt _n _col(49) ///
				"Wald chi2(" ///
				as res e(df_m) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(chi2))
			local pvalue _col(49) as txt "Prob > chi2" ///
				_col(67) "=" as res ///
				_col(73) %6.4f chiprob(e(df_m),abs(e(chi2)))
		}

	#delimit ;
		di `model' ;
		di as txt "corr(u_i, X)" _col(20) "= " as res "0"
			as txt " (assumed)" `pvalue' ;
	#delimit cr
	}
	else if "`e(small)'" != "" {
		#delimit ;
	        di as txt _col(49) "F(" as res e(df_m) as txt "," as res e(df_r)
        	        as txt ")" _col(67) "=" _col(70) as res %9.2f e(F) ;
		di as txt "corr(u_i, X)" _col(20) "= " as res "0"
                	as txt _col(49) "Prob > F" _col(67) "="
	                _col(73) as res %6.4f e(m_p)  ;
		#delimit cr
	}
	else {
		di as txt _col(49) "Wald chi2(" /* 
			*/ as res e(df_m) as txt ")" _col(67) "=" /*
			*/ _col(70) as res %9.2f e(chi2) 
		#delimit ;
		di as txt "corr(u_i, X)" _col(20) "= " as res "0"
			as txt " (assumed)" _col(49) "Prob > chi2" _col(67) "="
			_col(73) as res %6.4f chiprob(e(df_m),e(chi2)) ;
	#delimit cr
	}		

	if "`thetad'" != "" {
		if e(Tcon) {
			di as txt "theta" _col(20) "= " as res e(theta)
		}
		else {
			di as smcl as txt _n "{hline 19} theta {hline 20}"
			di as txt "  min      5%       median        95%" /*
				*/ "      max" 
			di as res %6.4f e(thta_min) %9.4f e(thta_5) /*
				*/ %11.4f e(thta_50) %11.4f e(thta_95) /*
				*/ %9.4f e(thta_max) 

		}
	}
	display

	_coef_table, level(`level') plus `diopts'
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
	di as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
	di as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
	di as txt %`c's "rho" " {c |} " as res %10s "`rho'" /*
		*/ as txt "   (fraction of variance due to u_i)"
	di as txt "{hline `c1'}{c BT}{hline `rest'}"
end

program define DispFD 
	syntax , [level(cilevel) *]
	_get_diopts diopts, `options' 
	local cfmt `"`s(cformat)'"'
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

	#delimit ;
        di _n as txt "First-differenced IV regression";
        di as txt "Group variable:    " as res abbrev("`e(ivar)'",12) as txt
                _col(49) as txt "Number of obs" _col(67) "="
                _col(69) as res %10.0fc e(N) ;
        di as txt "Time variable:     " as res abbrev("`e(tvar)'",12) as txt
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
	#delimit cr

	if "`e(vcetype)'" != "" {
		if !missing(e(df_r)) {
			local model as txt _n _col(49) "F(" ///
				as res %4.0f e(df_m) as txt "," ///
				as res %7.0f e(df_r) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(F))
			local pvalue _col(49) as txt "Prob > F" ///
				_col(67) "=" as res ///
				_col(73) %6.4f Ftail(e(df_m),e(df_r),e(F)) _n
		}
		else {
			local model as txt _n _col(49) ///
				"Wald chi2(" ///
				as res e(df_m) as txt ")" ///
				_col(67) "=" _col(70) as res %9.2f abs(e(chi2))
			local pvalue _col(49) as txt "Prob > chi2" ///
				_col(67) "=" as res ///
				_col(73) %6.4f chiprob(e(df_m),abs(e(chi2))) _n
		}

	#delimit ;
		di `model' ;
		di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
			`pvalue' ;
	#delimit cr
	}
	else if "`e(small)'" != "" {
		local p = fprob(e(df_b),e(df_rz),e(F))
		#delimit ;
        	di as txt _col(49) "F(" as res e(df_b) as txt "," as res e(df_rz) 
			as txt ")" _col(67) "=" _col(70) as res %9.2f e(F) ;
	        di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
        	        as txt _col(49) "Prob > F" _col(67) "="
                	_col(73) as res %6.4f `p' _n ;
		#delimit cr
	}
	else {
		#delimit ;
        	di as txt _col(49) "Wald chi2(" as res e(df_b) as txt 
			")" _col(67) "=" _col(70) as res %9.2f e(chi2) ;
	        di as txt "corr(u_i, Xb)" _col(16) "= " as res %6.4f e(corr)
        	        as txt _col(49) "Prob > chi2" _col(67) "="
                	_col(73) as res %6.4f e(chi2_p) _n  ;
	#delimit cr
	}

	_coef_table , level(`level') plus `diopts'
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1

        di as txt %`c's "sigma_u" " {c |} " as res %10s "`sigma_u'"
        di as txt %`c's "sigma_e" " {c |} " as res %10s "`sigma_e'"
        di as txt %`c's "rho" " {c |} " as res %10s "`rho'" /*
		*/ as txt "   (fraction of variance due to u_i)"
	di as txt "{hline `c1'}{c BT}{hline `rest'}"

end

program define DispI
	tempname rhold
	_return hold `rhold'
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local cbuffer = c(linesize) - `w'
	local instd "`e(instd)'"
	local insts "`e(insts)'" 
	foreach var of local instd {
		_ms_parse_parts `var'
		if !r(omit) {
			local instd1 "`instd1' `var'"
		}
	} 
	foreach var of local insts {
		_ms_parse_parts `var'
		if !r(omit) {
			local insts1 "`insts1' `var'"
		}
	} 
	local instd: list clean instd1 
	local insts: list clean insts1
	di as txt "{p 0 16 `cbuffer'}Instrumented:{space 3}`instd'{p_end}"
	di as txt "{p 0 16 `cbuffer'}Instruments:{space 4}`insts'{p_end}"	
	di as txt "{hline `w'}"

	_return restore `rhold'
end

program define Check4FVars, sclass
        version 11
	syntax varlist(ts fv)

        // NOTE: -syntax- sets 's(fvops)'
        
end

program define Variance, rclass
	version 14
	syntax , [Robust JACKknife BOOTstrap]

	return scalar var = 2
end

program define Clusters, eclass
	version 14
	syntax varname, CLuster

	gettoken 0:0, parse(",")
	ereturn local clustervar "`0'"
	ereturn scalar var = 3
end

program define VceType, sclass
version 14

cap noi syntax, [conventional Robust CLuster BOOTstrap JACKknife]

local rc _rc 

	if `rc' > 0 {
		di as txt "{phang} The {bf:vce()} option is misspecified." ///
			"{p_end}"
		exit 198
	}

local k: word count `conventional' `robust' `cluster' `bootstrap' `jacknife'

	if `k'>1 {
		di as err "at most one vce type may be specified"
		exit 184
	}
	else if `k'==0 {
		sreturn local vce conventional
	}
	else {
		sreturn local vce ///
			`conventional'`robust'`cluster'`bootstrap'`jacknife'
	}
end 
