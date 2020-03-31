*! version 1.2.0  13feb2019

program _pss_error

	gettoken type 0 : 0
	_pss_error_`type' `0'
end

program _pss_error_argsonetest
	args nargs solvefor methodname param
	if ("`solvefor'"=="n") {
		local calctype " to compute sample size"
	}	
	else if ("`solvefor'"=="k") {
		local calctype " to compute number of clusters"
	}	
	else if ("`solvefor'"=="m") {
		local calctype " to compute cluster size"
	}	
	else if ("`solvefor'"=="esize") {
		local calctype " to compute effect size"
	}	
	else if ("`solvefor'"=="power") {
		local calctype " to compute power"
	}	

	if ("`methodname'"=="regrsquared") {
		_pss_error_argsregrsqtest `nargs' `param' `solvefor'	///
			"`calctype'"
		exit
	}

	if (`nargs'==0) {
		if ("`solvefor'"=="esize") {
			di as err "{p}null `param' is required`calctype'" ///
			 "{p_end}"
			exit 198
		}
		else {
			di as err "{p}null `param' and alternative `param' " ///
			  "are required`calctype'{p_end}"
			exit 198
		}
	}
	else if (`nargs'==1 & "`solvefor'"!="esize") {
			di as err "{p}alternative `param' is " ///
			 "required`calctype'{p_end}"
			exit 198
	}
	else if (`nargs'>2) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
	}
	else if ("`solvefor'"=="esize" & `nargs'>1) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}Only null `param' is required`calctype'.  "
		di as err "If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
		
	}
end

program _pss_error_argsonealttest
	args nargs solvefor methodname param optargok
	if ("`solvefor'"=="n") {
		local calctype " to compute sample size"
	}	
	else if ("`solvefor'"=="esize") {
		local calctype " to compute effect size"
	}	
	else if ("`solvefor'"=="power") {
		local calctype " to compute power"
	}	

	if (`nargs'==0) {
		if ("`solvefor'"!="esize" & "`optargok'"=="") {
			di as err "{p}`param' is required`calctype'" ///
			 "{p_end}"
			exit 198
		}
	}
	else if (`nargs'>1) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses."
		if ("`methodname'"=="regrsqall") {
			di as err "If you want to test a subset of "
			di as err "coefficients, remember to specify "
			di as err "option {bf:ncontrol()}.{p_end}"

		}
		else di "{p_end}"
		exit 198
	}
	else if ("`solvefor'"=="esize" & `nargs'>0) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}The `param' may not be specified`calctype'."
		di as err "  If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses."
		if ("`methodname'"=="regrsqall") {
			di as err "If you want to test a subset of "
			di as err "coefficients, remember to specify "
			di as err "option {bf:ncontrol()}.{p_end}"

		}
		else di "{p_end}"
		exit 198
	}
end

program _pss_error_argstwotest
	args nargs solvefor methodname param optargsok
	if ("`optargsok'"=="") {
		local required "is required"
	}
	else {
		local required "may be specified"
	}
	if ("`solvefor'"=="n" | "`solvefor'"=="n1" | "`solvefor'"=="n2") {
		local calctype " to compute sample size"
	}	
	else if ("`solvefor'"=="k" | "`solvefor'"=="k1" | "`solvefor'"=="k2") {
		local calctype " to compute number of clusters"
	}	
	else if ("`solvefor'"=="m" | "`solvefor'"=="m1" | "`solvefor'"=="m2") {
		local calctype " to compute cluster size"
	}
	else if ("`solvefor'"=="esize") {
		local calctype " to compute effect size"
	}	
	else if ("`solvefor'"=="power") {
		local calctype " to compute power"
	}	

	if (`nargs'==0 & "`optargsok'"=="") {
		if ("`solvefor'"=="esize") {
			di as err "{p}control-group `param' is " ///
			 "required`calctype'{p_end}"
			exit 198
		}
		else {
			di as err "{p}control-group and experimental-group " ///
			 "`param's are required`calctype'{p_end}"
			exit 198
		}
	}
	else if (`nargs'==1 & "`solvefor'"!="esize" & "`optargsok'"=="") {
			di as err "{p}experimental-group `param' is " ///
			 "required`calctype'{p_end}"
			exit 198
	}
	else if (`nargs'>2) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
	}
	else if ("`solvefor'"=="esize" & `nargs'>1) {
		di as err "{p}too many command arguments specified{p_end}"
		di as err "{p 4 4 2}Only control-group `param' " ///
			  "`required'`calctype'.  "
		di as err "If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
		
	}
end

program _pss_error_iteroptsnotallowed

	_pss_syntax SYNITEROPTS : iteropts
	syntax [, `SYNITEROPTS' txt(string asis) * ]
	
	while ("`SYNITEROPTS'"!="") {
		gettoken iteropt SYNITEROPTS : SYNITEROPTS
		gettoken iteropt par : iteropt, parse("(")
		local iteropt = lower("`iteropt'")
		if (`"``iteropt''"'!="") {
			if ("`par'"!="") {
				local par "()"
			}
			di as err `"{p}option {bf:`iteropt'`par'} not allowed"'
			di as err `"`txt'{p_end}"'
			exit 198
		}
	}	
end

program _pss_error_optnotallowed
	args options

	if `"`options'"'!="" {
		gettoken opt : options, bind
		di as err `"option {bf:`opt'} not allowed"'
		exit 198
	}
end

program _pss_error_argsregrsqtest
	args nargs param solvefor calctype
	if (`nargs'==0) {
		if ("`solvefor'"=="esize") {
			di as err "{p}`param' of the reduced model is "	///
				"required`calctype'{p_end}" 
			exit 198
		}
		else {
			di as err "{p}`param' of the full and the " ///
				"reduced model are required`calctype'{p_end}"
			exit 198
		}
	}
	else if (`nargs'==1 & "`solvefor'"!="esize") {
			di as err "{p}`param' of the full model is " ///
			 "required`calctype'{p_end}"
			exit 198
	}
	if (`nargs'>2) {
		di as err "{p}too many command arguments specified.{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
	}
	else if ("`solvefor'"=="esize" & `nargs'>1) {
		di as err "{p}too many command arguments specified.{p_end}"
		di as err "{p 4 4 2}Only the `param' of the reduced model is " 
		di as err "required`calctype'.  "
		di as err "If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
		
	}
end
