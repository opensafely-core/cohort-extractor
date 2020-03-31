*! version 1.1.0  11jan2019
program power_cmd_onecorr_parse
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	_power_onecorr_`type'_parse `anything', `options' `type'

end

program _power_onecorr_test_parse

	syntax [anything(name=args)], pssobj(string) [ ONESIDed *]
	local 0, `options' `onesided'

	mata: st_local("solvefor", `pssobj'.solvefor)

	// to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "sample size for a one-sided test"	
		}
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
	syntax [, `SYNOPTS' diff(string) `star' ]

	if (`isiteropts') {
		local validate `solvefor'
		if ("`solvefor'"=="esize") local validate corr

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(>-1 <1)
		if (_rc!=0) {
			di as err "{p}{bf:power onecorrelation}: null "	///
				"correlation must be between -1 and 1{p_end}"
			exit 198
		}
		local r0 `r(numlist)'
		local k0 : list sizeof r0	
		local ++nargs
	}
	if `"`arg2'"'!="" {
		capture numlist "`arg2'", range(>-1 <1)
		if (_rc!=0) {
			di as err "{p}{bf:power onecorrelation}:  "	///
				"alternative correlation must be between " ///
				"-1 and 1{p_end}"
			exit 198
		}
		local ++nargs
		local r1 `r(numlist)'
		local k1 : list sizeof r1	
		if `k0'==1 & `k1'==1 {
			if reldif(`r0',`r1') < 1e-10 {
				di as err "{p}null and alternative "    ///
				 "correlations are equal; this is not " ///
				 "allowed{p_end}"
				exit 198
			}
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and diff()
	if (`"`diff'"'=="") {
		_pss_error argsonetest  "`nargs'" "`solvefor'" 	///
					"onecorrelation" "correlation"
		if ("`solvefor'"=="esize" & "`init'"!="" & `k0'==1) {
			_pss_chk_init "null correlation" "`init'" "`r0'" ///
				"`direction'"
		}
	}
        else {
		if (`nargs'> 2) {
			_pss_error argsonetest "`nargs'" "`solvefor'"  ///
					       "onecorrelation" "correlation"
		}
		else if ("`solvefor'"=="esize") {
			di as err "option {bf:diff()} is not allowed when " ///
			 "computing effect size"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}only one of alternative correlation " ///
			 "or option {bf:diff()} is allowed {p_end}"
			exit 198
		}
		cap numlist `"`diff'"', range(>-2 <2)
		if c(rc) {
			di as err "{p}invalid {bf:diff(`diffs')}; values "  ///
			 "must be greater than -2 and less than 2{p_end}"
			 exit 198
		}
		local diffs `r(numlist)'
		local d : list sizeof  diffs
		if `d' == 1 {
			if (abs(`diffs') < 1e-10) {
				di as err "{p}invalid {bf:diff(`diffs')}; " ///
				 "zero is not allowed{p_end}"
				exit 198
			}
		}
		if `k0'==1 & `d'==1 {
			tempname r1

			scalar `r1' = `arg1' + `diffs'
			local extra
			if (`r1'<=-1) local extra "less than or equal to -1"
			if (`r1'>=1) local extra "greater than or equal to 1"
			if "`extra'" != "" {
				di as err "{p}null correlation plus the " ///
				 "difference is `extra'; this is not "    ///
				 "allowed {p_end}"
				exit 198
			}
		}
	}
	mata: `pssobj'.initonparse("`diff'")
end
