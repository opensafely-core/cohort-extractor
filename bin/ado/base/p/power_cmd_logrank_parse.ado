*! version 1.0.0  13jan2017
program power_cmd_logrank_parse
	version 14

	syntax [anything] [, test * ]
	local type `test'
	if ("`test'"=="") {
		di as err "invalid syntax"
		exit 198
	}	
	_power_logrank_`type'_parse `anything', `options'

end

program _power_logrank_test_parse

	
	syntax [anything(name=args)] , pssobj(string) [ * ]
	gettoken s1 args : args, match(par)
	gettoken s2 args : args, match(par)
	
	local 0 , `options' 
	
	mata: `pssobj'.getsolvefor("solvefor")
	
	//check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="esize") {
		if (`"`s1'"'!="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "effect size in the absence of censoring"	
		}
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	else if ("`solvefor'"=="n") {
		local msg "sample size"
	}
	else if ("`solvefor'"=="m") {
		local msg "cluster sizes"
	}
	else if ("`solvefor'"=="k") {
		local msg "numbers of clusters"
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}
	
	local clu_opt cluster k1(string)  k2(string) KRATio(string) ///
		m1(string) m2(string) MRATio(string) ///
		rho(string) CVCLuster(string)
	//parse options to check
	_pss_syntax SYNOPTS : twotest  
	syntax [, 		`SYNOPTS' 	///
				HRatio(string)	///
				LNHRatio(string) ///
				SCHoenfeld 	///
				WDProb(string) 	///
				effect(string)	///
				SIMPson(string)	///
			     	st1(varlist numeric min=2 max=2) ///
				p1(string)	///	//undocumented
				`clu_opt'	///
				`star'		///	//iteropts
		]
		
	local is_cls 0
	local crd cluster randomized design
	if ("`cluster'"!="" | `"`k1'`k2'`m1'`m2'"' !="") local is_cls  1
		
	// options not allowed for crd
	if (`is_cls') {
		foreach x in simpson st1 wdprob {
		if (`"``x''"'!="") {
			di as err "{p}{bf:power logrank}: " ///
			"option {bf:`x'()} is not allowed for `crd'{p_end}"
			exit 198
		}
		}	
		if (`"`schoenfeld'"'!="") {
			di as err "{p}{bf:power logrank}: " ///
		"option {bf:schoenfeld()} is not allowed for `crd'{p_end}"
			exit 198
		}	
	}

	if (`isiteropts') {
		if ("`init'" != "") {
			if ("`schoenfeld'" == "") {
				cap assert `init' > 0
				if (_rc) {
			di as err "invalid option {bf:init()}: " ///
					"expected a positive number"
					exit 198
				}
			}
			else {	
				cap confirm number `init'  
				if (_rc) {
			di as err "invalid option {bf:init()}: " ///
					"expected a number"
					exit 198
				}	
			}	
		}
		_pss_chk_iteropts, `options' init(`init') pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}
	
	if (`"`compute'"'!="") {
		di as err "option {bf:compute()} not allowed"
		exit 198
	}
	if (`"`effect'"'!="") {
		if strpos("hratio", "`effect'") ==1 &	 	///
				length("`effect'")>=2 {
			local effect hratio
		}
		else if strpos("lnhratio", "`effect'")==1 & 	///
				length("`effect'")>=4 {
			local effect lnhratio
		}	
		else {
			di as err "{p}invalid option {bf:effect()}{p_end}"
			exit 198
		}		
	}		
	
	if (`"`hratio'"'!="" & `"`lnhratio'"'!="") {
		opts_exclusive "hratio() lnhratio()"
		exit 198
	}		
	if (`"`hratio'"'!="") {
		local hropt "hratio"
	}
	else if (`"`lnhratio'"'!="") {
		local hropt "lnhratio"
	}

	local nargs 0
	if `"`s1'"'!="" {
		cap numlist `"`s1'"', range(>0 <1)
		if (_rc) {
			di as err "survival probabilities must be " ///
				"numbers between 0 and 1"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list

		local ++nargs
	}
	if `"`s2'"'!="" {
		cap numlist `"`s2'"', range(>0 <1)
		if (_rc) {
			di as err "survival probabilities must be " ///
				"numbers between 0 and 1"
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list

		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if (`s1' == `s2' ) {
				di as err "{p}survival probabilities in " ///
				"the control and the experimental groups " ///
				"must be different{p_end}"
				exit 198
			}	
			if reldif(`s1',`s2')<=1e-6 {
				di as err "{p}survival probabilities in " ///
				"the control and the experimental groups " ///
				"are too close; reldif(s1, s2) <= 1.0e-6{p_end}"
				exit 198
			} 
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and hratio/lnhratio
	if (`nargs'>=2) {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
				"logrank" "survival probability" "optargsok"
	}				
	
	if ("`hratio'`lnhratio'"!="") {
		if ("`solvefor'"=="esize") {
			di as err "option {bf:hratio()} or {bf:lnhratio()} " ///
				"is not allowed with effect-size determination"
			exit 184
		}	
	        if (`nargs'> 1) {
			di as err "{p}only one of experimental-group " ///
			"survival probability, option {bf:hratio()}, or " ///
				"option {bf:lnhratio()} is allowed {p_end}"
			exit 198
		}	
	}
	if (`"`hratio'"'!= "") {
		cap numlist `"`hratio'"', range(>0)
		if (_rc) {
			di as err "{bf:hratio()} must contain positive numbers"
			exit 198
		}
		local mlist `r(numlist)'
		local k : list sizeof mlist
		if `k' == 1 {
			if (`mlist'==1) {
				di as err "{p}{bf:hratio()} must contain " ///
				"positive numbers different from 1{p_end}"
				exit 198
			}
			if reldif(`mlist',1) <= 1e-6 {
				di as err "{bf:hratio()} " ///
				"is too close to 1; reldif(hratio,1) <= 1.0e-6"
				exit 198
			}
		}	

	}	
	if (`"`lnhratio'"'!= "") {
		cap numlist `"`lnhratio'"'
		if (_rc) {
			di as err "{bf:lnhratio()} must contain numbers"
			exit 198
		}
		local mlist `r(numlist)'
		local k : list sizeof mlist
		if `k' == 1 {
			if `mlist' == 0 {
				di as err "{p}{bf:lnhratio()} must contain " ///
				"numbers different from 0{p_end}"
				exit 198
			}	
			if abs(`mlist') <= 1e-6 {
				di as err "{p}{bf:lnhratio()} is too close " ///
				"to 0; abs(lnhratio) <= 1.0e-6{p_end}"
				exit 198
			}
		}
	}
	
	if (`"`p1'"' != "" & `"`nratio'"'!= "") {
		opts_exclusive "p1() nratio()"
		exit 198
		cap numlist `"`p1'"', range(>0 <1)
		if _rc {
			di as err "{bf:p1()} must contain numbers " ///
				"between 0 and 1" 
			exit 198
		}
	}
	if `"`wdprob'"' != "" {
		if ("`solvefor'"!="n") {
			di as err ///
			"option {bf:wdprob()} is allowed only with " ///
				"sample-size computation"
			exit 198
		}
		cap numlist `"`wdprob'"', range(>=0 <1)
		if _rc {
			di as err "{bf:wdprob()} must be in [0,1)"
			exit 198
		}
	}
	
	//check equivalent ways of specifying censoring information
	if ("`s1'"!="" & `"`simpson'`st1'"'!="") {
		di as err "{p}survival probabilities may not be " ///
                          "specified in combination with "		  ///
			  "option {bf:simpson()} or {bf:st1()}{p_end}"
		exit 198
	}
	/* simpson() */
	if `"`simpson'"' != "" {
		if `"`st1'"' != "" {
			di as err 	///
	"options {bf:st1()} and {bf:simpson()} may not be combined"
			exit 198
		}
		if `"`solvefor'"' == "esize" {
			di as err ///
			"option {bf:simpson()} is not allowed with " ///
				  "effect-size computation"
			exit 198
		}
		cap confirm matrix `simpson'
		if _rc {
			local k: word count `simpson'
			if `k' != 3 {
di as err "{p}{bf:simpson()}: matrix name or numlist with three numbers " ///
	  "between 0 and 1 is required{p_end}" 
exit 198
			}
			tokenize `"`simpson'"'
			forvalues i = 1/3 {
				cap confirm number ``i''
				if _rc {
di as err ///
"{p}option {bf:simpson()}: matrix name or numlist with three numbers " ///
	  "between 0 and 1 is required{p_end}" 
exit 198
				}
				cap assert ``i''>0 & ``i''<=1
				if _rc {
di as err ///
 "{p}option {bf:simpson()}: matrix name or numlist with three numbers " /// 
	  "between 0 and 1 is required{p_end}" 
exit 198
				}
			}	
			tempname simmat
			mat `simmat' = (`1', `2', `3')
		}
		else {
			tempname simmat
			if rowsof(`simpson') == 3 {
				mat `simmat' = `simpson''
			}
			else {
				mat `simmat' = `simpson'
			}
		}
		forvalues i = 1/3 {
			cap assert `simmat'[1,`i']>0 & `simmat'[1,`i']<=1
			if _rc {
				di as err "option {bf:simpson()}: " 	///
					  `"matrix {bf:`simpson'} "'	///
					  "must contain values between 0 and 1"
				exit 198
			}
		}
		cap assert `simmat'[1,1] >= `simmat'[1,2] & ///
			   `simmat'[1,2] >= `simmat'[1,3]
		if _rc {
			di as err ///
			"{p}option {bf:simpson()}: values of the survivor " ///
				 "function should not increase with time{p_end}"
			exit 198
		}
	}
	/* st1() */
	if `"`st1'"' != "" {
		if `"`solvefor'"' == "esize" {
			di as err "option {bf:st1()} is not allowed with " ///
				  "effect-size computation"
			exit 198
		}
		tokenize `"`st1'"'
		local tvar `2'
		local surv1 `1'
		cap confirm numeric variable `tvar'
		if _rc {
			di as err ///
		`"option {bf:st1()}: time variable {bf:`tvar'} must "'	///
				   "contain nonnegative values"
			exit 198
		}
		cap confirm numeric variable `surv1'
		if _rc {
			di as err ///
		`"option {bf:st1()}: survival variable {bf:`surv1'} "'	///
				  "must contain values between 0 and 1"
			exit 198
		}
		qui summ `tvar', meanonly
		cap assert r(min)>=0
		if _rc {
			di as err ///
			`"option {bf:st1()}: time variable {bf:`tvar'} "' ///
				   "must contain nonnegative values"
			exit 198
		}
		cap assert r(max)-r(min) > 0
		if _rc {
			di as err ///
			"option {bf:st1()}: length of the accrual " ///
				  "period must be greater than 0;"
			di as err `"check values of time variable {bf:`tvar'}"'
			exit 198
		}
		cap assert `surv1'>0 & `surv1'<=1 if `surv1'<.
		if _rc {
			di as err ///
		"option {bf:st1()}: survival variable {bf:`surv1'} " ///
		"must contain values between 0 and 1"
			exit 198
		}
		/* survival function must be decreasing */
		qui query sortseed
		local sortseed = r(sortseed)
		tempvar id
		qui gen byte `id' = _n
		qui sort `tvar' `surv1', stable
		cap assert `surv1'[_n]<=`surv1'[_n-1] if _n>1 & `surv1'<.
		qui sort `id'
		set sortseed `sortseed'
		if _rc {
			di as err ///
			"option {bf:st1()}: values of the survivor "	///
				  "function should not increase with time"
			exit 198
		}
	}
	//initialize settings constant in all scenarios
	mata: `pssobj'.initonparse("`effect'",		///
				   "`schoenfeld'",	///
				   "`simmat'",		///
				   "`st1'",		///
				   "`hropt'",		///
				   ("`s1'"!=""), 	///
				   ("`p1'"!=""),	///
				   ("`wdprob'"!=""))

end
