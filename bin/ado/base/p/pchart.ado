*! version 2.3.3  25dec2007
program define pchart, sort rclass
	version 6
	if _caller() < 8 {
		pchart_7 `0'
		exit
	}
	syntax varlist(min=3 max=3) [, STAbilized  noGRaph Generate(string) * ]
	marksample touse

	_get_gropts , graphopts(`options') getallowed(CLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local clopts `"`s(clopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts clopts, opt(`clopts')

	tokenize `varlist'
	local REJECTS "`1'"
	local UNIT "`2'"
	local xttl : var label `UNIT'
	if `"`xttl'"' == "" {
		local xttl `UNIT'
	}
	local SAMPLE "`3'"

	// the # of rejects and sample sizes must all be nonnegative or
	// missing
	cap assert `REJECTS' >= 0
	if _rc {
		di in red "negative values encountered in `REJECTS'"
		exit
	}
	cap assert `SAMPLE' >= 0
	if _rc {
		di in red "negative values encountered in `SAMPLE'"
		exit
	}

	tempvar NTOTAL P

	sum `SAMPLE', mean
	if r(max) == 0 {
		di in red "All samples are missing or zero"
		exit
	}
	// constant sample size
	local constant = (r(min)==r(max))
	if r(min)==r(max) {
		local SAMPLE = r(min)
		local icons 1
	}
	else	local icons 0

	qui gen `P' = `REJECTS'/`SAMPLE' if `touse'
	local yttl "Fraction defective"
	label variable `P' "`yttl'"
	sum `P', mean
	local pbar = r(mean)
	if `pbar' <= 0 {
		di in red "No units were ever rejected"
		exit
	}
	format `P' %9.4f
	tempvar LCL UCL
	if `icons' {		// constant sample size
		local ucl=`pbar' + 3*sqrt(`pbar'*(1-`pbar')/(`SAMPLE'))
		local lcl=max(0,2*`pbar'-`ucl')
		qui gen `LCL' = `lcl' if `touse'
		qui gen `UCL' = `ucl' if `touse'
		qui count if (`P'<`lcl' | `P'>`ucl') & `touse'
		local out = "`r(N)'"
		local note ///
		"`r(N)' unit`=cond(r(N)==1," is","s are")' out of control"
	}
	else {			// varying sample size
		qui gen float `UCL' = 3*sqrt(`pbar'*(1-`pbar')/(`SAMPLE')) if `touse'
		qui gen float `LCL' = `pbar'-`UCL' if `touse'
		quietly replace `LCL' = 0 if `LCL' < 0 & `touse'
		quietly replace `UCL' = `pbar' + `UCL' if `touse'
		label variable `UCL' " "
		label variable `LCL' " "

		qui count if `P'<`LCL' | `P'>`UCL' & `touse'
		local out = "`r(N)'"
		local note ///
		"`r(N)' unit`=cond(r(N)==1," is","s are")' out of control"
		if "`stabili'" != "" {
			format `P' %9.2f
			quietly replace `UCL' = (`UCL'-`pbar')/3 if `touse'
			quietly replace `P' = (`P'-`pbar')/`UCL' if `touse'
			label variable `P' "`yttl' (Standard Deviation units)"
			local yttl `""`yttl'" "(Standard Deviation units)""'
			local pbar = int(`pbar'*10000+.5)/10000
			local lcl -3
			local ucl 3
			quietly replace `LCL' = `lcl' if `touse'
			quietly replace `UCL' = `ucl' if `touse'
			local note2 ///
"Stabilized p Chart, average number of defects = `pbar'"
			local pbar 0
		}
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	
	/*option generate*/
	if "`generate'" != "" {
		tokenize `generate'
        	local wc : word count `generate'
                if `wc' != 3 {
                	error 198
                }
                confirm new var `1'
                confirm new var `2'
                confirm new var `3'
		local pname `"`1'"'
                local lname  `"`2'"'
                local uname  `"`3'"'
		qui generate `lname' = `LCL'
		qui generate `uname' = `UCL'
		qui generate `pname' = `P'
	}



	/*return values*/
	qui summ `P' if `touse'
	return scalar pbar = r(mean)
	local  N = `r(N)'
	local missing = _N - `r(N)'
	if `missing' >0 {
		di as text _n "warning: missing values found"
	}
	if `icons'{
		qui  summ `LCL' if `touse'
		return scalar lcl_p = r(mean)
		qui  summ `UCL' if `touse'
		return scalar ucl_p = r(mean)
	}
	return scalar N = `N'
	return scalar out_p = `out'
	qui count if `P'<`LCL' & `touse'
	return scalar below_p = `r(N)'
	qui count if  `P'>`UCL' & `touse'
	return scalar above_p = `r(N)'


	

	if "`graph'"=="" {
		label var `LCL' "Control limit"
		label var `UCL' "Control limit"
		version 8: graph twoway			///
		(rline `LCL' `UCL' `UNIT',		///
			sort				///
			pstyle(ci)			///
			yaxis(1 2)			///
			ylabels(, nogrid)		///
			xlabels(, nogrid)		///
			ytitle(`yttl', axis(1))		///
			ylabels(`lcl' `pbar' `ucl',	///
				axis(2))		///
			yticks(`pbar',			///
				grid gmin gmax		///
				axis(2)			///
			)				///
			ytitle("", axis(2))		///
			xtitle(`"`xttl'"')		///
			note(`"`note'"' `"`note2'"')	///
			`legend'			///
			`clopts'			///
		)					///
		(connected `P' `UNIT',			///
			sort				///
			pstyle(p1)			///
			`options'			///
		)					///
		|| `plot' || `addplot'			///
		// blank
	}
end
