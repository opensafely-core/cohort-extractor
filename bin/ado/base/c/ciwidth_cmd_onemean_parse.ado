*! version 1.0.0  11feb2019
program ciwidth_cmd_onemean_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_onemean_`type'_parse `anything', `options' `type'

end

program _ciwidth_onemean_ci_parse
   version 16
   syntax [anything(name=args)], pssobj(string) [ knownsd NOPROBWIDTH1 ///
                                        fpc(string) NORMAL PROBWidth(string) * ]
        local 0 , `options' `knownsd' fpc(`fpc') ///
		probwidth(`probwidth')
			
	mata: `pssobj'.getsolvefor("solvefor")

	if ("`noprobwidth1'"=="" & "`knownsd'`normal'"=="") {
		if ("`solvefor'"!="probwidth" & "`probwidth'"=="") {
di as err "{bf:ciwidth onemean}: option {bf:probwidth()} required"			
			if ("`solvefor'"=="width") {
di as err "{p 4 4 2}You must specify option {bf:probwidth()} to compute " ///
"the width of the default Student's t-based CI.{p_end}"
			}
			else {
di as err "{p 4 4 2}You must specify option {bf:probwidth()} to compute " ///
"sample size for the default Student's t-based CI.{p_end}"
			}
			exit 198
		}
	}
	
	if (`"`knownsd'`normal'"'!="" &  `"`probwidth'"'!="") {
		di as err "options {bf:probwidth()} and {bf:knownsd} " ///
	 	"may not both be specified"
		di as err "{p 4 4 2}Probability of CI width is not relevant" ///
" for the normal-based CI, which is computed when you specify option " ///
"{bf:knownsd}.{p_end}"
		exit 184
	}
	if (`"`knownsd'`normal'"'!="" &  "`solvefor'"=="probwidth") {
		di as err "option {bf:knownsd} is not allowed when " ///
			"computing probability of CI width"
			exit 198
	}
	local is_cls 0
	// when it is a crd 
	if ("`cluster'"!="" | `"`k'`m'"' !="") {
		local is_cls 1
		// when crd, knownsd is implied; knownsd used in iter decision
		if ("`knownsd'"=="") {
			local 0 `0' knownsd
			local knownsd knownsd
		}	
	}	
	
	// check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'" == "n") {
		if ("`knownsd'`normal'"=="" ) {
			local isiteropts 1
			local star init(string) *
		}
		else { 
			local msg "sample size for a normal-based CI"
		}
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
			sd(string)		///
			KNOWNSD			///
			fpc(string)		///
			probwidth(string)	///
			`star'			/// //iteropts when allowed
		]

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	if `"`arg1'"'!="" {
                cap numlist `"`arg1'"'
                if c(rc) {
                        di as err "{p}command argument " ///
			"(mean estimate) must be a number"
                        exit 198
                }
                local a1list `r(numlist)'
                local ka1 : list sizeof a1list
                if `ka1'==1 {
			di as txt "{p}note: command argument " ///
"(mean estimate) does not affect computations and is used only for " ///
"display{p_end}"
                }
        }

	if ("`arg2'"!="") {
		di as err "{p}too many command arguments specified{p_end}"
                di as err "{p 4 4 2}If you are specifying multiple values, "
                di as err "remember to enclose them in parentheses.{p_end}"
                exit 198
	}

	// options not allowed for crd
	if (`is_cls') {
		if (`"`fpc'"'!="") {
			di as err "{p}{bf:ciwidth onemean}:" ///
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

	// sd()
	if (`"`sd'"'!="") {
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "option {bf:sd()} must contain positive numbers"
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
				di as err "{p}invalid option {bf:init(`init')}: " ///
				 "value is greater than or equal to the "  ///
				 "population size specified in option "           ///
				 "{bf:fpc(`_fpc')}{p_end}"
				exit 198
			}
		}
	}

	mata: `pssobj'.initonparse(`"`fpclab'"', `"`fpcsym'"', ///
			"`knownsd'","`normal'", "`arg1'")
end
