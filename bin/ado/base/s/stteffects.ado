*! version 1.0.0  29nov2014

program define stteffects, eclass byable(onecall)
	version 14.0
	
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	local cmdline `"stteffects `0'"'
	local cmdline: list retokenize cmdline

	gettoken proc rest : 0, parse(" ,")
	local replay = (("`proc'"==""|"`proc'"==",") & ///
			"`e(cmd)'"== "stteffects")
	if (`replay') {
		local proc `e(subcmd)'
		if _by() {
			error 190
		}
	}
	else {
		cap stset
		local rc = c(rc)
		if `rc' {
			di as err "{p}you must {helpb stset} your data " ///
			 "before running {bf:stteffects}{p_end}"
			exit `rc'
		}
		local wtype : char _dta[st_wt]
		if "`wtype'" != "" {
			if "`c(prefix)'" == "bootstrap" {
				di as err "{p}prefix {bf:bootstrap} is not " ///
				 "allowed with weights{p_end}"
				exit 101
			}
			local noboot nobootstrap
		}
		local 0 `rest'
		if "`proc'" == "ra" {
			cap noi `BY' _vce_parserun _stteffects_ra, `noboot': `0'
		}
		if "`proc'" == "wra" {
			cap noi `BY' _vce_parserun _stteffects_wra, ///
				`noboot': `0'
		}
		else if "`proc'" == "ipw" {
			/* only one equation; _eqlist will strip 	*/
			/*  parentheses					*/
			cap noi `BY' _vce_parserun _stteffects_ipw, noeqlist ///
					`noboot': `0'
		}
		else if "`proc'" == "ipwra" {
			cap noi `BY' _vce_parserun _stteffects_ipwra, ///
					`noboot': `0'
		}
		local rc = c(rc)
		if `rc'==198 & "`wtype'"!="" {
			di as txt "{phang}Weights are not allowed when " ///
			 "bootstrapping standard errors.{p_end}"
			local rc = 101
		}
		if `rc' {
			exit `rc'
		}
		if "`s(exit)'" != "" {
			ereturn local marginsnotok _ALL
			ereturn local estat_cmd teffects_estat
			ereturn local predict stteffects_p
			ereturn local cmdline `"`cmdline'"'
			ereturn local cmd "stteffects"
	        	exit
        	}
	}
	if "`proc'" == "ra" {
		`BY' _stteffects_ra `0'
	}
	else if "`proc'" == "wra" {
		`BY' _stteffects_wra `0'
	}
	else if "`proc'" == "ipw" {
		`BY' _stteffects_ipw `0'
	}
	else if "`proc'" == "ipwra" {
		`BY' _stteffects_ipwra `0'
	}
	else {
		di as err "{p}invalid procedure; expected one of {bf:ra}, " ///
		 "{bf:wra}, {bf:ipw}, or {bf:ipwra}{p_end}"
		exit 198
	}
	if !`replay' & "`proc'"!="overlap" {
		ereturn local marginsnotok _ALL
		ereturn local estat_cmd stteffects_estat
		ereturn local predict stteffects_p
		ereturn local cmdline `"`cmdline'"'
		ereturn local cmd "stteffects"
	}
end

exit
