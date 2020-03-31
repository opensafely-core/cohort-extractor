*! version 1.0.0  10dec2018
program cm_wrk_dlg
	version 16
	
	if `"`0'"' == `""' {
		di as err "subcommand required"
		exit 198
	}
	
	gettoken do 0 : 0, parse(" ,")
	local ldo = length("`do'")
	
	if "`do'" == bsubstr("alt",1,max(3,`ldo')) {
		cm_dlg_get_alt `0'
		exit
	}
	else {
		di as err `"unknown subcommand `do'"'
		exit 198
	}
end

program cm_dlg_get_alt
	args dlg clist

	capture qui cmset
	local altvar : char _dta[_cm_altvar]
	if _rc | "`altvar'" == "" {
		.`dlg'.cmset_error.setvalue 1
		exit
	}
	else {
		mata : build_alternatives_macro()
		local osclist_name ///
			`"`.`dlg'.`clist'.contents'"'
		local i = 1
		foreach var in `___myaltvars' {
			.`dlg'.`osclist_name'[`i'] = "`var'"
			local ++i
		}
	}
end

version 16

local N_TRUNCATE 32 

mata:

void build_alternatives_macro()
{
	transmorphic colvector		myret
	string matrix			mystring
	string scalar			myalt

	myret = build_alternatives_colvec()

	if (isreal(myret)) {
		mystring = strofreal(myret')	
	}
	else {
		mystring = myret' 
	}

	myalt = invtokens(mystring)
	st_local("___myaltvars", myalt)
}

transmorphic colvector build_alternatives_colvec()
{

	// Returns either string or numeric colvector.

	string scalar caseid, altvar, altlab
	
	caseid = st_global("_dta[_cm_caseid]")
	
	if (caseid == "") {
		printf("{err}data not {bf:cmset}\n")
		printf("{p 4 4 2}Use {bf:cmset} {it:caseidvar} ....{p_end}\n")
		exit(459)
	}
	
	altvar = st_global("_dta[_cm_altvar]")
	
	if (altvar == "") {
		printf("{err}alternatives variable {it:altvar} not set\n")
		printf("{p 4 4 2}Use {bf:cmset} {it:caseidvar} {it:altvar}{p_end}\n")
		exit(459)
	}
	
	if (st_isnumvar(altvar)) {
	
		altlab = st_varvaluelabel(altvar)
		
		// No value labels. The numeric values are returned.
	
		if (altlab == "") {
			return(uniqrows(st_data(., altvar)))
		}
		
		// Label could have been dropped, but still attached to variable.
		
		if (!st_vlexists(altlab)) {
			return(uniqrows(st_data(., altvar)))
		}
		
		// Labeled.
		
		return(substr(st_vlmap(altlab, uniqrows(st_data(., altvar))),
			1, `N_TRUNCATE'))
	}
	
	// String.
	
	return(substr(uniqrows(st_sdata(., altvar)), 1, `N_TRUNCATE'))
}

end
