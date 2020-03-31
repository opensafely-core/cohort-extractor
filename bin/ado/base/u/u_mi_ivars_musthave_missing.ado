*! version 1.0.0  04feb2011
program u_mi_ivars_musthave_missing
	version 12

	args nvars vars colon varlist touse noerror indent

	if ("`varlist'"=="") { 
		exit
	}
	if ("`indent'"=="") {
		local indent 0 4 2
	}
	if ("`noerror'"=="") {
		local font bf
		local dias err
		local rc = 459
	}
	else {
		local font bf
		local dias txt
		local rc = 0
	}

	local haserr 0 
	local bad
	foreach var of local varlist { 
		qui count if `var'==. & `touse'
		if (r(N)==0) {
			if (`haserr') { 
				di as smcl " {`font':`var'}" _c
				local bad `bad' `var'
			}
			else { 
				di as `dias' as smcl "{p `indent'}"
				di as smcl "{`font':`var'}" _c
				local bad `bad' `var'
			}
			local ++haserr
		}
	}
	c_local `nvars' "`haserr'"
	c_local `vars' "`bad'"
	if (`haserr') { 
		exit `rc'
	}
end
