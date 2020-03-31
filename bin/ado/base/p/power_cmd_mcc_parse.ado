*! version 1.0.0  11dec2014

program define power_cmd_mcc_parse
	version 14.0
	syntax [anything], [ test * ]

	_power_mcc_test_parse `anything', `options'
	
end

program define _power_mcc_test_parse, sclass
	syntax [anything(name=args)], pssobj(string) [ * ]
	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)
	//to check if iteration options are allowed
	if "`solvefor'"=="n" | "`solvefor'"=="esize" {
		local isiteropts 1
		local star *
	}
	else {
		local isiteropts 0
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing power)
	}

	_pss_syntax SYNOPTS : onetest
	syntax, [ `SYNOPTS' m(numlist)	corr(numlist) ORatio(numlist) ///
				`star' compare ]

	if `isiteropts' {
		if ("`solvefor'"=="esize") local validate OR

                _pss_chk_iteropts `validate', `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
		if "`solvefor'"=="n" & "`options'"!="" & ///
			("`onesided'"!=""|"`direction'"!="") {
			di as err "{p}iteration options are only allowed "  ///
				"for effect size or the two-sided test " ///
				"when computing sample size{p_end}"
			exit 198
		}
        }

	gettoken arg1 args : args, match(par)

	local nargs = ("`arg1'"!="") + ("`args'"!="")
	if (!`nargs' ) { 
		di as err "{p}exposure probability " _c
		if "`solvefor'" != "esize" & "`oratio'"=="" {
			di as err "and {bf:oratio()} are " _c
		}
		else {
			local solvefor "odds ratio"
			di as err "is " _c
		}
		di as err "required to compute `solvefor'{p_end}" 
		exit 198	
	}
	if `nargs' > 1 {
		di as err "{p}too many arguments specified{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
	}
	else if `nargs'==1 & "`oratio'"!="" & "`solvefor'"=="esize" {
		di as err "{p}nothing to compute; all parameters have been " ///
		 "provided: {bf:oratio()}, {bf:power()}, and {bf:n()}{p_end}"
		exit 198
	}
	if ("`oratio'"=="" & "`solvefor'"!="esize") {
		di as err "{p}{bf:oratio()} is required " ///
			"to compute `solvefor'{p_end} "
		exit 198
	}		
	
	cap numlist "`arg1'", range(>0 <1)
	if _rc { 
		di as err "{p}probability of exposure must be greater than " ///
		 "0 and less than 1{p_end}"
		exit 198
	}
	if "`oratio'" != "" {
		cap numlist "`oratio'", range(>0)
		if (_rc) {
			di as err "{bf:oratio()} must contain positive numbers"
			exit 198
		}	
	
		local orlist `r(numlist)'
		local kor : list sizeof orlist
		if `kor' == 1 {
			if `orlist' == 1 {
				di as err "{p}{bf:oratio()} must contain " ///
				   "positive numbers different from 1{p_end}" 
				exit 198
			}
		}
	}
	if "`m'" != "" {
		cap numlist "`m'", integer range(>0)
		if _rc { 
			di as err "{bf:m()} must contain positive integers"
			exit 198
		}
		local rhs `"`rhs' m(`r(numlist)')"'
	}
	if "`corr'" != "" {
		cap numlist "`corr'", range(>-1 <1)
		if _rc { 
			di as err "{bf:corr()} must contain numbers " ///
			 "between -1 and 1"
			exit 198
		}
	}

	if ("`compare'"!="" & "`solvefor'" !="n") {
		di as err "{p}option {bf:compare} is allowed only " ///
			"for sample-size determination{p_end}"
		exit 198
	}	
		
        mata: `pssobj'.initonparse(("`compare'"!=""), "`m'")
end
