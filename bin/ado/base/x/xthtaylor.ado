*! version 1.7.0   21jun2018
program  xthtaylor, eclass byable(onecall) sort prop(xt xtbs)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	local vv: di "version " string(min(10.1,_caller())) ", missing: "  
	`vv' ///
	`BY' _vce_parserun xthtaylor, panel	///
		mark(I T Endog CONStant Varying) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xthtaylor `0'"'
		exit
	}
			/* Model: y_it = b*x_it + g*z_i + mu_i + v_it
			   z_i: time invariant in panel
			   mu_i: random effects
			   v_it: random error
			   X = [X1, X2];  Z = [Z1, Z2]
			   X1, Z1 exogenous, and X2, Z2 endogenous
			*/
	version 8
	if replay() {
		if `"`e(cmd)'"'==`"xthtaylor"' {
			if _by() {
				error 190
			}
			Replay `0'
			exit `e(rc)'
		}
		error 301
	}
	`BY' Estimate `0'
	version 10: ereturn local cmdline `"xthtaylor `0'"'
end

program Estimate, eclass byable(recall)
	syntax varlist(ts) [if] [in] [iw fw],		/*
		*/ Endog(varlist numeric ts) 		/*
		*/ [ CONStant2(varlist numeric ts) 	/*
		*/ Varying(varlist numeric ts) 		/*
		*/ AMacurdy 				/*
		*/ noCONStant 				/*
		*/ I(varname) 				/*
		*/ T(varname) 				/*
		*/ Level(cilevel) 			/*
		*/ Small VCE(string) ]

	if "`constant2'" != "" & "`varying'" != "" {
		di as err ///
		"may not specify both {bf:constant()} and {bf:varying()}"
		exit 198
	}

	local typelist varlist endog 
	local inlist : list endog in varlist
	if !`inlist' {
		di as err "some variables specified in {bf:endog()} not " /*
			*/ "included in main variable list"
		exit 198
	} 

	if "`constant2'" != "" {
		local typelist `typelist' constant2
		local inlist : list constant2 in varlist
		if !`inlist' {
			di as err "some variables specified in " /*
				*/ "{bf:constant()} not " /*
				*/ "included in main variable list"
			exit 198
		} 
	}
	if "`varying'" != "" {
		local typelist `typelist' varying
		local inlist : list varying in varlist
		if !`inlist' {
			di as err "some variables specified in " /*
				*/ "{bf:varying()} not " /*
				*/ "included in main variable list"
			exit 198
		} 
	}
	
	local fullist		/* full variable list */
	foreach type of local typelist {
		local `type' : list uniq `type'
		tsunab `type' : ``type''
		local fullist : list fullist | `type'
	}

	gettoken yvar xzlist : fullist

	tempvar wt
	if "`weight'" != "" {
		qui gen double `wt' `exp'
		local wtopt "[`weight'=`wt']"
	}
	else {
		qui gen byte `wt' = 1
	}

	tempvar touse
	mark `touse' `if' `in' `wtopt'
	markout `touse' `xzlist' 

	if "`amacurdy'" != "" {
		_xt, i(`i') t(`t') trequired
		local tsdeltaopt delta(`=r(tdelta)')
		local tsfmt : format `r(tvar)'
	}
	else {
		_xt, i(`i') t(`t')
	}
	local ivar "`r(ivar)'"
	local tvar "`r(tvar)'"
	
	////////////////////// Parsing vce options ////////////////////
	
	local nvce: list sizeof vce
	local siclust = 0
	tempvar cuentas1

	if ("`vce'"=="conventional") {
		local nvce = 0
	}
	
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
		quietly egen `cuentas1' = group(`clustervar')
		quietly sum `cuentas1'
		local cuentas = r(max)
		local clust = e(clustervar)
		local var = e(var)
		local tvce cluster
		local type Robust
		_xtreg_chk_cl2 `clustervar' `ivar'
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
	
	if "`amacurdy'" != "" {
		tempvar first_t diff
		sort `touse' `ivar' `tvar', stable
		qui by `touse' `ivar': gen byte `first_t' = (_n==1 & `touse')
		qui bys `touse' `first_t' : gen byte `diff' = `tvar' - /*
			*/ `tvar'[_n-1] if _n>1 & `first_t' 
		summ `diff' if `first_t', meanonly
		if r(max)!=0 | r(min)!=0 {
			di as err "All panels must start at the " /*
				*/ "same time period"
			exit 198
		}

		qui tsset `ivar' `tvar', `tsdeltaopt' `tsfmtopt' noquery
		tsreport if `touse', report panel
		if r(N_gaps) != 0 {
			di as err "gaps are not allowed with {bf:amacurdy}"
			exit 198
		}

		if "`weight'" != "" {
			di as err "weights are not allowed with {bf:amacurdy}"
			exit 198
		}
	}

				/* parse variables */
	CheckVar `ivar' `"`tvar'"' `touse' `xzlist'
	local constant2_c `s(invariant)'
	local varying_c `s(varying)'


	if "`constant2'" != "" {
		local diff : list constant2 - constant2_c 
		if "`diff'" != "" {
			di as err "{bf:`diff'} not time invariant in panels."
			exit 198
		}
		local diff : list constant2_c - constant2 
		if "`diff'" != "" {
			di as err ///
			"{bf:`diff'} not included in {bf:constant()}."
			exit 198
		}
	}
	if "`varying'" != "" {
		local diff : list  varying - varying_c
		if "`diff'" != "" {
			di as err "`diff' not time varying in panels." 
			exit 198
		}
		local diff : list  varying_c - varying
		if "`diff'" != "" {
			di as err ///
			"{bf:`diff'} not included in {bf:varying()}."
			exit 198
		}
	}

	local exog : list xzlist - endog
	local xvar1 : list exog - constant2_c
	local xvar2 : list endog - constant2_c 
	local zvar1 : list exog - varying_c
	local zvar2 : list endog - varying_c

				/* check collinearity */
	local nvar : word count `xzlist'
	_rmcoll `xzlist' `wtopt' if `touse', `constant'
	local xzlist `"`r(varlist)'"'

	local vartype : set type
	set type double
	local names
	foreach type in xvar1 xvar2 zvar1 zvar2  {
		local `type' : list `type' & xzlist
		local names `names' ``type''
		local `type'names ``type''
		tsrevar ``type''
		local `type' `r(varlist)'
		markout `touse' ``type''
	}
	local yname `yvar'
	tsrevar `yvar'
	local yvar `r(varlist)'
	markout `touse' `yvar'
	set type `vartype'

	local ok = 1
	if "`xvar1'" == "" {
		di as err "There are no time-varying exogenous " /*
			*/ "variables in the model."
		local ok = 0
	} 

	if "`zvar1'" == "" {
		di as err "There are no time-invariant exogenous " /*
			*/ "variables in the model."
		local ok = 0
	} 

	if !`ok' {
		di as err "If you have those variables specified, " /*
			*/ "they may have been " /*
			*/ "removed because of collinearity."
		exit 198
	}

	sort `touse' `ivar', stable	/* _crcchkw needs to sorted by this 
					   order, but previous commands needs 
					   the order to be -by ivar tvar-
					   to handle time-series operators
					*/
				/* check fweights */
	if "`weight'" == "fweight" {
 		_crcchkw `ivar' `wt' `touse'
	}

				/* check conditions */
	local k1 : word count `xvar1'
	local k2 : word count `xvar2'
	local g2 : word count `zvar2'
	local k = `k1' + `k2'

	if `k1' < `g2' & "`amacurdy'" == ""  {
		di as err "The model is underidentified (k1<g2)"
		exit 198
	}

	quietly {
				/* count T_i, summarize */
		tempvar Ti
		by `touse' `ivar': gen double `Ti' = sum(`touse')
		by `touse' `ivar': replace `Ti' = . if _n!=_N
		summ `Ti' `wtopt'  if `Ti'!=0 & `Ti'<., meanonly
		local Ng = r(N)			/* # of panels */
		local N = r(sum_w)		/* weighted counts */

		summ `Ti' if `Ti'>0, meanonly
		local Tmax = r(max)
		local Tmin = r(min)
		local Tavg = r(mean)

		if `Tmax'*`k1' < `g2' & "`amacurdy'" != "" {
			di as err "The model is " /*
				*/ "underidentified (T*k1<g2)"
			exit 198
		}	

		tempname Tbar
		if `Tmax' == `Tmin' {
			local isT_cons 1	/* balanced */
			by `touse' `ivar': replace `Ti' = cond(`touse', /*
				*/ `Ti'[_N], .)
			scalar `Tbar' = `Tmax'
		}
		else {
			if "`amacurdy'" != "" {
				di as err "{bf:amacurdy} only works with " /*
					*/ "balanced data"
				exit 198
			}

			local isT_cons 0	/* unbalanced */
			tempvar T_inv
			by `touse' `ivar': gen double `T_inv'=1/`Ti'
			summ `T_inv', meanonly
			scalar `Tbar' = 1/r(mean)
			by `touse' `ivar': replace `Ti' = cond(`touse', /*
				*/ `Ti'[_N], .)
		}

				/* within transformation */
		local list "yvar xvar1 xvar2"
		foreach var of local list {
			local k = 1
			foreach i of local `var' {
					/* 
					   `var'`k'_m = Xbar, the mean of X
					   `var'`k'_dm = X - Xbar 
					   note: using `k' instead of original
						 variable name to avoid the
						 case that a name is too long
					*/
				tempvar `var'`k'_m `var'`k'_dm

				by `touse' `ivar': gen double ``var'`k'_m' = /*
					*/ sum(`i') 
				by `touse' `ivar': replace ``var'`k'_m' = /*
					*/ ``var'`k'_m'[_N]/`Ti'
				by `touse' `ivar': gen double ``var'`k'_dm' = /*
					*/ `i'-``var'`k'_m' if `touse'
				local `var'_m ``var'_m' ``var'`k'_m'
				local `var'_dm ``var'_dm' ``var'`k'_dm' 
				local k = `k'+1
			}
		}

					/* obtain within-estimator */
		reg `yvar_dm' `xvar1_dm' `xvar2_dm' `wtopt' /*
			*/ if `touse', nocons
		local n = e(N)
				
		tempname b_w V_w
		mat `b_w' = e(b)

				/* estimate sigma_v^2 */
		tempname sigmaV2
		scalar `sigmaV2' = e(rss)/(`n'-`N')

				/* generate d_i=ybar_i-xbar_i*b_within 
				   trick -mat score- to use xbar_i 

				   note: if some transformed covariates 
				   are dropped from OLS regression, the 
				   corresponding coefficient will be set as
				   zero, so won't affect -mat score-. 
				*/
		tempvar xbm_w xb_w res res2 zg di
		local newnames `xvar1_m' `xvar2_m'
		mat colnames `b_w' = `newnames'
		mat score double `xbm_w' = `b_w' if `touse'
		gen double `di' = `yvar_m' - `xbm_w'

		local newnames `xvar1' `xvar2'
		mat colnames `b_w' = `newnames'
		mat score double `xb_w' = `b_w' if `touse'

				/* estimate sigma_1^2 */
		reg `di' `zvar1' `zvar2' (`xvar1' `zvar1') `wtopt' /*
			*/ if `touse'
		predict double `zg', xb

		gen double `res' = `yvar' - `xb_w' - `zg' if `touse'
		by `touse' `ivar': gen double `res2' = sum(`res') /*
			*/ if `touse'
		by `touse' `ivar': replace `res2' = (`res2'[_N]/`Ti'[_N])^2
		summ `res2' `wtopt', meanonly 
		tempname sigma12 sigmaU2
		scalar `sigma12' = r(sum)/`N'

				/* Generate theta=sigma_u/sigma_1 */
		scalar `sigmaU2' = cond( ((`sigma12'-`sigmaV2')/`Tbar') > 0, /*
			*/ (`sigma12'-`sigmaV2')/`Tbar', 0 )
		if `isT_cons' {
			tempname theta 
			if `sigmaU2' == 0 { 
				scalar `theta' = 0 
			}
			else { 
				scalar `theta' = 1 - /*
					*/ sqrt(`sigmaV2'/`sigma12') 
			}
		}
		else {
			tempvar theta
			if `sigmaU2' == 0 { 
				gen byte `theta' = 0 
			}
			else { 
				gen double `theta' = 1 - /*
					*/ sqrt(`sigmaV2'/(`Ti'*`sigmaU2' /*
					*/ +`sigmaV2')) if `touse' 
			}
		}

				/* GLS transformation */
		tempvar yvar_g
		gen double `yvar_g' = `yvar' - `theta'*`yvar_m' if `touse'
		local list "xvar1 xvar2 zvar1 zvar2"
		foreach var of local list {
			local k = 1
			foreach i of local `var' {
				tempvar `var'`k'_g
				if "`var'"!="zvar1" & "`var'"!="zvar2" {
					gen double ``var'`k'_g' = `i' /*
						*/ - `theta'*``var'`k'_m' /*
						*/ if `touse'
				}
				else {
					gen double ``var'`k'_g' = `i' /*
						*/ - `theta'*`i' /*
						*/ if `touse'
				}
				local list_g `list_g' ``var'`k'_g'
				local k = `k' + 1
			}
		}

				/* transform constant-term */
		if "`constant'" == "" {
			tempvar g_cons
			gen double `g_cons' = 1 -`theta'
			local names `names' "_cons"
		}

		if "`amacurdy'" == "" {		/* Hausman-Taylor estimator */
			local title "Hausman-Taylor"
			
			if (`siclust'>0) {
				tempvar modebase
				reg `yvar_g' `list_g' `g_cons'  	/*
				*/ (`xvar1_dm' `xvar2_dm' 		/*
				*/ `xvar1_m' `zvar1' `g_cons') `wtopt' 	/*
				*/ if `touse', nocons 
				matrix `modebase' = e(V)
			}
			if (`siclust'==0) {
				reg `yvar_g' `list_g' `g_cons'  	/*
				*/ (`xvar1_dm' `xvar2_dm' 		/*
				*/ `xvar1_m' `zvar1' `g_cons') `wtopt' 	/*
				*/ if `touse', nocons 
			}
			if (`siclust'==1) {
				reg `yvar_g' `list_g' `g_cons'  	/*
				*/ (`xvar1_dm' `xvar2_dm' 		/*
				*/ `xvar1_m' `zvar1' `g_cons') `wtopt' 	/*
				*/ if `touse', nocons cluster(`clust')
				local Ngc = e(N_clust)
			}
			if (`siclust'==2) {
				reg `yvar_g' `list_g' `g_cons'  	/*
				*/ (`xvar1_dm' `xvar2_dm' 		/*
				*/ `xvar1_m' `zvar1' `g_cons') `wtopt' 	/*
				*/ if `touse', nocons cluster(`ivar')
			}
		}
		else {				/* Amemiya-MaCurdy estimator */
			local title "Amemiya-MaCurdy"

				/* note: for balanced panels only. 
				   If want to handle unbalanced data with gaps, 
				   -tsfill- may be used 
				   to fill in the missing time-periods */

			sort `touse' `ivar' `tvar', stable

			local k = 1
			foreach var of local xvar1 {
				forvalues i=1/`Tmax' {
					tempvar xvar1`k'_T`i'
					by `touse' `ivar': gen double /*
						*/ `xvar1`k'_T`i'' = /*
						*/ `var'[`i'] if `touse'

					local xvar1s `xvar1s' `xvar1`k'_T`i''
					local k = `k' + 1
				}
			}
			
			if (`siclust'>0) {
				tempvar modebase
				reg `yvar_g' `list_g' `g_cons'		/*
				*/ (`xvar1_dm' `xvar2_dm' 	/*
				*/ `xvar1s' `zvar1' `g_cons') 	/*
				*/ if `touse', nocons
				 matrix `modebase' = e(V)
			}
			
			if (`siclust'==0) {
				reg `yvar_g' `list_g' `g_cons'		/*
				*/ (`xvar1_dm' `xvar2_dm' 	/*
				*/ `xvar1s' `zvar1' `g_cons') 	/*
				*/ if `touse', nocons
			}
			if (`siclust'==1) {
				reg `yvar_g' `list_g' `g_cons'		/*
				*/ (`xvar1_dm' `xvar2_dm' 	/*
				*/ `xvar1s' `zvar1' `g_cons') 	/*
				*/ if `touse', nocons cluster(`clust')	
				local Ngc = e(N_clust)		
			}
			if (`siclust'==2) {
				reg `yvar_g' `list_g' `g_cons'		/*
				*/ (`xvar1_dm' `xvar2_dm' 	/*
				*/ `xvar1s' `zvar1' `g_cons') 	/*
				*/ if `touse', nocons cluster(`ivar')			
			}
		}

				/* obtain F-statistic */
		tempname F df df_r
		if "`constant'"=="" {
			test `list_g' 
			scalar `F' = r(F)
			scalar `df' = r(df)
			scalar `df_r' = r(df_r)
		}
		else {
			scalar `F' = .
			scalar `df' = e(df_m)
			scalar `df_r' = e(df_r)
		}

				/* repost estimates with original varnames */
		tempname b V chi2
		local nobs = e(N)
		mat `b' = e(b)
		mat `V' = e(V)

				/* correct number of obs. when iweighted */
		if "`weight'" == "iweight" {
			count if e(sample)==1
			local nobs = r(N)
		}

		mat colnames `b' = `names'
		mat rownames `V' = `names'
		mat colnames `V' = `names'
		_ms_op_info `b'
		if r(tsops) {
			quietly tsset, noquery
		}
		eret post `b' `V',	depname(`yname')	///
					obs(`nobs')		///
					esample(`touse')	///
					buildfvinfo
		_post_vce_rank

		tempname sigmaV sigmaU
		scalar `sigmaV' = sqrt(`sigmaV2')
		scalar `sigmaU' = sqrt(`sigmaU2')
		eret scalar sigma_u = `sigmaU'
		eret scalar sigma_e = `sigmaV'
		eret scalar rho     = `sigmaU'^2/(`sigmaU'^2+`sigmaV'^2)

		eret scalar Tbar    = `Tbar'
		eret scalar Tcon    = `isT_cons'
		eret scalar N_g     = `Ng'
		eret scalar N_clust = `Ng'
		
		if "`small'" != "" {
			eret scalar df_r = `df_r'
		}
		if `siclust'==0 {
			eret scalar df_m = `df'
			eret scalar F = `F'
			eret scalar chi2 = `F'*`df'
			eret local chi2type "Wald"
		}
		if `siclust'==1 {
			tempname chi2
			eret scalar df_m = `df'
			mat `chi2'       = e(b)*syminv(e(V))*e(b)'
			eret scalar chi2 = trace(`chi2')
			eret local chi2type "Wald"
			eret scalar N_clust = `Ngc'
		}
		if `siclust'==2 {
			tempname chi2
			eret scalar df_m = `df'
			mat `chi2'       = e(b)*syminv(e(V))*e(b)'
			eret scalar chi2 = trace(`chi2')
			eret local chi2type "Wald"
		}

		eret scalar g_min = `Tmin'
		eret scalar g_avg = `Tavg'
		eret scalar g_max = `Tmax'

		eret local TIendogenous "`zvar2names'"
		eret local TIexogenous "`zvar1names'"
		eret local TVendogenous "`xvar2names'"
		eret local TVexogenous "`xvar1names'"

		eret local wexp "`exp'"
		eret local wtype "`weight'"
		if "`amacurdy'"!="" {
			eret local tvar "`tvar'"
		}

		if `siclust'== 1 {
			eret local vce "cluster"
			eret local vcetype "Robust"
			eret local clustvar "`clustervar'"
			mat colnames `modebase' = `names'
			mat rownames `modebase' = `names'
			mat colnames `modebase' = `names'
			eret matrix V_modelbased = `modebase'
		}
		
		if `siclust'== 2 {
			eret local vce "robust"
			eret local vcetype "Robust"
			eret local clustvar "`ivar'"
			mat colnames `modebase' = `names'
			mat rownames `modebase' = `names'
			mat colnames `modebase' = `names'
			eret matrix V_modelbased = `modebase'
		}
		
		if `siclust'== 0 {
			eret local vce "conventional"
		}

		eret local ivar "`ivar'"
		eret local depvar "`yname'" 
		eret local predict "xtht_p"
		eret local title "`title'"
	}
	
	Replay, level(`level') 
	eret local cmd "xthtaylor"
end


program define Replay				/* DISPLAY */
	syntax [, Level(cilevel)]

	cap confirm integer number `e(g_avg)'
	if _rc == 0 {
		local avgfmt "%10.0f"
	}
	else {
		local avgfmt "%10.1f"
	}

	if `"`e(title)'"' == "Amemiya-MaCurdy" {
		local disp_t /*
		   */ as txt "Time variable: " as res abbrev("`e(tvar)'",12)
	}

	#delimit ;
	di _n as text `"`e(title)' estimation"' 
		_col(49) "Number of obs" _col(67) "=" 
		_col(69) as res %10.0fc e(N) ;
	di as text "Group variable: " in ye abbrev("`e(ivar)'",12) in gr
		_col(49) "Number of groups" _col(67) "="
		_col(69) as res %10.0fc e(N_g) _n ;
	di `disp_t' as txt 
		_col(49) "Obs per group:" ;
	di as txt
		_col(63) "min" _col(67) "="
		_col(69) as res %10.0g e(g_min) ;
	di as txt 
		_col(63) "avg" _col(67) "="
		_col(69) as res `avgfmt' e(g_avg) ;
	di as txt
		_col(63) "max" _col(67) "="
		_col(69) as res %10.0g e(g_max) _n ;
	#delimit cr

	if "`e(prefix)'" != "" & !missing(e(df_r)) {
		local model as txt _col(49) "F(" ///
			as res %4.0f e(df_m) as txt "," ///
			as res %7.0f e(df_r) as txt ")" ///
			_col(67) "=" _col(69) as res %10.2f abs(e(F))
		local pvalue _col(49) as txt "Prob > F" _col(67) "=" ///
			as res _col(73) %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		local model as txt _col(49) "Wald chi2(" ///
			as res e(df_m) as txt ")" ///
			_col(67) "=" _col(69) as res %10.2f e(chi2)
		local pvalue _col(49) as txt "Prob > chi2" _col(67) "=" ///
			as res _col(73) %6.4f chiprob(e(df_m),abs(e(chi2)))
	}

	di as txt "Random effects u_i ~ " as res "i.i.d." `model' 
	di `pvalue'
	
	display
	
	local a = "`e(N_clust)'"
	local b = string(`a',"%13.0gc")
	if (`"`e(vce)'"' == "cluster") {
		di ///
			as text "{ralign 78:(Std. Err. adjusted for " ///
			as result "`b'" as text " clusters in " ///
			"`e(clustvar)')}"
	}
	if  (`"`e(vce)'"'== "robust") {
		di ///
			as text "{ralign 78:(Std. Err. adjusted for " ///
			as result "`b'" as text " clusters in " ///
			"`e(clustvar)')}"	
	}

	if e(df_r) < . {
		local test t
	}
	else {
		local test z
	}

        local fullist `e(TVexogenous)' `e(TVendogenous)'
        local fullist `fullist' `e(TIexogenous)' `e(TIendogenous)'
        local fullist : subinstr local fullist "." ".", count(local hasts)
	local yvar `e(depvar)'
	local hasts = `hasts' | index("`yvar'", ".")
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	di as txt "{hline 13}{c TT}{hline 64}"
	if `"`e(vcetype)'"' != "" {
		tempname Tab
		.`Tab' = ._tab.new, col(7) lmargin(0) ignore(.b)
		// column        1      2     3     4     5     6     7
		.`Tab'.width	13    |11    11     9     9    12    12
		.`Tab'.titlefmt  .   %11s  %12s   %7s     .  %24s     .
		local vcetype `"`e(vcetype)'"'
		if "`e(vce)'" == "bootstrap" {
			local obs "Observed"
			if "`e(vcetype)'" == "Bootstrap" {
				local citype "Normal-based"
			}
		}
		local ciwd : length local citype
		local vcewd : length local vcetype
		if `"`e(mse)'"' != "" {
			capture which `e(vce)'_`e(mse)'.sthlp
			local mycrc = c(rc)
			if `mycrc' {
				capture which `e(vce)'_`e(mse)'.hlp
				local mycrc = c(rc)
			}
			if !`mycrc' {
				local vcetype ///
				"{help `e(vce)'_`e(mse)'##|_new:`vcetype'}"
				local plus = `: length local vcetype' - `vcewd'
				local plus "+`plus'"
			}
		}
		if `vcewd' <= 12 {
			// NOTE: see the width and pad definitions of .`Tab'
			local vcewd = `vcewd'`plus' + ceil((12-`vcewd')/2+1)
		}
		if `ciwd' <= 27 {
			// NOTE: see the width and pad definitions of .`Tab'
			local ciwd = `ciwd' + ceil((27-`ciwd')/2)
		}
		// column        1       2             3   4  5          6  7
		.`Tab'.titlefmt  .       .     %`vcewd's   .  .   %`ciwd's  .
		.`Tab'.titles   "" "`obs'" `" `vcetype'"' "" "" "`citype'" ""
		.`Tab'.titlefmt  .       .          %12s   .  .       %24s  .
	}
	di as txt %12s abbrev("`yvar'", 12) " {c |}" /*
		*/ _col(21) "Coef." _col(29) "Std. Err." _col(44) "`test'" /*
*/ _col(49) "P>|`test'|" _col(`=61-`cil'') /*
*/ `"[`=strsubdp("`level'")'% Conf. Interval]"'
	di as txt "{hline 13}{c +}{hline 64}"


        foreach item in TVexogenous TVendogenous TIexogenous TIendogenous {
		if "`e(`item')'" != "" {
			local itemlist `itemlist' `item'
		}	
	}

        foreach item of local itemlist {
                di as res "`item'" as txt _col(14) "{c |}"
                local names `e(`item')'

					/* check time-series operators */
		if `hasts' {
			TS_names `"`names'"'
			local varnames `s(varnames)'
			local tsnames `s(tsnames)'

			local flag 1
			gettoken ts tsnames : tsnames
			gettoken var varnames : varnames
			gettoken fullname names : names
			while "`ts'" != "" {

				gettoken next_ts tsnames : tsnames
				gettoken next_var varnames : varnames

				if "`next_var'" == "`var'" & `flag' {
					/* there may be several 
					   lagged/differenced variables 
					   associated with the same variable,
					   such as L1/3.x; this is the 
					   first of them appeared */
					di as txt %12s abbrev("`var'", 12) /*
						*/ " {c |}" 
					local flag 0
				}
				if "`next_var'" == "`var'" /*
					*/ | "`pre_var'" == "`var'" {
					if "`ts'" == "0" {
						dispVar "--." `level' `fullname'
					}
					else {
						dispVar "`ts'." `level' /*
							*/ `fullname'
					}

					if "`next_var'" != "`var'" {
						local flag 1
					}
				}
				else {			/* next_var != var */
					if "`ts'" != "0" {
						di as txt %12s /*
							*/ abbrev("`var'", 12)/*
							*/ " {c |}" 
						dispVar "`ts'." `level' /*
							*/ `fullname'
					}
					else {
						dispVar `var' `level' /*
							*/ `fullname'
					}
				}

				local pre_var `var'
				local ts `next_ts'
				local var `next_var'
				gettoken fullname names : names
			}
		}	
		else {
			foreach var of local names {
				dispVar `var' `level' `var'
			}
		}
	}

	tempname b 
	mat `b' = e(b)
	local names : colnames(`b')
	local names : subinstr local names "_cons" "_cons", word /*
		*/ count(local hascons)
	if `hascons' {
		di as txt _col(14) "{c |}"
		dispVar _cons `level' _cons 
	}

	di as txt "{hline 13}{c +}{hline 64}"

	di as txt "     sigma_u {c |} " as res %10.0g e(sigma_u)
	di as txt "     sigma_e {c |} " as res %10.0g e(sigma_e)
	di as txt "         rho {c |} " as res %10.0g e(rho) /*
		*/ as txt "   (fraction of variance due to u_i)"
	di as txt "{hline 13}{c BT}{hline 64}"

        di "Note: " as res "TV" as txt " refers to time varying; " _c
        di as res "TI" as txt " refers to time invariant."
					/* DISPLAY end */
	_prefix_footnote
end


program define dispVar
	local name `1'
	local level `2'
	local var `3'
	tempname p ll ul	

	if e(df_r) < . {
		scalar `p' = 2*ttail(e(df_r), /*
			*/ abs(_b[`var']/_se[`var']))
		scalar `ll' = _b[`var'] - invttail(e(df_r), /*
			*/ (100-`level')/200)*_se[`var']
		scalar `ul' = _b[`var'] + invttail(e(df_r), /*
			*/ (100-`level')/200)*_se[`var']
	}
	else {
		scalar `p' = 2*norm(-abs(_b[`var']/_se[`var']))
		scalar `ll' = _b[`var'] - /*
			*/ invnorm(0.5+`level'/200)*_se[`var'] 
		scalar `ul' = _b[`var'] + /*
			*/ invnorm(0.5+`level'/200)*_se[`var'] 
	}

	if "`name'" == "`var'" {
		local name = abbrev("`name'", 12)
	}
	di as txt %12s "`name'" " {c |}" 			/*
		*/ as res _col(17) %9.0g _b[`var'] 		/*
		*/ _col(28) %9.0g _se[`var'] 			/*
		*/ _col(39) %7.2f _b[`var']/_se[`var'] 		/*
		*/ _col(49) %5.3f `p' 				/*
		*/ _col(58) %9.0g `ll' 				/*
		*/ _col(70) %9.0g `ul'
end


program define CheckVar, sclass
	sreturn clear
	gettoken ivar 0 : 0			/* tosue */
	gettoken tvar 0 : 0
	gettoken smpl 0 : 0			/* panel variable */

				/* sort in this order to allow -ts- */
	sort `ivar' `tvar' `smpl', stable 
	tempvar Tcount
	qui by `ivar': gen long `Tcount' = sum(`smpl') if `smpl'
	qui by `ivar': replace `Tcount' = cond(`smpl', /*
		*/ `Tcount'[_N], .)

	local varying			/* time-varying variables */
	local invariant		/* time-invariant variables */
	foreach var of local 0 {
		tempvar diff junk
					/* to allow time-series operator */
		qui gen double `junk' = `var' if `smpl'
		qui by `ivar': gen double `diff' =	/*
			*/	sum(`junk')/sum(`smpl') - `junk' if `smpl'
		qui summ `diff' if `smpl', meanonly
			/* Precision issues => `diff' may not have a mean
			   of precisely zero, so we use a cushion here */
		if abs(r(min)) < 1e-12 & abs(r(max)) < 1e-12 {
			local invariant `invariant' `var' 
		}
		else {
			local varying `varying' `var'
		}
		drop `diff' `junk'
	}
	
	sreturn local invariant `invariant'
	sreturn local varying `varying'
end


program define TS_names, sclass
	sreturn clear
	args names
	
	local blank 0
	foreach var of local names {
		tokenize "`var'", parse(.)
		if "`2'" == "." {
			local varnames `varnames' `3'

			local ts `1'
						/* add "1" to the end  
						   such that "L" to "L1" */
			if `:length local ts' == 1 {
				local ts "`ts'1"
			}
			local tsnames `tsnames' `ts'
		}
		else {
			local varnames `varnames' `1'
			local tsnames `tsnames' `blank'
		}
	}

	sreturn local varnames `varnames'
	sreturn local tsnames `tsnames'
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
