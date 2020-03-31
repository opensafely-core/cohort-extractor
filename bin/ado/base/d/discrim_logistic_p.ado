*! version 1.0.6  15oct2019
program discrim_logistic_p
	version 10

	if "`e(cmd)'" != "discrim" | "`e(subcmd)'" != "logistic" {
		error 301
	}
	if "`e(N_groups)'" == "" {
		di as err "e(N_groups) not found"
		exit 322
	}

	syntax anything(name=newvarlist id=newvarlist) [if] [in], [ ///
		Classification	/// group classification
		Pr		/// probabilities of group membership
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
	// -classification- and -group()- are not allowed together;
	// 	-classification- expects 1 variable
	//
	// If -group()- is not specified and only 1 var is given then -group()-
	//	defaults to the first group
	//
	// The default is -classification- if only 1 var specified (and
	//	-group()- not specified); the default is -pr- if k vars
	//	specified or 1 var with -group()- option

	// Mark which observations are to be predicted
	tempvar touse
	mark `touse' `if' `in'

	local ngp = e(N_groups)
	local ibase = e(ibaseout)

	// Get the list of new variables
	capture _stubstar2names `newvarlist', nvars(`ngp') singleok
	if c(rc) {
		if c(rc) == 102 & `"`group'"' != "" {
			error 103
		}
		else { // rerun to get error out
			_stubstar2names `newvarlist', nvars(`ngp') singleok
		}
	}
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `varlist'	// will be 1 or `ngp'

	// Set default statistic if not specified
	if "`classification'`pr'" == "" {
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
	opts_exclusive "`classification' `pr'"

	if `"`ties'"' != "" & "`classification'" == "" {
		// ties() allowed only with -classification-
		opts_exclusive "ties() `pr'"
	}
	discrim prog_utility ties , `ties'
	local ties `s(ties)'
	if "`ties'" == "nearest" {
		di as err "option {bf:ties(nearest)} not allowed"
		exit 198
	}

	if "`classification'" != "" & `"`group'"' != "" {
		di as err "options {bf:classification} and {bf:group()} may not be specified together"
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
	if "`classification'" == "" { // wait until call back if classification
		tempname priormat
		if `"`priors'"' == "" {
			if `"`e(grouppriors)'"' != "matrix" {
				di as err "matrix e(grouppriors) not found"
				exit 322
			}
			mat `priormat' = e(grouppriors)
		}
		else {
			tempname gcntmat
			if `"`e(groupcounts)'"' != "matrix" {
				di as err "matrix e(groupcounts) not found"
				exit 322
			}
			mat `gcntmat' = e(groupcounts)
			discrim prog_utility priors `"`priors'"' `ngp' `gcntmat'
			mat `priormat' = r(grouppriors)
		}
	}


	// Compute the predictions

	forvalues i = 1/`nvars' {
		tempvar tmp
		local tmpvlist `tmpvlist' `tmp'
	}

	if "`classification'" != "" {	// -classification-
		forvalues i=1/`ngp' {
			tempname tmp`i'
			local tmps `tmps' `tmp`i''
		}
		if `"`priors'"' != "" {
			local propt `"priors(`priors')"'
		}

		// call back through to get probabilities
		qui predict double(`tmps'), pr `propt'

		local vlab1 "classification"

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
	else if "`pr'" != "" {
		if `nvars' == 1 {
			// set up tempvars for all N_groups even though we
			// only want pr for one group
			local holdgrpl `grplist'
			local tmpvlist
			forvalues i=1/`ngp' {
				tempvar tmp
				local tmpvlist `tmpvlist' `tmp'
			}
			local nvars `ngp'
		}
		forvalues i=1/`ngp' {
			local vlab`i' "group`i' posterior probability"
		}

		// adjust _cons coefficients for priors
		tempname newb
		mat `newb' = e(b)
		mata: _discrim_DoAdj("`newb'", "`priormat'")

		// do probability predictions
		local ateq 0
		forvalues i = 1/`ngp' {
			local v : word `i' of `tmpvlist'
			if `i' != `ibase' {
				local ++ateq
				qui matrix score double `v' ///
					= `newb' if `touse' , eq(#`ateq')
				qui replace `v' = exp(`v') if `touse'
			}
			else {
				qui gen byte `v' = 1 if `touse'
			}

			// no equal sign here (evaluated later)
			local doit `doit' + `v'
		}

		tempname suml
		qui gen double `suml' = 0 `doit' if `touse'
		forvalues i = 1/`ngp' {
			local v : word `i' of `tmpvlist'
			qui replace `v' = `v' / `suml'
		}

		if "`holdgrpl'" != "" {
			local nvars 1
			local tmpvlist : word `holdgrpl' of `tmpvlist'
			local vlab1 `vlab`holdgrpl''
		}
	}
	else {				// should never reach inside here
		di as err "internal error in discrim_logistic_p"
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

