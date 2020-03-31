*! version 1.0.4  29aug2017

program define esizei
	version 13
	#del ; 
	syntax anything [,
		Level(cilevel)
		UNEqual
		Welch  
		COHensd 
		HEDgesg 
		GLAssdelta 
		PBCorr 
		ALL] ;
	#del cr

	if "`level'"=="" {
		local level==c(level)
	}

	if floor(real(`"`level'"')) < 50 {
		di in red 	///
		"{bf:level()} must be between 50 and 99.99 inclusive for {bf:esizei}"
		exit 198
	}

	// CONFIRM 6 ARGUMENTS
	numlist "`anything'", min(3) max(6)
	capture numlist "`anything'", min(6) max(6)
	if _rc==0 local flavor = "means"
	capture numlist "`anything'", min(3) max(3)
	if _rc==0 local flavor = "F"
	
	if "`flavor'" == "means" {
		// PARSE `anything'
		gettoken n1  anything : anything , parse(" ,")
		gettoken m1  anything : anything , parse(" ,")
		gettoken sd1 anything : anything , parse(" ,")
		gettoken n2  anything : anything , parse(" ,")
		gettoken m2  anything : anything , parse(" ,")
		gettoken sd2 : anything , parse(" ,")

		// CHECK THE ATTRIBUTES OF THE ARGUMENTS
		confirm integer number `n1'
		if `n1'<=0 error 2001
		confirm number `m1'
		confirm number `sd1'
		if `sd1'<=0 error 411
		confirm integer number `n2'
		if `n2'<=0 error 2001
		confirm number `m2'
		confirm number `sd2'
		if `sd2'<=0 error 411
			
		quietly ttesti `n1' `m1' `sd1' `n2' `m2' `sd2', `unequal' `welch'
		_esize_calculations , level(`level') immediate  	///
			`unequal' `welch'				///
			`cohensd' `hedgesg' `glassdelta' `pbcorr' `all'
	}
	else if "`flavor'" == "F" {
		local OptionList "unequal welch cohensd hedgesg glassdelta pbcorr all"
		foreach TempOption of local OptionList {
			if "``TempOption''" != "" {
				di as error "option {bf:`TempOption'} not allowed"
				error 198
			}	
		}
	
		// PARSE `anything'
		gettoken df1  anything : anything , parse(" ,")
		gettoken df2  anything : anything , parse(" ,")
		gettoken F    anything : anything , parse(" ,")
		
		// CHECK THE ATTRIBUTES OF THE ARGUMENTS
		confirm integer number `df1'
		if `df1'<=0 error 2001
		confirm integer number `df2'
		if `df2'<=0 error 2001
		confirm number `F'
		if `F'<=0 error 411
		
		if _caller() > 15 {
			Ftest `df1' `df2' `F' `level'
		}
		else {
			Ftest_13 `df1' `df2' `F' `level'
		}
		
	}
	else {
		di as error "{bf:esizei} accepts 3 or 6 arguments"
		error 121
	}
end

program Ftest, rclass
	args df1 df2 F level

	esize_calc_eta `df1' `df2' `F', level(`level')
	
	tempname Eta2 LowerEta2 UpperEta2
	tempname Omega2
	tempname Eps2

	local  level 		= r(level) 
	scalar `Omega2' 	= r(omega2)
	scalar `Eps2' 		= r(epsilon2)
	scalar `UpperEta2' 	= r(ub_eta2)
	scalar `LowerEta2' 	= r(lb_eta2)
	scalar `Eta2' 		= r(eta2)

	disp 	_newline 					///
		as text "Effect sizes for linear models"  	///
		_newline

	tempname mytab
	.`mytab' = ._tab.new, col(4) lmargin(0) puttab(`mytab')
	.`mytab'.width    20   |12    12    12
	.`mytab'.titlefmt  .     .    %24s   .
	.`mytab'.pad       .     2     3     3
	.`mytab'.numfmt    . %9.0g %9.0g %9.0g
	.`mytab'.strcolor result  .  .  . 
	.`mytab'.strfmt    %19s  .  .  .
	.`mytab'.strcolor   text  .  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Effect Size"                   /// 1
			"Estimate"                      /// 2
			"[`level'% Conf. Interval]" ""  //  3 4
	mata: st_put_tab_reset_cspans("`mytab'", "1 2 0")
	.`mytab'.sep, middle
	.`mytab'.row    "Eta-Squared" 		///
		`Eta2'				///
		`LowerEta2' 			///
		`UpperEta2'
	.`mytab'.row "Epsilon-Squared" `Eps2' "" ""
	.`mytab'.row "Omega-Squared" `Omega2' "" ""
	.`mytab'.sep, bottom
	.`mytab'.post_results
	return add
	
	return scalar level = `level'
	return scalar omega2 = `Omega2'
	return scalar epsilon2 = `Eps2'
	return scalar ub_eta2 = `UpperEta2'	
	return scalar lb_eta2 = `LowerEta2'
	return scalar eta2 = `Eta2'
end

program define esize_calc_eta, rclass
	version 15
	syntax anything [, Level(cilevel)]

	// CONFIRM 3 ARGUMENTS
	numlist "`anything'", min(3) max(3)

	// PARSE `anything'
	gettoken NumDF  anything : anything , parse(" ,")
	gettoken DenDF  anything : anything , parse(" ,")
	gettoken F      anything : anything , parse(" ,")
	
	tempname alpha AlphaLower AlphaUpper
	tempname Eta2 LowerEta2 UpperEta2 
	tempname Eps2
	tempname Omega2
	tempname LambdaLower LambdaUpper 
	tempname OutputWidth regress_rss mesize

	scalar `AlphaLower' = (`level'+100)/200
	scalar `AlphaUpper' = 1 - ((`level'+100)/200)

	scalar `Eta2'=`NumDF'*`F'/(`NumDF'*`F'+`DenDF')
	scalar `LambdaLower' = npnF(`NumDF',`DenDF',`F',`AlphaLower')
	scalar `LowerEta2' = max(0,	///
		`LambdaLower'/		///
		(`LambdaLower'+`NumDF'+`DenDF'+1))
	scalar `LambdaUpper' = npnF(`NumDF',`DenDF',`F',`AlphaUpper')
	scalar `UpperEta2' = min(1,	///
		`LambdaUpper'/		///
		(`LambdaUpper'+`NumDF'+`DenDF'+1))
	scalar `Eps2'=(`F'-1)/(`F'+`DenDF'/`NumDF')
	scalar `Omega2'=(`F'-1)/(`F'+(`DenDF'+1)/`NumDF')

	// RETURN RESULTS
	// =================================================
	return scalar level = `level'
	return scalar omega2 = `Omega2'
	return scalar epsilon2 = `Eps2'
	return scalar ub_eta2 = `UpperEta2'	
	return scalar lb_eta2 = `LowerEta2'
	return scalar eta2 = `Eta2'
end

program Ftest_13, rclass
	args df1 df2 F level

	esize_calc_eta_13 `df1' `df2' `F', level(`level')

	tempname Eta2 LowerEta2 UpperEta2
	tempname Omega2 LowerOmega2 UpperOmega2

	local  level 		= r(level) 
	scalar `UpperOmega2' 	= r(ub_omega2) 
	scalar `LowerOmega2' 	= r(lb_omega2)
	scalar `Omega2' 	= r(omega2)
	scalar `UpperEta2' 	= r(ub_eta2)
	scalar `LowerEta2' 	= r(lb_eta2)
	scalar `Eta2' 		= r(eta2)

	disp 	_newline 					///
		as text "Effect sizes for linear models"  	///
		_newline

	// DISPLAY OUTPUT
	tempname mytab
	.`mytab' = ._tab.new, col(4) lmargin(0)
	.`mytab'.width    20   |12    12    12
	.`mytab'.titlefmt  .     .    %24s   .
	.`mytab'.pad       .     2     3     3
	.`mytab'.numfmt    . %9.0g %9.0g %9.0g
	.`mytab'.strcolor result  .  .  . 
	.`mytab'.strfmt    %19s  .  .  .
	.`mytab'.strcolor   text  .  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Effect Size"                   /// 1
			"Estimate"                      /// 2
			"[`level'% Conf. Interval]" ""  //  3 4
	.`mytab'.sep, middle
	.`mytab'.row    "Eta-Squared" 		///
		`Eta2'				///
		`LowerEta2' 			///
		`UpperEta2'
	.`mytab'.row "Omega-Squared"		///
		`Omega2' 			///
		`LowerOmega2'   		///
		`UpperOmega2'
	.`mytab'.sep, bottom
	
	// RETURN RESULTS
	// =================================================
	return scalar level = `level'
	return scalar ub_omega2 = `UpperOmega2'
	return scalar lb_omega2 = `LowerOmega2'
	return scalar omega2 = `Omega2'
	return scalar ub_eta2 = `UpperEta2'	
	return scalar lb_eta2 = `LowerEta2'
	return scalar eta2 = `Eta2'
end

program define esize_calc_eta_13, rclass
	version 13
	syntax anything [, Level(cilevel)]

	// CONFIRM 3 ARGUMENTS
	numlist "`anything'", min(3) max(3)

	// PARSE `anything'
	gettoken NumDF  anything : anything , parse(" ,")
	gettoken DenDF  anything : anything , parse(" ,")
	gettoken F      anything : anything , parse(" ,")
	
	tempname alpha AlphaLower AlphaUpper
	tempname Eta2 LowerEta2 UpperEta2 
	tempname Omega2 LowerOmega2 UpperOmega2
	tempname LambdaLower LambdaUpper 
	tempname OutputWidth regress_rss mesize

	scalar `AlphaLower' = (`level'+100)/200
	scalar `AlphaUpper' = 1 - ((`level'+100)/200)

	scalar `Eta2'=`NumDF'*`F'/(`NumDF'*`F'+`DenDF')
	scalar `LambdaLower' = npnF(`NumDF',`DenDF',`F',`AlphaLower')
	scalar `LowerEta2' = max(0,	///
		`LambdaLower'/		///
		(`LambdaLower'+`NumDF'+`DenDF'+1))
	scalar `LambdaUpper' = npnF(`NumDF',`DenDF',`F',`AlphaUpper')
	scalar `UpperEta2' = min(1,	///
		`LambdaUpper'/		///
		(`LambdaUpper'+`NumDF'+`DenDF'+1))
	// CALCULATE OMEGA-SQUARED 
	// THE EQUATION FOR OMEGA-SQUARED COMES FROM SMITHSON (2001):
	//	EQUATION (7) ON PAGE 615 IS SUBSTITUTED FOR R2 IN 
	//	EQUATION (12) ON PAGE 619 
	scalar `Omega2' = max(0,	///
		`Eta2'-(`NumDF'/`DenDF')*(1-`Eta2'))
	scalar `LowerOmega2' = max(0,	///
		`LowerEta2'-(`NumDF'/`DenDF')*(1-`LowerEta2'))
	scalar `UpperOmega2' = min(1,	///
		`UpperEta2'-(`NumDF'/`DenDF')*(1-`UpperEta2'))

	// RETURN RESULTS
	// =================================================
	return scalar level = `level'
	return scalar ub_omega2 = `UpperOmega2'
	return scalar lb_omega2 = `LowerOmega2'
	return scalar omega2 = `Omega2'
	return scalar ub_eta2 = `UpperEta2'	
	return scalar lb_eta2 = `LowerEta2'
	return scalar eta2 = `Eta2'
end

/*
References

    Smithson, M. 2001.  Correct confidence intervals for various
        regression effect sizes and parameters:  The importance
        of noncentral distributions in computing intervals.  Educational
        and Psychological Measurement 61: 605-632.

*/

