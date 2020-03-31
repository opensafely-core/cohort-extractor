*! version 1.1.0  05may2016
program mi_sub_reshape
	version 11
	args type stubs iv jv reshapecmd

	/* ------------------------------------------------------------ */
	if ("`type'"=="wide") {			/* if going wide ... 	*/
		local idvars_cur `iv' `jv'
		local idvars_new `iv'
	}
	else {					/* if going long ... 	*/
		local idvars_cur `iv'
		local idvars_new `iv' `jv'
	}
	sort `idvars_cur'
	capture by `idvars_cur': assert _N==1
	if (_rc) { 
		local n : word count `idvars_cur'
		local variables = cond(`n'==1, "variable", "variables")
		local do       = cond(`n'==1, "does",     "do")
		di as smcl as err "{p}"
		di as smcl as err "`variables' `idvars_cur'"
		di as smcl as err "`do' not uniquely identify the observations"
		di as smcl as err "in the orig. data"
		di as smcl as err "{p_end}"
		exit 459
	}

	/* ------------------------------------------------------------ */

	local marker `_dta[_mi_marker]'
	local style `_dta[_mi_style]'
	local name  `_dta[_mi_name]'
	local M     `_dta[_mi_M]'
	local N	    `_dta[_mi_N]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	local update `_dta[_mi_update]'
	
	/* ------------------------------------------------------------ */
	di 
	di as smcl as txt "reshaping {it:m}=0 data ..."
	drop _mi_id _mi_miss
	local hold "`_dta[_mi_marker]'"
	char _dta[_mi_marker]
	`reshapecmd'
	char _dta[_mi_marker] "`hold'"
	quietly {
		sort `idvars_new'
		gen `c(obs_t)' _mi_id = _n
		compress _mi_id
		/* variable _mi_miss still not filled in */
		char _dta[_mi_marker] `marker'
		char _dta[_mi_style]  `style'
		char _dta[_mi_name]   `name'
		char _dta[_mi_M]      `M'
		char _dta[_mi_N]      `=_N'
		char _dta[_mi_ivars]  `ivars'   /* cannot be filled in yet */
		char _dta[_mi_pvars]  `pvars'   /* cannot be filled in yet */
		char _dta[_mi_rvars]  `rvars'   /* cannot be filled in yet */
		char _dta[_mi_update]     /* leave blank */
		save "`name'", replace

		tempfile mapping
		keep _mi_id `idvars_new'
		save "`mapping'"
	}
	
	/* ------------------------------------------------------------ */
	forvalues i=1(1)`M' {
		di 
		di as smcl as txt "reshaping {it:m}=`i' data ..."
		qui use _`i'_`name', clear 
		drop _mi_id
		char _dta[_mi_marker]
		quietly `reshapecmd'
		char _dta[_mi_marker] `marker'
		char _dta[_mi_style] "flongsep_sub"
		char _dta[_mi_name]  "`name'"
		char _dta[_mi_m]     `i'
		sort `idvars_new'
		qui merge 1:1 `idvars_new' using "`mapping'", ///
				keep(match) sorted nogen nonotes
		qui save _`i'_`name', replace
	}

	/* ------------------------------------------------------------ */
	di
	di as txt "assembling results ..."

	quietly { 
		use `name', clear
		reshape_fix `type' 
	}
	qui gen byte _mi_miss = . 
	qui u_mi_certify_data, acceptable proper
end

program reshape_fix
	args type
	reshape_fix_u _dta[_mi_ivars] `type'
	reshape_fix_u _dta[_mi_pvars] `type'
	reshape_fix_u _dta[_mi_rvars] `type'
end

program reshape_fix_u
	args charname type

	if ("`type'"=="long") {
		local fromtype wide
	}
	else {
		local fromtype long
	}

	local vars ``charname''
	local nXij : char _dta[ReS_Xij_n]
	forvalues i=1/`nXij' {
		local Xij_wide : char _dta[ReS_Xij_wide`i']
		local Xij_long : char _dta[ReS_Xij_long`i']
		if ("`: list vars & Xij_`fromtype''"!="") {
			local vars : list vars - Xij_`fromtype'
			local vars `vars' `Xij_`type''
		}
	}
	char `charname' `vars'
end

exit

// old code from version 1.0.5  16feb2015
/*
program reshape_fix_wide
	reshape_fix_wide_u _dta[_mi_ivars]
	reshape_fix_wide_u _dta[_mi_pvars]
	reshape_fix_wide_u _dta[_mi_rvars]
end

program reshape_fix_wide_u
	args charname

	local vars ``charname''

	local new
	foreach v of local vars {
		tosub_wide tosub : `v'
		local new `new' `tosub'
	}
	local new : list uniq new
	char `charname' `new'
end

program tosub_wide
	args return colon  name

	capture confirm var `name'	// abbreviation is off
	if (_rc==0) {
		c_local `return' `name'
		exit
	}

	local 0 "`name'*"
	capture syntax varlist
	if (_rc) {
		c_local `return'
		exit
	}
	local sublist 
	local l = ustrlen("`name'") + 1
	foreach v of local varlist {
		local part2 = usubstr("`v'", `l', .)
		capture confirm integer number `part2'
		if (_rc==0) { 
			local sublist `sublist' `v'
		}
	}
	c_local `return' `sublist'
end
	

program reshape_fix_long
	reshape_fix_long_u _dta[_mi_ivars]
	reshape_fix_long_u _dta[_mi_pvars]
	reshape_fix_long_u _dta[_mi_rvars]
end

program reshape_fix_long_u
	args charname

	local vars ``charname''

	local new
	foreach v of local vars {
		tosub_long tosub : `v'
		local new `new' `tosub'
	}
	local new : list uniq new
	char `charname' `new'
end

program tosub_long
	args return colon  name

	capture confirm var `name'	// abbreviation is off
	if (_rc==0) {
		c_local `return' `name'
		exit
	}

	c_local `return' 
	if (bstrlen("`name'")==1) {
		exit
	}
	while (1) { 
		local l = bstrlen("`name'")
		local last = bsubstr("`name'", `l', 1)
		capture confirm number `last'
		if (_rc) {
			exit
		}
		local name = bsubstr("`name'", 1, `l'-1)
		if ("`name'"=="") {
			exit
		}
		capture confirm var `name' 
		if (_rc==0) { 
			c_local `return' `name'
			exit
		}
	}
	/*NOTREACHED*/
end
*/
