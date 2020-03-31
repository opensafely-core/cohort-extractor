*! version 1.0.0  17feb2015
program power_cmd_exp_parse
	version 14
	
	syntax [anything] [, test * ]
	local type `test'
	if ("`test'"=="") {
		di as err "invalid syntax"
		exit 198
	}	
	_power_exp_`type'_parse `anything', `options'

end

program _power_exp_test_parse

	// parse options needed to determine when iteration opts are allowed
	syntax [anything(name=args)] , pssobj(string) [ * ]
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)			
	local 0 , `options' 

	mata: `pssobj'.getsolvefor("solvefor")

	//parse options to check
	_pss_syntax SYNOPTS : twotest  
	syntax [, 		`SYNOPTS' 	///
				HRatio(string)	///
				LNHRatio(string) ///
				effect(string)	///
				Time(string)	///
				LOGHazard	///
				UNConditional	///
			     	FPeriod(string) /// 
				APeriod(string) ///
				STUDYTime(string) ///
				APRob(string)	///
				ATime(string)	///
				APTime(string)	///
				ASHape(string)	///
				LOSSPRob(string) ///
				lossprob1(string) ///
				lossprob2(string) ///
				LOSSTime(string) ///
				LOSSHaz(string) ///
				losshaz1(string) ///
				losshaz2(string) ///
				SHOW	///
				SHOW1(string)	///
				DIFFerence(string) ///
				HDIFFerence(string) ///
				p1(string)	///	//undocumented
				initshape(real 0.5)  /// init to solve arate
		]
				
	if `"`time'"' == "" {
		local argnames hazard rates
		local argname hazard rate
		local hs_sym h
	}
	else {
		local argnames survival probabilities
		local argname survival probability
		local hs_sym s
	}
	
	local nargs 0
	if (`"`arg1'"'!="") {
		if ("`time'" == "") {
			cap numlist `"`arg1'"', range(>0)
			if (_rc) {
di as err "`argnames' must be positive numbers"
				exit 198
			}
		}	
		else {	
			cap numlist `"`arg1'"', range(>0 <1)
			if (_rc) {
di as err "`argnames' must be numbers between 0 and 1"
				exit 198
			}
		}	
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list

		local ++nargs
	}
	if (`"`arg2'"'!="") {
		if ("`time'" == "") {
			cap numlist `"`arg2'"', range(>0)
			if (_rc) {
di as err "`argnames' must be positive numbers"
				exit 198
			}
		}	
		else {	
			cap numlist `"`arg2'"', range(>0 <1)
			if (_rc) {
di as err "`argnames' must be numbers between 0 and 1"
			}
		}	
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list
		local ++nargs
	
		if `ka1'==1 & `ka2'==1 {
			if (`arg1' == `arg2') {
di as err "{p}`argnames' in the control and the experimental groups " ///
	"must be different{p_end}"
				exit 198
			}	
			if reldif(`arg1',`arg2')<=1e-6 {
di as err "{p}`argnames' in the control and the experimental " ///
	"groups are too close; reldif(`hs_sym'1,`hs_sym'2) <= 1.0e-6{p_end}"
				exit 198
			}
		}	
		
	}
	
	if `"`args'"'!="" {
		local ++nargs
	}

	if ("`solvefor'"=="esize") {
		di as err "{p}effect-size determination is not available "
		exit 198
	}
	
	local effmsgor "{bf:hratio()}, {bf:lnhratio()}, " ///
		"{bf:difference()}, or {bf:hdifference()}" 
	
	local nopts 0
	foreach x in hratio lnhratio difference hdifference {
		if (`"``x''"'!="") local ++nopts
	}
	if (`nopts'>1) {
		di as err "{p}only one of `effmsgor' is allowed{p_end}"
		exit 198
	}         
	
	if (`nargs'>0) {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
					"exponential" "`argname'" "optargsok"
	}	
	
	if (`nargs'> 1 & `"`hratio'`lnhratio'`hdifference'`difference'"'!="" ) {
		di as err "{p}only one of experimental-group `argname', " ///
			"`effmsgor' is allowed{p_end}"
		exit 198
	}
	
	if `"`difference'`hdifference'"' != "" {
		if (`"`arg1'"'=="" ) {
			di as err "{p} {bf:hdifference()} and " ///
				"{bf:difference()} require control-group " ///
				"hazard rate or survival probability{p_end}"
			exit 198
		}	
		
		cap numlist `"`difference'`hdifference'"'
		if _rc {
			di as err ///
				"{bf:difference()} and {bf:hdifference()} " ///
				"must contain numbers" 
			exit 198
		}	
		local difflist `r(numlist)'
		local ndiff : list sizeof difflist
		if (`ndiff'==1) {
			cap assert `difference'`hdifference' != 0
			if _rc {
				di as err "{bf:difference()} and " ///
					"{bf:hdifference()} must contain " ///
					"numbers different from 0" 
				exit 198
			}
			if abs( `difference'`hdifference')<=1e-6 {
				di as err "{p}{bf:hdifference()} is too " ///
				"close to 0; abs(hdifference) <= 1.0e-6{p_end}"
				exit 198
			}
		}
		local n_arg1: list sizeof arg1
		
		if (`n_arg1' == 1 & `ndiff' == 1) {
			if ("`time'" == "") local temp_h2 = `arg1' + ///
				`difference'`hdifference' 
			else local temp_h2 = -log(`arg1') + ///
				`difference'`hdifference'
			if (`temp_h2' <= 0) {	 	
				di as err "{p}the resulting " ///
				"experimental-group hazard rate is less " ///
				"than or equal to 0; this is not allowed{p_end}"
				exit 198
			}
		}		
		
	}
	if `"`hratio'"' != "" {
		cap numlist `"`hratio'"', range(>0)
		if _rc {
			di as err "{bf:hratio()} must contain positive numbers" 
			exit 198
		}
		local hrlist `r(numlist)'
		local nhr : list sizeof hrlist
		if (`nhr'==1) {
			cap assert `hratio' != 1
			if _rc {
				di as err "{bf:hratio()} must contain "	///
					"positive numbers different from 1" 
				exit 198
			}
			if reldif(`hratio',1) <= 1e-6 {
				di as err "{bf:hratio()} " ///
				"is too close to 1; reldif(hratio,1) <= 1.0e-6"
				exit 198
			}
		}	

	}
	if `"`lnhratio'"' != "" {
		cap numlist `"`lnhratio'"'
		if _rc {
			di as err "{bf:lnhratio()} must contain numbers" 
			exit 198
		}
		local lnhrlist `r(numlist)'
		local nlnhr : list sizeof lnhrlist
		if (`nlnhr'==1) {
			cap assert `lnhratio' != 0
			if _rc {
				di as err "{bf:lnhratio()} must contain " ///
					"numbers different from 0" 
				exit 198
			}
			if abs(`lnhratio') <= 1e-6 {
				di as err "{p}{bf:lnhratio()} is too close " ///
				"to 0; abs(lnhratio) <= 1.0e-6{p_end}"
				exit 198
			}
		}
	}
	
	if (`"`p1'"' != "") {
		cap numlist `"`p1'"', range(>0 <1)
		if _rc {
			di as err "{bf:p1()} must contain numbers " ///
				"between 0 and 1" 
			exit 198
		}
	}
	
// check options and effect sizes
	// -showevents- not combined with -graph-
	if (`"`graph'`graph1'"' != "" & `"`table'`table1'"' == "" ///
			& `"`show'`show1'"' != "") {
		di as err "{p}{bf:show()} may not be combined with " ///
					"{bf:graph}{p_end}"
		exit 198			
	}			
	// doesn't -show- and -show(event)- at the same time
	// when no losses information, -show(losses)- ignored
	capture chk_show showopt "`show'" `"`show1'"'
	if c(rc) {
		di as err "invalid {bf:show()} option " 
		exit 198	
	}
	if (`"`showopt'"' != "") {
		local 0 , `showopt'
		syntax [, `showopt']
	}
	if (`"`compute'"'!="") {
		di as err "compute() not allowed"
		exit 198
	}
	if (`"`hratio'"'!="") {
		local hropt "hratio"
	}
	else if (`"`lnhratio'"'!="") {
		local hropt "lnhratio"
	}
	else if (`"`difference'`hdifference'"'!="") {
		local hropt "hdifference"
	}	

	// hr:atio, lnhr:atio, diff:erence, hdiff:erence, lnhdiff:erence
	if (`"`effect'"'!="") {
		if strpos("difference", "`effect'")==1 & 		///
				length("`effect'")>=4 {
			local effect difference
		}	
		else if	strpos("hdiffererence", "`effect'")==1 &	///
				length("`effect'")>=5 {
			local effect hdifference
		}
		else if strpos("lnhratio", "`effect'") ==1 & 	///
				length("`effect'")>=4 {
			local effect lnhratio
		}		
		else if strpos("lnhdifference", "`effect'") ==1 &	///
				length("`effect'")>=7 {
			local effect lnhdifference
		}		
		else if strpos("hratio", "`effect'") ==1 & ///
				length("`effect'")>=2 {
			local effect hratio
		}	
		else {
			di as err "{p}invalid {bf:effect()}{p_end}"
			exit 198
		}
		
		if (`"`arg1'"' == "" & ("`effect'" == "difference" ///
					| "`effect'" == "hdifference")) {
			di as err "{p}{bf:effect(difference)} and " ///
				"{bf:effect(hdifference)} are not allowed " ///
				" when no argument is specified {p_end}"
			exit 198	
		}	
	}
	
	if (`"`p1'"' != "" & `"`nratio'"' != "") {
		opts_exclusive "p1() nratio()"
		exit 198
	}	

	if (`"`studytime'"'!="" & `"`aperiod'"'!="" & `"`fperiod'"'!="") {
		di as err "{p}{bf:studytime()} may only be combined"
		di as err "with one of {bf:aperiod()} or {bf:fperiod()}{p_end}"
		exit 198
	}

	/* check input arguments */	
	if "`arg1'" == "" {
		if `"`time'"' != "" {
			di as err "{p}{bf:time()} requires specifying survival "	///
				"probability in the control group{p_end}"
			exit 198
		}
		if `"`aperiod'`fperiod'`studytime'"' != "" {
			di as err  `"{p}`argname' in the control group "' ///
				   "must be specified if {bf:aperiod()}, " ///
				   "{bf:fperiod()}, or {bf:studytime()} " ///
				   "is specified{p_end}"
			exit 198
		}
	}
	
	if "`arg1'" != "" {
		if `"`time'"' == "" { /* assume hazards */
			`note' di as txt ///
				"note: input parameters are hazard rates"
		}
		else { /* assume survival probabilities */
			`note' di as txt "{p 0 6}note: input parameters " ///
					 "are survival probabilities{p_end}"		 
			cap numlist `"`time'"', range(>0)
			if _rc {
				di as err "{bf:time()} must contain " ///
						"positive numbers"
				exit 198
			}
		}
	}
	
	if "`loghazard'"!="" & "`ashape'`aprob'`atime'`aptime'"!="" {
			di as err "{p}{bf:ashape()}, {bf:aprob()}, " ///
				"{bf:atime()}, and {bf:aptime()} may not " ///
				"be combined with {bf:loghazard}{p_end}"
			exit 198
	}
	
	if (`"`ashape'`aprob'`atime'`aptime'"' != "" & `"`aperiod'"' == "" ///
		& ("`studytime'" =="" | ("`studytime'"!="" /// 
		& "`fperiod'" == ""))) {
		di as err "{p}{bf:ashape()}, {bf:aprob()}, " ///
			"{bf:atime()}, and {bf:aptime()} require " ///
			"specifying {bf:aperiod()} or specifying " ///
			"both {bf:studytime()} and {bf:fperiod()}{p_end}"
		exit 198
	}

	/* fperiod(), aperiod() */
	if `"`fperiod'`studytime'`aperiod'"' == "" & ///
	   (`"`losshaz'`losshaz1'`losshaz2'"' != "" | ///
	   `"`lossprob'`lossprob1'`lossprob2'"' != "") {
		di as err "{p}{bf:losshaz()}, {bf:losshaz1()}, " ///
			"{bf:losshaz2()}, {bf:lossprob()}, " ///
			"{bf:lossprob1()}, and {bf:lossprob2()} require " ///
			"specifying {bf:fperiod()}, {bf:aperiod()}, " ///
			"or {bf:studytime()}{p_end}"
		exit 198
	}
	if `"`fperiod'"' != "" {
		cap numlist "`fperiod'", range(>=0)
		if _rc {
			di as err "{bf:fperiod()} must contain " ///
				"nonnegative numbers"
			exit 198
		}
	}
	if `"`aperiod'"' != "" {
		cap numlist "`aperiod'", range(>=0)
		if _rc {
			di as err "{p}{bf:aperiod()} must " ///
				"contain nonnegative numbers{p_end}"
			exit 198
		}	
		if (`"`aprob'`atime'`aptime'`ashape'"' !="") {
		
			cap numlist "`aperiod'", range(>0)
			if _rc {
				di as err "{p}{bf:aprob()}, {bf:aptime()}, " ///
				"{bf:atime()}, and {bf:ashape()} may not be" ///
				" specified when {bf:aperiod()} " ///
				"contains 0{p_end}"
				exit 198
			}	
		}		
	}
	
	if `"`studytime'"' != "" {
		cap numlist "`studytime'", range(>=0)
		if _rc {
			di as err "{p}{bf:studytime()} must " ///
				"contain nonnegative numbers{p_end}"
			exit 198
		}
	}
	if `"`atime'"' != "" {
		cap numlist "`atime'", range(>0)
		if _rc {
			di as err "{p}{bf:atime()} must " ///
				"contain positive numbers{p_end}"
			exit 198
		}
	}
	if `"`aprob'"' != "" {
		cap numlist "`aprob'", range(>0 <1)
		if _rc {
			di as err "{p}{bf:aprob()} must " ///
				"contain numbers " ///
			 "greater than 0 and less than 1{p_end}"
			exit 198
		}
	}
	if `"`aptime'"' != "" {
		cap numlist "`aptime'", range(>0 <1)
		if _rc {
			di as err "{p}{bf:aptime()} must " ///
				"contain numbers " ///
			 "greater than 0 and less than 1{p_end}"
			exit 198
		}
	}
	if `"`losstime'"' != "" {
		cap numlist "`losstime'", range(>0)
		if _rc {
			di as err "{p}{bf:losstime()} must " ///
				"contain positive numbers{p_end}"
			exit 198
		}
	}
	
	if `"`ashape'"' != "" {
		cap numlist "`ashape'"
		if _rc {
			di as err "{bf:ashape()} must be numeric"
			exit 198
		}
	}
	/* aprob(), aptime() and atime() */
	local recruit `aprob' `atime' `aptime'
	if ("`aperiod'" != "" | ("`studytime'"!="" & "`fperiod'"!="")) {	
		if (`"`ashape'"' != "" &  `"`recruit'"' != "") {
			di as err "{p}{bf:ashape()} may not be " ///
				"combined with {bf:aprob()}, " ///
				"{bf:atime()} or {bf:aptime()}{p_end}"
			exit 198
		}
		else if (`"`aptime'"' != ""  & `"`atime'"' != "") {
			di as err "{p}{bf:aptime()} and " ///
				"{bf:atime()} may not be " ///
					"combined{p_end}"
			exit 198
		}
	}
	/* losshaz(), lossprob(), and losstime() */
	if ("`lossprob'" !="" & "`lossprob1'`lossprob2'" !="") {
		di as err "{p}{bf:lossprob1()} and {bf:lossprob2()} " ///
			"may not be combined with {bf:lossprob()} {p_end}"
			exit 198	
	}		

	if ("`losshaz'" !="" & "`losshaz1'`losshaz2'" !="") {
		di as err "{p}{bf:losshaz1()} and {bf:losshaz2()} " ///
			"may not be combined with {bf:losshaz()} {p_end}"
			exit 198		
	}	
	
	if `"`losstime'"' != "" {
		if (`"`lossprob'`lossprob1'`lossprob2'"' == "") {
			di as err "{p}{bf:losstime()} requires specifying " ///
				"{bf:lossprob1()}, {bf:lossprob2()}, " ///
				"or {bf:lossprob()}{p_end}"
			exit 198
		}
		cap numlist `"`losstime'"', range(>=0)
		if _rc {
			di as err "{p}{bf:losstime()} must contain " ///
				"positive numbers {p_end}"
			exit 198
		}	
	
	}
	if (`"`lossprob'`lossprob1'`lossprob2'`losstime'"' != "") {
		local is_losst=1
	}	
	if `"`losshaz'"' != "" {
		cap numlist `"`losshaz'"', range(>=0) 
		if _rc {
			di as err "{bf:losshaz()} must contain " ///
				  "nonnegative numbers"
			exit 198
		}
		local is_lossh1 = 0
		local is_losst = 0
	}
	if `"`losshaz1'"' != "" {
		cap numlist `"`losshaz1'"', range(>=0) 
		if _rc {
			di as err "{bf:losshaz1()} must contain " ///
				  "nonnegative numbers"
			exit 198
		}
		local is_lossh1 = 1
		local is_losst = 0
	}
	if `"`losshaz2'"' != "" {
		cap numlist `"`losshaz2'"', range(>=0)
		if _rc {
			di as err "{bf:losshaz2()} must contain " ///
				  "nonnegative numbers"
			exit 198
		}
		local is_lossh1 = 1
		local is_losst = 0
	}
		
	if `"`lossprob'"' != "" {
		
		cap numlist `"`lossprob'"', range(>=0 <1) 
		if _rc {	
			di as err "{bf:lossprob()} must contain " ///
				  "numbers between 0 and 1"
			exit 198
		}
		local is_lossp1 = 0
	}	
	if `"`lossprob1'"' != "" {
		cap numlist `"`lossprob1'"', range(>=0 <1) 
		if _rc {
			di as err "{bf:lossprob1()} must contain " ///
				  "numbers between 0 and 1"
			exit 198
		}
		local is_lossp1 = 1
	}
	if `"`lossprob2'"' != "" {
		cap numlist `"`lossprob2'"', range(>=0 <1)
		if _rc {
			di as err "{bf:lossprob2()} must contain " ///
				  "numbers between 0 and 1"
			exit 198
		}
		local is_lossp1 = 1
	}
	if `"`lossprob'`lossprob1'`lossprob2'"' != "" & ///
		`"`losshaz'`losshaz1'`losshaz2'"'  != "" {
		di as err "{p}{bf:losshaz1()}, {bf:losshaz2()}, or " ///
			"{bf:losshaz()}  and  {bf:lossprob1()}, " ///
			"{bf:lossprob2()}, or {bf:lossprob()} " ///
				"may not be combined{p_end}"
		exit 198
	}
		
	if "`is_losst'" == "" local is_losst .
	if "`is_lossp1'" == "" local is_lossp1 .
	if "`is_lossh1'" == "" local is_lossh1 .
		
	   					
	mata: `pssobj'.initonparse("`effect'",		///
				"`loghazard'",		///
				"`unconditional'",	///
				  "`hropt'",		///
				   ("`arg1'"!=""),	///
				   ("`arg2'"!=""),	///
				   ("`time'"!=""),	///
				   ("`p1'"!=""),	///
				   ("`showevents'"!=""), ///
				   ("`showlosses'"!=""), ///
				   ("`showeventprobs'"!=""), ///
				   ("`aperiod'"!=""), ///
				   ("`fperiod'"!=""), ///
				   ("`studytime'"!=""), ///
				   ("`recruit'`ashape'"==""), ///
				   `is_losst',		///
				   `is_lossp1',		///
				   `is_lossh1')
end

program chk_show 
	version 14
	args showopt show show1	
	if ("`show'" != "") {
		local showopt_list showevents showlosses
	}
	if (`"`show1'"' != "") {
		foreach opt in `show1' {
			local showopt_list `showopt_list' show`opt'
		}
	}
	local 0 ,`showopt_list'
	syntax, [showevents SHOWEVENTPRobs showlosses showall]
	if ("`showall'" != "") {
		local showopt_list showevents showeventprobs showlosses
	}
	else local showopt_list `showevents' `showeventprobs' `showlosses'
	c_local `showopt' "`showopt_list'"
end	
