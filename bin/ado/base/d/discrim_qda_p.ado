*! version 1.0.6  15oct2019
program discrim_qda_p
	version 10

	if "`e(cmd)'" != "discrim" | "`e(subcmd)'" != "qda" {
		error 301
	}
	if "`e(N_groups)'" == "" {
		di as err "e(N_groups) not found"
		exit 322
	}

	syntax anything(name=newvarlist id=newvarlist) [if] [in], [ ///
		Classification	/// group classification
		Pr		/// probabilities of group membership
		MAHalanobis	/// Mahalanobis distance squared to group
		CLSCore		/// classification function score
		LOOClass	/// leave-one-out group classification
		LOOPr		/// leave-one-out probabilities
		LOOMahal	/// LOO Mahalanobis distance squared to group
		LOOCLScore	/// undocumented: LOO discriminant scores 
		PRIors(string)	/// prior prob. (default to e(grouppriors))
		Group(string)	/// specifies a particular group
		TIEs(string)	/// ties
	]

	// Rules:
	//
	// -pr- with -group()- produces probabilities for the specified group
	// 	(i.e., expects 1 variable)
	//
	// -pr- without -group()- produces probabilities for the k groups
	//	(i.e., expects k variables)
	//
	// -mahalanobis-, -clscore-, -loopr-, -loomahal-, -looclscore-, act
	// like -pr-
	//	(1 var if -group()- specified or k vars otherwise)
	//
	// -classification- and -group()- are not allowed together;
	// 	-classification- expects 1 variable
	//
	// -looclass- acts like -classification-
	//
	// If -group()- is not specified and only 1 var is given then -group()-
	//	defaults to the first group
	//
	// The default is -classification- if only 1 var specified (and
	//	-group()- not specified); the default is -pr- if k vars
	//	specified or 1 var with -group()- option
	//
	// The options that begin with -loo- are allowed only on observations
	//	that are part of e(sample)

	// Mark which observations are to be predicted
	tempvar touse
	mark `touse' `if' `in'
	if "`looclass'`loopr'`loomahal'`looclscore'" != "" {
		// loo options further restricted to e(sample)
		qui replace `touse' = 0 if !e(sample)
	}

	// Get the list of new variables
	capture _stubstar2names `newvarlist', nvars(`e(N_groups)') singleok
	if c(rc) {
		if c(rc) == 102 & `"`group'"' != "" {
			error 103
		}
		else { // rerun to get error out
			_stubstar2names `newvarlist', ///
						nvars(`e(N_groups)') singleok
		}
	}
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `varlist'	// will be 1 or `e(N_groups)'

	// Set default statistic if not specified
	if "`classification'`pr'`mahalanobis'`clscore'`looclass'`loopr'`loomahal'`looclscore'" == "" {
		if `nvars' == 1 & `"`group'"' == "" {
			local classification classification
			local msg ///
			 "(option {bf:classification} assumed; group classification)"
		}
		else if `nvars' == 1 { // 1 var but also group() specified
			local pr pr
			local msg ///
			      "(option {bf:pr} assumed; group posterior probability)"
		}
		else {
			local pr pr
			local msg ///
			    "(option {bf:pr} assumed; group posterior probabilities)"
		}
	}

	// Check for options that are not allowed together etc.
	opts_exclusive "`classification' `pr' `mahalanobis' `clscore' `looclass' `loopr' `loomahal' `looclscore'"

	if `"`ties'"' != "" & "`classification'`looclass'" == "" {
		// ties() allowed only with -classification- or -looclass-
		opts_exclusive ///
	    "ties() `pr' `mahalanobis' `clscore' `loopr' `loomahal' `looclscore'"
	}
	discrim prog_utility ties, `ties'
	local ties `s(ties)'
	if `"`ties'"' == "nearest" {
		di as err "option {bf:ties(nearest)} not allowed"
		exit 198
	}

	if "`classification'" != "" & `"`group'"' != "" {
		di as err "options {bf:classification} and {bf:group()} may not be specified together"
		exit 198
	}
	if "`looclass'" != "" & `"`group'"' != "" {
		di as err "options {bf:looclass} and {bf:group()} may not be specified together"
		exit 198
	}

	if `nvars' > 1 & `"`group'"' != "" {
		di as err "option {bf:group()} not appropriate with multiple new variables"
		exit 198
	}
	if `nvars' > 1 & "`classification'" != "" {
		di as err "only one variable allowed with option {bf:classification}"
		exit 198
	}
	if `nvars' > 1 & "`looclass'" != "" {
		di as err "only one variable allowed with option {bf:looclass}"
		exit 198
	}

	// Take care of group() option
	if `"`group'"' == "" {
		numlist "1/`nvars'"
		local grplist `r(numlist)'
	}
	else {
		ParseGroup `group'
		local grplist `s(group)'
	}

	// Determine prior probabilities
	if "`classification'`looclass'" == "" {
				// wait until call back if classification
		tempname priormat
		if `"`priors'"' == "" {
			if `"`e(grouppriors)'"' != "matrix" {
				di as err "matrix e(grouppriors) not found"
				exit 322
			}
			mat `priormat' = e(grouppriors)
			local redoC 0
		}
		else {
			tempname gcntmat
			if `"`e(groupcounts)'"' != "matrix" {
				di as err "matrix e(groupcounts) not found"
				exit 322
			}
			mat `gcntmat' = e(groupcounts)
			discrim prog_utility priors ///
					`"`priors'"' `e(N_groups)' `gcntmat'
			mat `priormat' = r(grouppriors)
			local redoC 1
		}
	}

	// Compute the predictions

	forvalues i = 1/`nvars' {
		tempvar tmp
		local tmpvlist `tmpvlist' `tmp'
	}

	if "`classification'`looclass'" != "" {	//-classification- or -looclass-
		forvalues i=1/`e(N_groups)' {
			tempname tmp`i'
			local tmps `tmps' `tmp`i''
		}
		if `"`priors'"' != "" {
			local propt `"priors(`priors')"'
		}
		if "`classification'" != "" {
			// call back through to get probabilities
			qui predict double `tmps', pr `propt'

			local vlab1 "classification"
		}
		else {	// looclass
			// call back through to get LOO probabilities
			qui predict double `tmps', loopr `propt'

			local vlab1 "LOO classification"
		}

		// generates `tmpvlist' variable and sets r(N_ties) to # ties
		qui discrim prog_utility assigngroup ///
				"`tmpvlist'" "`tmps'" "`touse'" "`ties'"

		local nties = r(N_ties)
		if `nties' {
			if "`msg'" != "" di as txt "`msg'" // this comes first
			local msg	// erase so won't appear again later
			di as txt "Warning: " as res "`nties' " ///
				as txt plural(`nties',"tie") " encountered"
			di as txt "ties are assigned to " _c
			if "`ties'" == "missing" {
				di as txt "missing values"
			}
			else if "`ties'" == "first" {
				di as txt "the first tied group value"
			}
			else if "`ties'" == "random" {
				di as txt "a random tied value"
			}
		}

		capture drop `tmps'
	}
	else if ///
	   "`pr'`loopr'`mahalanobis'`loomahal'`clscore'`looclscore'" != "" {
		if `nvars' == 1 {
			// set up tempvars for all N_groups even though we
			// only want pr for one group
			local holdgrpl `grplist'
			local nvars `e(N_groups)'
			local tmpvlist
			forvalues i=1/`nvars' {
				tempvar tmp
				local tmpvlist `tmpvlist' `tmp'
			}
		}
		forvalues i=1/`nvars' {
			if "`pr'" != "" {
				local vlab`i' "group`i' posterior probability"
			}
			else if "`loopr'" != "" {
				local vlab`i' ///
					"group`i' LOO posterior probability"
			}
			else if "`mahalanobis'" != "" {
				local vlab`i' ///
					"group`i' Mahalanobis squared distance"
			}
			else if "`loomahal'" != "" {
				local vlab`i' ///
				    "group`i' LOO Mahalanobis squared distance"
			}
			else if "`clscore'" != "" {
				local vlab`i' "group`i' classification score"
			}
			else if "`looclscore'" != "" {
				local vlab`i' ///
					"group`i' LOO classification score"
			}
		}

		foreach v of local tmpvlist {
			qui gen double `v' = .
		}

		if "`pr'" != "" {
			mata: _discrim_qdaMahal("`priormat'", ///
						"`tmpvlist'","`touse'", 1)
		}
		else if "`mahalanobis'" != "" {
			mata: _discrim_qdaMahal("`priormat'", ///
						"`tmpvlist'","`touse'", 0)
		}
		else if "`clscore'" != "" {
			mata: _discrim_qdaMahal("`priormat'", ///
						"`tmpvlist'","`touse'", 2)
		}
		else if "`loopr'" != "" {
			mata: _discrim_qdaLoo("`priormat'", ///
						"`tmpvlist'", "`touse'", 1)
		}
		else if "`loomahal'" != "" {
			mata: _discrim_qdaLoo("`priormat'", ///
						"`tmpvlist'", "`touse'", 0)
		}
		else {	// -looclscore-
			mata: _discrim_qdaLoo("`priormat'", ///
						"`tmpvlist'", "`touse'", 2)
		}

		if "`holdgrpl'" != "" {
			local nvars 1
			local tmpvlist : word `holdgrpl' of `tmpvlist'
			local vlab1 `vlab`holdgrpl''
		}
	}
	else {				// should never reach inside here
		di as err "internal error in discrim_qda_p"
		exit 9935
	}

	// At this point data successfully generated in `tmpvlist' variables
	// transfer them to user requested variables (and of requested type)
	if "`msg'" != "" di as txt "`msg'"
	forvalues i = 1/`nvars' {
		`myqui' gen `: word `i' of `typlist'' ///
			    `: word `i' of `varlist'' ///
			  = `: word `i' of `tmpvlist'' if `touse'
		drop `: word `i' of `tmpvlist''
		label var `: word `i' of `varlist'' `"`vlab`i''"'
		// all but first time done quietly so only 1 missings message
		local myqui quietly
	}
end

program ParseGroup, sclass
	sreturn clear
	local grparg `"`0'"'
	local ngrps = e(N_groups)

	if `"`grparg'"' == "" {
		// default to first group
		local ans 1
	}
	else if bsubstr(`"`grparg'"',1,1) == "#" {
		// Using #1 style of specifying the group
		local ans = bsubstr(`"`grparg'"',2,.)
		capture confirm integer number `ans'
		if c(rc) {
			di as err "invalid option {bf:group()}"
			di as err "`ans' found where integer expected"
			exit 7
		}
		if `ans' < 1 | `ans' > `ngrps' {
			di as err "invalid option {bf:group()}"
			di as err ///
			 "`ans' found where positive integer < `ngrps' expected"
			exit 7
		}
	}
	else { 
		capture confirm integer number `grparg'
// if not a number, see if it matches one of the group labels in e(grouplabels)
		if _rc {
			local glabs `"`e(grouplabels)'"'
			local ans : list posof `"`grparg'"' in glabs
			if `ans' == 0 {
				di as err "invalid option {bf:group()}"
				exit 198
			}
		}
		else { // value of variable
			tempname gv
			mat `gv' = e(groupvalues)
			local cols = colsof(`gv')
			local ans 0
			forvalues i = 1/`cols' {
				if reldif(`grparg', `gv'[1,`i']) < 1e-6 {
					local ans `i'
				}
			}
			if `ans' == 0 {
				di as err "invalid option {bf:group()}"
				exit 198
			}
		}
		
	}

	sreturn local group `ans'
end
