*! version 1.0.0  06jun2013
program power_cmd_twovar_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_twovar_`type'_parse `anything', `options'

end

program _power_twovar_test_parse

	syntax [anything(name=args)] , pssobj(string) [ ONESIDed * ]
	local 0 , `options' `onesided'

	mata: st_local("solvefor", `pssobj'.solvefor)

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"|"`solvefor'"=="n1"|"`solvefor'"=="n2") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="esize") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "effect size for a one-sided test"	
		}
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : twotest  

	syntax [, 		`SYNOPTS' 	///
				ratio(string)	///
				sd		///
				`star'		///
		]

	if (`isiteropts') {
		local validate = substr("`solvefor'",1,1)
		if ("`validate'"!="n") local validate var

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	if ("`sd'"=="") {
		local param "variance"
	}
	else {
		local param "standard deviation"
	}
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(> 0)
		if (_rc!=0) {
			di as err "`param's must be positive numbers"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
		local ++nargs
	}

	if `"`arg2'"'!="" {
		capture numlist "`arg2'", range(> 0)
		if (_rc!=0) {
			di as err "`param's must be positive numbers"
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list
		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list') < 1e-10 {
				di as err "{p}control and experimental "   ///
				 "`param's are equal; this is not allowed" ///
				 "{p_end}"
				exit 198
			}
		}
	}
	
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and ratio()
	if (`"`ratio'"'=="") {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
					"twovariances" "`param'"

		if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
			_pss_chk_init "control `param'" "`init'" "`a1list'" ///
				"`direction'"
		}
	}
	else {
		if (`nargs'> 2) {
			_pss_error argstwotest "`nargs'" "`solvefor'"  ///
					      "twovariances" "`param'"
		}
		else if ("`solvefor'"=="esize") {
			di as err "{p}option {bf:ratio()} is not allowed " ///
			 "when computing effect size"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}only one of the `param's or option " ///
			  "{bf:ratio()} is allowed {p_end}"
			exit 198
		}
		cap numlist `"`ratio'"', range(>0)
		if (_rc) {
			di as err "{bf:ratio()} must contain positive numbers"
			exit 198
		}
		local rlist `r(numlist)'
		local k : list sizeof rlist
		if `k' == 1 {
			if (reldif(`rlist',1) < 1e-10) {
				di as err "{p}invalid {bf:ratio(`rlist')}; " ///
				 "one is not allowed{p_end}"
				exit 198
			}
		}
	}
	mata: `pssobj'.initonparse("`sd'","`ratio'")
end
