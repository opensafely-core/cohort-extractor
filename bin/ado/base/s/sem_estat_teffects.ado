*! version 1.1.0  07jul2011
program sem_estat_teffects, rclass
	version 12
	
	if "`e(cmd)'"!="sem" {
		error 301
	}	
	
	syntax [, *]

	_get_diopts diopts options, `options'

	local 0 `", `options'"'
	syntax [, 		///
		STANDardized 	///
		NOLABel		///
		noDIRect	///
		noINDIRect	///
		noTOTal		///
		COMPact		///
		]

	local stand : length local standardized
	local omit : length local compact
	if (e(k_ox) + e(k_lx) == 0) {
		dis as txt "(model has no exogenous variables)"
		exit 
	}
	if (e(k_oy) + e(k_ly) == 0) {
		dis as txt "(model has no endogenous variables)"
		exit 
	}

	local direct = "`direct'" != "nodirect"
	local indirect = "`indirect'" != "noindirect"
	local total = "`total'" != "nototal"
	
	if `direct'+`indirect'+`total' == 0 {
		dis as txt "(nothing to do)"
		exit 
	}
	
	if `omit' {
		local diopts "`diopts' noomit"
	}

	tempname nobs
	matrix `nobs' = e(nobs)
	
	mata: st_sem_estat_teffects(`stand')

 	_ms_findomitted r(direct) r(V_direct)
 	_ms_findomitted r(indirect) r(V_indirect)
 	_ms_findomitted r(total) r(V_total)

	return matrix nobs = `nobs'
	return add

	tempname b V Cns code pclass
	matrix `pclass' = return(b_pclass)
	if `stand' {
		tempname std
	}
	local mlist direct indirect total
	foreach mat of local mlist {
		if ``mat'' {
			matrix `b' = return(`mat')
			matrix `V' = return(V_`mat')
			if `stand' {
				matrix `std' = return(`mat'_std)
			}
			local cnsopt
			if "`return(Cns_`mat')'" == "matrix" {
				matrix `Cns' = return(Cns_`mat')
				local cnsopt cnsmat(`Cns')
			}
			matrix `code' = return(code_`mat')
			di _n 
			di as txt strproper("`mat'") " effects"
			_coef_table,	bmat(`b')		///
					vmat(`V')		///
					emat(`code')		///
					`cnsopt'		///
					pclassmat(`pclass')	///
					bstdmat(`std')		///
					cmdextras		///
					nocnsreport		///
					noeqcheck		///
					`nolabel'		///
					`standardized'		///
					`diopts'
		}
	}
end         

exit
