*! version 1.2.7  18dec2018
program _prefix_model_test, eclass
	version 9
	syntax [name(name=cmd)] [, svy noADJust noSVYadjust MINimum ]

	if (inlist("`cmd'","asmixlogit","cmmixlogit","cmxtmixlogit")) {
		_asmixtest, `svy' `adjust' `svyadjust'
		exit
	}

	local K = 1
	if "`e(k_eq_model)'" != "" {
		capture confirm integer number `e(k_eq_model)'
		if ! c(rc) {
			local K = e(k_eq_model)
		}
	}
	if "`e(k_eq_model_skip)'" != "" {
		capture confirm integer number `e(k_eq_model_skip)'
		if ! c(rc) {
			local skip = e(k_eq_model_skip)
		}
	}
	ereturn local df_m
	ereturn local F
	ereturn local chi2
	ereturn local chi2type
	ereturn local p
	if (`K' == 0) {
		exit
	}
	forval i = 1/`K' {
		if !`:list i in skip' {
			local spec "`spec' ([#`i'])"
		}
	}

	// look for constraints
	tempname cns omit
	capture matrix `cns' = get(Cns)
	if (c(rc)) local cns

	if "`cns'" != "" {
		local k_autoCns = e(k_autoCns)
		if missing(`k_autoCns') {
			local k_autoCns 0
		}
		if rowsof(`cns') == `k_autoCns' {
			local cns
		}
	}

	if "`svy'" != "" & "`adjust'`svyadjust'" != "" {
		local adjust nosvyadjust
	}
	else	local adjust

	_ms_omit_info e(b), nocons
	matrix `omit'	= r(omit)	
        capture test `spec', `adjust'
	if !c(rc) {
		if `:length local minimum' {
			quietly test, min
		}
		ereturn scalar df_m = r(df)
		local drop = r(drop)
		if `drop' {
			local drop 0
			local i 1
			local idrop `"`r(dropped_`i')'"'
			while "`idrop'" != "" {
				if !`omit'[1,`idrop'] {
					local ++drop
				}
				local ++i
				local idrop `"`r(dropped_`i')'"'
			}
		}
		if `drop' == 0 | "`cns'" != "" {
			if !missing(e(df_r)) {
				ereturn scalar F = r(F)
			}
			else {
				ereturn scalar chi2 = r(chi2)
				ereturn local chi2type Wald
			}
			ereturn scalar p = r(p)
		}
		else {
			if !missing(e(df_r)) {
				ereturn scalar F = .
			}
			else {
				ereturn scalar chi2 = .
				ereturn local chi2type Wald
			}
			ereturn scalar p = .
		}
	}
	else {
		if missing(e(df_r)) {
			ereturn local chi2type Wald
		}
		ereturn scalar df_m = 0
	}
end
