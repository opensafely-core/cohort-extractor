*! version 1.2.0  11jan2019
program power_cmd_oneprop_parse
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	_power_oneprop_`type'_parse `anything', `options'

end

program _power_oneprop_test_parse
	
	syntax [anything(name=args)] , pssobj(string)	///
				[	test(string)	///
					ONESIDed	///
					BINOMial	/// undoc.
					WALD		/// undoc.
					SCORE		/// default, undoc.
					cluster k(string) ///
					m(string) CVCLuster(string) ///
					*		///
				]
				
	local is_cls 0
	local crd cluster randomized design
	// when it is a crd 
	if ("`cluster'"!="" | `"`k'`m'"' !="") local is_cls 1
				
	opts_exclusive "`wald' `binomial' `score'"	
	if (`"`test'"'!="") {
		if (`"`wald'`score'`binomial'"'!="") {
			di as err "only one of {bf:test()}, {bf:score}, " ///
			          "{bf:wald}, or {bf:binomial} is allowed"
			exit 198
		}
		local len = length(`"`test'"')
		if (`"`test'"'=="wald") local wald wald
		else if (`is_cls') {
			di as error "only option {bf:test(wald)} is " ///
			"allowed with `crd'"
			exit 198
		}
		else if (`"`test'"'==bsubstr("binomial",1,`len') & `len'>4) {
			local binomial binomial
		}
		else if (`"`test'"'!="score") {
			di as err ///
			`"{p}{bf:test()}: invalid method {bf:`test'}{p_end}"'
			exit 198
		}
	}
	local 0, `options' `onesided' ///
		`cluster' k(`k') m(`m') cvcluster(`cvcluster')

	mata: `pssobj'.getsolvefor("solvefor")


	// check if iteration options are allowed
	local isiteropts 0
	if ("`binomial'"!="") {
		local msg "for the binomial test"
	} 
	else if ("`solvefor'"=="n") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg ///
			    "when computing sample size for a one-sided test"
		}
	}
	else if ("`solvefor'" == "k") {
		if ("`onesided'"=="" | ///
		("`onesided'"!="" & "`m'"=="" & "`cvcluster'"!="")) {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "when computing number of clusters "
			local msg "`msg' for a one-sided test"
			if ("`m'"=="") {
				local msg "`msg' with constant cluster sizes"
			}	
		}

	}
	else if ("`solvefor'" == "m") {
		if ("`onesided'"==""|"`cvcluster'"!="") {	
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg ///
			     "when computing cluster size for a one-sided test"
			local msg "`msg' with constant cluster size"
		}	
	}
	else if ("`solvefor'"=="esize") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="power") {
		local msg "when computing power"
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed ,  ///
			`options' txt(`msg')
	}


	local clu_opt cluster k(string) m(string) rho(string) cvcluster(string)
	_pss_syntax SYNOPTS : onetest
	syntax [,	`SYNOPTS' 			///
			diff(string)			///
			CRITVALues			///
			CONTINuity			///
			forcebinomial			/// undoc.
			`clu_opt'			///
			`star'				///
		]

	if "`binomial'"!="" & "`nfractional'"!="" {
		di as err "{p}options {bf:test(binomial)} and " ///
			  "{bf:nfractional} may not be combined{p_end}"
		exit 184
	}
	if "`binomial'"!="" & "`continuity'"!="" {
		di as err "{p}options {bf:test(binomial)} and " ///
			  "{bf:continuity} may not be combined{p_end}"
		exit 184
	}

	// options not allowed for crd
	if (`is_cls') {
		if (`"`test'"'!="" & `"`test'"'!="wald") {
			di as err "{p}{bf:power oneproportion}: only " /// 
			"{bf:test(wald)} is allowed for `crd'{p_end}"
                        exit 198
		}
		local notcrdlist critvalues continuity forcebinomial ///
			binomial score 
		foreach opt of local notcrdlist {			
			if (`"``opt''"'!="") {
				di as err "{p}{bf:power oneproportion}: " ///
				"{bf:`opt'} is not allowed for `crd'{p_end}"
				exit 198
			}	
		}
		local wald wald
	
	}

	if (`isiteropts') {
		local validate `solvefor'
		if ("`validate'"=="esize") local validate proportion

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}
			
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	local nargs 0
	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}null proportion must be between 0 " ///
			 "and 1{p_end}"
			exit 198
		}
		local alist1 `r(numlist)'
		local k1 : list sizeof alist1
		local ++nargs
	}
	if `"`arg2'"'!="" {
	    	capture numlist "`arg2'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}alternative proportion must be " ///
			 "between 0 and 1{p_end}"
			exit 198
		}
		local alist2 `r(numlist)'
		local k2 : list sizeof alist2
		local ++nargs

		if `k1'==1 & `k2'==1 {
			if reldif(`alist1',`alist2') < 1e-10 {
				di as err "{p}null proportion is equal to " ///
				 "the alternative; this is not allowed{p_end}"
				exit 198
			}
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}
	// not allowed to calculate sample size or effect size using binomial
	if (("`solvefor'"=="n" | "`solvefor'"=="esize") & ///
	     `"`binomial'"'!="" & "`forcebinomial'"=="") {
		if ("`solvefor'"=="n") {
			local dimsg "sample"
		}
		else {
			local dimsg "effect"
		}
		di as err "{p}{bf:power oneproportion}: `dimsg'-size "
		di as err "determination is not allowed.{p_end}"
		di as err "{p 4 4 2} " proper("`dimsg'") "-size determination "
		di as err "is not allowed for the binomial test.  "
                di as err "Power function of the binomial test is often nonmonotonic; see  {mansection PSS poweroneproportionRemarksandexamplesex7:{it:Saw-toothed power function}} for details.{p_end}"
		exit 198 	
	}

	// check arguments and diff()
	if (`"`diff'"'=="") {
		_pss_error argsonetest "`nargs'" "`solvefor'"	///
				       "oneproportion" "proportion"
		if ("`solvefor'"=="esize" & "`init'"!="" & `k1'==1) {
			_pss_chk_init "null proportion" "`init'" "`alist1'" ///
				"`direction'"
		}
	}
	else {
		if (`nargs' > 2) {
			_pss_error argsonetest "`nargs'" "`solvefor'"	///
					       "oneproportion"	"proportion"
		}
		else if ("`solvefor'"=="esize")	{
			di as err "{p}option {bf:diff()} is not allowed " ///
			 "when computing effect size.{p_end}"
			exit 198
		}
		else if (`nargs' > 1) {
			di as err "{p}only one of alternative proportion " ///
			 "or option {bf:diff()} is allowed{p_end}" 
			exit 184	
		}
		cap numlist `"`diff'"', range(>-1 <1)
		if (_rc) {
			di as err "{p}{bf:diff()} must contain numbers "  ///
			  "between -1 and 1{p_end}"
			exit 198
		}
		local dlist `r(numlist)'
		local k : list sizeof dlist
		if `k' == 1 {
			if abs(`dlist') < 1e-10 {
				di as err "{p}invalid {bf:diff(`dlist')}; " ///
				 "zero is not allowed{p_end}"
				exit 198
			}
		}
		if `k'==1 & `k1'==1 {
			tempname p2

			scalar `p2' = `alist1' + `dlist'
			local extra
			if (`p2'>=1) local extra "greater than or equal to 1"
			else if (`p2'<=0) local extra "less than or equal to 0"

			if "`extra'" != "" {
				di as err "{p}null proportion plus "    ///
				 "{bf:diff()} is `extra'; this is not " ///
				 "allowed{p_end}"
				exit 198
			}
		}
	}
	// -critvalues-
	if ("`binomial'"=="" & "`critvalues'"!="") {
		di as err "option {bf:critvalues} requires {bf:test(binomial)}"
		exit 198
	}
	
	mata: `pssobj'.initonparse("`diff'","`binomial'`wald'`score'",	///
				   "`critvalues'")
end
