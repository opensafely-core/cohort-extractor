*! version 2.8.0  27mar2018
program stcox_fr, eclass byable(onecall) sort prop(swml hr)
	version 8.1, missing
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`version' `BY' _vce_parserun stcox, stdata	///
		mark(STrata SHared OFFset tvc CLuster) 	///
		numdepvars(0) : `0'
	if "`s(exit)'" != "" {
		exit
	}

	if replay() {
		syntax [, ESTImate * ]
		if `"`estimate'"'=="" {
			if _by() {
				error 190 
			}
			if `"`e(cmd)'"' != "stcox_fr" {
				error 301
			}
			`version' ///
			Display `0'
			exit
		}
	}
	`version' `by' Estimate `0'
end

program Estimate, eclass byable(recall) sort
	local vv : di "version " string(_caller()) ":"
	
	version 8.1, missing
	st_is 2 analysis

	if _caller() < 14 {
		local TVCOPT TVC(varlist)
	}
	else {
		local TVCOPT TVC(varlist fv)
	}

	syntax [varlist(default=none fv)] [if] [in], /*
	*/ SHared(varname) [ FRailty(string) Robust CLuster(passthru) /*
	*/ CMD ESTImate noHR Level(cilevel) noSHow NOLOg LOg /*
	*/ BREslow EFRon EXACTM EXACTP STrata(passthru) noHEADer noCOEF /*
	*/ BASEHC(passthru) BASEChazard(passthru) BASESurv(passthru) /*
	*/ MGale(passthru) esr(passthru) noLRtest EFFects(string) /*
	*/ SCHoenfeld(passthru) SCAledsch(passthru) `TVCOPT' /*
	*/ OFFset(varname) texp(passthru) altvce(name) VCE(passthru) /* 
	*/ FORCESHARED * ]

	// NOTE: altvce() is an undocumented option set by _vce_parserun for
	// the purpose of generating an improved error message when this
	// command is called with an option that generates a variable along
	// with an alternative <vcetype> that resamples the data.
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}


	if `"`frailty'"' != "" {
		local l = length(`"`frailty'"') 
		if bsubstr("gamma",1,max(1,`l')) != `"`frailty'"' {
			di as err /*
			*/ `"frailty distribution `frailty' not allowed"'
			exit 198 
		}
	}

	_get_diopts diopts options, `options'
	NotAllowed `exactm' `exactp' `robust' `"`cluster'"' `"`strata'"'
	_vce_parse, argopt(CLuster) opt(OIM Robust) :, `vce'
	if "`r(cluster)'`r(robust)'" != "" {
		NotAllowed "`r(vceopt)'"
	}

	if _by() {
		_byoptnotallowed basehc()      `"`basehc'"'
		_byoptnotallowed basechazard() `"`basechazard'"'
		_byoptnotallowed basesurv()    `"`basesurv'"'
		_byoptnotallowed mgale()       `"`mgale'"'
		_byoptnotallowed esr()         `"`esr'"'
		_byoptnotallowed schoenfeld()  `"`schoenfeld'"'
		_byoptnotallowed scaledsch()   `"`scaledsch'"'
		_byoptnotallowed effects()     `"`effects'"'
	}

	if "`altvce'" != "" {
		_prefix_vcenotallowed "`altvce'" basehc()      `"`basehc'"'
		_prefix_vcenotallowed "`altvce'" basechazard() `"`basechazard'"'
		_prefix_vcenotallowed "`altvce'" basesurv()    `"`basesurv'"'
		_prefix_vcenotallowed "`altvce'" mgale()       `"`mgale'"'
		_prefix_vcenotallowed "`altvce'" esr()         `"`esr'"'
		_prefix_vcenotallowed "`altvce'" schoenfeld()  `"`schoenfeld'"'
		_prefix_vcenotallowed "`altvce'" scaledsch()   `"`scaledsch'"'
	}

	if "`tvc'" != "" {
		_tvc_notallowed basechazard()	`"`basechazard'"'
		_tvc_notallowed basehc()	`"`basehc'"'
		_tvc_notallowed basesurv()	`"`basesurv'"'
		_tvc_notallowed effects()	`"`effects'"'
		_tvc_notallowed esr()		`"`esr'"'
		_tvc_notallowed mgale()		`"`mgale'"'
		_tvc_notallowed scaledsch()	`"`scaledsch'"'
		_tvc_notallowed schoenfeld()	`"`schoenfeld'"'
	}

	mlopts mlopts options, `options' `log' `nolog'
	if `"`s(collinear)'"' != "" {
		di as err "option collinear not allowed"
		exit 198
	}
	local cns `s(constraints)'
	if `"`options'"' != "" {
		local word : word 1 of `options'
		di as err `"option `word' not allowed"'
		exit 198
	}
	if "`cns'" != "" {
		local lrtest nolrtest
	}

	local id : char _dta[st_id]
	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]
	local t0 `"t0(_t0)"'
	local d `"dead(_d)"'

	tempvar touse 
	st_smpl `touse' `"`if'"' `"`in'"' `"`shared'"'
	markout `touse' `varlist' `tvc'
	if _by() {
		qui replace `touse'=0 if `_byindex'!=_byindex()
	}

	local passthru `basehc' `basechazard' `basesurv' `mgale' /*
		*/ `esr' `schoenfeld' `scaledsch'

	fvexpand `varlist' if `touse'
	local varlist `"`r(varlist)'"'
	if _caller() >= 14 {
		fvexpand `tvc' if `touse'
		local tvc `"`r(varlist)'"'
	}

	local nv : list sizeof varlist
	local ntvc : list sizeof tvc
	local nv = `nv' + `ntvc'
	if `"`passthru'"' != "" {
		CheckPass, `passthru' nv(`nv')  /* If fail, then fail early */
		local passvars `s(passvars)'
	}

	_st_err_sharedgaps "`shared'" "`forceshared'" "`touse'"
	local fvtvc 0
	if `"`tvc'"'!="" & _caller() < 14 {
		// tvc() has a limit of 100 variables
		if `ntvc' > 100 {
			di as err "too many variables specified"
			di as err "option tvc() incorrectly specified"
			exit 198 
		}
		version 11: _rmcoll `tvc', forcedrop
		local tvcvars `r(varlist)'
		local tvc `"tvc(`tvcvars')"'
	}
	else if `"`tvc'"'!="" {
		// tvc() has a limit of 100 variables
		if `ntvc' > 100 {
			di as err "too many variables specified"
			di as err "option tvc() incorrectly specified"
			exit 198 
		}
		version 14: _rmcoll `tvc', expand
		local tvcvars `r(varlist)'
		fvrevar `tvcvars'
		local ttvcvars `r(varlist)'
		if !`: list tvcvars == ttvcvars' {
			local fvtvc 1
		}
		local tvc `"tvc(`ttvcvars')"'
	}

	if "`offset'"!="" {
		local offopt offset(`offset')
	}

	if `"`cmd'"'!="" {
		di as err "no equivalent " as inp "cox " _c
		di as err "command for shared frailty models"
		exit 198
	}
	
	if `"`wt'"' != "" {
		if `"`wt'"'!="iweight" {
			di as err "only iweights are allowed"
			exit 198
		}
		CheckWgt `shared' `w' if `touse'
	}

	if `"`effects'"' != "" {
		local i : word count `effects'
		if `i' != 1 {
di as err "effects() invalid:  only one new variable name required"
			exit 198
		}
		confirm new var `effects' `passvars'
	}

	tempvar shareid
	tempname fmat 
	qui egen long `shareid' = group(`shared') if `touse'
	qui summ `shareid' if `touse', meanonly
	local ngroup = r(max)
	if `ngroup' <= 1 {
		di as err "`shared' must define more than one group"
		exit 198
	}

	ChkMatsize `=`ngroup' + `nv''

	if `"`_dta[st_id]'"' != "" {
		local subid `_dta[st_id]'
	}

	if `"`subid'"' != "" {
		tempvar diff
		sort `touse' `subid' `shareid'
		qui by `touse' `subid': gen long `diff' = /*
			*/ `shareid' - `shareid'[_n-1] if `touse'
		capture assert `diff'==0 if !missing(`diff') & `touse'
		if _rc {
			local warn warn
		}
		drop `diff'
	}

	tempvar nn
	gen `c(obs_t)' `nn' = _n
	sort `touse' `shareid' `nn'

	`vv' ///
	_rmcoll `varlist' `w' if `touse'
	local varlist "`r(varlist)'"

	global COXFshared `shareid'
	global COXFfrom `fmat'
	global COXFcmd cox _t `varlist' `w' if `touse', 
	global COXFcmd $COXFcmd `offopt' `t0' `d' `tvc' 
	global COXFcmd `vv' $COXFcmd `texp' `breslow' `efron',

	st_show `show'

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local nodi *
	}
	if "`lrtest'" == "" {
		tempname ll_c
		`nodi'di _n as txt "Fitting comparison Cox model:"

		qui $COXFcmd, nocoef norefine  // quietly intentional
		scalar `ll_c' = e(ll)
	}

	`nodi'di _n as txt "Estimating frailty variance:"

	ml model d0 stcox_fr_ll (lntheta:), max nopreserve search(quietly) /*
		*/ crittype(log profile likelihood) collinear missing /*
		*/ noscvars `mlopts'

	tempname theta se_theta
	scalar `theta' = exp(_b[_cons])
	scalar `se_theta' = `theta'*_se[_cons]

	`nodi'di _n as txt "Fitting final Cox model:"

	local ngg `ngroup'
	if `theta' < 1e-12 {
		$COXFcmd, `options' `passthru' nocoef `log'
		local ngg 0
	}
	else {
		local th = `theta'
		$COXFcmd, `passthru' gampen(`shareid') /*
		*/ theta(`th') nocoef `log'
	}

	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)

	local dim = colsof(`b') - `ngg'

	/* Save off random effects if desired */
	if "`effects'" != "" {
		qui gen double `effects' = `b'[1,`dim'+`shareid'[_n]] /*
			*/ if `touse'
	}

	if `dim' > 0 {
		mat `b' = `b'[1,1..`dim']
		mat `V' = `V'[1..`dim',1..`dim']
		if `fvtvc' {
		    local stripe : colna `b'
		    local ntvc : list sizeof ttvcvars
		    local TVCVARS : copy local tvcvars
		    forval i = 1/`ntvc' {
			gettoken tvar ttvcvars : ttvcvars 
			gettoken xvar TVCVARS : TVCVARS 
			if "`tvar'" != "`xvar'" {
				local stripe : subinstr local stripe	///
					"`tvar'" "`xvar'", word all
			}
		    }
		    matrix colna `b' = `stripe'
		    matrix colna `V' = `stripe'
		    matrix rowna `V' = `stripe'
		}
		ereturn post `b' `V', noclear depname("_t") buildfvinfo ///
			ADDCONS
		_post_vce_rank
	}
	else {
		tempname hold
		capture noisily nobreak {
			_estimates hold `hold'
			qui cox _t if `touse', dead(_d)
			mat `b' = e(b)
			mat `V' = e(V)
			_estimates unhold `hold'
		}
		ereturn post `b' `V', noclear depname("_t")
		_post_vce_rank, checksize
	}

	`vv' ///
	WaldTest
	
	if e(N)==0 | e(N)>=. { 
		exit 2001 
	}
	/* inherits e() stuff from -cox- */

	ereturn scalar theta = `theta'
	ereturn scalar se_theta = `se_theta'
	ereturn local ll_0 
	ereturn local r2_p
	if "`lrtest'" == "" {
		ereturn scalar ll_c = `ll_c'
		ereturn scalar chi2_c = max(0,2*(e(ll)-e(ll_c))) 
		ereturn scalar p_c = chi2tail(1, e(chi2_c))*0.5
	}

	SaveGrpInfo `shareid' `touse' `w'
	if "`warn'"!="" {
		eret local sh_warn sh_warn
	}
	SaveOpt, `passthru'

	st_hc `touse'

	if "`effects'" != "" {
		ereturn local re_var `effects'
	}
	ereturn local shared `shared'
	ereturn local predict stcox_p
	ereturn hidden local marginsprop addcons
	ereturn hidden local marginsfootnote _multirecordcheck
	ereturn local cmd2 "stcox"
	ereturn local cmd "stcox_fr"
	local offset `e(offset)'
	ereturn local offset1 `offset'
	ereturn local offset `offset'
	ereturn local estat_cmd stcox_estat
	ereturn local vce oim		// default
	global S_E_cmd2 "stcox"		/* double save */
	tempname b
	mat `b' = e(b)
	_ms_omit_info `b'
	local cols = colsof(`b')
        if `r(k_omit)' {
		if `r(k_omit)'==`cols' {
		  local varlist ""
		}
		else {
                  mata : ///
                  st_local("varlist",invtokens(select(st_matrixcolstripe ///
                  ("`b'")[.,2]',1:-st_matrix("r(omit)"))))
		}
        }
	else {
		local varlist `varlist' `tvcvars'
	}
        unopvarlist `varlist'
        local varlist `r(varlist)'
	signestimationsample _t _t0 _d `varlist' `e(shared)' ///
				       `e(offset)'

	macro drop COXFshared COXFcmd COXFfrom

	`vv' ///
	Display, `hr' level(`level') `header' `coef' `diopts'
end

program NotAllowed
	forvalues i = 1/5 {
		if `"``i''"' != "" {
			di as err /*
			*/`"option ``i'' not allowed for shared frailty models"'
			local error error
		}
	}
	if "`error'" != "" {
		exit 198
	}
end


program SaveOpt, eclass
	syntax [, MGale(string) BASEHC(string) BASEChazard(string) /*
		*/ BASESurv(string) SCHoenfeld(string) /*
		*/ SCAledsch(string) ESR(string) * ]
	eret local mgale "`mgale'"
	eret local basehc "`basehc'"
	eret local baseh "`basedchazard'"
	eret local basech "`basechazard'"
	eret local bases "`basesurv'"

	SaveNm vl_sch "`schoenfeld'" "Schoenfeld"
	SaveNm vl_ssc "`scaledsch'" "scaled Schoenfeld"
	SaveNm vl_esr "`esr'"	  "efficient score"

	if "`mgale'" != "" { 
		label var `mgale' "martingale" 
	}
	if "`basehc'" != "" { 
		label var `basehc' "baseline hazard contribution"
	}
	if "`basesurv'" != "" { 
		label var `basesurv' "baseline survivor" 
	}
	if "`basechazard'"!= "" { 
		label var `basechazard' "cumulative baseline hazard" 
	}
end

program SaveNm, eclass
	args name base lname 

	if "`base'" == "" { 
		exit 
	}

	tempname b
	mat `b' = get(_b)
	local p = colsof(`b')
	local names : colnames(`b')

	local j = index("`base'","*")
	if `j' {
		local base = bsubstr("`base'",1,`j'-1)
		local i 1
		while `i' <= `p' {
			local iname : word `i' of `names'
			label var `base'`i' "`lname' - `iname'"
			local list `list' `base'`i'
			local i = `i'+1
		}
	}
	else {
		tokenize `base'
		local i 1
		while `i' <= `p' {
			local iname : word `i' of `names'
			label var ``i'' "`lname' - `iname'"
			local list `list' ``i''
			local i = `i'+1
		}
	}
	eret local `name' `list'
end

program SaveGrpInfo, eclass
	syntax varlist(min=2  max=2) [iw]
	tokenize `varlist' 
	local gvar `1'
	local touse `2'
	tempvar T w
	if "`weight'"=="iweight" {
		qui gen double `w' `exp' if `touse'
		qui by `touse' `gvar': gen long `T' = sum(`w'*`touse')  
		qui by `touse' `gvar': replace `T' = . if _n!=_N
		summarize `T', meanonly
	}
	else {
		qui by `touse' `gvar': gen `c(obs_t)' `T' = _N if _n==1 & `touse'
		summarize `T' if `touse', meanonly
	}
	eret scalar N_g = r(N)
	eret scalar g_min = r(min)
	eret scalar g_max = r(max)
	eret scalar g_avg = r(mean)
end

program CheckWgt
	syntax varname [if] [iweight]

	marksample touse, strok
	if "`weight'"!="" {
		tempvar w
		qui gen double `w' `exp'
		sort `touse' `varlist'
		_crcchkw `varlist' `w' `touse'
		drop `w'
	}
end

program CheckPass, sclass
	syntax [, BASEHC(string) BASEChazard(string) BASESurv(string) /*
	*/ MGale(string) esr(string) /*
	*/ SCHoenfeld(string) SCAledsch(string) nv(integer 0) ]
	
	foreach opt in basehc basechazard basesurv mgale { 
		CheckSingle `"``opt''"' `opt'
		local newvars `newvars' ``opt''
	}
	foreach opt in esr schoenfeld scaledsch {
		CheckMultiple `"``opt''"' `opt' `nv'
		local newvars `newvars' `s(vlist)'
	}
	confirm new variable `newvars'
	sreturn local passvars `newvars'
end

program CheckSingle
	args vlist optname

	if `"`vlist'"' != "" {
		local n : word count `vlist'
		if `n' != 1 {
di as err `"`optname'() invalid:  one new variable name required"'
			exit 198
		}
		confirm new var `vlist'
	}
end

program CheckMultiple, sclass
	args vlist optname nvars

	if `"`vlist'"' != "" {
		local n : word count `vlist'
		if `n'==1 & bsubstr(`"`vlist'"',-1,1)=="*" {
			local stub = /*
			*/ bsubstr(`"`vlist'"',1,length(`"`vlist'"')-1)
			local vlist
			forvalues i = 1/`nvars' {
				local vlist `vlist' `stub'`i'
			}
			local n `nvars'
		}
		if `n' != `nvars' {
di as err `"`optname'() invalid:  `nvars' new variable name(s) required"'
			if `n' > `nvars' {
				exit 103 
			}
			else {
				exit 102
			}
		}
		confirm new var `vlist'
	}
	sreturn local vlist `vlist'
end

program ChkMatsize
	args n
	if c(max_matdim) < `n' {
		error 915
	}
end

program WaldTest, eclass

	eret local chi2type Wald

	tempname b
	mat `b' = e(b)
	local names : colnames `b'	
	capture test `names'
	
	if !_rc {
		eret scalar chi2 = r(chi2)
		eret scalar df_m = r(df)
	}
	else {
		eret scalar chi2 = 0
		eret scalar df_m = 0
	}
end
	
program Display, eclass
	local vv : di "version " string(_caller()) ", missing:"
	syntax [, noCOEF noHEADer noHR Level(cilevel) *]	

	_get_diopts diopts, `options'
	if "`header'" == "" {
		DiHeader 
	}
	di
	if "`coef'" != "" {
		exit
	}
	local offset `e(offset)'
	ereturn local offset
	if "`hr'" != "" {
		_coef_table, level(`level') plus `diopts'
	}
	else {
		_coef_table, level(`level') eform("Haz. Ratio") plus `diopts'
	}
	if `"`s(width_col1)'"' != "" {
		local w1 = s(width_col1)
		local wrest = `s(width)' - `w1' - 1
	}
	else {
		local w1 13
		local wrest 64
	}
	local w1fmt = `w1' - 1
	ereturn local offset `offset'
	di as txt %`w1fmt's "theta" " {c |}  " as res /*
	*/ %9.0g e(theta) _s(2) %9.0g e(se_theta)
	di as txt "{hline `w1'}{c BT}{hline `wrest'}"
	`vv' ///
	DiFooter, `hr'
end

program DiHeader
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)
	local crlen = max(15,length(`"`crtype'"'))
	local h1 no ties
	if "`e(ties)'"=="breslow" {
		local h1 Breslow method for ties
	}
	else if "`e(ties)'"=="efron" {
		local h1 Efron method for ties
	}

	di
	di as txt "Cox regression -- `h1'"
	di
	di as txt "Gamma shared frailty" _col(49) as txt /*
		*/ "Number of obs" _col(67) "=" _col(69) as res /*
		*/ %10.0fc e(N)
	di as txt "Group variable: " as res abbrev("`e(shared)'",12) /*
		*/ _col(49) as txt "Number of groups" _col(67) "=" /*
		*/ _col(69) as res %10.0fc e(N_g) 
	di _col(49) as txt "Obs per group:"

	di as txt %-`crlen's "No. of subjects" " = " as res %12.0fc /*
		*/ e(N_sub) _col(63) /*
		*/ as txt "min = " as res %10.0fc e(g_min)

	di as txt %-`crlen's "No. of failures" " = " /*
		*/ as res %12.0fc `e(N_fail)'/*
		*/ _col(63) as txt "avg" " = " as res %10.0gc e(g_avg)
	di as txt %-`crlen's "Time at risk" " = " as res %12.0g e(risk) /*
		*/ _col(63) as txt "max" " = " as res %10.0fc e(g_max)
	di
    if "`e(df_r)'" != "" {
	di _col(49) as txt "F(" as res %4.0f e(df_m) as txt"," /*
		*/ as res %7.0f e(df_r) as txt ")" /*
		*/ _col(67) "= " _col(70) as res %9.2f e(F)

	di as txt %-`crlen's "`crtype'" " =   " as res %10.0g e(ll) /*
		*/ _col(49) as txt "Prob > F" _col(67) "=" _col(73) /*
		*/ as res %6.4f Ftail(e(df_m), e(df_r), e(F))
    }
    else {
	di _col(49) as txt "`e(chi2type)' chi2(" as res e(df_m) as txt ")" /*
		*/ _col(67) "= " _col(70) as res %9.2f e(chi2)

	di as txt %-`crlen's "`crtype'" " =   " as res %10.0g e(ll) /*
		*/ _col(49) as txt "Prob > chi2" _col(67) "=" _col(73) /*
		*/ as res %6.4f chiprob(e(df_m), e(chi2))
    }
end

program DiFooter
	syntax [, noHR]
	if "`e(ll_c)'"!="" {
		if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e4)) /*
       	         */ | (e(chi2_c)==0) { 
	  		local fmt "%8.2f"
		}
		else local fmt "%8.2e"
		
		local chi : di `fmt' e(chi2_c)
		local chi = trim("`chi'")

		di in smcl as txt "LR test of theta=0: " as txt ///
			"{help j_chibar##|_new:chibar2(01) = }" ///
			as res "`chi'" _col(56) as txt "Prob >= chibar2 = " ///
			as res %5.3f e(p_c)
	}
	if "`hr'" == "" {
		local type hazard ratios
	}
	else {
		local type regression parameters
	}
	local linesize: set linesize
	local parg4 = min(`linesize', 78)
	di 
	if "`e(texp)'" != "" {
		local t "tvc"
		if (_caller()<11) local t "t"
		di "{p 0 6 0 `parg4'}"
		di as txt "Note: Variables in " as res "`t'" as txt /*
		*/ " equation interacted with `e(texp)'.{p_end}"
	}
	di as txt "Note: Standard errors of `type' are " _c
	di as txt "conditional on theta."
	if "`e(sh_warn)'"=="sh_warn" {
		di as txt "Warning: observations within subject "_c
		di as txt "belong to different frailty groups."
	}
end

