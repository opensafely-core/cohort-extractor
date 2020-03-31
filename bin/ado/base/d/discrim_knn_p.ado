*! version 1.0.8  21oct2019
program define discrim_knn_p, sortpreserve
	version 10.0

/*  var1 with options -pr- and -group()- produces 1 new variables
		depending on the number in group (numlist has ng things in it)
    stub* with -pr- and group() produces an error
    stub* with -pr- and no group() produces 1..ng new variables where
		ng is the number of groups possible from e(N_groups)
    stub* with -cl- creates an error
    var1..varN with -pr- and no group() expects N == e(N_groups)
*/

/* Parse. */

/* a few options are in ParseNewVarsPlus */
	ParseNewVarsPlus `0'
	local varspec `s(varspec)'
	local newvarlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `newvarlist'
	local group `"`s(group)'"'
	local pr `s(pr)'
	local class `s(class)'
	local loo `s(loo)'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local options `"`s(options)'"'

/* the remainder are parsed in Parse Options */
	ParseOptions, `options' `pr' `loo'
	local priors  `s(priors)' // prior probabilities
	local ties `s(ties)'   // how to handle ties
	local darg `s(darg)'   // argument (e.g. L(3) would be (3)) undoc'd
	local dtype `s(dtype)' // distance type similarity or dissimilarity 
	local dname `s(dname)' // distance name undocumented meas() opt
	local s2d   `s(s2d)'   // s2d transform undocumented
	local mahal `s(mahal)' // mahalanobis distance undocumented
	local noup  `s(noup)'  // noupdate option mahalanobis & loo

	if `"`s2d'"' == "" {
		if "`e(s2d)'" == "" {
			local s2d none
		}
		else {
			local s2d `e(s2d)'
		}
	}
	local dname _dis_`dname'
	if "`loo'" == "" {
		local loo noloo
	}
	if `"`group'"' != "" {
		tempname grmat
		foreach word of local group {
			mat `grmat' = (nullmat(`grmat'), `word')
		}
	} 
	else {
		tempname grmat
		mat `grmat' = (1)
	}
		

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
		discrim prog_utility priors `"`priors'"' `e(N_groups)' `gcntmat'
		mat `priormat' = r(grouppriors)
	}
	local varlist `e(varlist)'
	marksample touse

	if "`loo'" == "loo" {
		capture confirm variable `e(groupvar)'
		local groupvar `e(groupvar)'
		local rc = _rc
		if `rc' {
			di as err "`e(groupvar)' does not exist "
			exit 459
		}
		quietly count if e(sample)
		if r(N) == 0 {
			local i 1
			foreach word of local newvarlist {
				local type : word `i' of `typlist'
				local grp : word `i' of `group'
				gen `type' `word' = .
				local ++i
				if "`pr'"=="" {
					label variable `word' 	///
					"LOO classification"
				}
				else {
					label variable `word' ///
					"group`grp' LOO posterior probability"
				}
			}
			exit 0
		}
	}

	local coln : colnames e(community)
	local k = e(k_nn)
	confirm integer number `k'
	assert `k' > 0
	local N_groups = `e(N_groups)'
	tokenize `coln'
	local fwgt `1'
	mac shift
	local ind `1'
	mac shift
	local coln `*'

	confirm variable `coln'

	local xbind 0
	if `"`pr'"'==""  local xbind 1
	if "`darg'" == "" {
		mata: _discrim_knnPcomp("`touse'", `k', `N_groups', `"`grmat'"', `"`priormat'"', `"`coln'"', `"`typlist'"', `"`newvarlist'"', `nvars', `xbind', "`ties'", "`loo'", "`s2d'", `"`mahal'"', `"`noup'"', `"`groupvar'"', &`dname'())
	}
	else {
		mata: _discrim_knnPcomp("`touse'", `k', `N_groups', `"`grmat'"', `"`priormat'"', `"`coln'"', `"`typlist'"', `"`newvarlist'"', `nvars', `xbind', "`ties'", "`loo'", "`s2d'", `"`mahal'"', `"`noup'"', `"`groupvar'"', &`dname'(), `"`darg'"')
	}
	local i 1
	foreach word of local newvarlist {
		local grp : word `i' of `group'
		if `"`loo'"' == "loo" {
			local LOO "LOO "
		}
		if "`pr'"=="" {
			label variable `word' 	///
			"`LOO'classification"
		}
		else {
			label variable `word' ///
			"group`grp' `LOO'posterior probability"
		}
		local ++i
	}
	qui count if `: word 1 of `newvarlist''>=.
	if r(N) > 0 {
		di as text "("  r(N) " missing " ///
				plural(r(N), "value") " generated)"
	}
end

program ParseNewVarsPlus, sclass
	syntax [anything(name=vlist)] [if] [in] [, Group(string) ///
			Classification Pr LOOClass LOOPr * ]
	local myif `"`if'"'
	local myin `"`in'"'
	local myopts `"`options'"'

	local classify `classification'
	opts_exclusive "`classify' `pr' `looclass' `loopr'"
	if `"`looclass'"' != "" | `"`loopr'"' != "" {
		local loo loo
		if `"`looclass'"' != "" {
			local classify classification
		}
		else local pr pr
		if "`myif'" != "" {
			local myif `if' & e(sample)
		}
		else local myif if e(sample)
	}
	if "`pr'" == "" & `"`classify'"' == "" {
		if "`group'" == "" {
			noi di in green "(option {bf:classification} assumed;" ///
				" group classification)"
			local classify classification
		}
		else {
			noi di in green "(option {bf:pr} assumed;" ///
				" group posterior probability)"
			local pr pr
		}
	}
	opts_exclusive "`classify' `pr'"
	if `"`classify'"' != "" & `"`group'"' != "" {
		di as err "options {bf:classification} and {bf:group()} may not be specified together"
		exit 198
	}

	if `"`vlist'"' == "" {
		di as err "{it:varlist} required"
		exit 100
	}
	local varspec `"`vlist'"'
	local ng : word count `group'
	if `"`pr'"' != "" & `"`group'"' == "" {
		local neq = e(N_groups)
		local ng `neq'
	}
	local stub 0
	if strpos("`vlist'","*") {
		if "`classify'" != "" {
			noi di as err "only one variable allowed with "	///
				"option {bf:classification}"
			exit 198
		}
		if "`group'" != "" {
			noi di as err "option {bf:group()} not appropriate with "	///
				"multiple new variables"
			exit 198
		}
		_stubstar2names `vlist', nvars(`ng')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		syntax newvarlist [if] [in] [, * ]
	}
	local nvars : word count `varlist'

	if `"`classify'"' != "" & `nvars' > 1 {
		noi di as err	///
		"only one variable may be specified with option {bf:classification}"
		exit 198
	}

	if `ng' != `nvars' & "`pr'" != "" {
		di as err	///
	"incorrect number of variables specified: specified `nvars', need `ng'"
		exit 198
	}
	else if `"`pr'"' != "" & `"`group'"' == "" {
		numlist "1/`nvars'"
		local group `r(numlist)'
	}
	else {
		ParseGroup `group'
		local group `s(group)'
	}


	sreturn clear
	sret local pr `pr'
	sret local class `classify'
	sret local loo `loo'
	sreturn local varspec `varspec'
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
	sret local group `group'
	sreturn local if `"`myif'"'
	sreturn local in `"`myin'"'
	sreturn local options `"`myopts'"'
end

program ParseOptions, sclass
	syntax [, PRIors(string) /// prior prob. (default to e(grouppriors))
		  ties(str)	 /// ties
		  Pr		 /// probabilities
		  NOUPdate	 /// do not update with LOO and mahalanobis
		  loo		 /// leave one out, defined in ParseNewVars	
		/// undocumented next 3
		  MAHalanobis	 /// mahalanobis distance undocumented
		  s2d(str)	 /// similarity to dissimilarity undocumented
		  MEAsure(str)	 /// distance measure undocumented
	]
	sret clear
	if `"`ties'"'!="" & `"`pr'"'!="" {
		di as err "option {bf:ties()} allowed only with "	///
			"options {bf:classification} or {bf:looclass}"
		exit 198
	}
	discrim prog_utility ties , `ties'
	local ties `s(ties)'
	if `"`measure'"' != "" {
		parse_dissim `measure'
		local dname `s(dist)'
		local dtype `s(dtype)'
		local darg `s(darg)'
		local dbin `s(binary)'
	}
	else {
		local dname `e(measure)'
		local dtype `e(measure_type)'
		local darg `e(measure_arg)'
		local dbin `s(measure_binary)'
	}
	if `"`s2d'"' != "" { // 1) if s2d specified check no prob with meas()
		if "`dtype'" == "dissimilarity" {
			di as err "option {bf:s2d()} not allowed with a " 	///
				"dissimilarity measure"
			exit 198
		}
	}
	if "`s2d'" == "" { // 2) if not specified, go get from e()
		local s2d `e(s2d)'
	}
	if "`s2d'" != "" { // 3) if now defined, check syntax
		mds_parse_s2d `s2d'
		local s2d `s(s2d)'
	}
	else if "`dtype'" == "similarity" { // and if not defined, but needed
		local s2d standard	    // define it as standard
	}
	if `"`mahalanobis'"' == "" {
		local mahalanobis `e(mahalanobis)'
	}
	if "`mahalanobis'" != "" && "`dbin'" == "binary" {
		di as err "mahalanobis distance not valid with binary measures"
		exit 198
	}
	if `"`noupdate'"' != "" & (`"`mahalanobis'"'=="" | `"`loo'"'=="") {
		di as err "{p 0 0 2}option {bf:noupdate} only valid "	///
			"with Mahalanobis distance and options "		///
			"{bf:looclass} or {bf:loopr}{p_end}"
		exit 198
	}

	sret local priors `priors'
	sret local ties `ties'
	sret local darg `darg'
	sret local dtype `dtype'
	sret local dname `dname'
	sret local s2d `s2d'
	sret local mahal `mahalanobis'
	sret local noup `noupdate'
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
			di as err "{bf:`ans'} found where integer expected"
			exit 7
		}
		if `ans' < 1 | `ans' > `ngrps' {
			di as err "invalid option {bf:group()}"
			di as err ///
			 "{bf:`ans'} found where positive integer < `ngrps' expected"
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

