*! version 2.3.2  25dec2007
program define cchart, rclass
	version 6
	if _caller() < 8 {
		cchart_7 `0'
		exit
	}

	syntax varlist(min=2 max=2) [, noGRaph * ] 
        marksample touse

	_get_gropts , graphopts(`options') getallowed(clopts plot addplot)
	local options `"`s(graphopts)'"'
	local clopts `"`s(clopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts clopts, opt(`clopts')

	tokenize `varlist'
	local DEFECTS "`1'"
	local UNIT "`2'"
	local xttl : var label `UNIT'
	if `"`xttl'"' == "" {
		local xttl `UNIT'
	}

	// the # of defects must all be nonnegative or missing
	sum `DEFECTS', mean
	if r(min) < 0 {
		di in red "negative values encountered in `DEFECTS'"
		exit
	}
	local cbar = r(mean)
	local lcl = cond(`cbar'>9,`cbar' - 3*sqrt(`cbar'),0)
	local ucl = `cbar' + 3*sqrt(`cbar')
	tempvar LCL UCL
	gen `LCL' = `lcl'
	gen `UCL' = `ucl'
	qui count if (`DEFECTS'<`lcl' | `DEFECTS'>`ucl') & `touse'
	local note "`r(N)' unit`=cond(r(N)==1," is","s are")' out of control"
	local yttl : var label `DEFECTS'
	if `"`yttl'"' == "" {
		local yttl `DEFECTS'
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	label var `LCL' "Control limit"
	label var `UCL' "Control limit"

	/* return values*/
	return scalar cbar = `cbar'
	qui summ `LCL' if `touse'
	return scalar lcl_c = `r(mean)'
	qui summ `UCL' if `touse'
	return scalar ucl_c = `r(mean)'
	return scalar N = `r(N)'
	local missing = _N -`r(N)'
	if `missing' > 0 {
 		di as text _n "warning: missing values found"
	}
	qui count if (`DEFECTS'<`lcl' | `DEFECTS'>`ucl') & `touse'
	return scalar out_c = `r(N)'
	qui count if (`DEFECTS'<`lcl' ) & `touse'
        return scalar below_c = `r(N)'
	qui count if ( `DEFECTS'>`ucl') & `touse'
	return scalar above_c = `r(N)'

	
	if "`graph'" == "" {
		version 8: graph twoway			///
		(rline `LCL' `UCL' `UNIT' if `touse',	///
			sort				///
			pstyle(ci)			///
			yaxis(1 2)			///
			ylabels(, nogrid)		///
			xlabels(, nogrid)		///
			ytitle(`"`yttl'"', axis(1))	///
			ytitle("", axis(2))		///
			ylabels(`lcl' `cbar' `ucl',	///
				axis(2))		///
			yticks(`cbar',			///
				grid gmin gmax		/// 
				axis(2)			/// 
			)				///
			xtitle(`"`xttl'"')		///
			note(`"`note'"')		///
			`legend'			///
			`clopts'			///
		)					///
		(connected `DEFECTS' `UNIT' if `touse',	///
			sort				///
			pstyle(p1)			///
			`options'			///
		)					///
		|| `plot' || `addplot'			///
	}
	// blank
end
