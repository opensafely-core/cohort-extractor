*! version 1.0.0  20feb2017
program nlerm_get_cov_probit
	version 15
	syntax varlist(min=1 max=1) [if], at(name)	///
		isigma22(string) sigma22(string)	///
		nresiduals(string) 			///
		originaleb(string) storescale(string)	///
		[hnoconstant]
	local np = colsof(`at')
	tempname covvec
	matrix `covvec' = J(1,`nresiduals',.)
	local adj = 0
	if "`hnoconstant'" == "" {
		local adj = -1
	}
	forvalues i = 1/`nresiduals' {
			matrix `covvec'[1,`i'] = `at'[1,	///
				`np'-`nresiduals'+`i'+`adj']
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
	local j = `np' -`nresiduals'+`adj'
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
	if "`hnoconstant'" == "" {
		qui replace `yh' = `at'[1,`np']/`freesig'-	///
			`originaleb'[1,`np'] in `j'
	}
	qui replace `yh' = `yh' + 1 in 1 
	qui replace `varlist' = `yh'
end

exit
