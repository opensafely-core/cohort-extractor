*! version 1.0.10  03feb2011
program define pperron, rclass
	version 6.0, missing
	syntax varname(ts) [if] [in] [, TRend noConstant Lags(int -1) REGress]

	if      "`constan'" != "" & "`trend'" == "" { local case 1 }
	else if "`constan'" == "" & "`trend'" == "" { local case 2 }
	else if "`constan'" == "" & "`trend'" != "" { local case 4 }
	else {
		noi di in red "cannot choose trend if constant is excluded"
		exit 198
	}

        marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

        local samp "if `touse'==1"


	quietly {
		local mac
		if `case' == 2 { local mac "c"  }
		if `case' == 4 { local mac "ct" }
		if "`trend'" != "" { 
			summ `tvar' `samp', meanonly
			local min = r(min)
			tempvar tt
			gen long `tt' = `tvar'-r(min) 
		}
		tempvar u gamu
		reg `varlist' L.`varlist' `tt' `samp', `constan' 
		predict double `u' if e(sample), resid
		local T   = e(N)
		local k   = e(df_m) 
		local s   = e(rmse) 
		if "`constan'" != "" { local k = `k' + 1 }
		local rho = _b[L.`varlist']
		local sig = _se[L.`varlist']
		
		if `lags' < 0 {
			local lags = int(4*(`T'/100)^(2/9))
		}
		gen double `gamu' = sum(`u'*`u')
		local gam0 = `gamu'[_N]/`T'
		local Zp0 = `T'*(`rho'-1)
		local Zt0 = (`rho'-1)/`sig'
		local lam = `gam0'
		local i 1
		while `i' <= `lags' {
			replace `gamu' = sum(`u'*L`i'.`u')
			local gam`i' = `gamu'[_N]/`T'
			local factor = 2*(1-`i'/(`lags'+1))
			local lam = `lam' + `factor'*`gam`i''
			local i = `i'+1
		}
		local Zp = `Zp0'-((`T'*`sig'/`s')^2)* /*
			*/ (`lam'-`gam0')/2
		local Zt = `Zt0'*sqrt(`gam0'/`lam') - /*
			*/ .5*(`lam'-`gam0')*(`T'*`sig'/`s')/sqrt(`lam')

		if "`mac'" != "" {
			MacP `mac' `Zt'
			local ztp = `r(pval)'
		}
		GetCrit `case' `T'
	}
	noi di in gr _n "Phillips-Perron test for unit root" /* 
		*/ _col(52) "Number of obs   = " in ye %9.0g `T'
	di in gr _col(52) "Newey-West lags = " in ye %9.0g `lags'
	di _n in smcl in gr _col(32) /*
		*/ "{hline 10} Interpolated Dickey-Fuller {hline 9}"
	di in gr _col (19) "Test" /*
		*/ _col(32)  "1% Critical" /*
		*/ _col(50)  "5% Critical" /*
		*/ _col(67) "10% Critical"
	di in gr _col (16) "Statistic" /*
		*/ _col(36)  "Value" /*
		*/ _col(54)  "Value" /*
		*/ _col(72) "Value"
	di in smcl in gr "{hline 78}"

	di in gr " Z(rho)" /*
		*/ _col(15) in ye %10.3f `Zp' /*
		*/ _col(33) %10.3f `r(Zp1)' /*
		*/ _col(51) %10.3f `r(Zp5)' /*
		*/ _col(69) %10.3f `r(Zp10)'

	di in gr " Z(t)" /*
		*/ _col(15) in ye %10.3f `Zt' /*
		*/ _col(33) %10.3f `r(Zt1)' /*
		*/ _col(51) %10.3f `r(Zt5)' /*
		*/ _col(69) %10.3f `r(Zt10)'

	if "`ztp'" != "" {
		di in smcl in gr "{hline 78}"
		di in gr "MacKinnon approximate p-value for Z(t) = " /*
			*/ in ye %6.4f `ztp'
		ret scalar pval   = `ztp'
		ret hidden scalar p = `ztp'		// double save
	}

	if "`regress'" != "" {
		di
		if "`tt'" != "" {
			DispReg `tt'
		}
		else {
			regress, nohead
		}
	}

	ret scalar Zt     = `Zt'
	ret scalar Zrho   = `Zp'
	ret scalar lags = `lags'
	ret scalar N      = `T'
end

program define GetCrit, rclass

	args case N

	tempname zp zt
	
	if `case' == 1 {
		mat `zp' = (-11.9,-12.9,-13.3,-13.6,-13.7,-13.8\  /*
			  */ -7.3, -7.7, -7.9, -8.0, -8.0, -8.1\  /*
			  */ -5.3, -5.5, -5.6, -5.7, -5.7, -5.7)

		mat `zt' = ( -2.66,-2.62,-2.60,-2.58,-2.58,-2.58\ /*
			  */ -1.95,-1.95,-1.95,-1.95,-1.95,-1.95\ /*
			  */ -1.60,-1.61,-1.61,-1.62,-1.62,-1.62)
	}
	else if `case' == 2 {
		mat `zp' = (-17.2,-18.9,-19.8,-20.3,-20.5,-20.7\  /*
			  */-12.5,-13.3,-13.7,-14.0,-14.0,-14.1\  /*
			  */-10.2,-10.7,-11.0,-11.2,-11.2,-11.3)

		mat `zt' = ( -3.75,-3.58,-3.51,-3.46,-3.44,-3.43\ /*
			  */ -3.00,-2.93,-2.89,-2.88,-2.87,-2.86\ /*
			  */ -2.63,-2.60,-2.58,-2.57,-2.57,-2.57)
	}
	else {
		mat `zp' = (-22.5,-25.7,-27.4,-28.4,-28.9,-29.5\  /*
			  */-17.9,-19.8,-20.7,-21.3,-21.5,-21.8\  /*
			  */-15.6,-16.8,-17.5,-18.0,-18.1,-18.3)

		mat `zt' = ( -4.38,-4.15,-4.04,-3.99,-3.98,-3.96\ /*
			  */ -3.60,-3.50,-3.45,-3.43,-3.42,-3.41\ /*
			  */ -3.24,-3.18,-3.15,-3.13,-3.13,-3.12)
	}

	if `N' <= 25 {
		local zp1  = `zp'[1,1] 
		local zp5  = `zp'[2,1]
		local zp10 = `zp'[3,1]
		local zt1  = `zt'[1,1] 
		local zt5  = `zt'[2,1]
		local zt10 = `zt'[3,1]
	}
	else if `N' <= 50 {
		local zp1  = `zp'[1,1] + (`N'-25)/25 * (`zp'[1,2]-`zp'[1,1])
		local zp5  = `zp'[2,1] + (`N'-25)/25 * (`zp'[2,2]-`zp'[2,1])
		local zp10 = `zp'[3,1] + (`N'-25)/25 * (`zp'[3,2]-`zp'[3,1])
		local zt1  = `zt'[1,1] + (`N'-25)/25 * (`zt'[1,2]-`zt'[1,1])
		local zt5  = `zt'[2,1] + (`N'-25)/25 * (`zt'[2,2]-`zt'[2,1])
		local zt10 = `zt'[3,1] + (`N'-25)/25 * (`zt'[3,2]-`zt'[3,1])
	}
	else if `N' <= 100 {
		local zp1  = `zp'[1,2] + (`N'-50)/50 * (`zp'[1,3]-`zp'[1,2])
		local zp5  = `zp'[2,2] + (`N'-50)/50 * (`zp'[2,3]-`zp'[2,2])
		local zp10 = `zp'[3,2] + (`N'-50)/50 * (`zp'[3,3]-`zp'[3,2])
		local zt1  = `zt'[1,2] + (`N'-50)/50 * (`zt'[1,3]-`zt'[1,2])
		local zt5  = `zt'[2,2] + (`N'-50)/50 * (`zt'[2,3]-`zt'[2,2])
		local zt10 = `zt'[3,2] + (`N'-50)/50 * (`zt'[3,3]-`zt'[3,2])
	}
	else if `N' <= 250 {
		local zp1  = `zp'[1,3] + (`N'-100)/150 * (`zp'[1,4]-`zp'[1,3])
		local zp5  = `zp'[2,3] + (`N'-100)/150 * (`zp'[2,4]-`zp'[2,3])
		local zp10 = `zp'[3,3] + (`N'-100)/150 * (`zp'[3,4]-`zp'[3,3])
		local zt1  = `zt'[1,3] + (`N'-100)/150 * (`zt'[1,4]-`zt'[1,3])
		local zt5  = `zt'[2,3] + (`N'-100)/150 * (`zt'[2,4]-`zt'[2,3])
		local zt10 = `zt'[3,3] + (`N'-100)/150 * (`zt'[3,4]-`zt'[3,3])
	}
	else if `N' <= 500 {
		local zp1  = `zp'[1,4] + (`N'-250)/250 * (`zp'[1,5]-`zp'[1,4])
		local zp5  = `zp'[2,4] + (`N'-250)/250 * (`zp'[2,5]-`zp'[2,4])
		local zp10 = `zp'[3,4] + (`N'-250)/250 * (`zp'[3,5]-`zp'[3,4])
		local zt1  = `zt'[1,4] + (`N'-250)/250 * (`zt'[1,5]-`zt'[1,4])
		local zt5  = `zt'[2,4] + (`N'-250)/250 * (`zt'[2,5]-`zt'[2,4])
		local zt10 = `zt'[3,4] + (`N'-250)/250 * (`zt'[3,5]-`zt'[3,4])
	}
	else {
		local zp1  = `zp'[1,6]
		local zp5  = `zp'[2,6]
		local zp10 = `zp'[3,6]
		local zt1  = `zt'[1,6]
		local zt5  = `zt'[2,6]
		local zt10 = `zt'[3,6]
	}
	return scalar Zp1  = `zp1'
	return scalar Zp5  = `zp5'
	return scalar Zp10 = `zp10'
	return scalar Zt1  = `zt1'
	return scalar Zt5  = `zt5'
	return scalar Zt10 = `zt10'
end


program define MacP, rclass
	args type tau

	local stype = lower("`type'")
	if "`stype'"=="c" { local type 0 }
	else              { local type 1 }

	local g3=0
        local min=.
	local max=.
        if `type'==0 { 
                if `tau'>-1.61 {
                        local min = -9999
                        local max = 2.74
                        local g0 = 1.7339
                        local g1 = 0.93202
                        local g2 = -0.12745
                        local g3 = -0.010368
                }
                else {
                        local min = -18.83
                        local g0 = 2.1659
                        local g1 = 1.4412
                        local g2 = 0.038269
                        local g3 = 0
                }
        } /* type==0 */
        else if `type'==1 { 
                if `tau'>-2.89 {
                        local min = -9999
                        local max = 0.70
                        local g0 = 2.5261
                        local g1 = 0.61654
                        local g2 = -0.37956
                        local g3 = -0.060285
                }
                else {
                        local min = -16.18
                        local g0 = 3.2512
                        local g1 = 1.6047
                        local g2 = 0.049588
                        local g3 = 0
                }
	}

	local h = `g0' + `g1'*`tau' + `g2'*(`tau')^2 + `g3'*(`tau')^3
	local p = cond(`tau'<`min',0,cond(`tau'>`max',1,normprob(`h')))
	return scalar pval = `p'
end


program define DispReg
	args tt
	di in smcl in gr "{hline 13}{c TT}{hline 64}"
	di in smcl in gr abbrev("`e(depvar)'",12) _col(14) "{c |}" /*
		*/ _col(21) "Coef." _col(29) "Std. Err." _col(44) "t" /*
		*/ _col(49) "P>|t|" _col(59) "[95% Conf. Interval]"
	di in smcl in gr "{hline 13}{c +}{hline 64}"
	di in smcl in gr %12s abbrev("`e(depvar)'",12) _col(14) "{c |}"
	local vv "L1.`e(depvar)'"
	local bv "_b[`vv']"
	local sv "_se[`vv']"
	di in smcl in gr _col(10) "L1. {c |}" in ye /*
		*/ _col(17) %9.0g `bv' /*
		*/ _col(28) %9.0g `sv' /*
		*/ _col(38) %8.2f `bv'/`sv' /*
		*/ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
		*/ _col(58) %9.0g `bv' - invt(`e(df_r)',$S_level/100)*`sv' /*
		*/ _col(70) %9.0g `bv' + invt(`e(df_r)',$S_level/100)*`sv' 
	local vv "`tt'"
	local bv "_b[`vv']"
	local sv "_se[`vv']"
	di in smcl in gr %12s "_trend" _col(14) "{c |}" in ye /*
		*/ _col(17) %9.0g `bv' /*
		*/ _col(28) %9.0g `sv' /*
		*/ _col(38) %8.2f `bv'/`sv' /*
		*/ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
		*/ _col(58) %9.0g `bv' - invt(`e(df_r)',$S_level/100)*`sv' /*
		*/ _col(70) %9.0g `bv' + invt(`e(df_r)',$S_level/100)*`sv' 
	local vv "_cons"
	local bv "_b[`vv']"
	local sv "_se[`vv']"
	di in smcl in gr %12s "_cons" _col(14) "{c |}" in ye /*
		*/ _col(17) %9.0g `bv' /*
		*/ _col(28) %9.0g `sv' /*
		*/ _col(38) %8.2f `bv'/`sv' /*
		*/ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
		*/ _col(58) %9.0g `bv' - invt(`e(df_r)',$S_level/100)*`sv' /*
		*/ _col(70) %9.0g `bv' + invt(`e(df_r)',$S_level/100)*`sv' 
	di in smcl in gr "{hline 13}{c BT}{hline 64}"
end
