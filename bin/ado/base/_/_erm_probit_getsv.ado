*! version 1.0.1  12dec2019
program _erm_probit_getsv, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [	///
		touse(string)				///
		isigma22(string)			///
		sigma22(string) 			///
		residuals(string)			///
		noConstant				///
		OFFset(passthru)			///
		storeresidual(string)]
	tempname xb xbres b btmp cov icov
	qui probit `varlist' `residuals' if `touse', asis	///
		`constant' `offset'
	local depvar `e(depvar)'
	local np = e(k)
	qui predict double `xb' if `touse', xb
	local nresids: word count `residuals'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local fcolnames: colfullnames `bforcolnames'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local tfcolnames: colfullnames `bforcolnames'
	local fcolnames
	if "`constant'" == "noconstant" {
		local npm = `np'-`nresids'
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
		tempvar xbres
		qui gen double `xbres' = 0 if `touse'
		foreach var of varlist `residuals' {
			qui replace `xbres' = ///
				`xbres' + _b[`e(depvar)':`var']*`var' ///
					if `touse'
		}
		tempvar temp
		qui gen `temp' = 0 in 1/`np'
		qui replace `temp' = 1 in 1
		tempname originaleb
		matrix `originaleb' = e(b)
		tempname scale
		local hnoconstant 
		if "`constant'" == "noconstant" {
			local hnoconstant hnoconstant
		}
		qui nl erm_get_cov_probit @ `temp', isigma22(`isigma22') ///	
			sigma22(`sigma22') nresiduals(`nresids')	 /// 
			nparameters(`np') 				 ///
			originaleb(`originaleb') storescale(`scale') 	 ///
			`hnoconstant'
		qui replace `xb' = `xb'*`scale' if `touse'
		qui replace `xbres' = `xbres'*`scale' if `touse'
		matrix `btmp' = e(b)
		// covariance indices 
		if "`constant'" != "noconstant" {
			local t = `np' - `nresids'-1
			local t1 = `np'-`nresids'
			local t2 = `np'-1
			matrix `b' = (`btmp'[1,1..`t'],`btmp'[1,`np'])
			matrix `cov' = (1, `btmp'[1,`t1'..`t2'] \	///
					(`btmp'[1,`t1'..`t2'])',`sigma22')
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
			local t = `np'-`nresids'
			local t1 = `np'-`nresids'+1
			matrix `b' = `btmp'[1,1..`t']
			matrix `cov' = (1,`btmp'[1,`t1'..`np'] \	///
					(`btmp'[1,`t1'..`np'])',`sigma22')
                        mata : st_local("ispsd", ///
                               strofreal(__ispsd(st_matrix("`cov'"))))
                        if !`ispsd' {
                                mata : st_matrix("`cov'",               ///
                                       __MakePSD(st_matrix("`cov'"),    ///
                                       epsilon(20)))
                        }
			matrix `icov' = invsym(`cov')			
		}
		if "`storeresidual'" != "" {
			qui gen double `storeresidual' =  `xbres' + 	///
				`scale'*cond(`depvar',			///
				normalden(`xb'/`scale')/		///
					normal(`xb'/`scale'),		///
				-normalden(`xb'/`scale')/		///
					normal(-`xb'/`scale'))		///
				 if `touse'
		}
	}
	else {
		matrix `b' = e(b)
		matrix `cov' = I(1)
		matrix `icov' = I(1)		
		if "`storeresidual'" != "" {
			qui gen double `storeresidual' =   	///
				cond(`depvar',			///
				normalden(`xb')/		///
					normal(`xb'),		///
				-normalden(`xb')/		///
					normal(-`xb'))		///
				 if `touse'
		}
	}
	matrix colnames `b' = `fcolnames'
	return matrix b = `b'	
	return matrix cov = `cov'
	return matrix icov = `icov'
end
exit
