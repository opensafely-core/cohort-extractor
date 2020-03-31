*! version 1.0.2  15aug2006
program define _assert_obs
	version 8

	gettoken subcmd 0 : 0, parse(" ,")
	if `"`subcmd'"' == "define" {
		Define `0'
	}
	else if `"`subcmd'"' == "begincheck" {
		BeginCheck `0'
	}
	else if `"`subcmd'"' == "check" {
		Check `0'
	}
	else if `"`subcmd'"' == "endcheck" {
		EndCheck `0'
	}
	else {
		di as err `"unknown subcommand `subcmd'"'
		exit 198
	}
end


program define Define
	syntax [varlist], id(varlist) [ Computed(str) ]

	mac drop T_mkassert_obs*

	quietly isid `id', sort
	global T_mkassert_obs_id `id'

	local tol 1e-8
	tokenize `"`computed'"'
	while `"`1'"' != "" {
		capt confirm number `1'
		if !_rc {
			if `1' < 0 {
				di as err "tolerance should be nonnegative"
				exit 197
			}
			local tol `1'
			mac shift
			continue
		}

		foreach v of varlist `1' {
			local tol_`v' `tol'
		}
		mac shift
	}

	local i 0
	foreach v of local varlist {
		local i = `i'+1

		global T_mkassert_obs_v`i'  `v'
		capt confirm string variable `v'
		if !_rc {
			global T_mkassert_obs_vt`i'  string
		}
		else {
			capt assert `v' == int(`v')
			if !_rc {
				global T_mkassert_obs_vt`i'  integer
			}
			else {
				global T_mkassert_obs_vt`i'  real
				global T_mkassert_obs_tol`i' "`tol_`v''"
			}
		}

		local vl : variable label `v'
		global T_mkassert_obs_vl`i' `"`vl'"'
	}
	global T_mkassert_obs_n  `i'
end


program define BeginCheck

	isid $T_mkassert_obs_id , sort

	forvalues i = 1 / $T_mkassert_obs_n {

		if "${T_mkassert_obs_vt`i'}" == "string" {
		
			confirm string var ${T_mkassert_obs_v`i'}
		
		}
		else if "${T_mkassert_obs_vt`i'}" == "integer" {
		
			confirm numeric var ${T_mkassert_obs_v`i'}
			capt assert ${T_mkassert_obs_v`i'} == int(${T_mkassert_obs_v`i'})
			if _rc {
				di "${T_mkassert_obs_v`i'} is not integer valued"
				exit 198
			}
		
		}
		else if "${T_mkassert_obs_vt`i'}" == "real" {
		
			confirm numeric var ${T_mkassert_obs_v`i'}
		
		}
		else {
		
			di as err "assert_obs::BEGINCHECK  this should not happen"
			exit 198
		}

		local vl : variable label ${T_mkassert_obs_v`i'}
		if `"`vl'"' != `"${T_mkassert_obs_vl`i'}"' {
			di as err `"error in variable label of ${T_mkassert_obs_v`i'}"'
			exit 198
		}
	}
end


program define Check
	local obs `1'
	mac shift

	forvalues i = 1 / $T_mkassert_obs_n {
		if "${T_mkassert_obs_vt`i'}" == "string" {
		
			assert ${T_mkassert_obs_v`i'}[`obs'] == `"``i''"'
			
		}
		else if "${T_mkassert_obs_vt`i'}" == "integer" {
		
			assert ${T_mkassert_obs_v`i'}[`obs'] == ``i''
			
		}
		else if "${T_mkassert_obs_tol`i'}" == "" {
		
			assert float(${T_mkassert_obs_v`i'}[`obs']) == float(``i'')
			
		}
		else {
		
			assert reldif(${T_mkassert_obs_v`i'}[`obs'] , ``i'') < ${T_mkassert_obs_tol`i'}
			
		}
	}
end


program define EndCheck
	global T_mkassert_obs*
end

exit

SYNTAX

	_assert_obs define varlist, id(varlist) computed(# var)
	_assert_obs begincheck
	_assert_obs check # value-list
	_assert_obs endcheck

GLOBALS

   T_mkassert_obs_n        number of variables
   T_mkassert_obs_id       identification variables
   T_mkassert_obs_v<i>     name of variable i
   T_mkassert_obs_vt<i>    type of variable i; type := { string | integer | real }
   T_mkassert_obs_vl<i>    variable label of variable i
   T_mkassert_obs_tol<i>   tolerance for testing of variable i
