*! version 1.0.0  06mar2009

/*
	u_mi_no_sys_vars "<variable_list>" ["<word>"]

	Verify no -mi- system variables in list.
	Give error message

		may not specify <variables found>

	or

		<word> may not include <variables found>
*/

program u_mi_no_sys_vars /* vars [thing] */
	version 11
	args vars thing

	local sysvars "_mi_miss _mi_m _mi_id"
	local bad : list vars & sysvars
	if ("`bad'"=="") {
		exit
	}
	di as smcl as err "{p}"
	if (`"`thing'"'=="") {
		di as smcl as err "may not specify"
	}
	else {
		di as smcl as err `"`thing' may not include"'
	}
	di as smcl as err "system variables such as"
	di as smcl as err "{bf:_mi_m}, {bf:_mi_id}, or {bf:_mi_miss}"
	di as smcl as err "{p_end}"
	exit 198
	/*NOTREACHED*/
end

