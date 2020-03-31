*! version 1.1.0  19feb2019 
program define _etregress_pre, eclass byable(onecall) properties(svyb svyj svyr)
	version 13.0
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun etregress, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"etregress `0'"'
		exit
	}

	version 6.0, missing
	if replay() {
		if "`e(cmd)'" != "etregress" { error 301 } 
		if _by() { error 190 }
		if "`e(method)'"== "twostep" {
			Display2 `0'
		}
		else    Display `0'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"etregress `0'"'
	version 10: ereturn hidden local version = _caller()
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
		*/ MLOpts(string) noLOg Robust  Cluster(varname)	/*
		*/ TWOstep noSKIP SCore(passthru) FROM(string)		/*
		*/ VCE(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if `"`from'"' != "" {
		opts_exclusive "`twostep' from()"
	}
	if "`twostep'" != "" {
		_vce_parse, optlist(CONVENTIONAL) :, `vce'
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")
	}
	else if `"`vce'"' != "" {
		local options `"`options' `vce'"'
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
	
	if "`weight'" == "pweight" | "`cluster'" != "" {
		local robust "robust"
	}

	if "`hazard'" != "" { confirm new var `hazard' }
	if "`cluster'" != "" { local clusopt "cluster(`cluster')" }

	if "`log'" == "" {
		local showlog noisily
	}
	else local showlog quietly
        if "`skip'" != "" {
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
				/* Parse ML options */

	_get_diopts diopts option0, `option0'
	mlopts stdopts, `option0'
	local coll `s(collinear)'
	opts_exclusive "`coll' `twostep'"

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
	markout `touse' `dep' `ind' `trtdep' `trtind'

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
	`vv' ///
	_rmcoll `trtind' `wgt' if `touse', `trtnc' `coll'
	local trtind "`r(varlist)'"
	`vv' ///
	_rmdcoll `dep' `ind' `wgt' if `touse', `nc' `coll'
	local ind "`r(varlist)'"

				/* model estimation */

	`vv' ///
	TwoStep "`dep'" "`ind'" "`nc'" "`trtdep'" "`trtind'" /*
		*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"     /*
		*/ `touse' "`first'" "`hazard'"  "`robust'"

	if "`twostep'" == "" {

		tempname b1 athrho lnsigma llreg llprob
		scalar `llprob' =e(ll_p)

		/* initial values */
		if `"`from'"' == "" {
			mat `b1' = e(b)
			mat `b1'= `b1'[1, 1..colsof(`b1')-1]
			scalar `athrho' = max(min(e(rho), .85), -.85)
			scalar `athrho' = 1/2*ln((1+`athrho')/(1-`athrho'))
			scalar `lnsigma' = ln(e(sigma))
			mat `b1' = `b1', `athrho', `lnsigma'
			local init init(`b1', copy)
		}
		else	local init init(`from')

		local hazard `e(hazard)'
		`vv' ///
		qui _regress `dep' `ind' `trtdep' `wgt' if `touse', `nc'
		scalar `llreg' = e(ll)
		if "`skip'" == "noskip" {
				/* constant only model */

			`vv' ///
			TwoStep "`dep'" "" "`nc'" "`trtdep'" "" "`trtnc'"   /*
				*/ "`wgt'" "`wtype'" "`wtexp'" `touse'      /*
				*/ "`first'" "`hazard'" "`robust'"
			tempname b0 athrho lnsigma 
			mat `b0' = e(b)
			mat `b0'= `b0'[1, 1..colsof(`b0')-1]
			scalar `athrho' = max(min(e(rho), .85), -.85)
			scalar `athrho' = 1/2*ln((1+`athrho')/(1-`athrho'))
			scalar `lnsigma' = ln(e(sigma))
			mat `b0' = `b0', `athrho', `lnsigma'
			local continu "continue"
			est clear
			`showlog' di
			`showlog' di in green "Fitting constant-only model:"
			`vv' ///
			Mmethod "`dep'" "" "`nc'" "`trtdep'" "" /*
				*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"    /*
				*/ `touse' "init(`b0', copy)"  "`robust'"   /*
				*/ "`clusopt'" "`log'" "" "`stdopts'"      
			`showlog' di
			`showlog' di in green "Fitting full model:"
		}

		`vv' ///
		Mmethod "`dep'" "`ind'" "`nc'" "`trtdep'" "`trtind'" /*
			*/ "`trtnc'" "`wgt'" "`wtype'" "`wtexp'"    /*
			*/ `touse' "`init'"  "`robust'"   /*		 
			*/ "`clusopt'" "`log'" "`continu'" "`stdopts'" /*
			*/ "`score'"

				/* comparison test */
		capture confirm matrix e(Cns)
		if !_rc {
			local hascns 1
		}
		if "`robust'" != "" | "`hascns'" == "1" {
			est local chi2_ct "Wald"
			qui test [athrho]_b[_cons] = 0
			est scalar chi2_c = r(chi2)
		}
		else {
			est local chi2_ct "LR"
			est scalar chi2_c = 2*(e(ll) - `llreg'- `llprob' )
		}
		est scalar p_c = chiprob(1, e(chi2_c))

		Reparm
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
		est local ll_p
		est repost [`wtype'`wexp'], esample(`touse') buildfvinfo
	}
	est local footnote "treatreg_footnote"
	est local predict "treatr_p"
	est local cmd "etregress"	
	if "`twostep'" == "" {
		Display, level(`level') `diopts'
		est local marginsok "XB YCTrt YCNTrt PTrt XBTrt default"
	}
	else	Display2, level(`level') `diopts'
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
	est scalar ll_p = `llprob'
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
		*/	init	/*
		*/	robust	/*
		*/	clusopt	/*
		*/      log     /*
		*/ 	continu /*
		*/	stdopts	/*
		*/	score
	local depn : subinstr local dep "." "_"
	local trtdepn : subinstr local trtdep "." "_"
	`vv' ///
	ml model lf treat_ll					/* 
		*/ (`depn': `dep' = `ind' `trtdep', `nc')	/*
		*/ (`trtdepn': `trtdep' = `trtind', `trtnc')	/*
		*/ /athrho /lnsigma 				/*
		*/ if `touse' `wgt',				/* 
		*/ `robust' `clusopt'				/*
		*/ collinear missing max nooutput nopreserve	/*
		*/ `init' search(off) `log' `continu'		/* 
		*/ `stdopts' `mlopts' `score'			/*
	*/ diparm(athrho, tanh label("rho"))				/*
	*/ diparm(lnsigma, exp label("sigma"))				/*
	*/ diparm(athrho lnsigma,					/*
	*/   func(exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )	/*
	*/   der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2)	/*
	*/     exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )		/*
	*/   label("lambda"))
	est scalar k_aux = 2
	est local method "ml"
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

	mat `tmp' = `b'[1,"athrho:_cons"]
	scalar `tau' = `tmp'[1,1]
	mat `tmp' = `b'[1,"lnsigma:_cons"]
	scalar `lns' = `tmp'[1,1]

	scalar `rho' = (expm1(2*`tau')) / (exp(2*`tau')+1)
	scalar `sig' = exp(`lns')
	scalar `lambda' = `rho'*`sig'

	mat `d' =  ( `sig'*4*exp(2*`tau')/(exp(2*`tau')+1)^2 , `lambda' )
	mat `v' =  (`v'["athrho:_cons".."lnsigma:_cons",      /*
		*/   "athrho:_cons".."lnsigma:_cons"]  )
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

program define Display
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	version 9: ml display, level(`level') nofootnote `diopts'
	_prefix_footnote
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

