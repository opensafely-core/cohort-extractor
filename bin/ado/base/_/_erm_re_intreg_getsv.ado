*! version 1.0.1  12dec2019
program _erm_re_intreg_getsv, rclass
	version 16
	syntax varlist(numeric fv ts) [pw iw fw], [	///
		ll(string)				///
		ul(string)				///
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
		storeresiduala(string) panvar(string) depvarname(string)]

	tempname b btmp covaa cov22 icovaa icov22 xb ub constry
	if "`residualse'" == "" {
		qui xtintreg `ll' `ul' `varlist' if `touse', ///
			`offset' `constant' iter(50)
		matrix `btmp' = e(b)
		local tfcolnames: colfullnames `btmp'
		local t1 = 1
		local t2 = colsof(`btmp')-2
		matrix `b' = `btmp'[1,`t1'..`t2']
		local fcolnames
		forvalues i=1/`t2' {
			local w: word `i' of `tfcolnames'
			local fcolnames `fcolnames' `w'
		}
		matrix colnames `b' = `fcolnames'		
		matrix `covaa' = ((`btmp'[1,`t2'+1])^2)
		matrix `icovaa' = 1/`covaa'[1,1]
		matrix `cov22' = ((`btmp'[1,`t2'+2])^2)
		matrix `icov22' = 1/`cov22'[1,1]
		qui predict double `xb' if `touse'
		local there22 = `cov22'[1,1]
		local thereaa = `covaa'[1,1]		
		qui gsem (`ll' <-`xb'@1 U[`panvar']@1,		///
			`offset' family(gaussian,		///
			udepvar(`ul'))) if `touse', 		///
			noconstant nocapslatent latent(U)	///
			var(e.`ll'@`there22')			///
			var(U[`panvar']@`thereaa') noestimate
		qui predict double `storeresiduala', latent
		tempname scale
		scalar `scale' = sqrt(`there22')
		qui gen double `storeresiduale' = `ll' - `xb' - ///
			`storeresiduala'	/// 
			if ~missing(`ll') & ~missing(`ul') & (		///
				`ll'==`ul')	
		local lower ((`ll'-`xb'-`storeresiduala')/`scale')
		qui replace `storeresiduale' = 0 + 	///
			`scale'*normalden(`lower')/		///
			normal(-`lower')			///
			if missing(`ul') & ~missing(`ll')
		local upper ((`ul'-`xb'-`storeresiduala')/`scale')
		qui replace `storeresiduale' = 0 +		///
			-`scale'*normalden(`upper')/		///
			normal(`upper')				///
			if missing(`ll') & ~missing(`ul')
		qui replace `storeresiduale' = 0 +		///
			`scale'*(				///
				normalden(`lower')-		///
				normalden(`upper'))/		///
				(normal(`upper')-		///	
				normal(`lower'))		///
			if ~missing(`ll') & ~missing(`ul') & (	///
				`ll' != `ul')			
	}
	else {
		local nresidualsa: word count `residualsa'
		local nresidualse: word count `residualse'
		qui xtintreg `ll' `ul' `varlist' `residualsa'	///
			`residualse' if `touse', `offset' `constant'
		tempname ob
		matrix `ob' = e(b)
		qui predict double `xb'
		qui gen double `storeresiduala' = 0
		foreach var of varlist `residualsa' {
			qui replace `storeresiduala' = ///
				`storeresiduala' + _b[`var']*`var' if `touse'
		}
		qui gen double `storeresiduale' = 0
		foreach var of varlist `residualse' {
			qui replace `storeresiduale' = ///
				`storeresiduale' + _b[`var']*`var' if `touse'
		}
		local tfcolnames: colfullnames `ob'
		if "`constant'" == "noconstant" {
			local t1 = 1
			local t2 = colsof(`ob')-`nresidualsa'-`nresidualse'-2
			matrix `b' = `ob'[1,`t1'..`t2']
			local fcolnames
			forvalues i=1/`t2' {
				local w: word `i' of `tfcolnames'
				local fcolnames `fcolnames' `w'
			}
			matrix colnames `b' = `fcolnames'
		}
		else {
			local t1 = 1
			local t2 = colsof(`ob')-`nresidualsa'-`nresidualse'-3
			matrix `b' = `ob'[1,`t1'..`t2']
			matrix `b' = `b',(`ob'[1,colsof(`ob')-2])
			local fcolnames	
			forvalues i=1/`t2' {
				local w: word `i' of `tfcolnames'
				local fcolnames `fcolnames' `w'
			}
			local kob = colsof(`ob')-2
			local w: word `kob' of `tfcolnames'
			local fcolnames `fcolnames' `w'
			matrix colnames `b' = `fcolnames'
		}
		if "`constant'" == "noconstant" {
			local t1 = colsof(`ob')-`nresidualsa'-`nresidualse'+1-2
		}
		else {
			local t1 =  colsof(`ob')-`nresidualsa'-`nresidualse'-2
		}
		local t2 = `t1' + `nresidualsa'-1
		tempname ora 
		matrix `ora' = `ob'[1,`t1'..`t2']
		local t1 = `t2'+1
		local t2 = `t1' + `nresidualse'-1
		tempname ore
		matrix `ore' = `ob'[1,`t1'..`t2']
		if `nresidualsa' == 1 {
			tempname vara cova
			scalar `vara' = e(sigma_u)
			scalar `cova' = `ora'[1,1]*`sigmaa'[1,1]
			matrix `covaa' = 				///
				(`vara'^2+(`cova'^2)*`isigmaa'[1,1],	///
				`cova' \ `cova',`sigmaa'[1,1])
                        mata : st_local("ispsd", ///
                               strofreal(__ispsd(st_matrix("`covaa'"))))
                        if !`ispsd' {
                                mata : st_matrix("`covaa'",               ///
                                       __MakePSD(st_matrix("`covaa'"),    ///
                                       epsilon(20)))
                        }
			matrix `icovaa' = invsym(`covaa')
			tempname vare cove
			scalar `vare' = e(sigma_e)
			scalar `cove' = `ore'[1,1]*`sigma22'[1,1]
			matrix `cov22' = 				///
				(`vare'^2+(`cove'^2)*`isigma22'[1,1],	///
				`cove' \ `cove',`sigma22'[1,1])
                        mata : st_local("ispsd", ///
                               strofreal(__ispsd(st_matrix("`cov22'"))))
                        if !`ispsd' {
                                mata : st_matrix("`cov22'",               ///
                                       __MakePSD(st_matrix("`cov22'"),    ///
                                       epsilon(20)))
                        }
			matrix `icov22' = invsym(`cov22')
		}
		else  {
			tempname sa
			matrix `sa' = J(1,1,.)
			matrix `sa'[1,1] = e(sigma_u)
			tempname se
			matrix `se' = J(1,1,.)
			matrix `se'[1,1] = e(sigma_e)
			local np = `nresidualsa'
			tempvar temp
			qui gen `temp' = 0 in 1/`np'
			qui replace `temp' = 1 in 1
			qui nl erm_get_cov_regress @`temp',	///
				isigma22(`isigmaa') 		///
				sigma22(`sigmaa') 		///
				originaleb(`ora')		/// 	
				nparameters(`nresidualsa')
			matrix `covaa' = e(b)
			matrix `sa'[1,1] = `sa'[1,1]^2
			matrix `sa' = `sa' + `covaa'*`isigmaa'*(`covaa'')
			matrix `covaa' = (`sa'[1,1],`covaa' \ `covaa'',`sigmaa')
                        mata : st_local("ispsd", ///
                               strofreal(__ispsd(st_matrix("`covaa'"))))
                        if !`ispsd' {
                                mata : st_matrix("`covaa'",               ///
                                       __MakePSD(st_matrix("`covaa'"),    ///
                                       epsilon(20)))
                        }
			matrix `icovaa' = invsym(`covaa')
			replace `temp' = 0 in 1/`np'
			qui replace `temp' = 1 in 1
			qui nl erm_get_cov_regress @`temp',	///
				isigma22(`isigma22')		///
				sigma22(`sigma22') 		///
				originaleb(`ore')		/// 	
				nparameters(`nresidualse')
			matrix `cov22' = e(b)
			matrix `se'[1,1] = `se'[1,1]^2
			matrix `se' = `se' + `cov22'*`isigma22'*(`cov22'')
			matrix `cov22' = (`se'[1,1],`cov22' \ ///
				`cov22'',`sigma22')
                        mata : st_local("ispsd", ///
                               strofreal(__ispsd(st_matrix("`cov22'"))))
                        if !`ispsd' {
                                mata : st_matrix("`cov22'",               ///
                                       __MakePSD(st_matrix("`cov22'"),    ///
                                       epsilon(20)))
                        }
			matrix `icov22' = invsym(`cov22')
		}
		local there22 = `cov22'[1,1]
		local thereaa = `covaa'[1,1]		
		qui gsem (`ll' <-`xb'@1 U[`panvar']@1,		///
			`offset' family(gaussian,		///
			udepvar(`ul'))) if `touse', 		///
			noconstant nocapslatent latent(U)	///
			var(e.`ll'@`there22')			///
			var(U[`panvar']@`thereaa') noestimate
		tempvar sta
		qui predict double `sta', latent
		qui replace `storeresiduala' = ///
			`storeresiduala' + `sta' if `touse'


		tempname scale
		scalar `scale' = sqrt(`there22')
		qui replace `storeresiduale' = `storeresiduale' + 	///
			`ll' - `xb' - `sta'				/// 
			if ~missing(`ll') & ~missing(`ul') & (		///
				`ll'==`ul')	
		local lower ((`ll'-`xb'-`sta')/`scale')
		qui replace `storeresiduale' = `storeresiduale' + ///
			`scale'*normalden(`lower')/		///
			normal(-`lower')			///
			if missing(`ul') & ~missing(`ll')
		local upper ((`ul'-`xb'-`sta')/`scale')
		qui replace `storeresiduale' = `storeresiduale' +	///
			-`scale'*normalden(`upper')/		///
			normal(`upper')				///
			if missing(`ll') & ~missing(`ul')
		qui replace `storeresiduale' = `storeresiduale' +	///
			`scale'*(				///
				normalden(`lower')-		///
				normalden(`upper'))/		///
				(normal(`upper')-		///	
				normal(`lower'))		///
			if ~missing(`ll') & ~missing(`ul') & (	///
				`ll' != `ul')	
	}

	matrix coleq `b' = `depvarname'
	return matrix b = `b'
	return matrix cov22 = `cov22'
	return matrix icov22 = `icov22'
	return matrix covaa = `covaa'
	return matrix icovaa = `icovaa'	
end
exit
