*! version 1.2.0  19feb2019
program define svyheckman, sortpreserve
	version 8

	if replay() {
		if "`e(cmd)'" != "svyheckman" {
			error 301
		}
		svyopts invalid diopts `0'
		if "`invalid'" != "" {
			di as err "`invalid' : invalid options for replay"
			exit 198
		}
		Display, `diopts'
		exit
	}
	else	Estimate `0'
end

program define Estimate, eclass

/* Allow = after depvar */
	gettoken depvar 0 : 0 , parse(" =,[")
	unab depvar : `depvar'
	confirm variable `depvar'
	gettoken equals rest : 0 , parse(" =")
	if "`equals'" == "=" {
		local 0 `"`rest'"'
	}

/* Parse. */
	syntax	varlist(default=none numeric)	/*
	*/	[pw iw]				/* see _svy_newrule.ado
	*/	[if] [in]			/*
	*/	,				/*
	*/	SELect(string)			/* required
	*/	[				/*
	*/	noCONStant			/* my options
	*/	FROM(string)			/*
	*/	Mills(string) NShazard(string)	/*
	*/	OFFset(varname numeric)		/*
	*/	LOg				/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	* 				/* svy/ml/display options
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	mlopts mlopts rest, `options'

	svyopts svymlopts diopts , `rest'
 
	SelectEq seldep selind selnc seloff : `"`select'"'

	if "`seloff'" != "" {
		local soffopt "offset(`seloff')"
	}

	if `"`log'"' == "" {
		local log nolog
		local qui quietly
	}

	local rhometh 2				/* rhosigma is default */

/* Check syntax errors */

	if "`constant'"!="" & "`varlist'" == "" {
		noi di as err "must specify independent variables or "	/*
			*/ "allow constant for primary equation"
		exit 102
	}
	if "`nshazard'" != "" & "`mills'" != "" {
		di as txt /*
		*/ "note: options nshazard() and mills() are synonyms;"
		di as txt /*
		*/ "      using nshazard() and ignoring mills()"
	}
	if "`nshazard'" != "" {
		local mills `nshazard'
	}
	if "`mills'" != "" {
		confirm new var `mills'
	}

/* Process scores */
	if "`score'" != "" {
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" {
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 `score'4
			local n : word count `score'
		}
		if `n' != 4 {
			di as err /*
*/ "score() requires you specify four new variable names"
			exit 198
		}
		confirm new var `score'
		tempvar sc1 sc2 sc3 sc4
		local scopt "score(`sc1' `sc2' `sc3' `sc4')"
	}

	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

/* Find estimation sample */

	qui svyset
	local wtype `r(wtype)'
	local wtexp "`r(wexp)'"
	if "`wtype'" != "" {
		local wgt `"[`wtype'`wtexp']"'
	}

/* Set observed/selected variable. */

	if "`seldep'" == "" {
		tempname seldep
		qui gen byte `seldep' =  `depvar' != . 
		local selname select
	}
	else	local selname `seldep'

	tempvar touse rtouse
	mark `touse' `if' `in' `wgt', zeroweight
	markout `touse' `seldep' `selind' `seloff' `cluster', strok

	qui gen byte `rtouse' = `touse'
	markout `rtouse' `depvar' `varlist' `offset'
	qui replace `touse' = 0  if `seldep' & !`rtouse'

/* Remove collinearity */

	_rmcoll `selind' if `touse', `selnc'
	local selind "`r(varlist)'"
	_rmdcoll `depvar' `varlist' if `touse' & `seldep', `constant'
	local varlist "`r(varlist)'"

/* Check selection condition */

	qui sum `seldep' if `touse'
	if `r(N)' == `r(sum)' {
		di as err "Dependent variable never censored due to selection: "
		di as err "model would simplify to OLS regression"
		exit 498
	}

/* Full model.
 * Starting values and comparison LL */

	tempname b regll prbll
	GetIval "`depvar'" "`varlist'" "`constant'" "`selind'" "`selnc'" /*
		*/ `b' "`wgt'" "`wtype'" "`wtexp'"          /*
		*/ `touse' `seldep' "`offset'" "`soffopt'"     /*
		*/ "`rhometh'" "`twostep'" "`first'"
	scalar `regll' = r(regll)			/* not used for svy */
	scalar `prbll' = r(prbll)			/* not used for svy */
	if "`from'" == "" {
		local from "`b', copy"
	}

/* Fit miss-specified model. */

	`qui' FitMiss `depvar' `varlist' if `touse',	/*
	*/ sel(`seldep' = `selind', `selnc' `soffopt')	/*
	*/ `offopt'					/*
	*/ `diopts'					/*
	*/ mlopts(`mlopts')				/*
	*/ `svymlopts'
	if "`r(results)'" != "" {
		tempname Vmeff
		mat `Vmeff' = e(V)
	}

/* Fit full model */

	ml model d2 heck_d2						/*
	*/ (`depvar':  `depvar' = `varlist', `offopt' `constant')	/*
	*/ (`selname': `seldep' = `selind', `selnc' `soffopt')		/*
	*/ /athrho							/*
	*/ /lnsigma							/*
	*/ if `touse',							/*
	*/ collinear							/*
	*/ missing							/*
	*/ max								/*
	*/ nooutput							/*
	*/ nopreserve							/*
	*/ `mlopts'							/*
	*/ svy								/*
	*/ `svymlopts'							/*
	*/ `scopt'							/*
	*/ `log'							/*
	*/ init(`from')							/*
	*/ search(off)							/*
	*/ title(Survey Heckman selection model)			/*
	*/ crittype("log pseudolikelihood")				/*
	*/
	Reparm

/* Get Mills' ratio if requested */

	if "`mills'" != "" {
		qui _predict double `mills', eq(#2), if `touse'
		qui replace `mills' = normd(`mills') / normprob(`mills')
		label var `mills' "nonselection hazard"
	}

/* Handle scores if requested */

	if "`score'" != "" {
		tokenize `score'
		local i 1
		while "``i''" != "" {
			rename `sc`i'' ``i''
			local i = `i' + 1
		}
		eret local scorevars `score'
	}
	else	eret local scorevars

	tokenize `e(depvar)'
	if bsubstr("`2'", 1, 2) == "__" {
		eret local depvar `1'
	}
	qui count if `seldep' == 0 & `touse'
	eret scalar N_cens = r(N)
	eret local predict "heckma_p"
	eret local mills `mills' 
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret scalar k_aux    = 2 /* # of ancillary parameters */
	eret local cmd "svyheckman"

/* Double save. */

	global S_E_nobs = e(N)
	global S_E_nstr = e(N_strata)
	global S_E_npsu = e(N_psu)
	global S_E_npop = e(N_pop)
	global S_E_wgt   `e(wtype)'
	global S_E_exp  "`e(wexp)'"
	global S_E_str   `e(strata)'
	global S_E_psu   `e(psu)'
	global S_E_depv  `e(depvar)'
	global S_E_f    = e(F)
	global S_E_mdf  = e(df_m)
	global S_E_cmd   `e(cmd)'

	Display, `diopts'
end

program define Display
	syntax [, Level(cilevel) * ]
	local opts svy level(`level') dof(`e(df_r)')

	ml display , level(`level') `options'				/*
	*/ diparm(athrho,  `opts' tanh label("rho"))			/*
	*/ diparm(lnsigma, `opts' exp label("sigma"))			/*
	*/ diparm(athrho lnsigma,					/*
	*/   func(exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )	/*
	*/   der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2)	/*
	*/     exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )		/*
	*/   `opts' label("lambda"))					/*
	*/
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

	eret scalar rho    = `rho'
	eret scalar sigma  = `sig'
	eret scalar lambda = `lambda'
	eret scalar selambda  = `lamse'
end

program define GetIval, rclass 
	args 	    depvar	/*
		*/  varlist	/*
		*/  constant	/*
		*/  selind	/*
		*/  selnc	/*
		*/  b0		/*
		*/  wgt		/*
		*/  wtype	/*
		*/  wtexp	/*
		*/  touse	/*
		*/  seldep	/* dependent variable is observed
		*/  offset	/* regression offset as -offvar- 
		*/  soffopt	/* selection offset as -offset(offvar)-
		*/  rhometh	/* method of computing or handling rho
		*/  twostep	/*
		*/  first	/*
		*/  lvmills

	if "`first'" != "" {
		local first noisily
	}
	if "`twostep'" == "" {
		local do2 "*" 
	}
	
	tempname bprb breg sigma lnsigma rho rho1 athrho Vprb deltbar wtobs
	tempvar pxb delthat mills
	qui {
					/* First-step -- probit */

		`first' probit `seldep' `selind' `wgt' /*
			*/ if `touse', asis `selnc' `soffopt'
		`do2' matrix `Vprb' = get(VCE)
		predict double `pxb', xb, if `touse'
		mat `bprb' = get(_b)
		gen double `mills' = normd(`pxb') / normprob(`pxb') 
		return scalar prbll = e(ll)

					/* Regression strictly to test indep */
		if "`offset'" != ""  {
			local origdep `depvar'
			tempname depvar
			gen double `depvar' = `origdep' - `offset'
		}
		if "`wtype'" == "aweight" {
			tempvar wt
			gen double `wt' `wtexp'
			sum `wt' if `touse', meanonly
			replace `wt' = `wt' * r(N) / r(sum)
			sum `wt'  if `touse' & `seldep'
			scalar `wtobs' = r(sum)         
			                /* required, e(N) is rounded */
			regress `depvar' `varlist' [iweight=`wt'], /*
				*/ `constant', /*
				*/ if `touse' & `seldep'
		}
		else {
			regress `depvar' `varlist' `wgt', /*
			*/ `constant', if `touse' & `seldep' 
			scalar `wtobs' = e(N)
		}
		return scalar regll = -0.5 * `wtobs' * /*
			*/ ( ln(2*_pi) + ln(e(rss)/`wtobs') + 1 )

					/* Compute delta-bar */
		gen double `delthat' = `mills' * (`mills' + `pxb')
		sum `delthat' if `touse' & `seldep', meanonly
		scalar `deltbar' = r(mean)

					/* Second-step -- regression w/ Mills */
		if "`constant'" == "" {
			tempvar one
			gen byte `one' = 1
		}
    		regress `depvar' `varlist' `one' `mills' `wgt', nocons, /*
			*/ if `touse' & `seldep'
		mat `breg' = get(_b)

					/* Heckman's two-step consistent 
		 			 * estimates of sigma and rho */
		tempname rss ebar adj ratio
		if e(rss) == . {
			tempvar e
			predict double `e' if `touse', resid
			replace `e' = sum(`e'^2)
			scalar `rss' = `e'[_N]
			if `rss' == . {
				error 1400
			}
		}
		else    scalar `rss' = e(rss)
		
		scalar `ebar' = `rss' / e(N)
		scalar `sigma' = sqrt(`ebar' + `deltbar'*_b[`mills']^2)

		scalar `rho' = _b[`mills'] / `sigma'
		scalar `rho1' = `rho'
		if abs(`rho') > 1 & `rhometh' >= 1 & `rhometh' <= 2 {
			scalar `rho' = `rho'/abs(`rho')
			if "`twostep'" != "" {
				noi di as txt "note: two-step estimate " /*
				*/ "of rho = "  `rho1' " is being "        /*
				*/ "truncated to " `rho'
			}
			if `rhometh' == 2 {
				scalar `sigma' = _b[`mills']*`rho'
			}
		}
		if `sigma' == 0 {
			scalar `sigma' = .001
		}
		if `rho' == . {
			scalar `rho' = 0
		}

		if "`twostep'" != "" {
			if "`lvmills'" != "" {
				rename `mills' `lvmills'
				local mills `lvmills'
				label var `mills' "nonselection hazard"
			}
			noi Heck2 `breg' `rho' `sigma' `bprb' `Vprb'	/*
			*/ `depvar' "`varlist'" "`constant'" "`seldep'"	/*
			*/ "`selind'" "`selnc'" "`mills'" "`delthat'"	/*
			*/ "`touse'" "`rhometh'" "`rho1'"
		}
		else {
			scalar `athrho' = max(min(`rho',.85), -.85)
			scalar `athrho' = 0.5 * log((1+`athrho') / /*
				*/ (1-`athrho'))
			scalar `lnsigma' = ln(`sigma')
			mat `b0' = `breg'[1,1..(colsof(`breg')-1)] ,   /*
				*/ `bprb' , `athrho' , `lnsigma'
		}


	}
end


/*  Note:  Heck2 assumes that the regression w/ a Mills ratio is the
 *  current set of estimates */

program define Heck2, eclass   /* BetaReg rho sigma Cov(probit) 
				  RegVars RecCons PrbVars Mills touse */
	args	    b		/*  regression Beta
		*/  rho		/*  
		*/  sigma	/*
		*/  bprb	/*  probit Beta
		*/  Vprb	/*  probit VCE
		*/  depvar		/*  dependent variable
		*/  varlist		/*  independent varlist
		*/  constant		/*  "" or "noconstant"
		*/  seldep	/*  selection eqn dependent variable
		*/  selind	/*  selection eqn indep varlist
		*/  selnc	/*  selection eqn : "" or "noconstant"
		*/  mills	/*  Mills' ratio
		*/  delthat	/*
		*/  touse	/*  To use variable
		*/  rhometh	/*  method of using rho
		*/  rho1	/*  original two-step rho if outside -1,1 */

	tempname XpX1 F Q rho2 VBm 

	/* Compute Heckman's two-step consistent estimates of Cov */

					/* Get X'X inverse from the 
					 * second-step regression */

	if e(rmse) != 0 {
		matrix `XpX1' = get(VCE) / e(rmse)^2
	}
	else {
		di as err /*
*/ "insufficient information in sample to estimate heckman model"
		exit 2000
	}

					/*  Heckman's adjustment to Cov  */
	local fulnam `varlist'
	if "`constant'" == "" {
		tempvar one
		g byte `one' = 1
		local fulnam "`fulnam' _cons"
	}
	local fulnam "`fulnam' lambda"
	local kreg : word count `fulnam'
	local kreg1 = `kreg' + 1
	qui mat accum `F' = `varlist' `one' `mills' `selind' [iw=`delthat'], /*
		*/ `selnc', if `touse' & `seldep'
	mat `F' = `F'[1..`kreg', `kreg1'...]
	mat rowname `F' = `fulnam'
	scalar `rho2' = `rho' * `rho'
	mat `Q' = `rho2' * `F'*`Vprb'*`F''

					/* Finish the variance computation */
	tempvar rho2del
	if (`rho' < -1 | `rho' > 1) & `rhometh' == 3 {
		scalar `rho2' = 1
	}
	qui gen double `rho2del' = 1 - `rho2' * `delthat'  if `touse'
	qui mat accum `VBm' = `varlist' `one' `mills' [iw=`rho2del'], /*
		*/ nocons,  if `touse' & `seldep'
	mat `VBm' = `sigma'^2 * `XpX1' * (`VBm' + `Q') * `XpX1'

					/* Build the set of full eqn names */
	local eqnam
	tokenize `fulnam'
	local i 1
	while `i' < `kreg' {
		local eqnam `eqnam' `depvar':``i''
		local i = `i' + 1
	}

	if bsubstr("`seldep'",1,2) != "__" {
		local selname `seldep'
	}
	else    local selname select
	local kprb : word count `selind'
	local i 1
	tokenize `selind'
	while `i' <= `kprb' {
		local eqnam `eqnam' `selname':``i''
		local i = `i' + 1
	}
	if "`selnc'" == "" {
		local eqnam `eqnam' `selname':_cons 
		local kprb = `kprb' + 1
	}
	local eqnam `eqnam' mills:lambda

					/*  Put model and selection 
					 *  equation together 
					 *  Quicker w/ matrix expr, but would
					 *  be hard to understand */

	tempname bfull Vfull zeros Vmills CovMill zeroPrb b0 bmills
	local kreg0 = `kreg' - 1
	mat `b0' = `b'[1,1..`kreg0'] 
	mat `bmills' = `b'[1,`kreg'] 
	mat `bfull' = `b0', `bprb' , `bmills'
	mat `Vmills' = `VBm'[`kreg', `kreg']
	mat `CovMill' = `VBm'[1..`kreg0', `kreg']
	mat `VBm' = `VBm'[1..`kreg0', 1..`kreg0']
	mat `zeros' = J(`kreg0', `kprb', 0)
	mat `zeroPrb' = J(`kprb', 1, 0)
	mat `VBm' = /*
		*/  ( `VBm'       , `zeros'    ,  `CovMills' \      /*
		*/    `zeros''    , `Vprb'     ,  `zeroPrb'  \      /*
		*/    `CovMills'' , `zeroPrb'' ,  `Vmills' )
	mat `VBm' = (`VBm' + `VBm'') / 2
	mat colnames `bfull' = `eqnam'
	mat rownames `VBm' = `eqnam'
	mat colnames `VBm' = `eqnam'

	qui count if `touse'
	capture eret post `bfull' `VBm', obs(`r(N)')
	if _rc {
		if _rc == 506 {
			di as err "estimate of rho outside the interval "  /*
				*/ "[-1, 1] has led to a covariance matrix"
			di as err "that is not positive definite"
			* mat `VBm' = 0*`VBm'
			mat `VBm'[1, 1] = 0*`VBm'[1..`kreg0', 1..`kreg0']
		}
		eret post `bfull' `VBm', obs(`r(N)')
	}

	eret scalar N = `r(N)'
	capture qui test `varlist', min
	if _rc == 0 {
		eret scalar chi2 = `r(chi2)'
		eret scalar df_m = `r(df)'
		eret scalar p    = `r(p)'
	}
	qui count if `seldep' == 0 & `touse'
	eret scalar N_cens = r(N)	/* early, sic */
	eret local chi2type "Wald"
	eret local title2 "(regression model with sample selection)"
	eret local title "Heckman selection model -- two-step estimates"
	if bsubstr("`mills'", 1, 2) != "__" {
		eret local mills `mills'
	}
	eret scalar rho = `rho'
	if `rho1' != `rho' {
		eret scalar rho1 = `rho1'
	}
	eret scalar sigma = `sigma'
	eret scalar lambda = [mills]_b[lambda]
	eret scalar selambda = [mills]_se[lambda]
	eret local predict "heckma_p"
end
 
/* Fit miss-specified model. */
program define FitMiss, rclass
	syntax varlist if [,		/*
	*/ constant			/*
	*/ mlopts(string)		/*
	*/ offset(passthru)		/*
	*/ sel(passthru)		/*
	*/ MEFF				/*
	*/ MEFT				/*
	*/ *				/*
	*/ ]

	svyopts junk junk2 junk3, `options'
	local subcond `s(subpop)'

	tempname touse
	mark `touse' `if'
	eret clear
	if "`meff'`meft'" != "" {
		di _n as txt "Computing misspecified "		///
			as res "heckman"			///
			as txt " model for meff/meft computation:"
		if "`subcond'" != "" {
			local mysubtouse (`touse' & `subcond' != 0)
		}
		else    local mysubtouse `touse'
		heckman `varlist'	/*
		*/ if `mysubtouse',	/*
		*/ `constant'		/*
		*/ `mlopts'		/*
		*/ `offset'		/*
		*/ `sel'		/*
		*/
	}
	return local results `meff'`meft'
end

/* process the selection equation
	[depvar =] indvars [, noconstant offset ]
*/
program define SelectEq
	args seldep selind selnc seloff colon sel_eqn

	gettoken depvar rest : sel_eqn, parse(" =")
	gettoken equal rest : rest, parse(" =")

	if "`equal'" == "=" {
		unab depvar : `depvar'
		c_local `seldep' `depvar' 
	}
	else	local rest `"`sel_eqn'"'
	
	local 0 `"`rest'"'
	syntax [varlist(numeric default=none)] 	/*
		*/ [, noCONstant OFFset(varname numeric) ]

	if "`constant'" != "" & "`varlist'" == "" {
		di as err "no variables specified for selection equation"
		exit 198
	}

	c_local `selind' `varlist'
	c_local `selnc' `constant'
	c_local `seloff' `offset'
end

exit

