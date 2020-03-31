*! version 1.0.0  03dec2014
program power_cmd_cox_parse
	version 14

	syntax [anything] [, test * ]
	local type `test'
	if ("`test'"=="") {
		di as err "invalid syntax"
		exit 198
	}	
	_power_cox_`type'_parse `anything', `options'

end

program _power_cox_test_parse

	syntax [anything(name=args)], pssobj(string) [ * ]
	
	local 0 , `options'

	mata: `pssobj'.getsolvefor("solvefor")
	_pss_syntax SYNOPTS : onetest
	syntax [, 	`SYNOPTS'		///
			HRatio(string)         ///
			sd(string)		///
			r2(string)		///
			FAILProb(string) 	///
			EVENTPRob(string) 	///
			WDProb(string) 		///
			effect(string)		///
		]	
	
	if ("`failprob'" != "" &  "`eventprob'" != "") {
		di as err "{p}only one of {bf:failprob()} " ///
			"or {bf:eventprob()} is allowed{p_end}"
		exit 198
	}	
	gettoken arg1 args : args, match(par)
	if (`"`arg1'"' != "" & `"`hratio'"' != "") {
		di as err "{p}only one of coefficient or {bf:hratio()} " ///
			"is allowed{p_end}"
		exit 198
	}	
	
	local nargs 0

	if `"`arg1'"'!="" {
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}
	
	// check arguments and hratio()
	if (`"`hratio'"'!="" & "`solvefor'"=="esize") {
		di as err "{p}option {bf:hratio()} "	///
			"is not allowed with "	///
			"effect-size determination{p_end}"
		exit 184
	}
	if (`"`hratio'"'=="") {
		_pss_error argsonealttest "`nargs'" "`solvefor'"  ///
				       "cox" "coefficient" "optargsok"
		if (`nargs' > 0 & `"`arg1'"'!="") {
			cap numlist "`arg1'"
			if c(rc) {
				di as err "coefficients must be numeric "
				exit 198
			}
			local a2list `r(numlist)'
			local ka2 : list sizeof a2list
			if `ka2'==1 {
				if `a2list' == 0 {
					di as err "{p}alternative " ///
					 "coefficient is zero; this is not " ///
					 "allowed{p_end}"
					exit 198
				}
				cap assert abs(`a2list') > 1.0e-6 
				if _rc {
					di as err "alternative coefficient " ///
						"is too small " ///
						"(abs(b1) <= 1.0e-6) "
					exit 198
				}	
			}
		}
	}
        else {
		if (`nargs'> 0) {
			di as err "{p}only one of "     ///
			  	  "alternative coefficient or " ///
				  "{bf:hratio()} is allowed {p_end}"
			exit 198
		}
		cap numlist `"`hratio'"', range(>0)
		if (_rc) {
			di as err "{bf:hratio()} must contain positive numbers"
			exit 198
		}
		local dlist `r(numlist)'
		local kd : list sizeof dlist
		if `kd' == 1 {
			if `dlist' == 1 {
				di as err "{p}{bf:hratio()} must contain " ///
				   "positive numbers different from 1{p_end}" 
				exit 198
			}
			cap assert reldif(`dlist',1) > 1.0e-6 
			if _rc {
				di as err "{p}{bf:hratio()} " ///
					"is too close to 1; " ///
					"reldif(hratio,1) <= 1.0e-6{p_end}"
				exit 198
			}	
		}
	}
	
	// sd() range
	if (`"`sd'"'!="") {
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "{bf:sd()} must contain positive numbers"
			exit 198
		}
	}

	// r2() range
	if  (`"`r2'"'!="") {
		cap numlist `"`r2'"', range(>=0 <1)
		if _rc {
			di as err "{bf:r2()} must be in [0,1)"
			exit 198
		}
	}
	// failprob() range 
	if  (`"`failprob'`eventprob'"'!="") {
		cap numlist `"`failprob'`eventprob'"', range(>0 <=1)
		if _rc {
			if (`"`failprob'"'!="") {
				di as err "{bf:failprob()} must be in (0,1]"
			}
			else di as err "{bf:eventprob()} must be in (0,1]"	
			exit 198
		}
	}	
	
	if `"`wdprob'"' != "" {
		if ("`solvefor'"!="n") {
			di as err "{bf:wdprob()} is allowed only with " ///
				"sample-size computation"
			exit 198
		}
		cap numlist `"`wdprob'"', range(>=0 <1)
		if _rc {
			di as err "{bf:wdprob()} must be in [0,1)"
			exit 198
		}
	}
	
	if (`"`effect'"'!="") {
		
		if regexm("hratio", "`effect'") == 1 & 		///
				length("`effect'")>=2 {
			local effect hratio
		}
		else if strpos("lnhratio", "`effect'") ==1 &	///
				length("`effect'")>=4 {
			local effect lnhratio
		}	
		else if strpos("coefficient", "`effect'") ==1 &	///
				length("`effect'")>=4 {
			local effect coefficient
		}
		else {
			di as err "{p}invalid {bf:effect()}{p_end}"
			exit 198
		}		
	}	

	mata: `pssobj'.initonparse("`effect'",		///
				   ("`arg1'"!=""), 	///
				    ("`r2'"!=""), 	///
				   ("`failprob'`eventprob'"!=""), ///
				   ("`wdprob'"!=""))
end
