*! version 1.0.1  12dec2019
program _erm_re_probit_getsv, rclass
	version 16
	syntax varlist(numeric fv ts) [pw iw fw], [	///
		touse(string)				///
		isigma22(string)			///
		sigma22(string) 			///
		isigmaa(string)				///
		sigmaa(string)				///
		residualse(string)			///
		residualsa(string)			///
		noConstant				///
		OFFset(passthru)			///
		storeresiduale(string)			///
		storeresiduala(string) panvar(string) ]
	tempname xb xbrese xbresa b btmp
	tempname cov22 icov22
	tempname covaa icovaa
	tempname bforcolnames
	if "`residualse'" == "" {
		gettoken depvar varlist: varlist
		qui xtprobit `depvar' `varlist', `constant' `offset' iter(50)
		matrix `btmp' = e(b)
		local tfcolnames: colfullnames `btmp'
		local k = e(k)
		matrix `covaa' = `btmp'[1,`k']
		matrix `covaa'[1,1] = exp(`covaa'[1,1])
		matrix `icovaa' = 1/`covaa'[1,1]
		matrix `cov22'	= 1
		matrix `icov22' = 1
		qui predict double `xb', xb
		local j = `k'-1
		local fcolnames
		forvalues i=1/`j' {
			gettoken f tfcolnames: tfcolnames
			local fcolnames `fcolnames' `f'
		}
		matrix `b' = `btmp'[1,1..`j']
		local sc = `covaa'[1,1]
		qui gsem (`depvar' <- `xb'@1 U[`panvar']@1, probit), ///
			nocapslatent latent(U) var(U[`panvar']@`sc') ///
			noestimate startvalues(zero) iter(50)
		qui predict double `storeresiduala', latent
		qui replace `xb' = `xb' + `storeresiduala'
		qui gen double  `storeresiduale' =  		///
				cond(`depvar',			///
				normalden(-`xb')/normal(`xb'),	///
				-normalden(-`xb')/normal(-`xb'))
		local scale 1		
	}
	else {
		qui xtprobit `varlist' `residualsa' `residualse' ///
			if `touse', re asis `constant' `offset'  ///
                        iter(50)
		local depvar `e(depvar)'
		local np = e(k)
		matrix `bforcolnames' = e(b)
		local tfcolnames: colfullnames `bforcolnames'
		local colnames
		local nresidualsa: word count `residualsa'
		local nresidualse: word count `residualse'
		if "`constant'" == "noconstant" {
			local npm = `np'-1-`nresidualsa'-`nresidualse'
			forvalues i = 1/`npm' {
				local w: word `i' of `tfcolnames'
				local colnames `colnames' `w'
			}
		}
		else {
			local npm = `np'-`nresidualsa'-`nresidualse'-2
			forvalues i = 1/`npm' {
				local w: word `i' of `tfcolnames'
				local colnames `colnames' `w'
			}
			local k = `np'-1
			local w: word `k' of `tfcolnames'
			local colnames `colnames' `w'		
		}
		
 		// fixed values
		qui predict double `xb' if `touse', xb
		// random effects residuals
		qui gen double `xbresa' = 0
		foreach var of varlist `residualsa' {
			qui replace `xbresa' = `xbresa' + 		///
				_b[`e(depvar)':`var']*`var' if `touse'		
		}
		// observation level residuals
		qui gen double `xbrese' = 0
		local nresidualsa: word count `residualse'
		foreach var of varlist `residualse' {
			qui replace `xbrese' = `xbrese' + 		///
				_b[`e(depvar)':`var']*`var' if `touse'		
		}
	
		local k = e(k)
		tempvar temp
		qui gen `temp' = 0 in 1/`k'
		qui replace `temp' = 1 in 1
		tempname originaleb
		matrix `originaleb' = e(b)
		tempname scale
		local hnoconstant 
		if "`constant'" == "noconstant" {
			local hnoconstant hnoconstant
		}
		qui nl erm_re_get_cov_probit @ `temp',			/// 
			isigma22(`isigma22') sigma22(`sigma22')		/// 
			isigmaa(`isigmaa') sigmaa(`sigmaa')		/// 	
			nresiduals(`nresidualse') nparameters(`np') 	///
			originaleb(`originaleb') storescale(`scale') 	///
			`hnoconstant'
		matrix `btmp' = e(b)
		if "`constant'" != "noconstant" {
			local t = `k'-2*`nresidualse'-2
			matrix `b' = (`btmp'[1,1..`t'],`btmp'[1,`k'-1])	
		}
		else {
			local t = `k'-2*`nresidualse'-1
			matrix `b' = `btmp'[1,1..`t']			
		}
		local t1 = `t'+1
		local t2 = `t' + `nresidualsa'
		matrix `covaa' = (`btmp'[1,`k'],	///
				`btmp'[1,`t1'..`t2'] \	///
				(`btmp'[1,`t1'..`t2'])',`sigmaa')
                mata : st_local("ispsd", ///
                       strofreal(__ispsd(st_matrix("`covaa'"))))
                if !`ispsd' {
                        mata : st_matrix("`covaa'",               ///
                               __MakePSD(st_matrix("`covaa'"),    ///
                               epsilon(20)))
                }
		matrix `icovaa' = invsym(`covaa')
		local t1 = `t2'+1
		local t2 = `t2'+`nresidualse'
		matrix `cov22' = (1,	///
				`btmp'[1,`t1'..`t2'] \	///
				(`btmp'[1,`t1'..`t2'])',`sigma22')
                mata : st_local("ispsd", ///
                       strofreal(__ispsd(st_matrix("`cov22'"))))
                if !`ispsd' {
                        mata : st_matrix("`cov22'",               ///
                               __MakePSD(st_matrix("`cov22'"),    ///
                               epsilon(20)))
                }
		matrix `icov22' = invsym(`cov22')
		qui replace `xb' = `xb'*`scale' if `touse'
		qui replace `xbrese' = `xbrese'*`scale' if `touse'
		qui replace `xbresa' = `xbresa'*`scale' if `touse'

		tempvar ddepvar0 ddepvar1
		qui gen `ddepvar0' = 0 if ~`depvar' & `touse'
		qui gen `ddepvar1' = 0 if `depvar' & `touse'
		local scscale = `scale'^2
		tempname resavar  
		local kavar = colsof(`covaa')
		matrix `resavar' = `covaa'[1,1] -	/// 
			`covaa'[1,2..`kavar']*invsym(	///
			`covaa'[2..`kavar',2..`kavar'])*`covaa'[2..`kavar',1]
                local scresavar = `resavar'[1,1]
		qui gsem (`ddepvar1' <- `xb'@1 U[`panvar']@1), noconstant ///
			family(gaussian, udepvar(`ddepvar0')) 	///
			var(e.`ddepvar1'@`scscale') noestimate	///
			var(U[`panvar']@`scresavar') startv(zero) ///
                        iter(50)
		tempvar ub
		qui predict double `ub', latent
		tempvar xbfull
		qui gen double `xbfull' = (`xb' + `ub')/`scale' if `touse'
		qui gen double	`storeresiduala' = `xbresa' + `ub' if `touse'
		qui gen double  `storeresiduale' = `xbrese' + 		///
				`scale'*cond(`depvar',			///
				normalden(-`xbfull')/normal(`xbfull'),	///
				-normalden(-`xbfull')/normal(-`xbfull'))	
	}
	matrix colnames `b' = `colnames'
	return matrix b = `b'	
	return matrix cov22 = `cov22'
	return matrix icov22 = `icov22'
	return matrix covaa = `covaa'
	return matrix icovaa = `icovaa'
	return scalar scale = `scale'
end
exit
