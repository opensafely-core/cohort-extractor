*! version 1.0.2  03jun2015
program _teffects_ipwra_p
	version 13
	syntax	anything [if] [in] [, ///
		te CMean LNSigma PSLNSigma ps xb psxb TLevel(string) SCores]
	local predt 	`te' `cmean' `lnsigma' ///
			`pslnsigma' `ps' `xb' `psxb' `scores' 
	local npredt: word count `predt'
	if `npredt' > 1 {
		di as error ///
		"{p}only one of {bf:te}, {bf:lnsigma}, {bf:cmean}, " ///
		"{bf:ps}, {bf:pslnsigma}, {bf:psxb}, {bf:xb}," ///
		" or {bf:scores} can be" ///
		" specified{p_end}"
                exit 198
        }
	else if `npredt' == 0 {
		di as txt "(option {bf:te} assumed; treatment effect)"
		local te te
	}

	local fhetprobit fractional heteroskedastic probit
	local flogit fractional logistic 
	local fprobit fractional probit 

	if ("`lnsigma'" != "" & ///
		("hetprobit" != "`e(omodel)'" & ///
			"`fhetprobit'" != "`e(omodel)'")) {
		di as error ///
		"{bf:lnsigma} not allowed under {bf:omodel(`e(omodel)')}"
		exit 498
	}
	if ("`pslnsigma'" != "" & "hetprobit" != "`e(tmodel)'") {
		di as error ///
		"{bf:pslnsigma} only allowed under {bf:tmodel(hetprobit())}"
		exit 498
	}
	marksample touse, novarlist

	local tlevels `e(tlevels)'
	local cval = e(control)
	if ("`scores'" != "") {
		local sber = ltrim(rtrim("`tlevels'"))
		local s: subinstr local	sber " " ",", all
		qui replace `touse' = 0 if !inlist(`e(tvar)',`s')
	}
	if ("`te'`psxb'`pslnsigma'" != "") {
		local tlevels : list tlevels - cval
	}

	local nlevs: word count `tlevels'
	if "`tlevel'" != "" {
		_teffects_label2value `e(tvar)', label(`tlevel')
		local tlevel = `r(value)'
	}
	if real("`tlevel'") != .  {
		local validtrt = 0
                forvalues i = 1/`nlevs' {
                       	local j: word `i' of `tlevels'
                       	if (`tlevel' == `j') {
				local validtrt = 1
                               	continue, break
                       	}
                }
               	if !`validtrt' & `tlevel' == e(control) {
			di as error ///
		"{bf:tlevel()} must be valid noncontrol treatment level"
			exit 198
		}
		else if !`validtrt' {
			di as error ///
		"{bf:tlevel()} must be valid treatment level"
			exit 198
		}               
	}
	if ("`tlevel'" != "") {
		_stubstar2names `anything', nvars(1) 
	}
	else if "`scores'" == ""{
		capture _stubstar2names `anything', nvars(`nlevs') 	
		if (_rc) {
			_stubstar2names `anything', nvars(1) 
			local tlevel: word 1 of `tlevels'
		}
	}
	else {
		local duonlevs = 0
		if ("hetprobit" == "`e(omodel)'"| ///
			"`fhetprobit'" == "`e(omodel)'") {
			local duonlevs = `duonlevs'+3*`nlevs'
		}
		else {
			local duonlevs = `duonlevs'+2*`nlevs'
		}

		if ("hetprobit" == "`e(tmodel)'") {
			local duonlevs = `duonlevs'+`nlevs'
		}
		else if ("probit" == "`e(tmodel)'") {
			local duonlevs = `duonlevs'+1
		}
		else {
			local duonlevs = `duonlevs'+`nlevs'-1
		}
		_stubstar2names `anything', nvars(`duonlevs') nosubcommand
	}

	// ps of control is sum of other ps - 1
	if ("`ps'" != "" & inlist("`tlevel'","","`cval'")) {
		local typlist `s(typlist)'
		local varlist `s(varlist)'
		local tlevnoc : list tlevels - cval

		tempvar ps`cval'
		qui gen double `ps`cval'' = 1 if `touse'
		foreach lnum of local tlevnoc {
			tempvar ps`lnum'
			qui Predps, touse(`touse') typ(double) ///
				var(`ps`lnum'') lev(`lnum')
			qui replace `ps`cval'' = `ps`cval''-`ps`lnum'' ///
				if `touse'
		}
		if ("`tlevel'" == "") {
			forvalues i = 1/`nlevs' {
				local typ: word `i' of `typlist'
				local var: word `i' of `varlist'
				local lev: word `i' of `tlevels'
				gen `typ' `var' = `ps`lev'' if `touse'
				local lab: value label `e(tvar)'
				if ("`lab'" != "") {
					local lev: label `lab' `lev'
				}
				label variable `var' ///
				`"propensity score, `e(tvar)'=`lev'"'
			}
		}
		else {
			gen `typlist' `varlist' = `ps`cval'' if `touse'		
			local lab: value label `e(tvar)'
			if ("`lab'" != "") {
				local cval: label `lab' `cval'
			}
			label variable `varlist' ///
			`"propensity score, `e(tvar)'=`cval'"'
		}	
	}
	else if ("`ps'" != "") {
		Predps, touse(`touse') ///
			typ(`s(typlist)') var(`s(varlist)') lev(`tlevel')
		local lab: value label `e(tvar)'
		if ("`lab'" != "") {
			local tlevel: label `lab' `tlevel'
		}
		label variable `s(varlist)' ///
			`"propensity score, `e(tvar)'=`tlevel'"'
	}
	else if ("" == "`tlevel'" & "`scores'" == "") {
		local typlist `s(typlist)'
		local varlist `s(varlist)'
		forvalues i = 1/`nlevs' {
			local typ: word `i' of `typlist'
			local var: word `i' of `varlist'
			local lev: word `i' of `tlevels'
			if !("`te'" != "" & `lev' == e(control)) {
Pred`te'`cmean'`lnsigma'`pslnsigma'`ps'`xb'`psxb' , touse(`touse') ///
				typ(`typ') var(`var') lev(`lev')
			}
		}
	}
	else if ("`scores'" == "") {
Pred`te'`cmean'`lnsigma'`pslnsigma'`ps'`xb'`psxb' , touse(`touse') ///
		typ(`s(typlist)') var(`s(varlist)') lev(`tlevel')
	}
	else {
		Predscore, touse(`touse') ///
			typs(`s(typlist)') vars(`s(varlist)')
	}
end

program Predpslnsigma
	syntax, typ(string) var(string) touse(string) lev(string)
	local ens  "`e(enseparator)'" 
	if (`lev' == e(control)) {
		gen `typ' `var' = 0 if `touse'
	}
	else {
		_predict  `typ' `var' if `touse', xb ///
			equation(TME`ens'`lev'_lnsigma) 
	}
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
	}
	label variable `var' ///
`"Propensity score log square root of latent variance, `e(tvar)'=`lev'"'	
end

program Predps 
	syntax, typ(string) var(string) lev(string) touse(string)
	// never called for control
	tempvar xb
	qui Predpsxb, typ(double) var(`xb') lev(`lev') touse(`touse')
	if ("hetprobit" == "`e(tmodel)'") {
		tempvar lns
		qui Predpslnsigma, typ(double) var(`lns') lev(`lev') ///
			touse(`touse')
		gen `typ' `var' = normal(`xb'/exp(`lns')) if `touse'
	}
	else if ("probit" == "`e(tmodel)'") {
		gen `typ' `var' = normal(`xb') if `touse'		
	}
	else if ("`e(tmodel)'" == "logit") {
		local tlevels `e(tlevels)'
		local ctrl `e(control)'
		local tlevels : list tlevels - ctrl
		tempvar denom tps
		qui gen double `denom' = 1 if `touse'
		foreach lnum of local tlevels {
			qui Predpsxb, typ(double) var(`tps') ///
			lev(`lnum') touse(`touse')
			qui replace `denom' = `denom' + exp(`tps') ///
				if `touse'
			drop `tps'
		}
		gen `typ' `var' = exp(`xb')/`denom' if `touse'
	}	
end

program Predpsxb
	syntax, typ(string) var(string) lev(string) touse(string)
	local ens  "`e(enseparator)'" 
	if (`lev' == e(control)) {
		gen `typ' `var' = 0 if `touse'
	}
	else {
		_predict  `typ' `var' if `touse', xb ///
			equation(TME`ens'`lev') 
	}
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
	}
	label variable `var' ///
		`"propensity score, linear prediction, `e(tvar)'=`lev'"'
end


program Predlnsigma
	syntax, typ(string) var(string) lev(string) touse(string)
	local ens "`e(enseparator)'"
	_predict  `typ' `var' if `touse', xb ///
		equation(OME`ens'`lev'_lnsigma) 
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
	}
	label variable `var' ///
		`"log square root of latent variance, `e(tvar)'=`lev'"'
end


program Predxb
	syntax, typ(string) var(string) lev(string) touse(string)
	local ens "`e(enseparator)'"
	_predict  `typ' `var' if `touse', xb ///
		equation(OME`ens'`lev') 
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
	}
	label variable `var' ///
		`"linear prediction, `e(tvar)'=`lev'"'
end

program Predcmean
	syntax, typ(string) var(string) lev(string) touse(string)
	local ens "`e(enseparator)'"
	tempvar xbest
	qui _predict double  `xbest' if `touse', xb ///
		equation(OME`ens'`lev') 
		
	local fhetprobit fractional heteroskedastic probit
	local flogit fractional logistic 
	local fprobit fractional probit 
	
	if ("linear" == "`e(omodel)'") {
		gen `typ' `var' = `xbest' if `touse'
	}
	if ("logit" == "`e(omodel)'"| "`flogit'" == "`e(omodel)'") {
		gen `typ' `var' = invlogit(`xbest') if `touse'
	}
	if ("poisson" == "`e(omodel)'") {
		gen `typ' `var' = exp(`xbest') if `touse'
	}
	if ("probit" == "`e(omodel)'" |"`fprobit'" == "`e(omodel)'") {
		gen `typ' `var' = normal(`xbest') if `touse'
	}
	if ("hetprobit" == "`e(omodel)'"|"`fhetprobit'" == "`e(omodel)'") {
		tempvar zbest
		qui _predict double `zbest' if `touse', xb ///
			equation(OME`ens'`lev'_lnsigma)
		gen `typ' `var' = normal(`xbest'/exp(`zbest')) if `touse'
	}
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
	}

	label variable `var' ///
		`"mean prediction, `e(tvar)'=`lev'"'
end

program Predte
	syntax, typ(string) var(string) lev(string) touse(string)
	tempvar estlev estcontrol
	qui Predcmean, typ(double) var(`estlev') lev(`lev') touse(`touse')
	local cval = e(control)
	qui Predcmean, typ(double) var(`estcontrol') lev(`cval') touse(`touse')
	gen `typ' `var' = `estlev'-`estcontrol' if `touse'
	local lab: value label `e(tvar)'
	if ("`lab'" != "") {
		local lev: label `lab' `lev'
		local cval: label `lab' `cval'
	}
	label variable `var' ///
		`"treatment effect, `e(tvar)': `lev' vs `cval'"'
end	


program Predscore
	syntax, typs(string) vars(string) touse(string)

	tempvar t0k

	local fhetprobit fractional heteroskedastic probit
	local flogit fractional logistic 
	local fprobit fractional probit 

	if ("`e(stat)'"!="pomeans") local copt control(`e(control)')
	if ("`e(stat)'"=="atet") local topt tlevel(`e(treated)')
	if ("`e(cme)'" != "ml") {
		local cmm `e(cme)'
	}	
	local depvar `e(depvar)'
	local tvar `e(tvar)' 
	local varlist `e(fvtvarlist)'
	local tmodel `e(tmodel)'
	local omodel `e(omodel)'
	local stat `e(stat)'
	if ("`stat'"=="atet") local stat att
	local htvarlist `e(fvhtvarlist)'
	local tconstant `e(tconstant)'
	local dconstant `e(dconstant)'
	local hdvarlist `e(fvhdvarlist)'
	local dvarlist `e(fvdvarlist)'
	local tlevels `e(tlevels)'
	local klev = `e(k_levels)'
	local ctrl = e(control)
	local tlev = e(treated)

	/* exclude any new levels that did not exist at estimation	*/
	forvalues i=1/`klev' {
		tempvar t`i'
		local lev : word `i' of `tlevels'

		qui gen byte `t`i'' = (`tvar'==`lev') if `touse'
		local tvars `tvars' `t`i''
	}
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local dhetprobit = ("`omodel'"=="hetprobit"|"`omodel'"=="`fhetprobit'")

	if "`varlist'" != "" {
		fvexpand `varlist' if `touse'
		local fvtvlist `r(varlist)'
		fvrevar `varlist' if `touse'
		local fvtrevar `r(varlist)'
	}
	if `tconstant' | `dconstant' {
		tempvar cons 
		qui gen byte `cons' = 1 if `touse'

		if (`tconstant') local tconst tconst(`cons')
		if (`dconstant') local dconst dconst(`cons')
	}
	if "`dvarlist'" != "" {
		fvexpand `dvarlist' if `touse'
		local fvdvlist `r(varlist)'

		fvrevar `dvarlist' if `touse'
		local fvdrevar `r(varlist)'
	}
	if `pshetprobit' {
		fvexpand `htvarlist' if `touse'
		local fvhtvlist `r(varlist)'

		fvrevar `htvarlist' if `touse'
		local fvhtrevar `r(varlist)'
	}
	if `dhetprobit' {
		fvexpand `hdvarlist' if `touse'
		local fvhdvlist `r(varlist)'

		fvrevar `hdvarlist' if `touse'
		local fvhdrevar `r(varlist)'
	}
	_teffects_omit_vars, klev(`klev') fvtvlist(`fvtvlist')       ///
		fvtrevar(`fvtrevar') `tconst' fvhtvlist(`fvhtvlist') ///
		fvhtrevar(`fvhtrevar') fvdvlist(`fvdvlist')          ///
		fvdrevar(`fvdrevar') `dconst' fvhdvlist(`fvhdvlist') ///
		fvhdrevar(`fvhdrevar')

	local komit = `r(komit)'
	local ind `"`r(index)'"'
	local fvotrevar `"`r(fvotrevar)'"'
	local fvohtrevar `"`r(fvohtrevar)'"'
	local fvodrevar `"`r(fvodrevar)'"'
	local fvohdrevar `"`r(fvohdrevar)'"'
	local k : list sizeof fvotrevar

	tempname b0
	if("`stat'" == "pomeans") {
		mat `b0' = e(b)
	}
	else {
		tempname b
		matrix `b' = e(b)
		/* control is located at `klev' in b			*/
		/* pivot the control to its natural position `ic'	*/
		local ic : list posof "`ctrl'" in tlevels
		if `ic' > 1 {
			mat `b0' = `b'[1,1..`=`ic'-1']
		}
		mat `b0' = (nullmat(`b0'),`b'[1,`klev'])
		if `ic' < `klev' {
			mat `b0' = (`b0',`b'[1,`ic'..`=`klev'-1'])
		}
		mat `b0' = (`b0',`b'[1,`=`klev'+1'...])
	}
	// get omitted and base levels out
	Getob, mat(`b0')
	matrix `b0' = r(mat)

	// temporary score variables for later naming
	local tots: word count `vars'
	local scorelist
	forvalues i = 1/`tots' {
		tempvar tmpscore`i'
		qui gen double `tmpscore`i'' = . if `touse'
		local scorelist `scorelist' `tmpscore`i''
	}
	
	local omodel2 `omodel'
	
	if ("`omodel'"=="`flogit'") {
		local omodel2 flogit
	}
	if ("`omodel'"=="`fprobit'") {
		local omodel2 fprobit
	}
	if ("`omodel'"=="`fhetprobit'") {
		local omodel2 fhetprobit
	}

	
	if "`e(subcmd)'" == "ipwra" {
		_teffects_gmm_ipwra `scorelist' if `touse' ,	///
			depvar(`depvar')			///
			tvars(`tvars') 				///
			tlevels(`tlevels')			///
			control(`ctrl')				///
			treated(`tlev')				///
			tvarlist(`fvotrevar') 			///
			htvarlist(`fvohtrevar')			///
			dvarlist(`fvodrevar') 			///
			hdvarlist(`fvohdrevar')			///
			stat(`stat')				///
			tmodel(`tmodel') 			///
			omodel(`omodel2') 			///
			at(`b0') 
	}
	else { // aipw
		_teffects_gmm_aipw `scorelist' if `touse' ,	///
			depvar(`depvar')			///
			tvars(`tvars') 				///
			tlevels(`tlevels')			///
			control(`ctrl')				///
			psvars(`fvotrevar')			///
			ohvars(`fvohdrevar')			///
			ovars(`fvodrevar')			///
			pshvars(`fvohtrevar')			///
			stat(`stat')				///
			tmodel(`tmodel') 			///
			ofform(`omodel2') cmm(`cmm')		///
			at(`b0') 
	}

	if ("`stat'" == "pomeans") {
		forvalues i = 1/`klev' {
			local lev: word `i' of `tlevels'
			local typ: word `i' of `typs'
			local var: word `i' of `vars'
			gen `typ' `var' = `tmpscore`i'' if `touse'
			local a parameter-level score for mean, ///
				`e(tvar)'=`lev'
			label variable `var' "`a'"
		}
	}
	else {
		local j = 0
		forvalues i = 1/`klev' {
			local lev : word `i' of `tlevels'
			if `lev' == `ctrl' {
				local ic = `i'
				continue
			}
			local typ: word `++j' of `typs'
			local var: word `j' of `vars'
			gen `typ' `var'= `tmpscore`i'' if `touse'
			local astat = upper("`e(stat)'")
			local a parameter-level score ///
				for `astat' `tvar': ///
				`lev' vs `ctrl'
			label variable `var' `"`a'"'
		}
		local typ: word `klev' of `typs'
		local var: word `klev' of `vars'
		gen `typ' `var' = `tmpscore`ic'' if `touse'
		local a parameter-level score 
		local a `a' for mean `tvar', `ctrl'
		label variable `var' "`a'"
	}
	local tto = 0
	// Now predictions for linear forms
	forvalues i = 1/`klev' {
		local lev: word `i' of `tlevels'
		local j = `i' + `klev'
		local typ: word `j' of `typs'
		local var: word `j' of `vars'
		gen `typ' `var'=`tmpscore`j'' if `touse'
		label variable `var' ///
		"equation-level score for linear prediction, `tvar'=`lev'"
	}
	local tto = 2*`klev'
	if ("hetprobit" == "`omodel'"|"`fhetprobit'" == "`omodel'") {
		forvalues i = 1/`klev' {
			local lev: word `i' of `tlevels'
			local j = `i' + `klev' + `klev'
			local typ: word `j' of `typs'
			local var: word `j' of `vars'
			gen `typ' `var' = `tmpscore`j'' if `touse'
			label variable `var' ///
"equation-level score for log square root of latent variance, `tvar'=`lev'"
		}
		local tto = 3*`klev'
	}
	if !("logit" == "`tmodel'") {
		local tto = `tto'+1
		local typ: word `tto' of `typs'
		local var: word `tto' of `vars'
		gen `typ' `var' = `tmpscore`tto'' if `touse'
		label variable `var' ///
"equation-level score for propensity score, linear prediction, `tvar'=`tlev'"
		local tto = `tto'+1
		if ("hetprobit" == "`tmodel'") {
			local typ: word `tto' of `typs'
			local var: word `tto' of `vars'
			gen `typ' `var' = `tmpscore`tto'' if `touse'
                        local ens `e(enseparator)'
                        local elot ///                           
			   equation-level score from TME`ens'`tlev'_lnsigma
			label variable `var' "`elot'" 
		}
	}	
	else {
	        local tlevels : list tlevels - ctrl
		local `--klev'	
		forvalues i = 1/`klev' {
			local lev: word `i' of `tlevels'
			local j = `i'+`tto'
			local typ: word `j' of `typs'
			local var: word `j' of `vars'
			gen `typ' `var' = `tmpscore`j'' if `touse'
			label variable `var' ///
"equation-level score for propensity score, linear prediction, `tvar'=`lev'"
		}
	}
end

program Getob, rclass
	syntax, mat(string)
	tempname matout
	local f: colnames `mat'
	local matoutlist 
	local i = 1
	foreach lnum of local f {
		_ms_parse_parts `lnum'
		if (r(base) != .) {
			local base = r(base)
		}
		else {
			local base = 0
		}
		if (r(omit) != .) {
			local omit = r(omit)
		}	
		else {
			local omit = 0
		}
		if !(`omit'|`base') {
			local matoutlist `matoutlist' , `mat'[1,`i']
		}
		local i = `i'+1
	}

	matrix `matout' = (0 `matoutlist')
	local len = colsof(`matout')
	matrix `matout' = `matout'[1,2..`len']
	return matrix mat = `matout', copy
end
