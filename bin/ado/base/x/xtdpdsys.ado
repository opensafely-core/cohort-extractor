*! version 1.2.0  21jun2018
program define xtdpdsys, byable(onecall) eclass prop(xtbs)

	local vv : display "version " string(_caller()) ", missing:"
	version 10
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if replay() {
		if "`e(cmd)'" != "xtdpdsys" { 
			error 301 
		} 
		if _by() { 
			error 190 
		}
		syntax [, Level(cilevel) *]
		xtdpd , level(`level') `options'
		exit
	}

	syntax varlist(ts default=none) [if] [in], [ Robust * ]

	if "`robust'" != "" {
		di "{err}{cmd:robust} not allowed"
		exit 198
	}	

	_xtab_parser `varlist' `if' `in', `options' xtdpdsys
	
	local xtdpd_cmd `r(cmd)'

	`vv' `BY' xtdpd `xtdpd_cmd'
	ereturn local cmdline `"xtdpdsys `0'"'
end
