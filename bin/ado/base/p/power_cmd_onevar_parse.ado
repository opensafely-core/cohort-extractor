*! version 1.1.0  11jan2019
program power_cmd_onevar_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_onevar_`type'_parse `anything', `options' `type'

end

program _power_onevar_test_parse

	syntax [anything(name=args)], pssobj(string) [ ONESIDed * ]
	local 0 , `options' `onesided'

	mata: st_local("solvefor", `pssobj'.solvefor)

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
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

	_pss_syntax SYNOPTS : onetest
	syntax [, 	`SYNOPTS'		///
			ratio(string)		///
			sd			///
			NORMAL			/// //undoc.
			`star'			/// //iteropts when allowed
		]
	if (`isiteropts') {
		local validate `solvefor'
		if ("`validate'"=="esize") local validate var

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
		cap numlist "`arg1'", range(>0)
		local rc = c(rc)
		if (`rc') {
			di as err "{p}invalid null `param'; `param's must " ///
			 "be positive numbers{p_end}"
			 exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist "`arg2'", range(>0)
		local rc = c(rc)
		if (`rc') {
			di as err "{p}invalid alternative `param'; " ///
			 "`param's must be positive numbers{p_end}"
			 exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list
		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list')<1e-10 {
				di as err "{p}null and alternative " ///
				 "`param's are equal; this is not "  ///
				 "allowed{p_end}"
				exit 198
			}
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and ratio()
	if (`"`ratio'"'=="") {
		_pss_error argsonetest "`nargs'" "`solvefor'"  ///
				       "onevariance" "`param'"
		if ("`solvefor'"=="esize" & "`init'"!="" & `ka1'==1) {
			_pss_chk_init "null `param'" "`init'" "`a1list'" ///
				"`direction'"
		}	
	}
	else { 
		if ("`solvefor'"=="esize") {
			di as err "option {bf:ratio()} is not allowed " ///
			 "when computing effect size"
			exit 198
		}
		else if (!`nargs') {
			di as err "{p}null `param' is required{p_end}"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}alternative `param' and option " ///
			 "{bf:ratio()} may not be combined{p_end}"
			exit 184
		}
		cap numlist `"`ratio'"', range(>0)
		if (_rc) {
			di as err "invalid {bf:ratio()}; {bf:ratio()} must " ///
			 "contain positive numbers"
			exit 198
		}
		local ratlist `r(numlist)'
 		local n_rat : list sizeof ratlist
 		if (`n_rat'==1) {
 			if (reldif(`ratlist', 1)< 1e-10) {
 				di as err ///
 				    "{p}invalid {bf:ratio(`ratlist')}; " ///	
 				    "one is not allowed{p_end}"
 				exit 198 
 			}
 		}
	}
	mata: `pssobj'.initonparse("`sd'","`ratio'","`normal'")
end
