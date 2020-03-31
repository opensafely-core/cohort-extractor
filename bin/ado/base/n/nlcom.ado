*! version 1.4.1  16dec2013
program nlcom, rclass
	local vv : display "version " string(_caller()) ":"
	version 8

	if replay() {
		if "`e(cmd)'" != "nlcom" {
			error 301
		}
		Display `0'
		exit
	}

        if "`e(properties)'" == "" {
                error 301
        }

	if (!has_eprop(b) | !has_eprop(V)) {
		error 321
	}

	is_svy
	local is_svy `r(is_svy)'
	if "`is_svy'" == "1" {
		if "`e(complete)'" == "available" {
			di as err /*
*/ `"must run svy command with "complete" option before using this command"'
			exit 301
		}
		// check should be redundant
		if "`e(N_psu)'" ~= "" & "`e(N_strata)'" ~= "" {
			local psuopt psu(`e(N_psu)')
			local strataopt strata(`e(N_strata)')
			local svy svy
		}
	}

	local nc 0
	gettoken tok : 0, parse(" (,")
	local single single
	local zero `"`0'"'
	if `"`tok'"' == "(" {  /* eqns within parens */
		local single 
		while `"`tok'"' == "(" {
			local ++nc
			gettoken tok 0 : 0, parse(" (,") match(paren)
			local tokens `"`tokens' `"`tok'"'"'
			gettoken tok : 0, parse(" (,")
		}
		if `"`tok'"' != "," & `"`tok'"' != "" {
			local tokens
			local single single
		}
	}

	if "`single'"=="single" {	/* eqn without parens */
		local 0 `"`zero'"'
		while `"`tok'"' != "" & `"`tok'"' != "," {
			gettoken tok 0 : 0, parse(" ,") bind
			local eq `"`eq' `tok'"'
			gettoken tok : 0, parse(" ,") bind
		}
		if `"`eq'"' == "" {
			error 198
		}
		local nc 1
		local tokens `"`"`eq'"'"'
		local eq
	}

	syntax [,	noHEADer			///
			Level(cilevel)			///
			post				///
			ITERate(integer 100)		///
			DF(numlist max=1 >0 missingok)	///
			*				///
		]

	if "`df'" != "" {
		local dofopt df(`df')
	}

	_get_diopts diopts, `options'
	ParsePrint `"`header'"' `tokens'
	local eqnames `s(eqnames)'
	local eqns `s(eqns)'

	tempname G R VCE b V

	`vv' ///
	capture noi qui testnl `eqns', g(`G') r(`R') /*    prints errors
		*/ iterate(`iterate') `dofopt'
	if _rc { 
		exit _rc
	}

	tempvar isamp 
	if "`e(N)'" != "" {
		local N = e(N)
		return scalar N = e(N)
	}
	else {
		local N = .
	}
	qui gen byte `isamp' = e(sample)

	if "`df'"!="" {
		local dof = `df'
		return scalar df_r = `df'
	}
	else if "`e(df_r)'" != "" & _caller() < 13 {
		local dof = e(df_r)
		return scalar df_r = e(df_r)
	}
	else {
		local dof = .
	}
	local dofopt
	if !missing(`dof') {
		local dofopt "dof(`dof')" 
	}
	if !missing(`N') {
		local Nopt "obs(`N')"
	}
	local esopt "esample(`isamp')"

	if "`e(depvar)'" != "" {
		local ndepv : word count `e(depvar)'
		if `ndepv' == 1 {
			local depn "depn(`e(depvar)')"
		}
	}

	mat `VCE' = `G'*e(V)*`G''
	mat colnames `VCE' = `eqnames'
	mat rownames `VCE' = `eqnames'
	mat rownames `R' = `eqnames'
	mat `R' = `R''

	if "`is_svy'" == "1" {
		tempname VSRS
		mat `VSRS' = `G'*e(V_srs)*`G''
		mat colnames `VSRS' = `eqnames'
		mat rownames `VSRS' = `eqnames'
		local vsrsopt vsrs(`VSRS')
		if "`e(V_srswr)'" == "matrix" {
			tempname VSRSWR
			mat `VSRSWR' = `G'*e(V_srswr)*`G''
			mat colnames `VSRSWR' = `eqnames'
			mat rownames `VSRSWR' = `eqnames'
			local vsrswropt vsrswr(`VSRSWR')
		}
		if "`e(V_msp)'" == "matrix" {
			tempname VMSP
			mat `VMSP' = `G'*e(V_msp)*`G''
			mat colnames `VMSP' = `eqnames'
			mat rownames `VMSP' = `eqnames'
			local vmspopt vmsp(`VMSP')
		}
	}

	mat `b' = `R'
	mat `V' = `VCE'

	if "`post'" != "" {
		`vv' ///
		Post, r(`R') vce(`VCE') `dofopt' `depn' `Nopt' /*
			*/ `esopt' `svy' `strataopt' `psuopt' /*
			*/ `vsrsopt' `vsrswropt' `vmspopt'
		Display, level(`level') `diopts'
	}
	else {
		tempname estname
		nobreak {
			_estimates hold `estname'
			capture noisily break {
				`vv' ///
				Post, r(`R') vce(`VCE') `dofopt' `depn' /*
					*/ `Nopt' `esopt' `svy' /*
					*/ `strataopt' `psuopt' /*
					*/ `vsrsopt' `vsrswropt' `vmspopt'
				Display, level(`level') `diopts'
			}
			local rc = _rc
			_estimates unhold `estname'
			if `rc' {
				exit `rc'
			}
		}
	
	}

	return matrix V `V'
	return matrix b `b'
end

program Post, eclass
	version 8
	syntax, r(string) vce(string) [dof(passthru) obs(passthru) /*
		*/ esample(passthru) depn(passthru) /*
		*/ SVY strata(real 1.0) psu(real 1.0) /*
		*/ vsrs(string) vsrswr(string) vmsp(string) /*
		*/ ]

	eret post `r' `vce', `dof' `obs' `esample' `depn'
	if _caller() >= 13 {
		if "`svy'" != "" {
			if "`dof'" == "" {
				local svy
			}
		}
	}
	if "`svy'" != "" {
		eret scalar N_strata = `strata'
		eret scalar N_psu = `psu'
		eret matrix V_srs `vsrs'
		if `"`vsrswr'"' != "" {
			eret matrix V_srswr `vsrswr'
		}
		if `"`vmsp'"' != "" {
			eret matrix V_msp `vmsp'
		}
	}
	_post_vce_rank
	eret local cmd "nlcom"
	eret local predict "nlcom_p"
end

program Display
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	di
	eret di, level(`level') `diopts'
end

program ParsePrint, sclass
	if `"`1'"' == "noheader" {
		local dont *
	}
	mac shift
	local i 1
	`dont' di
	while `"``i''"' ~= "" {
		ParseExp `"``i''"' `i'
		local exp `s(exp)'
		local name `s(name)'
		local eqnames `eqnames' `name'
		CheckValue `exp'
		`dont'di as txt %12s abbrev(`"`name'"',12) ":  " /*
			*/ as res `"`exp'"'
		local eqns `"`eqns' (`exp'=0)"'
		local ++i
	}
	sreturn local eqnames `eqnames'
	sreturn local eqns `eqns'
end

program ParseExp, sclass
	args exp n
	local myexp `"`exp'"'
	gettoken name myexp : myexp, parse(":") bind
	if `"`name'"'==":" {
		di as error `"invalid name"'
		exit 198
	}
	gettoken equals myexp : myexp, parse(":")
	if `"`equals'"' == ":" {          /* using name */
		local wc: word count `name'
		if `wc'>1 {
			di as err `"invalid name: `name'"'
			exit 198
		}
		capture confirm name `name'
		if _rc {
			di as err `"invalid name: `name'"'
			exit 198
		}
		CheckEquals `myexp'
		sreturn local exp `"`myexp'"'	
		sreturn local name `"`name'"'
		exit
	}		
	CheckEquals `exp'
	sreturn local exp `"`exp'"'
	sreturn local name "_nl_`n'"
end

program CheckEquals
	local token token
	while `"`token'"'!="" {
		gettoken token 0 : 0, parse(" =")
		if `"`token'"'=="=" | `"`token'"'=="==" {
			di as err _quote "=" _quote /*
			*/ " not allowed in expression"
			exit 198
		}
	}
end

program CheckValue
	tempname w1 w2
	
	scalar `w1' = `0'
	if missing(`w1') {
		di as err "expression " as inp `"(`0')"' /*
			*/ as err " evaluates to missing"
		exit 498
	}
	if _N > 1 {
		scalar `w2' = `0' in l
		if `w1' != `w2' {
			di as err "expression " as inp /*
				*/`"(`0')"' as err  /*
				*/ " contains reference to X rather than _b[X]"
			exit 198
		}
	}
end

exit

