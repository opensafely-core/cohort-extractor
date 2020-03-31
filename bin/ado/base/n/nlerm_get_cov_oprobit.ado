*! version 1.0.0  28mar2016
program nlerm_get_cov_oprobit
	version 15
	syntax varlist(min=1 max=1) [if], at(name)	///
		isigma22(string) sigma22(string)	///
		nresiduals(string) 			///
		originaleb(string) storescale(string)	///
		ncuts(string)
	local np = colsof(`at')
	tempname covvec
	matrix `covvec' = J(1,`nresiduals',.)
	forvalues i = 1/`nresiduals' {
			matrix `covvec'[1,`i'] = `at'[1,	///
				`np'-`nresiduals'+`i'-`ncuts']
	}
	tempname freevar
	matrix `freevar' = `covvec'*`isigma22'*(`covvec'')
	tempname freesig
	scalar `freesig' = sqrt(1-`freevar'[1,1])
	scalar `storescale' = `freesig'
	tempname residmat
	matrix `residmat' = `covvec'*`isigma22'
	tempvar yh
	qui gen double `yh' = .
	local j = `np' -`nresiduals'-`ncuts'
	forvalues i = 1/`j' {
		qui replace `yh' = `at'[1,`i']/`freesig' - ///
			`originaleb'[1,`i'] in `i'
	}
	local j = `j'+1
	forvalues h=1/`nresiduals' {
		qui replace `yh' = `residmat'[1,`h']/`freesig'	///
			-`originaleb'[1,`j'] in `j'
		local j = `j' + 1
	}
	forvalues h=`j'/`np' {
		qui replace `yh' = `at'[1,`h']/`freesig'	///
			-`originaleb'[1,`h'] in `h'
	}
	qui replace `yh' = `yh' + 1 in 1 
	qui replace `varlist' = `yh'
end

exit
