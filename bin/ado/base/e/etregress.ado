*! version 1.3.2  19feb2019
program define etregress, eclass byable(onecall) properties(svyb svyj svyr)
	version 14.0
	local vv : di "version " string(_caller()) ":"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`vv' `BY' _vce_parserun etregress, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"etregress `0'"'
		exit
	}

	version 6.0, missing

	if replay() {
		if "`e(cmd)'" != "etregress" { error 301 } 
		if _by() { error 190 }
		if _caller() < 14 {
			_etregress_pre `0'
			exit
		}
		if "`e(method)'"== "twostep" {
			Display2 `0'
		}
		else if "`e(method)'" == "cfunction" {
			Display3 `0'
		}
		else {
			Display `0'
		}	
		exit
	}

	if _caller() < 14 {
		`vv' `BY' _etregress_pre `0'
		version 10: ereturn local cmdline `"etregress `0'"'
		exit
	}	
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"etregress `0'"'
end

program define Estimate, eclass byable(recall)
	version 6, missing
	gettoken dep 0 : 0 , parse(" =,[")
	_fv_check_depvar `dep'
	tsunab dep : `dep'
	
	local depstub = cond( match("`dep'", "*.*"),		/*
			*/ bsubstr("`dep'",			/*
			*/ 	  (index("`dep'",".")+1),.),	/*
			*/ "`dep'")
	confirm variable `depstub'

	gettoken equals rest : 0, parse(" =")

	if "`equals'" == "=" { local 0 `"`rest'"' }

				/* Primary */
	syntax [varlist(default=none ts fv)] [if] [in] [pw fw iw aw]   	/*
		*/ , TReat(string)   [ HAzard(string)			/* 
		*/ noConstant FIRst Level(cilevel)			/*
		*/ MLOpts(string) NOLOg LOg Robust  Cluster(varname)	/*
		*/ TWOstep noSKIP/*undoc*/ LRMODEL 			/*
		*/ SCore(passthru) FROM(string) 		/*
		*/ VCE(passthru) ITERate(string) POutcomes CFUNCtion * ]
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if `"`from'"' != "" {
		opts_exclusive "`twostep' from()"
	}
	if "`twostep'" != "" {
		_vce_parse, optlist(CONVENTIONAL) :, `vce'
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")
		capture assert "`cfunction'" == ""
		if (_rc) {
			opts_exclusive "`twostep' cfunction"			
		}
		capture assert "`poutcomes'" == "" 
		if (_rc) {
			opts_exclusive "`twostep' poutcomes"
		}
	}
	else if `"`vce'"' != "" {
		if ("`cfunction'" == "")  {
			local options `"`options' `vce'"'
		}
		qui capture qui _vce_parse, argoptlist(CLuster):, `vce'
		local clvar `r(cluster)'
	}
				/* set up command options */

	local ind `varlist'
	local if0 `if'
	local in0 `in'
	local option0 `options'
	local nc `constant'
	local wtype `weight'
	local wtexp `"`exp'"'
	if "`weight'" != "" { local wgt `"[`weight'`exp']"'  }
	
	if ("`weight'" == "pweight" | "`cluster'" != "") | "`cfunction'" != "" {
		local robust "robust"
	}

	if "`hazard'" != "" { confirm new var `hazard' }
	if "`cluster'" != "" { local clusopt "cluster(`cluster')" }

				/* Parse ML options */

	_get_diopts diopts option0, `option0'
	mlopts stdopts, `option0'
	local coll `s(collinear)'
	local constr `s(constraints)'
	opts_exclusive "`coll' `twostep'"

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	local logtrue "`s(nolog)'`s(log)'"
	if "`log'" == "" {
		local showlog noisily
	}
	else local showlog quietly
	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constan' constraints(`constr')	///
			options(`twostep' `cfunction' `clusopt' `robust') ///
			indep(`dep')
		local skip "noskip"
	}
        else if "`skip'" != "" {
                if "`robust'" != "" {
di in blue "model LR test inappropriate with robust covariance estimates"
			local skip
                }
                if "`constan'" != "" {
di in blue "model LR test inappropriate with noconstant option"
                        local skip
                }
                if "`ind'" == "" {
di in blue "model LR test inappropriate with constant-only model"
                      local skip
                }
                if "`twostep'" != "" {
di in blue "model LR test inappropriate for two-step model"
                       local skip
                }
                if "`skip'" == "" {
                       di in blue "    performing Wald test instead"
		}
	}

				/* Process selection equation */
	tokenize `"`treat'"', parse(" =")
	if "`2'" ~= "=" {
		di in red "invalid syntax"
		exit 198
	}
	_fv_check_depvar `1'
	tsunab 1 : `1'
	local trtdep `1'
	local 1 " "
	local 2 " "
	local 0 `*'
	syntax [varlist(default=none ts fv)] [, noConstant ] 			

	if !`fvops' {
		local fvops = "`s(fvops)'" == "true"
	}

	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}

				/* set up selection eq options */
	local trtind `varlist'
	local trtnc `constant'
        if "`skip'" != "" {
                if "`constan'" != "" {
di in blue "model LR test inappropriate with noconstant option"
                        local skip
                }
	} 
				/* ensure valid selection eq */
	if "`trtnc'" != "" & "`trtind'" ==""{
		noi di in red "no variables specified for treatment" 
		exit 198
	}

				/* ensure valid main eq */
	if "`nc'" != "" & "`ind'" == "" {
		noi di in red "no variables specified for primary equation"
		exit 198
	}

				/* mark sample */

	tempname touse 
	mark `touse' `wgt' `if0' `in0'
	markout `touse' `dep' `ind' `trtdep' `trtind' `clvar'

				/* ensure trtvar are bivariate 1 0 */
	tempname val1 val2
	qui sum `trtdep' if `touse' 
	if r(N) == 0 {         
		di in red "no observations for treatment equation"
		exit 198
	}
	scalar `val1' = r(min)
	scalar `val2' = r(max)
	if `val1' == `val2' {
		di in red "treatments do not vary"
		exit 2000
	}

	qui count if  `trtdep' != 1 & `trtdep' != 0 & `touse'
	if r(N) != 0 {
		di in red "invalid treatment values. only 0 and 1 are allowed"
		exit 450 
	}
	 
				/* test collinearity */
	qui `vv' ///
	_rmcoll `trtind' `wgt' if `touse', `trtnc' `coll'
	local trtind "`r(varlist)'"
	qui `vv' ///
	_rmdcoll `dep' `ind' `wgt' if `touse', `nc' `coll'
	local ind "`r(varlist)'"

				/* model estimation */
	local forml
	if ("`cfunction'`twostep'" == "") {
		local forml forml
	}	
	if ("`forml'`twostep'" != "") {
		tempname llprob		
	}
	tempname llprob
	if ("`twostep'" != "") {
		`vv' ///
		TwoStep "`dep'" "`ind'" "`nc'" "`trtdep'" "`trtind'" /*
			*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"     /*
			*/ `touse' "`first'" "`hazard'"  "`robust'"
		scalar `llprob' = e(ll_p)
	}
	else { 
		local qcfunc
		if ("`cfunction'" == "") {
			local qcfunc qui
		}

		if ("`cfunction'" != "") {
			// make sure we allow only the options we need
			capture assert "`mlopts'`stdopts'" == ""
			if _rc {			
				local 0 `", `mlopts'`stdopts'"'
				syntax [, NOOPTION ]
				error 198
			} 
		}
		`vv' ///
		Cfunction "`robust'" "" "`dep'" "`ind'" "`nc'" /*
			*/ "`trtdep'" "`trtind'" /*
			*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"     /*
			*/ `touse' "`first'" "`hazard'"   /*
			*/ "`poutcomes'" "`cfunction'" "`from'" /*
			*/ "`forml'" "`llprob'" "`logtrue'" "`iterate'"
		if ("`cfunction'" != "") {
			`vv' Display3, level(`level') `diopts'	
			if ("`poutcomes'" == "") {
				Reparm
			}
			else {
				Reparm2
			}
			exit
		}
		if ("`from'" == "") {
			tempname bcf
			matrix `bcf' = e(b)
			local top = 2 + 2*("`poutcomes'"!="")
			if abs(tanh(`bcf'[1,colsof(`bcf')-1])) > .99 {
				matrix `bcf'[1,colsof(`bcf')-1] = 0		
			}
			if inlist(exp(`bcf'[1,colsof(`bcf')]),0,.) {
				matrix `bcf'[1,colsof(`bcf')] = 0
			}
			if (`top' == 4) {
				if abs(tanh(`bcf'[1,colsof(`bcf')-3])) > .99 {
					matrix `bcf'[1,colsof(`bcf')-3]=0
				}
				if inlist(exp(`bcf'[1,colsof(`bcf')-2]),0,.) {
					matrix `bcf'[1,colsof(`bcf')-2]=0
				}
			}
			local from `bcf',copy
		}		
	}
	if "`twostep'" == "" {
		if ("`iterate'" != "") {
			local mli iterate(`iterate')
		}

		tempname b1 athrho lnsigma llreg
		local init init(`from')
		local hazard `e(hazard)'
		`vv' ///
		qui _regress `dep' `ind' `trtdep' `wgt' if `touse', `nc'
		scalar `llreg' = e(ll)
		if "`skip'" == "noskip" {
			tempname ji2
			capture `vv' ///
			Cfunction "`robust'" "tnot" "`dep'" "" /*
			*/ "`nc'" "`trtdep'" "`trtind'" /*
			*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"     /*
			*/ `touse' "`first'" "`hazard'"   /*
			*/ "`poutcomes'" "`cfunction'" "" /*
			*/ "`forml'"
			if (_rc) {
				exit _rc
			}
			tempname b0
			mat `b0' = e(b)
			local continu "continue"
			est clear
			`showlog' di
			`showlog' di in green "Fitting constant-only model:"
			`vv' ///
			Mmethod "tnot" "`dep'" "" "`nc'" "`trtdep'" 	    /*
				*/ "`trtind'" /*
				*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"    /*
				*/ `touse' "init(`b0', copy)"  "`robust'"   /*
				*/ "`clusopt'" "`logtrue'" "" "`stdopts'" /*
				*/ "`score'" "`poutcomes'" "`mli'"    
			`showlog' di
			`showlog' di in green "Fitting full model:"
		}
		`vv' ///
		Mmethod "" "`dep'" "`ind'" "`nc'" "`trtdep'" "`trtind'" /*
			*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"    /*
			*/ `touse' "`init'"  "`robust'"   /*		 
			*/ "`clusopt'" "`logtrue'" "`continu'" "`stdopts'" /*
			*/ "`score'" "`poutcomes'" "`mli'"
				/* comparison test */
		local hascns 0
		capture confirm matrix e(Cns)
		if !_rc {
			local hascns 1
		}
		if "`robust'" != "" | "`hascns'" == "1" | ///
		   "`e(vcetype)'" == "Robust" {
			est local chi2_ct "Wald"
			capture qui test _b[/athrho] = 0
			if (_rc) {
				qui `vv' test ///
				_b[/athrho0] = _b[/athrho1] = 0
			}
			est scalar chi2_c = r(chi2)
		}
		else {
			est local chi2_ct "LR"
			est scalar chi2_c = 2*(e(ll) - `llreg'- `llprob' )
		}
		if ("`poutcomes'" == "") {
			est scalar p_c = chiprob(1, e(chi2_c))
		}
		else {
			est scalar p_c = chiprob(2, e(chi2_c))
		}

		if ("`poutcomes'" == "") {
			Reparm
		}
		else {
			Reparm2
		}
		else {
			est local poutcomes `poutcomes'
		}
			
		est local title "Linear regression with endogenous treatment"
		est local title2 "Estimator: maximum likelihood"
		if "`hazard'" != "" { est local hazard "`hazard'" }
	}
	else {
		if `"`stdopts'"' != "" {
			// mlopts are not allowed with -twostep-
			local 0 `", `stdopts'"'
			syntax [, NOOPTION ]
			error 198		// [sic]
		}
		if "`robust'`cluster'`wgt'" != ""{
			di in red /*
			*/"robust, cluster(), and weights not allowed" /*
			*/ " with the twostep option"
			est clear 
			exit 198
		}

		est local title "Linear regression with endogenous treatment"
		est local title2 "Estimator: two-step"
		est local depvar `dep' `trtdep'
		est local vce "`vce'" 
		est local method "twostep" 
		est hidden local margins_prolog etreg_fix_stripe
		est hidden local margins_epilog etreg_restore_stripe
		est repost [`wtype'`wexp'], esample(`touse') buildfvinfo
	}
	if ("`twostep'" == "") {
		est local footnote "etreg_footnote"
	}
	if ("`twostep'" != "") {
		est local footnote "treatreg_footnote"
		est local predict "treatr_p"
	}
	else {
		est local predict "etregress_p"
	}
	est local cmd "etregress"	
	if "`twostep'" == "" {
		Display, level(`level') `diopts'
		est local marginsok "XB CTE YCTrt YCNTrt PTrt XBTrt default"
	}
	else {
		Display2, level(`level') `diopts'
	}
	
end

program define TwoStep, eclass
	version 6, missing
	local vv : di "version " string(_caller()) ":"
	args 		dep	/*
		*/	ind	/*
		*/	nc	/*
		*/	trtdep	/*
		*/	trtind	/*
		*/	trtnc	/*
		*/	wgt	/*
		*/	wtype	/*
		*/	wtexp	/*
		*/	touse	/*
		*/	first   /*
		*/	hazard	/*
		*/	robust

	if "`first'" != "" {local first noi }

	tempname bprb vprb bregx vreg breg llprob
	tempvar xbprb lambda tao

				/* Step1 -- probit */
	qui{
		`vv' ///
		`first' probit `trtdep' `trtind' `wgt' if `touse',  /*
			*/ nolog `trtnc' asis `robust' /*
			*/ iter(`=min(1000,c(maxiter))')
		mat `vprb' = get(VCE)
		mat `bprb' = get(_b)
		scalar `llprob' = e(ll)
		predict double `xbprb', xb
		gen double `lambda' = normd(`xbprb')/normprob(`xbprb') /*
			*/ if `trtdep' == 1 & `touse'
		replace  `lambda' = -normd(`xbprb')/(1-normprob(`xbprb')) /*
			*/ if `trtdep' == 0 & `touse'
		if "`hazard'" != "" { 
			capture drop `hazard'
			gen double `hazard' = `lambda' 
			label variable `hazard' ///
			"hazard from treatment equation"
		}
		gen double `tao' = `lambda'*(`lambda' + `xbprb')
	}
				/* Step 2 -- regress */
	
	qui{	
		if "`nc'" =="" {
			tempvar one
			gen byte `one' = 1
		}
		`vv' ///
	 	_regress `tao' `wgt' if `touse'
		local mtao = _b[_cons] 
		`vv' ///
		_regress `dep' `ind' `trtdep' `one' `lambda' `wgt' ///
			if `touse', noc 
		mat `breg' = get(_b) 
		mat `vreg' = get(VCE)
		local blambda _coef[`lambda']
		local sigma =sqrt(e(rss)/e(N) + `mtao'*`blambda'^2)
		local rho = `blambda'/`sigma'
		if `sigma' == 0 { local sigma = .001}
		if `rho' >= . { local rho = 0 }
		if abs(`rho') > 1 {
			local rho = `rho'/abs(`rho') 
		}
		local rho2= `rho'*`rho'
	}

				/* Cov adjustment */

	tempname  XsI Vbs F Q 
	if e(rmse) != 0 {
		matrix `XsI' = `vreg' / (e(rmse)^2)
	}
	else {
		di in red "insufficient information"
		exit 2000
	}

	fvexpand `ind' if `touse'
	local fulnam `r(varlist)'
	local fulnam "`fulnam' `trtdep'"
	fvexpand `trtind' if `touse'
	local trtind `r(varlist)'
	if "`nc'" == ""{
		tempvar one
		gen byte `one' = 1
		local fulnam "`fulnam' _cons"
	}
	local fulnam "`fulnam' lambda"
	local kreg : word count `fulnam'
	local kreg1 = `kreg' + 1
	qui mat accum `F' = `ind' `trtdep' `one' `lambda' (`trtind') /*
		*/ [iw = `tao'], `trtnc', if `touse'
	mat `F' = `F'[1.. `kreg', `kreg1' ...]
	`vv' ///
	mat rowname `F' = `fulnam'
	mat `Q' = `rho2'*`F'*`vprb'*`F''

 	tempvar rho2tao 
	qui gen double `rho2tao' = 1 - `rho2'*`tao' if `touse' 
	qui mat accum `Vbs' = `ind' `trtdep' `one' `lambda' [iw=`rho2tao'], /*
		*/ nocons, if `touse'
	mat `Vbs' = `sigma'^2 * `XsI' *(`Vbs' + `Q')*`XsI' 

				/* Build the eqn names */
	local eqnam 
 	local depn : subinstr local dep "." "_"
	tokenize `fulnam'
	local i 1
	while `i' < `kreg' {
		local eqnam `eqnam' `depn':``i''
		local i= `i' + 1
	}

	local trtname : subinstr local trtdep "." "_"
	local kprb : word count `trtind'
	local i 1
	tokenize `trtind'
	while `i' <= `kprb' {
		local eqnam `eqnam' `trtname':``i''
		local i = `i' + 1
	}
	if "`trtnc'" =="" {
		local kprb = `kprb' + 1
		local eqnam `eqnam' `trtname':_cons
	}
	local eqnam `eqnam' hazard:lambda
	 
	tempname bfull Vfull zeros Vmills CovMill zeroPrb b0 bmills
	local kreg0 = `kreg' -1
	mat `b0' = `breg'[1, 1..`kreg0']
	mat `bmills' = `breg'[1, `kreg']
	mat `bfull' = `b0', `bprb', `bmills'
	mat `Vmills' = `Vbs'[`kreg', `kreg']
	mat `CovMill' = `Vbs'[1..`kreg0', `kreg']
	mat `Vbs' = `Vbs'[1..`kreg0', 1..`kreg0']
	mat `zeros' = J(`kreg0', `kprb', 0)
	mat `zeroPrb' = J(`kprb', 1, 0)
	mat `Vbs' = /*
		*/ ( `Vbs'	, `zeros'	, `CovMill' \	/*
		*/   `zeros''	, `vprb'	, `zeroPrb'  \  /*
		*/   `CovMill'', `zeroPrb''	, `Vmills' )
	`vv' ///
	mat colnames `bfull' = `eqnam'
	`vv' ///
	mat rownames `Vbs' = `eqnam'
	`vv' ///
	mat colnames `Vbs' = `eqnam'

	qui count if `touse'
	version 11: ///
	ereturn post `bfull' `Vbs', obs(`r(N)')
	_post_vce_rank
	est scalar N = `r(N)'
	capture qui test `ind' `trtdep', min
	if _rc == 0 {
		est scalar chi2 = `r(chi2)'
		est scalar df_m = `r(df)'
		est scalar p    = `r(p)'
	}
	est local chi2type "Wald"
	if "`hazard'" !="" { est local hazard `hazard'}
	est scalar rho= `rho'
	est scalar sigma = `sigma'
	est scalar lambda = [hazard]_b[lambda]
	est scalar selambda = [hazard]_se[lambda]
	est hidden scalar ll_p = `llprob'
	est local marginsok "XB PTrt XBTrt default"
	est local marginsnotok "YCTrt YCNTrt"
end


program define Mmethod, eclass
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	else {
		local vv "version 8.1:"
	}
	version 6, missing
	args 		tnot	/*
		*/	dep	/*
		*/	ind	/*
		*/	nc	/*
		*/	trtdep	/*
		*/	trtind	/*
		*/	trtnc	/*
		*/	wgt	/*
		*/	wtype	/*
		*/	wtexp	/*
		*/	touse	/*
		*/	init	/*
		*/	robust	/*
		*/	clusopt	/*
		*/      log     /*
		*/ 	continu /*
		*/	stdopts	/*
		*/	score /*
		*/	poutcomes /*
		*/	iterate
	
	local depn : subinstr local dep "." "_"
	local trtdepn : subinstr local trtdep "." "_"
	local ind: list ind - trtdep
	if "`tnot'" == "" {
		fvexpand `ind' 1.`trtdep' if `touse'
	}
	else {
		fvexpand `ind' if `touse'
	}
	local ind `r(varlist)'
	fvexpand `trtind' if `touse'
	local trtind `r(varlist)'
	version 13
	nobreak {
		mata: _etregress_init("inits", "`trtdep'","`touse'") 
		capture noisily break {
		if ("`poutcomes'" == "") {
			`vv' noi  ml model lf2 _etregress_lf2()	/*
			*/ (`depn': `dep'=`ind',`nc') /*
			*/ (`trtdepn': `trtdep'=`trtind', `trtnc') /*
			*/ /athrho /lnsigma 				/*
			*/ if `touse' `wgt',				/*
			*/ userinfo(`inits')				/* 
			*/ `robust' `clusopt'				/*
			*/ collinear missing max nooutput nopreserve	/*
			*/ `init' search(off) `log' `continu'		/* 
			*/ `stdopts' `mlopts' `score' `iterate'		/*
			*/ diparm(athrho, tanh label("rho"))		/*
			*/ diparm(lnsigma, exp label("sigma"))		/*
			*/ diparm(athrho lnsigma,	     		/*
			*/ func( /*
			*/ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	*/ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	     */ label("lambda"))
			ereturn scalar k_eq = 4
			ereturn scalar k_aux = 2
		}
		else {
			`vv' noi ml model lf2 _etregress_lf2_2()	/*
			*/ (`depn': `dep'=`ind',`nc') /*
			*/ (`trtdepn': `trtdep'=`trtind', `trtnc') /*
			*/ /athrho0 /lnsigma0 /athrho1 /lnsigma1	/*
			*/ if `touse' `wgt',				/*
			*/ userinfo(`inits')				/* 
			*/ `robust' `clusopt'				/*
			*/ collinear missing max nooutput nopreserve	/*
			*/ `init' search(off) `log' `continu'		/* 
			*/ `stdopts' `mlopts' `score' `iterate'		/*
			*/ diparm(athrho0, tanh label("rho0"))		/*
			*/ diparm(lnsigma0, exp label("sigma0"))	/*
			*/ diparm(athrho0 lnsigma0,	     		/*
			*/ func( /*
			*/ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	*/ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	     */ label("lambda0")) /*
			*/ diparm(athrho1, tanh label("rho1"))		/*
			*/ diparm(lnsigma1, exp label("sigma1"))	/*
			*/ diparm(athrho1 lnsigma1,	     		/*
			*/ func( /*
			*/ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	*/ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
	     */ label("lambda1"))
			ereturn scalar k_eq = 6	
			ereturn scalar k_aux = 4
		}
		}
		ereturn hidden local dep `dep'
		ereturn hidden local trtdep `trtdep'
		ereturn hidden local ind `ind'
		ereturn hidden local trtind `trtind'
	}
	local erc = _rc
	mata: rmexternal("`inits'")
	if (`erc') {
		exit `erc'
	}

	version 6, `missing'
	est local method "ml"
	est hidden local marginsprop "nochainrule"
end	

program define Display2
	syntax [, level(cilevel) COEFLegend selegend *]
	local legend `coeflegend' `selegend'
	_get_diopts diopts, `options' `legend'
	local cfmt `"`s(cformat)'"'
	#delimit ;
	di in gr _n "`e(title)'" _col(49) "Number of obs"
		in gr _col(68) "="
		in ye _col(70) %9.0g e(N) ;

	local chifmt = cond(e(chi2)<1e+6,"%9.2f","%9.2e") ;
	if !missing(e(df_r)) { ;
		di in gr "`e(title2)'"_col(49) "F("
			in ye %4.0f e(df_m) in gr ","
			in ye %7.0f e(df_r) in gr ")"
			in gr _col(68) "="
			in ye _col(70) %9.2f e(F) ;
		di in gr _col(49) "Prob > F"
			in gr _col(68) "="
			in ye _col(73) %6.4f Ftail(e(df_m),e(df_r),e(F)) _n ;
	} ;
	else { ;
		di in gr "`e(title2)'" _col(49) "`e(chi2type)' chi2("
			in ye e(df_m) in gr ")"
			in gr _col(68) "="
			in ye _col(70) `chifmt' e(chi2) ;
		di in gr _col(49) "Prob > chi2"
			in gr _col(68) "="
			in ye _col(73) %6.4f chiprob(e(df_m),e(chi2)) _n ;
	} ;
	#delimit cr
	if `:length local legend' {
		_coef_table, level(`level') `diopts'
		exit
	}

	_coef_table, level(`level') plus `diopts'
	if c(noisily) == 0 {
		exit
	}
	if `"`cfmt'"' != "" {
		local rho	: display `cfmt' e(rho)
		local sigma	: display `cfmt' e(sigma)
	}
	else {
		local rho	: display %10.5f e(rho)
		local sigma	: display %10.0g e(sigma)
	}
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
        di in smcl in gr %`c's "rho" " {c |} " in ye %10s "`rho'"
        di in smcl in gr %`c's "sigma" " {c |} " in ye %10s "`sigma'"
	di in smcl in gr "{hline `c1'}{c BT}{hline `rest'}"

end

program define Reparm, eclass

			/* somewhat superseded by _diparm, but kept for
			 * lambda and so sigma and rho can be saved in e() */
	tempname b v d tau lns rho sig tmp lambda lamse
	mat `b' = get(_b)
	mat `v' = get(VCE)

	mat `tmp' = `b'[1,"/athrho"]
	scalar `tau' = `tmp'[1,1]
	mat `tmp' = `b'[1,"/lnsigma"]
	scalar `lns' = `tmp'[1,1]

	scalar `rho' = (expm1(2*`tau')) / (exp(2*`tau')+1)
	scalar `sig' = exp(`lns')
	scalar `lambda' = `rho'*`sig'

	mat `d' =  ( `sig'*4*exp(2*`tau')/(exp(2*`tau')+1)^2 , `lambda' )
	mat `v' =  (`v'["/athrho".."/lnsigma",      /*
		*/   "/athrho".."/lnsigma"]  )
	mat `v' = `d'*`v'*`d''
	scalar `lamse' = sqrt(`v'[1,1])

	est scalar rho    = `rho'
	est scalar sigma  = `sig'
	est scalar lambda = `lambda'
	est scalar selambda  = `lamse'
	/*  Double saves for backward compatibility */
	global S_1 = `rho'
	global S_2 = `sig'
	global S_3 = `lambda'
	global S_4 = `lamse'
end

program define Reparm2, eclass

			/* somewhat superseded by _diparm, but kept for
			 * lambda and so sigma and rho can be saved in e() */
	tempname b v d tmp tau0 lns0 rho0 sig0 lambda0 lam0se ///
	                   tau1 lns1 rho1 sig1 lambda1 lam1se
	mat `b' = get(_b)
	mat `v' = get(VCE)

	mat `tmp' = `b'[1,"/athrho0"]
	scalar `tau0' = `tmp'[1,1]
	mat `tmp' = `b'[1,"/lnsigma0"]
	scalar `lns0' = `tmp'[1,1]

	scalar `rho0' = (expm1(2*`tau0')) / (exp(2*`tau0')+1)
	scalar `sig0' = exp(`lns0')
	scalar `lambda0' = `rho0'*`sig0'

	mat `d' =  ( `sig0'*4*exp(2*`tau0')/(exp(2*`tau0')+1)^2 , `lambda0' )
	mat `v' =  (`v'["/athrho0".."/lnsigma0",      /*
		*/   "/athrho0".."/lnsigma0"]  )
	mat `v' = `d'*`v'*`d''
	scalar `lam0se' = sqrt(`v'[1,1])

	mat `b' = get(_b)
	mat `v' = get(VCE)

	mat `tmp' = `b'[1,"/athrho1"]
	scalar `tau1' = `tmp'[1,1]
	mat `tmp' = `b'[1,"/lnsigma1"]
	scalar `lns1' = `tmp'[1,1]

	scalar `rho1' = (expm1(2*`tau1')) / (exp(2*`tau1')+1)
	scalar `sig1' = exp(`lns1')
	scalar `lambda1' = `rho1'*`sig1'

	mat `d' =  ( `sig1'*4*exp(2*`tau1')/(exp(2*`tau1')+1)^2 , `lambda1' )
	mat `v' =  (`v'["/athrho1".."/lnsigma1",      /*
		*/   "/athrho1".."/lnsigma1"]  )
	mat `v' = `d'*`v'*`d''
	scalar `lam1se' = sqrt(`v'[1,1])


	est scalar selambda0  = `lam0se'
	est scalar rho0    = `rho0'
	est scalar sigma0  = `sig0'
	est scalar lambda0 = `lambda0'

	est scalar selambda1  = `lam1se'
	est scalar rho1    = `rho1'
	est scalar sigma1  = `sig1'
	est scalar lambda1 = `lambda1'

end


program define Display
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	ml display, level(`level') nofootnote `diopts'	
	version 9.1: _prefix_footnote
end 

program define DiLambda
	args level

	tempname z lb ub

	scalar `z' = invnorm((100 + `level') / 200)
	scalar `lb' = e(lambda) - `z'*e(selambda)
	scalar `ub' = e(lambda) + `z'*e(selambda)

	local llb : di %9.0g `lb'
	if length("`llb'") > 9 {
		local lbfmt "%8.0g"
	}
	else	local lbfmt "%9.0g"

	local uub : di %9.0g `ub'
	if length("`uub'") > 9 {
		local ubfmt "%8.0g"
	}
	else	local ubfmt "%9.0g"

	di in smcl in gr _col(3) "    lambda {c |}  " /*
		*/  in ye %9.0g e(lambda) "  " %9.0g e(selambda)    /*
		*/  _col(58) `lbfmt' `lb' "   "  `ubfmt' `ub'

end

program define Cfunction, eclass
	version 13
	//, missing
	local vv : di "version " string(_caller()) ":"
	args    	robust	/*
		*/	tnot	/*
		*/	dep	/*
		*/	ind	/*
		*/	nc	/*
		*/	trtdep	/*
		*/	trtind	/*
		*/	trtnc	/*
		*/	wgt	/*
		*/	wtype	/*
		*/	wtexp	/*
		*/	touse	/*
		*/	first	/*
		*/	hazard	/*
		*/	poutcomes /*
		*/	cfunction /*
		*/	from	/*
		*/	forml	/*
		*/	llprob  /*
		*/      log	/*
		*/	iterate 
	tempvar xbprb lambda lambda0 lambda1 nolres
	tempname probitb
	local cvmi
	if "`iterate'" != "" {
		local cvmi conv_maxiter(`iterate')
	}
	if "`first'" != "" { 
		local first noi
	}
	else {
		local first qui
	}	
	qui {
		if ("`tnot'" == "") {
			local ind: list ind - trtdep
			fvexpand `ind' 1.`trtdep' if `touse'
		}
		else {
			fvexpand `ind'
		}
		local ind `r(varlist)'
		fvrevar `ind'
		local find `r(varlist)'
		fvexpand `trtind' if `touse'
		local trtind `r(varlist)'
		fvrevar `trtind'	
		local ftrtind `r(varlist)'
		local noind
		local nofind
		local i = 1
		local frominlist 
		foreach word of local ind {
			_ms_parse_parts `word'
			if !`r(omit)' {
				local noind `noind' `word'
				local a: word `i' of `find'
				local nofind `nofind' `a'
				local frominlist `frominlist',`i'
			}
			local i = `i' + 1
		}
		local j = `i'
		if ("`nc'" != "noconstant") {
			local frominlist `frominlist',`j'
			local j = `j' + 1
		}
		local notrtind
		local noftrtind
		local i = 1
		foreach word of local trtind {
			_ms_parse_parts `word'
			if !(`r(omit)') {
				local notrtind `notrtind' `word'
				local a: word `i' of `ftrtind'
				local noftrtind `noftrtind' `a'
				local frominlist `frominlist',`j'
			}
			local i = `i' + 1
			local j = `j' + 1
		}
		if ("`treatnc'" != "noconstant") {
			local frominlist `frominlist',`j'
			local j = `j' + 1
		}
	}
	if ("`wtype'" == "aweight") {
		tempvar normwt
                qui gen double `normwt' `wtexp' if `touse'
                qui summ `normwt' if `touse', mean                   
                qui replace `normwt' = r(N)*`normwt'/r(sum)
		`vv' ///
		`first' probit `trtdep' `noftrtind' ///
			[iw=`normwt'] if `touse',  /*
			*/ nolog `trtnc' `robust' asis /*
			*/ iter(`=min(1000,c(maxiter))')
	}
	else {
		`vv' ///
		`first' probit `trtdep' `noftrtind' ///
			`wgt' if `touse',  /*
			*/ nolog `trtnc' `robust' asis /*
			*/ iter(`=min(1000,c(maxiter))')
	}
	if "`llprob'" != "" {
		scalar `llprob' = e(ll)
	}
	if ("`from'" != "" & "`forml'" != "") {
		exit
	}
	local noindnamed
	foreach var of local noind {
		local noindnamed `noindnamed' `dep':`var'
	}
	if ("`nc'" != "noconstant") {
		local noindnamed `noindnamed' `dep':_cons
	}
	local notrtindnamed
	foreach var of local notrtind {
		local notrtindnamed `notrtindnamed' `trtdep':`var'
	}
	if ("`trtnc'" != "noconstant") {
		local notrtindnamed `notrtindnamed' `trtdep':_cons
	}
	local indnamed
	foreach var of local ind {
		local indnamed `indnamed' `dep':`var'
	}
	if ("`nc'" != "noconstant") {
		local indnamed `indnamed' `dep':_cons
	}
	local trtindnamed
	foreach var of local trtind {
		local trtindnamed `trtindnamed' `trtdep':`var'
	}
	if ("`trtnc'" != "noconstant") {
		local trtindnamed `trtindnamed' `trtdep':_cons
	}
	if _caller() < 15 {
		local athrho	"athrho:_cons"
		local athrho0	"athrho0:_cons"
		local athrho1	"athrho1:_cons"
		local lnsigma	"lnsigma:_cons"
		local lnsigma0	"lnsigma0:_cons"
		local lnsigma1	"lnsigma1:_cons"
	}
	else {
		local athrho	"/athrho"
		local athrho0	"/athrho0"
		local athrho1	"/athrho1"
		local lnsigma	"/lnsigma"
		local lnsigma0	"/lnsigma0"
		local lnsigma1	"/lnsigma1"
	}
	if ("`poutcomes'" != "") {
		local tot ///
		`indnamed'  `trtindnamed' ///
		`athrho0' `lnsigma0' `athrho1' `lnsigma1'

		local notot ///
		`noindnamed' `notrtindnamed' ///
		`athrho0' `lnsigma0' `athrho1' `lnsigma1'
	}
	else {	 
		local tot `indnamed' `trtindnamed' `athrho' `lnsigma'
		local notot `noindnamed' `notrtindnamed' `athrho' `lnsigma'
	}
	local npf = wordcount("`tot'")
	if ("`from'" != "") {
		ParseFrom `from'
                local ncol = `s(ncol)'
                local from `s(from)'
                local fopt `s(fopt)'
		// create from matrix 
		if "`fopt'" == "skip" | "`fopt'" != "copy" {
			confirm matrix `from'
			if ("`fopt'" == "skip") {
				capture assert `ncol' >= `npf'
			}
			else if ("`fopt'" != "copy") {
				capture assert `ncol' >= `npf'
			}
			if _rc {
				di as error  ///
			`"all parameters are not specified in {bf:from()}"'
				exit 198
			}
			tempname pffrommat
			matrix `pffrommat' = J(1,`npf',.)
			local j = 1
			foreach word of local tot {
				local location = colnumb(`from',"`word'")
				if !missing(`location') {
					matrix `pffrommat'[1,`j'] = ///
						`from'[1,`location']
				}
				local j = `j' + 1
			}
			capture assert matmissing(`pffrommat') == 0
			if _rc {
				di as error  ///
			`"all parameters are not specified in {bf:from()}"'
				exit 198
			}
			local from `pffrommat'
		}
		else if "`fopt'" == "copy" {
			capture confirm matrix `from'
			if _rc {
				local from = subinstr("`from'"," ",",",.)
				tempname afram 
				matrix `afram' = (`from')
				capture assert colsof(`afram') == `npf'
				if (_rc) {
					di as error  ///
		`"incorrect number of parameters specified in {bf:from()}"'
					exit 198
				}
				local from `afram'
			}
		}
	}

	matrix `probitb' = e(b)	
	qui predict double `xbprb', xb
	qui gen double `lambda' = normalden(`xbprb')/normal(`xbprb') /*
		*/ if `trtdep' == 1 & `touse'
	qui replace `lambda' = -normalden(`xbprb')/(1-normal(`xbprb')) /*
		*/ if `trtdep' == 0 & `touse'	
	if "`hazard'" != "" { 
		capture drop `hazard'
		gen double `hazard' = `lambda' 
		label variable `hazard' ///
		"hazard from treatment equation"
	}
	if ("`poutcomes'" != "") {
		tempvar lambda0
		qui gen double `lambda0' = `lambda'*(!`trtdep') if `touse'
		tempvar lambda1
		qui gen double `lambda1' = `lambda'*(`trtdep') if `touse' 
	}

	qui if ("`from'" == "") {
		tempname bpass regb
		tempvar nolres
		if ("`poutcomes'" != "") {
			qui reg `dep' `nofind'  `lambda0' `lambda1'  `wgt' ///
				if `touse', `nc'				
			tempvar tao1 tao0
			tempname blambda0 blambda1
			gen double `tao0' = `lambda0'*(`lambda0'+`xbprb') ///
				if `touse'  & !`trtdep'
			gen double `tao1' = `lambda1'*(`lambda1'+`xbprb') ///
				if `touse' & `trtdep'
			scalar `blambda0' = _b[`lambda0']
			scalar `blambda1' = _b[`lambda1']
			tempvar nolres
			predict double `nolres' if `touse', res
			replace `nolres' = `nolres'^2 if `touse'
			tempname sigma0 sigma1 rho0 rho1
			matrix `regb' = e(b)
			tempname mtao0 mtao1
			
			qui regress `tao0' `wgt' if `touse'
			scalar `mtao0' = _b[_cons]
			qui regress `tao1' `wgt' if `touse'
			scalar `mtao1' = _b[_cons]
			qui regress `nolres' `wgt' ///
				if !`trtdep' & `touse'
			scalar `sigma0'= ///
				sqrt(_b[_cons]+`mtao0'*(`blambda0'^2))
			scalar `rho0' = `blambda0'/`sigma0'
			qui regress `nolres' `wgt' if `trtdep' & `touse'
			scalar `sigma1'= ///
			sqrt(_b[_cons]+`mtao1'*(`blambda1'^2))
			scalar `rho1' = `blambda1'/`sigma1'

			tempname athrho0 athrho1
			tempname lnsigma0 lnsigma1
			scalar `athrho0' = atanh(`rho0')
			scalar `lnsigma0' = ln(`sigma0')
			scalar `athrho1' = atanh(`rho1')
			scalar `lnsigma1' = ln(`sigma1')
			if (`athrho0' == .) {
				scalar `athrho0'= 0
			}
			if (`athrho1' == .) {
				scalar `athrho1'= 0
			}
			if (`lnsigma0' == .) {
				scalar `lnsigma0'= 0
			}
			if (`lnsigma1' == .) {
				scalar `lnsigma1'= 0
			}

			if ("`nc'" == "noconstant") {
				matrix `regb' = ///
				`regb'[1,1..(colsof(`regb')-2)]
			}
			else {
				if ("`tnot'" == "") {
					matrix `regb' = ///
					(`regb'[1,1..(colsof(`regb')-3)], ///
					`regb'[1,colsof(`regb')])
				}
				else {
					matrix `regb' = ///
					(`regb'[1,colsof(`regb')])
				}
			}
			matrix `bpass' = ///
				(`regb', `probitb', ///
				`athrho0',`lnsigma0',`athrho1',`lnsigma1')

		}
		else {
			qui reg `dep' `nofind' `lambda' `wgt' ///
				if `touse', `nc' omitted
			tempvar tao
			tempname blambda
			gen double `tao' = `lambda'*(`lambda'+`xbprb') ///
				if `touse' 
			scalar `blambda' = _b[`lambda']
			tempvar nolres
			predict double `nolres' if `touse', res
			replace `nolres' = `nolres'^2 if `touse'
			tempname sigma rho
			matrix `regb' = e(b)
			tempname mtao
			qui regress `tao' `wgt' if `touse'
			scalar `mtao' = _b[_cons]
			qui regress `nolres' `wgt' if `touse'
			scalar `sigma' = sqrt(_b[_cons]+`mtao'*(`blambda'^2))
			scalar `rho' = `blambda'/`sigma'

		        if `sigma' == 0 { 
				scalar `sigma' = .001
			}
		        if abs(`rho') >= 1 { 
				scalar `rho' = 0 
			}
			tempname athrho
			tempname lnsigma
			scalar `athrho' = atanh(`rho')
			scalar `lnsigma' = ln(`sigma')
			if ("`nc'" == "noconstant") {
				matrix `regb' = ///
				`regb'[1,1..(colsof(`regb')-1)]
			}
			else {
				if ("`tnot'" == "") {
					matrix `regb' = ///
					(`regb'[1,1..(colsof(`regb')-2)], ///
					`regb'[1,colsof(`regb')])
				}			
				else {
					matrix `regb' = ///
					(`regb'[1,colsof(`regb')])
				}
			}
			matrix `bpass' = ///
				(`regb', `probitb', ///
				`athrho',`lnsigma')		
		}
		local from from(`bpass')
		if ("`forml'" != "") {
			local cvmi conv_maxiter(0)
		}
	}
	else {
		// take omitteds out of from
		tempname afrom
		local frominlist = ///
			bsubstr("`frominlist'",2, length("`frominlist'"))
		// add ancillary parameters back
		if ("`poutcomes'" != "") {
			local df = colsof("`from'")
			local cf = colsof("`from'")-1
 			local bf = colsof("`from'")-2
 			local af = colsof("`from'")-3
			local frominlist `frominlist',`af',`bf',`cf',`df'
		}
		else {
 			local bf = colsof("`from'")
 			local af = colsof("`from'")-1
			local frominlist `frominlist',`af',`bf'
		}	
		mata: st_matrix("`afrom'", ///
			st_matrix("`from'")[1,(`frominlist')])
		local from from(`afrom')
	}
	local noconstantt		
	if ("`trtnc'" == "noconstant") {
		local noconstantt noconstantt
	}
	else {
		local tcons tcons
	}
	if ("`nc'" != "noconstant") {
		local bcons bcons
	}
	if ("`log'" != "nolog" & "`forml'" == "") {
		local qcfunc noi
	}	
	else {
		local qcfunc qui
	}
	if ("`poutcomes'" != "") {
		local np = ///
		wordcount(`"`ind' `trtind' `tcons' `bcons'"') + 4 
		local nonp = ///
		wordcount(`"`noind' `notrtind' `tcons' `bcons'"') + 4 
		if ("`qcfunc'" != "qui") {		
			di ""
		}
		`qcfunc' gmm _etregress_2_gmm if `touse' `wgt', ///
		y(`dep') tvar(`trtdep') ///
		treat(`notrtind') `nc' `noconstantt' ///
		out(`noind') ///
		equations(out treat outm0 outs0 outm1 outs1) ///
		nparameters(`nonp') ///
		instruments(out: `nofind', `nc') ///
		instruments(outm0: `lambda0',noconstant) ///
		instruments(outm1: `lambda1',noconstant) ///
		instruments(treat: `noftrtind', `trtnc') ///
		winitial(identity) iterlogonly ///
		`opts' `from' onestep hasderivatives ///
		valueid("GMM criterion Q(b)") `cvmi' `log' 
	}
	else {
		local np = ///
		wordcount(`"`ind' `trtind' `tcons' `bcons'"') + 2 
		local nonp = ///
		wordcount(`"`noind' `notrtind' `tcons' `bcons'"') + 2
		if ("`qcfunc'" != "qui") {		
			di ""
		}
		`qcfunc' gmm _etregress_gmm if `touse' `wgt', ///
		y(`dep') tvar(`trtdep') ///
		treat(`notrtind') `nc' `noconstantt' ///
		out(`noind')	///
		equations(out treat outm outs) ///
		nparameters(`nonp') ///
		instruments(out: `nofind', `nc') ///
		instruments(outm: `lambda', noconstant) ///
		instruments(treat: `noftrtind', `trtnc') ///
		iterlogonly `opts' `from' hasderivatives ///
		winitial(identity) onestep ///
		valueid("GMM criterion Q(b)") `cvmi' `log' 
	}
	tempname b V init
	matrix `b' = e(b)
	matrix `V' = e(V)
	if ("`e(vcetype)'" == "Robust") {
		tempname V_modelbased
		mata: st_matrix("`V_modelbased'", ///
			-qrinv(st_matrix("e(G)"))/st_numscalar("e(N)"))
	}
	matrix `init' = e(init)
		
	tempname fb fV finit
	matrix `fb' = J(1,`np',0)
	matrix colnames `fb' = `tot'
	matrix `finit' = J(1,`np',0)
	matrix colnames `finit' = `tot'
	matrix `fV' = J(`np',`np',0)
	matrix colnames `fV' = `tot'
	matrix rownames `fV' = `tot'
	if ("`e(vcetype)'" == "Robust") {
		tempname fV_modelbased
		matrix `fV_modelbased' == J(`np',`np',0)
		matrix colnames `fV_modelbased' = `tot'
		matrix rownames `fV_modelbased' = `tot'
	}

	
	local i = 1
	foreach var of local notot {
		local colnumbtot: list posof "`var'" in tot
		local colnumbnotot: list posof "`var'" in notot
		matrix `fb'[1,`colnumbtot'] = `b'[1,`colnumbnotot']
		matrix `finit'[1,`colnumbtot'] = `init'[1,`colnumbnotot']
		foreach vary of local notot {
			local colnumbtoty: list posof "`vary'" in tot
			local colnumbnototy: list posof "`vary'" in notot
			matrix `fV'[`colnumbtot',`colnumbtoty'] = ///
				`V'[`colnumbnotot',`colnumbnototy'] 
			if ("`e(vcetype)'" == "Robust")	{
			matrix `fV_modelbased'[`colnumbtot',`colnumbtoty']= ///
				`V_modelbased'[`colnumbnotot',`colnumbnototy'] 			
			}
		}
	}
        tempname eN eQ eJ eJ_df eN_clust erank eic econverged ///
		 en_moments econverged ek eG eS eW

	capture scalar `econverged' = e(converged)
        capture scalar `eN' = e(N)
        capture scalar `eQ' = e(Q)
        capture scalar `eJ' = e(J)
        capture scalar `eJ_df' = e(J_df) 
        capture scalar `erank' = e(rank)
        capture scalar `eic' = e(ic)
        capture scalar `econverged' = e(converged)
        capture scalar `en_moments' = e(n_moments)
	capture scalar `ek' = e(k)
	matrix `eG' = e(G)
	matrix `eS' = e(S)
	matrix `eW' = e(W)

	
	tempvar touse2
	qui gen byte `touse2' = e(sample)
	ereturn post `fb' `fV' [`e(wtype)'`e(wexp)'] , ///
		esample(`touse2') buildfvinfo
	ereturn hidden matrix Vold = `V'
	ereturn hidden matrix Voldmodelbased = `V_modelbased'

        ereturn scalar N = `eN' 
	ereturn scalar k = `ek'
	if ("`poutcomes'" != "") {
		ereturn hidden local diparm1 athrho0, tanh label("rho0")
		ereturn hidden local diparm2 lnsigma0, exp label("sigma0")
		ereturn hidden local diparm3 athrho0 lnsigma0, /*
                        */ func( /*
                        */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
        */ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
             */ label("lambda0")
		ereturn hidden local diparm4 athrho1, tanh label("rho1")
		ereturn hidden local diparm5 lnsigma1, exp label("sigma1")
		ereturn hidden local diparm6 athrho1 lnsigma1, /*
                        */ func( /*
                        */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
        */ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
             */ label("lambda1")
		ereturn scalar k_eq = 6	
		ereturn scalar k_aux = 4
	}
	else {
		ereturn hidden local diparm1 athrho, tanh label("rho")
		ereturn hidden local diparm2 lnsigma, exp label("sigma")
		ereturn hidden local diparm3 athrho lnsigma, /*
                        */ func( /*
                        */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
        */ der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2) /*
             */ exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) ) /*
             */ label("lambda")
		ereturn scalar k_eq = 4
		ereturn scalar k_aux = 2
	}
	ereturn scalar k_dv = 2
        capture ereturn hidden scalar Q = `eQ'
        capture ereturn hidden scalar J = `eJ' 

        if ("`eJ_df'" != "") {
                if (!missing(`eJ_df')) {
                        capture ereturn hidden scalar J_df = `eJ_df'
                }
        }
        capture ereturn scalar rank = `erank' 
        capture ereturn scalar converged = `econverged'
        capture qui di colsof(`fV_modelbased') 
        if !_rc {
                ereturn hidden matrix V_modelbased = `fV_modelbased'
        }       
	ereturn hidden matrix init = `finit'
	ereturn scalar converged = e(converged)
	ereturn local depvar `dep' `trtdep'
	if ("`hazard'" != "") {
		ereturn local hazard `hazard'
	}
	ereturn local title "Linear regression with endogenous treatment"
	ereturn local title2 "Estimator: control-function"
	ereturn local vce robust
	ereturn local vcetype Robust
	ereturn local predict etregress_p
	ereturn local footnote etreg_footnote

	ereturn local method cfunction
	ereturn hidden local poutcomes `poutcomes'
	ereturn local chi2_ct "Wald"
	if (`"`poutcomes'"' == "") {
		qui `vv' test _b[/athrho] = 0
	}
	else {
		qui `vv' test ///
		_b[/athrho0] = _b[/athrho1] = 0
	}
	ereturn scalar chi2_c = r(chi2)
	if ("`poutcomes'" == "") {
		ereturn scalar p_c = chiprob(1, e(chi2_c))
	}
	else {
		ereturn scalar p_c = chiprob(2, e(chi2_c))
	}
	ereturn local cmd etregress
	ereturn local ///
		marginsok "XB CTE YCTrt YCNTrt PTrt XBTrt default"
	ereturn hidden local marginsprop nochainrule
	ereturn hidden local trtdep `trtdep'
	ereturn hidden local dep `dep'
	ereturn hidden matrix W = `eW'
	ereturn hidden matrix G = `eG'
	ereturn hidden matrix S = `eS'
	ereturn hidden scalar k_eq_model = 1
	if ("`llprob'" != "") {
		ereturn hidden scalar llprob = `llprob'
	}
end

program Display3 
	syntax [, level(cilevel) *]
	_coef_table_header
	_coef_table, level(`level') `options'
	version 9.1: _prefix_footnote
end	

program define ParseFrom, sclass
	version 13
        cap noi syntax anything(name=from equalok), [ copy skip ]
        local rc = c(rc)
        if `rc' {
                di as err "in option {bf:from()}"
                exit `rc'
        }
        if "`copy'"!="" & "`skip'"!="" {
                di as err "{p}suboptions {bf:copy} and {bf:skip} may not " ///
                 "be combined in option {bf:from()}{p_end}"
                exit 184
        }
        cap confirm matrix `from'
        if (!c(rc)) sreturn local ncol = colsof(`from')
        else sreturn local ncol = 0

        sreturn local from `from'
        sreturn local fopt `copy'`skip'
end

