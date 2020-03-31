*! version 1.0.3  28mar2017
program _teffects_ra_p
	version 13
	syntax	anything [if] [in] [, ///
		te CMean xb LNsigma TLevel(string) SCores]
	local predt `te' `cmean' `xb' `scores' `lnsigma'
	local npredt: word count `predt'
	if `npredt' > 1 {
		di as error ///
		"{p}only one of {bf:te}, {bf:cmean}, {bf:xb}, {bf:lnsigma}" ///
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
	
	if ("`lnsigma'" != "" & "hetprobit" != "`e(omodel)'" & ///
		"`fhetprobit'" != "`e(omodel)'") {
		di as error ///
		"{bf:lnsigma} not allowed under {bf:omodel(`e(omodel)')}"
		exit 498
	}

	capture assert "" == "`tlevel'" if "" != "`scores'"
	if _rc {
		di as error "cannot specify {bf:tlevel()} with {bf:scores}"
		exit 198
	}
	marksample touse, novarlist

	if ("`scores'" != "") {
		local sber = ltrim(rtrim("`e(tlevels)'"))
		local s: subinstr local	sber " " ",", all
		qui replace `touse' = 0 if !inlist(`e(tvar)',`s')
	}
	 
	local tlevels `e(tlevels)'
	local control `e(control)'
	if ("`te'" != "") local tlevels : list tlevels - control

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
			local sortedlevels: list sort tlevels
			local tlevel: word 1 of `sortedlevels'
		}
	}
	else {
		if ("hetprobit" != "`e(omodel)'"& ///
			"`fhetprobit'" != "`e(omodel)'") {
			local duonlevs = 2*`nlevs'
		}
		else {
			local duonlevs = 3*`nlevs'
		}
		_stubstar2names `anything', nvars(`duonlevs') nosubcommand
	}

	if ("" == "`tlevel'" & "`scores'" == "") {
		local typlist `s(typlist)'
		local varlist `s(varlist)'
		forvalues i = 1/`nlevs' {
			local typ: word `i' of `typlist'
			local var: word `i' of `varlist'
			local lev: word `i' of `tlevels'
			if !("`te'" != "" & `lev' == e(control)) {
				Pred`xb'`cmean'`te'`lnsigma', touse(`touse') ///
					typ(`typ') var(`var') lev(`lev')
			}
		}
	}
	else if ("`scores'" == "") {
		Pred`xb'`cmean'`te'`lnsigma', touse(`touse') ///
			typ(`s(typlist)') var(`s(varlist)') lev(`tlevel')
	}
	else {
		Predscore, touse(`touse') ///
			typs(`s(typlist)') vars(`s(varlist)')
	}
end

program Predscore
	syntax, typs(string) vars(string) touse(string)
        local tlevels `e(tlevels)'
	local ens "`e(enseparator)'"
	local t = e(k_levels)	
	
	local fhetprobit fractional heteroskedastic probit
	local flogit fractional logistic 
	local fprobit fractional probit 

	forvalues i = 1/`t' {
		local lev: word `i' of `tlevels'
		tempvar OME`lev' m`lev'
		qui _predict double `OME`lev'' if `touse', xb ///
			equation(OME`ens'`lev') 
		if ("linear" == "`e(omodel)'") {
			qui gen double `m`lev'' = `OME`lev'' if `touse'
		}
		else if ("logit" == "`e(omodel)'"| ///
			"`flogit'" == "`e(omodel)'") {
			qui gen double `m`lev''=invlogit(`OME`lev'') if `touse'
		}
		else if ("poisson" == "`e(omodel)'") {
			qui gen double `m`lev'' = exp(`OME`lev'') if `touse'			
		}
		else if ("probit" == "`e(omodel)'" | ///
			"`fprobit'" == "`e(omodel)'") {
			qui gen double `m`lev'' = normal(`OME`lev'') if `touse'
			tempvar f`lev'
			qui gen double `f`lev''=normalden(`OME`lev'') if `touse'
		}
		if ("hetprobit" == "`e(omodel)'"| ///
			"`fhetprobit'" == "`e(omodel)'") { 	
			tempvar f`lev' ez`lev' OMEs`lev'
			qui _predict double `OMEs`lev'' if `touse', xb ///
				equation(OME`ens'`lev'_lnsigma)
			qui gen double `ez`lev'' = exp(`OMEs`lev'') if `touse'
			qui replace `ez`lev'' = c(epsdouble) ///
				 if `touse' & `ez`lev'' < c(epsdouble)		
			qui gen double `f`lev'' = ///
				normalden(`OME`lev''/`ez`lev'')/`ez`lev'' ///
				if `touse'
			qui gen double `m`lev'' = ///
				normal(`OME`lev''/`ez`lev'')  if `touse'				
		}
		if (inlist("`e(omodel)'","probit", "hetprobit", ///
			"`fhetprobit'")) {
			tempvar mm`lev'
			qui gen double `mm`lev'' = `m`lev''*(1-`m`lev'') ///
				if `touse'			
			qui replace `mm`lev'' = c(epsdouble) ///
				if `touse' & `mm`lev''<c(epsdouble)
		}
	}
	if ("`e(stat)'" != "pomeans") {
		local cval = e(control)
		local tval = e(treated)
		local astat = upper("`e(stat)'")
		local multit = 1
		local tlevels `e(tlevels)' 
		local control `e(control)'
		local tlevels : list tlevels - control
		local tm1 = e(k_levels)-1		
		if ("`astat'" == "ATET") {
			local multit `tval'.`e(tvar)'
		}		
		forvalues i = 1/`tm1' {
			local lev: word `i' of `tlevels'
			local var: word `i' of `vars'
			local typ: word `i' of `typs'
			gen `typ' `var' = `multit'*(`m`lev'' ///
				-[POmean]_b[`cval'.`e(tvar)'] ///
				-[`astat']_b[r`lev'vs`cval'.`e(tvar)']) ///
				if `touse'
			local a parameter-level score for `astat' `e(tvar)'
			local a `a': `lev' vs `cval'
			label variable `var' `"`a'"'
		}
		local t = `tm1'+1
		local pmean: word `t' of `vars'	
		local typen: word `t' of `typs'
		gen `typen' `pmean' = `multit'*(`m`cval'' ///
			- [POmean]_b[`cval'.`e(tvar)']) if `touse'
		label variable `pmean' ///
	 `"parameter-level score for mean `e(tvar)', `cval' vs. base"'
	}
	else {
	        local tlevels `e(tlevels)'
		local t = e(k_levels)	
		forvalues i = 1/`t' {
			local lev: word `i' of `tlevels'
			local var: word `i' of `vars'
			local typ: word `i' of `typs'
			gen `typ' `var'=`m`lev'' - ///
				[POmeans]_b[`lev'.`e(tvar)'] if `touse'
			label variable `var' ///
			`"parameter-level score for mean, `e(tvar)'=`lev'"'
		}
	}
        local tlevels `e(tlevels)'
	local t = e(k_levels)	
	forvalues i = 1/`t' {
		local lev: word `i' of `tlevels'
		if ("`cnoind'" != "") {
			local mx `lev.`e(tvar)' 
		}
		local j = `i' + `t'
		local typ: word `j' of `typs'
		local var: word `j' of `vars'
		if (inlist("`e(omodel)'", "linear", "logit", "poisson", ///
			"`flogit'")) {
			gen `typ' `var'= ///
			`lev'.`e(tvar)'*(`e(depvar)'-`m`lev'') if `touse'
		}
		else if (inlist("`e(omodel)'","hetprobit","probit", ///
			"`fprobit'", "`fhetprobit'")) {
			gen `typ' `var'=`lev'.`e(tvar)'*( ///
				`f`lev''*(`e(depvar)'-`m`lev'')/`mm`lev'') ///
			if `touse'
		}
		label variable `var' ///
		"equation-level score for linear prediction, `e(tvar)'=`lev'"
	}
	if ("hetprobit" == "`e(omodel)'"|"`fhetprobit'" == "`e(omodel)'") {
		forvalues i = 1/`t' {
			local lev: word `i' of `tlevels'
			local j = `i' + `t' + `t'
			local typ: word `j' of `typs'
			local var: word `j' of `vars'
			local k = `i' + `t'
			local varl: word `k' of `vars'
			gen `typ' `var' = ///
			`lev'.`e(tvar)'*(-`OME`lev''*`varl') if `touse'
			label variable `var' ///
"equation-level score for log square root of latent variance, `e(tvar)'=`lev'"
		}
	}
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
	if ("probit" == "`e(omodel)'"| "`fprobit'" == "`e(omodel)'") {
		gen `typ' `var' = normal(`xbest') if `touse'
	}
	if ("hetprobit" == "`e(omodel)'"| "`fhetprobit'" == "`e(omodel)'") {
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
exit
