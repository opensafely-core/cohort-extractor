*! version 1.0.1  28mar2017
program _teffects_ipw_p
	version 13
	syntax	anything [if] [in] [, ///
		ps xb LNSigma TLevel(string) SCores]
	local predt `ps' `xb' `scores' `lnsigma'
	local npredt: word count `predt'
	if `npredt' > 1 {
		di as error ///
			"{p}only one of {bf:lnsigma}, {bf:ps}, {bf:xb}"
			" or {bf:scores} can be" ///
			" specified{p_end}"
                exit 198
        }
	else if `npredt' == 0 {
		di as txt "(option {bf:ps} assumed; propensity score)"
		local ps ps
	}
	if ("`lnsigma'" != "" & "hetprobit" != "`e(tmodel)'") {
	di as error "{bf:lnsigma} only allowed under {bf:tmodel(hetprobit())}"
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
	 
	local cval = e(control)
	local tlevels `e(tlevels)'
	if ("`xb'`lnsigma'" != "") {
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
			local sortedlevels: list sort tlevels
			local tlevel: word 1 of `sortedlevels'
			//local tlevel = e(treated)
		}
	}
	else {
		if ("hetprobit" != "`e(tmodel)'") {
			local duonlevs = `nlevs' + `nlevs'-1
		}
		else {
			local duonlevs = `nlevs' + 2*(`nlevs'-1)
		}
		_stubstar2names `anything', nvars(`duonlevs') nosubcommand
	}
	// ps of control is other sum of other ps - 1
	if ("`ps'" != "" & inlist("`tlevel'","","`cval'")) {
		local typlist `s(typlist)'
		local varlist `s(varlist)'
		local etlevels `e(tlevels)'
		local etlevels : list etlevels - cval
		tempvar ps`cval'
		qui gen double `ps`cval'' = 1 if `touse'
		foreach lnum of local etlevels {
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
			Pred`xb'`lnsigma', touse(`touse') ///
				typ(`typ') var(`var') lev(`lev')
		}
	}
	else if ("`scores'" == "") {
		Pred`xb'`lnsigma', touse(`touse') ///
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
	local t    = e(k_levels)	
	local tlev = e(treated)
	local ctrl = e(control)
	local ens  "`e(enseparator)'" 
	if (inlist("`e(tmodel)'","hetprobit", "probit")) {
		tempvar xbps
		qui _predict double `xbps' if `touse', xb ///
			equation(TME`ens'`tlev') 
		tempvar z
		if ("hetprobit"=="`e(tmodel)'") {
			tempvar lns
			qui _predict double `lns' if `touse', xb ///
				equation(TME`ens'`tlev'_lnsigma) 
			tempvar elns
			qui gen double `elns' = exp(`lns') if `touse'
			qui replace `elns' = c(epsdouble) ///
				if `elns' <c(epsdouble) & `touse'
			qui gen double `z' = `xbps'/`elns' ///
				if `touse'
		}
		else if ("probit" == "`e(tmodel)'") {
			qui gen double `z' = `xbps' if `touse'
		}

		tempvar cdf f p
		qui gen double `cdf' = normal(`z') if `touse'
		qui replace `cdf' = c(epsdouble) if `cdf'<c(epsdouble) ///
			& `touse'
		qui gen double `p' = cond(`e(tvar)'==`tlev',`cdf',1-`cdf') ///
			if `touse'
		qui gen double `f' = normalden(`z') if `touse'
		qui replace `f' = cond(`e(tvar)'==`tlev',`f',-`f') if `touse'
		tempvar r
		qui gen double `r' = `f'/`p' if `touse'
		if ("hetprobit"=="`e(tmodel)'") {
			qui replace `r' = `r'/`elns' if `touse'
			tempvar rh
			qui gen double `rh' = -`r'*`xbps' if `touse'
		}
		tempvar ipw
		if ("`e(stat)'" == "atet") {
			qui gen double `ipw' = `cdf'/`p' if `touse'
		}
		else {
			qui gen double `ipw' = 1/`p' if `touse'
		}

		qui summarize `ipw' if `touse', meanonly
		tempname mp
		scalar `mp' = r(mean)
		qui replace `ipw' = `ipw'/`mp' if `touse'
		// r is ps linear predictor score
		// rh is ps lnsigma linear predictor score
		tempvar del
		if ("`e(stat)'" == "pomeans") {
			qui gen double `del' = `e(depvar)' - ///
			[POmeans]_b[`tlev'.`e(tvar)']*(`tlev'.`e(tvar)') ///
			- [POmeans]_b[`ctrl'.`e(tvar)']*(`ctrl'.`e(tvar)') ///
			if `touse'
		}
		else if ("`e(stat)'" == "ate") {
			qui gen double `del' = `e(depvar)' - ///
			[ATE]_b[r`tlev'vs`ctrl'.`e(tvar)']*( ///
			`tlev'.`e(tvar)') ///
			- [POmean]_b[`ctrl'.`e(tvar)'] ///
			if `touse'
		}
		else if ("`e(stat)'" == "atet") {
			qui gen double `del' = `e(depvar)' - ///
			[ATET]_b[r`tlev'vs`ctrl'.`e(tvar)']*( ///
			`tlev'.`e(tvar)') ///
			- [POmean]_b[`ctrl'.`e(tvar)']  ///
			if `touse'
		}
		local stat1: word 1 of `vars'
		local typ1: word 1 of `typs'
		if ("`e(stat)'" == "pomeans") {
			gen `typ1' `stat1' = `ipw'*`del'* ///
				(`ctrl'.`e(tvar)') if `touse'
			label variable `stat1' ///
			 `"parameter-level score for mean, `e(tvar)'=`ctrl'"'
		}
		else {
			gen `typ1' `stat1' = `ipw'*`del' if `touse'
			local astat = upper("`e(stat)'")
			local a parameter-level score for `astat' ///
			`e(tvar)': `tlev' vs `ctrl'
			label variable `stat1' `"`a'"'
		}
		local stat2: word 2 of `vars'
		local typ2: word 2 of `typs'
		gen `typ2' `stat2' = `ipw'*`del'*(`tlev'.`e(tvar)') if `touse'
		if ("`e(stat)'" == "pomeans") {
			label variable `stat2' ///
			 `"parameter-level score for mean, `e(tvar)'=`tlev'"'
		}
		else {
			label variable `stat2' ///
		 `"parameter-level score for mean `e(tvar)', `ctrl' vs. base"'
		}
		local ps: word 3 of `vars'
		local pst: word 3 of `typs'
		gen `pst' `ps' = `r' if `touse'
		label variable `ps' ///
		"equation-level score for linear prediction, `e(tvar)'=`tlev'"
		if ("hetprobit"=="`e(tmodel)'") {
			local psl: word 4 of `vars'
			local pstl: word 4 of `typs'
			gen `pstl' `psl' = `rh' if `touse'
			local elot equation-level score for log ///
		square root of latent variance, `e(tvar)'=`tlev'
			label variable `psl' "`elot'" 
		}
	}
	else if ("logit" == "`e(tmodel)'") {
		tempvar den
		qui gen double `den' = 1 if `touse'
		forvalues i = 1/`t' {
			local lev: word `i' of `tlevels'
			if (`lev' != `ctrl') {
				tempvar xbps`lev'
				qui _predict double `xbps`lev'' if ///
					`touse', xb equation(TME`ens'`lev') 
				tempvar p`lev'
				qui gen double `p`lev'' = ///
					exp(`xbps`lev'') if `touse'
				qui replace `den' = `den' + `p`lev'' ///
					if `touse'
			}
		}
		tempvar p`ctrl'
		qui gen double `p`ctrl'' = 1/`den' if `touse'
		tempvar p
		qui gen double `p'=`p`ctrl'' if `touse' & `e(tvar)'==`ctrl'
		tempvar r`ctrl'
		qui gen double `r`ctrl'' = (`e(tvar)'==`ctrl')-`p`ctrl'' ///
			if `touse'
		forvalues i = 1/`t' {
			local lev: word `i' of `tlevels'
			if (`lev' != e(control)) {
				tempvar r`lev'
				qui replace `p`lev'' = `p`lev''/`den' ///
					if `touse'
				qui replace `p' = `p`lev'' if `touse' & ///
					`e(tvar)' == `lev'			
				qui gen double `r`lev'' = ///
					(`e(tvar)'==`lev')-`p`lev'' ///
				if `touse'
			}
		}
		tempvar ipw
		if ("`e(stat)'" == "atet") {
			qui gen double `ipw' = `p`tlev''/`p' if `touse'
		}
		else {
			qui gen double `ipw' = 1/`p' if `touse'
		}
		qui summarize `ipw' if `touse', meanonly
		tempname mp
		scalar `mp' = r(mean)
		qui replace `ipw' = `ipw'/`mp' if `touse'

		tempvar del
		qui gen double `del' = `e(depvar)' if `touse'

		if ("`e(stat)'" == "pomeans") {
			forvalues i = 1/`t' {
				local lev: word `i' of `tlevels'
				qui replace `del' = `del' - ///
					[POmeans]_b[`lev'.`e(tvar)']* ///
					(`lev'.`e(tvar)') if `touse'		
			}
		}
		else {
			forvalues i = 1/`t' {
				local lev: word `i' of `tlevels'
				local STAT = upper("`e(stat)'")
				if (`lev' != `ctrl') {
					qui replace `del' = `del' - ///
				[`STAT']_b[r`lev'vs`ctrl'.`e(tvar)']* ///
						(`lev'.`e(tvar)') ///
					if `touse'				
				}
				else {
					qui replace `del' = `del' - ///
					[POmean]_b[`ctrl'.`e(tvar)'] ///
					if `touse'
				}	
			}			
		}
		if ("`e(stat)'" == "pomeans") {
			forvalues i = 1/`t' {
				local lev: word `i' of `tlevels'
				local typ: word `i' of `typs'
				local var: word `i' of `vars'
				gen `typ' `var' = `ipw'*`del'* ///
					(`lev'.`e(tvar)') if `touse'
				local a parameter-level score for mean, ///
					`e(tvar)'=`lev'
				label variable `var' "`a'"
			} 
		}
		else {
			local tlevnoc : list tlevels - ctrl
			local tmi = `t'-1
			forvalues i = 1/`tmi' {
				local lev: word `i' of `tlevnoc'
				local typ: word `i' of `typs'
				local var: word `i' of `vars'
				gen `typ' `var'= ///
				`ipw'*`del'*(`lev'.`e(tvar)') ///
					if `touse'
				local astat = upper("`e(stat)'")
				local a parameter-level score ///
					for `astat' `e(tvar)': ///
					`lev' vs `ctrl'
				label variable `var' `"`a'"'
			}
			local typ: word `t' of `typs'
			local var: word `t' of `vars'
			gen `typ' `var' = `ipw'*`del' if `touse'
			local a parameter-level score 
			local a `a' for mean `e(tvar)', `ctrl' vs. base
			label variable `var' "`a'"
		}
		local j = `t'
		forvalues i = 1/`t' {
			local lev: word `i' of `tlevels'
			if `lev' == `ctrl' {
				continue
			}
			local typ: word `++j' of `typs'
			local var: word `j' of `vars'
			gen `typ' `var' = `r`lev'' if `touse'
			label variable `var' ///
		"equation-level score for linear prediction, `e(tvar)'=`lev'"
		}
	}
end

program Predlnsigma
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
`"log square root of latent variance, `e(tvar)'=`lev'"'	
end


program Predxb
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
		`"Linear prediction, `e(tvar)'=`lev'"'
end

program Predps 
	syntax, typ(string) var(string) lev(string) touse(string)
	// never called for control
	tempvar xb
	qui Predxb, typ(double) var(`xb') lev(`lev') touse(`touse')
	if ("hetprobit" == "`e(tmodel)'") {
		tempvar lns
		qui Predlnsigma, typ(double) var(`lns') lev(`lev') ///
			touse(`touse')
		gen `typ' `var' = normal(`xb'/exp(`lns')) if `touse'
	}
	else if ("probit" == "`e(tmodel)'") {
		gen `typ' `var' = normal(`xb') if `touse'		
	}
	else if ("`e(tmodel)'" == "logit") {
		local tlevels `e(tlevels)'
		local cntl `e(control)'
		local tlevels : list tlevels - cntl
		tempvar denom tps
		qui gen double `denom' = 1 if `touse'
		foreach lnum of local tlevels {
			qui Predxb, typ(double) var(`tps') ///
			lev(`lnum') touse(`touse')
			qui replace `denom' = `denom' + exp(`tps') ///
				if `touse'
			drop `tps'
		}
		gen `typ' `var' = exp(`xb')/`denom' if `touse'
	}	
end
exit
