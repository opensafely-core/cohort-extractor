*! version 1.1.5  09sep2019

/* -------------------------------------------------------------------- */
					/* top level, -ssd-		*/
program ssd, byable(onecall)
	version 12

	if _by() {
		di as err "summary statistics data may not be combined with by"
		exit 109
	}

	gettoken cmd rest : 0, parse(" ,")
	local l = strlen("`cmd'")

	if ("`cmd'"==bsubstr("addgroup", 1, max(5, `l'))) {
		ssd_addgroup `rest'
		exit
	}
	if ("`cmd'"==bsubstr("describe", 1, max(1, `l'))) {
		ssd_describe `rest'
		exit
	}
	if ("`cmd'"==bsubstr("initialize", 1, max(4, `l'))) {
		ssd_initialize `rest'
		exit
	}
	if ("`cmd'"==bsubstr("list", 1, max(1, `l'))) {
		ssd_list `rest'
		exit
	}
	if ("`cmd'"==bsubstr("query", 1, max(1, `l'))) {
		ssd_query `rest'
		exit
	}
	if ("`cmd'"=="repair") {
		ssd_repair `rest'
		exit
	}
	if ("`cmd'"=="set") {
		ssd_set `rest'
		exit
	}
	if ("`cmd'"==bsubstr("status", 1, max(4, `l'))) {
		ssd_status `rest'
		exit
	}
	if ("`cmd'"==bsubstr("unaddgroup", 1, max(7, `l'))) {
		ssd_unaddgroup `rest'
		exit
	}
	if ("`cmd'"=="build") {
		ssd_build `rest'
		exit
	}

	if ("`cmd'"=="") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "{bf:ssd} must be followed by a subcommand."
		di as err "You might type {bf:ssd query},"
		di as err "{bf:ssd init}, {bf:ssd set covariances}, etc."
		di as err "{p_end}"
		exit(199)
	}

	capture noisily ssd_`cmd' `rest'
	if (_rc == 199) {
		di as err "unknown {cmd:ssd} subcommand {bf:ssd `cmd'}"
	}
	exit _rc
end


/* ==================================================================== */
					/* ssd subcommands		*/

/* -------------------------------------------------------------------- */
					/* ssd initialize		*/
/*
	ssd initialize <newvarnames> 
*/

program ssd_initialize
	/* ------------------------------------------------------------ */
					/* no observations in memory	*/
	if (c(k) | c(N)) {
		error 4
	}

	/* ------------------------------------------------------------ */
					/* parse input   		*/

	parse_name_ops names ops : `"`0'"'
	local 0 `ops'
	syntax [, WECOULDHAVEOPS]
	local groupvar "_group"

	/* ------------------------------------------------------------ */
					/* confirm variable names	*/

	local K : list sizeof names
	if (`K'<2) {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "Syntax is{bind:   }{bf:ssd init} {it:varnames}{break}"
		di as err "You must specify two or more new variables names."
		di as err "{p_end}"
		exit 198
	}
	forvalues i=1(1)`K' {
		local name : word `i' of `names'
		capture noi confirm name `name'
		if (_rc) {
			exit 198
		}
		local name`i' `name'
	}
	/* ------------------------------------------------------------ */
					/* verify variable names unique	*/
	local dups   : list dups names
	local n_dups : list sizeof dup
	if (`n_dups') {
		di s err "syntax error"
		di as err "{p 4 4 2}"
		di as err "You specified the same variable name"
		di as err "more than once."
		di as err "{p_end}"
		exit(198)
	}
	
	/* ------------------------------------------------------------ */
					/* create variable names	*/
	assert _N==0
	u_ssd_chars_zap
	quietly {
		gen int `groupvar' = .
		gen int _type  = .
		forvalues i=1(1)`K' {
			qui gen double `name`i'' = .
		}
	}

	/* ------------------------------------------------------------ */
					/* initialize			*/
	u_ssd_chars_init
	if ("`groups'"=="") {
		u_ssd_addgroup 1
		ssd_initialize_msg `g'
	}
	/* ------------------------------------------------------------ */
end


/*
	parse_name_ops m_names m_ops : ...

		Split ... into the part before the comma, and the 
		part including and after the comma.  This routine 
		does not respect bindings, so it can only be used 
		to split simple things.
*/

program parse_name_ops /* name ops : toparse */
	gettoken m_names 0 : 0, parse(" :,")
	gettoken m_ops   0 : 0, parse(" :,")
	gettoken colon   0 : 0, parse(" :,")

	local names
	local ops
	gettoken token  0 : 0, parse(" :,")
	while ("`token'"!="" & "`token'"!="") {
		local names `names' `token' 
		gettoken token  0 : 0, parse(" :,")
	}
	if ("`token'" == ",") {
		local ops ", `0'"
	}
	c_local `m_ops'   `ops'
	c_local `m_names' `names'
end


program ssd_initialize_msg
	args `g'

	if (`_dta[ssd_G]'>1) {
		local for "for group `g' "
	}
	di as txt
	di as txt "{p 0 2 2}"
	di as txt "Summary statistics data `for'initialized."
	di as txt "Next use, in any order,"
	di as txt "{p_end}"

	di as txt
	di as txt "{p 4 8 2}"
	di as txt "{bf:ssd set observations} (required){break}"
	di as txt "It is best to do this first."
	di as txt "{p_end}"

	di as txt
	di as txt "{p 4 8 2}"
	di as txt "{bf:ssd set means} (optional){break}"
	di as txt "Default setting is 0."
	di as txt "{p_end}"

	di as txt
	di as txt "{p 4 8 2}"
	di as txt "{bf:ssd set variances} or {bf:ssd set sd} (optional){break}"
	di as txt "Use this only if you have set or will set correlations and,"
	di as txt "even then, this is optional but highly recommended."
	di as txt "Default setting is 1."
	di as txt "{p_end}"

	di as txt
	di as txt "{p 4 8 2}"
	di as txt "{bf:ssd set covariances} or {bf:ssd set correlations} (required){break}"
	di as txt "{p_end}"

end

					/* ssd initialize		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd addgroup			*/

program ssd_addgroup
	mata: ssd_assert_ssd()
	if (`_dta[ssd_G]'==1) {
		ssd_addgroup_first `0'
	}
	else {
		ssd_addgroup_other `0'
	}
end

program ssd_addgroup_first 
	gettoken name    0 : 0
	gettoken nothing 0 : 0

	if ("`name'"=="" | "`nothing'"!="") {
		ssd_addgroup_first_syntax
		/*NOTREACHED*/
	}
	capture confirm new variable `name'
	local rc = _rc
	if (`rc'==110) {
		di as err "variable {bf:`name'} already exists; no action taken"
		exit 110
	}
	else if (`rc') {
		di as err "{bf:`name'} is an invalid new variable name"
		exit 198
	}

	nobreak {
		rename _group `name'
		char _dta[ssd_groupvar] `name'
		u_ssd_addgroup 2
	}

	di as txt "  (new group `name'==2 added)"
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "The {bf:ssd set} commands now modify the new group"
	di as txt "`name'==2.  If you need to modify data for" 
	di as txt "`name'==1, place a {bf:1} right after the {bf:set}."
	di as txt "For example,"
	di as txt 
	di as txt "        . {bf:ssd set 1 means ...}
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "would modify the means for group `name'==1."
	di as txt "{p_end}"
end

program ssd_addgroup_first_syntax
	di as err "syntax error"
	di as err "{p 4 4 2}"
	di as err "To add summary statistics for another group of "
	di as err "observations, use {bf:ssd addgroup}."
	di as err "The syntax is"
	di as err ""
	di as err "        . {bf:ssd addgroup} {it:newvarname}"
	di as err ""
	di as err "{p 4 4 2}"
	di as err "The summary statistics data you have already entered"
	di as err "will be treated as the data for {it:newvarname}==1,"
	di as err "and {bf:ssd} will be in the mode so that"
	di as err "the new data you provide using {bf:ssd set} are"
	di as err "for group {it:newvarname}==2."
	di as err
	di as err "{p 4 4 2}"
	di as err "After that, if you want to add yet another group,"
	di as err "type {bf:ssd addgroup} without arguments.  Then"
	di as err "you will be entering data for {it:newvarname}==3."
	di as err "You may add as many groups as you wish."
	di as err 
	di as err "{p 4 4 2}"
	di as err "If you add a group mistakenly, just type"
	di as err "{bf:ssd unaddgroup} to remove it."
	di as err "{p_end}"
	exit 198
end

program ssd_addgroup_other 
	local nargs : list sizeof 0
	if `nargs' > 1 {
		ssd_addgroup_first_syntax
		/*NOTREACHED*/
	}
	else if `nargs' == 1 {
		capture syntax varname
		if c(rc) {
			ssd_addgroup_first_syntax
			/*NOTREACHED*/
		}
		if `"`_dta[ssd_groupvar]'"' != "`varlist'" {
			di as err "{p 0 0 2}"
			di as err ///
"variable {bf:`varlist'} does not match the already specified group variable;"
			di as err "no action taken"
			di as err "{p_end}"
			exit 198
		}
	}


	nobreak {
		local G0 = `_dta[ssd_G]'
		local G = `G0' + 1
		u_ssd_addgroup `G'
	}

	di as txt "  (new group `name'==`G' added)"
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "The {bf:ssd set} commands now modify the new group"
	di as txt "`name'==`G'.  If you need to modify data for" 
	di as txt "`name'==`G', place a {bf:`G'} right after the {bf:set}."
	di as txt "For example,"
	di as txt 
	di as txt "        . {bf:ssd set `G' means ...}
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "would modify the means for group `name'==`G'."
	di as txt "{p_end}"
end


					/* ssd addgroup			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd unaddgroup		*/
/*
	ssd unaddgroup #_g
*/

program ssd_unaddgroup
	args g nothing 
	mata: ssd_assert_ssd()
	if (`_dta[ssd_G]'==1) {
		di as err "cannot unadd the first group"
		di as err "{p 4 4 2}"
		di as err "To start all over, type {bf:drop _all}."
		di as err "{p_end}"
		exit 459
	}
	if ("`g'"=="") {
		ssd_unaddgroup_syntax
		/*NOTREACHED*/
	}

	capture confirm integer number `g'
	if (_rc) {
		di as err "{bf:`g'} invalid group number"
		exit 198
	}

	if (`g'==`_dta[ssd_G]') {
		nobreak {
			char _dta[ssd_N`g']
			char _dta[ssd_hasM`g']
			char _dta[ssd_hasVS`g']
			char _dta[ssd_VS`g']
			char _dta[ssd_hasCC`g']
			char _dta[ssd_CC`g']
			quietly drop if `_dta[ssd_groupvar]' == `g'
			char _dta[ssd_G] `=`g'-1'
			di as txt "  (group `g' deleted)"
			if (`_dta[ssd_G]'==1) {
				rename `_dta[ssd_groupvar]' _group
				char _dta[ssd_groupvar] _group
			}
		}
		exit
	}
	di as err "`g' is not the last group;"
	di as err "only the last group can be removed"
	exit 198
end

program ssd_unaddgroup_syntax
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "The last group is `_dta[ssd_G]'."
	di as txt "To delete it, type {bf:ssd unaddgroup `_dta[ssd_G]'}."
	di as txt "The status of the group is"
	di as txt "{p_end}"
	ssd_status `_dta[ssd_G]'
	di as txt
	di as txt "{p 4 4 2}"
	di as txt "You can only remove the last group.{break}"
	di as txt "To delete it, type {bf:ssd unaddgroup `_dta[ssd_G]'}." 
	di as txt "{p_end}"
	di as err "you must specify group number"
	exit 198
end
		
					/* ssd unaddgroup		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd describe			*/

/*
	ssd describe [, nodate]

	The -nodate- option is not documented.  It is used in testing 
	to prevent the date from showing.


	saved in r()
	    scalars:
		r(N)		# of observations in total
		r(k)		# of variables (excluding group variable)
		r(G)		# of groups
		r(complete)	whether data complete
		r(complete_means)
				whether means are complete
		r(complete_covariances)
				whether covariances are complete

	    macros:
		r(v#)		variable names, # = 1 .. r(k)
		r(groupvar)	group variable name ir r(G)>1
*/
		
program ssd_describe, rclass
	mata: ssd_assert_ssd()
	syntax [, noDATE]

	if (c(filename)!="") {
		local suffix `"from `c(filename)'"'
	}
	di as txt
	di as txt "{p 2 2 2}
	di as txt `"Summary statistics data `suffix'"'
	di as txt "{p_end}"

	local N 0
	forvalues i=1(1)`_dta[ssd_G]' {
		local N = `N' + `_dta[ssd_N`i']'
	}
	local x : data label
	if (udstrlen(`"`x'"')> 32) {
		local x = udsubstr(`"`x'"', 1, 30) + ".."
	}

	return scalar N = `N'
	di as txt "    obs:" as res %16.0gc `N' _col(42) `"`x'"'

	local K = `_dta[ssd_K]'-2
	local filedate = cond("`date'"=="", "`c(filedate)'", "")
	di as txt "   vars:" as res %16.0gc `K' _col(42) "`filedate'"

	if ("`_dta[note0]'"!="") {
		di as txt _col(42) as res "(_dta has notes)"
	}

	di as txt "  {hline 72}"
	di as txt "  variable name" _col(34) "variable label"
	di as txt "  {hline 72}"
	
	local 0 "_all"
	syntax varlist
	local varcnt 0
	foreach name of local varlist {
		if ("`name'"!="`_dta[ssd_groupvar]'" & ///
		    "`name'"!="_type") {
			local ++varcnt
			return local v`varcnt' "`name'"
			local lbl : variable label `name'
			if (udstrlen(`"`lbl'"')>40) {
				local lbl = udsubstr(`"`lbl'"', 1, 38) + ".."
			}
			di "  " as res abbrev("`name'", 28) ///
				as txt _col(34) `"`lbl'"'
		}
	}
	return scalar k = `varcnt'

	di as txt "  {hline 72}"
	return scalar G = `_dta[ssd_G]'
	if (`_dta[ssd_G]'>1) {
		return local groupvar "`_dta[ssd_groupvar]'"
		di as txt "  Group variable:  " ///
			as res "`_dta[ssd_groupvar]'" ///
			as txt "  (`_dta[ssd_G]' groups)"
		di as txt "{p 3 5 2}"
		di as txt "Obs. by group:"
		local comma ","
		forvalues i=1(1)`_dta[ssd_G]' {
			if (`i'==`_dta[ssd_G]') {
				local comma 
			}
			di as txt "`_dta[ssd_N`i']'`comma'"
		}
		di as txt "{p_end}"
	}
	mata: my_ssd_check_completeness("complete")
	return scalar complete = `complete'

	mata: my_ssd_any_means_avbl("any")
	mata: my_ssd_all_means_avbl("all")
	return scalar complete_means = !(`any' & !`all')
	if (`any' & !`all') {
		di as txt
		di as txt "{p 2 4 4}"
		di as txt "note: Some groups have means"
		di as txt "defined but other groups do not."
		di as txt "{p_end}"
	}

	mata: my_ssd_any_covariances_avbl("any")
	mata: my_ssd_all_covariances_avbl("all")
	return scalar complete_covariances = !(`any' & !`all')
	if (`any' & !`all') {
		di as txt
		di as txt "{p 2 4 4}"
		di as txt "note: Some groups have covariances defined"
		di as txt "but other groups do not."
		di as txt "For the purposes of this message, a group"
		di as txt "has covariances defined if (1) the"
		di as txt "covariance matrix is set, or (2) the"
		di as txt "correlation matrix and variances or"
		di as txt "standard deviations are set."
		di as txt "{p_end}"
	}
end


					/* ssd describe			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd list			*/

/*
	ssd list [#_g]
*/


program ssd_list
	mata: ssd_assert_ssd()
	syntax [anything(id="group number" name=g)]
	unab varlist : *
	local tosub "`_dta[ssd_groupvar]' _type"
	local varlist : list varlist - tosub

	if ("`g'"!="") {
		capture confirm integer number `g'
		if _rc {
			di as err {p 0 2 2}"
			di as err "{bf:g} found where nothing or"
			di as err "group number expected"
			di as er "{p_end}"
			exit 198
			/*NOTREACHED*/
		}
		if (`g'<1 | `g'>`_dta[ssd_G]') {
			di as err "group number out of range"
			di as err "{p 4 4 2}"
			di as err "Group number must be between 1 and"
			di as err "`_dta[ssd_G]'."
			di as err "{p_end}"
			exit 198
			/*NOTREACHED*/
		}
		local hasg 1
	}
	else {
		local hasg 0
	}
	

	if (`_dta[ssd_G]'==1) {
		di as txt
		mata: ssd_list(1, "`varlist'", 0)
		exit
	}

	local groupvar : char _dta[ssd_groupvar]
	if (`hasg') {
		local gval : label (`groupvar') `g'
		di as txt
		di as txt "{p}Group `groupvar'==`gval':{p_end}"
		mata: ssd_list(`g', "`varlist'", 1)
		exit
	}

	forvalues g=1(1)`_dta[ssd_G]' {
		local gval : label (`groupvar') `g'
		di as txt
		di as txt "{hline `c(linesize'}"
		di as txt "{p}Group `groupvar'==`gval':{p_end}"
		mata: ssd_list(`g', "`varlist'", 1)
	}
	di as txt "{hline `c(linesize'}"
end

					/* ssd list			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* ssd query			*/
/*
	ssd query
	
	saved in r()
	    scalars:
		r(isSSD)	whether data are SSD
*/

program ssd_query, rclass
	syntax
	if ("`_dta[ssd_marker]'"!="SSD") {
		di as txt "  (data not SSD)"
		return scalar isSSD = 0
	}
	else {
		di as txt "  (data SSD)"
		return scalar isSSD = 1
	}
end
	
					/* ssd query			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd repair			*/

program ssd_repair
	if ("`_dta[ssd_marker]'"!="SSD") {
		di as err "data in memory are not summary statistics data (SSD)"
		exit 459
	}
	if ("`_dta[ssd_version]'"!="1") {
		di as err "unknown SSD format"
		exit(459)
	}
		
	syntax

	mata: check_repair_possibility("code")
	if (`code'==0) {
		di as txt "  (data do not need repairing)"
		exit
	}
	if (`code'==2) {
		di as err "data cannot be repaired (1)"
		exit 459
	}

	/* find variables groupvar and type (pos 1 and 2) */
	find_var_by_pos groupvar : 1
	find_var_by_pos type     : 2

	preserve

	local N_desired = `_dta[ssd_n]'*`_dta[ssd_G]'
	if (_N > `N_desired') {
		local K = `_dta[ssd_K]' - 2
		quietly keep if `groupvar'>=1 		  & 	///
				`groupvar'<=`_dta[ssd_G]' & 	///
				`type'    >= 1		  &	///
				`type'    <= `K'+2
		if (_N != `N_desired') {
			di as err "data cannot be repaired (2)"
			exit 459
			/*NOTREACHED*/
		}
	}

	local todrop 
	unab varlist : *
	local K      : list sizeof varlist
	local K_desired `_dta[ssd_K]'

	if (`K' > `K_desired') {
		foreach name of local varlist {
			local dropthis 0
			local pos ``name'[ssd_pos]'
			capture confirm integer number `pos'
			if (_rc) {
				local dropthis 1
			}
			else {
				if (`pos'<1 | `pos'>`_dta[ssd_K]') {
					local dropthis 1
				}
			}
			if (`dropthis') {
				local todrop `todrop' `name'
			}
		}
		if ("`todrop"=="") {
			di as err "data cannot be repaired (3)"
			exit 459
			/*NOTREACHED*/
		}
		quietly drop `todrop'
		unab varlist : *
		local K      : list sizeof varlist
		if (`K' != `K_desired') {
			di as err "data cannot be repaired (4)"
			exit 459
			/*NOTREACHED*/
		}
	}

	capture mata: ssd_assert_ssd()
	if (_rc) {
		di as err "data cannot be repaired (5)"
		exit 459
		/*NOTREACHED*/
	}
	restore, not
	di as txt "  (data repaired)"
end


program find_var_by_pos
	args lmacname colon pos

	unab varlist : *
	foreach name of local varlist {
		local varpos ``name'[ssd_pos]'
		capture confirm integer number `varpos'
		if (_rc==0) {
			if (`varpos' == `pos') {
				local result `name'
				exit 	// which exits from loop 
			}
		}
	}
	if ("`result'"!="") {
		c_local `lmacname' `result'
		exit
	}
	di as err "data cannot be repaired (9)"
	exit 459
end

					/* ssd repair			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* ssd set (main driver)	*/

/*
	set [#] <subcmd> ...
*/

program ssd_set
	mata: ssd_assert_ssd()
	gettoken cmd rest : 0
	capture confirm integer number `cmd'
	if (_rc==0) {
		local g `cmd'
		gettoken cmd rest : rest
	}
	else	local g `_dta[ssd_G]'
	assert_g_valid `g'
	
	local l = strlen("`cmd'")

	if ("`cmd'"==bsubstr("correlations", 1, max(3, `l'))) {
		ssd_set_correlations `g' `rest'
		exit
	}

	if ("`cmd'"==bsubstr("covariances", 1, max(3, `l'))) {
		ssd_set_covariances `g' `rest'
		exit
	}

	if ("`cmd'"==bsubstr("means", 1, max(4, `l'))) {
		ssd_set_means `g' `rest'
		exit
	}
	if ("`cmd'"==bsubstr("observations", 1, max(3, `l'))) {
		ssd_set_observations `g' `rest'
		exit
	}
	if ("`cmd'"==bsubstr("sds", 1, max(2, `l'))) {
		ssd_set_sd `g' `rest'
		exit
	}
	if ("`cmd'"==bsubstr("variances", 1, max(3, `l'))) {
		ssd_set_variances `g' `rest'
		exit
	}

	capture ssd_set_`cmd' `rest'
	if (_rc == 199) {
		di as err "unknown {cmd:ssd set} subcommand"
	}
	else if (_rc) {
		capture noi ssd set_`cmd' `rest'
	}
	exit _rc
end

program assert_g_valid
	args g


	capture confirm integer number `g' 
	if (_rc) {
		di as err "{bf:`g'} found where group number expected"
		exit 198
	}
	if (`g'<1 | `g'>`_dta[ssd_G]') {
		di as err "group number {bf:`g'} out of range"
		di as err "{p 4 4 2}"
		if (`_dta[ssd_G]'==0) {
			di as err "No groups are currently defined;"
			di as err "use command {bf:ssd addgroup}"
			di as err "to add one."
			di as err "{p_end}"
			exit 198
		}
		if (`_dta[ssd_G]'==1) {
			di as err "Only one group, group=1, is currently"
			di as err "defined.  Omit typing the group number"
			di as err "to set or reset values in the first"
			di as err "group, or use command {bf:ssd addgroup}"
			di as err "to add a new group."
			di as err "{p_end}"
			exit 198
		}
		di as err "Specify a number between 1 and `_dta[ssd_G]'"
		di as err "to set or reset values in an existing group,"
		di as err "or use command {bf:ssd addgroup} to add"
		di as err "a new group."
		di as err "{p_end}"
		exit 198
	}
end


/* -------------------------------------------------------------------- */
					/* ssd set status		*/

/*
	set [#] ...
*/

program ssd_status
	syntax [anything(name=g id="group number")]
	if ("`g'"=="") {
		local g `_dta[ssd_G]'
	}
	if (`_dta[ssd_G]'==0) { 
		di as txt "{p 0 0 2}"
		di as txt "(no groups defined; use {bf:ssd addgroup} to add one"
		di as txt "{p_end)"
		exit
	}

	/* ------------------------------------------------------------ */
	di as txt
	if (`_dta[ssd_G]'>1) {
		di as txt "    Status for group `_dta[ssd_groupvar]'==`g':"
	}
	else 	di as txt "    Status:"

	local isset = `_dta[ssd_N`g']'!=0 
	ssd_status_msg "observations" `isset' 1
	ssd_status_msg "means" `_dta[ssd_hasM`g']' 0
	ssd_status_msg "variances or sd" `_dta[ssd_hasVS`g']' 0
	ssd_status_msg "covariances or correlations" `_dta[ssd_hasCC`g']' 1
end

program ssd_status_msg
	args text isset isreqd

	local l = 35 - strlen("`text'")
	if (`isset') {
		local msg "  set"
	}
	else {
		if (`isreqd') {
			local msg "unset (required to be set)"
		}
		else	local msg "unset"
	}

	di as txt _skip(`l') "`text':  `msg'"
end

					/* ssd set status		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* set observations		*/

/*
	set [#] observations # [, replace]
*/

program ssd_set_observations
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	syntax anything(id="number") [, replace]
	capture confirm integer number `anything'
	if (_rc) {
		di as err "{bf:`anything'} found number of observations expected"
		exit 198
	}
	if ("`replace'"!="") {
		char _dta[ssd_N`g'] `anything'
	}
	else {
		if (`_dta[ssd_N`g']'==0) {
			char _dta[ssd_N`g'] `anything'
		}
		else	error_whatever_already_set "{bf:observations}"
	}
	value_set "" `g'
	ssd_status `g'
end



					/* set observations		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* set means			*/

/*
	ssd set [#] means <vecvalues>[, replace]

	<vecvalues> :=
		# # ... #
		(stata) <stata_matrix_name>
		(mata)  <mata_matrix_name>
*/

program ssd_set_means
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	syntax anything(id="mean values" name=list) [, replace]
	if ("`replace'"=="") {
		if (`_dta[ssd_hasM`g']') {
			error_whatever_already_set "means"
		}
	}
	
	mata: set_means(`g', "`list'")
	char _dta[ssd_hasM`g'] 1
	value_set s `g'
	ssd_status `g'
end

					/* set means			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* set variances & set sd	*/

/*
	ssd set {variances|sd} <vecvalues>] [, replace]

	<vecvalues> :=
		# # ... #
		(stata) <stata_matrix_name>
		(mata)  <mata_matrix_name>
*/

program ssd_set_variances
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	if (`_dta[ssd_hasCC`g']' & "`_dta[ssd_CC`g']'"=="cov") {
		implied_set_error var
		/*NOTREACHED*/
	}
		
	syntax anything(id="variance values" name=list) [, replace]
	if ("`replace'"=="") {
		if (`_dta[ssd_hasVS`g']') {
			error_whatever_already_set "variances"
		}
	}
	
	mata: set_variances(`g', "`list'")
	char _dta[ssd_hasVS`g'] 1
	char _dta[ssd_VS`g']    "var"
	value_set s `g'
	ssd_status `g'
end

program ssd_set_sd
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	if (`_dta[ssd_hasCC`g']' & "`_dta[ssd_CC`g']'"=="cov") {
		implied_set_error sd
		/*NOTREACHED*/
	}

	syntax anything(id="sd values" name=list) [, replace]
	if ("`replace'"=="") {
		if (`_dta[ssd_hasVS`g']') {
			error_whatever_already_set "standard deviations"
		}
	}
	
	mata: set_variances(`g', "`list'")
	char _dta[ssd_hasVS`g'] 1
	char _dta[ssd_VS`g']    "sd"
	value_set s `g'
	ssd_status `g'
end

program implied_set_error
	args which
	if ("`which'"=="var") {
		di as err "variances already set"
		di as err "{p 4 4 2}"
		di as err "You previously {bf:set covariances}."
		di as err "The diagonal elements of the covariance matrix"
		di as err "are the variances."
		di as err "{p_end}"
	}
	else {
		di as err "standard deviations already set"
		di as err "{p 4 4 2}"
		di as err "You previously {bf:set covariances}."
		di as err "The diagonal elements of the covariance matrix"
		di as err "are the squares of the standard deviations."
		di as err "{p_end}"
	}
	exit 198
end

					/* set variances & set sd	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* set cov & set cor		*/
/*
	ssd set {covariances|sd} <matvalues>] [, replace]

	<matvalues> :=
		# # ... # 		(with backslashes)
		(ltd)  # # ... #	(w/o  backslashes)
		(dut)  # # ... #	(w/o  backslashes)
		(stata) <stata_matrix_name>
		(mata)  <mata_matrix_name>
*/

program ssd_set_covariances
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	syntax anything(id="covariance values" name=list) [, replace]
	if ("`replace'"=="") {
		if (`_dta[ssd_hasCC`g']') {
			error_whatever_already_set "covariances"
		}
	}
	
	mata: set_covariances(`g', "`list'", 0)
	char _dta[ssd_hasCC`g'] 1
	char _dta[ssd_CC`g']    "cov"
	value_set s `g'
	ssd_status `g'
end

program ssd_set_correlations
	mata: ssd_assert_ssd()
	gettoken g 0 : 0

	syntax anything(id="correlation values" name=list) [, replace]
	if ("`replace'"=="") {
		if (`_dta[ssd_hasCC`g']') {
			error_whatever_already_set "correlations"
		}
	}
	
	mata: set_covariances(`g', "`list'", 1)
	char _dta[ssd_hasCC`g'] 1
	char _dta[ssd_CC`g']    "corr"
	value_set s `g'
	ssd_status `g'
end

					/* set cov & set cor		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* characteristics utilities	*/

/*
	u_ssd_chars_init

	Characteristics are:
		_dta[ssd_marker]	"SSD"
		_dta[ssd_version]	1

		_dta[ssd_G]	        <# of groups> 
		_dta[ssd_K]		<# of vars>, incl _type & _group
		_dta[ssd_n]		obs per group 
		_dta[ssd_vars]		<all variables in order>
		_dta[ssd_groupvar]	name of group var (_group is default)	

	    The following are indexed by group number:

		_dta[ssd_N#]		# of observations
		_dta[ssd_hasM#]		1 or 0 (has means)

		_dta[ssd_hasVS#]	1 or 0 (has variances or sds)
		_dta[ssd_VS#]		"var" or "sd" or ""

		_dta[ssd_hasCC#]	1 or 0 (has covariances or correlations)
		_dta[ssd_CC#]		"cov" or "corr"

	    The following are by variable:
		<varname>[ssd_pos]	1, 2, ... (variable position)
*/


program u_ssd_chars_zap
	char _dta[ssd_marker]
	char _dta[ssd_version]

	capture unab varlist : *
	if (_rc==0) {
		foreach name of local varlist {
			char `name'[ssd_pos]
		}
	}

	if ("`_dta[ssd_G]'"!="") {
		forvalues i=1(1)`_dta[ssd_G]' {
			char _dta[ssd_N`i']

			char _dta[ssd_hasM`i'] 

			char _dta[ssd_hasVS`i']
			char _dta[ssd_VS`i']

			char _dta[ssd_hasCC`i']
			char _dta[ssd_CC`i']
		}
	}

	char _dta[ssd_G]
	char _dta[ssd_K]
	char _dta[ssd_n]
	char _dta[ssd_vars]
	char _dta[ssd_groupvar]

end


program u_ssd_chars_init 
	u_ssd_chars_zap

	local 0 _all
	syntax varlist
	local obs_per_group = c(k)  /* -2 + 2 */

	char _dta[ssd_version] "1"	/* marker set last		*/

	char _dta[ssd_G]	0
	char _dta[ssd_K]        `c(k)'
	char _dta[ssd_n]	`obs_per_group'
	char _dta[ssd_vars]     `varlist'
	char _dta[ssd_groupvar]	_group

	unab varlist : *
	local i 1
	foreach name of local varlist {
		char `name'[ssd_pos] `i'
		local ++i
	}
	char _dta[ssd_marker]	"SSD"
end



					/* characteristics utilities	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* utilities			*/

/*
	u_ssd_addgroup #_g

		Adds a group containing missing values 
*/


program u_ssd_addgroup 
	args i 

	if (`i' <= `_dta[ssd_G]' | 	///
	    `i' >  `_dta[ssd_G]'+1) {
		error_invalid_group_no `i'
	}
	local base = _N + 1
	quietly {
		set obs `=_N+`_dta[ssd_n]''
		replace `_dta[ssd_groupvar]'= `i'        in `base'/l
		replace _type               = 1          in `base'
		replace _type               = 2          in `=`base'+1'
		replace _type               = 2 + sum(1) in `=`base'+2'/l
		sort `_dta[ssd_groupvar]' _type
		char _dta[ssd_G]     `i'
		char _dta[ssd_N`i']        0
		char _dta[ssd_hasM`i']     0
		char _dta[ssd_hasVS`i']    0
		char _dta[ssd_hasCC`i']    0
	}
end


program value_set
	args s g
	if (`_dta[ssd_G]'>1) {
		di as txt "  (value`s' set for group `_dta[ssd_groupvar]'==`g')"
	}
	else	di as txt "  (value`s' set)
end

					/* utilities			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* error messages		*/


program error_whatever_already_set
	args whatever

	di as err "`whatever' have already been set"
	di as err "{p 4 4 2}"
	di as err ///
	"Specify option {bf:replace} if you wish to reset the value(s)."
	di as err "{p_end}"
	exit 198
end
	

program error_invalid_group_no 
	args group_no

	di as err "group_no' invalid group number"
	di as err "{p 4 4 2}"
	di as err "The next group to be defined is ``_dta[ssd_G]+1'."
	if (`_dta[ssd_G']) {
		di as err "The current group is `_dta[ssd_G]'."
	}
	di as err "{p_end}"
	exit 198
end

program u_ssd_corrupt_begin
	di as err "statistical-summary data has been modified"
	di as err "{p 4 4 2}"
		di as err "You have incorrectly, probably inadvertently,"
		di as err "modified the statistical-summary data (SSD)"
		di as err "in memory."
end


/* ==================================================================== */
/* -------------------------------------------------------------------- */
					/* Mata subroutines		*/

version 12
local RS	real scalar
local RM	real matrix
local RR	real rowvector
local SS	string scalar
local SR	string rowvector
local SM	string matrix

local boolean	real scalar
local True	(1)
local False	(0)

local Code	real scalar


mata:

/* -------------------------------------------------------------------- */
				/* ssd set utilities			*/


void set_means(`RS' g, `SS' values)
{
	`RS'	rc
	`RS'	K
	`RR'	w

	K = ssd_K()

	if (bsubstr(values,1,1) == "(") {
		w = getmatrix(values, 1, K)
	}
	else {
		w = strtoreal(tokens(values))

		if (cols(w)!=K) {
			if (cols(w)<K) {
				errprintf("too few values specified\n")
				rc = 122
			}
			else {
				errprintf("too many values specified\n")
				rc = 123
			}
			errprintf("{p 4 4 2}\n")
			errprintf(
			"You need to specify %g numeric values.\n", K)
			errprintf("{p_end}\n") 
			exit(rc)
		}
	}

	if (sum(w:>=.)) {
		errprintf("missing values not allowed\n")
		exit(459)
	}
	ssd_put_means(g, w)
}

void set_variances(`RS' g, `SS' values)
{
	`RS'	rc
	`RS'	K
	`RR'	w

	K = ssd_K()

	if (bsubstr(values,1,1)=="(") {
		w = getmatrix(values, 1, K)
	}
	else {
		w = strtoreal(tokens(values))
	}

	if (cols(w)!=K) {
		if (cols(w)<K) {
			errprintf("too few values specified\n")
			rc = 122
		}
		else {
			errprintf("too many values specified\n")
			rc = 123
		}
		errprintf("{p 4 4 2}\n")
		errprintf("You need to specify %g numeric values.\n", K)
		errprintf("{p_end}\n") 
		exit(rc)
	}

	if (sum(w:>=.)) {
		errprintf("missing values not allowed\n")
		exit(459)
	}
	if (sum(w:<0)) {
		errprintf("negative values not allowed\n")
		exit(459)
	}

	ssd_put_Var(g, w)
}


void set_covariances(`RS' g, `SS' values, `boolean' iscorr)
{
	`RS'	K
	`RM'	W

	K = ssd_K()

	if (bsubstr(values,1,1)=="(") {
		W = getmatrix(values, K, K)
	}
	else {
		W = set_covariances_parse(values, K)
	}

	if (sum(W:>=.)) {
		errprintf("missing values not allowed\n")
		exit(198)
	}
	if (iscorr) {
		assert_diag_1(W)
		assert_fix_symmetric(W)
		if (sum(W:>1) | sum(W:<(-1))) {
			errprintf(
				"nondiagonal values must be between -1 and 1\n") 
			exit(459)
		}
		assert_semipos(W)
	}
	else {
		assert_diag_semipos(W)
		assert_fix_symmetric(W)
		assert_semipos(W)
	}
	ssd_put_CC(g, iscorr ? "corr" : "cov", W)
}

void assert_diag_1(`RM' W)
{
	if (sum(diagonal(W:!=1))) { 
		errprintf("values must be 1 along the diagonal\n")
		exit(459)
	}
}

void assert_diag_semipos(`RM' W)
{
	if (sum(diagonal(W):<0)) {
		errprintf("values must be >= 0 along diagonal\n")
		exit(459)
	}
}

void assert_fix_symmetric(`RM' W)
{
	if (W==W') return
	if (mreldif(W', W)>1e-8) {
		errprintf("matrix not symmetric\n")
		exit(459)
	}
	W = (W + W'):/2
}

void assert_semipos(`RM' W)
{
	`RR'	evals
	`RS'	norm

	norm = norm(evals = symeigenvalues(W))
	if (norm==0) return
	if (sum((evals:/norm):<(-1e-8))) {
		errprintf("matrix not positive semidefinite\n")
		errprintf("{p 4 4 2}\n")
		errprintf("One or more numeric values are incorrect\n")
		errprintf("because real data can generate only\n")
		errprintf("positive semidefinite covariance or\n")
		errprintf("correlation matrices.\n")
		errprintf("{p_end}\n")
		exit(459)
	}
}
		

`RM' set_covariances_parse(`SS' values, `RS' K)
{
	`SR'	s
	`RS'	enel

	s = tokens(subinstr(values, "/", "\"), " \")
	if (length(s) != (enel=(K*(K+1))/2 + K - 1)) {
		set_covariances_err(K, (length(s)>enel))
		/*NOTREACHED*/
	}

	return((s[2]=="\" ? set_covariances_parse_lt(s, K) :
			    set_covariances_parse_ut(s, K)) )
}


void set_covariances_err(`RS' K, `RS' toomany)
{
	errprintf((toomany ? "too many" : "too few")+ " elements specified\n")
	errprintf("{p 4 4 2}\n")
	errprintf("You need to enter a %g {it:x} %g symmetric matrix.\n", K, K)
	errprintf("Enter (1) the lower triangle and diagonal\n")
	errprintf("or (2) the diagonal and upper triangle.  Either way, you\n")
	errprintf("put spaces between numeric values and\n")
	errprintf("backslashes ({bf:\}) between rows.\n")
	matrix_example() ;
	exit(198)
}


`RM' set_covariances_parse_lt(`SR' s, `RS' K)
{
	`RS'	i, j, m
	`RM'	W

	W = J(K, K, .)
	i = 1
	j = 0 
	for (m=1; m<=length(s); m++) {
		if (s[m]=="\") {
			if (j==i) {
				(void) ++i 
				j = 0 
			}
			else 	misplaced_slash() 
		}
		else {
			if (++j>i) missing_slash()
			if ((W[j,i] = W[i,j] = strtoreal(s[m]))==.) { 
				badnumber(s[m], i, j) 
			}
		}
	}
	return(W)
}

`RM' set_covariances_parse_ut(`SR' s, `RS' K)
{
	`RS'	i, j, m
	`RM'	W

	W = J(K, K, .)
	i = 1
	j = 0 
	for (m=1; m<=length(s); m++) {
		if (s[m]=="\") {
			if (j==K) j = i++ 
			else 	  misplaced_slash() 
		}
		else {
			if (++j>K) missing_slash()
			if ((W[j,i] = W[i,j] = strtoreal(s[m]))==.) { 
				badnumber(s[m], i, j) 
			}
		}
	}
	return(W)
}

void badnumber(`SS' str, `RS' i, `RS' j)
{
	errprintf("{bf:%s} is not a numeric value\n", str) 
	errprintf("{p 4 4 2}\n")
	errprintf("That is the value you specified for the\n") 
	errprintf("%g,%g element of the matrix.\n", i, j)
	errprintf("{p_end}\n")
	exit(198)
}


void misplaced_slash()
{
	errprintf("backslash (\) misplaced\n")
	errprintf("{p 4 4 2}\n")
	errprintf("A backslash occurs in a place that it should not.\n")
	all_slashes()
}


void missing_slash()
{
	errprintf("backslash (\) misplaced\n")
	errprintf("{p 4 4 2}\n")
	errprintf("A backslash does not occur in a place that it should.\n")
	all_slashes()
}

void all_slashes()
{
	errprintf("You may enter the lower triangle and diagonal, or\n")
	errprintf("the diagonal and upper triangle.  Backslashes\n") 
	errprintf("separate rows.  For instance, you could type\n") ; 
	errprintf("\n") 
	errprintf("        . {\bf:ssd set corr 1 \ .2 1 \ .4 .3 1}\n")
	errprintf("or\n") 
	errprintf("        . {\bf:ssd set corr 1 .2 .4 \ 1 .3 \ 1}\n")
	errprintf("\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("and both specify the same symmetric matrix, namely\n")
	errprintf("\n") 
	errprintf("               1  .2  .4\n")
	errprintf("              .2   1  .3\n")
	errprintf("              .4  .3   1\n")

	exit(198)
}

void matrix_example()
{
	errprintf("For example,\n")
	errprintf("\n")
	errprintf("        . {bf:ssd set corr  1 \         ///}\n")
	errprintf("          {bf:             .2  1 \      ///}\n")
	errprintf("          {bf:             .4 .3  1}\n")
	errprintf("or\n")
	errprintf("        . {bf:ssd set corr  1  .2  .4 \ ///}\n")
	errprintf("          {bf:             .2  1 \      ///}\n")
	errprintf("          {bf:             .4}\n")
	errprintf("\n")
	errprintf("{p 4 4 2}\n")
	errprintf("You can write this all on one line if you wish, and\n")
	errprintf("you are required to do this on one line if working\n")
	errprintf("interactively:\n")
	errprintf("\n")
	errprintf("        . {bf:ssd set corr  1 \ .2 1 \ .4 .3 1}\n")
	errprintf("\n")
	errprintf("        . {bf:ssd set corr  1 .2 .4 \ .2 1 \ .4}\n")
}


/*
	s contains:
		(stata) name
		(mata) name
*/

`RM' getmatrix(`SS' s, `RS' r, `RS' c)
{	
	transmorphic	t
	`SS'		tok
	`Code'		todo 
	`RM'		W

	t = tokeninitstata()
	tokenset(t, s)

	assert(tokenget(t)=="(")

	todo = -1
	tok = strlower(tokenget(t))
	if (tok=="stata") todo = 1
	else if (tok=="mata") todo = 2
	else if (r>1) {
		if      (tok=="ltd") todo = 3
		else if (tok=="dut") todo = 4
	}
	if (todo == -1) getmatrix_error_198(r)

	if (tokenget(t)!=")") getmatrix_error_198(r)

	W = (todo==1 | todo==2 ?
		getmatrix_name(  t, todo, r, c) :
		getmatrix_inline(t, todo, r, c) )

	return(W)
}

`RM' getmatrix_inline(transmorphic t, `RS' todo, `RS' r, `RS' c)
{
	`RS'	n, i, j, m
	`SR'	values
	`RM'	W

	assert(r==c)
	values = tokens(tokenrest(t))
	n = (r*(r+1))/2
	if (length(values) != n) {
		if (length(values)<n) {
			errprintf("too few values specified\n")
			exit(122)
		}
		errprintf("too many values specified\n")
		exit(123)
	}

	W = J(r, r, .)

	if (todo==3) {					/* ltd		*/
		for (i=m=1; i<=r; i++) {
			for (j=1; j<=i; j++) {
				W[i,j] = W[j,i] = strtoreal(values[m++])
				if (W[i,j]==.) {
					invalid_numeric_value(values[m-1])
					/*NOTREACHED*/
				}
			}
		}
	}
	else {
		for (i=m=1; i<=r; i++) {
			for (j=i; j<=r; j++) {
				W[i,j] = W[j,i] = strtoreal(values[m++])
				if (W[i,j]==.) {
					invalid_numeric_value(values[m-1])
					/*NOTREACHED*/
				}
			}
		}
	}

	return(W)
}

void invalid_numeric_value(`SS' val)
{
	errprintf("{\bf:%s} is invalid numeric value\n", val)
	exit(198)
}


`RM' getmatrix_name(transmorphic t, `RS' todo, `RS' r, `RS' c)
{
	`SS'			name, nothing
	`RM'			W
	pointer(`RM') scalar	p

	if ((name = tokenget(t)) == "") getmatrix_error_198(r)
	if (!st_isname(name)) {
		errprintf("{bf:%s} invalid matrix name\n", name)
		exit(198)
	}
	if ((nothing = tokenget(t))!="") {
		errprintf("{bf:%s} found where nothing expected\n", nothing)
		exit(198)
	}

	if (todo==1) {					/* stata */
		W = st_matrix(name)
		if (W==J(0,0,.)) {
			errprintf("Stata matrix {bf:%s} not found\n", name)
			exit(111)
		}
	}
	else {						/* mata */
		p = findexternal(name)
		if (p==NULL) {
			errprintf("Mata matrix {bf:%s} not found\n", name)
			exit(111)
		}
		if (eltype(*p)!="real" ) {
			errprintf(
			"Mata matrix (bf:%s} does not contain real values\n", 
			name) 
			exit(109)
		}
		W = *p 
	}

	if (rows(W)==r & cols(W)==c) 		return(W)
	if (r==1 & cols(W)==1 & rows(W)==c)	return(W')

	errprintf("conformability error\n") 
	errprintf("{p 4 4 2}\n")
	errprintf(todo==1 ? "Stata\n" : "Mata\n")
	errprintf("matrix %s\n", name)
	errprintf("is %g {it:x} %g,\n", rows(W), cols(W))
	errprintf("not %g {it:x} %g.\n", r, c)
	errprintf("{p_end}\n")
	exit(503)
	/*NOTREACHED*/
}
		

void getmatrix_error_198(`RS' r)
{
	errprintf("syntax error\n")
	errprintf("    Specify\n")
	errprintf("       {bf:(stata)} {it:stata_matrix_name}\n")
	errprintf("    or\n")
	errprintf("       {bf:(mata)}  {it:mata_matrix_name}\n")
	if (r!=1) {
		errprintf("    or\n") 
		errprintf("       {bf:(ltd)}   {it:# # ... #}\n")
		errprintf("    or\n") 
		errprintf("       {bf:(dut)}   {it:# # ... #}\n")
		errprintf("\n")
		errprintf("{p 4 4 2}\n")
		errprintf(
		"{bf:ltd} stands for Lower Triangle and diagonal.{break}\n")
		errprintf(
		"{bf:dut} stands for Diagonal and Upper Triangle.{break}\n")
		errprintf("{p_end}\n")
	}
	exit(198)
}

				/* ssd set utilities			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* ssd list subroutines			*/


void ssd_list(`RS' g, `SS' varlist, `boolean' includeleadlf)
{
	`RS'	K, N
	`RR'	m, v
	`RM'	V
	`SS'	Mstat, VSstat, CCstat, matname, matdrop
	`SR'	vblnames
	`SM'	toset

	matname = st_tempname()

	K        = ssd_K()
	vblnames = tokens(varlist)
	toset    = J(K, 1, ""), vblnames'

	pragma unset m
	pragma unset v
	pragma unset V
	pragma unset Mstat
	pragma unset VSstat
	pragma unset CCstat
	
	ssd_get_raw_means(g,  Mstat, m)
	ssd_get_raw_VS(   g, VSstat, v)
	ssd_get_raw_CC(   g, CCstat, V)

	matdrop = sprintf("matrix drop %s", matname)

	/* ------------------------------------------------------------ */
	if (includeleadlf) printf("\n")

	if ((N=ssd_get_N(g))!=.) {
		printf("{txt}  Observations = %g\n", N)
	}
	else {
		printf("{txt}{p 2 2 2}\n")
		printf("Observations undefined.\n")
		printf("{res:THEY MUST BE DEFINED.}\n")
		printf("{p_end}\n")
	}

	printf("\n")
	if (Mstat!="") {
		st_matrix(matname, m)
		st_matrixrowstripe(matname, ("", " "))
		st_matrixcolstripe(matname, toset)
		printf("{txt}  Means:")
		stata(sprintf("matrix list %s, noheader", matname))
		stata(matdrop)
	}
	else {
		printf("{txt}  Means undefined; assumed to be 0\n")
	}


	/* ------------------------------------------------------------ */
	if (CCstat!="cov") {
		printf("\n")
		if (VSstat!="") {
			st_matrix(matname, v)
			st_matrixrowstripe(matname, ("", " "))
			st_matrixcolstripe(matname, toset)
			printf("{txt}  %s:", 
				VSstat=="var" ? "Variances" : 
				                "Standard deviations")
			stata(sprintf("matrix list %s, noheader", matname))
			stata(matdrop)
		}
		else {
			printf("{txt}  Variances undefined; assumed to be 1\n")
		}
	}
	else {
		printf("\n")
		printf("{txt}{p 2 2 2}\n")
		printf("Variances implicitly defined; they are the\n")
		printf("diagonal of the covariance matrix.\n")
		printf("{p_end}\n")
	}
	/* ------------------------------------------------------------ */

	printf("\n")
	if (CCstat!="") {
		st_matrix(matname, V)
		st_matrixcolstripe(matname, toset)
		st_matrixrowstripe(matname, 
			(J(K,1,""),J(K,1," "))/*+ toset*/)
		printf("{txt}  %s:", 
				CCstat=="cov" ? "Covariances" : 
						"Correlations")
		stata(sprintf("matrix list %s, noheader", matname))
		stata(matdrop)
	}
	else {
		printf("{txt}{p 2 2 2}\n")
		printf("Covariances (correlations) undefined.\n")
		printf("{res:THEY MUST BE DEFINED.}\n")
		printf("{p_end}\n")
	}
	/* ------------------------------------------------------------ */
}


				/* ssd list subroutines			*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* Stata interfaces to ssd public util	*/


void my_ssd_check_completeness(`SS' lmacname)
{
	`boolean'	result

	result = ssd_check_completeness(., "warn")
	st_local(lmacname, strofreal(result))
}

void my_ssd_any_means_avbl(`SS' lmacname)
{
	st_local(lmacname, strofreal(ssd_any_means_avbl(.)))
}

void my_ssd_all_means_avbl(`SS' lmacname)
{
	st_local(lmacname, strofreal(ssd_all_means_avbl(.)))
}

void my_ssd_any_covariances_avbl(`SS' lmacname)
{
	st_local(lmacname, strofreal(ssd_any_covariances_avbl(.)))
}

void my_ssd_all_covariances_avbl(`SS' lmacname)
{
	st_local(lmacname, strofreal(ssd_all_covariances_avbl(.)))
}

void check_repair_possibility(`SS' lmacname)
{
	st_local(lmacname, strofreal(ssd_data_corrupt(`False')))
}

end
