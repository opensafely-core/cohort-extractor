*! version 1.0.1  17sep2019

/*
	u_mi_no_wide_vars "<variable_list>" ["<word>"]

	Verify no -mi- wide _#_vars in list.
	Give error message

		may not specify <variables found>

	or

		<word> may not include <variables found>
*/

program u_mi_no_wide_vars /* vars [thing] */
	version 11
	args vars thing

	if ("`_dta[_mi_style]'" != "wide") {
		exit
	}

	if (`_dta[_mi_M]'==0) {
		exit
	}

	mata: getwidevars("widevars")

	local badvars : list vars & widevars
	if ("`badvars'"=="") {
		exit
	}

	local n : word count `badvars'
	local variables = cond(`n'==1, "variable", "variables")

	di as smcl as err "{p}"
	if (`"`thing'"'=="") {
		di as smcl as err "may not specify"
	}
	else {
		di as smcl as err `"`thing' may not include"'
	}
	di as smcl as err "mi wide system `variables'"
	di as smcl as err "{bf}`badvars'{txt}"
	di as smcl as err "{p_end}"
	exit 198
end

local RS	real scalar
local SS	string scalar
local SC	string colvector
local SR	string rowvector

version 11
mata:
void getwidevars(`SS' macname)
{
	`SR'	var
	`SR'	prefix, res
	`RS'	m, M, i, n, k

	M = strtoreal(st_global("_dta[_mi_M]"))
	if (M==0 | M>=.) {
		st_local(macname, "")
		return
	}

	var = tokens(st_global("_dta[_mi_ivars]") + " " + 
		     st_global("_dta[_mi_pvars]"))
	if ((n=length(var))==0) {
		st_local(macname, "")
		return
	}

	prefix = J(1, M, "")
	for (m=1; m<=M; m++)  prefix[m] = sprintf("_%g_", m)


	k   = 0
	res = J(1, n*m, "")
	for (i=1; i<=n; i++) { 
		for (m=1; m<=M; m++) res[++k] = prefix[m] + var[i]
	}

	st_local(macname, invtokens(res))
}
end
