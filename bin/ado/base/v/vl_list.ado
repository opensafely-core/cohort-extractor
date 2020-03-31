*! version 1.0.0  19may2019

////////////////////////////////// vl list //////////////////////////////////
//
//	vl List [<vlnames> | (varlist)] [, options ]
//
//	Default interpretations:
//
//		vl list 	  <-- all vlnames
//		vl list * | _all  <-- error
//
//		vl list, system	  <-- all vlsysnames
//
//		vl list, user	  <-- all vlusernames
//
//		vl list (*)	  <-- all numeric variables, classified or not
//		vl list (_all)	  <-- same as above
//		vl list ()	  <-- error
//
//		vl list (* | _all), strok   <-- all variables including string
//
//	When both vlsys and vluser are set, all variables are by default listed
//      twice, giving both their vlsys and vluser classifications.
//
//	Unclassified variables in (varlist) syntax described as
//
//		vl list (stringvar), all           <-- "string variable"
//
//		vl list (not_classified_var)       <-- listed twice
//						       "not in vlsys"
//						       "not in vluser"
//
//		vl list (in_sys_but_not_user_var)  <-- listed twice
//						       "<vlsysname>"
//						       "not in vluser"
//
//		vl list (not_in_sys_but_in_user_var)  <-- listed twice
//						          "not in vlsystem"
//						          "<vlusername>"
//
//	To see only vlsys, specify option -system-.
//	To see only vluser, specify option -user-.
//      To not see unclassified variables, use the -vl list [<vlnames>]
//	syntax.
//
/////////////////////////////////////////////////////////////////////////////

program vl_list, rclass
	version 16

	syntax [anything]				///
		[, 					///
		   SYStem				///
		   USER					///
		   SORT					///
		   STROK				///
		   MINimum				/// display
		   MAXimum				/// display
		   OBServations				/// display
		   SET					/// undocumented; used by vl_set
		   CLASS(name)				/// undocumented; used by vl_set
		   noHEADer				/// undocumented; used by vl_set
		   HEADERONLY				/// undocumented; used by vl_set
		   FOOTERONLY				/// undocumented; used by vl_set
		   VARLENGTH(numlist integer max=1 >=1) /// undocumented; used by vl_set
		   *                                    /// LSTRETCH or NOLSTRETCH
		]

	opts_exclusive "`header' `headeronly' `footeronly'"
	
	ParseLstretch, `options'
	local lstretch `s(lstretch)'  // "lstretch" or ""

	if ("`class'" == "") {
		tempname vl stmp utmp
		.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')
	}
	else {  // use class instance created by -vl set-

		local vl `class'
	}

	.`vl'.assert_vlsys_or_vluser_set

	.`vl'.check_system_user_options, `system' `user'
	local system `s(system)'
	local user   `s(user)'

	// anything must either be a list of vlnames (vlsysnames or vlusernames)
	// or a varlist. It cannot be a mix of vlnames and varnames.

	if (`"`anything'"' == "") {  // all vlsysnames and vlusernames

		if ("`system'" != "") {
			.`vl'.get_vlsysnames vlsysnames
		}

		if ("`user'" != "") {
			.`vl'.get_vlusernames vlusernames
		}

		local vlnamelist `vlsysnames' `vlusernames'
	}
	else {
		.`vl'.get_vlnamelist_or_varlist `anything', `system' `user' ///
							    list `strok'
		local vlnamelist `s(vlnamelist)'
		local varlist    `s(varlist)'
	}

	// Create
	//
	//	vlnamelist = list of vlnames
	//	varlist    = matching list of varnames
	//
	// Note: vlnamelist and varlist are the same length. Varnames are
	// repeated if they are in more than one vlname macro.

	if ("`vlnamelist'" != "") {
		VarnamesOfVLnames `vlnamelist', class(`vl') ///
						`sort' `system' `user'

		if ("`set'" == "" & "`r(varlist)'" == "") {
			local n : list sizeof vlnamelist
		
			di as txt "{p 0 6 2}note: {bf:`vlnamelist'}"
			di as txt plural(`n', "contains", "contain")
			di as txt "no variables{p_end}"
			exit
		}
	}
	else {
		VLnamesOfVarlist `varlist', class(`vl') ///
					    `sort' `system' `user'
	}

	local vlnamelist `r(vlnamelist)'
	local varlist    `r(varlist)'
	
	// Display options.

	if ("`varlength'" == "") {
		.`vl'.get_max_length_names varlength : `varlist'
	}
	
	.`vl'.get_max_length_names vlnamelength : `vlnamelist'
	
	GetDisplayOpts, varlength(`varlength') vlnamelength(`vlnamelength') ///
		        `minimum' `maximum' `observations' `lstretch'
	
	local di_opts `s(di_opts)'

	// Display footer when footeronly.

	if ("`footeronly'" != "") {
		Footer, `di_opts'
		exit
	}

	// Header.

	if ("`header'" == "") {
		Header, `di_opts'

		if ("`headeronly'" != "") {
			exit
		}
	}

	// Zero counts of vlsysnames.

	if ("`system'" != "") {
		.`vl'.get_vlsysnames vlsysnames

		foreach vlname of local vlsysnames {
			local k_`vlname' 0
			local rlist `rlist' k_`vlname'
		}

		local k_system     0
		local k_not_system 0

		local rlist `rlist' k_system k_not_system

		if ("`strok'" != "") {
			local k_string 0
			local rlist `rlist' k_string
		}
	}

	if ("`user'" != "") {
		local k_not_user 0
		local rlist `rlist' k_not_user

		if ("`strok'" != "" & "`system'" == "") {
			local k_string 0
			local rlist `rlist' k_string
		}
	}

	// Body.

	local nlines : list sizeof vlnamelist

	forvalues i = 1/`nlines' {

		local vlname : word `i' of `vlnamelist'
		local x      : word `i' of `varlist'

		if ("`observations'" != "") {

			.`vl'.is_string_variable is_string : `x'

			if (`is_string' & "`: char `x'[_vl_N]'" == "") {
				qui count if !missing(`x')
				char `x'[_vl_N] `r(N)'
			}
		}

		Body `vlname' `x', class(`vl') `di_opts'

		// Increment number of variables listed in vlname.

		GetReturnName rname : `vlname'

		if ("`k_`rname''" == "") {
			local k_`rname' 1
			local rlist `rlist' k_`rname'
		}
		else {
			local ++k_`rname'
		}

		.`vl'.is_vlsysname is_vlsysname : `vlname'

		if (`is_vlsysname') {
			local ++k_system
		}
		else {
			.`vl'.is_vlusername is_vlusername : `vlname'

			if (`is_vlusername') {
				local vlusernames : list vlusernames | vlname
			}
		}
	}

	// Footer.

	if ("`header'" == "") {
		Footer, `di_opts'
	}

	// Set return.

	foreach rname of local rlist {
		return scalar `rname' = ``rname''
	}
	
	if ("`system'" != "") {
		return local vlsysnames `vlsysnames'
	}

	local varlist : list uniq varlist

	if ("`user'" != "") {

		// vluser variables can be listed more than once.
		// r(k_user) = # distinct variables in vluser.

		.`vl'.get_vluser_varlist allvluservars

		local vluservars : list varlist & allvluservars

		local k_user : list sizeof vluservars

		return scalar k_user = `k_user'
		
		return local vlusernames `vlusernames'
	}

	local k : list sizeof varlist

	return scalar k = `k'
end

program ParseLstretch, sclass
	syntax [, noLSTRETCH ]
	
	local nolstretch `lstretch'
	
	syntax [, LSTRETCH ]
	
	local lstretch `lstretch'
	
	if ("`lstretch'`nolstretch'" == "") {
		
		if (inlist(c(lstretch), "on", "")) {
			sreturn local lstretch lstretch
		}
		
		exit
	} 
	
	sreturn local lstretch `lstretch'
end

program GetDisplayOpts, sclass
	syntax, varlength(integer) vlnamelength(integer) ///
	        [ minimum maximum observations lstretch ]
	
	if ("`lstretch'" != "") {
		local linesize = max(c(linesize), 79)
	}
	else {
		local linesize 79
	}
	
	local vlnamelength = `vlnamelength' + 1  // "$`vlname'"
	
	local vlnamedefault 15
	
	local vlnamelength = max(`vlnamelength', `vlnamedefault')
		
	// Required elements: "Values" "Levels" 
	// 3 + 1 + 15 ("Values") + 6 ("Levels") = 25
	
	local width = 25 + `varlength' + `vlnamelength' 
	
	if ("`minimum'" != "") {
		local width = `width' + 10
	}
	
	if ("`maximum'" != "") {
		local width = `width' + 10
	}
	
	if ("`observations'" != "") {
		local width = `width' + 11
	}
	
	// Minimum width with all options except varlength = 71.
	
	if (`width' > `linesize') {
	
		local extra = `width' - `linesize'
		
		local vlextra = `vlnamelength' - `vlnamedefault'
	
		if (`vlextra' > 0) {
		
			local half  = floor(`extra'/2)
			local bhalf = `extra' - `half'  // bigger half
			
			if (`bhalf' < `vlextra') {
				local vlnamelength = `vlnamelength' - `bhalf'
				local varlength    = `varlength'    - `half'
			}
			else {
				local vlnamelength = `vlnamedefault'
				local varlength    = `varlength' - `extra' ///
				                     + `vlextra'
			}
		}
		else {
			local varlength = `varlength' - `extra'  // >= 8
		}
		
		local width `linesize'
	}
		
	sreturn local di_opts width(`width')               ///
	                      varlength(`varlength')       ///
	                      vlnamelength(`vlnamelength') ///
	                      `minimum'                    ///
	                      `maximum'                    ///
	                      `observations'	                         
end
	
program GetReturnName
	args macname colon vlname

	if ("`vlname'" == "_user_string") {
		local vlname string
	}
	else if (substr("`vlname'", 1, 1) == "_") {
		local vlname = substr("`vlname'", 2, .)
	}

	c_local `macname' `vlname'
end

program VarnamesOfVLnames, rclass
	syntax namelist, class(name) [ sort system user ]

	local vl `class'

	// Already known to be vlnames.

	if ("`system'" != "" & "`user'" == "") {
		.`vl'.assert_vlnames `namelist', system
	}
	else if ("`system'" == "" & "`user'" != "") {
		.`vl'.assert_vlnames `namelist', user
	}

	foreach vlname of local namelist {

		// Get variables in vlname.

		local n : list sizeof global(`vlname')

		if (`n' > 0) {
			.`vl'.get_dups_of_string nvlnames : `n' `vlname'

			local vlnamelist `vlnamelist' `nvlnames'
			local varlist    `varlist'    ${`vlname'}

			if ("`sort'" != "") {
				Index, class(`vl') vlname(`vlname') ndup(`n')
				local sortlist `sortlist' `r(index)'
			}
		}
	}

	if ("`varlist'" != "") {
		.`vl'.assert_variables_in_vl `varlist'
	}

	if ("`sort'" != "") {
		mata: SortByIndexVarlist("sortlist", "varlist", "vlnamelist")
	}

	return local vlnamelist `vlnamelist'
	return local varlist    `varlist'
end

program VLnamesOfVarlist, rclass
	syntax varlist, class(name) [ sort system user ]

	local vl `class'

	foreach x of local varlist {

		// Get vlsysnames.

		if ("`system'" != "") {

			.`vl'.get_vlsysname_of_varname vlsysname : `x'

			if ("`vlsysname'" == "") {

				.`vl'.is_string_variable is_string : `x'

				if (`is_string') {
					local vlsysname _string
				}
				else {
					local vlsysname _not_system
				}
			}

			local varlistout `varlistout' `x'
			local vlnamelist `vlnamelist' `vlsysname'

			if ("`sort'" != "") {
				Index, class(`vl') vlname(`vlsysname')
				local sortlist `sortlist' `r(index)'
			}
		}

		// Get vlusernames.

		if ("`user'" != "") {

			.`vl'.get_vlusernames_of_varname vlusernames : `x'

			foreach vlusername of local vlusernames {

				local varlistout `varlistout' `x'
				local vlnamelist `vlnamelist' `vlusername'

				if ("`sort'" != "") {
					Index, class(`vl') vlname(`vlusername')
					local sortlist `sortlist' `r(index)'
				}
			}

			if ("`vlusernames'" == "") {

				local vlusername  // erase

				.`vl'.is_string_variable is_string : `x'

				if (!`is_string' | "`system'" == "") {

	// BEGIN BLOCK
	// When -system-, strings are already listed. Do not list twice.

	if (`is_string') {
		local vlusername _user_string
	}
	else {
		local vlusername _not_user
	}

	local varlistout `varlistout' `x'
	local vlnamelist `vlnamelist' `vlusername'

	if ("`sort'" != "") {
		Index, class(`vl') vlname(`vlusername')
		local sortlist `sortlist' `r(index)'
	}

	// END BLOCK
				}
			}
		}
	}

	if ("`sort'" != "") {
		mata: SortByVarlistIndex("sortlist", "varlistout", "vlnamelist")
	}

	return local vlnamelist `vlnamelist'
	return local varlist    `varlistout'
end

program Index, rclass
	syntax , class(name) vlname(name) [ ndup(integer 1) ]

	local vl `class'

	local i 0

	if ("`vlname'" == "_string") {
		local i 98
	}
	else if ("`vlname'" == "_user_string") {
		local i 999998
	}
	else if ("`vlname'" == "_not_system") {
		local i 99
	}
	else if ("`vlname'" == "_not_user") {
		local i 999999
	}
	else {
		.`vl'.is_vlsysname is_vlsysname : `vlname'

		if (`is_vlsysname') {
			.`vl'.get_index_of_vlsysname i : `vlname'
		}
		else {
			.`vl'.is_vlusername is_vlusername : `vlname'

			if (`is_vlusername'){
				.`vl'.get_index_of_sorted_vlusername i : `vlname'
				local i = `i' + 100
			}
		}
	}

	local index : di %06.0f `i'  // leading zeros so sorts properly
				     // as a string

	if (`ndup' > 1) {
		.`vl'.get_dups_of_string index : `ndup' `index'
	}

	return local index `index'
end

program Header
	syntax ,  width(integer)	///
	          varlength(integer)	///
	          vlnamelength(integer) ///
		[			///
		  minimum		///
		  maximum		///
		  observations		///
		]

	local w1 = `varlength' + 1
	local w2 = `width' - `w1' - 1

	local c1 = `varlength' - 7
	local c2 = `varlength' + 4
	local c3 = `c2' + `vlnamelength' + 1
	local c4 = `c3' + 15
	local c  = `c4' +  6

	local header "{col `c1'}Variable {c |}{col `c2'}Macro"
	local header "`header'{col `c3'}Values{col `c4'}Levels"

	if ("`minimum'" != "") {
		local c = `c' + 7
		local header "`header'{col `c'}Min"
		local c = `c' + 3
	}

	if ("`maximum'" != "") {
		local c = `c' + 7
		local header "`header'{col `c'}Max"
		local c = `c' + 3
	}

	if ("`observations'" != "") {
		local c = `c' + 8
		local header "`header'{col `c'}Obs"
	}

	di
	di as txt "{hline `w1'}{c TT}{hline `w2'}"
	di as txt "`header'"
	di as txt "{hline `w1'}{c +}{hline `w2'}"
end

program Body
	syntax namelist(min=2 max=2),  class(name)	     ///
				       width(integer)	     ///
	          		       varlength(integer)    ///
	          		       vlnamelength(integer) ///
				    [			     ///
		  		       minimum		     ///
		  		       maximum		     ///
		  		       observations	     ///
				    ]

	local vl `class'

	local vlname : word 1 of `namelist'
	local x      : word 2 of `namelist'

	if (inlist("`vlname'", "_string", "_user_string")) {
		local vldisplay "{txt:string variable}"
		local desc "strings"
	}
	else if ("`vlname'" == "_not_system") {
		local vldisplay "{txt:not in vlsystem}"
	}
	else if ("`vlname'" == "_not_user") {
		local vldisplay "{txt:not in vluser}"
	}
	else {
		local vlname = abbrev("`vlname'", `vlnamelength' - 1)
		local vldisplay "{res:$}{res:`vlname'}"

		// `x' may have a vlsys description even when
		// `vlname' is a vlusername.

		.`vl'.get_vlsys_desc_of_varname desc : `x'
		
		local lendesc = udstrlen(`"`desc'"')
		
		if (`lendesc' > 15) {
			local desc = udsubstr(`"`desc'"', 1, 15)
		}
	}

	.`vl'.get_vlsys_levels_of_varname levels : `x'

	local xname = abbrev("`x'", `varlength')
	
	local xlength = udstrlen("`xname'")
	
	local levlength = strlen("`levels'")

	local c1 = `varlength' - `xlength' + 1 
	local c2 = `varlength' + 4
	local c3 = `c2' + `vlnamelength' + 1
	local c4 = `c3' + 21 - `levlength'
	
di `"{col `c1'}{txt}`xname' {c |}{col `c2'}`vldisplay'{col `c3'}{res}`desc'{col `c4'}`levels'"' _c

	if ("`minimum'" != "") {

		local min : char `x'[_vl_min]

		if ("`min'" != "") {
			di as res " " %9.0g `min' _c
		}
		else {
			di "{space 10}" _c
		}
	}

	if ("`maximum'" != "") {

		local max : char `x'[_vl_max]

		if ("`max'" != "") {
			di as res " " %9.0g `max' _c
		}
		else {
			di "{space 10}" _c
		}
	}

	if ("`observations'" != "") {

		local N : char `x'[_vl_N]

		if ("`N'" != "") {
			di as res " " %10.0fc `N' _c
		}
	}

	di
end

program Footer
	syntax , width(integer) varlength(integer) [ * ]
	
	local w1 = `varlength' + 1
	local w2 = `width' - `w1' - 1

	di as txt "{hline `w1'}{c BT}{hline `w2'}"
end

/////////////////////////////// Mata utility ////////////////////////////////

version 16
mata:
mata set matastrict on

void SortByIndexVarlist(string scalar sortindex,
			string scalar varlist,
			string scalar vlnamelist)
{
	string matrix S

	S = tokens(st_local(sortindex))' ,
	    tokens(st_local(varlist))'   ,
	    tokens(st_local(vlnamelist))'

	if (rows(S) <= 1) {
		return
	}

	_sort(S, (1, 2))

	st_local(varlist,    invtokens(S[., 2]'))
	st_local(vlnamelist, invtokens(S[., 3]'))
}

void SortByVarlistIndex(string scalar sortindex,
			string scalar varlist,
			string scalar vlnamelist)
{
	string matrix S

	S = tokens(st_local(varlist))'   ,
	    tokens(st_local(sortindex))' ,
	    tokens(st_local(vlnamelist))'

	if (rows(S) <= 1) {
		return
	}

	_sort(S, (1, 2))

	st_local(varlist,    invtokens(S[., 1]'))
	st_local(vlnamelist, invtokens(S[., 3]'))
}

end

// END OF FILE
