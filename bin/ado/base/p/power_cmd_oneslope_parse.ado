*! version 1.0.0  10dec2016
program power_cmd_oneslope_parse
	version 15

	syntax [anything] [, test * ]
	local type `test'
	_power_oneslope_`test'_parse `anything', `options'

end

program _power_oneslope_test_parse
	syntax [anything(name=args)] , pssobj(string) [ONESIDed 	///
					sdx(string) SDERRor(string)	///
    					sdy(string) corr(string) * ]
	local 0, `options' `onesided' sdx(`sdx') sderror(`sderror') 	///
					sdy(`sdy') corr(`corr')
	mata: st_local("solvefor", `pssobj'.solvefor)

	// check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n" | "`solvefor'"=="esize") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}

	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , 			///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : onetest
	syntax [,       `SYNOPTS'               ///
			diff(string)            ///
			sdx(string)             ///
                        SDERRor(string)    	///
			sdy(string)             ///
    			corr(string)		///
                        `star'                  /// //iteropts when allowed
		]

	if (`isiteropts') {
	    	if "`solvefor'" == "n" {
			local validate `solvefor'
		}
		_pss_chk_iteropts `validate', `options' init(`init') 	///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		local ++nargs
	}
	if `"`arg2'"'!="" {
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}
		
	if `nargs' > 0 {
		cap numlist "`arg1'"
		if c(rc) {
			di as err "{p}" ///
				"null slopes must be real "	///
				"values{p_end}"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
	}
			
	if (`"`diff'"'=="") {
		_pss_error argsonetest  "`nargs'" "`solvefor'" 	///
					"oneslope" "slope"

        	if `nargs' > 0 {

			if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
				_pss_chk_init "null slope" "`init'" ///
					    "`a1list'" "`direction'"
			}
		 	if ("`solvefor'"=="esize" & `ka1'==1) {
                               if (`arg1'==0 & `"`corr'"'!="") {
                                       di as err "{p}" ///
                                       "effect-size computation is not " ///
                                       "available for zero null slope " ///
                                       "when {bf:corr()} is " ///
                                       "specified{p_end}"
                                       exit 198
                               }
                       }
		}
		if `nargs' > 1 {
			cap numlist "`arg2'"
			if c(rc) {
				di as err "{p}"	///
					"alternative slopes must "	///
					"be real values{p_end}"
				exit 198
			}
			local a2list `r(numlist)'
			local ka2 : list sizeof a2list
			if `ka1'==1 & `ka2'==1 {
				if `a1list' == `a2list' {
					di as err "{p}null and "	///
					"alternative slopes are equal; " /// 
					"this is not allowed{p_end}"
					 exit 198
				}
			}
			if (`ka2'==1 & `"`corr'"'!="") {
				if (`arg2'==0) {
					di as err "{p}{bf:corr()} is not " ///
				"allowed with zero alternative slope{p_end}"
					exit 198
				}
			}	
		}
	}
	else {
		if (`nargs'> 2) {
			_pss_error argsonetest "`nargs'" "`solvefor'"  	///
					       "oneslope" "slope"
		}
		else if ("`solvefor'"=="esize") {
			di as err "{p}{bf:power oneslope}: option "	///
				"{bf:diff()} is not allowed when "    ///
				"computing effect size{p_end}"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}{bf:power oneslope}: only one " ///
				"of alternative slope or option "	///
				"{bf:diff()} is allowed{p_end}"
			exit 198
		}
		cap numlist `"`diff'"'
		if (_rc) {
			di as err "{p}option {bf:diff()} " ///
				"must contain numbers{p_end}"
			exit 198
		}
		local dlist `r(numlist)'
		local kd : list sizeof dlist
		if `kd' == 1 {
			if `dlist' == 0 {
				di as err "{p}"	///
			"invalid option {bf:diff(`dlist')}; zero is "	///
			"not allowed{p_end}"
				 exit 198
			 }
			if (`"`arg1'"'!="" & `"`corr'"'!="") { 
				if (`ka1'==1 & `arg1'+`diff'==0) {
					di as err "{p}{bf:corr()} is not " ///
                                "allowed with zero alternative slope{p_end}"
                                	exit 198
				}
                        }
		}
	}

	// sdx(), sderr(), sdy(), corr()
	if (`"`sderror'"'!="" & `"`sdy'"'!="") {
		di as err "{p}{bf:power oneslope}: only one of "	///
			"options {bf:sderror()} or {bf:sdy()} is allowed{p_end}"
		exit 198
	}
	else if (`"`sderror'"'!="" & `"`corr'"'!="") {
		di as err "{p}{bf:power oneslope}: only one of " ///
			"options {bf:sderror()} or {bf:corr()} is "	///
			"allowed{p_end}"
		exit 198
	}
	else if (`"`sdy'"'!="" & `"`corr'"'!="") {
		di as err "{p}{bf:power oneslope}: only one of "	///
			"options {bf:sdy()} or {bf:corr()} is allowed{p_end}"
		exit 198
	}

	if (`"`sdx'"'!="") {
	    	cap numlist `"`sdx'"', range(>0)
		if (_rc) {
		    	di as err "{p}option {bf:sdx()} " ///
			   	  "must contain positive numbers{p_end}"
			exit 198
		}
	}
	if (`"`sderror'"'!="") {
	    	cap numlist `"`sderror'"', range(>0)
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:sderror()} must contain positive "	///
				"numbers{p_end}"
			exit 198
		}
	}
	if (`"`sdy'"'!="") {
	    	cap numlist `"`sdy'"', range(>0)
		if (_rc) {
		    	di as err "{p}option {bf:sdy()} " ///
				"must contain positive numbers{p_end}"
			exit 198
		}
	}
	if (`"`corr'"'!="") {
	    	cap numlist `"`corr'"', range(>-1 <1)
		if (_rc) {
		    	di as err "{p}option {bf:corr()} " ///
				" must be between -1 and 1{p_end}"
			exit 198
		}
	}
	
	mata: `pssobj'.initonparse("`diff'","`sdy'","`corr'")
end
