*! version 1.0.0  14may2017
program define dsgesim
	version 15
	syntax varlist, stub(string) [gx(string) hx(string) eta(string)]
	
	local state   = e(state)
	local control = e(control)
	
	local gxmat  = "e(policy)"
	local hxmat  = "e(transition)"
	local etamat = "e(shock_coeff)"
	local gxd    = "e(po_deriv)"
	local hxd    = "e(tr_deriv)"
	
	if("`gx'" != "") {
		local gxmat = "`gx'"
	}
	if("`hx'" != "") {
		local hxmat = "`hx'"
	}
	if("`eta'" != "") {
		local etamat = "`eta'"
	}
	mata: _dsge_simulate("`varlist'","`stub'", "`gxmat'", "`hxmat'", "`etamat'")
end
