*! version 1.0.1  12dec2019
program _erm_re_oprobit_getsv, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [		///
		touse(string)					///
		noconstant					///
		isigma22(string)				///
		sigma22(string)					///
		isigmaa(string)					///
		sigmaa(string)					///		
		residualse(string)				///
		residualsa(string)				///
		OFFset(passthru)				///
		storeresiduale(string)				///
		storeresiduala(string) panvar(string)]
	tempname xb xbrese xbresa b btmp
	tempname cov22 icov22
	tempname covaa icovaa
	tempname bforcolnames
	tempname bcut vals
	if "`residualse'" == "" {
		gettoken depvar varlist: varlist
		qui gsem (`depvar' <- `varlist' U[`panvar'], ///
			oprobit `offset') if `touse', nocapslatent ///
                        latent(U) iter(50)
		matrix `vals' = e(cat1)
		matrix `btmp' = e(b)
		local tfcolnames: colfullnames `btmp'
		local k = e(k)
		matrix `covaa' = `btmp'[1,`k']
		matrix `icovaa' = 1/`covaa'[1,1]
		matrix `cov22'	= 1
		matrix `icov22' = 1
		local ncuts = e(k_cat1)-1
		if "`offset'" == "" {
			local npm = `k'-`ncuts'-1-1
		}
		else {
			local npm = `k'-`ncuts'-1-1-1
		}
		local fcolnames 
		forvalues i = 1/`npm' {
			local w: word `i' of `tfcolnames'
			local fcolnames `fcolnames' `w'
		}
		matrix `b' = `btmp'[1,1..`npm']
		if "`offset'" == "" {
			local k1 = `npm' + 2
		}
		else {
			local k1 = `npm' + 3
		}
		local k2 = `k'-1
		matrix `bcut' = `btmp'[1,`k1'..`k2']
		matrix colnames `b' = `fcolnames'
		// store residual
		qui predict double `xb', conditional(fixedonly)
		qui predict double `storeresiduala', latent
		qui replace `xb' = `xb' + `storeresiduala'
		qui gen double `storeresiduale' = 0 if `touse'	
		local upper (`bcut'[1,1]-`xb')	
		qui replace `storeresiduale' = 			///
			-normalden(`upper')/			///
			normal(`upper') 			///
			if `depvar' == `vals'[1,1] & `touse'
		local j = `ncuts'
		forvalues i = 2/`j' {
			local upper (`bcut'[1,`j']-`xb')
			local lower (`bcut'[1,`j'-1]-`xb')	
			qui replace `storeresiduale' = 		///
				(normalden(`lower')-		///
				normalden(`upper'))/		///
				(normal(`upper')-		///
				normal(`lower'))		/// 	
				if `depvar' == `vals'[1,`i']	/// 
				& `touse'
		}
		local lower (`bcut'[1,`ncuts']-`xb')	
		qui replace `storeresiduale' = 			///
			normalden(`lower')/			///
			normal(-`lower')			///
			if `depvar' == `vals'[1,`ncuts'+1] & `touse'
		local scale 1	

		return matrix b = `b'	
		return matrix cov22 = `cov22'
		return matrix icov22 = `icov22'
		return matrix covaa = `covaa'
		return matrix icovaa = `icovaa'
		return scalar scale = `scale'		
		return matrix bcut = `bcut'
	}
	else {
		qui xtoprobit `varlist' `residualsa' `residualse' ///
			if `touse', `offset' iter(50)
		gettoken depvar varlist: varlist
		matrix `vals' = e(cat)
		matrix `btmp' = e(b)
		local tfcolnames: colfullnames `btmp'
		local k = e(k)
		local nresidualsa: word count `residualsa'
		local nresidualse: word count `residualse'
		local ncuts = e(k_cat)-1	
		if "`offset'" == "" {
			local npm = `k'-`nresidualsa'-`nresidualse'-`ncuts'-1
		}
		else {
			local npm = `k'-`nresidualsa'-`nresidualse'-`ncuts'-2
			
		}
		local fcolnames 
		forvalues i = 1/`npm' {
			local w: word `i' of `tfcolnames'
			local fcolnames `fcolnames' `w'
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
		if "`offset'" == "" {
			local k = e(k)
		}
		else {
			local k = e(k)-1
		}
		tempvar temp
		qui gen `temp' = 0 in 1/`k'
		qui replace `temp' = 1 in 1
		tempname originaleb
		matrix `originaleb' = e(b)
		tempname scale

		qui nl erm_re_get_cov_oprobit @ `temp',			/// 
			isigma22(`isigma22') sigma22(`sigma22')		/// 
			isigmaa(`isigmaa') sigmaa(`sigmaa')		/// 	
			nresiduals(`nresidualse') nparameters(`k') 	///
			originaleb(`originaleb') storescale(`scale') 	///
			ncuts(`ncuts')
		matrix `btmp' = e(b)
		local t = `k'-2*`nresidualse'-`ncuts'-1
		matrix `b' = `btmp'[1,1..`t']
		matrix colnames `b' = `fcolnames'
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
		local t1 = `t2'+1
		local t2 = `t2' + `ncuts'
		matrix `bcut' = `btmp'[1,`t1'..`t2']
		qui replace `xb' = `xb'*`scale' if `touse'
		qui replace `xbrese' = `xbrese'*`scale' if `touse'
		qui replace `xbresa' = `xbresa'*`scale' if `touse'

		tempname resavar  
		local scscale = `scale'^2	
		local kavar = colsof(`covaa')
		matrix `resavar' = `covaa'[1,1] -	/// 
			`covaa'[1,2..`kavar']*invsym(	///
			`covaa'[2..`kavar',2..`kavar'])*`covaa'[2..`kavar',1]
                local scresavar = `resavar'[1,1]

		qui gen double `storeresiduala' = .
		qui gen double `storeresiduale' = .
		local kcatm1 = `ncuts' 		
		forvalues i = 1/`kcatm1' {
			tempvar ddepvar0 ddepvar1
			qui gen `ddepvar0' = 0 if `touse' & ///
				`depvar'==`vals'[1,`i']
			qui gen `ddepvar1' = 0 if `touse' & ///
				`depvar'==`vals'[1,`i'+1]
			tempvar xbi
			qui gen `xbi' = `xb' - `bcut'[1,`i']*`scale' if ///
				(`touse' & (`depvar'==`vals'[1,`i'] |	///
				`depvar'==`vals'[1,`i'+1]))
			qui gsem (`ddepvar1' <- `xbi'@1 U[`panvar']@1) if ///
				(`touse' & (`depvar'==`vals'[1,`i'] | 	 ///
				`depvar'==`vals'[1,`i'+1])), noconstant  ///
				family(gaussian, udepvar(`ddepvar0')) 	 ///
				var(e.`ddepvar1'@`scscale') noestimate	 ///
				var(U[`panvar']@`scresavar') iter(50)
			tempvar ub
			qui predict double `ub' if (`touse' & ///
				`depvar'==`vals'[1,`i']), latent
			tempvar xbfull
			qui gen double `xbfull' = (`xb' + `ub')/`scale'	///
				if `touse' & `depvar'==`vals'[1,`i']
			qui replace `storeresiduala' = `xbresa' + `ub'	///
				if `touse' & `depvar'==`vals'[1,`i']
			qui replace `storeresiduale' = `xbrese'	+	///
				-`scale'*normalden(-`xbfull')/		///
				normal(-`xbfull') 			///
				if `touse' & `depvar'==`vals'[1,`i']
		}
		tempvar ub
		qui predict double `ub' if (`touse' & ///
			`depvar'==`vals'[1,`kcatm1'+1]), latent
		tempvar xbfull
		qui gen double `xbfull' = (`xb' + `ub')/`scale'	///
			if `touse' & `depvar'==`vals'[1,`kcatm1'+1]
		qui replace `storeresiduala' = `xbresa' + `ub'	///
			if `touse' & `depvar'==`vals'[1,`kcatm1'+1]
		qui replace `storeresiduale' = `xbrese'	+	///
			`scale'*normalden(`xbfull')/normal(`xbfull') ///
			if `touse' & `depvar'==`vals'[1,`kcatm1'+1]
		return matrix b = `b'	
		return matrix cov22 = `cov22'
		return matrix icov22 = `icov22'
		return matrix covaa = `covaa'
		return matrix icovaa = `icovaa'
		return scalar scale = `scale'		
		return matrix bcut = `bcut'
	}	
end
exit

