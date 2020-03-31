*! version 1.3.0  09apr2007
program define wntestb, rclass
	version 6.0, missing
	if _caller() < 8 {
		wntestb_7 `0'
		return add
		exit
	}

	syntax varname(ts) [if] [in] [, Level(integer $S_level) /*
		*/ TAble * ]

	marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

	if `"`table'"' == "" {
		_get_gropts , graphopts(`options') getallowed(plot addplot)
		local options `"`s(graphopts)'"'
		local plot `"`s(plot)'"'
		local addplot `"`s(addplot)'"'
	}
	else {
		syntax varname(ts) [if] [in] [, Level(integer $S_level) /*
			*/ TAble ]
	}

	if `level'<10 | `level'>99 {
		local level 95
	}

quietly {

	_crcchkt if `touse', t(`tvar')

	// Sample is set and t variable verified to be good

	tempvar x xr xi w 
	gen double `x' = `varlist' if `touse'

	preserve
	keep if `touse'

	local N    = _N
	local samp "in 1/`N'"
	local n1   = int(`N'/2)+1

	gen double `w'=((_n-1)/`N') in 1/`n1'

	fft `x', gen(`xr' `xi')
	replace `xr' = 0 in 1
	replace `xi' = 0 in 1
	replace `xr' = sum(`xr'*`xr'+`xi'*`xi')
	local    ss  = `xr' in `n1'
	replace `xr' = `xr'/`ss'

} // quietly

	qui replace `x' = .
	qui replace `x' = abs(`xr'-2*`w') in 1/`n1'
	sum `x', mean
	local stat = sqrt(`n1')*r(max)     
	qui bartcdf `stat'
	local pvalue = 1-r(prob)

	if "`table'" == "" {
		local yttl "Cumulative periodogram for `varlist'"
		label var `xr' "`yttl'"
		local xttl "Frequency"
		label var `w' "`xttl'"

		local ttl "Cumulative Periodogram White-Noise Test"
		local note : di "Bartlett's (B) statistic = " /*
				*/ %8.2f `stat' "   Prob > B = " %6.4f `pvalue'
		local l1title "Cumulative Periodogram for `varlist'"
		format `xr' `w' %-5.2f

		tempvar yid xid yul xul yll xll
		local lev = `level'/100
		bartq `lev'
		local sq1 = r(u)/sqrt(`n1')
		local sq2 = 1.-`sq1'
		local sq3 = `sq2'/2
		local sq4 = `sq1'/2
		qui gen `yid' = _n-1 in 1/2
		qui gen `xid' = `yid'/2
		qui gen `yul' = cond(_n==1, `sq1', 1.0) in 1/2
		qui gen `xul' = cond(_n==1, 0.0, `sq3') in 1/2
		qui gen `yll' = cond(_n==1, 0.0, `sq2') in 1/2
		qui gen `xll' = cond(_n==1, `sq4', 0.5) in 1/2
		if `"`plot'`addplot'"' == "" {
			local legend legend(nodraw)
		}
		version 8: graph twoway			///
		(scatter `xr' `w'			///
			if `touse' & `w' <= .5,		///
			ylabels(0(.2)1)			///
			ytitle(`"`yttl'"')		///
			xlabels(0(.1).5)		///
			xtitle(`"`xttl'"')		///
			title(`"`ttl'"')		///
			note(`"`note'"')		///
			`legend'			///
			`options'			///
		)					///
		(line `yid' `xid',			///
			sort				///
			lstyle(refline)			///
			yvarlabel("Reference")		///
		)					///
		(line `yll' `xll',			///
			sort				///
			pstyle(ci)			///
			yvarlabel(Limits)		///
		)					///
		(line `yul' `xul',			///
			sort				///
			pstyle(ci)			///
			yvarlabel(Limits)		///
		)					///
		|| `plot' || `addplot'			///
		// blank
	}
	else {
		di _n in gr "Cumulative periodogram white-noise test"
		di in smcl in gr "{hline 39}"
		di in gr " Bartlett's (B) statistic  = " in ye %10.4f `stat'
		di in gr " Prob > B                  = " in ye %10.4f `pvalue'
	}

	return scalar stat = `stat'
	return scalar p    = `pvalue'
end

program define bartcdf, rclass
	confirm number `1'

	local a `1'
	local eps = .00001

	if `a' < 0.3 {
		local prob = 0
	}
	else {
		local prob = 1
		local i    = 1

		while `i' <= 100 {
			local del = 2*(-1.)^`i'*exp(-2*`a'^2*`i'^2)

			if abs(`del') < `eps'*`prob' { 
				local i = 101
			}
			else {
				local prob = `prob'+`del'
				local i = `i'+1
			}
		}

	}
	return scalar prob = `prob'
end


program define bartq, rclass
	confirm number `1'
	local u `1'

	if `u' <= 0.0 | `u' >= 1.0 {
		noi di in red "argument of bartq must be in (0,1)"
		exit 198
	}

	local left=.3
	local right=2.
	local middle=1.15
	local eps=.0001

	local i=1
	while `i' <= 100 {

		bartcdf `middle'

		if r(prob) < `u' { local left  = `middle' }
		else             { local right = `middle' }

		local del=`right'-`left'

		if `del' < `eps' {
			local i  = 101
			local S2 = `middle'
		}			
		else {
			local i = `i'+1
			local middle = (`left'+`right')/2.
		}
						
	}

	return scalar u = `S2'
end

program define _crcchkt
	syntax [if] [in] [, t(varname)]
 
	xt_tis `t'

	local realt "`s(timevar)'"
	tempvar tt
	gen `tt' = D.`realt' `if' `in'
	summ `tt' `if' `in', mean
	capture assert r(min)==r(max) `if' `in'
	if _rc {
		noi di in red "time variable does not have constant step size"
		exit 198
	}
	if r(min) == 0 {
		noi di in red "tied values in time variable not allowed"
		exit 198
	}
end
