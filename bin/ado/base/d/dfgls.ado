*! version 1.1.1  11mar2016
program define dfgls, rclass sortpreserve
	version 8

	syntax varname(ts) [if] [in] [ , 		/*
		*/ Maxlag(numlist integer >=0 max=1) 	/*
		*/ GENerate(string) noTrend ERS]  

	local resflag 0
	local generat = cond("`generate'" == "", "", "`generate'") 

    	if "`generat'" != "" {
        	capture confirm new variable `generat' 
	        if _rc { 
        	        di as err "`generat' already exists: " _c  
                	di as err "specify new variable with generate( ) option"
	                exit 110 
        	}
		local resflag 1
        }

   	marksample touse
			/* get time variables */
	_ts timevar panelvar `if' `in', sort onepanel
	markout `touse' `timevar'
	tsreport if `touse', report
	if r(N_gaps) {
		di as err "sample may not contain gaps"
		exit 498
	}


	tempvar trd y iota qdtrd dty yhat 
	tempname nobs cbar alpha vcv cv stat i rzt1 rzt5 rzt10 first count kmax
	tempname resp10 resp5 ldty2 sldty2 tau t2 alpha tprob dft0b armse
	tempname sci dfti bSC results maici row
		
	if "`trend'"=="notrend" {
		local trend 0
		local stat "mu"
	}
	else {
		local trend 1
		local stat "tau"
	}

	gen  double `count'=sum(`touse')
	local nobs=`count'[_N]


	if `nobs' == 0 {
		di as err "no observations"
		exit 2000
	}	


	if "`maxlag'" != "" {
		local kmax ""
	}	
	else {
					/* set maxlag via Schwert criterion 
					(Ng/Perron JASA 1995) */

		local maxlag = int(12*(`nobs'/100)^0.25)
		local kmax = "Maxlag = `maxlag' chosen by Schwert criterion" 
	}

					/* cbars appropriate for trended, 
					detrended case */

	if `trend' {
		gen double `trd' = _n
		local cbar -13.5
	}
	else {
		local cbar -7.0
	}	

	scalar `alpha' = 1+`cbar'/`nobs'

	qui {
		gen double `y' = `varlist' if `count'==1
		gen double `iota' = 1 if `count'==1
		if `trend' {
			gen double `qdtrd' = `trd' if `count'==1
		}
		replace `y' = `varlist'-`alpha'*L.`varlist' if `count'>1
		replace `iota' = 1-`alpha' if `count'>1
		if `trend' {
			replace `qdtrd' = `trd'-`alpha'*L.`trd' if `count'>1
		}

/*		
run the GLS regression to detrend (or demean) the data via quasi-differencing
run over all available observations by relocating additional markout below
*/

		if `trend' {
			qui reg  `y' `iota' `qdtrd' if `touse', noc
		}
		else {
			qui reg `y' `iota' if `touse', noc
		}
/* correct for missing initial obs */

		gen byte `t2' = 1 if `touse'
		markout `touse' L(1/`maxlag').`t2'

/* generate OLS residual, not GLS residual, which becomes object of 
	(A)DF regression
*/

		if `trend' {
			gen double `dty'=`varlist'-_b[`iota']-_b[`qdtrd']*`trd'
		}
		else {
			gen double `dty'=`varlist'-_b[`iota']
		}

/* sldty2 is used in the calculation of MAIC below
* See p. 8 in Ng & Perron (2000).
*/

		gen double `ldty2' = (L.`dty')^2 if `touse'
		qui summarize `ldty2' if `touse',meanonly 
		local sldty2 = r(sum)
		if `trend' { 
			GetCritE `nobs' 
		}
		else { 
			GetCritD `nobs'
		}
		local rzt1=r(Zt1)
		local rzt5=r(Zt5)
		local rzt10=r(Zt10)
	}
	
/* markout one more to account for lag of delta */

	local maxl1 = `maxlag'+1
	markout `touse' L(1/`maxl1').`t2'
	qui summarize D.`dty' if `touse',meanonly 
	local nobs=r(N)

	local sname = abbrev("`varlist'", 16)
	di " "
	di as txt "DF-GLS for " as res "`sname'" _col(58) /*
		*/ as txt "Number of obs = " as res %5.0f `nobs' 
	if "`kmax'" !="" {
		di as txt "Maxlag = " as res `maxlag' /*
			*/ as txt " chosen by Schwert criterion" 
	}
	di " "
	local first 1
        if `maxlag' == 0 {
/* run the DF regression, no constant nor trend */
		qui reg D.`dty' L.`dty' if `touse', noc
		if `resflag' {
			qui predict double `generat',r
		}
		mat `vcv'=e(V)
		return scalar dft0=_b[L.`dty']/sqrt(`vcv'[1,1])
		return scalar rmse0=sqrt(e(rss)/`nobs')
		if `trend' { 
			GetCritT `nobs' `maxlag' 
		}
		else { 
			GetCritM `nobs' `maxlag' 
		}
		local resp5=r(resp5)
		local resp10=r(resp10)
		if "`ers'"=="ers" { 
			Out `stat' `first' 0 `return(dft0)' `rzt1' /*
				*/ `rzt5' `rzt10'
		}
		else { 
			Out `stat' `first' 0 `return(dft0)' `rzt1' /*
				*/ `resp5' `resp10'
		}
		exit
       	}
        else { 
/* loop over lags 1..maxlag */
		local i = `maxlag'
		local first 1
		local bRMSE .
		local lOpt = -1
		scalar `bSC' = .
		local bmaic .
		local ri = 0
		local rlSC = .
		local rlmaic = .
		while `i'>0 {
			local ri = `ri' + 1
/* run the ADF regression, no constant nor trend */
			qui reg D.`dty' L.`dty' DL(1/`i').`dty' /*
				*/ if `touse', noc
			if `resflag' {
				qui predict double `generat',r
				local resflag 0
			}
			mat `vcv'=e(V)
			local col=e(df_m)
			scalar `dfti'=_b[L.`dty']/sqrt(`vcv'[1,1])
			
			scalar `armse'=sqrt(e(rss)/`nobs')

			qui test DL`i'.`dty'
			scalar `tprob' = r(p)
			if `tprob'<0.10 & `lOpt'==-1 {
				local lOpt = `i'
				local bRMSE = `armse'
			}
/* Calculate SC */
			scalar `sci'=log((`armse')^2)  /*
				*/ + (`i'+1)*log(`nobs')/`nobs'
			local rlSC = cond(`sci'<`bSC',`ri',`rlSC')
			scalar `bSC' = min(`bSC',`sci')

/* Calculate MAIC, but first calculate tau variable */
/* See p. 8 in Ng & Perron (2000) */

			local tau = (`armse'^2)^(-1)/* 
				*/ *(_b[L.`dty'])^2*`sldty2'
			scalar `maici'=log(`armse'^2)/* 
				*/ +2*(`tau'+`i')/`nobs'
			local rlmaic = cond(`maici'<`bmaic',`ri',`rlmaic')
			local bmaic = min(`bmaic',`maici')
			mat `row' = (`i', `maici', `sci', `armse', `dfti' ) 
			mat `results' = (nullmat(`results') \ `row'  )
			if `trend' { 
				GetCritT `nobs' `i' 
			}
			else { 
				GetCritM `nobs' `i' 
			}
			local resp5=r(resp5)
			local resp10=r(resp10)
			if "`ers'"=="ers" { 
				Out `stat' `first' `i' `dfti' /*
					*/ `rzt1' `rzt5' `rzt10'
			}
			else { 
				Out `stat' `first' `i' `dfti' /*
					*/ `rzt1' `resp5' `resp10'
			}
			local i = `i' - 1
			local first 0
		}
		if `maxlag' > 1 {
			return scalar optlag = `lOpt'
			di " "
			if  `lOpt' !=-1 {
				di as txt "Opt Lag (Ng-Perron seq t) = " /*
					*/as res %2.0f `lOpt' _col(22) /*
					*/as txt " with RMSE " /*
					*/ as res %9.0g `bRMSE'
			}
			else {
				di as txt "Opt Lag (Ng-Perron seq t) = 0" /*
					*/ as res " [use maxlag(0)]"
			}
			di as txt "Min SC   = " as res /*
				*/ %9.0g `results'[`rlSC',3] /*
				*/ as txt " at lag " as res %2.0f /*
				*/ `results'[`rlSC',1] as txt " with RMSE " /*
				*/as res %9.0g `results'[`rlSC',4]
			di as txt "Min MAIC = " as res /*
				*/ %9.0g `results'[`rlmaic',2] /*
				*/as txt " at lag " %2.0f /*
				*/ as res `results'[`rlmaic',1] /*
				*/ as txt " with RMSE " /*
				*/ as res %9.0g `results'[`rlmaic',4]
			return scalar maiclag =  `results'[`rlmaic',1]
			return scalar sclag = `results'[`rlSC',1] 
		}
	}
	return scalar N =`nobs'
	return scalar maxlag = `maxlag'
	mat colnames `results' = k MAIC SIC RMSE DFGLS 
	return matrix results `results'
end

program define Out, nclass
	args stat first lags dft rzt1 rzt5 rzt10
	if (`first') {
		di as txt  _col (16) "DF-GLS `stat'" /*
        		*/ _col(32)  "1% Critical"  _col(50)  "5% Critical" /*
        		*/ _col(67) "10% Critical"
        	di as txt "  [lags]" _col (14) "Test Statistic" /*
        		*/ _col(36)  "Value" _col(54)  "Value" _col(72) "Value"
        	di as txt "{hline 78}"
	}
        di as txt _col(5) "`lags'" /*
        	*/ _col(14) as res %10.3f `dft'  _col(31) %10.3f `rzt1' /*
        	*/ _col(49) %10.3f `rzt5'  _col(67) %10.3f `rzt10'
end 
        	       
program define GetCritE, rclass
/* interp values from Elliott et al, Econometrica 64:4 1996 Table 1c */
        args N
	tempname zt
                mat `zt' = ( -3.77,-3.58,-3.46,-3.48\ /*
                          */ -3.19,-3.03,-2.93,-2.89\ /*
                          */ -2.89,-2.74,-2.64,-2.57)

        if `N' <= 50 {
                local zt1  = `zt'[1,1] 
                local zt5  = `zt'[2,1]
                local zt10 = `zt'[3,1]
        }
        else if `N' <= 100 {
                local zt1  = `zt'[1,1] + (`N'-50)/50 * (`zt'[1,2]-`zt'[1,1])
                local zt5  = `zt'[2,1] + (`N'-50)/50 * (`zt'[2,2]-`zt'[2,1])
                local zt10 = `zt'[3,1] + (`N'-50)/50 * (`zt'[3,2]-`zt'[3,1])
        }
        else if `N' <= 200 {
                local zt1  = `zt'[1,2] + (`N'-100)/100 * (`zt'[1,3]-`zt'[1,2])
                local zt5  = `zt'[2,2] + (`N'-100)/100 * (`zt'[2,3]-`zt'[2,2])
                local zt10 = `zt'[3,2] + (`N'-100)/100 * (`zt'[3,3]-`zt'[3,2])
        }
        else {
                local zt1  = `zt'[1,4]
                local zt5  = `zt'[2,4]
                local zt10 = `zt'[3,4]
        }
        return scalar Zt1  = `zt1'
        return scalar Zt5  = `zt5'
        return scalar Zt10 = `zt10'
end

program define GetCritD, rclass
/* from dfuller.ado */
        args N
	tempname zt
                mat `zt' = ( -2.66,-2.62,-2.60,-2.58,-2.58,-2.58\ /*
                          */ -1.95,-1.95,-1.95,-1.95,-1.95,-1.95\ /*
                          */ -1.60,-1.61,-1.61,-1.62,-1.62,-1.62)

        if `N' <= 25 {
                local zt1  = `zt'[1,1] 
                local zt5  = `zt'[2,1]
                local zt10 = `zt'[3,1]
        }
        else if `N' <= 50 {
                local zt1  = `zt'[1,1] + (`N'-25)/25 * (`zt'[1,2]-`zt'[1,1])
                local zt5  = `zt'[2,1] + (`N'-25)/25 * (`zt'[2,2]-`zt'[2,1])
                local zt10 = `zt'[3,1] + (`N'-25)/25 * (`zt'[3,2]-`zt'[3,1])
        }
        else if `N' <= 100 {
                local zt1  = `zt'[1,2] + (`N'-50)/50 * (`zt'[1,3]-`zt'[1,2])
                local zt5  = `zt'[2,2] + (`N'-50)/50 * (`zt'[2,3]-`zt'[2,2])
                local zt10 = `zt'[3,2] + (`N'-50)/50 * (`zt'[3,3]-`zt'[3,2])
        }
        else if `N' <= 250 {
                local zt1  = `zt'[1,3] + (`N'-100)/150 * (`zt'[1,4]-`zt'[1,3])
                local zt5  = `zt'[2,3] + (`N'-100)/150 * (`zt'[2,4]-`zt'[2,3])
                local zt10 = `zt'[3,3] + (`N'-100)/150 * (`zt'[3,4]-`zt'[3,3])
        }
        else if `N' <= 500 {
                local zt1  = `zt'[1,4] + (`N'-250)/250 * (`zt'[1,5]-`zt'[1,4])
                local zt5  = `zt'[2,4] + (`N'-250)/250 * (`zt'[2,5]-`zt'[2,4])
                local zt10 = `zt'[3,4] + (`N'-250)/250 * (`zt'[3,5]-`zt'[3,4])
        }
        else {
                local zt1  = `zt'[1,6]
                local zt5  = `zt'[2,6]
                local zt10 = `zt'[3,6]
        }
        return scalar Zt1  = `zt1'
        return scalar Zt5  = `zt5'
        return scalar Zt10 = `zt10'
end
program define GetCritM, rclass
/* response surface values from Cheung and Lai OBES 1995 Table 1, cols 1-2 */
	args N p
	tempname rsm
	mat `rsm' = ( -1.624, -19.888, 155.231, 0.709, 5.480, -16.055 \ /*
		*/    -1.948, -17.839, 104.086, 0.802, 5.558, -18.332 )
	
	local n1 = 1.0/`N'
	local pt = `p'/`N'
	local cr10 = `rsm'[1,1] + `rsm'[1,2]*`n1' + `rsm'[1,3]*(`n1'^2) + /*
		*/ `rsm'[1,4]*`pt' + `rsm'[1,5]*(`pt'^2) + `rsm'[1,6]*(`pt'^3)
	local cr05 = `rsm'[2,1] + `rsm'[2,2]*`n1' + `rsm'[2,3]*(`n1'^2) + /*
		*/ `rsm'[2,4]*`pt' + `rsm'[2,5]*(`pt'^2) + `rsm'[2,6]*(`pt'^3)
	return scalar resp10 = `cr10'
	return scalar resp5 = `cr05'
end
program define GetCritT, rclass
/* response surface values from Cheung and Lai OBES 1995 Table 1, cols 3-4 */
	args N p
	tempname rst
	mat `rst' = ( -2.550, -20.166, 155.215, 1.133, 9.808, -20.313 \ /*
		*/    -2.838, -20.328, 124.191, 1.267, 10.530, -24.600 )
	
	local n1 = 1.0/`N'
	local pt = `p'/`N'
	local cr10 = `rst'[1,1] + `rst'[1,2]*`n1' + `rst'[1,3]*(`n1'^2) + /*
		*/ `rst'[1,4]*`pt' + `rst'[1,5]*(`pt'^2) + `rst'[1,6]*(`pt'^3)
	local cr05 = `rst'[2,1] + `rst'[2,2]*`n1' + `rst'[2,3]*(`n1'^2) + /*
		*/ `rst'[2,4]*`pt' + `rst'[2,5]*(`pt'^2) + `rst'[2,6]*(`pt'^3)
	return scalar resp10 = `cr10'
	return scalar resp5 = `cr05'
end
