*! version 1.0.0  03feb2016
program nlgetpronresid
	version 15.0
	syntax varlist(min=1 max=1) [if], at(name) 		///
		icovycont(string) nresids(string) ncuts(string) ///
		totp(string) regat(string) cov(string) 		///
		storescale(string)
	local j = `totp' - `nresids' - `ncuts' + 1
	local covvec `at'[1,`j']*sqrt(`cov'[1,1])
	local j = `j' + 1
	local totpmcut = `totp'-`ncuts'
	local k = 2
	forvalues i = `j'/`totpmcut' {
		local covvec `covvec', `at'[1,`i']*sqrt(`cov'[`k',`k'])
		local k = `k' + 1
	}
	local covvec (`covvec')	
	tempname freevar residmat mcovvec
	matrix `mcovvec' = `covvec'
	matrix `freevar' = `mcovvec' * `icovycont' * (`mcovvec'')
	tempname freesig 
	scalar `freesig' = sqrt(1-`freevar'[1,1])
	scalar `storescale' = `freesig'
	matrix `residmat' = `mcovvec'*`icovycont'
	tempvar yh
	local j = `totp'-`nresids'-`ncuts'
	qui gen double `yh' = `at'[1,1]/`freesig' - `regat'[1,1] ///
		if `j' >= 1 in 1
	forvalues i = 2/`j' {
		replace `yh' = `at'[1,`i']/`freesig' ///
			- `regat'[1,`i'] in `i'
	}
	local j = `totp' - `ncuts' + 1
	forvalues i = `j'/`totp' {
		qui replace `yh' = `at'[1,`i']/`freesig' ///
				- `regat'[1,`i'] in `i'
	}
	local j = `totp'-`nresids' - `ncuts' + 1
	forvalues h = 1/`nresids' {
		qui replace `yh' = `residmat'[1,`h']/`freesig' ///
			- `regat'[1,`j'] in `j'
		local j = `j' + 1 
	}
	replace `yh' = `yh'+1 in 1
	qui replace `varlist' = `yh'
end



