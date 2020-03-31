*! version 1.0.8  20jan2015

/*
	mi register imputed [<varlist>]

	mi register passive [varlist]

	mi register regular [<varlist>]

		abbreviations are 3 letters
*/

program mi_cmd_register 
	version 11

	gettoken subcmd 0 : 0, parse(" :,=[]()+-")
	local l = strlen("`subcmd'")

	if ("`subcmd'"==bsubstr("imputed", 1, max(3,`l'))) {
		mi_register_imputed `0'
	}
	else if ("`subcmd'"==bsubstr("passive", 1, max(3,`l'))) {
		mi_register_passive `0'
	}
	else if ("`subcmd'"==bsubstr("regular", 1, max(3,`l'))) {
		mi_register_regular `0'
	}
	else {
		local di "di as smcl as err"
		`di' "{p 0 4 2}"
		`di' "syntax error{break}
		`di' "syntax is {bf:mi register} {it:type varlist}"
		`di' "where {it:type} is {bf:imputed}, {bf:passive},"
		`di' "or {bf:regular}"
		`di' "{p_end}"
		exit 198
	}
end


/* -------------------------------------------------------------------- */
					/* mi register regular		*/
/*
	mi_register_regular [<varlist>]

*/

program mi_register_regular, rclass

	u_mi_assert_set
	syntax varlist			/* numeric not required		*/
	tempname msgno
	u_mi_no_sys_vars  "`varlist'" "{bf:mi register}"
	u_mi_no_wide_vars "`varlist'" "{bf:mi register}"
	no_repeated_vars  "`varlist'"
	if ("`_dta[_mi_style]'"=="flongsep") {
		u_mi_chk_longvnames "`varlist'" "mi register" "" "regular"
	}

	u_mi_certify_data, acceptable msgno(`msgno')

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'

	local error 0
	foreach v of local varlist {
		local in : list v in ivars
		if (`in') { 
			di as err "variable `v' already registered as imputed"
			local error 1
		}
		local in : list v in passive
		if (`in') {
			di as err "variable `v' already registered as passive"
			local error 1
		}
	}
	if (`error') { 
		exit 110
	}
	local toadd
	foreach v of local varlist {
		local in : list v in rvars
		if (`in') {
			di as txt "(variable `v' already registered as regular)"
		}
		else {
			local toadd `toadd' `v'
		}
	}
	if ("`toadd'"!="") {
		char _dta[_mi_rvars] `rvars' `toadd'
		u_mi_certify_data, proper msgno(`msgno')
	}
end


/* -------------------------------------------------------------------- */
					/* mi register imputed		*/

/*
	mi_register_imputed [<varlist>] [, passive]

	    option -passive- is not documented.  This routine is 
	    called by -mi_register_passive-.

	    mi_register_imputed can change the sort order of the data.
*/

program mi_register_imputed, rclass
	u_mi_assert_set

	if ("`_dta[_mi_style]'"=="wide" | "`_dta[_mi_style]'"=="flongsep") {
		syntax varlist(numeric) [, PASSIVE ]
	}
	else {
		syntax varlist(numeric) [, PASSIVE noLONGNAMESCHK /*undoc.*/  ]
	}
	u_mi_no_sys_vars  "`varlist'" "{bf:mi register}"
	u_mi_no_wide_vars "`varlist'" "{bf:mi register}"
	no_repeated_vars  "`varlist'"
	local vtype imputation
	if ("`passive'"!="") {
		local vtype passive
	}
	u_mi_chk_longvnames "`varlist'" "mi register" "`longnameschk'" "`vtype'"

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')

	u_mi_ds_notinlist "`varlist'" "`_dta[_mi_rvars]'"  ///
				"already registered as regular"
	if ("`passive'"=="") {
		local type     imputed
		local altype   passive
		local samelist `_dta[_mi_ivars]'
		local  altlist `_dta[_mi_pvars]'
		local samechar  _dta[_mi_ivars]
		local altchar   _dta[_mi_pvars]
	}
	else {
		local type     passive
		local altype  imputed
		local samelist `_dta[_mi_pvars]'
		local  altlist `_dta[_mi_ivars]'
		local samechar  _dta[_mi_pvars]
		local altchar   _dta[_mi_ivars]
	}
	foreach v of local varlist {
		local in : list v in samelist
		if (`in') {
			local badlist `badlist' `v'
		}
		else {
			local in : list v in altlist
			if (`in') {
				local rereglist `rereglist' `v'
			}
			else {
				local reglist `reglist' `v'
			}
		}
	}

	if ("`badlist'"!="") { 
		local n : word count `badlist'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "`variables'
		di as smcl as err "`badlist'"
		di as smcl as err "already registered as `type'"
		di as smcl as err "{p_end}"
		exit 110
	}

	nobreak {
		if ("`reglist'"!="") {
			mi_register_imputed_`_dta[_mi_style]' `reglist', ///
					`passive' msgno(`msgno')
		}
		if ("`rereglist'"!="") {
			local n : word count `rereglist'
			local variables = cond(`n'==1, "variable", "variables")
			local were      = cond(`n'==1, "was",      "were")
			di as txt as smcl "{p 0 1 2}"
			di as smcl "(`variables' `rereglist'"
			di as smcl "`were' registered as `altype',"
			di as smcl "now registered as `type')"
			di as smcl "{p_end}"
				
			local fromlist   ``altchar''
			local tolist     ``samechar''

			local fromlist : list fromlist - rereglist
			local tolist   : list tolist   | rereglist
			char `samechar' `tolist'
			char `altchar'  `fromlist'
			u_mi_certify_data, proper msgno(`msgno')
		}
	}
end



program mi_register_imputed_mlong
	syntax [varlist(default=none numeric)] [, PASSIVE MSGNO(string)]

	if ("`varlist'"=="") {
		exit
	}
	no_repeated_vars "`varlist'"

	if ("`varlist'"!="") {
		if ("`passive'"=="") {
			char _dta[_mi_ivars] `_dta[_mi_ivars]' `varlist'
			u_mi_certify_data, updatemissonly
		}
		else {
			char _dta[_mi_pvars] `_dta[_mi_pvars]' `varlist'
		}
	}
end


program mi_register_imputed_flong
	syntax [varlist(default=none numeric)] [, PASSIVE MSGNO(string)]

	if ("`varlist'"=="") {
		exit
	}

	if ("`passive'"=="") {
		char _dta[_mi_ivars] `_dta[_mi_ivars]' `varlist'
		u_mi_certify_data, updatemissonly
	}
	else {
		char _dta[_mi_pvars] `_dta[_mi_pvars]' `varlist'
		u_mi_certify_data, acceptable proper
	}
end

program mi_register_imputed_flongsep

	syntax [varlist(default=none numeric)] [, PASSIVE MSGNO(string)]

	if ("`varlist'"=="") {
		exit
	}

	if ("`passive'"=="") {
		char _dta[_mi_ivars] `_dta[_mi_ivars]' `varlist'
	}
	else {
		char _dta[_mi_pvars] `_dta[_mi_pvars]' `varlist'
	}
	u_mi_certify_data, proper msgno(`msgno')
end
		
program mi_register_imputed_wide

	novarabbrev nobreak mi_register_imputed_wide_u `0'
	u_mi_fixchars, acceptable
end


program mi_register_imputed_wide_u
	syntax [varlist(default=none numeric)] [, PASSIVE MSGNO(string)]

	local old_vars `_dta[_mi_ivars]'
	local M        `_dta[_mi_M]'

	local fulllist `_dta[_mi_ivars]' `_dta[_mi_pvars]'

	// add new system imputed variables
	mustbe_newvars 1 `M' "`varlist'"
	capture noi {
		addvars_wide       1  `M' "`varlist'"
	}
	if (_rc) {
		local rc = _rc 
		u_mi_wide_drop_i_vars 1  `M' "`varlist'"
		exit `rc'
	}

	if ("`passive'"=="") {
		char _dta[_mi_ivars] `_dta[_mi_ivars]' `varlist'
		foreach var of local varlist {
			qui replace _mi_miss = 1 if `var'==.
		}
	}
	else {
		char _dta[_mi_pvars] `_dta[_mi_pvars]' `varlist'
	}
end

program mustbe_newvars
	args i0 i1 varlist 

	local bad
	foreach name of local varlist {
		forvalues i=`i0'(1)`i1' {
			capture confirm new var _`i'_`name'
			if _rc==110 {
				local bad `bad' _`i'_`name'
			}
			else if _rc {
				confirm new var _`i'_`name'
			}
		}
	}
	if ("`bad'"=="") { 
		exit
	}
	local n : word count `bad'
	local variables = cond(`n'==1, "variable", "variables")
	local exist     = cond(`n'==1, "exists",   "exist")
	di as smcl as err "{p}"
	di as smcl as err "`variables'"
	di as smcl as err "`bad'"
	di as smcl as err "already `exist'"
	di as smcl as err "{p_end}"
	exit 110
end
		
program addvars_wide
	args i0 i1 varlist

	foreach name of local varlist {
		local ty : type `name'
		forvalues i=`i0'(1)`i1' {
			qui gen `ty' _`i'_`name' = `name'
		}
	}
end

program u_mi_wide_drop_i_vars
	args i0 i1 varlist 

	nobreak {
		foreach name of local varlist {
			forvalues i = `i0'(1)`i1' {
				capture drop _`i'_`name'
			}
		}
	}
end



/* -------------------------------------------------------------------- */
					/* mi_register_passive		*/

/*
	mi_register_passive [varlist]
*/


program mi_register_passive, rclass
	syntax varlist(numeric) [, noLONGNAMESCHK /*undoc.*/ ]
	mi_register_imputed `varlist', passive `longnameschk'
	return add
end

/* -------------------------------------------------------------------- */
					/* utilities			*/


program u_mi_ds_notinlist
	args elements list errmsg 

	local combined `elements' `list'
	local dups :   list dups combined
	if ("`dups'"!="") { 
		local n : word count `dups'
		local variables = cond(`n'==1, "variable", "variables")

		di as smcl as err "{p}"
		di as smcl as err "`variables'
		di as smcl as err "`dups'"
		di as smcl as err "`errmsg'"
		di as smcl as err "{p_end}"
		exit 110
	}
end

program no_repeated_vars 
	args vars

	local dups : list dups vars
	if ("`dups'" == "") {
		exit
	}

	local dups : list uniq dups 

	local n : word count `dups'
	local variables = cond(`n'==1, "variable", "variables")

	di as err "syntax error"
	di as err "{p 4 4 2}"
	di as err "You specified `variables' {bf}"
	di as err "`dups'"
	di as err "{rm}more than once.  Variables may not be repeated."
	di as err "{p_end}"
	exit 198
end
