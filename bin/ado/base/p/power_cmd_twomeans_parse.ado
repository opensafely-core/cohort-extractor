*! version 1.2.0  11jan2019
program power_cmd_twomeans_parse
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	_power_twomeans_`type'_parse `anything', `options' `type'

end

program _power_twomeans_test_parse

	syntax [anything(name=args)]  , pssobj(string) 	///
				[	ONESIDed 	///
					NORMAL 		/// undoc.
					KNOWNSDs 	///
					cluster 	///
					k1(string)      ///
					k2(string)	///
					m1(string)	///
					m2(string)	///
					CVCLuster(string) /// 
					* 		///
				]
	local 0 , `options' `onesided' `normal' `knownsds' ///
		`cluster' k1(`k1') k2(`k2') ///
		 m1(`m1') m2(`m2') ///
		 cvcluster(`cvcluster')

	local is_cls 0
	local crd cluster randomized design
	// when it is a crd 
	if ("`cluster'"!="" | `"`k1'`k2'`m1'`m2'"' !="") {
		local is_cls = 1
		// when crd, knownsd is implied; knowsd used in iter decision
		if ("`knownsds'"=="") {
			local 0 `0' knownsds
			local knownsds knownsds
		}	
	}	
	
	if ("`knownsds'"!="") local normal normal

	mata: `pssobj'.getsolvefor("solvefor")

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"|"`solvefor'"=="n1"|"`solvefor'"=="n2") {
		if ("`normal'"!="" & "`onesided'"!="" & ///
				!(`is_cls'==1 & "`cvcluster'"!="")) {
			local msg "sample sizes for a normal one-sided test"
		}
		else {
			local isiteropts 1
			local star init(string) *
		}
	}
	else if ("`solvefor'"=="k" | "`solvefor'"=="k1"|"`solvefor'"=="k2") {
		if ("`onesided'"=="" | ///
		("`onesided'"!="" & "`m1'`m2'"=="" & "`cvcluster'"!="")) {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "number(s) of clusters for a one-sided test"
			if ("`m1'`m2'"=="") {
				local msg "`msg' with constant cluster sizes"
			}	
		}	
	}
	else if ("`solvefor'"=="m" | "`solvefor'"=="m1"|"`solvefor'"=="m2") {
		if ("`onesided'"==""|"`cvcluster'"!="") {	
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "cluster size(s) for a one-sided test"
			local msg "`msg' with constant cluster sizes"
		}	
	}
	else if ("`solvefor'"=="esize") {
		if ("`normal'"!="" & "`onesided'"!="") {
			local msg "effect size for a normal one-sided test"
		}
		else {
			local isiteropts 1
			local star init(string) *
		}
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	local clu_opt cluster k1(string)  k2(string) KRATio(string) ///
		m1(string) m2(string) MRATio(string) ///
		rho(string) cvcluster(string)
	
	_pss_syntax SYNOPTS : twotest  

	syntax [, 		`SYNOPTS' 	///
				diff(string)	///
				sd1(string)	///
				sd2(string)	///
				sd(string)	///
				KNOWNSDs	///
				NORMAL		/// undoc.
				welch		/// undoc.
				`clu_opt'	///
				`star'		///
		]

	// options not allowed for crd
	if (`is_cls') {
		if (`"`welch'"'!="") {
			di as err "{p}{bf:power twomeans}:" ///
			" option {bf:welch} is not allowed for `crd'{p_end}"
			exit 198
		}	
	}

	if (`isiteropts') {
		if (bsubstr("`solvefor'",1,1)=="n") local validate n
		else if (bsubstr("`solvefor'",1,1)=="k") local validate k
		if (bsubstr("`solvefor'",1,1)=="m") local validate m

		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		cap numlist `"`arg1'"'
		if (_rc) {
			di as err "means must contain numbers"
			exit 198
		}
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list

		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist `"`arg2'"'
		if (_rc) {
			di as err "means must contain numbers"
			exit 198
		}
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list

		local ++nargs

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list')<1e-10 {
				di as err "{p}the control-group mean and " ///
				 "the experimental-group mean are equal; " ///
				 "this is not allowed{p_end}"
				exit 198
			} 
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and diff()
	if (`"`diff'"'=="") {
		_pss_error argstwotest  "`nargs'" "`solvefor'" 	///
					"twomeans" "mean"

		if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
			_pss_chk_init "control-group mean" "`init'" 	///
				"`a1list'" "`direction'"
		}
	}
	else {
		if (`nargs'> 2) {
			_pss_error argstwotest "`nargs'" "`solvefor'"  ///
					       "twomeans" "mean"
		}
		else if ("`solvefor'"=="esize") {
			di as err "option {bf:diff()} is not allowed with " ///
			 "effect-size determination"
			exit 184
		}
		else if (`nargs'> 1) {
			di as err "{p}only one of experimental-group mean " ///
				  "or option {bf:diff()} is allowed {p_end}"
			exit 198
		}
		else if (`nargs'==0) {
		    di as err "{p}control-group mean must be specified{p_end}"
		    exit 198
		}
		cap numlist `"`diff'"'
		if (_rc) {
			di as err "{bf:diff()} must contain numbers"
			exit 198
		}
		local mlist `r(numlist)'
		local k : list sizeof mlist
		if `k' == 1 {
			if abs(`mlist') < 1e-10 {
				di as err "{p}invalid {bf:diff(`mlist')}: " ///
				 "zero is not allowed{p_end}"
				exit 198
			}
		}
	}
	
	// check sd1() sd2() and sd()
	if (`"`sd'"'!="") {
		if (`"`sd1'"'!="" | `"`sd2'"'!="") {
			di as err "{p}option {bf:sd()} is not allowed in a " ///
		"combination with option {bf:sd1()} or {bf:sd2()}{p_end}"
			exit 198
		}
		if (`"`welch'"'!="") {
			di as err "{p}option {bf:sd()} may not be combined " ///
			"with option {bf:welch}{p_end}"
			exit 198
		}
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "{bf:sd()} must contain positive numbers"
			exit 198
		}
	}
	else if (`"`sd1'`sd2'"'!="") {
		if (`"`sd1'"'!="") {
			if (`"`sd2'"'=="") {
				di as err "{p}option {bf:sd2()} must be " ///
				 "specified with option {bf:sd1()}{p_end}"
				exit 198 
			}	

			cap numlist `"`sd1'"', range(>0)
			if (_rc) {
				di as err "{bf:sd1()} must contain " ///
				 "positive numbers"
				exit 198
			}	
		}
		if (`"`sd2'"'!="") {
			if (`"`sd1'"'=="") {
				di as err "{p}option {bf:sd1()} must be " ///
				 "specified with option {bf:sd2()}{p_end}"
				exit 198 
			}

			cap numlist `"`sd2'"', range(>0)
			if (_rc) {
				di as err "{bf:sd2()} must contain " ///
				 "positive numbers"
				exit 198
			}
		}
	}
	else {
		if (`"`welch'"'!="") {
			di as err "{p}both options {bf:sd1()} and " ///
	"{bf:sd2()} are needed when option {bf:welch} is specified{p_end}"
			exit 198

		}
	}

	// check normal welch and unequal
	if (`"`normal'"'!="") {
		if (`"`welch'"'!="") {
			di as err "{p}option {bf:normal} may not be " ///
			"combined with option {bf:welch}{p_end}"
			exit 184
		}
	}

	if (`"`knownsds'"'!="") {
		if (`"`welch'"'!="") {
			di as err "{p}option {bf:knownsds} may not be " ///
			"combined with option {bf:welch}{p_end}"
			exit 184
		}
	}

	mata: `pssobj'.initonparse("`diff'","`sd1'`sd2'","`knownsds'",	///
				   "`normal'","`welch'")
end
