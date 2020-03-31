*! version 1.0.4  24feb2005
// new version:  looks for e(V_srs) and e(V_srswr) to gen e(deff) and e(deft)
program define _svy_mkdeff
	version 8
	if _caller() >= 9 {
		if "`e(prefix)'" != "svy" {
			di as err "svy estimation results not found"
			exit 301
		}
	}

	is_svysum `e(cmd)'
	local is_svysum = r(is_svysum)
	if `"`e(deff)'"' == "" {
		MakeDeff
	}
	if _caller() >= 9 ///
	 & `"`e(deffsub)'"' == "" ///
	 & (`"`e(subpop)'"' != "" ///
	 | (`is_svysum' & `"`e(over)'"' != "")) {
		MakeDeff, sub
	}

	if (_caller() >= 9) exit

	// double saves
	matrix S_E_Vsrs = e(V_srs)
	matrix S_E_deff = e(deff)
	matrix S_E_deft = e(deft)

	if "`e(V_srswr)'" != "" {
		matrix S_E_Vswr = e(V_srswr)
	}
end

program MakeDeff, eclass
	syntax [, sub ]
	tempname Vsrs f V deff deft

	// create row vectors for deff and deft
	matrix `V'	= vecdiag(e(V))
	local dim	= colsof(`V')
	matrix `deff'	= `V'
	matrix `deft'	= `V'
	matrix `Vsrs'	= e(V_srs`sub')
	if "`e(V_srs`sub'wr)'" != "" {
		tempname Vsrswr
		matrix `Vsrswr' = e(V_srs`sub'wr)
	}
	else	local Vsrswr `Vsrs'

	// perform computations for deff and deft
	forval i = 1/`dim' {
		scalar `f' = `V'[1,`i']/`Vsrs'[`i',`i']
		matrix `deff'[1,`i'] = cond(missing(`f'), 0, `f')

		scalar `f' = sqrt(`V'[1,`i']/`Vsrswr'[`i',`i'])
		matrix `deft'[1,`i'] = cond(missing(`f'), 0, `f')
	}

	// save matrices
	ereturn matrix deff`sub'  `deff'
	ereturn matrix deft`sub'  `deft'
end

exit
