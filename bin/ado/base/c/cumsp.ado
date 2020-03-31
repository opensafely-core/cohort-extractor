*! version  1.3.1  04oct2004
program define cumsp
	version 6.0, missing
	local vv : display "version " string(_caller()) ":"
	if _caller() < 8 {
		`vv' cumsp_7 `0'
		exit
	}

	syntax varname(ts) [if] [in] [, GENerate(string) * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	local gen `"`generat'"'
	local generat

	marksample touse
	_ts t1 panelvar `if' `in', sort onepanel
	markout `touse' `t1'
	local targ ", t(`t1')"

	if "`gen'" != "" {
		capture gen byte `gen' = 0
		if _rc {
			di in red "generate() should name one new variable"
			exit 198
		}
		capture drop `gen'
	}

quietly {

	tempvar  pg spg omega ourn
	tempname R0

	count if `touse'
	local n = r(N)
	`vv' pergram `varlist' if `touse', gen(`pg') nograph
	gen double `spg' = sum(`pg')
	cap local vlab : var label `varlist'
	local yttl `"Cumulative spectral distribution"'
	if "`vlab'" == "" {
		local vlab "`varlist'"
		local yttl "`yttl' of `vlab'"
	}
	else {
		local yttl `"`"`vlab'"' `"`yttl'"'"'
	}
	label var `spg' "`vlab'"

	gen long `ourn' = sum(1) if `touse'
	compress `ourn'
	gen double `omega' = (`ourn'-1)/`n'

	sum `pg' if `omega' <= .5
	local rden = r(sum)
	
	replace `spg' = `spg'/`rden'
	
	format `omega' `spg' %-5.2f

	local xttl "Frequency"
	label var `omega' "`xttl'"

} // quietly

	local ttl "Sample spectral distribution function"
	local note "Points evaluated at the natural frequencies"
	version 8: graph twoway			///
	(connected `spg' `omega'		///
		if `omega' <= .5,		///
		yaxis(1 2)			///
		ylabels(0(.2)1, axis(1))	///
		ylabels(0(.2)1, axis(2))	///
		ytitle(`yttl')			///
		ytitle(`""', axis(2))		///
		xlabels(0(.1).5)		///
		xtitle(`xttl')			///
		title(`"`ttl'"')		///
		note(`"`note'"')		///
		legend(nodraw)			/// no legend
		`options'			///
	)					///
	|| `plot' || `addplot'			///
	// blank

	if "`gen'" != "" {
		qui replace `spg' = . if `omega' > .5
		rename `spg' `gen'
		format `gen' %10.0g
	}
end
