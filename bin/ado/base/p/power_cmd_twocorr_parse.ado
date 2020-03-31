*! version 1.0.0  06jun2013
program power_cmd_twocorr_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_twocorr_`type'_parse `anything', `options'

end

program _power_twocorr_test_parse

	syntax [anything(name=args)] , pssobj(string) [ ONESIDed * ]
	local 0 , `options' `onesided'

	mata: st_local("solvefor", `pssobj'.solvefor)

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"|"`solvefor'"=="n1"|"`solvefor'"=="n2") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "sample sizes for a one-sided test"	
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

	_pss_syntax SYNOPTS : twotest  

	syntax [, 	`SYNOPTS'	///
			diff(string) 	///
			`star'		///
		]

	if (`isiteropts') {
		local validate = substr("`solvefor'",1,1)
		if ("`validate'"!="n") local validate corr

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if (`"`arg1'"'!="") {
		capture numlist "`arg1'", range(>=-1 <= 1)
		if (_rc!=0) {
			di as err "{p}correlation must be between -1 and 1" ///
			 "{p_end}"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
		local ++nargs
	}
	if (`"`arg2'"'!="") {
		capture numlist "`arg2'", range(>=-1 <= 1)
		if (_rc!=0) {
			di as err "{p}correlation must be between -1 and 1" ///
			 "{p_end}"
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list
		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list') < 1e-10 {
				di as err "{p}control group correlation " ///
				 "is equal to the comparison group "      ///
				 "correlation; this is not allowed{p_end}"
				exit 198
			}
		}
	}
	if (`"`args'"'!="") {
		local ++nargs
	}

	if (`"`nratio'"'!="") {
		local addcols "nratio "
	}
	local addcols "`addcols'delta r1 r2"

	if (`"`diff'"'=="") {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
				"twocorrelations" "correlation"

		if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
			_pss_chk_init "control correlation" "`init'" ///
				"`a1list'" "`direction'"
		}
	}
	else {
		local addcols "`addcols' diff"
		if (`nargs'>2) {
			_pss_error argstwotest "`nargs'" "`solvefor'" ///
				"twocorrelations" "correlation"
		}
		else if ("`solvefor'"=="esize") {
			di as err "{p}option {bf:diff()} is not allowed " ///
			 "when computing effect size{p_end}"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}only one of the experimental " ///
			 "correlation or option {bf:diff()} is allowed {p_end}"
			exit 198
		}
		else if (`nargs'==0) {
			di as err "{p}correlation for the control group " ///
			 "is needed when option {bf:diff()} is specified{p_end}"
			exit 198
		}

		cap numlist `"`diff'"', range(>=-2 <= 2)
		if (_rc) {
			di as err "{bf:diff()} must be between -2 and 2"
			exit 198
		}
		local clist `r(numlist)'
		local k : list sizeof clist
		if `k' == 1 {
			if abs(`diff') < 1e-10 {
				di as err "{p}invalid {bf:diff(`clist')}; " ///
				 "zero is not allowed{p_end}
				exit 198
			}
		}
		if `k'==1 & `ka1'==1 {
			tempname r1

			scalar `r1' = `a1list' + `clist'

			local extra
			if (`r1'>=1) local extra "greater than or equal to 1"
			if (`r1'<=-1) local extra "less than or equal to -1"
			if "`extra'" != "" {
				di as err "{p}control correlation plus the " ///
				 "difference is `extra'; this is not "       ///
				 "allowed {p_end}"
				exit 198
			}

		}
	}
	mata: `pssobj'.initonparse("`diff'")
end
