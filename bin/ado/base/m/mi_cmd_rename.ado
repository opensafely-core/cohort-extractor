*! version 1.0.1  13nov2014

/*
	mi rename <name> [, noupdate syscall nolongnameschk]
	-nolongnameschk- is undocumented and available only in mlong and flong
*/

program mi_cmd_rename
	version 11

	u_mi_assert_set
	gettoken oldname 0 : 0, parse(" ,")
	gettoken newname 0 : 0, parse(" ,")
	if ("`oldname'"=="" | "`newname'"=="") { 
		di as err "invalid syntax"
		di as smcl as err ///
		"    syntax is  {bf:mi rename} {it:oldname} {it:newname}"
		exit 198
	}
	if ("`_dta[_mi_style]'"=="wide" | "`_dta[_mi_style]'"=="flongsep") {
		syntax [, noUPdate SYSCALL ]
	}
	else {
		syntax [, noUPdate SYSCALL noLONGNAMESCHK]
	}

	unab oldname : `oldname'
	confirm new variable `newname'
	
	local rvars `_dta[_mi_rvars]'
	local isrvar : list oldname in rvars
	if (!`isrvar' | "`_dta[_mi_style]'"=="flongsep") { 
	      u_mi_chk_longvnames "`newname'" "mi rename" "`longnameschk'" "new"
	}

	if ("`syscall'"=="") {
		tempname msgno
		u_mi_certify_data, acceptable msgno(`msgno')
	}


	local ivars `_dta[_mi_ivars]'
	local in : list oldname in ivars
	if (`in') {
		local vtype "imputed"
	}
	else {
		local pvars `_dta[_mi_pvars]'
		local in : list oldname in pvars
		if (`in') {
			local vtype "passive"
		}
		else {
			local rvars `_dta[_mi_rvars]'
			local in : list oldname in rvars
			if (`in') { 
				local vtype "regular"
			}
		}
	}

	novarabbrev nobreak mi_rename_`_dta[_mi_style]' 	///
			"`vtype'" `oldname' `newname'		///
			"`update'" "`syscall'" "`msgno'"
end

program mi_rename_wide
	args vtype oldname newname noupdate syscall msgno

	if ("`vtype'"=="") {
		rename `oldname' `newname'
		exit
	}

	if ("`vtype'"=="regular") {
		rename `oldname' `newname'
		mi_rename_fixlist _mi_rvars `oldname' `newname'
		exit
	}

	if ("`vtype'"=="imputed") {
		local listname _mi_ivars
	}
	else if ("`vtype'"=="passive") {
		local listname _mi_pvars
	}
	else {
		di as err "mi_rename_wide: unknown vtype |`vtype'|"
		exit 9221
	}

	local M `_dta[_mi_M]'
	forvalues m=1(1)`M' {
		rename _`m'_`oldname' _`m'_`newname'
	}
	rename `oldname' `newname'
	mi_rename_fixlist `listname' `oldname' `newname'
end

program mi_rename_mlong
	args vtype oldname newname noupdate syscall msgno

	if ("`vtype'"=="") {
		rename `oldname' `newname'
		exit
	}

	if ("`vtype'"=="imputed") {
		local listname _mi_ivars
	}
	else if ("`vtype'"=="passive") {
		local listname _mi_pvars
	}
	else if ("`vtype'"=="regular") {
		local listname _mi_rvars
	}
	else {
		di as err "mi_rename_mlong: unknown vtype |`vtype'|"
		exit 9221
	}
	rename `oldname' `newname'
	mi_rename_fixlist `listname' `oldname' `newname'
end

program mi_rename_flong
	mi_rename_mlong `0'
end

program mi_rename_flongsep
	args vtype oldname newname noupdate syscall msgno

	/* ------------------------------------------------------------ */
	if ("`vtype'"=="") {
		local listname
	}
	else if ("`vtype'"=="imputed") {
		local listname _mi_ivars
	}
	else if ("`vtype'"=="passive") {
		local listname _mi_pvars
	}
	else if ("`vtype'"=="regular") {
		local listname _mi_rvars
	}
	else {
		di as err "mi_rename_flongsep: unknown vtype |`vtype'|"
		exit 9221
	}
	/* ------------------------------------------------------------ */

	if ("`syscall'"=="" & "`noupdate'"=="") {
		u_mi_certify_data, proper msgno(`msgno')
	}

	/* ------------------------------------------------------------ */
	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'
	preserve
	quietly {
		forvalues m=1(1)`M' {
			use _`m'_`name', clear 
			rename `oldname' `newname'
			save _`m'_`name', replace
		}
	}
	restore, preserve
	rename `oldname' `newname' 
	if ("`listname'"!="") {
		mi_rename_fixlist `listname' `oldname' `newname'
	}
	restore, not
end
		

program mi_rename_fixlist
	args dtacharname oldname newname

	local lst `_dta[`dtacharname']'
	local new
	foreach mbr of local lst {
		if ("`mbr'"=="`oldname'") {
			local newmbr `newname'
		}
		else {
			local newmbr `mbr'
		}
		local new `new' `newmbr'
	}
	char _dta[`dtacharname'] `new'
end
