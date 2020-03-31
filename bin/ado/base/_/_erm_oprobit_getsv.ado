*! version 1.0.1  12dec2019
program _erm_oprobit_getsv, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [		///
		touse(string)					///
		noconstant					///
		isigma22(string)				///
		sigma22(string)					///
		residuals(string)				///
		OFFset(passthru)				///
		storeresidual(string)]
	qui oprobit `varlist' `residuals' if `touse', `offset'
	tempname vals
	matrix `vals' = e(cat)
	local depvar `e(depvar)'
	local ncuts = e(k_cat) -1
	local np = e(k)
	tempvar xb
	qui predict double `xb' if `touse', xb
	local nresids: word count `residuals'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local fcolnames: colfullnames `bforcolnames'
	tempname bforcolnames
	matrix `bforcolnames' = e(b)
	local tfcolnames: colfullnames `bforcolnames'
	local fcolnames
	local npm = `np'-`nresids'-`ncuts'
	forvalues i = 1/`npm' {
		local w: word `i' of `tfcolnames'
		local fcolnames `fcolnames' `w'
	}

	tempname b btmp cov icov bcut
	if `nresids' > 0 {
		tempvar xbres
		qui gen double `xbres' = 0 if `touse'
		foreach var of varlist `residuals' {
			qui replace `xbres' = ///
				`xbres' + _b[`depvar':`var']*`var' ///
					if `touse'
		}
		tempvar temp
		qui gen `temp' = 0 in 1/`np'
		qui replace `temp' = 1 in 1
		tempname originaleb
		matrix `originaleb' = e(b)
		tempname scale
		qui nl erm_get_cov_oprobit @ `temp',		/// 	
			isigma22(`isigma22') sigma22(`sigma22')	///
			nparameters(`np') nresiduals(`nresids')	///
			ncuts(`ncuts') originaleb(`originaleb')	///
			storescale(`scale') 
		qui replace `xb' = `xb'*`scale' if `touse'
		qui replace `xbres' = `xbres'*`scale' if `touse'	
		matrix `btmp' = e(b)
		local t1 = `np'-`ncuts' + 1
		matrix `bcut' = `btmp'[1,`t1'..`np']
		local t2 = `np'-`ncuts'-`nresids'
		matrix `b' = `btmp'[1,1..`t2']
		local t1 = `np'-`ncuts'-`nresids'+1
		local t2 = `np'-`ncuts'
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
		if "`storeresidual'" != "" {
			qui gen double `storeresidual' = `xbres' if `touse'
			local upper (`bcut'[1,1]*`scale'-`xb')/`scale'	
			qui replace `storeresidual' = `storeresidual' + ///
				-`scale'*normalden(`upper')/		///
				normal(`upper') 			///
				if `depvar' == `vals'[1,1] & `touse'
			local j = `ncuts'-1
			forvalues i = 2/`j' {
				local upper (`bcut'[1,`j']*`scale'	///
					-`xb')/`scale'
				local lower (`bcut'[1,`j'-1]*`scale'	///
					-`xb')/`scale'	
				qui replace `storeresidual' = 		///
					`storeresidual' +		///
					`scale'*(			///
					normalden(`lower')-		///
					normalden(`upper'))/		///
					(normal(`upper')-		///
					normal(`lower'))		/// 	
					if `depvar' == `vals'[1,`i']	/// 
					& `touse'
			}
			local lower (`bcut'[1,`ncuts']*`scale'-`xb')/`scale'
			qui replace `storeresidual' = `storeresidual' + ///
				`scale'*normalden(`lower')/		///
				normal(-`lower')			///
				if `depvar' == `vals'[1,`ncuts'+1] & `touse'

		}
	}
	else {
		matrix `b' = e(b)
		local np = colsof(`b')
		local ncuts = e(k_cat)-1
		local ncuts = `np'-`ncuts'+1
		matrix `bcut' = `b'[1,`ncuts'..`np']
		local ncuts = `ncuts'-1
		matrix `b' = `b'[1,1..`ncuts']
		matrix `cov' = I(1)
		matrix `icov' = I(1)		
		if "`storeresidual'" != "" {
			local ncuts = e(k_cat)-1
			qui gen double `storeresidual' = 0 if `touse'
			local upper (`bcut'[1,1]-`xb')	
			qui replace `storeresidual' = 			///
				-normalden(`upper')/			///
				normal(`upper') 			///
				if `depvar' == `vals'[1,1] & `touse'
			local j = `ncuts'-1
			forvalues i = 2/`j' {
				local upper (`bcut'[1,`j']-`xb')
				local lower (`bcut'[1,`j'-1]-`xb')	
				qui replace `storeresidual' = 		///
					(normalden(`lower')-		///
					normalden(`upper'))/		///
					(normal(`upper')-		///
					normal(`lower'))		/// 	
					if `depvar' == `vals'[1,`i']	/// 
					& `touse'
			}
			local lower (`bcut'[1,`ncuts']-`xb')	
			qui replace `storeresidual' = 			///
				normalden(`lower')/			///
				normal(-`lower')			///
				if `depvar' == `vals'[1,`ncuts'+1] & `touse'
		}
	}
	matrix colnames `b' = `fcolnames'
	return matrix b = `b'	
	return matrix cov = `cov'
	return matrix icov = `icov'
	return matrix bcut = `bcut'
end
exit

