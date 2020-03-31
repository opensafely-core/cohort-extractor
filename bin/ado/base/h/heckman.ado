*! version 2.14.1  19feb2019
program define heckman, eclass byable(onecall) ///
			prop(svyb svyj svyr ml_score bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun heckman, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"heckman `0'"'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 6.0, missing

	if replay() {
		if "`e(cmd)'" != "heckman" { error 301 }
		if _by() { error 190 }
		if "`e(method)'" == "two-step" {
			Display2 `0'
		}
		else    Display `0'
		exit
	}

	if _caller() < 6.0 {
		if _by() { error 190 }
		local vers = string(_caller())
		version 5, missing
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"heckman `0'"'
end

program define Estimate, eclass byable(recall)
	version 6, missing	/* do not delete */
	local vv "version 8.1:"
	local mm d2
	if _caller() < 6.0 { 
		Parse50 `0' 
		local rhometh 0
		local fvops = 0
	}
	else {
					/* Allow = after depvar */

		gettoken dep 0 : 0 , parse(" =,[")
		_fv_check_depvar `dep'
		tsunab dep: `dep'
		local tsnm = cond( match("`dep'", "*.*"),		/*
				*/ bsubstr("`dep'",			/*
				*/        (index("`dep'",".")+1),.),	/*
				*/ "`dep'")
		confirm variable `tsnm'
		local depn : subinstr local dep "." "_"
		gettoken equals rest : 0 , parse(" =")
		if "`equals'" == "=" { local 0 `"`rest'"' }

					/* Primary syntax */
		syntax [varlist(default=none ts fv)] [if] [in] [pw fw iw aw] /*
			*/ , SELect(string)    [ BRACKET CLuster(varname)    /*
			*/ noCOEF  noConstant FIRst FROM(string) 	     /*
			*/ FROM0(string) Level(cilevel) noHEADer 	     /*
			*/ NOLOg LOg Mills(string) MLMethod(string) 	     /*
			*/ MLOpts(string) NShazard(string) 		     /*
			*/ OFFset(varname numeric) Robust		     /*
			*/ RHOForce RHOLimited RHOSigma RHOTrunc 	     /*
			*/ SCore(string) noSKIP/*undoc*/ LRMODEL	     /*
			*/ TECHnique(string) TWOstep MLe  /*
			*/ CRITTYPE(passthru) VCE(passthru) DOOPT /*
			*/ moptobj(passthru) * ]

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11
		
		if _by() {
			_byoptnotallowed score() `"`score'"'
			_byoptnotallowed nshazard() `"`nshazar'"'
			_byoptnotallowed mills() "`mills'"'
		}

		if "`twostep'" != "" & "`mle'" != "" {
			di as err "only one of mle and twostep is allowed."
			exit 198
		}

		if "`twostep'" != "" {
			_vce_parse, optlist(CONVENTIONAL) :, `vce'
			local vce conventional
		}
		else if `"`vce'"' != "" {
			local options `"`options' `vce'"'
		}

					/* Set up command options. */

					/* method for rho outside -1,1 */
		local ct : word count `rhotrunc' `rholimited' `rhosigmafix' /*
			*/ `rhoforce'
		if `ct' > 1 {
			di in red "options rhotrunc, rhoforce, rholimited" /*
				*/ ", and rhosigma, are mutually exclusive"
			exit 198
		}
		if "`rhoforce'" != "" {
			local rhometh 0
		}
		else if "`rhotrunc'" != "" {
			local rhometh 1
		}
		else if "`rholimited'" != "" {
			local rhometh 3
		}
		else {				/* rhosigma is default */
			local rhometh 2		
			local rhosigm "rhosigma"
		}

		if "`score'" != "" { 
			local n : word count `score'
			if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
				local score = /*
				*/ bsubstr("`score'",1,length("`score'")-1)
				local score `score'1 `score'2 `score'3 `score'4
				local n
			}
		}

		if "`nshazard'" != "" & "`mills'" != "" {
			di in blu /*
			*/ "note: options nshazard() and mills() are synonyms;"
			di in blu /*
			*/ "      using nshazard() and ignoring mills()"
		}

		if "`nshazard'" != "" { local mills `nshazard' }

		local ind `varlist'

		local if0 `if'          /* Required with second -syntax- */
		local in0 `in'
		local option0 `options'
		local nc `constan'
		local off `offset'
		if "`offset'" != "" { local offopt "offset(`offset')" }

			/* later we error out if weights with twostep */
		local wtype `weight'
		local wtexp `"`exp'"'
		if "`weight'" != "" { local wgt `"[`weight'`exp']"' }
		if "`twostep'" == "" {
			if "`cluster'" != "" { 
				local clusopt "cluster(`cluster')" 
			}
			_vce_parse, argopt(CLuster) opt(Robust oim opg) ///
				old: [`weight'`exp'], `vce' `clusopt' `robust'
			local cluster `r(cluster)'
			local robust `r(robust)'
			if "`cluster'" != "" { 
				local clusopt "cluster(`cluster')" 
			}
		}

		if "`lrmodel'" != "" {
			_get_diopts diopts option0, `option0'
			mlopts stdopts, `option0'
			local cns `s(constraints)'

			_check_lrmodel, `constan' `skip' constr(`cns') ///
				options(`twostep' `clusopt' `robust') ///
				indep(`ind')
			local skip noskip 
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

		local mllog `log' `nolog'
		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
		if "`log'" == "" {
			local showlog noisily
		} 
		else    local showlog quietly

		if "`mills'" != "" { confirm new var `mills' }

					/* Setup temporary scorevars */
		if "`score'" != "" {
			local numscr : word count `score'
			if `numscr' != 4 {
di in red "number of variables in score() option must be 4"
				exit 198
			}
			confirm new var `score'
			tempvar sc1 sc2 sc3 sc4
			local scoreml "score(`sc1' `sc2' `sc3' `sc4')"
		}

				/* Process selection equation */

					/* Set up selection depvar */

		tokenize `"`select'"', parse(" =")
		if "`1'" == "=" { local 1 " " }
		if "`2'" == "=" {
			_fv_check_depvar `1' 
			capture tsunab 1 : `1' 
			local seldep `1'
			local seldepn : subinstr local seldep "." "_"
			local 1 " " 
			local 2 " " 
		}

		local 0 `*'
		syntax varlist(default=none ts fv) [, noConstant   /*
			*/ OFFset(varname numeric) ]

		if !`fvops' {
			local fvops = "`s(fvops)'" == "true"
		}
		local selind `varlist'

					/* Set up selection eq options. */
		local selnc `constan'
		local seloff `offset'
		if "`seloff'" != "" { local seloffo "offset(`offset')" }

		if `fvops' {
			local mm e2
		}
		if "`mlmethod'" == "" { local mlmetho `mm' }
		if "`techniq'" == "" {
			local techniq "technique(nr)"
		}
		else	local techniq "technique(`techniq')"
				/* End process selection equation */
	}
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local negh negh
		if "`robust'" == "" {
			local doopt doopt
		}
		local fvexp expand
	}

					/* Parse ML options */
	_get_diopts diopts option0, `option0'
	mlopts stdopts, `option0'
	local coll `s(collinear)'
	local cns `s(constraints)'
	opts_exclusive "`coll' `twostep'"

					/* Ensure valid selection eqn */
	if "`selnc'" != "" & "`selind'" == "" { 
		noi di in red "no variables specified for selection"
		exit 198
	}
					/* Ensure valid main eqn */
	if "`nc'" != "" & "`ind'" == "" { 
noi di in red "must specify variables or allow constant for primary equation"
		exit 198
	}

					/* Set observed/selected variable. */
	if "`seldep'" == "" { 
		tempname seldep
		qui gen byte `seldep' =  `dep' < . 
		local selname select
	}
	else  local selname `seldepn'

					/* Define sample.
					 * Best left here w/ Parse50 */
	tempvar touse rtouse
	mark `touse' `if0' `in0' `wgt'
	markout `touse' `seldep' `selind' `seloff' `cluster', strok

	qui gen byte `rtouse' = `touse'
	markout `rtouse' `dep' `ind' `off'
	qui replace `touse' = 0  if `seldep' & !`rtouse'

					/* Remove collinearity */
	`vv' ///
	_rmcoll `selind' if `touse', `selnc' `coll' `fvexp'
	local selind "`r(varlist)'"
	`vv' ///
	_rmdcoll `dep' `ind' if `touse' & `seldep', `nc' `coll'
	local ind "`r(varlist)'"

					/* Check selection condition */
	qui sum `seldep' if `touse'
	if `r(N)' == `r(sum)' {
di in red "Dependent variable never censored because of selection: "
di in red "model would simplify to OLS regression"
		/* regress `dep' `ind' `wgt' if `touse' */
		exit 498
	}

					/* Fetch initial values */
	if "`twostep'" == "" {
					/* Constant only model */
		if "`skip'" != "" & "`from0'" == "" {
			tempname b0
			`vv' ///
			GetIval "`dep'" "" "`nc'" "`selind'" "`selnc'" `b0' /*
				*/ "`wgt'" "`wtype'" "`wtexp'" `touse'      /*
				*/ `seldep' "`off'" "`seloffo'" "`rhometh'" /*
				*/ "" "" "" "`coll'" "`cns'" "`selname'"    /*
				*/ "`doopt'"
			local from0 "`b0', copy"
		}
					/* Full model.
					 * Starting values and comparison LL */
		tempname b regll prbll
		`vv' ///
		GetIval "`dep'" "`ind'" "`nc'" "`selind'" "`selnc'" /*
			*/ `b' "`wgt'" "`wtype'" "`wtexp'"          /*
			*/ `touse' `seldep' "`off'" "`seloffo'"     /*
			*/ "`rhometh'" "`twostep'" "`first'" ""     /*
			*/ "`coll'" "`cns'" "`selname'" "`doopt'"
		scalar `regll' = r(regll)
		scalar `prbll' = r(prbll)
		if "`from'" == "" { local from "`b', copy" }
	}
	else {
		if `"`stdopts'"' != "" {
			// mlopts are not allowed with -twostep-
			local 0 `", `stdopts'"'
			syntax [, NOOPTION ]
			error 198		// [sic]
		}
					/* Do heckman's two-step procedure */

		if "`off'`seloff'`robust'`score'`cluster'`wgt'" != "" {
			di in red "weights, offset(), vce(robust), score(), and"
			di in red "vce(cluster clustvar) not allowed with the "
			di in red "two-step option"
			exit 198
		}
		`vv' ///
		GetIval "`dep'" "`ind'" "`nc'" "`selind'" "`selnc'" "`b'"    /*
			*/ "" "" "" "`touse'" "`seldep'" "`off'" "`seloffo'" /*
			*/ "`rhometh'" "`twostep'" "`first'" "`mills'" "" "" /*
			*/ "`selname'" "`doopt'"
		if bsubstr("`seldep'",1,2) != "__" {
			est local depvar `dep' `seldep'
		}
		else    est local depvar `dep'
		est local rhometh `rhotrunc'`rhosigmafix'`rhoforce'`rholimited'
		est local method "two-step" 
		est repost, esample(`touse') buildfvinfo
		est hidden local margins_prolog heckman_fix_stripe
		est hidden local margins_epilog heckman_restore_stripe
		est local vce "`vce'"
		est local cmd "heckman"
		_post_vce_rank
		Display2 , level(`level') `diopts'
		exit					/* EXIT */
	}

	if "`skip'" == "noskip" & "`cns'" == "" {
					/* Fit constant only model */
		`showlog' di
		`showlog' di in green "Fitting constant-only model:"
		`vv' ///
		ml model `mlmetho' heck_d2                             /*
			*/ (`depn':  `dep' = , `nc' `offopt')          /*
			*/ (select: `seldep' = `selind', `selnc' `seloffo') /*
			*/ /athrho  /lnsigma 	                       /*
			*/ if `touse' `wgt', wald(0)                   /*
			*/ collinear missing max nooutput nopreserve   /*
			*/ init(`from0') search(off) `mllog' `stdopts'   /*
			*/ `mlopts' `techniq' `bracket' `robust'       /*
			*/ `crittyp' nocnsnotes `negh'
		local continu "continue"
		`showlog' di
		`showlog' di in green "Fitting full model:"
	}

					/* Fit full model */
	`vv' ///
	ml model `mlmetho' heck_d2					/*
	*/ (`depn':   `dep' = `ind', `nc' `offopt')			/*
	*/ (`selname':   `seldep' = `selind', `selnc' `seloffo')	/*
	*/ /athrho /lnsigma						/*
	*/ if `touse' `wgt',						/*
	*/ collinear missing max nooutput nopreserve			/*
	*/ title(Heckman selection model)				/*
	*/ `scoreml' `robust' `clusopt'					/*
	*/ init(`from') search(off) `continu' `mllog' `stdopts'		/*
	*/ `mlopts' `techniq' `bracket' `crittyp'			/*
	*/ diparm(athrho, tanh label("rho"))				/*
	*/ diparm(lnsigma, exp label("sigma"))				/*
	*/ diparm(athrho lnsigma,					/*
	*/   func(exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )	/*
	*/   der( exp(@2)*(1-((exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)))^2)	/*
	*/     exp(@2)*(exp(@1)-exp(-@1))/(exp(@1)+exp(-@1)) )		/*
	*/   label("lambda"))						/*
	*/ `negh' `moptobj'
	ml_s_e
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
		est local scorevars `score' 
	}

	tokenize `e(depvar)'
	if bsubstr("`2'", 1, 2) == "__" { est local depvar `1' }
	if "`cns'" != "" {
		local hascns 1
	}
	if "`robust'" != "" | "`hascns'" == "1" {
		est local chi2_ct "Wald"
		qui test _b[/athrho] = 0
		est scalar chi2_c = r(chi2)
	}
	else {
		est local chi2_ct "LR"
		est scalar chi2_c = 2 * (e(ll) - `regll' - `prbll')
	}
	est scalar p_c = chiprob(1, e(chi2_c))
	if "`wtype'" == "fweight" {
		tempname sumwt
		qui gen double `sumwt'`wtexp'  if `touse' & !`seldep'
		qui replace `sumwt' = sum(`sumwt')
		est hidden scalar N_cens = `sumwt'[_N] 
		est hidden scalar N_unc  = e(N) - `sumwt'[_N]
		est scalar N_nonselected = `sumwt'[_N] 
		est scalar N_selected  = e(N) - `sumwt'[_N]
	}
	else {
		qui count if `seldep' == 0 & `touse'
		est hidden scalar N_cens = r(N) 
		est hidden scalar N_unc  = e(N) - r(N)
		est scalar N_nonselected = r(N) 
		est scalar N_selected  = e(N) - r(N)
	}
	est scalar k_aux = 2
	est local title2 "(regression model with sample selection)"
	est local method "ml"
	est local predict "heckma_p"
	est local mills `mills' 
	est local cmd "heckman"
	est hidden local marginsnomarkout "XBSel PSel"
	est local marginsnotok SCores SCORESEL stdp stdf stdpsel
	est local marginsok default XB PSel YCond YExpected Mills NShazard
	est hidden local marginsderiv PSel YCond YExpected Mills NShazard
	global S_E_cmd "heckman"

	Display , level(`level') `coef' `header' `diopts'
end


program define Display
	syntax [, Level(cilevel) noCOEF noHEADer *]

	if "`coef'" == "" {
		_get_diopts diopts, `options'
		if "`header'" == ""  { _crcshdr }
		version 9:	///
		ml display , noheader level(`level') nofootnote `diopts'
		di in gr  "`e(chi2_ct)' test of indep. eqns. (rho = 0):" /*
			*/ _col(38) "chi2(" in ye "1" in gr ") = "   /*
			*/ in ye %8.2f e(chi2_c) 		     /*
			*/ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
		if "`footnote'" == "" {
			_prefix_footnote
		}
		exit e(rc)
	}
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


program define Display2
	syntax [, Level(cilevel) *]

	_crcshdr
	_get_diopts diopts, `options'
	local cfmt `"`s(cformat)'"'
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
	_prefix_footnote
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

program define FirstStep, eclass
	version 6, missing	/* do not delete */
	local vv : di "version " string(_caller()) ":"

	args seldep selind wgt touse selnc seloffo selname doopt

	`vv' ///
	probit `seldep' `selind' `wgt' /*
		*/ if `touse', asis `selnc' `seloffo' /*
		*/ iter(`=min(1000,c(maxiter))') nocoef `doopt'
	est local depvar = `"`selname'"'
end

program define GetIval, rclass 
	version 6, missing	/* do not delete */
	local vv : di "version " string(_caller()) ":"

	args 	    dep		/*
		*/  ind		/*
		*/  nc		/*
		*/  selind	/*
		*/  selnc	/*
		*/  b0		/*
		*/  wgt		/*
		*/  wtype	/*
		*/  wtexp	/*
		*/  touse	/*
		*/  seldep	/* dependent variable is observed
		*/  off		/* regression offset as -offvar- 
		*/  seloffo	/* selection offset as -offset(offvar)-
		*/  rhometh	/* method of computing or handling rho
		*/  twostep	/*
		*/  first	/*
		*/  lvmills	/*
		*/  coll	/*
		*/  cns		/*
		*/  selname	/*
		*/  doopt

	if "`first'" != "" { local first noisily }
	if "`twostep'" == "" { 
		local do2 "*" 
	}
	
	tempname bprb breg sigma lnsigma rho rho1 athrho Vprb deltbar wtobs
	tempvar pxb delthat mills
	qui {
					/* First-step -- probit */

		`vv' ///
		`first' FirstStep `"`seldep'"' `"`selind'"' /*
			*/ `"`wgt'"' `"`touse'"' `"`selnc'"' `"`seloffo'"' /*
			*/ `"`selname'"' `"`doopt'"'
		`first' _prefix_display  
		`do2' matrix `Vprb' = get(VCE)
		predict double `pxb', xb, if `touse'
		mat `bprb' = get(_b)
		gen double `mills' = normd(`pxb') / normprob(`pxb') 
		return scalar prbll = e(ll)

					/* Regression strictly to test indep */
		if "`off'" != ""  { 
			local origdep `dep'
			tempname dep
			gen double `dep' = `origdep' - `off'
		}
		if "`wtype'" == "aweight" {
			tempvar wt
			gen double `wt' `wtexp'
			sum `wt' if `touse', meanonly
			replace `wt' = `wt' * r(N) / r(sum)
			sum `wt'  if `touse' & `seldep'
			scalar `wtobs' = r(sum)         
			                /* required, e(N) is rounded */
			`vv' ///
			_regress `dep' `ind' [iweight=`wt'], `nc', /*
				*/ if `touse' & `seldep'
		}
		else { 
			`vv' ///
			_regress `dep' `ind' `wgt', `nc', if `touse' & `seldep' 
			scalar `wtobs' = e(N)
		}
		return scalar regll = -0.5 * `wtobs' * /*
			*/ ( ln(2*_pi) + ln(e(rss)/`wtobs') + 1 )

					/* Compute delta-bar */
		gen double `delthat' = `mills' * (`mills' + `pxb')
		sum `delthat' if `touse' & `seldep', meanonly
		scalar `deltbar' = r(mean)

					/* Second-step -- regression w/ Mills */
		if "`nc'" == "" {
			tempvar one
			gen byte `one' = 1
		}
		`vv' ///
		_regress `dep' `ind' `one' `mills' `wgt', nocons, /*
			*/ if `touse' & `seldep'
		mat `breg' = get(_b)

					/* Heckman's two-step consistent 
					 * estimates of sigma and rho */
		tempname rss ebar adj ratio
		if e(rss) >= . {
			tempvar e
			predict double `e' if `touse', resid
			replace `e' = sum(`e'^2)
			scalar `rss' = `e'[_N]
			if `rss' >= . {
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
				noi di in blue "note: two-step estimate " /*
				*/ "of rho = "  `rho1' " is being "        /*
				*/ "truncated to " `rho'
			}
			if `rhometh' == 2 {
				scalar `sigma' = _b[`mills']*`rho'
			}
		}
		if `sigma' == 0 {scalar `sigma' = .001}
		if `rho' >= . { scalar `rho' = 0 }

		if "`twostep'" != "" {
			if "`lvmills'" != "" { 
				rename `mills' `lvmills'
				local mills `lvmills'
				label var `mills' "nonselection hazard"
			}
			`vv' ///
			noi Heck2 `breg' `rho' `sigma' `bprb' `Vprb' `dep' /*
				*/ "`ind'" "`nc'" "`seldep'" "`selind'"    /*
				*/ "`selnc'" "`mills'" "`delthat'" 	   /*
				*/ "`touse'" "`rhometh'" "`rho1'"
		}
		else {
			scalar `athrho' = max(min(`rho',.85), -.85)
			scalar `athrho' = 0.5 * log((1+`athrho') / /*
				*/ (1-`athrho'))
			scalar `lnsigma' = ln(`sigma')
			if `"`coll'"' != "" {
				`vv' ///
				mat coln `breg' = `dep':
				`vv' ///
				mat coln `bprb' = `seldep':
				mat `athrho' = `athrho', `lnsigma'
				if _caller() < 15 {
				mat coln `athrho' = athrho:_cons lnsigma:_cons
				}
				else {
				mat coln `athrho' = /athrho /lnsigma
				}
				mat `b0' = `breg'[1,1..(colsof(`breg')-1)], /*
					*/ `bprb' , `athrho'
			}
			else {
				mat `b0' = `breg'[1,1..(colsof(`breg')-1)], /*
				*/ `bprb' , `athrho' , `lnsigma'
			}
			local cb = colsof(`b0')
			if `"`cns'"' != "" & `"`coll'"' != "" {
				tempname T a C
				// build the column stripes
				foreach var of local ind {
					local coln `"`coln' `dep':`var'"'
				}
				if `"`nc'"' == "" {
					local coln `"`coln' `dep':_cons"'
				}
				foreach var of local selind {
					local coln `"`coln' `seldep':`var'"'
				}
				if "`selnc'" == "" {
					local coln `"`coln' `seldep':_cons"'
				}
				if _caller() < 15 {
					local coln ///
					`"`coln' athrho:_cons lnsigma:_cons"'
				}
				else {
					local coln `"`coln' /athrho /lnsigma"'
				}
				_b_post0 `coln'
				_b_fill0 `b0' "`coln'"
				`vv' ///
				makecns `cns'
				matcproc `T' `a' `C'
				mat `b0' = `b0'*`T'
				mat `b0' = `b0'*`T'' + `a'
			}
		}
	}
end


/*  Note:  Heck2 assumes that the regression w/ a Mills ratio is the
 *  current set of estimates */

program define Heck2, eclass   /* BetaReg rho sigma Cov(probit) 
				  RegVars RecCons PrbVars Mills touse */
	version 6.0, missing
	local vv : di "version " string(_caller()) ":"
	args	    b		/*  regression Beta
		*/  rho		/*  
		*/  sigma	/*
		*/  bprb	/*  probit Beta
		*/  Vprb	/*  probit VCE
		*/  dep		/*  dependent variable
		*/  ind		/*  independent varlist
		*/  nc		/*  "" or "noconstant"
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
di in red "insufficient information in sample to estimate heckman model"
		exit 2000
	}

					/*  Heckman's adjustment to Cov  */
	local fulnam `ind'
	if "`nc'" == "" {
		tempvar one
		g byte `one' = 1
		local fulnam "`fulnam' _cons"
	}
	local fulnam "`fulnam' lambda"
	local kreg : word count `fulnam'
	local kreg1 = `kreg' + 1
	qui mat accum `F' = `ind' `one' `mills' (`selind') [iw=`delthat'], /*
		*/ `selnc', if `touse' & `seldep'
	mat `F' = `F'[1..`kreg', `kreg1'...]
	`vv' ///
	mat rowname `F' = `fulnam'
	scalar `rho2' = `rho' * `rho'
	mat `Q' = `rho2' * `F'*`Vprb'*`F''

					/* Finish the variance computation */
	tempvar rho2del
	if (`rho' < -1 | `rho' > 1) & `rhometh' == 3 { scalar `rho2' = 1 }
	qui gen double `rho2del' = 1 - `rho2' * `delthat'  if `touse'
	qui mat accum `VBm' = `ind' `one' `mills' [iw=`rho2del'], /*
		*/ nocons,  if `touse' & `seldep'
	mat `VBm' = `sigma'^2 * `XpX1' * (`VBm' + `Q') * `XpX1'

					/* Build the set of full eqn names */
	local depn : subinstr local dep "." "_"
	local eqnam
	tokenize `fulnam'
	local i 1
	while `i' < `kreg' {
		local eqnam `eqnam' `depn':``i''
		local i = `i' + 1
	}
	if bsubstr("`seldep'",1,2) != "__" {
		local selname `seldep'
		local selname : subinstr local selname "." "_"
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
	if _caller() < 15 {
		local eqnam `eqnam' mills:lambda
	}
	else {
		local eqnam `eqnam' /mills:lambda
	}

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
	`vv' ///
	mat colnames `bfull' = `eqnam'
	`vv' ///
	mat rownames `VBm' = `eqnam'
	`vv' ///
	mat colnames `VBm' = `eqnam'

	qui count if `touse'
	version 11: ///
	capture ereturn post `bfull' `VBm', obs(`r(N)') fatal
	if _rc {
		if _rc == 506 {
			di in red "estimate of rho outside the interval "  /*
				*/ "[-1, 1] has led to a covariance matrix"
			di in red "that is not positive definite"
			* mat `VBm' = 0*`VBm'
			mat `VBm'[1, 1] = 0*`VBm'[1..`kreg0', 1..`kreg0']
		}
		version 11: ///
		ereturn post `bfull' `VBm', obs(`r(N)')
	}

	est scalar N = `r(N)'
	capture qui test [`depn']:`ind', min
	if _rc == 0 {
		est scalar chi2 = `r(chi2)'
		est scalar df_m = `r(df)'
		est scalar p    = `r(p)'
	}
	qui count if `seldep' == 0 & `touse'
	est hidden scalar N_cens = r(N)	/* early, sic */
	est hidden scalar N_unc  = e(N) - r(N)
	est scalar N_nonselected = r(N)	/* early, sic */
	est scalar N_selected  = e(N) - r(N)
	est local chi2type "Wald"
	est local title2 "(regression model with sample selection)"
	est local title "Heckman selection model -- two-step estimates"
	if bsubstr("`mills'", 1, 2) != "__" { est local mills `mills' }
	est scalar rho = `rho'
	if `rho1' != `rho' { est scalar rho1 = `rho1' }
	est scalar sigma = `sigma'
	if _caller() < 15 {
		est scalar lambda = [mills]_b[lambda]
		est scalar selambda = [mills]_se[lambda]
	}
	else {
		est scalar lambda = [/mills]_b[lambda]
		est scalar selambda = [/mills]_se[lambda]
	}
	est local predict "heckma_p"
	est local marginsok	XB		///
				XBSel		///
				Mills		///
				NShazard	///
				PSel		///
				E(passthru)	///
				Pr(passthru)	///
				YStar(passthru)	///
				default
	est local marginsnotok	SCores		///
				SCORESEL	///
				stdp		///
				stdf		///
				stdpsel		///
				YCond		///
				YExpected
	est hidden local marginsnomarkout "XBSel PSel"
	est hidden local marginsderiv PSel Mills NShazard
end

program define Parse50
	gettoken regeq  0 : 0 , parse(" ,")
	gettoken probit 0 : 0 , parse(" ,")

	syntax [if] [in] [fweight aweight] [, Level(cilevel) /*
		*/ noConstant noLOg * ]

	eq ? `regeq'
	local regeq `r(eqname)'
	tokenize "`r(eq)'"
	local dv `1'
	if "`dv'"=="" { local dv `r(eqname)' }
	mac shift
	local vreg `*'

	eq ? `probit'
	local vprobit `r(eq)'

					/* Send things back to caller in 
					 * names used by -syntax- and caller */
	c_local dep `dv'
	c_local depn `dv'
	c_local ind `vreg'
	c_local selind `vprobit'
	c_local nc `constan'
	c_local level `level'

	c_local log `log'
	if "`log'" == "" {
		local showlog "noisily"
	} 
	else    local showlog "quietly"
	c_local showlog `showlog'
	if "`weight'" != "" {
		c_local wtexp	`"`exp'"'
		c_local	wtype	`"`weight'"'
		c_local	wgt	`"[`weight'`exp']"'
	}
	c_local if0 `"`if'"'
	c_local in0 `in'
	c_local mlmetho d2
	c_local option0 `options'
end

exit

