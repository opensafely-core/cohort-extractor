*! version 1.0.0  25mar2009

/*
	u_mi_fixchars [, acceptable proper]

	Make characteristics the same in m=1, ..., M as in m=0.

	Option specifies what is already known to be true:

		<nothing>	data are not known to be acceptable or proper
		acceptable	data known to be acceptable
		proper		data known to be proper

	Specifying -proper- is equivalent to specifying -acceptable proper-.

	Specify option to save time.  Internally, this routine requires 

		wide:		data are acceptable
		mlong:		no requirements
		flong:		no requirements
		flongsep:	data are proper

	u_mi_fixchars handles certifying data if necessary.
*/
		

program u_mi_fixchars
	version 11

	local style "`_dta[_mi_style]'"
	if ("`style'" == "wide") {
		u_mi_fixchars_wide `0'
	}
	else if ("`style'"=="flongsep") { 
		u_mi_fixchars_flongsep `0'
	}
end

program u_mi_fixchars_wide
	syntax [, ACCEPTABLE PROPER]

	local M `_dta[_mi_M]'
	if (`M'==0) {
		exit
	}

	if ("`acceptable'"=="" & "`proper'"=="") {
		u_mi_certify_data, acceptable
	}

	mata: fix_wide(`M', "`_dta[_mi_ivars]' `_dta[_mi_pvars]'")
end


program u_mi_fixchars_flongsep
	syntax [, ACCEPTABLE PROPER]

	if (`_dta[_mi_M]'==0) {
		exit
	}

	if ("`acceptable'"=="" & "`proper'"=="") {
		u_mi_certify_data, acceptable proper
	}
	else if ("`proper'"=="") {
		u_mi_certify_data, proper
	}

	local instance
	capture noisily {
		mata: u_mi_get_mata_instanced_var("instance", "_u_mi_fixchars")
		u_mi_fixchars_flongsep_u `instance'
	}
	nobreak {
		local rc = _rc 
		capture mata: mata drop `instance'
	}
	exit `rc'
end

program u_mi_fixchars_flongsep_u
	args instance

	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'

	mata: u_mi_cpchars_get(`instance')
	preserve
	forvalues m=1(1)`M' {
		quietly use _`m'_`name', clear 
		mata: u_mi_cpchars_put(`instance', 2)
		quietly save _`m'_`name', replace
	}
end
	
mata:
void fix_wide(real scalar M, string scalar varnames)
{
	real scalar		i, j, n, m
	string scalar		v0, vm
	string rowvector	vars
	string colvector	char0, cnts0
	string colvector	todel

	vars = tokens(varnames)
	for (i=1; i<=cols(vars); i++) { 
		char0 = st_dir("char", v0=vars[i], "*")
		cnts0 = J(n=rows(char0), 1, "")

		for (j=1; j<=n; j++) {
			cnts0[j] = st_global(sprintf("%s[%s]", v0, char0[j]))
		}

		for (m=1; m<=M; m++) {
			vm  = sprintf("_%g_%s", m, v0) 
			todel = st_dir("char", vm, "*", 1)
			for (j=1; j<=rows(todel); j++) st_global(todel[j], "")
			for (j=1; j<=n; j++) {
				st_global(sprintf("%s[%s]", vm, char0[j]), 
								cnts0[j])
			}
		}
	}
}
end


