*! version 1.0.1  03jan2005
program define _svy_mkmeff, eclass
	version 8
	args Vmeff

/* Create row vector containing meft. */

	tempname V f meft
	matrix `V' = e(V)
	if colsof(`Vmeff') != colsof(`V') {
		matrix `Vmeff' = 0*`V'
	}
	matrix `V' = vecdiag(`V')
	matrix `meft' = `V'

	local dim = colsof(`V')
	forval i = 1/`dim' {
		scalar `f' = sqrt(`V'[1,`i']/`Vmeff'[`i',`i'])
		matrix `meft'[1,`i'] = cond(`f'<., `f', 0)
	}

/* Save matrices. */

	ereturn matrix V_msp `Vmeff'
	ereturn matrix meft `meft'

	if (_caller() >= 9) exit

/* Double saves. */

	matrix S_E_Vmsp = e(V_msp)
	matrix S_E_meft = e(meft)
end

