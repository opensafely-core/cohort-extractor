*! version 1.0.0  11feb2019
program ciwidth_cmd_pairedm_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_pairedm_`type'_parse `anything', `options' `type'

end

program _ciwidth_pairedm_ci_parse

	version 16
	syntax [anything(name=args)] , pssobj(string) [ knownsd NOPROBWIDTH1 ///
					fpc(string) normal PROBWidth(string) * ]

        local 0 , `options' `knownsd' fpc(`fpc') ///
		probwidth(`probwidth')
			
	mata: `pssobj'.getsolvefor("solvefor")

       if ("`noprobwidth1'"=="" & "`knownsd'`normal'"=="") {
                if ("`solvefor'"!="probwidth" & "`probwidth'"=="") {
di as err "{bf:ciwidth pairedmeans}: option {bf:probwidth()} required"		
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

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if ("`knownsd'`normal'"=="") {
			local isiteropts 1
			local star init(string) *
			local validate n
		}
		else { 
			local msg "sample size for a normal-based CI"
		}
		local validate n
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
			diff(string)		///
			sddiff(string)		///
			sd(string)		///
			sd1(string)		///
			sd2(string)		///
			CORR(string)		///
			KNOWNSD			///
			NORMAL			/// //undoc.
			fpc(string)		///
			probwidth(string)	///
			`star'			/// //iteropts when allowed
		]
	if (`isiteropts') {
                _pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
        }

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)

	local nargs 0
	if `"`arg1'"'!="" {
		cap numlist `"`arg1'"'
		if c(rc) {
			di as err "{p}pretreatment mean must be a number"
			exit 198
		}
                local a1list1 `r(numlist)'
                local ka1 : list sizeof a1list1

		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist `"`arg2'"'
		if c(rc) {
			di as err "{p}posttreatment mean must be a number"
			exit 198
		}
        	local a1list2 `r(numlist)'
                local ka2 : list sizeof a1list2
		if (`ka1'==1 & `ka2'==1) {
di as txt "{p}note: command arguments " ///
"(pretreatment and posttreatment mean estimates) do not affect " ///
"computations and are used only for display{p_end}"
		}
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	if (`nargs'> 2) {
                _pss_error argstwotest "`nargs'" "`solvefor'"  ///
                                               "twomeans" "mean"
        }

	if ("`diff'"=="" & `nargs'==1) {
di as err "{bf:ciwidth pairedmeans}: too few command arguments specified"
di as err "{p 4 4 2}When you specify a pretreatment mean (the first " ///
"command argument), you must also specify a posttreatment mean (the second " ///
"command argument) or option {bf:diff()}. Mean estimates, however, will be " ///
" used only for display.{p_end}"

                exit 198
	}
 	if (`"`diff'"'!="") {
                if (`nargs'==2) {
                        di as err "{p}option {bf:diff()} may not be " ///
                         "used in a combination with pretreatment and " ///
                         "posttreatment means{p_end}"
                        exit 184
                }
                cap numlist `"`diff'"'
                if (_rc) {
                        di as err "option {bf:diff()} must contain numbers"
                        exit 198
                }
	}

	if (`"`sd'"'!="") {
		if (`"`sd1'`sd2'"'!="") {
			di as err "options {bf:sd1()} and {bf:sd2()} " ///
			 "may not be specified with {bf:sd()}"
			exit 184
		}
		local which {bf:sd()}
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "option {bf:sd()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`sd1'"'!="") {
		local which {bf:sd1()}
		cap numlist `"`sd1'"', range(>0)
		if (_rc) {
			di as err "option {bf:sd1()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`sd2'"'!="") {
		if ("`which'"!="") local which "`which' and "
		local which `which' {bf:sd2()}

		cap numlist `"`sd2'"', range(>0)
		if (_rc) {
			di as err "option {bf:sd2()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`corr'"'!="") {
		if (`"`sddiff'"'!="") {
			di as err "{p}options {bf:corr()} and {bf:sddiff()}" ///
			 " may not both be specified{p_end}"
			exit 184
		}
		cap numlist `"`corr'"', range(>-1 <1)
		if (_rc) {
			di as err "{p}option {bf:corr()} must contain numbers " ///
			 "greater than -1 and less than 1{p_end}"
                        exit 198
		}
	}
	else if (`"`sddiff'"'!="") {
		if ("`which'" != "") {
			di as err "{p}`which' may not be specified with " ///
			 "{bf:sddiff()}{p_end}"
			exit 184 
		}
		cap numlist `"`sddiff'"', range(>0)
		if (_rc) {
			di as err "option {bf:sddiff()} must contain positive numbers"
			exit 198
		}
	}
	else if ("`which'" != "") {
		di as err "{p}option {bf:corr()} must be specified with `which'{p_end}"
		exit 198 
	}
	else {
		di as err "one of {bf:corr()} or {bf:sddiff()} must be " ///
		 "specified"
		exit 198
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
				 "population size specified in "           ///
				 "option {bf:fpc(`_fpc')}{p_end}"
				exit 198
			}
		}
	}
	mata: `pssobj'.initonparse("`arg1'", "`diff'", "`corr'", "`sd'", ///
				   "`sd1'", "`sd2'", 		///
				   `"`fpclab'"', `"`fpcsym'"',	///
				   "`knownsd'", "`normal'")
end
