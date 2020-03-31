*! version 1.3.3  13feb2015

/*

	Limits
		max(M) = 1000
*/


/* -------------------------------------------------------------------- */
					/* mi				*/

program mi, rclass
	version 11.0
	local version : di "version " string(_caller()) ":"

	set prefix mi

	gettoken subcmd 0 : 0, parse(" :,=[]()+-")

	local l = strlen("`subcmd'")

	if ("`subcmd'"=="add") {
		mi_cmd_add `0'
	}
	else if ("`subcmd'"=="append") {
		mi_cmd_append `0'
	}
	else if ("`subcmd'"=="convert") {
		mi_cmd_convert `0'
	}
	else if ("`subcmd'"=="copy") {
		mi_cmd_copy `0'
	}
	else if ("`subcmd'"==bsubstr("demote", 1, 6)) {
		mi_cmd_demote `0'
	}
	else if ("`subcmd'"==bsubstr("describe", 1, max(1,`l'))) {
		mi_cmd_describe `0'
	}
	else if ("`subcmd'"=="erase") {
		mi_cmd_erase `0'
	}
	else if ("`subcmd'"==bsubstr("estimate", 1, max(3,`l'))) {
		`version' mi_cmd_estimate `0'
	}
	else if ("`subcmd'"=="expand") {
		mi_cmd_expand `0'
	}
	else if ("`subcmd'"=="export") {
		mi_cmd_export `0'
	}
	else if ("`subcmd'"=="extract") {
		mi_cmd_extract `0'
	}
	else if ("`subcmd'"=="fvset") {
		mi_cmd_genericset "fvset `0'" "" all
	}
	else if ("`subcmd'"=="import") {
		mi_cmd_import `0'
	}
	else if ("`subcmd'"==bsubstr("impute",1,max(3,`l'))) {
		`version' mi_cmd_impute `0'
	}
	else if ("`subcmd'"=="merge") {
		mi_cmd_merge `0'
	}
	else if ("`subcmd'"==bsubstr("misstable", 1, max(6,`l'))) {
		mi_cmd_misstable `0'
	}
	else if ("`subcmd'"==bsubstr("passive", 1, max(3,`l'))) {
		mi_cmd_passive `0'
	}
	else if ("`subcmd'"=="post") {
		mi_cmd_post `0'
	}
	else if ("`subcmd'"=="predict") {
		`version' mi_cmd_predict `0'
	}	
	else if ("`subcmd'"=="predictnl") {
		`version' mi_cmd_predictnl `0'
	}
	else if ("`subcmd'"==bsubstr("query", 1, max(1,`l'))) {
		mi_cmd_query `0'
	}
	else if ("`subcmd'"==bsubstr("register", 1, max(3,`l'))) {
		mi_cmd_register `0'
	}
	else if ("`subcmd'"==bsubstr("rename", 1, max(3,`l'))) {
		mi_cmd_rename `0'
	}
	else if ("`subcmd'"=="replace0") {
		mi_cmd_replace0 `0'
	}
	else if ("`subcmd'"=="reshape") {
		mi_cmd_reshape `0'
	}
	else if ("`subcmd'"=="select") {
		mi_cmd_select `0'
	}
	else if ("`subcmd'"=="set") {
		mi_cmd_set `0'
	}
	else if ("`subcmd'"=="st") {
		mi_cmd_genericset "st `0'" "" na
	}
	else if ("`subcmd'"=="stjoin") {
		mi_cmd_stjoin `0'
	}
	else if ("`subcmd'"=="streset") {
		mi_cmd_genericset "streset `0'" ///
			"_st _d _t _t0 _origin _scalar _insmpl" na
	}
	else if ("`subcmd'"=="stset") {
		mi_cmd_genericset "stset `0'" ///
			"_st _d _t _t0 _origin _scalar _insmpl" na
	}
	else if ("`subcmd'"=="stsplit") {
		mi_cmd_stsplit `0'
	}
	else if ("`subcmd'"=="svyset") {
		mi_cmd_svyset `0'
	}
	else if ("`subcmd'"==bsubstr("testtransform", 1, max(6,`l'))) {
		mi_cmd_testtransform `0'
	}
	else if ("`subcmd'"=="test") {
		mi_cmd_test `0'
	}
	else if ("`subcmd'"=="tset") {
		mi_cmd_genericset "tsset `0'" "" reg
	}
	else if ("`subcmd'"=="tsset") {
		mi_cmd_genericset "tsset `0'" "" reg
	}
	else if ("`subcmd'"==bsubstr("unregister", 1, max(5,`l'))) {
		mi_cmd_unregister `0'
	}
	else if ("`subcmd'"=="unset") {
		mi_cmd_unset `0'
	}
	else if ("`subcmd'"=="update") { 
		mi_cmd_update `0'
	}
	else if ("`subcmd'"==bsubstr("varying", 1, max(4,`l'))) {
		mi_cmd_varying `0'
	}
	else if ("`subcmd'"=="xeq") { 
		`version' mi_cmd_xeq `0'
	}
	else if ("`subcmd'"=="xtset") { 
		mi_cmd_genericset "xtset `0'" "" reg
	}
	else {
		if ("`subcmd'"=="") {
			di as smcl as err "syntax error"
			di as smcl as err "{p 4 4 2}"
			di as smcl as err ///
			"{bf:mi} must be followed by a subcommand."
			di as smcl as err ///
			"You might type {bf:mi query}, or {bf:mi set wide},"
			di as smcl as err "etc."
			di as smcl as err "{p_end}"
			exit 198
		}

		capture which mi_cmd_`subcmd'
		if (_rc) { 
			if (_rc==1) {
				exit 1
			}
			di as smcl as err ///
			`"subcommand {bf:mi} {bf:`subcmd'} is unrecognized"'
			exit 199
			/*NOTREACHED*/
		}
		`version' mi_cmd_`subcmd' `0'
	}
	return add
end

/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* mi post			*/

/*
	mi post <postlist> [, drop orig noupdate]

		<postlist> := <posting> <postlist>

		<post>    := _<#>_<name> = <varname>   (all styles)
			     _*_<name> = <varname>     (mlong & flong) 

	N.B., -mi post- changes the sort order of the data if style 
             is mlong or flong.
*/

program mi_cmd_post, rclass
	version 11.0

	u_mi_assert_set
	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')

	if ("`_dta[_mi_style]'"=="mlong" | ///
	   "`_dta[_mi_style]'"=="flong" )     {
		local starok "starok"
	}

	/* ---------------------- parse arguments _#_name = varname --- */
	local l_lhs			// _#_name
	local l_rhs			// varname
	local l_base			// name
	local l_baseisivar		// 1->ivar, 0->pvar
	local n 0
	if (`"`0'"' == "") {
		error 198
	}
	local ivars `_dta[_mi_ivars]'
	gettoken tok 0 : 0, parse("=,()[]")
	while ("`tok'"!="" & "`tok'"!=",") {
		local lhs `tok'
		u_mi_parse_impvar i base : "`lhs'" exists "`starok'"
		gettoken tok 0 : 0, parse("=,()[]")
		u_mi_token_mustbe "`tok'" "="
		gettoken rhs 0 : 0, parse("=,()[]")
		confirm numeric var `rhs'
		unab rhs : `rhs'
		local l_lhs `l_lhs'  `lhs'
		local l_rhs `l_rhs'  `rhs'
		local l_base `l_base' `base'
		local baseisivar : list base in ivars
		local l_baseisivar `l_baseisivar' `baseisivar'
		local ++n
		gettoken tok 0 : 0, parse("=,()[]")
	}
	local 0 `tok' `0'
	syntax [, DROP ORIGinal noUPdate]
	if (`n'==0) {
		exit
	}

	/* ------------------------------------- construct drop command */
	local dropcmd
	if ("`drop'"!="") {
		local droplist 
		foreach rhs of local l_rhs {
			capture u_mi_parse_impvar j base : ///
						"`rhs'" exists `starok'
			if (_rc) {	// ignore rop of _#_var
				local droplist `droplist' `rhs'
			}
		}
		if ("`droplist'"!="") {
			// ignore drop for imputation or passive vars
			local tosub `_dta[_mi_ivars]' `_dta[_mi_pvars]'
			local droplist : list droplist - tosub
			if ("`droplist'" != "") {
				local dropcmd drop `droplist'
			}
		}
	}
	
	/* ---------------------------------------- execute request --- */
	mi_post_`_dta[_mi_style]' ///
		`msgno'		 ///
		"`update'"       ///
		"`l_lhs'" "`l_rhs'"  "`l_base'"  "`l_baseisivar'" ///
		"`original'"

	/* ---------------------------------- perform optional drop --- */
	`dropcmd'
end

program mi_post_mlong
	args msgno noupdate /* ... */

	u_mi_certify_data, proper msgno(`msgno') sortok `noupdate'
	gettoken junk 0 : 0
	novarabbrev nobreak mi_post_mlong_u `0'
end

program mi_post_mlong_u
	args noupdate l_lhs l_rhs l_base l_baseisivar orig
	local n : word count `l_base'

	/*
		_#_name=varname
			l_lhs		_#_name
			l_rhs		varname
			l_base 	name
			l_baseisivar	1->ivar, 0->pvar
	*/
	confirm var `l_base'
	confirm var `l_rhs'


	/*
	di "l_lhs    |`l_lhs'|"
	di "l_rhs    |`l_rhs'|"
	di "l_base   |`l_base'|"
	di "l_baseis |`l_baseisivar'|"
	*/

/*
	local sortedby : sortedby
	tempvar recnum
	quietly {
		gen `c(obs_t)' `recnum' = _n
		compress `recnum'
	}
	local sortedby `sortedby' `recnum'
*/
	sort _mi_m _mi_id


	forvalues i=1(1)`n' {
		local lhs   : word `i' of `l_lhs'
		local rhs   : word `i' of `l_rhs'
		local base  : word `i' of `l_base'
		local isivar : word `i' of `l_baseisivar'
		local ii    : word `i' of `l_i'

		u_mi_parse_impvar ii junk : "`lhs'" exists starok
		local smpl = cond("`ii'"=="*", "_mi_m", "(_mi_m==`ii')")

		if (`isivar' & "`orig'"=="") {
			if ("`base'"!="`rhs'") {
				qui replace `base'=`base'[_mi_id] if `smpl'
				qui replace `base'=`rhs' if `smpl' & `base'==.
			}
		}
		else if (`isivar') {
			qui replace `base'=`base'[_mi_id] if `smpl'
			qui replace `base'=`rhs'[_mi_id] if `smpl' & `base'==.
		}
		else if ("`orig'"=="") {
			if ("`base'"!="`rhs'") {
				qui replace `base'=`rhs' if `smpl' 
			}
		}
		else {
			qui replace `base'=`rhs'[_mi_id] if `smpl'
		}
	}

/*
	sort `sortedby'
*/
end

program mi_post_flong
	args msgno noupdate /* ... */

	u_mi_certify_data, proper msgno(`msgno') sortok `noupdate'
	gettoken junk 0 : 0
	novarabbrev nobreak mi_post_flong_u `0'
end

program mi_post_flong_u
	args noupdate l_lhs l_rhs l_base l_baseisivar orig
	local n : word count `l_base'

	confirm var `l_base'
	confirm var `l_rhs'

	sort _mi_m _mi_id


	forvalues i=1(1)`n' {
		local lhs   : word `i' of `l_lhs'
		local rhs   : word `i' of `l_rhs'
		local base  : word `i' of `l_base'
		local isivar : word `i' of `l_baseisivar'
		local ii    : word `i' of `l_i'

		u_mi_parse_impvar ii junk : "`lhs'" exists starok
		local smpl = cond("`ii'"=="*", "_mi_m", "(_mi_m==`ii')")

		if (`isivar' & "`orig'"=="") {
			if ("`base'"!="`rhs'") {
				qui replace `base'=`base'[_mi_id] if `smpl'
				qui replace `base'=`rhs' if `smpl' & `base'==.
			}
		}
		else if (`isivar') {
			qui replace `base'=`base'[_mi_id] if `smpl'
			qui replace `base'=`rhs'[_mi_id] if `smpl' & `base'==.
		}
		else if ("`orig'"=="") {
			if ("`base'"!="`rhs'") {
				qui replace `base'=`rhs' if `smpl' 
			}
		}
		else {
			qui replace `base'=`rhs'[_mi_id] if `smpl'
		}
	}

/*
	sort `sortedby'
*/
end
	

program mi_post_wide
	args msgno noupdate l_lhs l_rhs l_base l_baseisivar /* orig */

	local n : word count `l_lhs'

	confirm var `l_lhs'
	confirm var `l_rhs'
	confirm var `l_base'

	/* ------------------------------------------------------------ */
	nobreak {
		forvalues i=1(1)`n' {
			local lhs       : word `i' of `l_lhs'
			local rhs       : word `i' of `l_rhs'
			local base      : word `i' of `l_base'
			local baseisivar : word `i' of `l_baseisivar'
			di as txt "`lhs': " _c
			if (`baseisivar') {
				replace `lhs' = `rhs' if `base'==.
			}
			else {
				replace `lhs' = `rhs' if _mi_miss

			}
		}
	}
end

/*
	u_mi_parse_impvar i base : `name' {style|mustbestyle|exists} [starok]

	-style-
		`name' might be in the style _i_name and it might not. 
		If it is, return i=i and base=name, else return 
		i=0 and base="". Never aborts.

	-mustbestyle-
		`name' is expected to be an _i_name. i and name are 
		returned or aborts. Does not check that in range or 
		exists (could be new).

	-exists-
		`name' is expected to be in _i_name and to exist, 
		abort otherwise.

	-starok-
		style _*_name to be allowed.
*/

		
program u_mi_parse_impvar
	args toi tobase colon name todo starok passive

	c_local `toi' 0
	c_local `tobase' ""

	local erraction = cond("`todo'"=="style", "exit", "abortexit `name'")

	if (bsubstr(`"`name'"', 1, 1)!="_") {
		`erraction' 
	}

	local rest = bsubstr(`"`name'"', 2, .) 
	local i   = strpos(`"`rest'"', "_") 
	if (`i'<=1) { 
		`erraction'
	}
	local num = bsubstr(`"`rest'"', 1, `i'-1)

	if ("`starok'"=="") { 
		capture confirm integer number `num'
		if (_rc) { 
			`erraction'
		}
	}
	else {
		if ("`num'"!="*") {
			capture confirm integer number `num'
			if (_rc) { 
				`erraction'
			}
		}
	}

	local base = bsubstr(`"`rest'"', `i'+1, .)
	if ("`base'"=="") { 
		`erraction' 
	}
	c_local `tobase' `base'
	c_local `toi'   `num'
	if ("`todo'"=="mustbestyle") { 
		exit
	}

	if ("`num'"!="*") {
		if (`num'>`_dta[_mi_M]'| `num'<1) { 
			di as smcl as err ///
			"imputation {it:m}=`num' does not exist"
			exit 111
		}
	}
	else { 
		if (1>`_dta[_mi_M]') { 
			di as smcl as err "imputations ({it:m}>0) do not exist"
			exit 111
		}
	}

	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
	local in : list base in vars
	if (`in'==0) { 
		di as error ///
		"`base': variable not registered as imputed or passive"
		exit 111
	}
	confirm var `base'
end

program abortexit 
	args name 

	di as err "`name': invalid _i_name variable"
	exit 198
end

					/* mi post			*/
/* -------------------------------------------------------------------- */






/* -------------------------------------------------------------------- */
					/* mi demote 			*/

/*
	mi demote <varlist> [, regular syscall] 

	Considering demoting ivars and pvars to regular (option specified)
        or unregistered (option not specified) variables.

	Rules,

	    1. For each ivar, if variable has no . in m=0, unregister

	    2. If any unregistered in (1), update _mi_miss

	    3. For each pvar, if variable has no . in m=0 in _mi_miss, 
	       unregister

	    4. If any unregistration, make proper.

	Returns:
	    macros:
		r(imputed)	imputed variables demoted
		r(passive)	passive variables demoted

*/

program mi_cmd_demote, rclass
	u_mi_assert_set
	/* ------------------------------------------------------------ */
						/* parse		*/
	syntax [varlist(default=none)] [, REGular SYSCALL]

	if ("`syscall'"=="") {
		u_mi_certify_data, acceptable
	}

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'

	if ("`varlist'"=="") {
		local ch_ivars `ivars'
		local ch_pvars `pvars'
	}
	else {
		local ch_ivars
		local ch_pvars
		foreach v of local varlist {
			local in : list v in ivars
			if (`in') { 
				local ch_ivars `ch_ivars' `v'
			}
			else {
				local in : list v in pvars
				if (`in') { 
					local ch_pvars `ch_pvars' `v'
				}
			}
		}
	}

	/*
	Outputs:
		ch_ivars        ivars to consider
		ch_pvars        pvars to consider

		ivars		current ivars
		pvars		current pvars
		rvars		current rvars

		regular		whether to register as regular
	*/

						/* parse		*/
	/* ------------------------------------------------------------ */
						/* anything to do?	*/
	local nch1 : word count ch_ivars
	local nch2 : word count ch_pvars
	if (`nch1'+`nch2'==0) {
		exit
	}

	/* ------------------------------------------------------------ */
	preserve
	tempvar miss

	quietly mi extract 0, clear 
	mi_demote_mkmiss `miss' : "`ivars'"
	mi_demote_torm rm_ivars : "`ch_ivars'" `miss'
	local ni : word count `rm_ivars'
	if (`ni') {
		return local imputed `rm_ivars'
		local ivars : list ivars - rm_ivars
		if ("`regular'"!="") { 
			local rvars : list rvars | rm_ivars
		}
		drop `miss'
		mi_demote_mkmiss `miss' : "`ivars'"
	}

	mi_demote_torm rm_pvars : "`ch_pvars'" `miss'
	local np : word count `rm_pvars'
	if (`np') { 
		return local passive `rm_pvars'
		local pvars : list pvars - rm_pvars
		if ("`regular'"!="") { 
			local rvars : list rvars | rm_ivars
		}
	}

	if (`ni') { 
		local variables = cond(`ni'==1, "variable", "variables")
		local what = cond("`regular'"=="", "unregistered", "regular")
		di as smcl as txt "{p 0 4 2}"
		di as smcl as txt "(imputed `variables'"
		di as smcl as res "`rm_ivars'"
		di as smcl as txt "demoted to `what')"
		di as smcl as txt "{p_end}"
	}
	if (`np') { 
		local variables = cond(`np'==1, "variable", "variables")
		local what = cond("`regular'"=="", "unregistered", "regular")
		di as smcl as txt "{p 0 4 2}"
		di as smcl as txt "(passive `variables'"
		di as smcl as res "`rm_ivars'"
		di as smcl as txt "demoted to `what')"
		di as smcl as txt "{p_end}"
	}
		
	if (`ni'+`np') { 
		restore, preserve
		mi unregister `rm_ivars' `rm_pvars'
		if ("`regular'"!="") {
			mi register regular `rm_ivars' `rm_pvars'
		}
		restore, not
	}
end

program mi_demote_mkmiss
	args missvar  colon  ivars

	quietly {
		gen byte `missvar' = 0
		foreach v of local ivars {
			replace `missvar' = 1 if `v'==. /* sic */
		}
	}
end


program mi_demote_torm 
	args resultname  colon  vars ismissing

	args resultname  colon  vars ismissing

	local torm
	foreach v of local vars {
		capture assert `v'!=. if `ismissing'
		if (_rc==0) {
			local torm `torm' `v'
		}
	}
	c_local `resultname' `torm'

end
	
					/* mi demote 			*/
/* -------------------------------------------------------------------- */
