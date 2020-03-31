*! version 3.2.0  29sep2004
program define lvr2plot /* leverage vs. residual squared */
	version 6
	if _caller() < 8 {
		lvr2plot_7 `0'
		exit
	}

	_isfit cons anovaok
	syntax [, * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	if "`e(vcetype)'"=="Robust" { 
		di in red "leverage plot not available after robust estimation"
		exit 198
	}

	tempvar h r 
	quietly { 
		_predict `h' if e(sample), hat
		_predict `r' if e(sample), resid
		replace `r'=`r'*`r'
		sum `r', mean
		replace `r'=`r'/(r(mean)*r(N))
		local x=1/r(N)
		local y=(e(df_m)+1)*`x'
	}

	label var `h' "Leverage"
	local yttl : var label `h'
	label var `r' "Normalized residual squared"
	local xttl : var label `r'
	version 8: graph twoway		///
	(scatter `h' `r',		///
		ytitle(`"`yttl'"')	///
		xtitle(`"`xttl'"')	///
		yline(`y')		///
		xline(`x')		///
		`options'		///
	)				///
	|| `plot' || `addplot'		///
	// blank
end
