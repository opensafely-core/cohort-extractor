*! version 4.2.0  21jun2018
program define xtabond, byable(onecall) eclass prop(xt xtbs)

	local vv : display "version " string(_caller()) ", missing:"
	version 10, missing

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if _caller() < 10 {
		`BY' _xtabond9 `0'
		exit
	}	

	if replay() {
		if "`e(cmd)'" != "xtabond" {
			error 301 
		} 
		if _by() { 
			error 190 
		}
		syntax [, Level(cilevel) *]
		xtdpd , level(`level') `options'
		exit
	}

	syntax varlist(ts default=none) [if] [in], [ * ]

	_xtab_parser `varlist' `if' `in', `options' xtabond
	
	local xtdpd_cmd `r(cmd)'

	`vv' `BY' xtdpd `xtdpd_cmd'
	ereturn local cmdline `"xtabond `0'"'

end
