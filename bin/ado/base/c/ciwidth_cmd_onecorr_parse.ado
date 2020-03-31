*! version 1.0.0  11jan2019
program ciwidth_cmd_onecorr_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_onecorr_`type'_parse `anything', `options' `type'

end

program _ciwidth_onecorr_ci_parse
	version 16
	syntax [anything(name=args)], pssobj(string) [ *]
	local 0, `options'

	mata: `pssobj'.getsolvefor("solvefor")
	mata: `pssobj'.getonesided("onesided")
	
	// to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if (`onesided'==0) {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "sample size for a one-sided CI"	
		}
	}
	else if ("`solvefor'"=="width") {
		local msg CI width
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : oneci
	syntax [, `SYNOPTS' diff(string) `star' ]

	if (`isiteropts') {
		local validate `solvefor'
		
		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(>-1 <1)
		if (_rc!=0) {
			di as err "{p}{bf:ciwidth onecorrelation}: sample " ///
				"correlation must be between -1 and 1{p_end}"
			exit 198
		}
	}
	else {
		di as err "{p}sample correlation is required{p_end}"
		exit 198	
	}
	if `"`arg2'"'!="" {
		_pss_error argsonetest 3
	}
	if `"`width'"'!="" {
		capture numlist "`width'", range(<2)
		if (_rc!=0) {
			di as err "{p}{bf:ciwidth onecorrelation}: " ///	
			"CI width must be less than 2{p_end}"
			exit 198
		}
	}
		
	mata: `pssobj'.initonparse()
end
