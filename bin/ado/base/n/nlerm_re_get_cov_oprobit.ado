*! version 1.0.0  23jan2018
program nlerm_re_get_cov_oprobit
	version 16
	syntax varlist(min=1 max=1) [if], at(name)	///
		isigma22(string) sigma22(string)	///
		isigmaa(string) sigmaa(string)		///
		nresiduals(string) 			///
		originaleb(string) storescale(string)	///
		ncuts(string)
	local np = colsof(`at')
	tempname covveca
	matrix `covveca' = J(1,`nresiduals',.)
	tempname covvece
	matrix `covvece' = J(1,`nresiduals',.)
	forvalues i = 1/`nresiduals' {
		matrix `covveca'[1,`i'] = `at'[1,	///
			`np'-2*`nresiduals'+`i'-`ncuts'-1]
		matrix `covvece'[1,`i'] = `at'[1,	///
			`np'-`nresiduals'+`i'-`ncuts'-1]
	}
	tempname freevar
	matrix `freevar' = `covvece'*`isigma22'*(`covvece'')
	tempname freesig
	scalar `freesig' = sqrt(1-`freevar'[1,1])
	scalar `storescale' = `freesig'
	tempname freevara
	matrix `freevara' = `covveca'*`isigmaa'*(`covveca'')
	tempname residmate residmata
	matrix `residmate' = `covvece'*`isigma22'
	matrix `residmata' = `covveca'*`isigmaa'
	tempvar yh
	qui gen double `yh' = .
	local j = `np' - 2*`nresiduals'-`ncuts'-1
	forvalues i = 1/`j' {
		qui replace `yh' = `at'[1,`i']/`freesig' - ///
			`originaleb'[1,`i'] in `i'
	}
	local j = `j'+1
	forvalues h=1/`nresiduals' {
		qui replace `yh' = `residmata'[1,`h']/`freesig'	///
			-`originaleb'[1,`j'] in `j'
		local j = `j' + 1
	}
	forvalues h=1/`nresiduals' {
		qui replace `yh' = `residmate'[1,`h']/`freesig'	///
			-`originaleb'[1,`j'] in `j'
		local j = `j' + 1
	}
	local npm1 = `np'-1
	forvalues h=`j'/`npm1' {
		qui replace `yh' = `at'[1,`h']/`freesig'	///
			-`originaleb'[1,`h'] in `h'
	}
	qui replace `yh' = `at'[1,`np'] - ((`originaleb'[1,`np'])*(	///
				`freesig'^2) + `freevara'[1,1]) in `np'
	qui replace `yh' = `yh' + 1 in 1 
	qui replace `varlist' = `yh'
end

exit
