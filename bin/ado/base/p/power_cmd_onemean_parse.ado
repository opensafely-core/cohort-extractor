*! version 1.2.0  11jan2019
program power_cmd_onemean_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_onemean_`type'_parse `anything', `options' `type'

end

program _power_onemean_test_parse

   syntax [anything(name=args)], pssobj(string) [ ONESIDed knownsd ///
                                        fpc(string) NORMAL cluster k(string) ///
					m(string) CVCLuster(string) * ]
        local 0 , `options' `onesided' `knownsd' fpc(`fpc') ///
			`cluster' k(`k') m(`m') cvcluster(`cvcluster')
			
	mata: `pssobj'.getsolvefor("solvefor")
	
	local is_cls 0
	local crd cluster randomized design
	// when it is a crd 
	if ("`cluster'"!="" | `"`k'`m'"' !="") {
		local is_cls 1
		// when crd, knownsd is implied; knowsd used in iter decision
		if ("`knownsd'"=="") {
			local 0 `0' knownsd
			local knownsd knownsd
		}	
	}	
	
	// check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'" == "n") {
		if ("`knownsd'`normal'"=="" | "`onesided'"=="" |	///
		    `"`fpc'"'!="") {
			local isiteropts 1
			local star init(string) *
		}
		else { 
			local msg "sample size for a one-sided test"
			local msg "`msg' with known standard deviation"
			local msg "`msg' and infinite sample size"
		}
	}
	else if ("`solvefor'" == "k") {
		if ("`onesided'"=="" | ///
		("`onesided'"!="" & "`m'"=="" & "`cvcluster'"!="")) {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "number of clusters for a one-sided test"
			if ("`m'"=="") {
				local msg "`msg' with constant cluster sizes"
			}	
		}	
	}
	else if ("`solvefor'" == "m") {
		if ("`onesided'"=="" | "`cvcluster'"!="") {	
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "cluster size for a one-sided test"
			local msg "`msg' with constant cluster sizes"
		}	
	}
	else if ("`solvefor'"=="esize") {
		if ("`knownsd'`normal'"=="" | "`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else { 
			local msg "effect size for a one-sided test"
			local msg "`msg' with known standard deviation"
		}
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	local clu_opt cluster k(string) m(string) rho(string) cvcluster(string)
	
	_pss_syntax SYNOPTS : onetest
	syntax [, 	`SYNOPTS'		///
			diff(string)		///
			sd(string)		///
			KNOWNSD			///
			fpc(string)		///
			`clu_opt'		///
			`star'			/// //iteropts when allowed
		]

	// options not allowed for crd
	if (`is_cls') {
		if (`"`fpc'"'!="") {
			di as err "{p}{bf:power onemean}:" ///
			" option {bf:fpc()} is not allowed for `crd'{p_end}"
			exit 198
		}	
	}

	if (`isiteropts') {
		if ("`solvefor'" == "n" | "`solvefor'" == "m" | ///
			"`solvefor'" == "k") {
			local validate `solvefor'
		}
                _pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
        }


	
	
	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		local ++nargs
	}
	if `"`arg2'"'!="" {
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments and diff()
	if (`"`diff'"'=="") {
		_pss_error argsonetest "`nargs'" "`solvefor'"  ///
				       "onemean" "mean"
		if `nargs' > 0 {
			cap numlist "`arg1'"
			if c(rc) {
				di as err "null means must be real values"
				exit 198
			}
			local a1list `r(numlist)'
			local ka1 : list sizeof a1list
			if "`init'"!="" & "`solvefor'"=="esize" & `ka1'==1 {
				_pss_chk_init "null mean" "`init'" ///
					"`a1list'" "`direction'"
			}
		}
		if `nargs' > 1 {
			cap numlist "`arg2'"
			if c(rc) {
				di as err "alternative means must be real " ///
				 "values"
				exit 198
			}
			local a2list `r(numlist)'
			local ka2 : list sizeof a2list
			if `ka1'==1 & `ka2'==1 {
				if `a1list' == `a2list' {
					di as err "{p}null and alternative " ///
					 "means are equal; this is not "     ///
					 "allowed{p_end}"
					exit 198
				}
			}
		}
	}
        else {
		if (`nargs'> 2) {
			_pss_error argsonetest "`nargs'" "`solvefor'"  ///
					       "onemean" "mean"
		}
		else if ("`solvefor'"=="esize") {
			di as err "{bf:power onemean}: option {bf:diff()} " ///
				  "is not allowed when computing effect size"
			exit 198
		}
		else if (`nargs'> 1) {
			di as err "{p}{bf:power onemean}: only one of "     ///
			  	  "alternative mean or option {bf:diff()} " ///
				  "is allowed {p_end}"
			exit 198
		}
		cap numlist `"`diff'"'
		if (_rc) {
			di as err "{bf:diff()} must contain numbers"
			exit 198
		}
		local dlist `r(numlist)'
		local kd : list sizeof dlist
		if `kd' == 1 {
			if `dlist' == 0 {
				di as err "{p}invalid {bf:diff(`dlist')}; " ///
				 "zero is not allowed{p_end}"
				exit 198
			}
		}
	}
	// sd()
	if (`"`sd'"'!="") {
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "{bf:sd()} must contain positive numbers"
			exit 198
		}
	}
	// fpc()
	if (`"`fpc'"'!="") {
		_pss_chk_fpc `"`fpc'"' `"`n'"'
		local fpclab `""`s(lab)'""'
		local fpcsym `""`s(symlab)'""'

		local _fpc "`s(fpc)'"
		/* _fpc exists only if it is a single pop value	*/
		if "`solvefor'"=="n" & "`_fpc'"!="" & "`init'"!="" {
			if `init' >= `_fpc' {
				di as err "{p}invalid {bf:init(`init')}; " ///
				 "value is greater than or equal to the "  ///
				 "population size specified in "           ///
				 "{bf:fpc(`_fpc')}{p_end}"
				exit 198
			}
		}
	}

	mata: `pssobj'.initonparse("`diff'",`"`fpclab'"', `"`fpcsym'"',	///
				 "`knownsd'","`normal'")
end
