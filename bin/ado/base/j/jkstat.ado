*! version 1.2.0  12apr2011
program jkstat
	version 9
	if !inlist(`"`e(cmd)'"',"jackknife","svy") {
		Estimate `0'
		exit
	}

	syntax [anything] [using/] [if] [in] [fw pw iw]	///
		[, 					///
			Stat(passthru)			///
			STRata(passthru)		///
			MSE				///
			SINGLEunit(passthru)		///
			*				///
		]

	local a `"`anything'`using'`exp'`if'`in'"'
	local o `"`stat'`strata'`mse'`singleunit'"'
	if `"`a'`o'"' != "" {
		Estimate `0'
	}
	else	_prefix_display `0'

end

program Estimate, eclass
	// check syntax
	syntax [anything] [using] [if] [in]		///
		[fw pw iw][,	 			///
		Stat(passthru)				///
		STRata(passthru)			///
		MSE					///
		SINGLEunit(passthru)			///
		Level(cilevel)				///
		notable					///
		TItle(string asis)			///
		noHeader				///
		noLegend				///
		Verbose					///
		*					///
	]

	if "`weight'" != "" {
		local wgt `"[`weight'`exp']"'
	}

	_get_diopts diopts, `options'
	local diopts	`diopts'	///
			`table'		///
			`header'	///
			`legend'	///
			`verbose'	///
			level(`level')	///
			// blank

	// compute results
	_jk_sum `anything' `using' `wgt' `if' `in',	///
		`stat' `strata' `mse' `singleunit'

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
		ereturn local vcetype	"Jackknife"
	}
	else {
		ereturn local vcetype	"Jknife *"
	}
	ereturn local vce	jackknife
	ereturn local mse	`mse'
	ereturn hidden local predict _no_predict
	if "`e(cmd)'" == "" {
		ereturn local cmd jackknife
	}
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		ereturn local title "Jackknife results"
	}

	// display results
	_prefix_display, `diopts'
end

exit
