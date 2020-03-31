*! version 1.1.0  13mar2018

program _parse_gmm_optim_opts, sclass
	version 14
	syntax, [ TECHnique(string) conv_maxiter(string) conv_ptol(string) ///
		conv_vtol(string) conv_nrtol(string) tracelevel(string)    ///
		TOLerance(string) NRTOLerance(string) ITERate(string) ///
		NOLOg LOg * ]

	/* synonyms:							*/
	/* 	iterate() & conv_maxiter()				*/
	/*	tolerance() & conv_ptol()				*/
	/*	nrtolerance() & conv_nrtol()				*/

	if "`conv_maxiter'"!="" & "`iterate'"!="" {
		di as err "{p}options {bf:conv_maxiter()} and " ///
		 "{bf:iterate()} cannot both be specified{p_end}"
		exit 184
	}
	if "`conv_maxiter'"=="" & "`iterate'"=="" {
		local conv_maxiter = `c(maxiter)'
	} 
	else {
		local n `iterate'`conv_maxiter'
		cap confirm integer number `n'
		local rc = c(rc)
		if !`rc' {
			local rc = ((`n'<0) | (`n'>16000))
		}
		if `rc' {
			local which = cond("`conv_maxiter'"!="", ///
				"conv_maxiter", "iterate")
			di as err "{bf:`which'({it:#})} must be between 0 " ///
			 "and 16000"
			exit 198
		}
		local conv_maxiter = `n'
	}

	if "`conv_ptol'"!="" & "`tolerance'"!="" {
		di as err "{p}options {bf:conv_ptol()} and " ///
		 "{bf:tolerance()} can not both be specified{p_end}"
		exit 184
	}
	if "`conv_ptol'"=="" & "`tolerance'"=="" {
		local conv_ptol = 1e-6
	}
	else {
		local n `tolerance'`conv_ptol'
		cap confirm number `n'
		local rc = c(rc)
		if (`rc') local rc = 198
		else local rc = cond(`n'>0,0,411)

		if `rc' {
			local which = cond("`conv_ptol'"!="","conv_ptol", ///
					"tolerance")
			di as err "{p}{bf:`which'({it:#})} must be greater " ///
			 "than zero{p_end}"
			exit `rc'
		}
		local conv_ptol = `n'
	}

	if "`conv_nrtol'"!="" & "`nrtolerance'"!="" {
		di as err "{p}options {bf:conv_nrtol()} and " ///
		 "{bf:nrtolerance()} cannot both be specified{p_end}"
		exit 184
	}
	if "`conv_nrtol'"=="" & "`nrtolerance'"=="" {
		local nrt = 0
		local conv_nrtol = 1e-5
	}
	else {
		local n `nrtolerance'`conv_nrtol'
		cap confirm number `n'
		local rc = c(rc)
		if (`rc') local rc = 198
		else local rc = cond(`n'>0,0,411)

		if `rc' {
			local which = cond("`conv_nrtol'"!="","conv_nrtol", ///
					"nrtolerance")
			di as err "{bf:`which'({it:#})} must be greater " ///
			 "than zero{p_end}"
			exit `rc'
		}
		local conv_nrtol = `n'
		local nrt = 1
	}	
	if "`conv_vtol'" == "" {
		local conv_vtol = 1e-7
	}
	else {
		cap confirm number `conv_vtol'
		local rc = c(rc)
		if (`rc') local rc = 198
		else local rc = cond(`conv_vtol'>0,0,411)

		if `rc' {
			di as err "{p}{bf:conv_vtol({it:#})} must be " ///
			 "greater than zero{p_end}"
			exit `rc'
		}
	}
	
	local valid "nr dfp bfgs bhhh gn nm"
	if "`technique'" == "" {
		local technique "gn"
	} 
	else if "`:list technique & valid'" == "" {
		di as err "invalid technique in {bf:technique()}"
		exit 198
	}
	local allowed "nr dfp bfgs gn"
	if "`:list technique & allowed'" == "" {
		di as err "{bf:technique(`technique')} not supported by " ///
		 "{bf:gmm}"
		exit 198
	}
	if `nrt' & "`technique'"=="gn" {
		di as err "{p}option {bf:conv_nrtol()} is not allowed when " ///
		 "using the Gauss-Newton algorithm, {bf:technique(gn)}{p_end}"
		exit 198
	}
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" & "`tracelevel'"=="" {
		local tracelevel "none"
	}
	local allowed "none value tolerance params step gradient hessian"
	if "`tracelevel'" == "" {
		local tracelevel "value"
	}
	else if "`:list tracelevel & allowed'" == "" {
		di as err "invalid specification in {bf:tracelevel()}"
		exit 198
	}
	if "`technique'" == "gn" & "`tracelevel'" == "hessian" {
		di as err "{p}cannot specify {bf:tracelevel(hessian)} " ///
		 "with Gauss-Newton optimization{p_end}"
		exit 198
	}

	sreturn local options `options'
	sreturn local technique `technique'
	sreturn local conv_maxiter `conv_maxiter'
	sreturn local conv_ptol `conv_ptol'
	sreturn local conv_vtol `conv_vtol'
	sreturn local conv_nrtol `conv_nrtol'
	sreturn local tracelevel `tracelevel'
end

exit
