*! version 1.0.5  30nov2018

program define eteffects_p
        version 14
        
        syntax [anything] [if] [in],		///
                        [			///
                        te			///
                        xb			///
                        ps			///
			CMean			///
			SCores			///
			psxb			///
			TLEvel			///
			XBTotal			///
                        ]   
        
	marksample touse 
	
	// tlevel

	if "`tlevel'"=="" {
		local tlevel = 0
	}
	else{
		local tlevel  = 1
	}
	
	// Statistic 
	
	local scorest = 1
	
	if "`e(stat)'"=="atet" {
		local scorest = 2 
	}
	if "`e(stat)'"=="pomeans" {
		local scorest = 3
	}
	
	// Outcome models 
	
	local modelo = "`e(omodel)'"
		 
	if "`modelo'"=="linear" {
		local omodel = 1
	}
	if "`modelo'"=="exponential" {
		local omodel = 2
	}
	if ("`modelo'"=="probit"|"`modelo'"=="fractional"){
		local omodel = 3
	}
	
	if `"`scores'"' == "" {
		_stubstar2names `anything', nvars(2) singleok nosubcommand
		local varlist  = s(varlist)
		local typlist `s(typlist)'
		local score = real("`s(stub)'")
		local ns: list sizeof varlist
		
		//// Parsing options

		local options = ("`te'"!="") + ("`xb'"!="") + ("`ps'"!="") + ///
				("`cmean'"!="") + ("`psxb'"!="") + ///
				("`xbtotal'"!="")
				
		local stat "`te'`xb'`ps'`cmean'`xbtotal'`psxb'"

		if `options' > 1 {
			display as error "only one statistic may be specified"
			exit 198
		}

		if `options'== 0 {
			display as text ///
			"(statistic {bf:te} assumed; treatment effect)"
			local stat = 1
		}

		if "`stat'"=="`te'" {
			local stat = 1
		}
		
		if "`stat'"=="`xbtotal'" {
			local stat = 2
		}

		if "`stat'"=="`ps'" {
			local stat = 3
		}

		if "`stat'"=="`cmean'" {
			local stat = 4
		}
		if "`stat'"=="`psxb'" {
			local stat = 5
		}

		if "`stat'"=="`xb'" {
			local stat = 6
		}
		
		
		if ((`stat'==1|`stat'==5) & `ns'>1){
			display as error "too many variables specified"
			exit 103
		}
		if ((`stat'==1|`stat'==5) & `tlevel'==1) {
			display as error "option {bf:tlevel} may not be" ///
			" specified with {bf:te} or {bf:psxb}"
			exit 198
		}

		tempname predict1 predict2 
		quietly generate double `predict1'    = .
		quietly generate double `predict2'    = .

		mata: _IVteFFecTs_PoST("`touse'", `stat', `omodel',	///
					"`e(depvar)'", "`e(tvar)'",	///
					"`e(ovars)'", "`e(tvars)'",	///
					"`predict1'", "`predict2'")
		
		forvalues i = 1(1)`ns' {
			local name`i' = word("`varlist'",`i')
			if (`tlevel'==0) {
				generate `typlist' `name`i'' = `predict`i'' 
			}   
		}

		if (`tlevel'==1 & `ns'==2) {
			generate `typlist' `name1' = `predict2'
			generate `typlist' `name2' = `predict1'
		}
		if (`tlevel'==1 & `ns'==1) {
			generate `typlist' `name1' = `predict2'
		}	

		if `stat'== 1 {
			label var `name1' "treatment effect, `e(tvar)': 1 vs 0"
		}
		if `stat'== 2 {
			local cmon3 linear prediction on covariates
			label var `name1' ///
			"`cmon3' and predictors, `e(tvar)'=`tlevel'"
			if `ns' > 1 {
				local tlevel = abs(`tlevel'-1)
				label var `name2' ///
				"`cmon3' and predictors, `e(tvar)'=`tlevel'"
			}
		}
		if `stat'==4 {
			label var `name1' ///
			"mean prediction, `e(tvar)'=`tlevel'"
			if `ns' > 1 {
				local tlevel = abs(`tlevel'-1)
				label var `name2' ///
				"mean prediction, `e(tvar)'=`tlevel'"
			}
		}
		if `stat'==3 {
			label var `name1' ///
			"propensity score, `e(tvar)'=`tlevel'"
			if `ns' > 1 {
				local tlevel = abs(`tlevel'-1)
				label var `name2' ///
				"propensity score, `e(tvar)'=`tlevel'"
			}			
		}
		if `stat'==5 {
			local cmon4 propensity score, linear prediction,
			label var `name1' "`cmon4' `e(tvar)'=`tlevel'"
			if `ns' > 1 {
				local tlevel = abs(`tlevel'-1)
				label var `name2' ///
				"`cmon4' `e(tvar)'=`tlevel'"
			}			
		}
		if `stat'==6 {
			label var `name1' ///
			"linear prediction, `e(tvar)'=`tlevel'"
			if `ns' > 1 {
				local tlevel = abs(`tlevel'-1)
				label var `name2' ///
				"linear prediction, `e(tvar)'=`tlevel'"
			}			
		}
	}
	else {
		_stubstar2names `anything', nvars(5) singleok nosubcommand
		local varlist  = s(varlist)
		local typlist `s(typlist)'
		local score = real("`s(stub)'")
		local ns: list sizeof varlist	
		
		if "`e(wtype)'" != "" {
			local wgt [`e(wtype)' `e(wexp)']
		}
		
		tempname predict1  predict2 predict3  predict4 predict5
		quietly generate double `predict1'    = .
		quietly generate double `predict2'    = .
		quietly generate double `predict3'    = .
		quietly generate double `predict4'    = .
		quietly generate double `predict5'    = .
		
		mata: _IVteFFecTs_PoST2("`touse'", `omodel',		///
					"`e(depvar)'", "`e(tvar)'",	///
					"`e(ovars)'", "`e(tvars)'",	///
					"`predict1'", "`predict2'",	///
					"`predict3'","`predict4'",	///
					"`predict5'", `scorest')
					
		forvalues i = 1(1)`ns' {
			local name`i' = word("`varlist'",`i')
			generate `typlist' `name`i'' = `predict`i''                        
		}

		// Labels for predicted scores 
		
		local cmon parameter-level score from potential outcome mean
		local cmon2 equation-level score from linear outcome when
		
		if `scorest'==1 {
			if (`ns'==1) {
				label var `name1' ///
				"parameter-level score from ATE"
			}
			else {
				label var `name1' ///
				"parameter-level score from ATE"
				label var `name2' "`cmon' when `e(tvar)'=0"
				label var `name3' ///
				"equation-level score from probit treatment"
				label var `name4' "`cmon2' `e(tvar)'=0"
				label var `name5' "`cmon2' `e(tvar)'=1"
			}
		}
		if `scorest'==2 {
			if (`ns'==1) {
				label var `name1'  ///
					"parameter-level score from ATET"
			}
			else {
				label var `name1' ///
					"parameter-level score from ATET"
				label var `name2' "`cmon' when `e(tvar)'=0"
				label var `name3' ///
				"equation-level score from probit treatment"
				label var `name4' "`cmon2' `e(tvar)'=0"
				label var `name5' "`cmon2' `e(tvar)'=1"
			}
		}
		if `scorest'==3 {
			if (`ns'==1) {
				label var `name1' "`cmon' when `e(tvar)'=0"
			}
			else {
				label var `name1' "`cmon' when `e(tvar)'=0"
				label var `name2' "`cmon' when `e(tvar)'=1"
				label var `name3' ///
				"equation-level score from probit treatment"
				label var `name4' "`cmon2' `e(tvar)'=0"
				label var `name5' "`cmon2' `e(tvar)'=1"
			}
		}
	}

end
