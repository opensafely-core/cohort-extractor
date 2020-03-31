*! version 1.3.0  10oct2017
program define dfuller, rclass
	version 6.0, missing
	syntax varname(ts) [if] [in] [, TRend noCONstant /*
		*/ DRift Lags(int -1) REGress /*
		*/ CERTIFY ]

	/* certify is an undocumented option that keeps the
	   dickey-fuller regression results lying around for
	   certification purposes 
	*/
	if "`drift'" != "" {
		if "`constan'" != "" {
noi di as error "cannot specify drift if constant is excluded" 
			exit 198
		}
		if "`trend'" != "" {
noi di as error "cannot specify drift if time trend is included"
			exit 198
		}
	}
		
	if      "`constan'" != "" & "`trend'" == "" { local case 1 }
	else if "`constan'" == "" & "`trend'" == "" & "`drift'" == "" { 
		local case 2 
	}
	else if "`constan'" == "" & "`trend'" == "" & "`drift'" != "" {
		local case 3
	} 	
	else if "`constan'" == "" & "`trend'" != "" { local case 4 }
	else {
		noi di in red "cannot choose trend if constant is excluded"
		exit 198
	}

        marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'
        local samp "if `touse'==1"

	tempname usrest
	// may not be e-class() stuff lying around, so capture this
	if "`certify'" == "" {
		version 10: _estimates hold `usrest', copy restore nullok
	}
	quietly {
		if `lags' < 0 { local lags 0 }
		local mac
		if `case' == 2 { local mac "c"  }
		if `case' == 4 { local mac "ct" }
                if "`trend'" != "" {
                        summ `tvar' `samp', meanonly
                        local min = r(min)
                        tempvar tt
                        gen long `tt' = `tvar'-r(min)
                }
		if `lags' == 0 {
			reg D.`varlist' L.`varlist' `tt' `samp', `constan' 
		}
		else {
			reg D.`varlist' L.`varlist' DL(1/`lags').`varlist' /*
				*/ `tt' `samp', `constan' 
			local aug "Augmented "
		}
		local T = e(N)
		local n = e(N) - e(df_r)
		local Zt = _b[L.`varlist'] / _se[L.`varlist']

		if "`mac'" != "" {
			MacP `mac' `Zt'
			local ztp = `r(p)'
		}
		if `case' == 3 {
			local ztp = 1 - ttail(e(df_r), `Zt')
		}
		
		GetCrit `case' `T' `varname'
	}
	noi di in gr _n "`aug'Dickey-Fuller test for unit root" /* 
		*/ _col(52) "Number of obs   = " in ye %9.0g `T'
	if `case' == 3 {
		di _n in smcl as text _col(32) /*
			*/ "{hline 11} Z(t) has t-distribution {hline 11}"
	}
	else {
		di _n in smcl in gr _col(32) /*
			*/ "{hline 10} Interpolated Dickey-Fuller {hline 9}"
	}
	di in gr _col (19) "Test" /*
		*/ _col(32)  "1% Critical" /*
		*/ _col(50)  "5% Critical" /*
		*/ _col(67) "10% Critical"
	di in gr _col (16) "Statistic" /*
		*/ _col(36)  "Value" /*
		*/ _col(54)  "Value" /*
		*/ _col(72) "Value"
	di in gr in smcl "{hline 78}"

	di in gr " Z(t)" /*
		*/ _col(15) in ye %10.3f `Zt' /*
		*/ _col(33) %10.3f `r(Zt1)' /*
		*/ _col(51) %10.3f `r(Zt5)' /*
		*/ _col(69) %10.3f `r(Zt10)'
	ret scalar cv10 = `r(Zt10)'
	ret scalar cv5  = `r(Zt5)'
	ret scalar cv1  = `r(Zt1)'
	if `case' == 3 {
		di as text in smcl "{hline 78}"
		di as text "p-value for Z(t) = " as res %6.4f `ztp'
		ret scalar p = `ztp'
	}
	else if "`ztp'" != "" {
		di in gr in smcl "{hline 78}"
		di in gr "MacKinnon approximate p-value for Z(t) = " /*
			*/ in ye %6.4f `ztp'
		ret scalar p   = `ztp'
	}

        if "`regress'" != "" {
                di
                if "`tt'" != "" {
                        DispReg `tt' `lags' `varlist'
                }
                else {
                        regress, nohead
                }
        }

	ret scalar Zt     = `Zt'
	ret scalar N      = `T'
	ret scalar lags   = `lags'
end

program define GetCrit, rclass

	args case N varlist

	/* Take care of case 3 first, since easiest */
	if `case' == 3 {
		local zt1 = invttail(e(df_r), 0.99)
		local zt5 = invttail(e(df_r), 0.95)
		local zt10 = invttail(e(df_r), 0.90)
		return scalar Zt1  = `zt1'
		return scalar Zt5  = `zt5'
		return scalar Zt10 = `zt10'
		exit
        }        		
		

	tempname zt
	
	if `case' == 1 {
		mat `zt' = ( -2.66,-2.62,-2.60,-2.58,-2.58,-2.58\ /*
			  */ -1.95,-1.95,-1.95,-1.95,-1.95,-1.95\ /*
			  */ -1.60,-1.61,-1.61,-1.62,-1.62,-1.62)
	}
	else if `case' == 2 {
		mat `zt' = ( -3.75,-3.58,-3.51,-3.46,-3.44,-3.43\ /*
			  */ -3.00,-2.93,-2.89,-2.88,-2.87,-2.86\ /*
			  */ -2.63,-2.60,-2.58,-2.57,-2.57,-2.57)
	}
	else {
		mat `zt' = ( -4.38,-4.15,-4.04,-3.99,-3.98,-3.96\ /*
			  */ -3.60,-3.50,-3.45,-3.43,-3.42,-3.41\ /*
			  */ -3.24,-3.18,-3.15,-3.13,-3.13,-3.12)
	}

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


program define MacP, rclass
	args type tau

	local stype = lower("`type'")
	if "`stype'"=="c" { local type 0 }
	else              { local type 1 }


	local g3=0
        local min=.
	local max=.
        if `type'==0 {  /* no trend but constant in ADF regression */
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
        else if `type'==1 {     /* linear trend and constant in ADF reg.*/
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
        } /* type==1 */

        local h = `g0' + `g1'*`tau' + `g2'*(`tau')^2 + `g3'*(`tau')^3
        local p = cond(`tau'<`min',0,cond(`tau'>`max',1,normprob(`h')))
        return scalar p = `p'

	local h = `g0' + `g1'*`tau' + `g2'*(`tau')^2 + `g3'*(`tau')^3
	local p = cond(`tau'<`min',0,cond(`tau'>`max',1,normprob(`h')))
	return scalar p = `p'
end

program define DispReg
        args tt lags dvar
        di in smcl in gr "{hline 13}{c TT}{hline 64}"
        di in smcl in gr abbrev("`e(depvar)'",12) _col(14) "{c |}" /*
                */ _col(21) "Coef." _col(29) "Std. Err." _col(44) "t" /*
                */ _col(49) "P>|t|" _col(59) "[95% Conf. Interval]"
        di in smcl in gr "{hline 13}{c +}{hline 64}"
        di in smcl in gr %12s abbrev("`dvar'",12) _col(14) "{c |}"
        local vv "L1.`dvar'"
        local bv "_b[`vv']"
        local sv "_se[`vv']"
	di in smcl in gr _col(10) "L1. {c |}" in ye /*
                */ _col(17) %9.0g `bv' /*
                */ _col(28) %9.0g `sv' /*
                */ _col(38) %8.2f `bv'/`sv' /*
                */ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
                */ _col(58) %9.0g `bv' - invt(`e(df_r)',$S_level/100)*`sv' /*
                */ _col(70) %9.0g `bv' + invt(`e(df_r)',$S_level/100)*`sv'
        local vv "LD.`dvar'"
        local bv "_b[`vv']"
        local sv "_se[`vv']"
	if `lags' >= 1 {
		di in smcl in gr _col(10) "LD. {c |}" in ye /*
			*/ _col(17) %9.0g `bv' /*
			*/ _col(28) %9.0g `sv' /*
			*/ _col(38) %8.2f `bv'/`sv' /*
			*/ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
			*/ _col(58) %9.0g `bv' - invt(`e(df_r)',/*
			*/ $S_level/100)*`sv' /*
			*/ _col(70) %9.0g `bv' + invt(`e(df_r)',/*
			*/ $S_level/100)*`sv'
	}
	local i 2
	while `i' <= `lags' {
		local vv "L`i'D.`dvar'"
		local bv "_b[`vv']"
		local sv "_se[`vv']"
		di in smcl in gr %12s "L`i'D." " {c |}" in ye /*
			*/ _col(17) %9.0g `bv' /*
			*/ _col(28) %9.0g `sv' /*
			*/ _col(38) %8.2f `bv'/`sv' /*
			*/ _col(48) %6.3f tprob(e(df_r),`bv'/`sv') /*
			*/ _col(58) %9.0g `bv' - invt(`e(df_r)',/*
			*/ $S_level/100)*`sv' /*
			*/ _col(70) %9.0g `bv' + invt(`e(df_r)',/*
			*/ $S_level/100)*`sv'
		local i = `i'+1
	}
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

