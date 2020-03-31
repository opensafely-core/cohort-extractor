*! version 1.0.1  10mar2017
program power_cmd_rsquared_parse
	version 15

	syntax [anything] [, test  NControl(string) * ]
	local type `test'
	if ("`ncontrol'"=="") {
		_power_regrsqall_`test'_parse `anything', `options' 
	}
	else {
		_power_regrsqsub_`test'_parse `anything', ///
		`options'  ncontrol(`ncontrol')
	}
	
end

program _power_regrsqsub_test_parse

	syntax [anything(name=args)], pssobj(string) [ * ]

        local 0 , `options'
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
		_pss_error iteroptsnotallowed ,		///
			   `options' txt(when computing `msg')	
	}

	_pss_syntax SYNOPTS : onetest
	syntax [,       `SYNOPTS'               ///
                        diff(string)         ///
                        NTESTed(string)         ///
                        NControl(string)        ///
                        `star'                  ///
                ]	
	if ("`onesided'"!="") {
		di as err "{p}option {bf:onesided} not allowed{p_end}"
		exit 198
	}
	if (`"`direction'"' != "") {
                di as err "{p}option {bf:direction()} not allowed{p_end}"
                exit 198
        }
	if (`isiteropts') {
		if "`solvefor'" == "n" {
			local validate `solvefor'
		}
		else if "`solvefor'" == "esize" {
			local validate r2
		}
		_pss_chk_iteropts `validate', `options' init(`init')	///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	


	local nargs 0
	if `"`arg1'"'!="" {
		cap numlist "`arg1'", range(>=0 <1)
		if (_rc) {
			di as err "{p}R-squared for " ///
			      "the reduced model must be between 0 and 1{p_end}"	
			exit 198
		}
		local r1 `r(numlist)'
		local k1 : list sizeof r1
		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist "`arg2'", range(>=0 <1)
		if (_rc) {
			di as err "{p}"	///
	  			"R-squared for the full model " ///
                                "must be between 0 and 1{p_end}"
			exit 198
		}
		local ++nargs
		local r2 `r(numlist)'
		local k2 : list sizeof r2
		if (`k1'==1 & `k2'==1) {
			if (`r1'>`r2') {
				 di as err "{p}" ///
                                        "R-squared of the full model is " ///
                                        "less than of the reduced model; "  ///
                                        "this is not allowed{p_end}"
			exit 198
			}
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	if (`"`diff'"'=="") {
		_pss_error argsonetest  "`nargs'" "`solvefor'"  ///
					"regrsquared" "R-squared"
		if "`init'"!="" & "`solvefor'"=="esize" {							
			if (`k1'==1) {
				if(`init'+`arg1'>=1) {
					di as err "{p}invalid option "	///
					"{bf:init(`init')}; initial value " ///
					"plus R-squared of the reduced " ///
					"model should be less than 1{p_end}"
					exit 198
				}	
			}
		}
	}

	else {
		if(`nargs' ==0 ) {
			di as err "{p}R-squared of the reduced model " ///
				"must be specified with option " ///
				"{bf:diff()}{p_end}" 
			exit 198
		}
		else if (`nargs'> 2) {
			_pss_error argsonetest "`nargs'" "`solvefor'"   ///
					       "regrsquared" "R-squared"
		}
		else if (`nargs'> 1) {
			di as err "{p}only one " ///
				"of R-squared of the full model or " ///
				"option {bf:diff()} is allowed{p_end}"
			exit 198
		}
	
		cap numlist `"`diff'"', range(>0 <1)
		if (_rc) {
			di as err "{p}option"		 ///
				"{bf:diff()} must contain values " ///
				"between 0 and 1{p_end}"
			exit 198
		}
		local r3 `r(numlist)'
		local k3 : list sizeof r3 

		if (`k1'==1 & `k3'==1) {
			if (`r3'+`r1'>=1) {
				di as err "{p}"	///
					"R-squared of the reduced model " ///
					"plus R-squared difference " ///
					"must be less than 1{p_end}"
				exit 198
			}
		}
	}


	// ntested, ncontrol, pcorr
	if (`"`ntested'"'!="") {
		cap numlist "`ntested'", range(>0) integer
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:ntested()} must contain positive "	///
				" integers{p_end}"
			exit 198
		}
		local nt `r(numlist)'
		local nt_ct : list sizeof nt
	}
	else {
		local nt 1
		local nt_ct 1
	}	
	if (`"`ncontrol'"'!="") {	
		cap numlist "`ncontrol'", range(>0) integer
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:ncontrol()} must contain positive " ///
				"integers{p_end}"
			exit 198
		}
		local nc `r(numlist)'
		local nc_ct : list sizeof nc
	}
	else {
		local nc_ct 1
		local nc 1
	}		

	if ("`init'"!="" & "`solvefor'"=="n" & `nc_ct'==1 & `nt_ct'==1) {
			if (`init' <= `nc' + `nt' + 1 ) {
			di as err "{p}invalid "	///
				"{bf:init(`init')}; initial sampe size " ///
				"too small{p_end}"
				exit 198
		}
	}	
	
	local is_case1  0		
	mata: `pssobj'.initonparse(`is_case1', "`diff'", "`pcorr'")

end


program _power_regrsqall_test_parse

	syntax [anything(name=args)], pssobj(string) [ * ]

        local 0 , `options'
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
		_pss_error iteroptsnotallowed ,		///
			   `options' txt(when computing `msg')	
	}

	_pss_syntax SYNOPTS : onetest
	syntax [,       `SYNOPTS'               ///
                        NTESTed(string)         ///
			diff(string)		///
                        `star'                  ///
                ]
	if (`"`diff'"'!="") {
		di as err "{p}option {bf:diff()} not allowed for " ///
		"testing all coefficients; to test a subset of coefficient," ///
		" specify option {bf:ncontrol()}{p_end}"
		exit 198
	}		
	if ("`onesided'"!="") {
		di as err "{p}option {bf:onesided} not allowed{p_end}"
		exit 198
	}
	if (`"`direction'"' != "") {
                di as err "{p}option {bf:direction()} not allowed{p_end}"
                exit 198
        }
	if (`isiteropts') {
		if "`solvefor'" == "n" {
			local validate `solvefor'
		}
		else if "`solvefor'" == "esize" {
			local validate r2
		}
		_pss_chk_iteropts `validate', `options' init(`init')	///
			pssobj(`pssobj')	
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)

	local nargs 0

	if `"`arg1'"'!="" {
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	_pss_error argsonealttest "`nargs'" "`solvefor'"  ///
				     "regrsqall" "R-squared of the tested model"

	if `"`arg1'"'!="" {
		cap numlist "`arg1'", range(>0 <1)
		if (_rc) {
			di as err "{p}R-squared of " ///
			      "the tested model must be between 0 and 1{p_end}"	
			exit 198
		}
	}

	// ntested
	if (`"`ntested'"'!="") {
		cap numlist "`ntested'", range(>0) integer
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:ntested()} must contain positive "	///
				" integers{p_end}"
			exit 198
		}
		local nt `r(numlist)'
		local nt_ct : list sizeof nt
	}
	else {
		local nt 1
		local nt_ct 1
	}			

	if ("`init'"!="" & "`solvefor'"=="n" & `nt_ct'==1) {
			if (`init' <=  `nt' + 1 ) {
			di as err "{p}invalid option "	///
				"{bf:init(`init')}; initial sampe size " ///
				"is too small{p_end}"
				exit 198
		}
	}			
		
	local is_case1 1		
	mata: `pssobj'.initonparse(`is_case1', "`diff'", "`pcorr'")

end
