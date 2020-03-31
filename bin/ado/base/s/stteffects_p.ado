*! version 1.0.1  97dec2018

program define stteffects_p
	version 14.0

	if "`e(cmd)'" != "stteffects" {
		di as err "{help stteffects##|_new:stteffects} estimation " ///
		 "results not found"
		exit 301
	}

	local subcmd `e(subcmd)'

	if "`subcmd'" == "ra" {
		local allowed te CMean xb SCores
	}
	else if "`subcmd'" == "wra" {
		local allowed te CMean xb cxb SCores
	}
	else if "`subcmd'" == "ipw" {
		/* not documented: psxb is a synonym for xb		*/
		local allowed ps xb psxb SCores
		if "`e(cmodel)'" != "" {
			local allowed `allowed' cxb
		}
	}
	else if "`subcmd'" == "ipwra" {
		local allowed te ps CMean xb psxb SCores
		if "`e(cmodel)'" != "" {
			local allowed `allowed' cxb
		}
	}
	else {
		di as err "{help stteffects##|_new:stteffects} estimation " ///
		 "results not found"
		exit 301
	}
	if "`e(tmodel)'" == "hetprobit" {
		local allowed `allowed' PSLNSigma
		if "`subcmd'" == "ipw" {
			/* not documented: pslnsigma synonym for 	*/
			/* 		lnsigma				*/
			local allowed `allowed' LNSigma
		}
	}
	if "`e(omodel)'"!="" & "`c(omodel)'"!="exponential" {
		/* IPW or IPWRA						*/
		local allowed `allowed' LNSHape
	}
	if "`e(cmodel)'" != "" {
		/* WRA or IPWRA						*/
		local allowed `allowed' CENSurv
		if "`e(cmodel)'" != "exponential" {
			local allowed `allowed' CLNSHape
		}
	}
	PredictStat "`allowed'" : `0'
end

program define PredictStat
	_on_colon_parse `0'
	local allowed `s(before)'
	local 0 `"`s(after)'"'

	if e(k_levels) > 2 {
		local id newvarlist
	}
	else {
		local id newvarname
	}
	syntax anything(name=vlist id="`id'") [if] [in], [ `allowed' ///
		TLevel(passthru) Weights(passthru) VERBose ]

	/* undocumented wts	- return ipw or wra			*/
	/* 		verbose	- spew output				*/

	local k : word count `te' `cmean' `ps' `xb' `cxb' `psxb' `scores'
	local k1 : word count `lnshape' `clnshape' `pslnsigma' `lnsigma'
	local k2 : word count `censurv'
	local k = `k' + `k1' + `k2'

	local allowed = strlower("`allowed'")
	if `k' > 1 {
		while "`allowed'" != "" {
			gettoken op allowed : allowed
			if ("`c'"!="" & "`allowed'"=="") local c ", or"

			local opts `opts'`c' {bf:`op'}
			local c ,
		}
		di as err "{p}only one of `opts' can be specified{p_end}"
		exit 184
	}
	else if `k' == 0 {
		/* first in list is the default				*/
		local stat : word 1 of `allowed'
		if "`stat'" == "te" {
			di as txt "(option {bf:te} assumed; treatment effect)"
		}
		else if "`stat'" == "ps" {
			di as txt "(option {bf:ps} assumed; propensity score)"
		}
	}
	else {
		local stat `te'`ps'`cmean'`xb'`cxb'`psxb'
		local stat `stat'`lnshape'`clnshape'`pslnsigma'`scores'
		local stat `stat'`lnsigma'`censurv'
	}
	if "`e(subcmd)'"=="ipw" {
		if "`stat'"=="xb" {
			/* use synonym 					*/
			local stat psxb
		}
		else if "`stat'" == "lnsigma" {
			/* use synonym					*/
			local stat pslnsigma
		}
	}

	marksample touse, novarlist

	local lab : value label `e(tvar)'
	ParseTLevel `stat' `lab' : `tlevel'
	local tlevel "`s(tlevel)'"

	/* clear return code						*/
	capture
	if "`stat'" == "scores" {
		CountScores
		local kvar = `r(kvar)'
		_stubstar2names `vlist', nvars(`kvar') nosubc
		local typlist `s(typlist)'
		local vlist `s(varlist)'
	}
	else if "`tlevel'"!="" | "`stat'"=="cxb" | "`stat'"=="censurv" {
		local 0 `vlist'
		syntax newvarlist(min=1 max=1)
		local vlist `varlist'
	}
	else {
		local levels `e(tlevels)'
		local klev : list sizeof levels
		local kvar = `klev'
		if "`stat'"=="te" | "`stat'"=="psxb" | "`stat'"=="pslnsigma" {
			local `--kvar'
		}
		cap _stubstar2names `vlist', nvars(`kvar')
		local rc = c(rc)
		if !`rc' {
			local typlist `s(typlist)'
			local vlist `s(varlist)'
		}
		else if `rc' == 102 {
			/* too few variables; try single variable	*/
			local 0 `vlist'
			cap syntax newvarlist(min=1 max=1)
			local rc = c(rc)
			if `rc' == 103 {
				di as err "too few or too many variables " ///
				 "specified"
				di as txt "{phang}The current estimation "   ///
				 "results for {bf:stteffects} has `klev' "   ///
				 "levels so you must specify one, or "       ///
				 "`kvar' new variables, or you can use the " ///
				 "stub* notation.{p_end}"
				exit `rc'
			}
			else if `rc' {
				/* other error				*/
				syntax newvarlist(min=1 max=1)
			}
			local vlist `varlist'
			local k = 1
			if "`stat'"=="te" | "`stat'"=="psxb" {
				/* first level not the control		*/
				local control = e(control)
				local k = 1
				local kc : list posof "`control'" in levels
				if `kc' == 1 {
					local `++k'
				}
			
			}
			local tlevel : word `k' of `levels'
		}
		else {
			/* other error					*/
			_stubstar2names `vlist', nvars(`kvar')
		}
	}
	/* just one type, please					*/
	local type : word 1 of `typlist'

	local stat = strupper("`stat'")
	Predict`stat' `vlist', type(`type') touse(`touse') tlevel(`tlevel') ///
		`weights'
end

program define ParseTLevel, sclass
	_on_colon_parse `0'
	local before `s(before)'
	local 0, `s(after)'

	gettoken stat lab : before

	syntax, [ tlevel(passthru) ]

	if "`tlevel'" == "" {
		sreturn local tlevel
		exit
	}
	if "`stat'"=="cxb" | "`stat'"=="clnshape" | "`stat'"=="scores" {
		di as err "option {bf:tlevel()} not allowed"
		exit 198
	}
	local 0, `tlevel'
	if "`lab'" != "" {
		local cap cap
	}
	/* clear return code						*/	
	capture
	`cap' syntax, tlevel(integer)
	local rc = c(rc)
	if `rc' {
		syntax, tlevel(string)
		qui label list `lab'
		local k0 = r(min)
		local k1 = r(max)
		local found = 0
		forvalues k=`k0'/`k1' {
			cap local lev : label `lab' `k'
			if "`lev'" == "`tlevel'" {
				local tlevel = `k'
				local found = 1
				continue, break
			}
		}
		if !`found' {
			di as err "{p}{bf:`tlevel'} is not one of the " ///
			 "treatment levels{p_end}"
			exit 198
		}
	}
	else {
		local clev `control'
	}
	
	local levels `e(tlevels)'
	local levels : subinstr local levels " " ",", all
	local nocontrol = ("`stat'"=="te"|"`stat'"=="psxb"| ///
			"`stat'"=="pslnsigma")
	if `nocontrol' & `tlevel'==e(control) {
		di as err "{p}invalid {bf:tlevel(#)} specification, "
		di as err "`tlevel' is the control level and may not "
		di as err "be specified with {bf:`stat'}{p_end}"
		exit 198
	}
	if !inlist(`tlevel',`levels') {
		di as err "{p}invalid {bf:tlevel(#)} specification; {it:#} " ///
		 "must be one of `levels'{p_end}"
		exit 198
	}	

	sreturn local tlevel `tlevel'
end

program define PredictCENSURV
	syntax newvarlist, touse(varname) [ * ]

	local vlab "censoring survival probabilities"

	local dist `e(cmodel)'
	markout `touse' `e(cvarlist)'
	if "`dist'" != "exponential" {
		local shopt aeq(CME_lnshape)
		markout `touse' `e(cshapevlist)'
	}
	tempvar d

	qui gen byte `d' = 1-_d if `touse'

	PredictSurvival `varlist', touse(`touse') `options' dist(`dist') ///
		vlab(`vlab') eq(CME) d(`d') `shopt' 
end

program define PredictCXB

	local vlab "censoring model, linear prediction"

	PredictXB `0' eq(CME) vlab(`vlab') markout(fvcvarlist)
end

program define PredictCLNSHAPE

	local vlab "censoring model, log latent shape"

	PredictXB `0' eq(CME) aeq(_lnshape) vlab(`vlab') markout(fvcshapevlist)
end

program define PredictLNSHAPE

	local vlab "outcome model, log latent shape"

	PredictXB `0' eq(OME) aeq(_lnshape) vlab(`vlab') markout(fvoshapevlist)
end

program define PredictPSXB

	local vlab "propensity score, linear prediction"

	PredictXB `0' eq(TME) vlab(`vlab') markout(fvtvarlist)
end

program define PredictPSLNSIGMA

	local vlab "propensity score, log latent standard deviation"

	PredictXB `0' eq(TME) aeq(_lnsigma) vlab(`vlab') markout(fvhtvarlist)
end

program define PredictCMEAN
	PredictTE `0' cmean
end

program define PredictXB
	syntax newvarlist, type(string) touse(varname) [ tlevel(string) ///
		eq(string) aeq(string) vlab(string) markout(string) * ]

	local levels `e(tlevels)'
	local treated = e(treated)
	local control = e(control)
	local klev : list sizeof levels
	local tvar `e(tvar)'
	tempname b
	GetCoefficients, b(`b')

	if "`eq'" == "" {
		local eq OME
		local vlab "outcome model, linear prediction"
		local markout fvovarlist
	}
	if "`markout'" != "" {
		markout `touse' `e(`markout')'
	}
	local lab : value label `tvar'
	if "`eq'" == "CME" {
		mat score `type' `varlist' = `b' if `touse', eq(CME`aeq')
		label variable `varlist' `"`vlab'"'
		qui count if missing(`varlist')
		local N = r(N)
		if `N' {
			di as txt "(`N' missing values generated)"
		}
		exit
	}
	if "`tlevel'" != "" {
		mat score `type' `varlist' = `b' if `touse', ///
			eq(`eq'`tlevel'`aeq')
		local lev = `tlevel'
		if "`lab'" != "" {
			local lev : label `lab' `tlevel'
		}
		local vlab `"`vlab', `tvar'=`lev'"'
		label variable `varlist' `"`vlab'"'
		qui count if missing(`varlist')
		local N = r(N)
		if `N' {
			di as txt "(`N' missing values generated)"
		}
		exit
	}
	local i = 0
	forvalues k=1/`klev' {
		local lev : word `k' of `levels'
		if "`eq'"=="TME" & `lev'==`control' {
			continue
		}
		local v : word `++i' of `varlist'
		mat score `type' `v' = `b' if `touse', eq(`eq'`lev'`aeq')
		if "`lab'" != "" {
			local lev : label `lab' `lev'
		}
		local vlab0 `"`vlab', `tvar'=`lev'"'
		label variable `v' `"`vlab0'"'
		qui count if missing(`v')
		local N = r(N)
		if `N' {
			di as txt "(`N' missing values generated)"
		}
	}
end

program define Markout
	syntax, touse(varname) which(string)

	if "`which'" == "cmean" {
		markout `touse' `ovarlist' `oshapevlist'
	}
	if "`which'"=="cmean" | "`which'"=="scores" | "`which'"=="surv" {
		/* survival time variable				*/
		local to : char _dta[st_bt]
		if "`to'" != "`e(_depvar)'" {
			if "`to'" == "" {
				local rest "could not be found"
			}
			else {
				local rest "`to' is not the same variable"
				local rest "`rest' used at estimation time,"
				local rest "`rest' `e(survar)'"
			}
			di as err "{p}survival-time variable `rest'{p_end}"
			exit 119
		}
		/* markout using stset variable				*/
		local tt : char _dta[st_t]
		markout `touse' `tt'
		/* failure event variable				*/
		local fo : char _dta[st_bd]
		if "`e(_dead)'" != "" {
			if "`fo'" != "`e(_dead)'" {
				if "`fo'" == "" {
					local rest "could not be found"
				}
				else {
					local rest "`to' is not the same"
					local rest "`rest' variable used at"
					local rest "`rest' estimation time," 
					local rest "`rest' `e(survar)'"
				}
				di as err "{p}failure-event variable " ///
				 "`rest'{p_end}"
				exit 119
			}
			/* markout using stset variable			*/
			local ff : char _dta[st_d]
			markout `touse' `ff'
		}
	}
	if "`which'"=="scores" {
		local mlist "ovarlist oshapevlist cvarlist cshapevlist"
		local mlist "`mlist' tvarlist htvarlist tvar"
		while "`mlist'" != "" {
			gettoken markout mlist : mlist 
			if `"`e(`markout')'"' != "" {
				markout `touse' `e(`markout')'
			}
		}
		local levels "`e(tlevels)'"
		local levels = ltrim(rtrim("`levels'"))
		local s: subinstr local	levels " " ",", all
		qui replace `touse' = 0 if !inlist(`e(tvar)',`s')
	}
end

program define PredictTE
	syntax newvarlist, type(string) touse(varname) [ tlevel(string) ///
		cmean verbose * ]

	local subcmd `e(subcmd)'

	if "`subcmd'"=="ipw" | "`subcmd'"=="ipwra" {
		local ip ip
		local tmodel `e(tmodel)'
		local tmopt tmodel(`tmodel')
	}
	local levels `e(tlevels)'
	local klev : list sizeof levels
	local tvar `e(tvar)'
	local control = `e(control)'
	local treated = `e(treated)'
	local stat `e(stat)'
	local sdist `e(omodel)'
	local cdist `e(cmodel)'

	Markout, touse(`touse') which(pomean)

	/* survival time variable					*/
	local to : char _dta[st_t]
	/* failure event variable					*/
	local do : char _dta[st_d]

	tempname b
	GetCoefficients, b(`b') pomeans

	forvalues k=1/`klev' {
		tempvar te`k'
		qui gen double `te`k'' = .

		/* do not want the residuals; set estimates to zero	*/
		mat `b'[1,`k'] = 0
		local telist `telist' `te`k''
	}
	forvalues k=1/`klev' {
		tempvar s`k'
		qui gen double `s`k'' = .
		if "`sdist'" != "exponential" {
			tempvar ss`k'
			qui gen double `ss`k'' = .
		}
		local telist `telist' `s`k'' `ss`k''
	}
	/* compute the PO means					*/
	_stteffects_gmm_surv `telist' if `touse', b(`b') dist(`sdist') ///
		stat(pomeans) tvar(`tvar') levels(`levels')            ///
		control(`control') tlevel(`treated') to(`to') do(`do') 

	local lab : value label `tvar'
	if "`lab'" != "" {
		local clev : label `lab' `control'
	}
	else {
		local clev `control'
	}
	local kc : list posof "`control'" in levels
	if "`tlevel'" != "" {
		local lev = `tlevel'
		local k : list posof "`lev'" in levels
		if "`lab'" != "" {
			local lev : label `lab' `lev'
		}
		if "`cmean'" != "" {
			gen `type' `varlist' = `te`k'' if `touse'
			local vlab `"conditional mean, `tvar'=`lev'"'
			label variable `varlist' `"`vlab'"'
		}
		else {
			gen `type' `varlist' = `te`k''-`te`kc'' if `touse'
			local vlab `"treatment effect, `tvar': `lev' vs `clev'"'
			label variable `varlist' `"`vlab'"'
		}
	}
	else if "`cmean'" != "" {
		forvalues k=1/`klev' {
			local v : word `k' of `varlist'
			local lev : word `k' of `levels'
			if "`lab'" != "" {
				local lev : label `lab' `lev'
			}
			gen `type' `v' = `te`k'' if `touse'
			label variable `v' `"conditional mean, `tvar'=`lev'"'
		}
	}
	else if `klev' == 2 {
		local k : list posof "`treated'" in levels
		local lev `treated'
		if "`lab'" != "" {
			local lev : label `lab' `treated'
		}
		gen `type' `varlist' = `te`k''-`te`kc'' if `touse'
		local vlab `"treatment effect, `tvar': `lev' vs `clev'"'
		label variable `varlist' `"`vlab'"'
	}
	else {
		local i = 0
		forvalues k=1/`klev' {
			if `k' == `kc' {
				continue
			}
			local v : word `++i' of `varlist'
			local lev : word `k' of `levels'
			if "`lab'" != "" {
				local lev : label `lab' `lev'
			}
			gen `type' `v' = `te`k''-`te`kc'' if `touse'
			local vlab `"treatment effect, `tvar': `lev' vs `clev'"'
			label variable `v' `"`vlab'"'
		}
	}
end

program define PredictPS
	syntax newvarlist, type(string) touse(varname) [ tlevel(string) ///
		verbose * ]

	local model `e(tmodel)'
	local klev = e(k_levels)
	local levels `e(tlevels)'
	local treated `e(treated)'
	local control `e(control)'
	local tvar `e(tvar)'
	tempname b

	markout `touse' `e(fvtvarlist)' `e(fvhtvarlist)'

	GetCoefficients, b(`b')

	local eqs : coleq `b'
	local eqs : list uniq eqs
	local kr : list sizeof eqs
	forvalues i=1/`kr' {
		tempvar r`i'
		/* precision not needed					*/
		qui gen double `r`i'' = .
		local rlist `rlist' `r`i''
	}
	local kvar : list sizeof varlist
	forvalues i=1/`kvar' {
		tempvar ps`i'
		local pslist `pslist' `ps`i''
	}
	tempvar pr
	_stteffects_gmm_ps `rlist' if `touse', model(`model') ft(`pslist') ///
		tvar(`tvar') levels(`levels') prlev(`tlevel') prob(`pr')   ///
		tlevel(`treated') control(`control') b(`b') `verbose'

	local lab : value label `tvar'
	forvalues k = 1/`kvar' {
		local v : word `k' of `varlist'
		gen `type' `v' = `ps`k'' if `touse'
		if "`lab'" != "" {
			if "`tlevel'" != "" {
				local lev : label `lab' `tlevel'
			}
			else {
				local lev : word `k' of `levels'
				local lev : label `lab' `lev'
			}
		}
		else if "`tlevel'" != "" {
			local lev `tlevel'
		}
		else {
			local lev : word `k' of `levels'
		}
		label variable `v' `"propensity score, `tvar'=`lev'"'
	}
end

program define CountScores, rclass

	local sdist `e(omodel)'
	local cdist `e(cmodel)'
	local tmodel `e(tmodel)'
	local sexpo = ("`sdist'"=="exponential")
	local cexpo = ("`cdist'"=="exponential")
	local hetp = ("`tmodel'"=="hetprobit")
	local levels `e(tlevels)'
	local klev : list sizeof levels

	/* cmeans/ate/atet						*/
	local kvar = `klev'
	if "`sdist'" != "" {
		/* survival, outcome model				*/
		local kvar = `kvar' + (1+!`sexpo')*`klev'
	}
	if "`cdist'" != "" {
		/* censoring 						*/
		local kvar = `kvar' + 1 + !`cexpo'
	}
	if "`tmodel'" != "" {
		/* treatment model					*/
		local kvar = `kvar' + (`hetp'+1)*(`klev'-1)
	}
	return local kvar = `kvar'
end

program define PredictSCORES
	syntax newvarlist, type(string) touse(varname) [ weights(name) ///
		verbose * ]

	local subcmd `e(subcmd)'

	if "`subcmd'"=="ipw" | "`subcmd'"=="ipwra" {
		local ip ip
		local tmodel `e(tmodel)'
		local tmopt tmodel(`tmodel')
		if "`weights'" != "" {
			local wopt ipwra(`weights')
		}
	}
	else if "`weights'" != "" {
		if "`subcmd'" == "ra" {
			di as err "option {bf:weights()} not allowed"
			exit 198
		}
		local wopt wra(`weights')
	}
	local levels `e(tlevels)'
	local klev : list sizeof levels
	local tvar `e(tvar)'
	local control = `e(control)'
	local treated = `e(treated)'
	local stat `e(stat)'
	local sdist `e(omodel)'
	local cdist `e(cmodel)'
	local tmodel `e(tmodel)'
	local pomean = ("`stat'"=="pomeans")
	local sexpo = ("`sdist'"=="exponential")
	local cexpo = ("`cdist'"=="exponential")
	local hetp = ("`tmodel'"=="hetprobit")

	Markout, touse(`touse') which(scores)

	tempname b
	GetCoefficients, b(`b')

	forvalues k=1/`klev' {
		tempvar te`k'
		qui gen double `te`k'' = .

		local telist `telist' `te`k''
	}
	if "`sdist'" != "" {
		/* survival, outcome model				*/
		local ksc = (1+!`sexpo')*`klev'
		forvalues k=1/`ksc' {
			tempvar sc`k'
			qui gen double `sc`k'' = .

			local telist `telist' `sc`k''
		}
	}
	if "`cdist'" != "" {
		/* censoring 						*/
		tempvar cs1
		qui gen double `cs1' = .
		local telist `telist' `cs1'
		if !`cexpo' {
			tempvar cs2
			qui gen `cs2' = .
			local telist `telist' `cs2'
		}
	}
	if "`tmodel'" != "" {
		/* treatment model					*/
		local kst = (`hetp'+1)*(`klev'-1)
		forvalues i=1/`kst' {
			tempvar st`i'
			/* precision not needed				*/
			qui gen double `st`i'' = .

			local telist `telist' `st`i''
		}
	}
	_stteffects_gmm_`ip'wra `telist' if `touse', at(`b')          ///
		survdist(`sdist') tvar(`tvar') stat(`stat')           ///
		levels(`levels') control(`control') tlevel(`treated') ///
		censordist(`cdist') `tmopt' `wopt' `verbose'

	local lab : value label `tvar'
	if "`lab'" != "" {
		local clev : label `lab' `control'
	}
	else {
		local clev `control'
	}
	if `pomean' {
		local what mean
		local kl = `klev'
	}
	else {
		local STAT = upper("`stat'")
		local what "`STAT' `tvar'"
		local kl = `klev' - 1
	}
	local slab "parameter-level score for"
	local vlab "`slab' `what'"
	local i = 0
	local kk = 0
	forvalues k=1/`kl' {
		local v : word `++i' of `varlist'
		gen `type' `v' = `te`k'' if `touse'

		local lev : word `++kk' of `levels'
		if !`pomean' & `lev'==`control' {
			local lev : word `++kk' of `levels'
		}
		if "`lab'" != "" {
			local lev : label `lab' `lev'
		}
		if `pomean' {
			local what "`tvar'=`lev'"
		}
		else {
			local what "`lev' vs `clev'"
		}
		label variable `v' `"`vlab', `what'"'
	}
	if !`pomean' {
		local v : word `++i' of `varlist'
		gen `type' `v' = `te`klev'' if `touse'
		local vlab "`slab' mean, `tvar'=`clev'"
		label variable `v' `"`vlab'"'
	}
	local slab "equation-level score for"
	if "`sdist'" != "" {
		local vlab "`slab' linear prediction,"
		local alab "`slab' log shape,"
		local km = 1 + !`sexpo'
		local kl = 0
		forvalues k=1/`ksc' {
			local v : word `++i' of `varlist'
			gen `type' `v' = `sc`k'' if `touse'

			local k0 = !mod(`=`k'-1',`km')
			local kl = `kl' + `k0'
			local lev : word `kl' of `levels'
			if "`lab'" != "" {
				local lev : label `lab' `lev'
			}
			if `k0' {
				label variable `v' `"`vlab' `tvar'=`lev'"'
			}
			else {
				label variable `v' `"`alab' `tvar'=`lev'"'
			}
		}
	}
	if "`cdist'" != "" {
		/* censoring 						*/
		local v : word `++i' of `varlist'
		gen `type' `v' = `cs1' if `touse'
		label variable `v' "`slab' censoring linear prediction"
		if !`cexpo' {
			local v : word `++i' of `varlist'
			gen `type' `v' = `cs2' if `touse'
			label variable `v' `"`slab' censoring log shape"'
		}
	}
	if "`tmodel'" != "" {
		local vlab "`slab' propensity score linear prediction,"
		local hlab "`slab' propensity score log standard deviation,"
		local km = 1 + `hetp'
		local kl = 0
		forvalues k=1/`kst' {
			local v : word `++i' of `varlist'
			gen `type' `v' = `st`k'' if `touse'
			local k0 = !mod(`=`k'-1',`km')
			local kl = `kl' + `k0'
			local lev : word `kl' of `levels'
			if !`pomean' & `lev'==`control' {
				local lev : word `++kl' of `levels'
			}
			if "`lab'" != "" {
				local lev : label `lab' `lev'
			}
			if `k0' {
				label variable `v' `"`vlab' `tvar'=`lev'"'
			}
			else {
				label variable `v' `"`hlab' `tvar'=`lev'"'
			}
		}
	}
end

program define PredictSurvival
	syntax newvarlist, type(string) touse(varname) dist(string) ///
		vlab(string) eq(string) d(varname) [ aeq(string) verbose * ]

	Markout, touse(`touse') which(surv)

	tempvar xb e s ti
	tempname b
	mat `b' = e(b)

	mat score double `xb' = `b' if `touse', eq(`eq')
	qui gen double `e' = .
	qui gen double `s' = .
	qui gen byte `ti' = 1 if `touse'
	local to  _t
	if "`dist'" == "exponential" {
		_stteffects_exponential_moments `e' `s' if `touse', ///
			xb(`xb') ti(`ti') to(`to') do(`d')
	}
	else {
		tempvar zg as

		mat score double `zg' = `b' if `touse', eq(`aeq')
		qui gen double `as' = .

		_stteffects_`dist'_moments `e' `s' `as' if `touse', ///
			xb(`xb') zg(`zg') ti(`ti') to(`to') do(`d')
	}
	gen `type' `varlist' = `e' if `touse'
	label variable `varlist' `"`vlab'"'
end

program define GetCoefficients
	syntax, b(name) [ pomeans ] 

	mat `b' = e(b)
	/* fix stripe names that use margins notation			*/
	/*  many _ms_xxxx routines will not accept them			*/
	local stripe0 : colfullnames `b'
	local levels `e(tlevels)'
	local klev : list sizeof levels
	local STAT = strupper("`e(stat)'")
	/* label PO coefficients as POmeans regardless? coef not used	*/
	local pomeans = ("`pomeans'"!="")
	/* label PO coefficients according to e(stat)			*/ 
	if (!`pomeans') local pomeans = ("`STAT'"=="POMEANS")  

	forvalues i=1/`klev' {
		gettoken expr stripe0 : stripe0, bind
		local lev : word `i' of `levels'
		if `pomeans' {  
			local stri POmean`lev':_cons
		}
		else {
			if "`lev'" == "`e(control)'" {
				continue
			}
			local stri `STAT'`lev':_cons
		}
		local stripe `stripe' `stri'
	}
	if !`pomeans' {
		local stripe `stripe' POmean`e(control)':_cons
	}
	local stripe `stripe' `stripe0'
	
	mat colnames `b' = `stripe'
end

exit
