*! version 1.0.0  28mar2016
program nlerm_get_cov_regress
	version 15
	syntax varlist(min=1 max=1) [if], at(name)	///
		isigma22(string) sigma22(string)	///
		originaleb(string)
	tempname residmat
	matrix `residmat' = `at'*`isigma22'
	local np = colsof(`at')
	tempvar yh
	qui gen double `yh' = .
	forvalues i = 1/`np' {
		qui replace `yh' = `residmat'[1,`i'] - ///
			`originaleb'[1,`i'] in `i'
	}
	qui replace `yh' = `yh' + 1 in 1
	qui replace `varlist' = `yh'
end
exit
