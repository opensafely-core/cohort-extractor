*! version 1.0.0  15jun2011
program u_mi_getwidevars
	version 12
	args widevars colon vars mstart

	mata: getwidevars("tmpvars", "`vars'", "`mstart'")
	unab auxvars : _*_*
	local tmpvars : list tmpvars & auxvars

	c_local `widevars' "`tmpvars'"
end

version 12

local RS	real scalar
local SS	string scalar
local SC	string colvector
local SR	string rowvector

mata:

void getwidevars(`SS' macname, |`SS' vars, `SS' mstart)
{
	`RS'	first
	`SR'	var
	`SR'	prefix, res, underscore
	`RS'	M, i, n, nimp

	M = strtoreal(st_global("_dta[_mi_M]"))
	if (M==0 | M>=.) {
		st_local(macname, "")
		return
	}
	if (vars=="") {
		var = tokens(st_global("_dta[_mi_ivars]") + " " + 
			     st_global("_dta[_mi_pvars]"))
	}
	else var = tokens(vars)
	if ((n=length(var))==0) {
		st_local(macname, "")
		return
	}
	if (mstart!="") first = strtoreal(mstart)
	else first = 1
	if (first==0) return

	nimp = M-first+1
	underscore = J(1,nimp,"_")
	prefix = underscore + strofreal(range(first,M,1)') + underscore

	res = J(1,0,"")
	if (n<=nimp) {
		for (i=1; i<=n; i++) res = res, prefix:+var[i]
	}
	else {
		for (i=1; i<=nimp; i++) res = res, prefix[i]:+var
	}
	st_local(macname, invtokens(res))
}
end
