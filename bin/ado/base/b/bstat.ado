*! version 3.4.1  29feb2012
program bstat, eclass
	// version control
	if _caller() < 9 {
		bstat_8 `0'
		exit
	}
	local vv : di "version " string(_caller()) ", missing:"

	version 9

	if !inlist("bootstrap",`"`e(cmd)'"',`"`e(prefix)'"') {
		Estimate `0'
		exit
	}

	syntax [anything] [using/] [if] [in] [, 	///
		accel(passthru)				///
		Stat(passthru)				///
		n(passthru)				///
		*					///
	]

	if `"`anything'`using'`if'`in'`accel'`stat'`n'"' != "" {
		`vv' Estimate `0'
		ereturn local cmdline `"bstat `0'"'
	}
	else	_prefix_display `0'
end

program Estimate, eclass
	local vv : di "version " string(_caller()) ", missing:"
	version 9
	// check syntax
	syntax [anything] [using] [if] [in] [,	 	///
		accel(passthru)				///
		Stat(passthru)				///
		MSE					///
		Level(cilevel)				///
		n(passthru)				///
		notable					///
		TItle(string asis)			///
		noHeader				///
		noLegend				///
		Verbose					///
		TIEs					///
		*					///
	]

	_get_diopts diopts, `options'
	local diopts	`diopts'	///
			`table'		///
			`header'	///
			`legend'	///
			`verbose'	///
			level(`level')	///
			// blank

	// compute results
	`vv' _bs_sum `anything' `using' `if' `in', ///
		`accel' `stat' `n' `mse' `ties' level(`level')

	// save results
	tempname b V
	matrix `b' = r(b)
	matrix `V' = r(V)
	ereturn post `b' `V', obs(`r(N)')
	_r2e, xmat(b V)
	_post_vce_rank
	ereturn scalar k_extra = 0
	ereturn scalar k_aux = 0
	ereturn hidden local predict _no_predict
	ereturn local prefix bootstrap
	ereturn local cmd bstat
	if `"`title'"' != "" {
		ereturn local title `"`title'"'
	}
	else {
		ereturn local title "Bootstrap results"
	}

	// display results
	_prefix_display, `diopts'
end

exit
