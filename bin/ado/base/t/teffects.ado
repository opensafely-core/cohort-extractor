*! version 1.0.2  05dec2018

program define teffects, eclass byable(onecall)
	version 13

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	local cmdline `"teffects `0'"'
	local cmdline: list retokenize cmdline

	gettoken proc rest : 0, parse(" ,")
	local replay = (("`proc'"==""|"`proc'"==",") & "`e(cmd)'"== "teffects")
	if (`replay') {
		local proc `e(subcmd)'
		if _by() {
			error 190
		}
	}
	else {
		local 0 `rest'
		if "`proc'" == "ra" {
			`BY' _vce_parserun _teffects_ra: `0'
		}
		else if "`proc'" == "ipw" {
			`BY' _vce_parserun _teffects_ipw: `0'
		}
		else if "`proc'" == "ipwra" {
			`BY' _vce_parserun _teffects_ipwra: `0'
		}
		else if "`proc'" == "aipw" {
			`BY' _vce_parserun _teffects_aipw: `0'
		}
		if "`s(exit)'" != "" & ///
			!inlist("`proc'","nnmatch","psmatch","overlap") {
			ereturn local predict teffects_p
			ereturn local cmdline `"`cmdline'"'
			ereturn local cmd "teffects"
			ereturn hidden local _contrast_not_ok "_ALL"
	        	exit
        	}
	}


	if "`proc'" == "ra" {
		`BY' _teffects_ra `0'
	}
	else if "`proc'" == "ipw" {
		`BY' _teffects_ipw `0'
	}
	else if "`proc'" == "ipwra" {
		`BY' _teffects_ipwra `0'
	}
	else if "`proc'" == "aipw" {
		`BY' _teffects_aipw `0'
	}
	else if "`proc'" == "nnmatch" {
		`BY' _teffects_nnmatch `0'
	}
	else if "`proc'" == "psmatch" {
		`BY' _teffects_psmatch `0'
	}
	else if "`proc'" == "overlap" {
		_teffects_overlap `0'
	}
	else {
		di as err "{p}invalid procedure; expected one of {bf:ra}, " ///
		 "{bf:ipw}, {bf:ipwra}, {bf:aipw}, {bf:nnmatch}, or "       ///
		 "{bf:psmatch}{p_end}"
		exit 198
	}
	if !`replay' & "`proc'"!="overlap" {
		ereturn local marginsnotok _ALL
		ereturn local estat_cmd teffects_estat
		ereturn local predict teffects_p
		ereturn local cmdline `"`cmdline'"'
		ereturn local cmd "teffects"
	}
end

exit
