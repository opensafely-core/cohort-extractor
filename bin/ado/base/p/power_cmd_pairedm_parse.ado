*! version 1.1.0  11jan2019
program power_cmd_pairedm_parse
	version 13

	syntax [anything] [, test ci * ]
	local type `test' `ci'
	_power_pairedm_`type'_parse `anything', `options' `type'

end


program _power_pairedm_test_parse

	syntax [anything(name=args)] , pssobj(string) [ ONESIDed knownsd ///
					fpc(string) normal * ]
	local 0 , `options' `onesided' `knownsd' fpc(`fpc') `normal'

	mata: st_local("solvefor", `pssobj'.solvefor)

	//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if ("`knownsd'`normal'"=="" | "`onesided'"=="" |	///
		    `"`fpc'"'!="") {
			local isiteropts 1
			local star init(string) *
			local validate n
		}
		else { 
			local msg "sample size for a one-sided test"
			local msg "`msg' with known standard deviation"
			local msg "`msg' and infinite sample size"
		}
		local solveformsg "sample-size"
		local validate n
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
		local solveformsg "effect-size"
	}
	else if ("`solvefor'"=="power") {
		local msg power
		 local solveformsg "power"
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : onetest
	syntax [, 	`SYNOPTS'		///
			NULLdiff(string)	///
			ALTdiff(string)		///
			sddiff(string)		///
			sd(string)		///
			sd1(string)		///
			sd2(string)		///
			CORR(string)		///
			KNOWNSD			///
			NORMAL			/// //undoc.
			fpc(string)		///
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
	local ka1 = 0
	local ka2 = 0
	if `"`arg1'"'!="" {
		cap numlist `"`arg1'"'
		if c(rc) {
			di as err "{p}pretreatment mean must be a number"
			exit 198
		}
		local ++nargs
		local a1list `r(numlist)'
		local ka1 : list sizeof a1list
	}
	if `"`arg2'"'!="" {
		cap numlist `"`arg2'"'
		if c(rc) {
			di as err "{p}posttreatment mean must be a number"
			exit 198
		}
		local ++nargs
		local a2list `r(numlist)'
		local ka2 : list sizeof a2list

		if `ka1'==1 & `ka2'==1 {
			if reldif(`a1list',`a2list') < 1e-10 {
				di as err "{p}pretreatment and "           ///
				 "posttreatment means are equal; this is " ///
				 "not allowed{p_end}"
				exit 198
			}
		}
	}
	if `"`args'"'!="" {
		local ++nargs
	}
	if (`nargs' > 2) {
		di as err "{p}too many arguments specified{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, " ///
		 "remember to enclose them in parentheses.{p_end}"
                exit 198
	}

	// check arguments, nulldiff() and altdiff()
	local knl = 0
	if (`"`nulldiff'"'!="") {
		cap numlist `"`nulldiff'"'
		if (_rc) {
			di as err "{bf:nulldiff()} must contain numbers"
			exit 198
		}
		local nllist `r(numlist)'
		local knl : list sizeof nllist
		if `knl'==1 & `ka1'==1 & `ka2'==1 {
			tempname adiff

			scalar `adiff' = `a2list'-`a1list'
			if reldif(`nllist',`adiff') < 1e-10 {
				di as err "{p}difference between the "      ///
				 "posttreatment and pretreatment means is " ///
				 "equal to the {bf:nulldiff(`nllist')}; "   ///
				 "this is not allowed{p_end}"
				exit 198
			}
		}
	}

	if (`"`altdiff'"'!="") {
		if (`nargs'>1) {
			di as err "{p}option {bf:altdiff()} may not be " ///
			 "used in a combination with pretreatment and " ///
			 "posttreatment means{p_end}"
			exit 184
		}
		cap numlist `"`altdiff'"'
		if (_rc) {
			di as err "{bf:altdiff()} must contain numbers"
			exit 198
		}
		local adlist `r(numlist)'
		local kad : list sizeof adlist
		if `kad' == 1 {
			if abs(`adlist') < 1e-10 {
				di as err "{p}invalid "                 ///
				 "{bf:altdiff(`adlist')}; zero is not " ///
				 "allowed{p_end}" 
				exit 198
			}
		}
		if `kad'==1 & `knl'==1 {
			if (reldif(`adlist',`nllist') < 1e-10) {
				di as err "{p}{bf:altdiff(`adlist')} is "  ///
				 "equal to {bf:nulldiff(`nllist')}; this " ///
				 "is not allowed{p_end}"
				exit 198
			}
		}
		if ("`solvefor'"=="esize") {
			di as err "{p}{bf:altdiff()} is not allowed " ///
			 "when computing effect-size{p_end}"
			exit 198
		}
		else {
			if (`nargs'==2) {
				di as err "{p}{bf:altdiff()} cannot be "   ///
				 "specified with the posttreatment mean{p_end}"
				exit 184
			}
		}
	}
	else if ("`solvefor'"!="esize" & `nargs'==1) {
		di as err "{p}either option {bf:altdiff()} or "      ///
		 "alternative posttreatment mean must be specified " ///
		 "when computing `solveformsg'{p_end}"
		exit 198
	} 
	else if ("`solvefor'"!="esize" & `nargs'==0) {
		di as err "{p}either option {bf:altdiff()} or alternative " ///
		 "means must be specified when computing `solveformsg'{p_end}"
		exit 198
	}
	if ("`solvefor'"=="esize" & `nargs'>1) {
		di as err "{p}too many arguments specified for effect-size " ///
		 "computation.{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, " ///
		 "remember to enclose them in parentheses.{p_end}"
		exit 198
	}
	if ("`solvefor'"=="esize" & "`init'"!="" & `ka1'==1) {
		_pss_chk_init "pretreatment mean" "`init'" "`a1list'" ///
			"`direction'"
	}
	
	if (`"`sd'"'!="") {
		if (`"`sd1'`sd2'"'!="") {
			di as err "options {bf:sd1()} and {bf:sd2()} " ///
			 "cannot be specified with {bf:sd()}"
			exit 184
		}
		local which {bf:sd()}
		cap numlist `"`sd'"', range(>0)
		if (_rc) {
			di as err "{bf:sd()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`sd1'"'!="") {
		local which {bf:sd1()}
		cap numlist `"`sd1'"', range(>0)
		if (_rc) {
			di as err "{bf:sd1()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`sd2'"'!="") {
		if ("`which'"!="") local which "`which' and "
		local which `which' {bf:sd2()}

		cap numlist `"`sd2'"', range(>0)
		if (_rc) {
			di as err "{bf:sd2()} must contain positive numbers"
			exit 198
		}
	}
	if (`"`corr'"'!="") {
		if (`"`sddiff'"'!="") {
			di as err "{p}{bf:corr()} and {bf:sddiff()} cannot " ///
			 "both be specified{p_end}"
			exit 184
		}
		cap numlist `"`corr'"', range(>-1 <1)
		if (_rc) {
			di as err "{p}{bf:corr()} must contain numbers " ///
			 "greater than -1 and less than 1{p_end}"
                        exit 198
		}
	}
	else if (`"`sddiff'"'!="") {
		if ("`which'" != "") {
			di as err "{p}`which' cannot be specified with " ///
			 "{bf:sddiff()}{p_end}"
			exit 184 
		}
		cap numlist `"`sddiff'"', range(>0)
		if (_rc) {
			di as err "{bf:sddiff()} must contain positive numbers"
			exit 198
		}
	}
	else if ("`which'" != "") {
		di as err "{p}{bf:corr()} must be specified with `which'{p_end}"
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
				di as err "{p}invalid {bf:init(`init')}; " ///
				 "value is greater than or equal to the "  ///
				 "population size specified in "           ///
				 "{bf:fpc(`_fpc')}{p_end}"
				exit 198
			}
		}
	}
	mata: `pssobj'.initonparse("`arg1'", "`corr'", "`sd'",	///
				   "`sd1'", "`sd2'", 		///
				   `"`fpclab'"', `"`fpcsym'"',	///
				   "`knownsd'", "`normal'")
end
