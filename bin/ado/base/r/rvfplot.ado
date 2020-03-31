*! version 3.2.0  29sep2004
program define rvfplot	/* residual vs. fitted */
	version 6
	if _caller() < 8 {
		rvfplot_7 `0'
		exit
	}

	_isfit cons anovaok
	syntax [, * ]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	tempvar resid hat
	quietly _predict `resid' if e(sample), resid
	quietly _predict `hat' if e(sample)
	label var `hat' "Fitted values"
	label var `resid' "Residuals"
	version 8: graph twoway		///
	(scatter `resid' `hat',		///
		`options'		///
	)				///
	|| `plot' || `addplot'		///
	// blank
end
