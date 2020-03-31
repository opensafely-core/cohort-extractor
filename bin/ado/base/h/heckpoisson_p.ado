*! version 1.0.6  04feb2019
program heckpoisson_p
	version 15.0 
	if `"`e(cmd)'"' != "heckpoisson" {
		error 301
	}
	syntax [anything] [if] [in] [, SCores *]
	if `"`scores'"' == "" {
		HeckpoissonPNoscore `0'
	}
	else {
		HeckpoissonPScore `0'
	}
end
						//---HeckpoissonPScore---//
program  HeckpoissonPScore
	syntax anything [if] [in], 	///
		SCores			///
		[EQuation(string)]	// not documented

	marksample touse, novarlist

	_score_spec `anything' ,equation(`equation')	
	local varlist `s(varlist)'
	local typelist `s(typelist)'
	local coleq `s(coleq)'
	local nvars : word count `varlist'
	local eqspec `s(eqspec)'

	tempname sc1 sc2 sc3 sc4 
	tempvar xb zr 

	local sc `sc1' `sc2' `sc3' `sc4'
	qui PredictXb double `xb' `if'	
	qui PredictXbselect double `zr' `if'
	local rho = tanh(_b[/athrho])
	local sigma = exp(_b[/lnsigma])
	local npts  = e(n_quad)
	local y1 `e(depvar)'
	local y2 `e(seldeps)'

	tempvar seldep 
	if `"`y2'"' == "" {
		qui gen `seldep' = 1 if !missing(`depvar') 
		qui replace `seldep' = 0 if missing(`depvar')
	}
	else {
		qui gen `seldep' = `y2'	
	}

	mata : _HECKPOISSON_score(	///
		`"`y1'"',		///
		`"`seldep'"',		///
		`"`xb'"',		///
		`"`zr'"',		///
		`rho',			///
		`sigma',		///
		`npts',			///
		`"`touse'"',		///
		`"`sc'"')
	if `"`eqspec'"' == "" {
		forvalues i=1/`nvars' {
			local typ : word `i' of `typelist'
			local var : word `i' of `varlist'
			local eq  : word `i' of `coleq' 	
			gen `typ' `var' = `sc`i'' if `touse'
			label var `var' 	///
			    "equation-level for [`eq'] score from heckpoisson"
		}
	}
	else {
		local eqnum = bsubstr(`"`eqspec'"',2,1)
		gen `typelist' `varlist' = `sc`eqnum'' if `touse'	
		local eq  : word `eqnum' of `coleq'
		label var `varlist'	///
			"equation-level for [`eq'] score from heckpoisson"
	}
end
						//---HeckpoissonPNoscore---//
program HeckpoissonPNoscore
	syntax newvarname [if] [in] [, 		///
		n				///
		ir				///
	        NCond				///
		pr(passthru)			///
		PSel				///		
		xb				///
		XBSel	 			///
		noOFFset			///
		d1(passthru)			///
		d2(passthru)]

	local deriv `d1' `d2'

	marksample touse, novarlist

	capture opts_exclusive "`n' `ncond' `pr' `psel' `xb' `xbsel' `ir'"
	if _rc !=0 {
		di as err "only one {it:statistic} may be specified"
		exit 498
	}
	
	local case : word count  ///
		`n' `ncond' `pr' `psel' `xb' `xbsel'	`ir'
	if `case' == 0 {
		local n n 
		di as txt "(option {bf:n} assumed)"
	}

	if `"`n'"' != "" {
		PredictPomean `typelist' `varlist' if `touse', `offset' `deriv'
	}
	else if `"`ncond'"' != "" {
		PredictOmean `typelist' `varlist' if `touse', `offset' `deriv'
	}
	else if `"`pr'"' != "" {
		PredictPr `typelist' `varlist' if `touse', `pr' `deriv'
	}
	else if `"`psel'"' !="" {
		PredictPsel `typelist' `varlist' if `touse', `deriv'
	}
	else if `"`xb'"' != "" {
		PredictXb `typelist' `varlist' if `touse', `offset'  `deriv'
	}
	else if `"`xbsel'"' != "" {
		PredictXbselect `typelist' `varlist' if `touse', `deriv'
	}
	else if `"`ir'"' != "" {
		PredictIR `typelist' `varlist' if `touse', `deriv'
	}
end
						//---PredictIR-------//
program PredictIR
	syntax newvarname [if] [, NULLOP]

	tempvar xb
	qui _predict double `xb' `if', xb eq(#1) nooffset
	tempname sigma
	scalar `sigma' = exp(_b[/lnsigma])
	gen `typelist' `varlist' = exp(`xb'+`sigma'^2/2) `if'
	label var `varlist' `"Predicted incidence rate"'
end

						//---PredictPomean---//
program PredictPomean
	syntax newvarname [if] [, noOFFset d1(string) d2(string)]

	tempvar xb
	qui _predict double `xb' `if', xb eq(#1) `offset'
	tempname sigma2
	scalar `sigma2' = exp(_b[/lnsigma]*2)
	gen `typelist' `varlist' = exp(`xb'+`sigma2'/2) `if'
	label var `varlist' `"Predicted number of events"'
	if `"`d2'"' != "" {
		D2Pomean `varlist' `xb' `sigma2' "`if'" `"`d1'"' `"`d2'"'
	}
	else if `"`d1'"' != "" {
		D1Pomean `varlist' `xb' `sigma2' "`if'" `"`d1'"'
	}
end

program D1Pomean
	args var xb sigma2 if d1

	local eq : coleqnumb e(b) `d1'
	if "`eq'" == "." {
		di as err "equation {bf:`d1'} not found"
		exit 198
	}

	if `eq' == 4 {
		qui replace `var' = `var'*`sigma2' `if'
	}
	else if `eq' != 1 {{
		qui replace `var' = 0 `if'
	}
end

program D2Pomean
	args var xb sigma2 if d1 d2

	if strtrim(`"`d1'"') == "" {
		di as err "invalid {bf:d1()} option;"
		di as err "nothing found where equation identifier expected"
		exit 198
	}
	local eq1 : coleqnumb e(b) `d1'
	if "`eq1'" == "." {
		di as err "equation {bf:`d1'} not found"
		exit 198
	}
	local eq2 : coleqnumb e(b) `d2'
	if "`eq2'" == "." {
		di as err "equation {bf:`d2'} not found"
		exit 198
	}

	if !inlist(`eq1',1,4) | !inlist(`eq2',1,4) {
		qui replace `var' = 0 `if'
	}
	else if `eq1' != `eq2' {
		qui replace `var' = `var'*`sigma2' `if'
	}
	else if `eq1' == 4 {
		qui replace `var' = `var'*(`sigma2'*`sigma2'+2*`sigma2') `if'
	}
end

						//---PredictOmean---//
program PredictOmean
	syntax newvarname [if] [, noOFFset]
						// pomean	
	tempvar pomean
	qui PredictPomean double `pomean' `if', `offset'
						// mills
	tempvar wr
	qui _predict double `wr' `if', xb eq(#2)
	tempname sigma rho
	scalar `sigma' = exp(_b[/lnsigma])
	scalar `rho'   = tanh(_b[/athrho])
	tempvar mills
	qui gen double `mills' = normal(`wr'+`rho'*`sigma')/normal(`wr') `if'
						// omean
	gen `typelist' `varlist' = `pomean'*`mills' `if'
	label var `varlist' `"Conditional predicted number of events"'
end
						//---PredictXb---//
program PredictXb
	syntax newvarname [if] [, noOFFset]
	qui _predict `typelist' `varlist' `if', xb eq(#1) `offset'
	label var `varlist' `"Linear prediction for `e(depvar)' equation"'
end
						//---PredictXbselect---//
program PredictXbselect
	syntax newvarname [if] [, NULLOP]
	qui _predict `typelist' `varlist' `if', xb eq(#2)
	label var `varlist' `"Linear prediction for selection equation"'
end
						//---PredictPsel---//
program PredictPsel
	syntax newvarname [if] [, NULLOP]
	tempvar wr
	qui _predict double `wr' `if', xb eq(#2)
	gen `typelist' `varlist' = normal(`wr') `if'
	label var `varlist' `"Pr(select)"'
end
						//---PredictPr---//
program PredictPr
	syntax newvarname [if],		///
		pr(passthru)		///
		[noOFFset]
						// check pr to be positive int
	tempvar prv1 prv2
	CheckPr `if' , `pr' prv1(`prv1') prv2(`prv2')
	local pr1 `s(pr1)'
	local pr2 `s(pr2)'

	if `"`pr2'"' == "" {
		PredictPr1 `typelist' `varlist' `if', 	///
			prv1(`prv1') pr1(`pr1')	`offset'
	}
	else if `"`pr2'"' != ""{
		PredictPr1Pr2 `typelist' `varlist' `if',	///
			prv1(`prv1') prv2(`prv2')		///
			pr1(`pr1') pr2(`pr2') `offset'
	}
end
						//---PredictPr1Pr2---//
program PredictPr1Pr2
	syntax newvarname [if],		///
		prv1(string)		///
		prv2(string)		///
		pr1(string)		///
		pr2(string)		///
		[noOFFset]
	
	tempvar xb touse touse2m pr12_p pr12_p_m
	qui PredictXb double `xb' `if', `offset'
	qui gen double `pr12_p' = . `if'
	qui gen double `pr12_p_m' = . `if'
						// touse for whole sample
	qui gen `touse' = 0 
	qui replace `touse' = 1 `if' 
						// sigma and npts
	local sigma = exp(_b[/lnsigma])
	local npts  = e(n_quad)

	mata: _HECKPOISSON_pr1pr2(	///
		`"`xb'"',		///
		`"`prv1'"',		///
		`"`prv2'"',		///
		`"`touse'"',		///
		`npts',			///
		`sigma',		///
		`"`pr12_p'"',		///
		`"`pr12_p_m'"')
	qui gen `typelist' `varlist' = `pr12_p' `if'
	qui replace `varlist' = `pr12_p_m' `if' & missing(`prv2')
	label var `varlist' `"Pr(`pr1'<=`e(depvar)'<=`pr2')"'
end
						//---PredictPr1---//
program PredictPr1
	syntax newvarname [if], 	///
		pr1(string) 		///
		prv1(string)		///
		[noOFFset]

	tempvar xb touse pr1_p
	qui gen `touse' = 0
	qui replace `touse' = 1 `if'
	qui PredictXb double `xb' `if', `offset'
	qui gen double `pr1_p' = . `if'
	
	local sigma = exp(_b[/lnsigma])
	local npts = e(n_quad)
	mata: _HECKPOISSON_pr1(		///
		`"`xb'"', 		///
		`"`prv1'"',		///
		`"`touse'"',		///
		`npts',			///
		`sigma',		///
		`"`pr1_p'"')
	qui gen `typelist' `varlist' = `pr1_p' `if'
	label var `varlist' `"Pr(`e(depvar)'=`pr1')"'
end
						//---CheckPr---//
program CheckPr, sclass
	syntax [if] , 		///
		pr(string) 	///
		prv1(string)	///
		prv2(string)

	gettoken pr1 pr2 : pr , parse(", ")

	if (`"`pr2'"' == "") {
						// check the first number
		CheckPr1 `if' , pr1(`pr1') prv1(`prv1')
	}
	else if (`"`pr2'"' != "") {
						// check the second number
		CheckPr1Pr2 `if',	///
			pr1(`pr1')	///
			pr2(`pr2')	///
			prv1(`prv1') 	///
			prv2(`prv2')
	}
	sreturn local pr1 `s(pr1)'
	sreturn local pr2 `s(pr2)'
end
						//---CheckPr1---//
program CheckPr1, sclass
	syntax [if] ,		///
		pr1(string) 	///
		prv1(string)

	capture confirm integer number `pr1'
	local pr1n = !_rc
	capture assert `pr1'>0
	local pr1p = !_rc
	capture confirm numeric variable `pr1'
	local pr1v = !_rc
	if ((!`pr1n'&!`pr1v') | !`pr1p') {
		di as error ///
			"argument to {bf:pr()}" ///
			" must be nonnegative integer"    ///
			" or numeric variable"
		exit 198
	}
	qui gen `prv1' = `pr1' `if'
	sreturn local pr1 `pr1'
end
						//---CheckPr1Pr2---//
program CheckPr1Pr2, sclass
	syntax [if], 			///
		pr2(string) 		///
		pr1(string)		///
		prv1(string)		///
		prv2(string)

	capture confirm integer number `pr1'
	local pr1n = !_rc
	capture assert `pr1'>0
	local pr1p = !_rc
	capture confirm numeric variable `pr1'
	local pr1v = !_rc
						// valid separator	
	gettoken sep pr2 : pr2, parse(", ")		
	if `"`sep'"' != "," {
		di as error ///
			"invalid separator in {bf:pr()}, " ///
			"must use comma: ex. {bf:pr(1 ,3)}"
		exit 198
	}
						// check the second number
	capture confirm integer number `pr2'
	local pr2n = !_rc
	capture assert `pr2' == .
	local pr2m = !_rc
	capture confirm numeric variable `pr2'
	local pr2v = !_rc
	capture assert `pr2' > 0
	local pr2p = !_rc
						// first argument
	if (!`pr1p' |(!`pr1n' & !`pr1v')) {
		di as error ///
		"first argument to {bf:pr()}" ///
		" must be nonnegative integer" ///
		" or numeric variable"
		exit 198
	}
						// second argument
	if ((!`pr2n' & !`pr2m' & !`pr2v') | !`pr2p') {
		di "{p 0 0 2}"
		di as error ///
		"second argument to {bf:pr()}" ///
		" must be missing, nonnegative integer," ///
		" or numeric variable"
		di "{p_end}"
		exit 198
	}
						// pr1 <=pr2
	capture assert `pr1' <= `pr2'	
	if _rc {
		di as error ///
			"upper bound of `pr2' must be" ///
			" greater than or equal to the" ///
			" lower bound of `pr1'"
		exit 198
	}
	qui gen `prv1' = `pr1' `if'
	qui gen `prv2' = `pr2' `if'
	sreturn local pr1 `pr1'
	sreturn local pr2 `pr2'
end
