*! version 1.1.2  30jan2019
program ivpoisson_p
	version 13.0
        if "`e(cmd)'" != "ivpoisson" {
                error 301
        }

	syntax newvarlist(min=1 max=1 numeric) [if] [in], 	///
		[n						///
		 pr(string)					/// undoc
		 xb						///
		 Residuals					///
		 XBTotal EQuation(string) noOFFset]
	
	
	// combinations
	if ("`n'" != "" & "`pr'`xb'`xbtotal'`residuals'" != "") | ///
	   ("`pr'" != "" & "`n'`xb'`xbtotal'`residuals'" != "") | ///	
	   ("`xb'" != "" & "`n'`pr'`xbtotal'`residuals'" != "") | ///
	   ("`residuals'" != "" & "`n'`pr'`xb'`xbtotal'" != "") | ///
	   ("`xbtotal'" != "" & "`n'`pr'`xb'`residuals'" != "") {
		di as error "can only specify one of" 
		di as error ///
		"{bf:n}, {bf:pr()}, {bf:residuals}, {bf:xbtotal}, " ///
		"or {bf:xb}"
		exit 198  
	}
	if ("`xb'" != "") {
		//standard xb of model
		_predict `0'
		exit
	}
	else {
		capture assert "`equation'" == ""
		if (_rc) {
			di as error ///
				"{bf:equation()} invalid without {bf:xb}"
			exit 198
		}	
		syntax newvarlist(min=1 max=1 numeric) [if] [in], ///
		[n						///
		 pr(string)					///
		 Residuals					///
		 XBTotal noOFFset]	
	}
	
	//default
	if "`n'`pr'`xbtotal'`residuals'" == "" {
		local n n
                di as text ///
                "(option {bf:n} assumed; predicted number of events)"
	}
		
	// arguments
	// pr
	if ("`pr'" != "") {
		local prp `pr'
		gettoken pr1 prp: prp, parse(", ")
// first token is nonnegative number, or a nonnegative variable
		capture confirm number `pr1'
		local rc1 = _rc
		capture confirm numeric variable `pr1'
		local rc2 = _rc
		capture assert `pr1' >= 0
		local rc3 = _rc
	
		if ("`prp'" == "") {
			if ((`rc1' & `rc2') | `rc3') {
				di as error ///
"argument to {bf:pr()} must be number or variable, and nonnegative" 
				exit 198		
			}
		}	
		else {
			if ((`rc1' & `rc2') | `rc3') {
				di as error ///
"first argument to {bf:pr()} must be number or variable, and nonnegative" 
				exit 198		
			}
			gettoken junk prp: prp, parse(", ")
			capture assert "`junk'" == ","
			if (_rc) {
				di as error ///
"invalid separator in {bf:pr()}, must use comma: ex. {bf:pr(1 , 3)}"
				exit 198
			}		
			local pr2 `prp'
			capture confirm number `pr2'
			local rc1 = _rc
			capture confirm numeric variable `pr2'
			local rc2 = _rc
			capture assert "`pr2'" == "."
			local rc3 = _rc
			capture assert `pr2' >= 0
			local rc4 = _rc
			if ((`rc1' & `rc2') & `rc3') | `rc4' {
				di as error ///
"second argument to {bf:pr()} must be number or variable, " ///
"and nonnegative or missing" 
				exit 198		
			}
		}
	
		if "`pr1'" != "" & "`pr2'" != "" {
			capture assert `pr1' <= `pr2'
			if (_rc) {
				di as error ///
"misspecified interval in {bf:pr()};" 
				di as error ///
"right endpoint must be above or at left endpoint value" 
				exit 198		
			}
		}
	}	
	
	// mark sample and check/create the new variables requested
	marksample touse, novarlist 
	
	// predicted variable
        local predvar `varlist'
        local sto `typlist'
	
	// syntax checked and variables initialized
	// get xb expression for cfunction if necessary
	tempvar xbe
	if ("`e(estimator)'" != "cfunction") {
		qui _predict double `xbe', xb `offset'
	}
	else {
		local nfparms : colnfreeparms e(b)
		qui _predict double `xbe' if `touse', xb `offset' ///
			equation(`e(depvar)')
		if ("`e(endog)'" != "") {
			tempvar tp
			local ndog `e(endog)'
			foreach wct of local ndog {
				qui _predict double `tp', xb equation(`wct')
				local abvar `wct'
				local labvar = ustrlen("`wct'")
				if (`labvar' == 32) {
					local abvar = usubstr("`wct'",1,29) 
				}
				if `nfparms' {
					qui replace `xbe' = `xbe' + 	///
						_b[/c_`abvar']*(	///
						`wct'-`tp') if `touse'		
				}
				else {
					qui replace `xbe' = `xbe' + 	///
						[c_`abvar']_b[_cons]*(  ///
						`wct'-`tp') if `touse'		
				}
				drop `tp'
			}
		}
	}
	if ("`residuals'" != "") {
		Residual, touse(`touse') sto(`sto') predvar(`predvar') ///
			xbe(`xbe')
	}
		
	if ("`n'" != "") {
		Mean, touse(`touse') sto(`sto') predvar(`predvar')  ///
			xbe(`xbe')
	}
	if ("`xbtotal'" != "") {
		XBFull, touse(`touse') sto(`sto') predvar(`predvar') ///
			xbe(`xbe')
	}
	if ("`pr1'" != "" & "`pr2'" == "") {
		Pr1, pr1(`pr1') touse(`touse') sto(`sto') 	///
			predvar(`predvar')  		///
			xbe(`xbe')
	}
	if ( "`pr1'" != "" & "`pr2'" != "") {
		Pr1Pr2, pr1(`pr1') pr2(`pr2') touse(`touse')	///
			sto(`sto') predvar(`predvar')  		///
			xbe(`xbe')
	}
end

program Residual
	syntax , 	[touse(string) 	///
			sto(string) 	///
			predvar(string) ///
			xbe(string)]
	local predvarlab  "Residuals"		
		
	if("`e(additive)'" != "") {
		qui gen `sto' `predvar' = `e(depvar)'- exp(`xbe') ///
			if `touse'			
	}
	else if ("`e(multiplicative)'"!="" | "`e(estimator)'" == "cfunction") {
		qui gen `sto' `predvar' = `e(depvar)'/exp(`xbe') - 1 ///
			if `touse'						
	}	
	
	label variable `predvar' "`predvarlab'"	
	
end

program Mean
	syntax , 	[touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			n(string) ///
			xbe(string)]
	gen `sto' `predvar' = exp(`xbe') if `touse'
        local predvarlab  "Predicted number of events"
	label variable `predvar' "`predvarlab'"
end

program XBFull
	syntax , 	[touse(string) 	 ///
			sto(string) 	 ///
			predvar(string)	 ///
			xbe(string) ]
	qui gen `sto' `predvar' = `xbe' if `touse'	
	if ("`e(estimator)'" == "cfunction") {
		local predvarlab ///
		"Linear prediction on covariates and residuals"
	}
	else {
		local predvarlab ///
		"Linear prediction"
	}

	label variable `predvar' "`predvarlab'"		
	
end

program Pr1
	syntax , 	[pr1(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			xbe(string)]
	local predvarlab  "Pr(`e(depvar)'=`pr1')"
	qui gen `sto' `predvar' = poissonp(exp(`xbe'),`pr1') ///
		if `touse'
	label variable `predvar' "`predvarlab'"

end

program Pr1Pr2
	syntax , 	[pr1(string)	///
			pr2(string)	///
			touse(string) 	///
			sto(string) 	///
			predvar(string)	///
			n(string)	///
			xbe(string) ]
	local predvarlab  "Pr(`pr1'<=`e(depvar)'<=`pr2')"		
			
	capture confirm numeric variable `pr2'
	if (_rc) {
		if ("`pr2'" == ".") {
			local predvarlab  ///
			`"Pr(`pr1'<=`e(depvar)')"'
			// we only care about pr1 <= `e(depvar)'
			// so take the ceiling
			capture confirm numeric variable `pr1'
			if (_rc) {
				local pr1nu = `pr1'
			}
			else {
				tempvar pr1nu
				qui gen long `pr1nu' = `pr1'
			}
			qui gen `sto' `predvar' = ///
				poissontail(exp(`xbe'),`pr1nu') ///
				if `touse'				
		}
		else {			
			capture confirm numeric variable `pr1'
			if (_rc) {
				local pr1nu = `pr1'
			}
			else {
				tempvar pr1nu
				qui gen long `pr1nu' = `pr1'
			}
			
			qui gen `sto' `predvar' = ///
				poisson(exp(`xbe'),`pr2') -  ///
				poisson(exp(`xbe'),`pr1nu') + ///
				poissonp(exp(`xbe'),`pr1nu') ///
				if `touse'			
		}
	}
	else {
		tempvar misspr2
		gen `misspr2' = `pr2' == .
		capture confirm numeric variable `pr1'
		if (_rc) {
			local pr1nu = `pr1'
		}
		else {
			tempvar pr1nu
			qui gen long `pr1nu' = `pr1'
		}
		qui gen `sto' `predvar' = ///
			poissontail(exp(`xbe'),`pr1nu') ///
			 if `touse' & `misspr2'
		tempvar predvar1 se1 ci1l ci1u
		qui gen `sto' `predvar1' = ///
			poisson(exp(`xbe'),`pr2') -  ///
			poisson(exp(`xbe'),`pr1nu') + ///
			poissonp(exp(`xbe'),`pr1nu') ///
			if `touse' & !`misspr2'
		qui replace `predvar' = `predvar1' if !`misspr2'		
	}

	label variable `predvar' "`predvarlab'"

end
program Ivpscores
syntax anything [if] [in]
	marksample touse
	_stubstar2names `anything', nvars(`e(k_eq)') 
	local typlist `s(typlist)'
	local varlist `s(varlist)'

	local nfparms : colnfreeparms e(b)

	tempvar estlhs
	local y: word 1 of `e(depvar)'
	qui _predict double `estlhs' if `touse', equation(`y')
	local j = 2
	tempvar lp
	foreach val in `e(endog)' {
		qui _predict double `lp' if `touse', equation(`val')
		local i = `j'-1
		tempvar resid`i'
		qui gen double `resid`i'' = `val'-`lp' if `touse'
		local abval `val'
		local labval = ustrlen("`val'")
		if (`labval' == 32) {
			local abval = usubstr("`val'",1,29) 
		}	
		if `nfparms' {
			qui replace `estlhs' = `estlhs'+ ///
				_b[/c_`abval']*(`resid`i'') if `touse'
		}
		else {
			qui replace `estlhs' = `estlhs'+ ///
				[c_`abval']_b[_cons]*(`resid`i'') if `touse'
		}
		local j = `j' + 1
	}
	local typ: word 1 of `typlist'
	local var: word 1 of `varlist'
	gen `typ' `var' =`y'/exp(`estlhs') - 1 if `touse'
	label variable `var' "equation-level score for [`y'] from ivpoisson"
	local j = 2
	foreach val in `e(endog)' {
		local typ: word `j' of `typlist'
		local vare: word `j' of `varlist'
		local i = `j'-1
		gen `typ' `vare' = `resid`i'' if `touse'
		label variable `vare' ///
		"equation-level score for [`val'] from ivpoisson"
		local j = `j' + 1
	}
	local i = 1
	local w = wordcount("`e(endog)'")
	foreach val in `e(endog)' {
		local typ: word `j' of `typlist'
		local vare: word `j' of `varlist'
		local qui
		if `i' < `w' {
			local qui qui
		}
		`qui' gen `typ' `vare' = `resid`i''*`var' if `touse'
		local abval `val'
		local labval = ustrlen("`val'")
		if (`labval' == 32) {
			local abval = usubstr("`val'",1,29) 
		}	
		label variable `vare' ///
		"equation-level score for /c_`abval' from ivpoisson"
		local i = `i' + 1
		local j = `j' + 1
	} 
end
exit
