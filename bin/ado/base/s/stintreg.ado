*! version 1.1.0  29mar2018
program define stintreg, eclass byable(onecall) sort ///
		prop(swml nohr hr tratio svyb svyj svyr mi)

	version 15
	local version : di "version " string(_caller()) ", missing:"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`version' `BY' _vce_parserun stintreg, noneedvarlist		///
		mark(STrata OFFset ANCillary anc2 CLuster) 	///
		numdepvars(0) : `0'

	if "`s(exit)'" != "" {
		ereturn local cmdline `"stintreg `0'"'
		exit
	}
	if replay() {
		if _by() { 
			error 190 
		}
		syntax [, DISTribution(string) /// 
			  INTerval(varlist numeric min=2 max=2) *]
		if "`distribution'"=="" {
			if "`e(cmd2)'" != "stintreg" { 
				error 301 
			} 
			if "`e(prefix)'" == "svy" {
				_prefix_display `0'
				exit
			}

			Display `0'
			exit 
		}
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"stintreg `0'"'
end

program Estimate, eclass byable(recall)

	version 15
	local vv : di "version " string(_caller()) ", missing:"
	syntax [varlist(default=empty fv)] [fw pw iw] [if] [in] /*
		*/ , INTerval(varlist numeric min=2 max=2) /*
		*/ DISTribution(string) /*
		*/ [CLuster(passthru) Level(cilevel)  /*
		*/ Robust EPSilon(numlist max=1 >0) /* 
		*/ FRAILty/*UNDOCUMENTED*/ SHared(varname)/*UNDOCUMENTED*/ /*
		*/ TIME TRatio noHR noHEADer SCore(passthru) noCOEF /* 
		*/ STrata(varname numeric fv) ANCillary(varlist numeric fv) /*
		*/ anc2(varlist numeric fv) noCONstant VCE(passthru) /*
		*/ FROM(string) OFFset(varname numeric) NOLOg LOg *]

	_get_diopts diopts options, `options'
	mlopts mlopts options, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'

	if "`epsilon'" == "" local epsilon = 1e-6

	if "`options'" != "" {
		di as err "option {bf:`options'} not allowed"
		exit 198
	}

	_vce_parse, argopt(CLuster) opt(Robust OIM OPG) old	///
		: [`weight'`exp'], `cluster' `robust' `vce'
	local robust `r(robust)'
	local cluster `r(cluster)'
	if "`robust'`cluster'" == "" {
		local options `"`options' `r(vceopt)'"'
	}

	gettoken ltime interval : interval
	gettoken rtime interval : interval
	
	_fv_check_depvar `ltime' `rtime', k(2)
	tempvar diff
	qui gen `diff' = `rtime' - `ltime'
	qui count if `diff' < 0 
	if `r(N)' > 0 {
		di as err "option {bf:interval()}: invalid syntax"
		di as err "{p 4 4 2}Left-censoring limit, {bf:`ltime'},"
		di as err "is larger than right-censoring limit, {bf:`rtime'}."
		di as err "This is not allowed. Perhaps,"
		di as err "you need to switch the order of variables in"
		di as err "option {bf:interval()}.{p_end}"
		exit 198
	}

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	if "`shared'" != "" {
		di as err "option {bf:shared()} is not allowed"
		exit 198
	}

	`vv' GetCmd `"`distribution'"' 
	local ecmd `s(cmd)'

	if "`strata'" != "" {
		if "`ancillary'" != "" {
			di as err "options {bf:strata()} and " ///
				"{bf:ancillary()} may not be specified " ///
				"together"
			exit 198
		}
		if "`anc2'" != "" {
			di as err "options {bf:strata()} and " ///
				"{bf:anc2()} may not be specified " ///
				"together"
			exit 198
		}
		if "`frailty'" != "" {
			di as err "options {bf:frailty} and " ///
				"{bf:strata()} may not be specified " ///
				"together"
			exit 198
		} 
	}
	
	if "`frailty'" != "" {
		if "`ancillary'" != "" {
			di as err "option {bf:ancillary()} is not allowed" ///
				" with option {bf:frailty}"
			exit 198
		}
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with option {bf:frailty}"
			exit 198
		}
	}

	GetClass `ecmd'
	local class `s(class)'

	// -tratio- and -nohr- check
	if "`ecmd'" == "gompertz" {
		if "`tratio'" != "" {
			di as err ///
			"option {bf:tratio} is not allowed with PH models"
			exit 198
		}
		if "`time'" != "" {
			di as err "option {bf:time} not allowed with " ///
				"Gompertz distribution"
			exit 198 
		}
	}
	else if "`ecmd'" == "ereg" | "`ecmd'" == "weibull"{
		if "`tratio'" != "" & "`time'" == "" {
			di as err ///
			"option {bf:tratio} is not allowed with PH models"
			exit 198
		}
		if "`hr'" != "" & "`time'" != "" {
			di as err ///
			"option {bf:nohr} is not allowed with AFT models"
			exit 198
		}
	}
	else {
		if "`hr'" != "" {
			di  as err ///
			"option {bf:nohr} is not allowed with AFT models"
			exit 198
		}
	}

	Opt_`class', `time' `tratio' `hr'
	local etime `s(etime)'
	local otime `s(otime)'
	local rotime `s(rotime)'

	if `level' != $S_level {
		local otime `"level(`level') `otime'"'
		local rotime `"level(`level') `rotime'"'
	}

	if "`weight'" != "" {
		local wgt "[`weight'`exp']"
		if "`weight'" == "pweight" {
			local robust "robust"
		}
	}

					/* identify estimation subsample */
	tempvar touse
	local rest , cluster(`cluster') strata(`strata')
	local rest `rest' offset(`offset') 
	icst_smpl `touse' `ltime' `rtime' `"`if'"' "`in'" "`wgt'" "`rest'"
	markout `touse' `varlist'
	if _by() {
		local byind "`_byindex'"
		qui replace `touse'=0 if `byind'!=_byindex()
		local byind
	}

	if `"`strata'"' != "" {
		local varlist `varlist' i.`strata'
		if "`ecmd'" != "ereg" {
			local ancillary `ancillary' i.`strata'
		}
		if "`ecmd'" == "gamma" {
			local anc2 `anc2' i.`strata'
		} 
	}
					/* shut off eform if appropriate */

	if `"`strata'`ancillary'`anc2'"' != "" {
		local noeform noeform
		if "`ecmd'" == "ereg" | "`ecmd'" == "weibull" | ///
		   "`ecmd'" == "gompertz" {
			if "`hr'" == "" & "`time'" == "" {
			di as txt ///
			"{p 0 6 2 80}note: option {bf:nohr} is implied " ///
			"if option {bf:strata()} or {bf:ancillary()} " ///
			"is specified{p_end}" 
			}
		} 
	}

					/* determine command arguments 	*/

	if "`cluster'"!="" {
		local cluster "cluster(`cluster')"
	}
	if "`constant'" != "" {
		local nvar : word count `varlist'
		if `nvar' == 0 {
			di as err "independent variables required " _c
			di as err "with option {bf:noconstant}"
			exit 100
		}
	}

					/* Create failure indicator */
	tempvar fail
	qui gen byte `fail' = .
	/* uncensored */
	qui replace `fail' = 1 if (`rtime'-`ltime')<=`epsilon' & `touse'
	/* right-censored */ 
	qui replace `fail' = 2 if `rtime' >= . & `touse'
	/* left-censored */
	qui replace `fail' = 3 if (`ltime' >= . | `ltime'==0) & `touse'
	/* interval-censored */
	qui replace `fail' = 4 if (`rtime'-`ltime')>`epsilon' & ///
			`fail'!=3  & `fail' != 2 & `touse'

					/* Count number of observations */
	_nobs `touse' `wgt'
	local N `r(N)'
	_nobs `touse' `wgt' if `fail' == 1, min(0)
	local Nunc `r(N)'
	_nobs `touse' `wgt' if `fail' == 2, min(0)
	local Nrc `r(N)'
	_nobs `touse' `wgt' if `fail' == 3, min(0)
	local Nlc `r(N)'
	_nobs `touse' `wgt' if `fail' == 4, min(0)
	local Nintc `r(N)'

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

	if "`constant'" != "" | "`from'" != "" {
		local skip = "skip"
		local search search(quietly)
		if "`log'" == "" {
			di _n as txt "Fitting full model:"
		}
	}

	GetMlProg,  ecmd(`ecmd') `time' `frailty' ///
		ancillary(`ancillary') anc2(`anc2')

	local mltype `s(mltype)'
	local mlprogname `s(progname)'
	local predictname `s(predict)'
	local anc `s(anc)'
	local ancdisp `s(ancdisp)'
	local aux `s(aux)'

	if "`score'" != "" {
		tempname b
		mat `b' = e(b)
		
		qui `vv' ml model `mltype' `mlprogname' ///
		(`ltime': `ltime' `rtime' `fail' = `varlist', ///
		`constant' `offopt') `anc' `wgt' if `touse', ///
		maximize missing iter(0) init(`b') search(off) ///
		nowarning `score'
 
		exit
	}

	eret clear

	if "`varlist'" != "" & "`skip'" == "" {
		if "`log'" == "" {
			di _n as txt "Fitting constant-only model:"
		}
		`vv' ml model `mltype' `mlprogname' ///
		(`ltime':`ltime' `rtime' `fail' = , `offopt') ///
		`anc' `wgt' if `touse', maximize missing search(quietly) ///
		`mllog' `coll' `cns' `vce' nocnsnotes noout wald(0) 

		local converged_cons = e(converged)

		tempname b_cons
		mat `b_cons' = e(b)

		if `converged_cons' {
			local cont continue
			local search search(off)
		}
		else {
			local init "init(`b_cons', skip)"
			local cont wald(1)
			local search search(quietly)
		}

		if "`log'" == "" {
			di _n as txt "Fitting full model:"
		}
	}
	else {
		if "`from'" != "" {
			local init "init(`from')"
		}
		local cont wald(1)
		local search search(quietly) 
	}

	`vv' ml model `mltype' `mlprogname' ///
	(`ltime': `ltime' `rtime' `fail' = `varlist', `constant' `offopt') ///
 	    `anc' `wgt' if `touse', maximize missing `search' `init' ///
	    `robust' `cluster' `mllog' `mlopts' `coll' `cns' `vce' `cont' ///
	    `ancdisp'

	if `class' == 1 {
		if "`time'" != "" {
			eret local frm2 "time"
		}
		else eret local frm2 "hazard" 
	}
	else if `class' == 2 {
		eret local frm2 "hazard"
	}
	else if `class' == 3 {
		eret local frm2 "time"
	}

	eret scalar N = `N'
	eret scalar N_unc = `Nunc'
	eret scalar N_lc = `Nlc'
	eret scalar N_rc = `Nrc'
	eret scalar N_int = `Nintc'
	eret scalar epsilon = `epsilon'
	eret hidden local eps_str `epsilon'
	eret local depvar `ltime' `rtime'
	eret local cmd `ecmd'
	eret local cmd2 stintreg

	SetTitle
	SetAncillary

	eret hidden local marginsprop `e(marginsprop)' nochainrule
	if "`noeform'" != "" {          /* eform not appropriate */
		eret hidden local noeform noeform
	}
	eret local marginsok default MEDian time mean LNTime hr xb
 	eret local marginsnotok HAzard stdp Surv CSNell MGale DEViance
	eret local predict_sub `predictname'
	eret local predict stintreg_p
	eret local estat_cmd stintreg_estat
	eret hidden local marginsfootnote _multirecordcheck
	if "`strata'" != "" eret local strata `strata'

	Display, `rotime' `header' `coef' `diopts'
end

program define Display
	syntax [, noHR TRatio noHEADer noCOEF Level(cilevel) *]
	_get_diopts diopts, `options'
	if "`e(frm2)'" == "hazard" {
		if "`tratio'"!="" {
			di as err ///
			"option {bf:tratio} is not allowed with PH models"
			exit 198
		}
		if "`hr'"=="" {
			local hr "hr"
		}
		else	local hr
	}
	else {
		if "`hr'"!="" {
			di as err ///
			"option {bf:nohr} is not allowed with AFT models"
			exit 198
		}
	}

	_coef_table_header, `header'

	if "`coef'"=="" {
		di
		if "`e(noeform)'" != "" {
			`e(cmd)', level(`level') nohead `diopts'
			if "`tratio'"!="" {
				di as txt ///
		"{p 0 6 2 `s(width)'}Note: Option {bf:tratio} ignored; " ///
				"not appropriate with {bf:strata()} " ///
				"or {bf:ancillary()} options{p_end}"
			}
		}
		else {
			if "`tratio'" != "" local tr tr

			`e(cmd)', `hr' `tr' level(`level') nohead `diopts'
			if "`hr'`tratio'"!="" {
				capture di _b[_cons]
				if _rc {
di as txt "{p}Note: No constant term was estimated in the main equation.{p_end}" 
				}
			}
		}
	}
	
	if e(converged_cons) == 0 & e(converged) == 1 {
		local astxt as txt as smcl
di `astxt' "{p 0 6 2 `s(width)'} Note: Constant-only model did not converge;" 
di `astxt' "Wald model test is reported." 
di `astxt' "{p_end}"		
	}	
	
end

program SetTitle, eclass

	local cmd `e(cmd)'

	if "`e(frm2)'"=="hazard" {
		local metric "PH"
	}
	if "`e(frm2)'"=="time" {
		local metric "AFT"
	}
	if "`cmd'"=="weibull" {
		ereturn local distribution "weibull"
		ereturn local title "Weibull `metric' regression"
		exit
	}
	if "`cmd'"=="ereg" {
		ereturn local distribution "exponential"
		ereturn local title "Exponential `metric' regression"
		exit
	}
	if "`cmd'"=="lnormal" {
		ereturn local distribution "lognormal"
		ereturn local title "Lognormal `metric' regression"
		exit
	}
	if "`cmd'"=="llogistic" {
		ereturn local distribution "loglogistic"
		ereturn local title "Loglogistic `metric' regression"
		exit
	}
	if "`cmd'"=="gamma" {
		ereturn local distribution "generalized gamma"
		ereturn local title "Generalized gamma `metric' regression"
		exit
	}
	if "`cmd'"=="gompertz" {
		ereturn local distribution "gompertz"
		ereturn local title "Gompertz `metric' regression"
		exit
	}
end

program SetAncillary, eclass

	local cmd `e(distribution)'
	tempname b 
	mat `b' = e(b)

	if "`cmd'"=="weibull" {
		local aux_n : colnfreeparms `b'
		if `aux_n' == 1 { 
			ereturn scalar aux_p = exp(_b[/ln_p])
			ereturn scalar k_aux = 1
		}
		exit
	}
	if "`cmd'"=="lognormal" {
		local aux_n : colnfreeparms `b'
		if `aux_n' == 1 { 
			ereturn scalar sigma = exp(_b[/lnsigma])
			ereturn scalar k_aux = 1
		}
		exit
	}
	if "`cmd'"=="loglogistic" {
		local aux_n : colnfreeparms `b'
		if `aux_n' == 1 { 
			ereturn scalar gamma = exp(_b[/lngamma])
			ereturn scalar k_aux = 1
		}
		exit
	}
	if "`cmd'"=="generalized gamma" {
		local aux_n : colnfreeparms `b'
		if `aux_n' == 2 { 
			ereturn scalar sigma = exp(_b[/lnsigma])
			ereturn scalar kappa = _b[/kappa]
			ereturn scalar k_aux = 2
		}
		exit
	}
	if "`cmd'"=="gompertz" {
		local aux_n : colnfreeparms `b'
		if `aux_n' == 1 { 
			ereturn scalar gamma = _b[/gamma]
			ereturn scalar k_aux = 1
		}
		exit
	}
end

program define GetCmd, sclass
	args dist 
	local vv = _caller()
	if "`dist'"=="" {
		/* default command */ 
		if "`e(cmd2)'"=="stintreg" { 
			sret local cmd "`e(cmd)'"
			exit
		}
		di as err "option {bf:distribution()} is required"
		exit 198
	}
	
	local l = length("`dist'")
	if bsubstr("exponential",1,max(1,`l')) == "`dist'" { 
		sret local cmd "ereg"
		exit
	}
	local l = length("`dist'")
	if bsubstr("ereg",1,max(1,`l')) == "`dist'" { 
		sret local cmd "ereg"
		exit
	}
	if bsubstr("weibull",1,max(1,`l')) == "`dist'" { 
		sret local cmd "weibull"
		exit
	}
	if bsubstr("lognormal",1,max(`l',4)) == "`dist'" | /*
 		*/ bsubstr("lnormal",1,max(`l',2)) == "`dist'" {
 		sret local cmd "lnormal"
 		exit
	}
	if bsubstr("loglogistic",1,max(`l',4))  == "`dist'"  | /*
 		*/ bsubstr("llogistic",1,max(`l',2)) == "`dist'"  {
		sret local cmd "llogistic"
 		exit
	}
	if bsubstr("gompertz",1,max(3,`l')) == "`dist'" {
		sret local cmd "gompertz"
 		exit
	}
	if bsubstr("ggamma",1,max(4,`l')) == "`dist'" {
		sret local cmd "gamma"
		exit
	}
	if "`dist'"==bsubstr("gamma",1,max(3,`l')) {
 		di in red "option {bf:distribution()}: " ///
			  "unknown distribution {bf:`dist'}"
 		di in red "{p 4 4 2}For the generalized gamma " ///
 			"distribution, use {bf:distribution(ggamma)}.{p_end}"
 		exit 198
 	}
	di in red "unknown distribution {bf:`dist'} " ///
		  "in option {bf:distribution()}"
	exit 198 
end

program define GetClass, sclass
	args cmd 
	if "`cmd'"=="ereg" | "`cmd'"=="weibull" {  
		sret local class 1
		exit
	}
	if "`cmd'"=="gompertz" {
		sret local class 2
		exit
	}
	if "`cmd'"=="lnormal" | "`cmd'"=="llogistic" | "`cmd'"=="gamma" {
		sret local class 3
		exit
	}
	
	error 301
end

program define Opt_1, sclass
	syntax [, noHR TIme TRatio]
	if "`time'"!="" | "`tratio'"!="" { 
		sret local etime /*nothing*/
		sret local otime `tratio'
		sret local rotime `tratio'
	}
	else {
		sret local etime hazard
		if "`hr'"=="" {
			sret local otime hr
			sret local rotime 
		}
		else {
			sret local otime /*nothing*/
			sret local rotime nohr
		}
	}
end

program define Opt_2, sclass
	syntax [, noHR]
	sret local etime /*nothing*/
	if "`hr'"=="" {
		sret local otime hr
		sret local rotime /*nothing*/
	}
	else {
		sret local otime
		sret local rotime nohr
	}
end
		

program define Opt_3, sclass
	syntax [, TIme TRatio]
	sret local etime /*nothing*/
	sret local otime `tratio'
	sret local rotime `tratio'
end
	
program define GetMlProg,  sclass

	syntax [, ecmd(string) TIme FRAILty ///
		  ancillary(string) anc2(string) ]

	if "`ecmd'" == "ereg" {
		if "`ancillary'" != "" {
			di as err "option {bf:ancillary()} is not allowed" ///
				" with {bf:distribution(exponential)}"
			exit 198
		}
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with {bf:distribution(exponential)}"
			exit 198
		}
		if "`frailty'" != "" {
			local mltype lf0
			if "`time'" == "" {
				local mlprogname ereg_ic_ll_fr
			}
			else {
				local mlprogname ereg2_ic_ll_fr
			}
			local anc "(lntheta:, freeparm)"
			local aux = 1
		}
		else if "`time'" == "" {
			local mltype lf2
			local mlprogname ereg_ic_ll
		}
		else {
			local mltype lf2
			local mlprogname ereg2_ic_ll
		}
		local predict ereg_ic_p
	}
	else if "`ecmd'" == "weibull" {
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with {bf:distribution(weibull)}"
			exit 198
		}
		if "`frailty'" != "" {
			local mltype lf0
			if "`time'" == "" {
				local mlprogname weib_ic_ll_fr
			}
			else {
				local mlprogname weib2_ic_ll_fr
			}
			local anc "(ln_p:, freeparm) (lntheta:, freeparm)"
			local ancdisp "diparm(ln_p, exp label("p"))"
			local ancdisp ///
		"`ancdisp' diparm(ln_p, f(exp(-@)) d(exp(-@)) label("1/p"))"
			local ancdisp ///
				"`ancdisp' diparm(lntheta, exp label("theta"))"

			local aux = 2
		}
		else {
			if "`time'" == "" {
				local mltype lf0
				local mlprogname weib_ic_ll
			}
			else {
				local mltype lf0
				local mlprogname weib2_ic_ll
			}
			if "`ancillary'" == "" {
				local anc "(ln_p:, freeparm)"
				local ancdisp "diparm(ln_p, exp label("p"))"
				local ancdisp ///
	"`ancdisp' diparm(ln_p, f(exp(-@)) d(exp(-@)) label("1/p"))"
			}
			else {
				local anc "(ln_p: `ancillary')"
			}
			local aux = 1
		}
		local predict weib_ic_p
	}
	else if "`ecmd'" == "gompertz" {
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with {bf:distribution(gompertz)}"
			exit 198
		}
		if "`frailty'" != "" {
			local mltype lf0
			local mlprogname gomp_ic_ll_fr
			local anc "(gamma:, freeparm) (lntheta:, freeparm)"
			local ancdisp "diparm(lntheta, exp label("theta"))"
			local aux = 2
		}
		else {
			local mltype lf0
			local mlprogname gomp_ic_ll
			if "`ancillary'" == "" {
				local anc "(gamma:, freeparm)"
			}
			else {
				local anc "(gamma: `ancillary')"
			}
			local aux = 1
		}
		local predict gomper_ic_p
	}
	else if "`ecmd'" == "lnormal" {
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with {bf:distribution(lognormal)}"
			exit 198
		}
		if "`frailty'" != "" {
			local mltype lf0
			local mlprogname lnorm_ic_ll_fr
			local anc "(lnsigma:, freeparm) (lntheta:, freeparm)"
			local ancdisp "diparm(lnsigma, exp label("sigma"))"
			local ancdisp ///
				"`ancdisp' diparm(lntheta, exp label("theta"))"
			local aux = 2
		}
		else {
			local mltype lf0
			local mlprogname lnorm_ic_ll
			if "`ancillary'"=="" {
				local anc "(lnsigma:, freeparm)"
			local ancdisp "diparm(lnsigma, exp label("sigma"))"
			}
			else {
				local anc "(lnsigma: `ancillary')"
			}
			local aux = 1
		}		
		local predict lnorm_ic_p
	}
	else if "`ecmd'" == "llogistic" {
		if "`anc2'" != "" {
			di as err "option {bf:anc2()} is not allowed" ///
				" with {bf:distribution(llogistic)}"
			exit 198
		}
		if "`frailty'" != "" {
			local mltype lf0
			local mlprogname logis_ic_ll_fr
			local anc "(lngamma:, freeparm) (lntheta:, freeparm)"
			local ancdisp "diparm(lngamma, exp label("gamma"))"
			local ancdisp ///
				"`ancdisp' diparm(lntheta, exp label("theta"))"
			local aux = 2
		}
		else {
			local mltype lf0
			local mlprogname logis_ic_ll
			if "`ancillary'"=="" {
				local anc "(lngamma:, freeparm)"
			local ancdisp "diparm(lngamma, exp label("gamma"))"
			}
			else {
				local anc "(lngamma: `ancillary')"
			}
			local aux = 1
		}
		local predict llog_ic_p
	}
	else if "`ecmd'" == "gamma" {
		if "`frailty'" != "" {
			local mltype lf0
			local mlprogname gamma_ic_ll_fr
	local anc "(lnsigma:, freeparm)(kappa:, freeparm)(lntheta:, freeparm)"
 			local ancdisp "diparm(lnsigma, exp label("sigma"))"
			local ancdisp ///
				"`ancdisp' diparm(lntheta, exp label("theta"))"
			local aux = 3
		}
		else {
			local mltype lf0
			local mlprogname gamma_ic_ll
			local anc "(lnsigma: `ancillary') (kappa: `anc2')"
			if "`ancillary'"=="" & "`anc2'"=="" {
			local anc "(lnsigma:, freeparm) (kappa:,freeparm)"
			local ancdisp "diparm(lnsigma, exp label("sigma"))"
			}
			else if "`ancillary'" != "" & "`anc2'" == "" {
			local anc "(lnsigma: `ancillary') (kappa:,freeparm)"
			}
			else if "`ancillary'" == "" & "`anc2'" != "" {
			local anc "(lnsigma:,freeparm) (kappa: `anc2')"
			}
			local aux = 2
		}
		local predict gamma_ic_p
	}

	sret local mltype `mltype'
	sret local progname `mlprogname'
	sret local predict `predict'
	sret local anc `anc'
	sret local ancdisp `ancdisp'
	sret local aux `aux'
end

exit

Concerning GetClass returns 

        s(class)        1 ln time/ln hazard command
			2 ln hazard command 
                        3 ln time command 

A class-1 command: 
     1)  defaults to estimating results in the ln hazard metric;
         a)  reports hazard ratio by default 
         b)  the -nohr- option will report coefficients
     2)  the -time- option will estimate in the ln time metric; 
         a)  reports coefficients by default
         b)  the -tratio- option will report coefficients as ratios;
     3)  A class-1 command fills in e(frm2) with "hazard" or "time" 
         depending on metric.
Examples are -weibull- and -exponential-

A class-2 command:
    1)  estimates in the ln hazard metric 
        a) by default, reports hazard ratio
        b) the -nohr- option will report coefficients
    2)  A class-2 command fills in e(frm2) with "hazard"
Examples are -gompertz-

A class-3 command:
    1)  estimates in the ln time metric
        a) by default, reports coefficients 
        b) the -tratio- option will report coefficients as ratios
    2)  A class-3 command fills in e(frm2) with "time"
Examples are -lnormal-.

-stintreg- works like this:

    1)  Estimates in the ln hazard metric if possible.
        a)  reports coefficients as hazard ratios by default
        b)  the -nohr- option will report coefficients

        c)  estimates in ln time metric if option -time- is specified
        d)  reports coefficients by default
        e)  reports ratios if option -tratio-

    2)  If only ln hazard is allowed:
        a)  reports coefficients as hazard ratios by default
        b)  the -nohr- option will report coefficients

    3)  If only ln time is allowed:
        a)  may specify option -time- or not; it makes no difference
        d)  reports coefficients by default
        c)  reports ratios if option -tratio-

So, options are -nohr-, -time-, and -tratio-.  They map like this:

    Class 1:            Est options            Display options
         <none>         hazard                 hr
         nohr           hazard     
         time      
         tratio                                    tratio
	 time tratio                               tratio
    Class 2:
         <none>                                hr
         nohr
    Class 3:
         <none>
         time
         tratio                                    tratio
         time tratio                               tratio


