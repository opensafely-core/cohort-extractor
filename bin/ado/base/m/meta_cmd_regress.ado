*! version 1.0.0  12jun2019
program meta_cmd_regress, eclass
	version 16
	if replay() {
		syntax [, *]
		if "`e(cmd1)'" != "meta_cmd_regress" {
			di as err "last estimates not found"
			di as err "{p 4 4 2}If you want to fit a " ///
				"constant-only model, specify "    ///
				"{bf:meta regress _cons}.{p_end}"
			exit 301
		}
		Display, `options'
		exit
	}
	Estimate `0'
end

program Estimate, eclass
	version 16

	syntax [anything] [if] [in] [,				///
		noCONStant					/// 
		NOMETASHOW					///
		METASHOW1					///
		fixed						///
		random(string)					///
		RANDOM1						///
		common						///
		se(string)					///
		noHEADer					///
		Level(string)					///
		ITERate(string)					///	
		TOLerance(string)				///
		NRTOLerance(string)				///
		NONRTOLerance					///
		i2(string)					///
		tau2(string)					///
		SHOWTRace					///
		GRADient					/// UNDOC
		EForm 						/// UNDOC
		HESSian						/// UNDOC
		showstep					/// UNDOC
		SHOWTOLerance					/// UNDOC	
		FRom(string)					///
		WGTVar(varname)					/// UNDOC
		DEPVar(varname)					/// UNDOC
		DEPName(string)					/// UNDOC
		SEVar(varname)					/// UNDOC
		bypasscommoncheck				/// UNDOC
		testtype(string)				/// UNDOC
		tmpvar(string)					/// UNDOC
		MULTiplicative					///
		TDISTribution 					/// 
		*]
	
	marksample touse

	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err
	}
	
	local varlist : subinstr local anything "_cons" "", all word
	fvexpand `varlist' if `touse'
	if "`r(tsops)'" == "true" {
		di as err "time-series operators not allowed"
		exit 101
	}
	local varlist `r(varlist)'
	if "`varlist'" == "" & "`constant'" == "noconstant" {
		di as err "too few variables specified"
		exit 102
	}
	
	if `=_N' == 0 error 111
	
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	
	meta__eform_err, `eform'
	
	if !missing("`common'") & !missing("`varlist'"){
		MregCommonModErr
		exit 498	
	}
	
	if !missing("`se'") & !missing("`tdistribution'") {
		di as err "{p}options {bf:tdistribution} and {bf:se()} may " ///
			"be combined{p_end}"
		exit 184	
	}
	
	if !missing("`se'") {
		meta__parse_seadj adjtype : `"`se'"'
	}
	if ("`adjtype'"=="khartung") local khartung khartung
	else if ("`adjtype'"=="tkhartung") local tkhartung tkhartung
	
	markout `touse' _meta_es _meta_se `varlist' `depvar' `sevar'
	
	
	if missing("`level'") {
		local level  : char _dta[_meta_level]
	}
	else {
		meta__validate_level "`level'"
		local level `s(mylev)'
	}	
	
	_get_diopts diopts garbage, `options'
	if `= wordcount("`garbage'")' {
		gettoken first rest : garbage, bind
		local s = cond(`= wordcount("`rest'")',"s","")
		local verb = cond(`= wordcount("`rest'")',"are","is")
		di as err "option`s' {bf:`garbage'} `verb' not allowed"
		exit 198
	}
	
	local re = subinstr("`random'"," ", "_",.)	
	local mod `"`re' `fixed' `random1' `common'"'	
	if  (`:word count `mod'' > 1) {
		meta__model_err	  
	}
	
		
	// will create locals -model- and -method-
	meta__model_method, random(`random') `random1' `fixed' `common' iv		
	if "`model'" == "common" & missing("`bypasscommoncheck'") & ///
		!missing("`varlist'") {
			MregCommonModErr
			exit 498   		
	}
	
	meta__parse_maxopts, from(`from') iter(`iterate') tol(`tolerance') ///	
		nrtol(`nrtolerance') model(`model') method(`method') ///
		i2(`i2') tau2(`tau2') `nonrtolerance' `showtrace' 
	
	if "`method'"=="mhaenszel" {
		meta__mh_err, cmd(meta-regression)
		local method ivariance 
	} 
	
	local method = cond("`method'" == "fixed", "ivariance", "`method'")
	
	if inlist("`model'","random","common") & !missing("`multiplicative'") {
		di as err "{p}option {bf:multiplicative} is allowed only " ///
			"with fixed-effects meta-regression{p_end}"
		exit 184	 
	}

	if !missing("`tau2'") local fixval "tau2 `tau2'"
	if !missing("`i2'") local fixval "i2 `i2'"
	
	if inlist("`model'", "fixed", "common") {
		local opt = cond(!missing("`fixed'"), "fixed", ///
		cond(!missing("`common'"), "common", ""))
		if !missing("`khartung'`tkhartung'") & !missing("`opt'") {
			di as err "options {bf:se()} " ///
			  "and {bf:`opt'} may not be combined"	
			di as err "{p 4 4 2}SE adjustment is " ///
			  "available only with random-effects models.{p_end}"
			exit 184
		}
		else if !missing("`khartung'`tkhartung'") {
			di as err "{p}option {bf:se()}" ///
			  " may be specified only with random-effects " ///
			  "models{p_end}"				
			exit 198
		}
	
		if !missing("`fixval'") & !missing("`opt'") {
			di as err "options {bf:i2()} and {bf:tau2()} may " ///
			  "not be combined with option {bf:`opt'}"
			di as err "{p 4 4 2}Sensitivity analysis based on " ///
			  "fixing the value of {it:tau2} or {it:I2} is " ///
			  "available only with random-effects models.{p_end}"
			exit 184
		}
		else if !missing("`fixval'") {
			di as err "{p}options {bf:i2()} and {bf:tau2()} " ///
			  "may be specified only with random-effects " ///
			  "models.{p_end}"
			exit 198
		}
	}
	
	if !missing("`tau2'") & !missing("`i2'") {
		di as err "{p}options {bf:i2()} and {bf:tau2()} may not " ///
			"be combined{p_end}"
		exit 184	
	}
	
	if !missing("`nonrtolerance'") local nrtolerance .
	
	if !missing("`wgtvar'")  & (!missing("`tkhartung'`khartung'") | ///
		 !missing("`fixval'")) {
			di as err "{p}option {bf:wgtvar()} may not be " ///
			  "combined with options {bf:tau2()}, {bf:i2()}, " ///
			  "or {bf:se()}{p_end}"
			exit 184	
	}
	
	meta__eform_err,  `eform' 
	
	_rmcoll `varlist' if `touse', `constant' 
	local xvars `r(varlist)'

	fvexpand `xvars' if `touse'
	local xvars `r(varlist)'

	if !missing("`xvars'") {
		qui mata: omittedvars("`xvars'")
		local xvars "`vars'"
	}	
	
	local iswarn  0
	local iserror 0
	eret clear
	
	tempname t2 I2 r2 h2 b V Q Q_kh q qkh df_Q ll ll_r df_m
	tempvar w
	
	if !missing("`header'") local qui quietly
	
	local y = cond(missing("`depvar'"), "_meta_es", "`depvar'")
	local SE = cond(missing("`sevar'"), "_meta_se", "`sevar'")
	
	if !missing("`fixval'") {
		gettoken param val : fixval
		if !inlist("`param'", "tausq", "isq", "tau2", "i2") {
			di as err "option {bf:`param'()} incorrectly specified"
			exit 198
		}
		cap confirm number `val' 
		if _rc { 
			di as err "in option {bf:`param'()}: " _c
			confirm number `val'
		}
		if inlist("`param'", "tausq", "tau2") {
			cap assert `val' >= 0
			if _rc {
				di as err "{p}in option {bf:tau2()}: " ///
				"{it:#} must be a nonnegative number{p_end}"
				exit 198
			} 
		}
		if inlist("`param'", "isq", "i2") {
			cap assert `val' >= 0 & `val' < 100
			if _rc {
				di as err "{p}in option {bf:i2()}: " ///
				"{it:#} must be a number in [0,100){p_end}"
				exit 198
			} 
		}
		local addcons = cond(missing("`constant'"), 1, 0)
		local istau2 = cond(inlist("`param'", "tausq", "tau2"), 1 , 0 )
		tempname hetstat
		mata: st_matrix("`hetstat'", _het_stat_fixval("`xvars'", ///
			"`y'", "`SE'", `addcons', `val', `istau2', ///
			"`touse'"))
		
		local method "sa"
		local cont cont
		
		scalar `ll' = .
		scalar `ll_r' = .
		scalar `I2' = `hetstat'[1,1]
		scalar `h2' = `hetstat'[1,2]
		scalar `t2' = `hetstat'[1,3]
		scalar `r2'  = .
		scalar `Q'  = `hetstat'[1,5] 
		
	}
	else {  
		
		if "`model'" == "random" & !missing("`showtrace'") {
			di
	`qui' di as txt "Estimating between-study variance, tau2:" _n(1)
		}
		
		`qui' meta__hetstat `xvars', esvar("`y'") sevar("`SE'") ///
			method("`method'") touse("`touse'") ///
			maxiter(`iterate') tol(`tolerance') ///
			nrtol(`nrtolerance') `showtrace' `constant' from(`from')
		
		local iswarn `e(iswarning)'
		local msg "Convergence not achieved during tau2 estimation"
		local iserror `e(iserror)'
		if ("`iserror'"=="1") {
			di as err "`msg'"
			exit 430
		}
		
		scalar `ll' = e(ll)
		scalar `ll_r' = e(ll_r)
		scalar `t2' =  e(_meta_tau2)

		scalar `I2' = e(_meta_i2)
		scalar `h2' = e(_meta_h2)
		scalar `r2'  = cond("`model'"=="random", e(_meta_r2), .)
		scalar `Q'  = e(_meta_Q) 	
	}
		
	if "`wgtvar'" == "" {			
		qui gen double `w' = 1/(`SE'^2 + `t2') if `touse'
	}
	else {	// affects only bhat estim., should behave as in -meta summ-
		qui gen double `w' = `wgtvar' if `touse'
	}
	
	// -mse1- Thompson & Sharp 1999 sec.3
	qui regress `y' `varlist' [iw=`w'] if `touse', mse1 `constant'
	local wtype iweight
	
	if !missing("`multiplicative'") {
		tempname denom
		tokenize `xvars'
		cap scalar `denom' = ///
			cond(missing("`constant'"),_se[_cons],_se[`1'])
		if _rc {
			if missing("`constant'") scalar `denom' = _se[_cons]
			else scalar `denom' = _se[`1']
		}
		//  use -[w = `w']- when -multiplicative- is specified 
		// (see Thompson and Sharp 1999, table III method (2))
		qui regress `y' `varlist' [w=`w'] if `touse', `constant'
		tempname num phi // dispersion parameter
		cap scalar `num' = ///
			cond(missing("`constant'"),_se[_cons],_se[`1'])
		if _rc {
			if missing("`constant'") scalar `num' = _se[_cons]
			else scalar `num' = _se[`1']
		}	
		scalar `phi' = (`num'/`denom')^2
		local wtype aweight
	}	
	
	cap drop _meta_regweight
	qui gen double _meta_regweight = `w'
	label var _meta_regweight "Regression weights"
	qui compress _meta_regweight
	
	scalar `Q_kh' = e(rss)	// Q_kh = \sum W (yj - xj b)^2, W based on RE
				// Khartung used this version
	
	qui count if `touse'
	local nobs = r(N)
	
	/* iweights mess up residual df;  re-compute it: */
	scalar `df_m' = e(df_m)
	local df_Q = `nobs' - `df_m' - ("`constant'" == "")
	scalar `qkh' = `Q_kh'/`df_Q'
	
	matrix `b' = e(b)
		
	local DEPNAME = cond(missing("`depname'"), "`y'", "`depname'")
	if (!missing("`khartung'`tkhartung'") & "`model'"=="random") {

		scalar `q' = cond(!missing("`tkhartung'"), max(1,`qkh'), ///
			`qkh')
		matrix `V' = `q'*e(V)
		ereturn post `b' `V', depname("`DEPNAME'") obs(`nobs') ///
			esample(`touse') dof(`df_Q') buildfvinfo
		ereturn scalar seadj = `qkh'
	}
	else if "`tdistribution'"!="" {
		matrix `V' = e(V)
		ereturn post `b' `V', depname("`DEPNAME'") obs(`nobs') ///
			esample(`touse') dof(`df_Q') buildfvinfo
	}
	else {
		matrix `V' = e(V)
		ereturn post `b' `V', depname("`DEPNAME'") obs(`nobs') ///
			esample(`touse') buildfvinfo
	}
		
	local hidphi hidden
	cap confirm scalar `phi'
	if (!_rc) {
		ereturn scalar phi = `phi'
		local hidphi 
		local hidphihet hidden
	}
	
	if !missing("`xvars'")  qui test `xvars'
	tempname allcoef0 
	if ((!missing("`khartung'`tkhartung'") & "`model'"=="random") | ///
		("`tdistribution'"!="")) {
		scalar `allcoef0' = r(F)
		ereturn scalar F = `allcoef0'
		ereturn scalar df_r = `df_Q'
		ereturn scalar p = Ftail( `df_m', `df_Q', r(F))
	}
	else {
		scalar `allcoef0' = r(chi2)
		ereturn scalar chi2 = `allcoef0'
		ereturn scalar p = chi2tail( `df_m', r(chi2))
	}
	
	if "`model'"!="random" local hidre hidden
	else local hidphi 
	
	if "`model'"!= "common" {
		ereturn `hidre' scalar tau2 =  `t2'
		ereturn `hidphi' `hidphihet' scalar I2_res   = `I2'
		ereturn `hidphi' `hidphihet' scalar H2_res   = `h2'
		if `r2' < . ereturn scalar R2   = `r2'
		ereturn `hidphi' scalar Q_res    = `Q'
		ereturn `hidphi' scalar df_Q_res = `df_Q'
		ereturn `hidphi' scalar p_Q_res = chi2tail(`df_Q', `Q')
	}
	
	ereturn scalar level = `level'
	
	ereturn local  model      = "`model'"
	ereturn local  method     = "`method'"
	if !missing("`se'") ereturn local seadjtype = ///
		cond("`adjtype'"=="khartung", "knapp-hartung", ///
			"truncated knapp-hartung")
	
	ereturn hidden local wexp "= _meta_regweight" 
	ereturn hidden local wtype "`wtype'" 
	
	ereturn hidden local fixparam  = "`param'"
	ereturn hidden scalar noconstant = cond(missing("`constant'"), 0, 1)
	
	ereturn scalar df_m = `df_m'
	if `ll' < . {
		ereturn hidden scalar _meta_ll = `ll'
	}	
	if `ll_r' < . {
		ereturn hidden scalar _meta_ll_r = `ll_r'
	}	
	
	ereturn local estat_cmd meta_estat
	ereturn local predict "meta_cmd_regress_p"
	
	ereturn local title = ///
		cond("`model'"=="fixed", "Fixed-effects meta-regression", ///
			cond("`model'"=="random", 			  ///
			"Random-effects meta-regression", 		  ///	
			"Common-effect meta-regression"))		  
	ereturn local indepvars `"`xvars'"'
	ereturn local marginsok "default FITted XB"
	ereturn local marginsnotok ///
		"stdp RESiduals STDF REFfects XBU Hat Leverage"
	ereturn local marginsdefault "predict(fitted fixedonly)"
	
	ereturn local cmdline `"meta regress `0'"'
	ereturn local cmd "meta regress"
	ereturn hidden local cmd1 "meta_cmd_regress"
	ereturn hidden local tkhartung "`tkhartung'"
	
	Display, `diopts' `eform' `header' level(`level') ///
		`nometashow' `metashow1' testtype("`testtype'") ///
		tmpvar("`tmpvar'")
	//ereturn local depvar "`y'"
	local didconverge 1
	if "`iswarn'"=="1" {
		di as txt "Warning: `msg'"
		local didconverge 0
	}	
	
	if inlist("`method'","reml","ml", "ebayes", "pmandel") {
		ereturn scalar converged = `didconverge'
	}
	
end


program define Display
	version 16
	syntax [,  noHEADer NOMETASHOW METASHOW1 EForm testtype(string) ///
		tmpvar(string) *]
	
	tempname pval 
	
	_get_diopts diopts garbage, `options'
	if `= wordcount("`garbage'")' {
		gettoken first rest : garbage, bind
		local s = cond(`= wordcount("`rest'")',"s","")
		local verb = cond(`= wordcount("`rest'")',"are","is")
		di as err "option`s' {bf:`garbage'} `verb' not allowed on " ///
			"replay"
		exit 198
	}
	
	if !missing("`header'") local qui quietly
	
	if "`eform'" == "eform" {
		local eform eform(exp(b))
	}
	
	local global_metashow : char _dta[_meta_show]
	
	di
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
			meta__esize_desc, col(3) 
			di
	}
	
	MethDesc, method("`e(method)'")
	
	scalar `pval' = chi2tail(e(df_Q_res), e(Q_res))

	if "`e(seadj)'" != "" {
		local truncated = ///
			cond(missing("`e(tkhartung)'"), "" ," Truncated")
		local setxt ///
		`" as txt "SE adjustment:`truncated' Knapp-Hartung" "'
	}
	
	local pos1 53
	local eqpos 68
	`qui' di as txt "`e(title)'" ///
			_col(`pos1') "Number of obs" _col(`eqpos') "= " ///
				as res %9.0f e(N)
	
	local param =  cond("`e(fixparam)'" == "i2", "I2", "`e(fixparam)'")

	if "`e(model)'" == "random" {
		`qui' di as txt "Method: `methdesc'" as res " `param'" ///
			as txt _col(53) "Residual heterogeneity:" 
		`qui' di `setxt' as txt ///	
			_col(65) "tau2" _col(70) "=" as res %8.4g e(tau2)
		`qui' di as txt ///
			 _col(63) "I2 (%)" _col(70) "= " ///
			as res %7.2f e(I2_res)  
		`qui' di as txt ///
			 _col(67) "H2" _col(70) "= " ///
			as res %7.2f e(H2_res)  

		if "`e(R2)'" != "" {
			`qui' di as txt  _col(56) "R-squared (%)" _col(70) ///
			"= " _c
			`qui' di as res %7.2f e(R2) 
		}
	}	
	if "`e(phi)'" != "" {
		`qui' di as txt "Error: Multiplicative" ///
			 _col(`pos1') "Dispersion phi" _col(`eqpos') "= " ///
			as res %9.2f e(phi)
		local MethTxt `"as txt "Method: `methdesc' " "'
	}
	if "`e(model)'" == "fixed" {
		local MethTxt `"as txt "Method: `methdesc' " "'
	}
	
	/* Overall model fit */
	if "`e(df_r)'" == "" {
		`qui' di as txt `MethTxt' 		      ///
			_col(`pos1') "Wald chi2(" as res      ///
			e(df_m) as txt ")" _col(`eqpos') "= " ///
			as res %9.2f e(chi2)
		  
		  `qui' di as txt _col(`pos1') "Prob > chi2"  ///
			_col(`eqpos') "= " as res %9.4f e(p)
	}
	else {
		`qui' di as txt `MethTxt' 			///
			_col(`pos1') "Model F(" as res e(df_m)  ///
			as txt "," as res e(df_r) as txt ")"    ///
			_col(`eqpos') "= " as res %9.2f e(F)
		  `qui' di as txt _col(`pos1') "Prob > F"       ///
			_col(`eqpos') "= " as res %9.4f e(p)
	}
	
	MbiasTmpInfo, testtype("`testtype'") tmpvar("`tmpvar'")

	ereturn display,  `eform' `diopts'
	
	/* footnote */
	if "`e(model)'"!= "common" {
		if "`e(phi)'" != "" | "`e(model)'"=="random" {
di as txt "Test of residual homogeneity: Q_res = chi2("   ///
as res e(df_Q_res) as txt ") = " 			  ///
as res %5.2f e(Q_res) as txt _col(58) "Prob > Q_res = " ///
as res %5.4f = chi2tail(e(df_Q_res), e(Q_res))

		}
	}	
end

program MbiasTmpInfo
	syntax [, testtype(string) tmpvar(string)]
	
	version 16
	local l = strlen("`tmpvar'")
	local pos = 13 - `l'
	
	if "`testtype'" == "harbord" {
		di as txt _col(12) "Z : scores"
		di as txt _col(12) "V : scores variance"
		di as txt _col(`pos') "`tmpvar'" _col(14) ": 1/sqrt(V)"
		
	}
	else if "`testtype'" == "peters" {
		di as txt _col(`pos') "`tmpvar'" _col(14) ": 1/_meta_studysize"	
	}
	else {
		exit
	}
end

program MregCommonModErr
	version 16
	di as err "{p}{bf:meta regress} with moderators not " 	    ///
		"supported with a common-effect model{p_end}"
	di as err "{p 4 4 2}The declared model is a common-effect " ///
	  "model, which assumes no heterogeneity. Meta-regression " ///
	  "with moderators is thus not appropriate. If you want to fit " ///
	  "a constant-only regression, specify {bf:meta regress _cons}. " ///
	  "Otherwise, specify option {bf:fixed} or " ///
	  "{bf:random()} to fit a fixed-effects or random-effects " ///
	  "meta-regression.{p_end}"
end

program MethDesc
	version 16
	syntax [, method(string)]
			
	     if "`method'" == "dlaird" local methdesc = "DerSimonian-Laird"
	else if inlist("`method'","invvariance","ivariance") {
		local methdesc = "Inverse-variance"
	} 
	else if "`method'" == "mle" local methdesc = "ML"
	else if "`method'" == "reml" local methdesc = "REML" 
	else if "`method'" == "ebayes" local methdesc = "Empirical Bayes"
	else if "`method'" == "hedges" local methdesc = "Hedges"
	else if "`method'" == "hschmidt" local methdesc = "Hunter-Schmidt"
	else if "`method'" == "sjonkman" local methdesc = "Sidik-Jonkman"
	else if "`method'" == "pmandel" local methdesc = "Paule-Mandel"
	else if "`method'" == "sa" local methdesc = "User-specified"

	c_local methdesc `methdesc'
end

