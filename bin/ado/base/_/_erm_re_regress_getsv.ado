*! version 1.0.1  10dec2019
program _erm_re_regress_getsv, rclass sortpreserve
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

	tempname b btmp covaa cov22 icovaa icov22
	gettoken depvar rvarlist: varlist

	if "`residualse'" == "" {
		qui gsem (`depvar' <-`rvarlist' U[`panvar']@1,	///
			`offset' `constant') if `touse', nocapslatent ///
                        latent(U) iter(50)
		matrix `btmp' = e(b)
		local tfcolnames: colfullnames `btmp'
		local k = e(k)
		if "`constant'" == "noconstant" {
			local j = `k'-4
			matrix `b' = `btmp'[1,1..`j']
			matrix `covaa' = `btmp'[1,`k'-1]
			local fcolnames
			forvalues i = 1/`j' {
				local w: word `i' of `tfcolnames'
				local fcolnames `fcolnames' `w'
			}
			matrix colnames `b' = `fcolnames'
		}
		else {
			local j = `k'-4
			matrix `b' = `btmp'[1,1..`j'],`btmp'[1,`k'-2]	
			matrix `covaa' = `btmp'[1,`k'-1]	
			local fcolnames
			forvalues i = 1/`j' {
				local w: word `i' of `tfcolnames'
				local fcolnames `fcolnames' `w'
			}
			local jb = `k'-2
			local w: word `jb' of `tfcolnames'
			local fcolnames `fcolnames' `w'
			matrix colnames `b' = `fcolnames'
		}
		matrix `icovaa' = 1/`covaa'[1,1]
		matrix `cov22'	= `btmp'[1,`k']
		matrix `icov22' = 1/`cov22'[1,1]
		tempvar xb
		qui predict double `xb', conditional(fixedonly)
		qui predict double `storeresiduala', latent
		qui gen double `storeresiduale' = `depvar' - `xb' ///
			- `storeresiduala' if `touse'
		local scale 1
	}
	else {
		local nresidualsa: word count `residualsa'
		local nresidualse: word count `residualse'
		qui xtintreg `depvar' `depvar' `rvarlist' `residualsa'	///
			`residualse' if `touse', `offset' `constant' iter(50)
		tempname sigma_u sigma_e
		scalar `sigma_u' = e(sigma_u)
		scalar `sigma_e' = e(sigma_e)
		tempname ob
		matrix `ob' = e(b)
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
			local t2 = colsof(`ob')-`nresidualsa'-`nresidualse'-1-2
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
		tempname xb
		matrix score double `xb' = `b' if `touse'
		tempvar resid
		qui gen double `resid' = `depvar' - `xb'
		tempvar order
		gen `order'= _n
		sort `panvar' `order', stable
		qui by `panvar': egen double `storeresiduala' = ///
			mean(`resid') if `touse'
		qui gen double `storeresiduale' = ///
			`resid' - `storeresiduala' if `touse'
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
			tempname sa
			matrix `sa' = J(1,1,.)
			matrix `sa'[1,1] = `sigma_u'
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
			tempname se
			matrix `se' = J(1,1,.)
			matrix `se'[1,1] = `sigma_e'
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
	}

	return matrix b = `b'	
	return matrix cov22 = `cov22'
	return matrix icov22 = `icov22'
	return matrix covaa = `covaa'
	return matrix icovaa = `icovaa'	
end
exit
