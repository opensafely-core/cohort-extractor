*! version 1.3.0  12apr2011
program brrstat, eclass
	version 9
	if `"`e(prefix)'"' != "svy" {
		Estimate `0'
		exit
	}

	syntax [anything] [using/] [if] [in] [, 	///
		Stat(passthru)				///
		MSE					///
		*					///
	]

	if `"`anything'`using'`if'`in'`stat'`mse'"' != "" {
		Estimate `0'
		ereturn local cmdline `"brrstat `0'"'
	}
	else	_prefix_display `0'

end

program Estimate, eclass
	// check syntax
	syntax [anything] [using] [if] [in] [,		///
		Stat(passthru)				///
		MSE					///
		Level(cilevel)				///
		notable					///
		TItle(string asis)			///
		noHeader				///
		noLegend				///
		Verbose					///
		*					///
	]

	// quick check for errors

	_get_diopts diopts, `options' level(`level')
	local diopts	`diopts'	///
			`table'		///
			`header'	///
			`legend'	///
			`verbose'	///
			// blank

	// compute results
	_brr_sum `anything' `using' `if' `in', `stat' `mse'

	// save results
	tempname b V
	matrix `b' = r(b)
	matrix `V' = r(V)
	ereturn post `b' `V'
	_r2e, xmat(b V)
	_post_vce_rank
	ereturn scalar k_extra = 0
	ereturn scalar k_aux = 0
	if "`mse'" == "" {
		ereturn local vcetype	"BRR"
	}
	else {
		ereturn local vcetype	"BRR *"
	}
	ereturn local vce	brr
	ereturn local mse	`mse'
	ereturn hidden local predict _no_predict
	if "`e(cmd)'" == "" {
		ereturn local cmd brr
	}
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		ereturn local title "BRR results"
	}

	// display results
	_prefix_display, `diopts'
end

exit
