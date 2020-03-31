*! version 1.0.0  30may2019

/////////////////////////////////////////////////////////////////////////////
//
//	Subcommands for system only:
//
//		vl set [<varlist>] [, options ]
//
//			(code in vl_set.ado)
//
//		vl move {<vlsysname_from> | (<varlist>)} <vlsysname_to>
//
//	Subcommands for user only:
//
//		vl create <vlusername> = ...
//
//		vl LABel <vlusername> ["<label>"]
//
//		vl MODify <vlusername> = ...
//
//		vl SUBstitute <vlusername> = <factor_vlnamelist>

//	Subcommands for both system and user:
//
//		vl clear [, SYStem USER ]
//
//		vl dir [, SYStem USER ]
//
//		vl drop {<vlnamelist> | (<varlist>)} [, SYStem USER ]
//
//		vl List [<vlnames> | (<varlist>)] [, options ]
//
//			(code in vl_list.ado)
//
//		vl rebuild
//
/////////////////////////////////////////////////////////////////////////////

program vl
	version 16

	gettoken subcmd 0 : 0, parse(" ,")

	local len = strlen("`subcmd'")
	if (`len' == 0) {
		di as err "{bf:vl} subcommand unspecified"
		di as err "{p 4 4 2}The syntax of {bf:vl} is"
		di as err "{bf:vl} {it:subcmd} ...{p_end}"
		exit 198
	}

	if ("`subcmd'" == "clear") {
		vl_clear `0'
		exit
	}

	if ("`subcmd'" == "create") {
		vl_create_modify 1 : `0'
		exit
	}

	if ("`subcmd'" == "dir") {
		vl_dir `0'
		exit
	}

	if ("`subcmd'" == "drop") {
		vl_drop `0'
		exit
	}

	if ("`subcmd'" == substr("label", 1, max(3, `len'))) {
		vl_label `0'
		exit
	}

	if ("`subcmd'" == substr("list", 1, `len')) {
		vl_list `0'
		exit
	}

	if ("`subcmd'" == substr("modify", 1, max(3, `len'))) {
		vl_create_modify 0 : `0'
		exit
	}

	if ("`subcmd'" == "move") {
		vl_move `0'
		exit
	}

	if ("`subcmd'" == "rebuild") {
		vl_rebuild `0'
		exit
	}

	if ("`subcmd'" == "set") {
		vl_set `0'
		exit
	}

	if ("`subcmd'" == substr("substitute", 1, max(3, `len'))) {
		vl_substitute `0'
		exit
	}

	di as err "{bf:`subcmd'} invalid {bf:vl} subcommand"
	exit 198
end

///////////////////////////////// vl clear //////////////////////////////////
//
//	System or user
//
//		vl clear [, SYStem USER ]
//
/////////////////////////////////////////////////////////////////////////////

program vl_clear
	syntax [, SYStem USER ]

	// It is important this routine does not check whether we are vl set.
	// Any remnants must be removed.

	if ("`system'`user'" == "") {
		local system system
		local user   user
	}

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	if ("`user'" != "") {
		.`vl'.erase_vluser_var_chars
		.`vl'.erase_vlusernames
		.`vl'.erase_vlfvnames
		.`vl'.vluser_set = 0
	}

	if ("`system'" != "") {
		.`vl'.erase_vlsys_var_chars
		.`vl'.erase_vlsysnames

		.`vl'.is_vluser_set is_vluser_set

		if (!`is_vluser_set') {
			char _dta[_vl_version_1]
		}
	}
end

//////////////////////////////// vl create //////////////////////////////////
//
//  User only
//
//	vl {create | modify} <vlusername> = <vlname>
//				          = (<varlist>)
//			                  = <vlname> + {<vlname> | (<varlist>)}
//			                  = <vlname> - {<vlname> | (<varlist>)}
//
/////////////////////////////////////////////////////////////////////////////

// vlusernames cannot be vlsysnames

program vl_create_modify

	// Get arguments.

	gettoken create 0 : 0
	gettoken colon  0 : 0

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	if (!`create') {
		.`vl'.assert_vluser_set
	}

	// Parse.

	// <lhsname>. Note that names for -vl create- are checked immediately
	// before execution.

	local pchars `" =+-()"'

	gettoken lhsname 0 : 0, parse("`pchars'")

	if (!`create') {
		.`vl'.assert_vlname `lhsname', user
	}

	// =

	gettoken eqsign 0 : 0, parse("`pchars'")
	.`vl'.assert_eq_sign "`eqsign'"

	// get_vlname_or_varlist returns either rhs1name or rhs1list,
	// not both. It checks that rhs1name is an existing vlname,
	// and that rhs1list is a valid nonempty varlist. It does not
	// check whether rhs1name contains variables.

	.`vl'.get_vlname_or_varlist `0', system user
	local rhs1name `s(vlname)'
	local rhs1list `s(varlist)'
	local 0        `s(rest)'

	if ("`rhs1name'" != "") {
		.`vl'.note_if_vlname_empty `rhs1name'
	}

	// See if that is all.

	if (`"`0'"' == "") {

		// Execute.

		if ("`rhs1name'" != "") {
			local rhs1list ${`rhs1name'}
		}

		if (`create') {
			.`vl'.add_new_vlname `lhsname'
		}

		.`vl'.modify_vluser n : `lhsname' `rhs1list'

		if (`create') {
			CreateNote `lhsname' `n'
		}
		else {
			ReCreateNote `lhsname'
		}

		exit
	}

	// Continue parse.

	gettoken op 0 : 0, parse("`pchars'")
	.`vl'.assert_operator `op'

	if ("'rhs1name'" == "") {

di as err "{bf:(}{it:varlist}{bf:)} found where {it:vlname} expected"

		exit 198
	}

	.`vl'.get_vlname_or_varlist `0', system user
	local rhs2name `s(vlname)'
	local rhs2list `s(varlist)'

	.`vl'.assert_next_token_nothing `s(rest)'

	if ("`rhs2name'" != "") {
		.`vl'.note_if_vlname_empty `rhs2name'

		local rhs2macname global(`rhs2name')
	}
	else {
		local rhs2macname rhs2list
	}

	// Execute.

	if ("`op'" == "+") {
		local rhslist : list global(`rhs1name') | `rhs2macname'
	}
	else {
		local rhslist : list global(`rhs1name') - `rhs2macname'
	}

	if (`create') {
		.`vl'.add_new_vlname `lhsname'
	}

	.`vl'.modify_vluser n : `lhsname' `rhslist'

	if (`create') {
		CreateNote `lhsname' `n'
	}
	else if ("`lhsname'" == "`rhs1name'") {
		ModifyNote `lhsname' `n'
	}
	else {
		ReCreateNote `lhsname' `n'
	}
end

program CreateNote
	args name n

	di as txt "{p 0 6 2}"
	di as txt "note: {bf:$}{bf:`name'} initialized with `n'"
	di as txt plural(`n', "variable")
	di as txt "{p_end}"
end

program ReCreateNote
	args name

	local n : list sizeof global(`name')

	di as txt "{p 0 6 2}"
	di as txt "note: {bf:$}{bf:`name'} reinitialized with `n'"
	di as txt plural(`n', "variable")
	di as txt "{p_end}"
end

program ModifyNote
	args name n

	if (`n' >= 0) {
		local addedto "added to"
	}
	else {
		local addedto "removed from"
		local n = -`n'
	}

	di as txt "{p 0 6 2}"
	di as txt "note: `n'"
	di as txt plural(`n', "variable")
	di as txt "`addedto' {bf:$}{bf:`name'}"
	di as txt "{p_end}"
end

////////////////////////////////// vl dir ///////////////////////////////////
//
//	System or user
//
//		vl dir [, SYStem USER ]
//
/////////////////////////////////////////////////////////////////////////////

program vl_dir, rclass
	syntax [,	       ///
		  SYStem       ///
		  USER	       ///
		  COUNTS(name) /// undocumented; used by vl_set
		  noBLANK      /// undocumented; used by vl_set
		]

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	.`vl'.assert_vlsys_or_vluser_set

	.`vl'.check_system_user_options, `system' `user'
	local system `s(system)'
	local user   `s(user)'

	if ("`blank'" == "") {
		di
	}
	
	di as txt "{hline 18}{c TT}{hline 60}"
	di as txt "{col 19}{c |}{col 42}Macro's contents"
	di as txt "{col 19}{c LT}{hline 60}"
	di as txt "Macro{col 19}{c |}  # Vars   Description"
	di as txt "{hline 18}{c +}{hline 60}"

	if ("`system'" != "") {

		.`vl'.get_number_of_vlsysnames n_vlsysnames

		di as txt "System{col 19}{c |}"

		local total = 0

		forvalues i = 1/`n_vlsysnames' {

			.`vl'.get_vlsysname name : `i'

			.`vl'.get_desc_of_vlsysname desc : `name'

			if ("`counts'" != "") {
				local n = `counts'[1, `i']
			}
			else {
				.`vl'.get_count_of_vlsysname n : `name'
			}

			local total = `total' + `n'

			return scalar k_`name' = `n'

			di as res _col(3) %-16s ("$"+"`name'") _c
			di as txt "{col 19}{c |} " _asis _c 
			di as txt %7.0fc `n' "   `desc' " _c
			di as txt plural(`n', "variable")
		}

		return scalar k_system = `total'
		
		.`vl'.get_vlsysnames vlsysnames
		
		return local vlsysnames `vlsysnames'
	}

	if ("`user'" != "") {

		.`vl'.get_vlusernames vlusernames

		di as txt "User{col 19}{c |}"

		foreach name of local vlusernames {

			.`vl'.get_desc_of_vlusername desc : `name'

			.`vl'.get_count_of_vlusername n : `name'

			return scalar k_`name' = `n'

			local name = abbrev("`name'", 14)

			di as res _col(3) %-16s ("$"+"`name'") _c
			di as txt "{col 19}{c |} " _asis _c 
			di as txt %7.0fc `n' _skip(3) _c

			if (`"`desc'"' != "") {
				di as txt `"`desc'"'
			}
			else {
				di as txt plural(`n', "variable")
			}
		}

		.`vl'.get_count_of_distinct_vluser total

		return scalar k_user = `total'
		
		return local vlusernames `vlusernames'
		
		// vlfvnames
		
		.`vl'.get_vlfvnames vlfvnames

		foreach name of local vlfvnames {

			.`vl'.get_desc_of_vlusername desc : `name'

			local name = abbrev("`name'", 14)

			di as res _col(3) %-16s ("$"+"`name'") _c
			di as txt "{col 19}{c |} " _asis _c 
			di as txt _skip(10) _c

			if (`"`desc'"' != "") {
				di as txt `"`desc'"'
			}
			else {
				di as txt "factor-variable list"
			}
		}
		
		return local vlfvnames `vlfvnames'
	}

	di as txt "{hline 18}{c BT}{hline 60}"
end

///////////////////////////////// vl drop ///////////////////////////////////
//
//	vl drop {<vlnamelist> | (<varlist>)} [, SYStem USER ]
//
/////////////////////////////////////////////////////////////////////////////

program vl_drop
	syntax anything [, SYStem USER ]

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	.`vl'.assert_vlsys_or_vluser_set

	.`vl'.check_system_user_options, `system' `user'
	local system `s(system)'
	local user   `s(user)'
	
	if ("`user'" != "") {
		local fv fv
	}

	// Get starting vlsysnames and vlusernames.

	.`vl'.get_vlsysnames vlsysnames
	.`vl'.get_vlusernames vlusernames
	
	.`vl'.get_vlnamelist_or_varlist `anything', `system' `user' `fv'
	local vlnamelist `s(vlnamelist)'
	local varlist    `s(varlist)'

	if ("`vlnamelist'" != "") {
	
		local n_vlnames : list sizeof vlnamelist
		local i 0

		foreach vlname of local vlnamelist {

			.`vl'.is_vlsysname is_sys : `vlname'

			if (`is_sys') {
				.`vl'.drop_vlsysname `vlname'
			}
			else {
				.`vl'.is_vlusername is_vlusername : `vlname'
		
				if (`is_vlusername') {
					.`vl'.drop_vlusername `vlname'
				}
				else {
					.`vl'.drop_vlfvname `vlname'
				}
			}
			
			if (`++i' < `n_vlnames') {
				.`vl'.update
			}
		}
	
		exit
	}
	
	// If here, varlist.
	
	if ("`user'" != "") {
		.`vl'.get_count_of_distinct_vluser n_old
	}

	if ("`system'" != "" & "`user'" == "") {
		.`vl'.assert_variables_in_vlsys `varlist'
		.`vl'.remove_varlist_from_vlsys `varlist'
	}
	else if ("`system'" == "" & "`user'" != "") {
		.`vl'.assert_variables_in_vluser `varlist'
		.`vl'.remove_varlist_from_vluser `varlist'
	}
	else {
		.`vl'.assert_variables_in_vl `varlist'
		.`vl'.remove_varlist_from_vlsys  `varlist'
		.`vl'.remove_varlist_from_vluser `varlist'
	}

	// Summarize results for varlists only.

	if ("`varlist'" != "") {

		if ("`system'" != "") {

			.`vl'.get_diff_counts_of_vlsys d : _all

			local n_sys_removed = -`d'

			DisplayNumber d_n_sys_removed : `n_sys_removed'
		}

		if ("`user'" != "") {

			.`vl'.get_count_of_distinct_vluser n_new

			local n_user_removed = `n_old' - `n_new'

			DisplayNumber d_n_user_removed : `n_user_removed'
		}

		local n_vars : list sizeof varlist

		DisplayNumber d_n_vars : `n_vars'

		di as txt "{p 0 6 2}"
		di as txt "note: `d_n_vars'"
		di as txt plural(`n_vars', "variable")
		di as txt "specified;"

		if ("`system'" != "") {
			if ("`user'" != "") {
				local semicolon ";"
			}

			di as txt "`note'`d_n_sys_removed'"
			di as txt plural(`n_sys_removed', "variable")
			di as txt "removed from {bf:vl} system macros`semicolon'"

			local note  // erase
		}

		if ("`user'" != "") {
			di as txt "`note'`d_n_user_removed'"
			di as txt plural(`n_user_removed', "variable")
			di as txt "removed from {bf:vl} user macros"
		}

		di as txt "{p_end}"
	}

	// Display results.

	di as txt
	di as txt "{hline 36}"
	di as txt "Macro                      # Removed"
	di as txt "{hline 36}"

	if ("`system'" != "") {

		di as txt "System"

		foreach name of local vlsysnames {

			.`vl'.get_diff_counts_of_vlsys d : `name'

			local d = -`d'

			DisplayCount `name' `d'
		}
	}

	if ("`user'" != "") {

		di as txt "User"

		foreach name of local vlusernames {

			.`vl'.get_diff_counts_of_vluser d : `name'

			local d = -`d'

			DisplayCount `name' `d'
		}
	}

	di as txt "{hline 36}"
end

program DisplayCount
	args name number
	
	local name = abbrev("`name'", 23)

	di as res "  $" "`name'" _col(28) as res %9.0fc `number'
end

//////////////////////////////// vl label ///////////////////////////////////
//
//  User only
//
//		vl label <vlusername> ["<label>"]
//
/////////////////////////////////////////////////////////////////////////////

program vl_label
	gettoken vlusername 0 : 0
	gettoken label      0 : 0

	if (`"`0'"' != "") {
		di as err `"{p}`0' found where nothing expected{p_end}"'
		exit 198
	}

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	.`vl'.assert_vluser_set

	local label = udsubstr(`"`label'"', 1, 49)
	
	.`vl'.set_desc_of_vlusername `vlusername' `"`label'"'
end

//////////////////////////////// vl move ////////////////////////////////////
//
//	System only
//
//		vl move <vlsysname_from> to <vlsysname_to>
//
//		vl move (<varlist>)      to <vlsysname_to>
//
/////////////////////////////////////////////////////////////////////////////

program vl_move

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	.`vl'.assert_vlsys_set

	// Parsing
	//
	// vl move <vlsysname_from>
        //         (<varlist>)

	.`vl'.get_vlname_or_varlist `0', system
	local name_from `s(vlname)'
	local list_from `s(varlist)'
	local 0         `s(rest)'

	if ("`name_from'" != "") {
		.`vl'.note_if_vlname_empty `name_from'
	}
	else {  // list_from
		.`vl'.assert_variables_in_vlsys `list_from', move
	}

	// vl move ... <vlsysname>

	gettoken name_to 0 : 0, parse(" ()")

	.`vl'.assert_vlname `name_to', system  // OK if empty

	.`vl'.assert_next_token_nothing `0'

	// Execute command.

	if ("`list_from'" != "") {
		global vl__tmp__ `list_from'
		local name_from "vl__tmp__"
	}

	local n_specified : list sizeof global(`name_from')

	.`vl'.move_vlsys_from_to `name_from' `name_to'

	global vl__tmp__  // erase macro

	// Get number of variables added to `name_to'.

	.`vl'.get_diff_counts_of_vlsys n_moved : `name_to'

	// Summarize results.

	DisplayNumber d_n_specified : `n_specified'
	DisplayNumber d_n_moved     : `n_moved'

	if (`n_specified' != `n_moved') {
		local semicolon ;
	}

	di as txt "{p 0 6 2}"
	di as txt "note: `d_n_specified'"
	di as txt plural(`n_specified', "variable")
	di as txt "specified and `d_n_moved'"
	di as txt plural(`n_moved', "variable")
	di as txt "moved`semicolon'"
	di as txt "{p_end}"

	if (`n_specified' != `n_moved') {
	
		local n_not_moved = `n_specified' - `n_moved'
		
		di as txt "{p 6 6 2}"
		di as txt "the"

		if (`n_not_moved' > 0) {
			
			di as txt plural(`n_not_moved',          ///
				         "other variable was",   ///
				         "other variables were")
		}
		else {
			di as txt plural(`n_specified',    ///
				         "variable was",   ///
				         "variables were")
		}
		
		di as txt "already in {bf:$}{bf:`name_to'}"
		di as txt "{p_end}"
	}

	// Display changes in a table.

	di
	di as txt "{hline 30}"
	di as txt "Macro          # Added/Removed"
	di as txt "{hline 30}"

	.`vl'.get_vlsysnames vlsysnames

	foreach name of local vlsysnames {

		.`vl'.get_diff_counts_of_vlsys d : `name'
		
		di as res "$" "`name'" _col(22) as res %9.0fc `d'
	}

	di as txt "{hline 30}"
end

program DisplayNumber
	args macname colon number

	local number : di %11.0fc `number'
	local number = strtrim("`number'")

	c_local `macname' `number'
end

/////////////////////////////// vl rebuild //////////////////////////////////
//
//	System and user
//
//		vl rebuild
//
//			sets vlsysname and vlusername macros based on chars
//
/////////////////////////////////////////////////////////////////////////////

program vl_rebuild

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	.`vl'.assert_next_token_nothing `0'

	.`vl'.assert_vlchars_set

	di as txt "Rebuilding {bf:vl} macros ..."

	.`vl'.set_vl_macros_from_var_chars
	
	// Rebuild fv_vlnamelist.
	
	.`vl'.get_vlfvnames names
	
	foreach name of local names {
	
		local vl_fv_exp : char _dta[_vl__`name']
	
		.`vl'.expand_fv_vlnamelist  `vl_fv_exp'
		
		global `name' `s(varlist)'
	}

	vl dir
end

///////////////////////////// vl substitute /////////////////////////////////
//
//	System and user
//
//		vl SUBstitute <vlusername> = <factor_vlnamelist>
//
/////////////////////////////////////////////////////////////////////////////

program vl_substitute

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')
	
	.`vl'.assert_vlsys_or_vluser_set
	
	// Parse <lhsname> = ....
	
	// <lhsname>. Note that names are checked immediately before execution.
	
	local pchars `" =.()#"'

	gettoken lhsname 0 : 0, parse(" =")

	// =

	gettoken eqsign 0 : 0, parse(" =")
	.`vl'.assert_eq_sign "`eqsign'"
	
	// <factor_vlnamelist>.
	
	.`vl'.expand_fv_vlnamelist `0'
	
	// Create new username.
	
	.`vl'.add_new_vlname `lhsname', fv

	// Save original expression in char. lhsname is 27 characters max.
	
	char _dta[_vl__`lhsname'] `s(vl_fv_exp)'
	
	// Create macro.
	
	global `lhsname' `s(varlist)'	
end

// END OF FILE
