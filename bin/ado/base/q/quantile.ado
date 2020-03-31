*! version 2.3.3  07mar2005
program define quantile, sort
	version 6, missing
	if _caller() < 8 {
		quantile_7 `0'
		exit
	}

	syntax varname [if] [in] [, *] 

	_get_gropts , graphopts(`options') getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')

quietly {

	tempvar QUANT LINE FRAC CNT
	gen `QUANT'=`varlist' `if' `in'
	sort `QUANT'
	gen long `CNT'=sum(`QUANT'<.)
	gen `FRAC'=(`CNT'-0.5)/`CNT'[_N]
	gen `LINE'=`QUANT'[1] + `CNT'* /*
		*/ ((`QUANT'[`CNT'[_N]]-`QUANT'[1])/`CNT'[_N])
	_crcslbl `QUANT' `varlist'
	local w : variable label `QUANT'
	local yttl "Quantiles of `w'"
	label var `QUANT' "`yttl'"
	local xttl "Fraction of the data"
	label var `FRAC' "`xttl'"
	label var `LINE' "Reference"
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}

} // quietly

	version 8: graph twoway			///
	(scatter `QUANT' `FRAC',		///
		sort				///
		ytitle(`"`yttl'"')		///
		xlabel(0(.25)1)			///
		xtitle(`"`xttl'"')		///
		`legend'			///
		`options'			///
	)					///
	(line `LINE' `FRAC',	 		///
		sort				///
		lstyle(refline)			///
		`rlopts'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end
