*! version 1.0.2  05jul2009

/*
	mi unregister [<varlist>]
*/

program mi_cmd_unregister, rclass
	version 11.0

	u_mi_assert_set
	syntax varlist
	u_mi_no_sys_vars  "`varlist'" "{bf:mi unregister}"
	u_mi_no_wide_vars "`varlist'" "{bf:mi unregister}"

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')

	if ("`varlist'"=="") {
		exit
	}

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	
	local remivar
	local rempvar
	local remrvar
	local unregistered
	foreach v of local varlist {
		local ini : list v in ivars
		if (`ini') {
			local remivar `remivar' `v'
		}
		else {
			local inp : list v in pvars
			if (`inp') {
				local rempvar `rempvar' `v'
			}
			else {
				local inr : list v in rvars
				if (`inr') { 
					local remrvar `remrvar' `v'
				}
				else {
					local unregistered `unregistered' `v'
				}
			}
		}
	}

	if ("`unregistered'"!="") { 
		local n : word count `unregistered' 
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as txt "{p}"
		di as smcl "(`variables' `unregistered'"
		di as smcl "already unregistered)"
		di as smcl "{p_end}"
	}

	local ivars : list ivars - remivar
	local pvars : list pvars - rempvar
	local rvars : list rvars - remrvar
	char _dta[_mi_ivars] `ivars'
	char _dta[_mi_pvars] `pvars'
	char _dta[_mi_rvars] `rvars'
	mi_unregister_`_dta[_mi_style]' "`remivar'" "`rempvar'" `msgno'
end

program mi_unregister_mlong 
	args wasivar waspvar msgno

	if ("`wasivar'" != "") {
		u_mi_certify_data, proper msgno(`msgno')
	}
end

program mi_unregister_flong
	args wasivar waspvar msgno

	if ("`wasivar'" != "") {
		u_mi_certify_data, proper msgno(`msgno')
	}
end

program mi_unregister_flongsep
	args wasivar waspvar msgno

	if ("`wasivar'" != "") {
		u_mi_certify_data, proper msgno(`msgno')
	}
end

program mi_unregister_wide
	args wasivar waspvar msgno

	local vars `wasivar' `waspvar' 

	forvalues i=1(1)`_dta[_mi_M]' {
		foreach v of local vars {
			capture drop _`i'_`v'
		}
	}
	if ("`wasivar'"!="") {
		u_mi_certify_data, updatemissonly
	}
end
