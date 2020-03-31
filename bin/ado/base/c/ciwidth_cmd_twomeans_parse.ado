*! version 1.0.0  13feb2019
program ciwidth_cmd_twomeans_parse
        version 16

        syntax [anything] [, test ci * ]
        local type `test' `ci'
        _ciwidth_twomeans_`type'_parse `anything', `options' `type'

end

program _ciwidth_twomeans_ci_parse

	version 16
	syntax [anything(name=args)]  , pssobj(string) 	///
				[	NORMAL 		/// undoc.
					KNOWNSDs 	///
   					sd1(string)     ///
                                	sd2(string)     ///
                                	sd(string)      ///
					NOPROBWIDTH1	///
					PROBWidth(string) ///
					* 		///
				]
	local 0 , `options' `normal' `knownsds' ///
		probwidth(`probwidth') sd1(`sd1') sd2(`sd2') sd(`sd')

	local is_cls 0
	local crd cluster randomized design
	
	if ("`knownsds'"!="") local normal normal

	mata: `pssobj'.getsolvefor("solvefor")

	
        if ("`noprobwidth1'"=="" & "`knownsds'`normal'"=="") {
		if ("`sd1'"!="" & "`probwidth'"!="" & "`sd2'`sd'"=="") {
di as err "{p}option {bf:sd1()} must be specified with options " ///
"{bf:sd2()} and {bf:knownsds}; it may not be combined with option " ///
"{bf:probwidth()}{p_end}"
			exit 198
		}
		else if ("`sd2'"!="" & "`probwidth'"!="" & "`sd1'`sd'"=="") {
di as err "{p}option {bf:sd2()} must be specified with options " ///
"{bf:sd1()} and {bf:knownsds}; it may not be combined with option " ///
"{bf:probwidth()}{p_end}"
			exit 198
		}
		else if("`sd1'"!="" & "`probwidth'"!="" & "`sd2'"!="") {
di as err "option {bf:probwidth()} not supported with unequal standard " ///
"deviations" ///
"{p 4 4 2}Option {bf:probwidth()} is supported only for " ///
"equal standard deviations specified in option {bf:sd()}. In the unequal " ///
"case, if you know population standard deviations, you can use option " ///
"{bf:knownsds} to obtain results.{p_end}"
			exit 198
		}
		else if ("`sd1'"!="" & "`probwidth'"=="" & "`sd2'"!="") {
di as err "{p}options {bf:sd1()} and {bf:sd2()} are allowed only " ///
"in combination with option {bf:knownsds}"
			exit 198
		}
                else if ("`solvefor'"!="probwidth" & "`probwidth'"=="") {
di as err "{bf:ciwidth twomeans}: option {bf:probwidth()} required"		
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

	if ("`solvefor'"=="probwidth" | `"`probwidth'"'!="") {
		local hasprobw 1
	}
	else {
		local hasprobw 0
	}
	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n"|"`solvefor'"=="n1"|"`solvefor'"=="n2") {
		if ("`normal'"!="") {
			local msg "sample sizes for a normal-based CI"
		}
		else {
			local isiteropts 1
			local star init(string) *
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

	_pss_syntax SYNOPTS : twoci

	syntax [, 		`SYNOPTS' 	///
				diff(string)	///
				sd1(string)	///
				sd2(string)	///
				sd(string)	///
				probwidth(string) ///
				KNOWNSDs	///
				NORMAL		/// undoc.
				EQUALSDs		///
				`star'		///
		]


	if (`isiteropts') {
		if (bsubstr("`solvefor'",1,1)=="n") local validate n

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
			di as err "control-group mean must contain numbers"
			exit 198
		}
                local a1list1 `r(numlist)'
                local ka1 : list sizeof a1list1
		local ++nargs
	}
	if `"`arg2'"'!="" {
		cap numlist `"`arg2'"'
		if (_rc) {
			di as err "experimental-mean must contain numbers"
			exit 198
		}
		local a1list2 `r(numlist)'
                local ka2 : list sizeof a1list2
                if (`ka1'==1 & `ka2'==1) {
                        di as txt "{p}note: command arguments " ///
"(control- and experimental-group mean estimates) do not affect " ///
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
di as err "{bf:ciwidth twomeans}: too few command arguments specified"
di as err "{p 4 4 2}When you specify a control-group mean (the first " ///
"command argument), you must also specify an experimental-group mean " ///
"(the second command argument) or option {bf:diff()}. Mean estimates, " ///
"however, will be used only for display.{p_end}"
		exit 198
        }

        if (`"`diff'"'!="") {
                if (`nargs'==2) {
                        di as err "{p}option {bf:diff()} may not be " ///
                         "used in a combination with control-group and " ///
                         "experimental-group means{p_end}"
                        exit 184
                }
                cap numlist `"`diff'"'
                if (_rc) {
                        di as err "option {bf:diff()} must contain numbers"
                        exit 198
                }
        }	
	// check sd1() sd2() and sd()
	if (`"`sd'"'!="") {
		if (`"`sd1'"'!="" | `"`sd2'"'!="") {
			di as err "{p}option {bf:sd()} is not allowed in a " ///
		"combination with option {bf:sd1()} or {bf:sd2()}{p_end}"
			exit 184
		}
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "option " ///
			"{bf:sd()} must contain positive numbers"
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
				di as err "option {bf:sd1()} must contain " ///
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
				di as err "option {bf:sd2()} must contain " ///
				 "positive numbers"
				exit 198
			}
		}
		if (`hasprobw'==1) {
			if ("`probwidth'"!="") {
			di as err "{p}option {bf:probwidth()} is " ///
"supported only for equal standard deviations specified in option " ///
"{bf:sd()}{p_end}"	
			}
			else {
di as err "{p}probability of width computation is " ///
"supported only for equal standard deviations specified in option " ///
"{bf:sd()}{p_end}"	
			}
			exit 198
		}
	}

	if (`"`knownsds'"'!="") {
		if (`hasprobw'==1 & `"`solvefor'"'!="probwidth") {
		di as err "options {bf:probwidth()} and {bf:knownsds} " ///
	 	"may not both be specified"
		di as err "{p 4 4 2}Probability of CI width is not relevant" ///
" for the normal-based CI, which is computed when you specify option " ///
"{bf:knownsds}.{p_end}"
		exit 184
		}
		else if (`"`solvefor'"'=="probwidth") {
			di as err "{p}option {bf:knownsds} is not allowed " ///
			"when computing probability of CI width{p_end}"
			exit 198
		}
		if  (`"`equalsds'"'!="") {
			di as err "{p}options {bf:knownsds} and " ///
			"{bf:equalsds} may not be combined{p_end}"
			exit 184
		}
	}
	if (`"`equalsds'"'!="") {
		if (`hasprobw'==1) {
			di as err "{p}option {bf:equalsds} is not allowed " ///
			"when considering the distribution of sd{p_end}"
			exit 198
		}
	}

	mata: `pssobj'.initonparse("`diff'","`sd1'`sd2'","`knownsds'", ///
			"`equalsds'", "`normal'","`arg1'")
end
