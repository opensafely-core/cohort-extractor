*! version 1.3.5  03feb2015
program define _svylc, rclass
	version 6
 	if `"`0'"'=="" {
		error 198
	}

/* Check if last command was a -svy- estimation command. */

	is_svy
	local is_svy `r(is_svy)'
	if bsubstr("`e(cmd)'",1,3)!="svy" & ! `is_svy' {
		error 301
	}

/* Check if -svymean-, etc., posted results. */

	if "`e(complete)'"=="available" {
		di in red `"must run svy command with "complete""' /*
		*/ " option before using this command"
		exit 301
	}

/* See if command is -svylc, show-. */

	gettoken token 0 : 0, parse(",= ")

	if `"`token'"'=="," {
		local 0 , `0'
		capture syntax [, SHOW ]
		if _rc {
			error 198
		}
		if `"`show'"'!="" {
			di /* blank line */
			est display
			exit
		}
	}

/* Split off formula and check for "=" (not allowed). */

	while `"`token'"'!="" & `"`end'"'=="" {
		if `"`token'"'=="=" {
			di in red `""=" not allowed in expression"'
			exit 198
		}
		if `"`token'"'=="," {
			local end 1 /* exit loop */
			local dopts `0'
			local 0 , `0'
		}
		else {
			local formula `formula'`token'
			gettoken token 0 : 0, parse(",= ")
		}
	}

	if `"`0'"'!="" {
		if   "`e(cmd)'"!="svymean" & "`e(cmd)'"!="svyratio" /*
		*/ & "`e(cmd)'"!="svytotal" & "`e(svyml)'"=="" {
			`e(cmd)' 0 syntax /* get options `s(dopts)' */
			local svy_est `e(svy_est)'
			local diopts `s(dopts)'
		}
		else if "`e(svyml)'" != "" {
			local svyml `e(svyml)'
			local diopts OR IRR RRR
		}
		syntax [, Level(int $S_level)	/*
		*/ DEFF				/*
		*/ DEFT				/*
		*/ MEFF				/*
		*/ MEFT				/*
		*/ EFORM			/*
		*/ `diopts'			/*
		*/ ]
	}

	local nopt : word count `or' `irr' `rrr' `eform'
	if `nopt' > 1 {
		if `"`irr'"' != "" {
			local or `or' `irr'
		}
		if `"`rrr'"' != "" {
			local or `or' `rrr'
		}
		if `"`eform'"' != "" {
			local or `or' `eform'
		}
		di in red "only one of the following can be specified "	/*
		*/ "at a time: `or'"
		exit 198
	}

/* Check if meff and meft are available. */

	tempname estname x b V Vsrs Vmsp bb VV Deff Deft

	if "`e(V_msp)'" == "matrix" {
		matrix `Vmsp' = e(V_msp)
	}
	else     local Vmsp

	if "`meff'`meft'"!="" & "`Vmsp'"=="" {
		di in red "meff and meft options must be specified " /*
		*/ "at initial estimation"
		exit 198
	}

/* Compute F-statistic. */

	qui _test `formula' = 0
	scalar `x' = r(F)

	matrix `b' = e(b)
	matrix `V' = e(V)

/* Hold on to deff and deft matrices and other needed e() results. */

	local cmd  `e(cmd)'
	local depn `e(depvar)'
	local fpc  `e(fpc)'
	local df   `e(df_r)'
	local nstr `e(N_strata)'
	local npsu `e(N_psu)'

	matrix `Vsrs' = e(V_srs)
	if "`fpc'"!="" {
		tempname Vswr
		matrix `Vswr' = e(V_srswr)
	}

/* Compute results. */

	nobreak {
		estimates hold `estname'
		capture noisily break {

			_getbv `x' `b' `V' `"`formula'"'

			scalar `bb' = `b'[1,1]
			scalar `VV' = `V'[1,1]

		/* Display formula. */

			noisily _test `formula' = 0, notest

		/* Convert Vsrs, Vmsp, Vswr to C*Vsrs*C', etc. */

			Get_CVC `Vsrs' `"`formula'"'
			scalar `Deff' = `VV'/`Vsrs'[1,1]

			if "`Vmsp'"!="" {
				Get_CVC `Vmsp' `"`formula'"'
				tempname Meft
				scalar `Meft' = sqrt(`VV'/`Vmsp'[1,1])
			}

			if "`fpc'"!="" {
				Get_CVC `Vswr' `"`formula'"'
				scalar `Deft' = sqrt(`VV'/`Vswr'[1,1])
			}
			else 	scalar `Deft' = sqrt(`Deff')

		/* Save results in e() for svy_dreg. */

			PostEst `b' `V' `Deff' `Deft' "`Meft'" /*
			*/ `cmd' "`depn'" "`fpc'" `df' "`svy_est'" "`svyml'"

			noisily {
				di /* blank line */
				svy_dreg, nohead prob ci `dopts'
			}
		}
		local rc = _rc
		estimates unhold `estname'
		if `rc' {
			error `rc'
		}
	}

/* Save r() results. */

	ret scalar df       = `df'
	ret scalar est      = `bb'
	ret scalar se       = sqrt(`VV')
	ret scalar N_strata = `nstr'
	ret scalar N_psu    = `npsu'
	ret scalar deff     = `Deff'
	ret scalar deft     = `Deft'
	if "`Meft'" != "" {
		ret scalar meft = `Meft'
	}

/* Double saves. */

	global S_1 `return(est)'
	global S_2 `return(se)'
	global S_3 `return(N_strata)'
	global S_4 `return(N_psu)'
	global S_5 `return(deff)'
	global S_6 `return(deft)'

	if "`Meft'"!="" {
		global S_7 `return(meft)'
	}
end

program define Get_CVC /* matrix_V `formula' */
	args V
	macro shift
	tempname w

	local dim = colsof(`V')
	matrix `w' = 0*`V'[1,1..`dim']

	est post `w' `V'

	qui _test `*' = 1
	scalar `w' = r(chi2)

	matrix `V' = (0)
	if !missing(1/`w') {
		matrix `V'[1,1] = 1/`w'
	}
end

program define PostEst, eclass
	args b V Deff Deft Meft cmd depn fpc df svy_est svyml

	est post `b' `V'

	tempname X

	ScaMat `X' `Deff'
	est matrix deff `X'
	ScaMat `X' `Deff'
	est matrix deft `X'

	if "`Meft'"!="" {
		ScaMat `X' `Meft'
		est matrix meft `X'
	}

	est scalar df_r = `df'
	est local svy_est `svy_est'
	est local svyml `svyml'
	est local depvar "`depn'"
	est local cmd    "`cmd'"
end

program define ScaMat
	args X x
	matrix `X' = (0)
	matrix `X'[1,1] = cond(`x'!=.,`x',0)
end

