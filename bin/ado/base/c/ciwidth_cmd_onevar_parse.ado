*! version 1.0.0  11feb2019
program ciwidth_cmd_onevar_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_onevar_`type'_parse `anything', `options' `type'

end

program _ciwidth_onevar_ci_parse
	version 16

	syntax [anything(name=args)], pssobj(string) [ ///
		NOPROBWIDTH1 PROBWidth(string) ///
		*]
	local 0 , `options' probwidth(`probwidth')

	mata: `pssobj'.getsolvefor("solvefor")
	mata: `pssobj'.getonesided("onesided")

        if ("`noprobwidth1'"=="") {
                if ("`solvefor'"!="probwidth" & "`probwidth'"=="") {
			if ("`solvefor'"=="width") {
di as err "option {bf:probwidth()} is required to compute CI width"
			}
			else {
di as err "option {bf:probwidth()} is required to compute sample size"
			}
			exit 198
                }
        }

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="width") {
		local msg CI width
	}
	else if ("`solvefor'"=="probwidth") {
		local msg probability of CI width
	}
	
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : oneci
	syntax [, 	`SYNOPTS'		///
			sd			///
		 	PROBWidth(string)       ///
			`star'			/// //iteropts when allowed
		]
	if (`isiteropts') {
		local validate `solvefor'

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
		
	}
	if ("`sd'"=="") {
		local param "variance"
		local param1 "variance"
	}
	else {
		local param "standard deviation"
		local param1 "standard-deviation"
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	local nargs 0
	if `"`arg1'"'!="" {
		cap numlist "`arg1'", range(>0)
		local rc = c(rc)
		if (`rc') {
di as err "{p}invalid command argument; `param' must " ///
			 "be positive number{p_end}"
			 exit 198
		}
	}
	else {
		di as err "{p}you must specify `param1' estimate as " ///
		"command argument{p_end}"
		exit 198	
	}
	if `"`arg2'"'!="" {
		_pss_error argsonetest 3
	}
		
	mata: `pssobj'.initonparse("`sd'")
end
