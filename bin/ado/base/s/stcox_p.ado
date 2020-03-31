*! version 7.3.0  24apr2017
program stcox_p, sort
	version 11

	if `"`e(cmd2)'"' != "stcox" {
		error 301
	}

	local scopt = cond(_caller() < 11, "SCores", "SCOres")

	syntax [anything] [if] [in] [, XB		///
				       Index		///
				       STDP		///
				       HR		///
				       CSNell		///
				       DEViance		///
				       CCSNell		/// (deprecated)
				       CMGale		/// (deprecated)
				       MGale		///
				       BASEChazard	///
				       basehc		///
				       BASESurv		///
				       EFFects		///
				       ESR		/// (undocumented)
				       `scopt' 		///
				       SCHoenfeld 	///
				       SCAledsch	///
				       DFBeta		///
				       LDisplace	///
				       LMax		///
				       PARTial		///
				       noOFFset 	]

	local type "`xb' `index' `stdp' `hr' `csnell' `deviance' `ccsnell'"
	local type "`type' `cmgale' `mgale' `basechazard' `basehc' `basesurv'"
	local type "`type' `effects' `scores' `esr' `schoenfeld' `dfbeta'"
	local type "`type' `ldisplace' `scaledsch' `lmax'"

	if `:word count `type'' > 1 {
		di as err "{p 0 4 2}only one of "
		di as err "`: list uniq type' "
		di as err "may be specified{p_end}"
		exit 198
	}
	local type : word 1 of `type'

	if "`type'" == "scores" {
		local type esr
	}

	if "`e(prefix)'" == "svy" {
		if inlist("`type'", "mgale", 		///
				    "csnell",		///
				    "deviance", 	///
				    "cmgale", 		///
				    "ccsnell") |	///
		   inlist("`type'", "schoenfeld",	///
				    "scaledsch", 	///
				    "dfbeta",		///
				    "ldisplace",	///
				    "lmax") {
			di as err "{p 0 4 2}option `type' not allowed after "
			di as err "estimation with svy{p_end}"
			exit 322
		}
	}

	if _caller() < 11 {			// version control
		if "`type'" == "esr" | "`type'" == "csnell" {
			local partial partial
		}
	}

	if inlist("`type'", "esr", 		///
			    "dfbeta", 		///
			    "ldisplace",	///
			    "lmax",		///
			    "mgale",		///
			    "deviance",		///
			    "csnell") {
		if "`partial'" == "" {		// default is "cumulative"
			local type c`type'
		}
	}
	else if "`partial'" != "" {
		di as err "{p 0 4 2}option {bf:partial} not allowed{p_end}"
		exit 198
	}

	if inlist("`type'", "dfbeta", "cdfbeta") {
		if "`e(vce)'" != "oim" & "`e(V_modelbased)'" == "" {
			di as err "{p 0 4 2} prediction not allowed "
			di as err "with this nonstandard vce{p_end}"
			exit 459
		}
	}

	if inlist("`type'", "ldisplace", "cldisplace", "lmax", "clmax") {
		if "`e(vce)'" != "oim" {
			di as err "{p 0 4 2} prediction not allowed "
			di as err "with nonstandard vce{p_end}"
			exit 459
		}
	}

	if inlist("`type'", "esr", 		///
			    "cesr", 		///
			    "dfbeta", 		///
			    "cdfbeta",		///
			    "schoenfeld", 	///
			    "scaledsch") {
		GenScoreLike `anything' `if' `in', type(`type') `offset'
		exit
	}

	if inlist("`type'", "mgale", 		///
			    "basechazard",   	///
			    "basehc", 		///
	                    "basesurv", 	///
			    "effects") {
		GenSinglePred `anything' `if' `in', type(`type') `offset'
		exit
	}

// Otherwise, leave it old school

	local myopts "XB Index STDP HR CSNell DEViance CCSnell CMGale"
	local myopts "`myopts' LDisplace MGale PARTial LMax"

	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

	syntax [if] [in] [, `myopts' noOFFset]

	marksample touse

	if inlist("`type'", "xb", "index", "stdp") {
		_predict `vtyp' `varn' if `touse', `type' `offset'
		exit
	}

	st_is 2 full

	if "`type'"=="" | "`type'"=="hr" {
		if "`type'"=="" {
			di in gr ///
			"(option {bf:hr} assumed; predicted hazard ratio)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = exp(`xb')
		label var `varn' "Predicted hazard ratio"
		exit
	}

	if "`offset'"!="" {
		di as err "option {bf:nooffset} not allowed"
		exit 198
	}

        if "`type'"=="csnell" {
		tempvar mgale
		qui predict double `mgale' if e(sample), mgale partial
		gen `vtyp' `varn' = (_d!=0) - `mgale' if `touse'
		if "`_dta[st_id]'" != "" { 
			local part "Partial " 
		}
		label var `varn' "`part'Cox-Snell residual"
		exit
	}

	if "`type'"=="deviance" | "`type'" == "cdeviance" { 
		if "`type'" == "deviance" & "`_dta[st_id]'" != "" {
			local pp "partial "
		}
		tempvar cmg
		qui predict double `cmg' if e(sample), mgale `pp'
		gen `vtyp' `varn' = sign(`cmg')*sqrt( /* 
		*/ -2*(`cmg' + (_d!=0)*(ln((_d!=0)-`cmg')))) if `touse'
		if "`pp'" != "" {
			label var `varn' "Partial deviance residual"
		}
		else {
			label var `varn' "Deviance residual"
		}
		exit
	}

	if "`type'"=="ccsnell" {
		if "`_dta[st_id]'" == "" {
			predict `vtyp' `varn' if `touse', csnell partial
			exit
		}
		tempvar cs esamp
		qui gen byte `esamp' = e(sample)
		qui predict double `cs' if e(sample), csnell partial
		sort `esamp' `_dta[st_id]' _t
		qui by `esamp' `_dta[st_id]': /*
			*/ replace `cs'=cond(_n==_N,sum(`cs'),.) if `esamp'
		gen `vtyp' `varn' = `cs' if `touse'
		label var `varn' "Cox-Snell residual"
		exit
	}

	if "`type'"=="cmgale" {
		tempvar mgale
		qui predict double `mgale' if e(sample), mgale partial
		if "`_dta[st_id]'" == "" {
			gen `vtyp' `varn' = `mgale' if `touse'
			label var `varn' "Martingale residual"
			exit
		}
		tempvar mg esamp
		qui gen byte `esamp' = e(sample)
		sort `esamp' `_dta[st_id]' _t
		qui by `esamp' `_dta[st_id]': /*
		*/ gen double `mg'=cond(_n==_N, sum(`mgale'), .) if `esamp'
		gen `vtyp' `varn' = `mg' if `touse'
		label var `varn' "Martingale residual"
		exit
	}

	if "`type'"=="ldisplace" | "`type'" == "cldisplace" {
		if "`type'" == "ldisplace" & "`_dta[st_id]'" != "" {
			local pp "partial "
		}
		tempvar tvar useme
		qui gen byte `useme' = `touse' & e(sample)
		tempname b
		mat `b' = e(b) 
		forval i = 1/`=colsof(`b')' {
			tempvar v`i'
			local scvars `scvars' `v`i''
		}
		qui predict double `scvars' if `useme', scores `pp'
		qui gen double `tvar' = . 
		qui replace `useme' = `useme' & !missing(`v1')
		GetLLDisplacements `scvars', touse(`useme') ldvar(`tvar')
		gen `vtyp' `varn' = `tvar' if `touse'
		if "`pp'" != "" {
			label var `varn' "Partial log-likelihood displacement"
		}
		else {
			label var `varn' "Log-likelihood displacement"
		}
		exit
	}

	if "`type'"=="lmax" | "`type'" == "clmax" {
		if "`type'" == "lmax" & "`_dta[st_id]'" != "" {
			local pp "partial "
		}
		tempvar tvar useme
		qui gen byte `useme' = e(sample)
		tempname b
		mat `b' = e(b) 
		local colnames : colfullnames `b'
		local i 1
		foreach var of local colnames {
			tempvar v`i'
			local scvars `scvars' `v`i''
			_ms_parse_parts `var' 
			if !`r(omit)' {
				local scvars_noomit `scvars_noomit' `v`i''
			}
			local ++i
		}
		qui predict double `scvars' if `useme', scores `pp'
		qui gen double `tvar' = . 
		qui replace `useme' = `useme' & !missing(`v1')
		GetLmax `scvars_noomit', touse(`useme') lmvar(`tvar')
		gen `vtyp' `varn' = `tvar' if `touse'
		if "`pp'" != "" {
			label var `varn' "Partial Lmax statistic"
		}
		else {
			label var `varn' "Lmax statistic"
		}
		exit
	}

	error 198
end

program GenSinglePred
	syntax [newvarname] [if] [in], type(string)

	marksample touse, novarlist 

	tempname b jj
	tempvar esamp shareid tvar svywtvar

	qui gen byte `esamp' = e(sample)
	local topt `type'(`tvar')

	if "`type'" == "effects" {
		if `"`e(cmd)'"' != "stcox_fr" {
			di as err "{p 0 4 2}effects only available with "
			di as err "shared frailty models{p_end}"
			exit 322
		}
		if `e(theta)' < 1e-12 {
			gen `typlist' `varlist' = . if `touse'	
			label var `varlist' "Shared log-frailty"
			exit
		}
		local topt
	}

	mat `b' = e(b)
	GetCoxCommand, b(`b') touse(`esamp') stat(`type') /// 
			share(`shareid') svywt(`svywtvar')
	local coxcomm `s(coxcommand)'


	if "`e(datasignature)'" != "" & "`e(prefix)'" != "svy" {
		checkestimationsample
	}

	_est hold `jj', restore nullok
	
	qui `coxcomm' `topt'

	if "`type'" == "effects" {
		GetRandomEffects `tvar' `esamp' `shareid' 
	}

	gen `typlist' `varlist' = `tvar' if `touse'

	if "`type'"=="mgale" {
		if "`_dta[st_id]'" != "" { 
			local part "partial "
		}
		if "`part'" != "" {
			label var `varlist' "Partial martingale residual"
		}
		else {
			label var `varlist' "Martingale residual"
		}
		exit
	}
	else if "`type'"=="basechazard" {
		label var `varlist' "Cumulative baseline hazard"
		exit
	}
	else if "`type'"=="basehc" {
		label var `varlist' "Baseline hazard contribution"
		exit
	}
	else if "`type'"=="basesurv" {
		label var `varlist' "Baseline survivor"
		exit
	}
	else if "`type'"=="effects" {
		label var `varlist' "Shared log-frailty"
		exit
	}
end

program GenScoreLike
	syntax [anything] [if] [in], type(string) 

	tempname b jj V
	tempvar esamp shareid svywtvar

	if ("`e(ties)'" == "partial" | "`e(ties)'" == "marginal") & 	///
	   ("`type'" == "schoenfeld" | "`type'" == "scaledsch") {
		di as err "{p 0 4 2}Schoenfeld residuals not available after "
		di as err "estimation with exactm or exactp{p_end}"
		exit 322
	}

	if "`type'" == "dfbeta" {
		local type esr
		local scaled scaled
	}

	if "`type'" == "cdfbeta" {
		local type esr
		local scaled scaled
		local cumulative cumulative
	}

	if "`type'" == "cesr" {
		local type esr
		local cumulative cumulative
	}

	marksample touse

	qui gen byte `esamp' = e(sample) 
	matrix `b' = e(b)
	if "`e(vce)'" == "oim" {
		matrix `V' = e(V)
	}
	else {
		matrix `V' = e(V_modelbased)
	}
	local xvars : coln `b'
	local dim = colsof(`b')

	GetCoxCommand, touse(`esamp') b(`b') stat(`type') /// 
		       share(`shareid') svywt(`svywtvar')
	local coxcomm `"`s(coxcommand)'"'

	GetVarNames `anything', dim(`dim')
	local svars `s(varlist)'
	local styps `s(typlist)'

	if "`e(datasignature)'" != "" & "`e(prefix)'" != "svy" {
		checkestimationsample
	}

	forval i = 1/`dim' {
		tempvar v`i'
		local tvars `tvars' `v`i''
	}

	_est hold `jj', restore nullok

	qui `coxcomm' `type'(`tvars')

	if "`type'" == "esr" & "`cumulative'" != "" {
		if "`_dta[st_id]'" != "" {
			sort `esamp' `_dta[st_id]' _t
			foreach vv of local tvars {
				qui by `esamp' `_dta[st_id]': replace /// 
				    `vv' = cond(_n==_N,sum(`vv'),.) if `esamp'
			}
		}
	}

	if "`type'" == "esr" & "`scaled'" != "" {
		tempvar useme
		qui gen byte `useme' = `touse' & `esamp' 
		if "`cumulative'" != "" & "`_dta[st_id]'" != "" {
			sort `esamp' `_dta[st_id]' _t
			qui by `esamp' `_dta[st_id]': replace /// 
				 `useme' = `useme' & (_n==_N)
		}
		ScaleScores `tvars', touse(`useme') var(`V')
	}

	if "`type'" == "esr" {
		if "`cumulative'" == "" & "`_dta[st_id]'" != "" { 
			local part "Partial "
		}
		if "`scaled'" != "" {
			local lab `part'DFBETA
		}
		else {
			if "`part'" != "" {	
				local lab `part'efficient score
			}
			else {
				local lab Efficient score
			}
		}
	}
	else if "`type'" == "schoenfeld" {
		local lab Schoenfeld
	}
	else if "`type'" == "scaledsch" {
		local lab Scaled Schoenfeld 
	}
	forval i = 1/`dim' {
		gettoken xvar xvars : xvars
		gettoken svar svars : svars
		gettoken tvar tvars : tvars
		gettoken type styps : styps
		qui gen `type' `svar' = `tvar' if `touse'
		label var `svar' "`lab' - `xvar'"
	}
end

program GetCoxCommand, sclass sort
	syntax [, touse(varname) b(name) stat(string) share(string) /// 
		  svywt(name) ]

	if "`touse'" == "" {
		local touse e(sample)
	}
	local xvars : coln `b'
	local t `e(depvar)'
	if `"`e(t0)'"' != "" {
		local t0 t0(`e(t0)')
	}
	local d dead(_d)

	if "`e(prefix)'" == "svy" & "`e(poststrata)'" != "" {
		svygen post `svywt' if `touse' [`e(wtype)'`e(wexp)'] , ///
				poststrata(`e(poststrata)') ///
				postweight(`e(postweight)')
		local wt [pw = `svywt']
	}
	else if "`e(prefix)'" == "svy" & "`e(calmethod)'" != "" {
		quietly ///
		svycal `e(calmethod)' `e(calmodel)' if `touse' ///
				[`e(wtype)'`e(wexp)'] , ///
				`e(calopts)' generate(`svywt')
		local wt [pw = `svywt']
	}
	else if `"`e(wtype)'"' != "" {
		local wt [`e(wtype)'`e(wexp)']
	}
			
	if `"`e(subpop)'"' != "" {
		tempvar subuse
		_svy_subpop `touse' `subuse', subpop(`e(subpop)')
		qui replace `touse' = `subuse' & _st
	}
	else {
		qui replace `touse' = 0 if !_st 
	}

	if `"`e(texp)'"' != "" {
		_tvc_notallowed predict 1
	}
	if `"`e(strata)'"' != "" {
		local strata strata(`e(strata)')
	}
	if `"`e(offset)'"' != "" {
		local offset offset(`e(offset)')
	}
	if `"`e(ties)'"' == "partial" {
		local ties exactp
	}
	else if `"`e(ties)'"' == "marginal" {
		local ties exactm
	}
	else if `"`e(ties)'"' != "none" {
		local ties `e(ties)'
	}
	if `"`e(shared)'"' != "" {
		local theta theta(`e(theta)')
		qui sort `touse' `e(shared)'
		qui egen long `share' = group(`e(shared)') if `touse'
		local gampen gampen(`share')
	}
	if `"`e(vce)'"' == "robust" {
		local robust robust
		if `"`e(clustvar)'"'!= "" {
			local robust `"robust cluster(`e(clustvar)')"'
		}
	}
	else if `"`e(vce)'"' == "cluster" {
		local robust `"cluster(`e(clustvar)')"'
	}

	local coxcommand `"cox `t' `xvars' `wt' if `touse', matfrom(`b')"'
	if `"`e(shared)'"' == "" {
		local coxcommand `"`coxcommand' iter(0)"'
	}
	local coxcommand `"`coxcommand' norefine `t0' `d'"'
	local coxcommand `"`coxcommand' `strata' `offset' `ties'"'
	local coxcommand `"`coxcommand' `theta' `gampen' `robust'"'

	sreturn local coxcommand `"`coxcommand'"'
end

program GetRandomEffects
	args tvar esamp share

	tempname b 
	mat `b' = e(b)
	qui summ `share', meanonly
	local ng = r(max)
	local dim = colsof(`b') - `ng'
	qui gen double `tvar' = `b'[1,`dim'+`share'[_n]] if `esamp'
end

program GetVarNames, sclass
	syntax [anything], dim(integer)

	cap _score_spec `anything', ignoreeq 
	local rc = _rc
	if `rc' & `rc' != 103 { 
		_score_spec `anything', ignoreeq
	}
	if (`:word count `s(varlist)'' < `dim') & (`rc' != 103) {
		local rc 102
	}
	if `rc' == 102 | `rc' == 103 {
		di as err "{p 0 4 2}you must specify `dim' new "
		di as err "variables {p_end}"
		exit `rc'
	}
	sreturn local varlist `s(varlist)'
	sreturn local typlist `s(typlist)'
end

program ScaleScores
	syntax varlist, touse(varname) var(name)

	capture noi mata: _stcrr_scale_the_scores()
	if _rc {
		di as err "{p 0 4 2}error scaling efficient score residuals"
		di as err "{p_end}"
		exit 459
	}
end

program GetLLDisplacements
	syntax varlist, touse(varname) ldvar(varname)

	capture noi mata: _stcrr_get_displacements() 
	if _rc {
		di as err "{p 0 4 2}error converting scores into likelihood "
		di as err "displacement statistics{p_end}"
		exit 459
	}
end

program GetLmax
	syntax varlist, touse(varname) lmvar(varname)
	tempname err

	capture noi mata: _stcrr_get_lmax() 
	if _rc | `err' {
		di as err "{p 0 4 2}error converting scores into Lmax "
		di as err "statistics{p_end}"
		exit 459
	}
end

exit
