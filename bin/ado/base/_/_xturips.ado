*! version 1.0.4  09feb2015
program _xturips, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ Trend						///
		  DEMEAN					///
		  Lags(string)					///
		  NOINTERpolate		/* undocumented */	///
		  USEDFKADJ		/* undocumented */	///
		]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	_xt, trequired
	capture xtset
	tempname usrdelta
	local panelvar  `r(panelvar)'
	local timevar   `r(timevar)'
	sca `usrdelta' =  `r(tdelta)'

	if `"`lags'"' != "" {
		_xtur_parse_lags `"`lags'"'
		local adf_lags = `s(lags)'
		local adf_lagsel `s(lagsel)'    // aic, bic, or hqic,
						// if specified
	}
	else {
		local adf_lags = -1
	}
	
	// Doesn't require strongly balanced sample, but can't have gaps
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta'   ///
		if `touse' & _n > 1
	if c(rc) {
		di as error			///
			"Im-Pesaran-Shin test cannot have gaps in data"
		exit 498
	}
	// If not strongly balanced, only some tests apply
	qui _xtstrbal `panelvar' `timevar' `touse'
	if "`r(strbal)'" != "yes" {
		local unbalanced unbalanced
	}
	
	// Back up user's e-class() stuff
	// capture --> _estimates errors out if no e-class() stuff
	// so clear our e-class() junk if nothing to restore
	tempname usrest
	capture _estimates hold `usrest', restore
	if _rc {
		local clreclass "yes"
	}

	// create trend variable if requested
	if "`trend'" != "" {
		tempvar ttrend
		qui by `panelvar': gen double `ttrend' = 1
		qui by `panelvar': replace `ttrend' =			///
			(`timevar'-`timevar'[_n-1])/			///
			`: char _dta[_TSdelta]' if _n > 1
		qui by `panelvar': replace `ttrend' = sum(`ttrend')
	}
	
	// remove cross-sectional averages for each time period
	tempvar depvar mean
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		qui gen double `depvar' = `usrdepvar'
	}
	
	tempvar obvar
	qui gen `c(obs_t)' `obvar' = _n
	
	// generate a panel var = 1...N so we can loop
	tempvar id pantouse
	qui bys `panelvar': gen long `pantouse' = sum(`touse')
	qui by `panelvar': replace `pantouse' = (`pantouse'[_N]>0)
	qui by `panelvar': gen `c(obs_t)' `id' = 1 if _n==1 & `pantouse'
	qui replace `id' = sum(`id')
	qui replace `id' = 0 if !`touse'
	summ `id', mean
	local capN = r(max)
	// need min_Ti to check if p-values for Z's exist
	tempvar one
	qui gen `one' = `touse'
	qui by `panelvar': replace `one' = sum(`one')
	qui by `panelvar': replace `one' = cond(_n==_N, `one'[_N], .)
			// skip over panels not in e(sample):
	sum `one' if `one' > 0 & !missing(`one'), mean
	local minT = r(min)
	local capT = r(mean)		// could be non-integer (Average)
		
	tempvar diffvar lagvar
	qui gen double `diffvar' = D.`depvar'
	qui gen double `lagvar' = L.`depvar'

	local obsused = 0
	if `adf_lags' == -1 {	
		tempname ti mui vari tti muti varti lagsused b 	zt ztt
		tempname ticv1 ticv5 ticv10 pztt
		foreach x in ti mui vari tti muti varti {
			sca ``x'' = 0
		}
		forvalues i = 1/`capN' {
			sum `obvar' if `id' == `i', mean
			local first = r(min)
			local last  = r(max)
			local icapT = r(N)
			qui regress `diffvar' `lagvar'		///
				`ttrend' in `first'/`last'	///
				if `touse'
			local obsused = `obsused' + e(N)
			// ttilde uses s^2 = var(`diffvar') 
			// instead of e(rss)/(N-k)under Ho (unit-root), 
			// both estimators are consistent
			sca `b' = _b[`lagvar']
			sca `ti' = `ti' + `b' / _se[`lagvar']
			qui su `diffvar' in `first'/`last' if `touse'
			sca `tti' = `tti' + `b' / (_se[`lagvar']/e(rmse)*r(sd))
			_ipstab1, t(`icapT') `nointerpolate'
			sca `mui' = `mui' + r(mu)
			sca `vari' = `vari' + r(var)
			sca `muti' = `muti' + r(mutilde)
			sca `varti' = `varti' + r(vartilde)
		}
		foreach x in ti mui vari tti muti varti {
			sca ``x'' = ``x'' / `capN'
		}
		sca `zt' = sqrt(`capN')*(`ti' - `mui') / sqrt(`vari')
		sca `ztt' = sqrt(`capN')*(`tti' - `muti') / sqrt(`varti')
		if "`unbalanced'" == "" {
			_critvals `capN' `capT' "`ttrend'" "`nointerpolate'"
			scalar `ticv1' = r(one)
			scalar `ticv5' = r(five)
			scalar `ticv10' = r(ten)
			if (`minT' > 5 & "`trend'" == "") |		///
			   (`minT' > 6 & "`trend'" != "")	{
			   	scalar `pztt' = normal(`ztt')
			}
			else {
				scalar `pztt' = .
			}
		}
		else {
			if `minT' > 9 {
			   	scalar `pztt' = normal(`ztt')
			}
			else {
				scalar `pztt' = .
			}
		}
		return scalar tbar = `ti'
		return scalar ttildebar = `tti'
		return scalar zt = `zt'
		return scalar zttildebar = `ztt'
		if "`unbalanced'" == "" {
			return scalar cv_1 = `ticv1'
			return scalar cv_5 = `ticv5'
			return scalar cv_10 = `ticv10'
		}
		return scalar p_zttildebar = `pztt'
	}
	else {
		tempname ti mui vari lagsused b wtbar
		foreach x in ti mui vari lagsused {
			sca ``x'' = 0
		}
		local meanlag = 0
		forvalues i = 1/`capN' {
			sum `obvar' if `id' == `i' & `touse', mean
			local first = r(min)
			local last  = r(max)
			local icapt = r(N)
			if `adf_lags' > 0 {
				local lagregs L(1/`adf_lags').(`diffvar')
			}
			if "`adf_lagsel'" != "" {
				_xturadfreg `diffvar' `lagvar' "`ttrend'" "" ///
					`adf_lags' `obvar' `first' `last'    ///
					`adf_lagsel' `touse' p_i
			}
			else {
				qui regress `diffvar' `lagvar'		///
					`lagregs'			///
					`ttrend' in `first'/`last'	///
					if `touse'
				local p_i = `adf_lags'
			}
			local meanlag = `meanlag' + `p_i'/`capN'
			sca `b' = _b[`lagvar']
			sca `ti' = `ti' + `b' / _se[`lagvar']
			local obsused = `obsused'  + e(N)
			qui su `diffvar' in `first'/`last' if `touse'
			if "`usedfkadj'" == "" {
				_adftmeanvar `p_i' `icapt' "`ttrend'"	///
					"`nointerpolate'"
			}
			else {
				// This uses T-k when looking up mean and var 
				// of t in IPS table 3
				_adftmeanvar `p_i' `=e(N)' "`ttrend'"	///
					"`nointerpolate'"
			}
			if r(mu) == . {
				if "`usedfkadj'" == "" {
					local tused = `icapt'
				}
				else {
					local tused = e(N)
				}
				di as error 			///
"mean and variance of t-statistic not available "
				di as error			///
"for T = " as res `tused' as err " with " as res `p_i' as err " lags"
				exit 498
			}
			sca `mui' = `mui' + r(mu)
			sca `vari' = `vari' + r(var)
			sca `lagsused' = `lagsused' + `p_i'
		}
		foreach x in ti mui vari lagsused {
			sca ``x'' = ``x'' / `capN'
		}
		sca `wtbar' = sqrt(`capN')*(`ti'-`mui')/sqrt(`vari')
		return scalar wtbar = `wtbar'
		return scalar p_wtbar = normal(`wtbar')
	}

	return scalar N_g = `capN'
	return scalar N_t = `capT'
	return scalar N = `obsused'
	if "`trend'" != "" {
		return local deterministics "`trend'"
	}
	else {
		return local deterministics "constant"
	}
	return local demean "`demean'"
	
	if `adf_lags' != -1 {
		if "`adf_lagsel'" != "" {
			return scalar lagm = `meanlag'
			return local adf_method "`adf_lagsel'"
		}
		else {
			return scalar lags = `meanlag'
		}
	}
	return local test "ips"
		
	di
	di as text "Im-Pesaran-Shin unit-root test for " as res "`varlist'"
	local linelen = 35 + length("`varlist'")
	di in smcl as text "{hline `linelen'}"
	if "`unbalanced'" != "" {
		local panhead as text _col(45) /*
*/ "Number of panels" _col(68) "=" _col(69) as res %7.0g `capN'
		local perhead as text _col(45) /*
*/ "Avg. number of periods" _col(68) "=" _col(69) as res %7.2f `capT'
	}
	else {
		local panhead as text _col(45) /*
*/ "Number of panels" _col(63) "=" _col(64) as res %7.0g `capN'
		local perhead as text _col(45) /*
*/ "Number of periods" _col(63) "=" _col(64) as res %7.0g `capT'
	}
	di as text "Ho: All panels contain unit roots" `panhead'
	di as text "Ha: Some panels are stationary" `perhead'
	di
	di as text "AR parameter: " as res "Panel-specific" _c
	di as text _col(45) "Asymptotics: " as res "T,N -> Infinity"
	di as text "Panel means:  " as res "Included" _c
	di as res _col(63) "sequentially"
	di as text "Time trend:   " _c
	if "`trend'" != "" {
		di as res "Included" _c
	}
	else {
		di as res "Not included" _c
	}
	if "`demean'" != "" {
		di as text _col(45) "Cross-sectional means removed"
	}
	else {
		di
	}

	di
	di as text "ADF regressions: " _c
	if `adf_lags' == -1 {
		di as res "No lags included"
	}
	else {
		if "`return(adf_method)'" == "" {
			if return(lags) != 1 {
				local s s
			}
			di as res return(lags) as text " lag`s'"
		}
		else {
			di as res %4.2f return(lagm)	 		  ///
				as text	" lags average (chosen by "	  ///
				as res "`=upper("`return(adf_method)'")'" ///
				as text ")"
		}
	}

	di in smcl as text "{hline 78}"
	if `adf_lags' == -1 {
		di as text _col(47) "Fixed-N exact critical values"
		di as text _col(21) "Statistic"			///
			   _col(36) "p-value"			///
			   _col(52) "1%"			///
			   _col(60) "5%"			///
			   _col(68) "10%"
		di in smcl as text "{hline 78}"
		di as text _col(2) "t-bar" as res _col(21) %8.4f `ti' _c
		if "`unbalanced'" != "" {
			di as res _col(55) "(Not available)"
		}
		else {
			di as res _col(50) %6.3f `ticv1'	///
				  _col(58) %6.3f `ticv5'	///
				  _col(66) %6.3f `ticv10'
		}
		di as text _col(2) "t-tilde-bar" 		///
			as res _col(21)	%8.4f `tti'
		di as text _col(2) "Z-t-tilde-bar"		///
			as res _col(21) %8.4f `ztt' _c
		if `pztt' < . {
			di as res _col(37) %6.4f `pztt'
		}
		else {
			di as res _col(39) "*"
		}
	}
	else {
		di as text _col(21) "Statistic" _col(36) "p-value"
		di in smcl as text "{hline 78}"
		if return(wtbar) < . {
			di as text _col(2) "W-t-bar"			///
				as res _col(21) %8.4f return(wtbar) 	///
				as res _col(37) %6.4f return(p_wtbar)
		}
		else {
			di as text _col(2) 				///
"Insufficient number of time periods to compute W-t-bar"
		}
	}
	di in smcl as text "{hline 78}"
	
	if "`pztt'" != "" {
		if `pztt' >= . {
			if "`unbalanced'" != "" {
				di as res "*" as text			///
" Normality of Z-t-tilde-bar requires at least 10 observations " _n	///
"  per panel with unbalanced data."
			}
			else if "`trend'" != "" {
				di as res "*" as text			///
" Normality of Z-t-tilde-bar requires at least 7 observations " _n	///
"  per panel with balanced data and a time trend."
			}
			else {
				di as res "*" as text 			///
" Normality of Z-t-tilde-bar requires at least 6 observations " _n	///
"  per panel with balanced data and no time trend."
			}
		}
	}
	
	if "`clreclass'" == "yes" {
		eret clear
	}
end



program _ipstab1, rclass

	syntax, t(real) [ NOINTERPOLATE ]
	
	tempname mvtilde mv
	mat `mvtilde' = (  6, -1.125, 0.497	\	///
			   7, -1.178, 0.506	\	///
			   8, -1.214, 0.506	\	///
			   9, -1.244, 0.527	\	///
			  10, -1.274, 0.521	\	///
			  15, -1.349, 0.565	\	///
			  20, -1.395, 0.592	\	///
			  25, -1.423, 0.609	\	///
			  30, -1.439, 0.623	\	///
			  40, -1.463, 0.639	\	///
			  50, -1.477, 0.656	\	///
			 100, -1.504, 0.683	\	///
			 500, -1.526, 0.704	\	///
			1000, -1.526, 0.702	\	///
			   ., -1.533, 0.706 )

	mat `mv' = 	(  6, -1.520, 1.745	\	///
			   7, -1.514, 1.414	\	///
			   8, -1.501, 1.228	\	///
			   9, -1.501, 1.132	\	///
			  10, -1.504, 1.069	\	///
			  15, -1.514, 0.923	\	///
			  20, -1.522, 0.851	\	///
			  25, -1.520, 0.809	\	///
			  30, -1.526, 0.789	\	///
			  40, -1.523, 0.770	\	///
			  50, -1.527, 0.760	\	///
			 100, -1.532, 0.735	\	///
			 500, -1.531, 0.715	\	///
			1000, -1.529, 0.707	\	///
			   ., -1.533, 0.706 )
	
	
	
	local row = rowsof(`mv')
	forvalues i = 1/14 {
		if `t' <= `mv'[`i', 1] {
			local row = `i'
			continue, break
		}
	}
	
	if `t' <= 10 | `t' > 1000 {	// nothing to interpolate
		local nointerpolate nointerpolate
	}
	
	if "`nointerpolate'" != "" {
		return scalar mutilde  = `mvtilde'[`row', 2]
		return scalar vartilde = `mvtilde'[`row', 3]
		return scalar mu  = `mv'[`row', 2]
		return scalar var = `mv'[`row', 3]
		exit
	}
	
	tempname mut vart mu var
	local rowheads 6 7 8 9 10 15 20 25 30 40 50 100 500 1000
	local bottom: word `=`row'-1' of `rowheads'
	local top: word `row' of `rowheads'
	local bfrac = 1 - (`t'-`bottom')/(`top'-`bottom')
	local tfrac = 1 - (`top'-`t')/(`top'-`bottom')
	scalar `mut' =  `bfrac'*`mvtilde'[`row'-1, 2] +		///
			`tfrac'*`mvtilde'[`row', 2]
	scalar `vart' = `bfrac'*`mvtilde'[`row'-1, 3] +		///
			`tfrac'*`mvtilde'[`row', 3]
	scalar `mu' =  `bfrac'*`mv'[`row'-1, 2] +		///
			`tfrac'*`mv'[`row', 2]
	scalar `var' = `bfrac'*`mv'[`row'-1, 3] +		///
			`tfrac'*`mv'[`row', 3]
	
	return scalar mutilde = `mut'
	return scalar vartilde = `vart'

	return scalar mu = `mu'
	return scalar var = `var'

end

program _critvals, rclass
// IPS Table 2
	args capn capt trend nointerpolate
	
	tempname onepct fivepct tenpct onepcttrend fivepcttrend tenpcttrend
	mat `onepct' = ( ///
-3.79, -2.66, -2.54, -2.50, -2.46, -2.44, -2.43, -2.42, -2.42, -2.40, -2.40 \ ///
-3.45, -2.47, -2.38, -2.33, -2.32, -2.31, -2.29, -2.28, -2.28, -2.28, -2.27 \ ///
-3.06, -2.32, -2.24, -2.21, -2.19, -2.18, -2.16, -2.16, -2.16, -2.16, -2.15 \ ///
-2.79, -2.14, -2.10, -2.08, -2.07, -2.05, -2.04, -2.05, -2.04, -2.04, -2.04 \ ///
-2.61, -2.06, -2.02, -2.00, -1.99, -1.99, -1.98, -1.98, -1.98, -1.97, -1.97 \ ///
-2.51, -2.01, -1.97, -1.95, -1.94, -1.94, -1.93, -1.93, -1.93, -1.93, -1.92 \ ///
-2.20, -1.85, -1.83, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81, -1.81 \ ///
-2.00, -1.75, -1.74, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73   /// 
	)

	mat `fivepct' = ( ///
-2.76, -2.28, -2.21, -2.19, -2.18, -2.16, -2.16, -2.15, -2.16, -2.15, -2.15 \ ///
-2.57, -2.17, -2.11, -2.09, -2.08, -2.07, -2.07, -2.06, -2.06, -2.06, -2.05 \ ///
-2.42, -2.06, -2.02, -1.99, -1.99, -1.99, -1.98, -1.98, -1.97, -1.98, -1.97 \ ///
-2.28, -1.95, -1.92, -1.91, -1.90, -1.90, -1.90, -1.89, -1.89, -1.89, -1.89 \ ///
-2.18, -1.89, -1.87, -1.86, -1.85, -1.85, -1.85, -1.85, -1.84, -1.84, -1.84 \ ///
-2.11, -1.85, -1.83, -1.82, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81 \ ///
-1.95, -1.75, -1.74, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73, -1.73 \ ///
-1.84, -1.68, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67, -1.67   ///
	)

	mat `tenpct' = ( ///
-2.38, -2.10, -2.06, -2.04, -2.04, -2.02, -2.02, -2.02, -2.02, -2.02, -2.01 \ ///
-2.27, -2.01, -1.98, -1.96, -1.95, -1.95, -1.95, -1.95, -1.94, -1.95, -1.94 \ ///
-2.17, -1.93, -1.90, -1.89, -1.88, -1.88, -1.88, -1.88, -1.88, -1.88, -1.88 \ ///
-2.06, -1.85, -1.83, -1.82, -1.82, -1.82, -1.81, -1.81, -1.81, -1.81, -1.81 \ ///
-2.00, -1.80, -1.79, -1.78, -1.78, -1.78, -1.78, -1.78, -1.78, -1.77, -1.77 \ ///
-1.96, -1.77, -1.76, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75, -1.75 \ ///
-1.85, -1.70, -1.69, -1.69, -1.69, -1.69, -1.68, -1.68, -1.68, -1.68, -1.69 \ ///
-1.77, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64, -1.64   ///
	)

	mat `onepcttrend' = ( ///
-8.12, -3.42, -3.21, -3.13, -3.09, -3.05, -3.03, -3.02, -3.00, -3.00, -2.99 \ ///
-7.36, -3.20, -3.03, -2.97, -2.94, -2.93, -2.90, -2.88, -2.88, -2.87, -2.86 \ ///
-6.44, -3.03, -2.88, -2.84, -2.82, -2.79, -2.78, -2.77, -2.76, -2.75, -2.75 \ ///
-5.72, -2.86, -2.74, -2.71, -2.69, -2.68, -2.67, -2.65, -2.66, -2.65, -2.64 \ ///
-5.54, -2.75, -2.67, -2.63, -2.62, -2.61, -2.59, -2.60, -2.59, -2.58, -2.58 \ ///
-5.16, -2.69, -2.61, -2.58, -2.58, -2.56, -2.55, -2.55, -2.55, -2.54, -2.54 \ ///
-4.50, -2.53, -2.48, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.43 \ ///
-4.00, -2.42, -2.39, -2.38, -2.37, -2.37, -2.36, -2.36, -2.36, -2.36, -2.36   ///
	)

	mat `fivepcttrend' = ( ///
-4.66, -2.98, -2.87, -2.82, -2.80, -2.79, -2.77, -2.76, -2.75, -2.75, -2.75 \ ///
-4.38, -2.85, -2.76, -2.72, -2.70, -2.69, -2.68, -2.67, -2.67, -2.66, -2.66 \ ///
-4.11, -2.74, -2.66, -2.63, -2.62, -2.60, -2.60, -2.59, -2.59, -2.58, -2.58 \ ///
-3.88, -2.63, -2.57, -2.55, -2.53, -2.53, -2.52, -2.52, -2.52, -2.51, -2.51 \ ///
-3.73, -2.56, -2.52, -2.49, -2.48, -2.48, -2.48, -2.47, -2.47, -2.46, -2.46 \ ///
-3.62, -2.52, -2.48, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.43 \ ///
-3.35, -2.42, -2.38, -2.38, -2.37, -2.37, -2.36, -2.36, -2.36, -2.36, -2.36 \ ///
-3.13, -2.34, -2.32, -2.32, -2.31, -2.31, -2.31, -2.31, -2.31, -2.31, -2.31   ///
	)

	mat `tenpcttrend' = ( ///
-3.73, -2.77, -2.70, -2.67, -2.65, -2.64, -2.63, -2.62, -2.63, -2.62, -2.62 \ ///
-3.60, -2.68, -2.62, -2.59, -2.58, -2.57, -2.57, -2.56, -2.56, -2.55, -2.55 \ ///
-3.45, -2.59, -2.54, -2.52, -2.51, -2.51, -2.50, -2.50, -2.50, -2.49, -2.49 \ ///
-3.33, -2.52, -2.47, -2.46, -2.45, -2.45, -2.44, -2.44, -2.44, -2.44, -2.44 \ ///
-3.26, -2.47, -2.44, -2.42, -2.41, -2.41, -2.41, -2.40, -2.40, -2.40, -2.40 \ ///
-3.18, -2.44, -2.40, -2.39, -2.39, -2.38, -2.38, -2.38, -2.38, -2.38, -2.38 \ ///
-3.02, -2.36, -2.33, -2.33, -2.33, -2.32, -2.32, -2.32, -2.32, -2.32, -2.32 \ ///
-2.90, -2.30, -2.29, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28, -2.28   ///
	)

	if "`trend'" != "" {
		local trend trend
	}	

	local row = rowsof(`onepct')
	local icnt = 1
	foreach i in 5 7 10 15 20 25 50 {	// 100 is default
		if `capn' <= `i' {
			local row = `icnt'
			continue, break
		}
		local `++icnt'
	}

	local col = colsof(`onepct')
	local jcnt = 1
	foreach j in 5 10 15 20 25 30 40 50 60 70 {	// 100 is default
		if `capt' <= `j' {
			local col = `jcnt'
			continue, break
		}
		local `++jcnt'
	}
	return scalar one = `onepct`trend''[`row',`col']
	return scalar five = `fivepct`trend''[`row', `col']
	return scalar ten = `tenpct`trend''[`row', `col']

end


program _adftmeanvar, rclass
// IPS Table 3
	args lag capt trend nointerpolate

	tempname mean var meantrend vartrend
	
	mat `mean' = ( ///
-1.504, -1.514, -1.522, -1.520, -1.526, -1.523, -1.527, -1.519, -1.524, -1.532 \ ///
-1.488, -1.503, -1.516, -1.514, -1.519, -1.520, -1.524, -1.519, -1.522, -1.530 \ ///
-1.319, -1.387, -1.428, -1.443, -1.460, -1.476, -1.493, -1.490, -1.498, -1.514 \ ///
-1.306, -1.366, -1.413, -1.433, -1.453, -1.471, -1.489, -1.486, -1.495, -1.512 \ ///
-1.171, -1.260, -1.329, -1.363, -1.394, -1.428, -1.454, -1.458, -1.470, -1.495 \ ///
     .,      ., -1.313, -1.351, -1.384, -1.421, -1.451, -1.454, -1.467, -1.494 \ ///
     .,      .,      ., -1.289, -1.331, -1.380, -1.418, -1.427, -1.444, -1.476 \ ///
     .,      .,      ., -1.273, -1.319, -1.371, -1.411, -1.423, -1.441, -1.474 \ ///
     .,      .,      ., -1.212, -1.266, -1.329, -1.377, -1.393, -1.415, -1.456   ///
	)

	mat `var' = ( ///
 1.069,  0.923,  0.851,  0.809,  0.789,  0.770,  0.760,  0.749,  0.736,  0.735 \ ///
 1.255,  1.011,  0.915,  0.861,  0.831,  0.803,  0.781,  0.770,  0.753,  0.745 \ ///
 1.421,  1.078,  0.969,  0.905,  0.865,  0.830,  0.798,  0.789,  0.766,  0.754 \ ///
 1.759,  1.181,  1.037,  0.952,  0.907,  0.858,  0.819,  0.802,  0.782,  0.761 \ ///
 2.080,  1.279,  1.097,  1.005,  0.946,  0.886,  0.842,  0.819,  0.801,  0.771 \ ///
     .,      .,  1.171,  1.055,  0.980,  0.912,  0.863,  0.839,  0.814,  0.781 \ ///
     .,      .,      .,  1.114,  1.023,  0.942,  0.886,  0.858,  0.834,  0.795 \ ///
     .,      .,      .,  1.164,  1.062,  0.968,  0.910,  0.875,  0.851,  0.806 \ ///
     .,      .,      .,  1.217,  1.105,  0.996,  0.929,  0.896,  0.871,  0.818   ///
	)

	mat `meantrend' = ( ///
-2.166, -2.167, -2.168, -2.167, -2.172, -2.173, -2.176, -2.174, -2.174, -2.177 \ ///
-2.173, -2.169, -2.172, -2.172, -2.173, -2.177, -2.180, -2.178, -2.176, -2.179 \ ///
-1.914, -1.999, -2.047, -2.074, -2.095, -2.120, -2.137, -2.143, -2.146, -2.158 \ ///
-1.922, -1.977, -2.032, -2.065, -2.091, -2.117, -2.137, -2.142, -2.146, -2.158 \ ///
-1.750, -1.823, -1.911, -1.968, -2.009, -2.057, -2.091, -2.103, -2.114, -2.135 \ ///
     .,      ., -1.888, -1.955, -1.998, -2.051, -2.087, -2.101, -2.111, -2.135 \ ///
     .,      .,      ., -1.868, -1.923, -1.995, -2.042, -2.065, -2.081, -2.113 \ ///
     .,      .,      ., -1.851, -1.912, -1.986, -2.036, -2.063, -2.079, -2.112 \ ///
     .,      .,      ., -1.761, -1.835, -1.925, -1.987, -2.204, -2.046, -2.088   ///
	)

	mat `vartrend' = ( ///
 1.132,  0.869,  0.763,  0.713,  0.690,  0.655,  0.633,  0.621,  0.610,  0.597 \ ///
 1.453,  0.975,  0.845,  0.769,  0.734,  0.687,  0.654,  0.641,  0.627,  0.605 \ ///
 1.627,  1.036,  0.882,  0.796,  0.756,  0.702,  0.661,  0.653,  0.634,  0.613 \ ///
 2.482,  1.214,  0.983,  0.861,  0.808,  0.735,  0.688,  0.674,  0.650,  0.625 \ ///
 3.947,  1.332,  1.052,  0.913,  0.845,  0.759,  0.705,  0.685,  0.662,  0.629 \ ///
     .,      .,  1.165,  0.991,  0.899,  0.792,  0.730,  0.705,  0.673,  0.638 \ ///
     .,      .,      .,  1.055,  0.945,  0.828,  0.753,  0.725,  0.689,  0.650 \ ///
     .,      .,      .,  1.145,  1.009,  0.872,  0.786,  0.747,  0.713,  0.661 \ ///
     .,      .,      .,  1.208,  1.063,  0.902,  0.808,  0.766,  0.728,  0.670   ///
	)


	if "`trend'" != "" {
		local trend "trend"
	}

	if `lag' < 0 | `lag' > 8 {
		return scalar mu = .
		return scalar var = .
		exit
	}
	local row = `lag' + 1		// first row is lag=0
	local col = colsof(`mean')
	local colheads 10 15 20 25 30 40 50 60 70 
	local jcnt = 1
	foreach j in `colheads' {	// 100 is default
		if `capt' <= `j' {
			local col = `jcnt'
			continue, break
		}
		local `++jcnt'
	}
	local colheads `colheads' 100
	
	tempname mymu myvar
	if "`nointerpolate'" == "" {
		if `col' == 1 | `capt' >= 100 {		// can't interpolate
			scalar `mymu' = `mean`trend''[`row',`col']
			scalar `myvar' = `var`trend''[`row',`col']
		}
		else if `:list posof "`capt'" in colheads' > 0 {
						// no need to interpolate
			scalar `mymu' = `mean`trend''[`row',`col']
			scalar `myvar' = `var`trend''[`row',`col']		
		}
		else {
			local bottom: word `=`col'-1' of `colheads'
			local top: word `col' of `colheads'
			local bfrac = 1 - (`capt'-`bottom')/(`top'-`bottom')
			local tfrac = 1 - (`top' -`capt')/(`top'-`bottom')
			scalar `mymu' = 				///
				`bfrac'*`mean`trend''[`row',`col'-1] + 	///
				`tfrac'*`mean`trend''[`row',`col']
			scalar `myvar' = 				///
				`bfrac'*`var`trend''[`row',`col'-1] + 	///
				`tfrac'*`var`trend''[`row',`col']
		}
	}
	else {
		scalar `mymu' = `mean`trend''[`row',`col']
		scalar `myvar' = `var`trend''[`row',`col']
	}
	
	return scalar mu = `mymu'
	return scalar var = `myvar'

end
