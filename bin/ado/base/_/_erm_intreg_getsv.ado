*! version 1.0.1  12dec2019
program _erm_intreg_getsv, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [	///
		ll(string)				///
		ul(string)				///
		touse(string)				///
		isigma22(string)			///
		sigma22(string) 			///
		residuals(string)			///
		noConstant				///
		OFFset(passthru)  			///
		storeresidual(string) depvarname(string) ]
	tempname xb residval
	qui intreg `ll' `ul' `varlist' `residuals' if `touse', ///
		`constant' `offset'
	qui predict double `xb' if `touse', xb
	tempname btmp
	matrix `btmp' = e(b)
	local np = e(k)-1
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
		matrix `resbeta' = J(1,`nresids',0)
	}
	local i = 1
	tempvar xbres
	qui gen double `xbres' = 0
	foreach var of local residuals {
		qui replace `xb' = `xb' - _b[`depvar':`var']*`var' if `touse'
		qui replace `xbres' = `xbres' + ///
			_b[`depvar':`var']*`var' if `touse'
		matrix `resbeta'[1,`i'] = _b[`depvar':`var']
		local i = `i' + 1
	}
	tempname var ovar
	scalar `ovar' = (exp(_b[lnsigma:_cons]))^2
	tempname b cov icov
	if `nresids' == 1 {
		scalar `var' = `ovar' +  ((`resbeta'[1,1])^2)*`sigma22'[1,1]
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
		tempname matvar
		matrix `matvar' = `cov'*`isigma22'*`cov'' 
		scalar `var' = `ovar' + `matvar'[1,1]
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
		scalar `var' = `ovar'
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
			local k = `np'-`nresids'
			matrix `b' = `btmp'[1,1..`k']
		}
		else {
			matrix `b' = `btmp'
		}
	}
	if "`storeresidual'" != "" {
		tempname scale
		scalar `scale' = sqrt(`ovar')
		qui gen double `storeresidual' = `ll' - `xb' -`xbres'	/// 
			if ~missing(`ll') & ~missing(`ul') & (		///
				`ll'==`ul')	
		local lower ((`ll'-`xb'-`xbres')/`scale')
		qui replace `storeresidual' = `xbres' + 	///
			`scale'*normalden(`lower')/		///
			normal(-`lower')			///
			if missing(`ul') & ~missing(`ll')
		local upper ((`ul'-`xb'-`xbres')/`scale')
		qui replace `storeresidual' = `xbres' +		///
			-`scale'*normalden(`upper')/		///
			normal(`upper')				///
			if missing(`ll') & ~missing(`ul')
		qui replace `storeresidual' = `xbres' +		///
			`scale'*(				///
				normalden(`lower')-		///
				normalden(`upper'))/		///
				(normal(`upper')-		///	
				normal(`lower'))		///
			if ~missing(`ll') & ~missing(`ul') & (	///
				`ll' != `ul')
	}
	matrix colnames `b' = `fcolnames'
	matrix coleq `b' = `depvarname'
	return matrix b = `b'	
	return matrix cov = `cov'
	return matrix icov = `icov'	
end
exit
