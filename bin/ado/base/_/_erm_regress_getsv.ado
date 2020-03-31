*! version 1.0.2  11dec2019
program _erm_regress_getsv, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [	///
		touse(string)				///
		isigma22(string)			///
		sigma22(string) 			///
		residuals(string)			///
		noConstant				///
		OFFset(passthru)			///
		storeresidual(string)]
	tempname xb residval
	gettoken depvar rvarlist: varlist
	qui gsem (`depvar' <-`rvarlist' `residuals',`offset' `constant') ///
		if `touse', nocapslatent iter(50)
	local np = e(k)-1
	qui predict double `xb' if `touse', eta
	tempname btmp
	matrix `btmp' = e(b)
	matrix `btmp' = `btmp'[1,1..`np']
	tempname resbeta
	local nresids: word count `residuals'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local fcolnames: colfullnames `bforcolnames'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local tfcolnames: colfullnames `bforcolnames'
	local fcolnames
	if "`constant'" == "noconstant" {
		local npm = `np'-`nresids'-1
		forvalues i = 1/`npm' {
			local w: word `i' of `tfcolnames'
			local fcolnames `fcolnames' `w'
		}
	}
	else {
		local npm = `np'-`nresids'-1
		forvalues i = 1/`npm' {
			local w: word `i' of `tfcolnames'
			local fcolnames `fcolnames' `w'
		}
		local w: word `np' of `tfcolnames'
		local fcolnames `fcolnames' `w'		
	}
	if `nresids' > 0 {
		matrix `resbeta' = J(1,`nresids',0)
	}
	local i = 1
	foreach var of local residuals {
		qui replace `xb' = `xb' - _b[`depvar':`var']*`var' if `touse'
		matrix `resbeta'[1,`i'] = _b[`depvar':`var']
		local i = `i' + 1
	}
	qui gen double `residval' = `depvar'-`xb' if `touse'
	qui sum `residval' if `touse'
	tempname var
	scalar `var' = r(Var)
	tempname b cov icov
	if `nresids' == 1 {
		matrix `cov' = (`var',`resbeta'[1,1]*`sigma22'[1,1] \ ///
				`resbeta'[1,1]*`sigma22'[1,1],`sigma22')
                mata : st_local("ispsd", ///
                       strofreal(__ispsd(st_matrix("`cov'"))))
                if !`ispsd' {
                        mata : st_matrix("`cov'",               ///
                               __MakePSD(st_matrix("`cov'"),    ///
                              epsilon(20)))
                }
		matrix `icov' = invsym(`cov')
	}
	else if `nresids' > 0 {
		tempvar temp
		qui gen `temp' = 0 if _n <= `nresids'
		qui replace `temp' = 1 in 1
		qui nl erm_get_cov_regress @`temp',isigma22(`isigma22') ///
			sigma22(`sigma22') originaleb(`resbeta')	/// 	
			nparameters(`nresids')
		matrix `cov' = e(b)
		matrix `cov' = (`var',`cov' \ `cov'',`sigma22')
                mata : st_local("ispsd", ///
                       strofreal(__ispsd(st_matrix("`cov'"))))
                if !`ispsd' {
                        mata : st_matrix("`cov'",               ///
                               __MakePSD(st_matrix("`cov'"),    ///
                              epsilon(20)))
                }
		matrix `icov' = invsym(`cov')
	}
	else {
		matrix `cov' = (`var')
		matrix `icov' = (1/`var')
	}
	if "`constant'" != "noconstant" {
		if `nresids' > 0 {
			local k = `np'-`nresids'-1
			matrix `b' = (`btmp'[1,1..`k'],`btmp'[1,`np']) 
		}
		else {
			matrix `b' = `btmp'
		}
	}
	else {
		if `nresids' > 0 {
			local k = `np'-`nresids'-1
			matrix `b' = `btmp'[1,1..`k']
		}
		else {
			local k = `np'-1
			matrix `b' = `btmp'[1,1..`k']
		}
	}
	if "`storeresidual'" != "" {
		qui gen double `storeresidual' = `residval' if `touse'
	}
	matrix colnames `b' = `fcolnames'
	return matrix b = `b'
	return matrix cov = `cov'
	return matrix icov = `icov'	
end

exit
