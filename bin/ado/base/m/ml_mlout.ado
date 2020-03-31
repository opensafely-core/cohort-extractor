*! version 6.4.0  03jun2009
program define ml_mlout
	version 8
	if _caller() < 9 {
		ml_mlout_8 `0'
		exit
	}
	if "`e(cmd)'" == "" | "`e(opt)'"!="ml" { 
		error 301
	}
	if "`e(svyml)'" != "" | "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [,			///
		Level(cilevel) 		///
		PLus			///
		noHeader		///
		First			///
		SHOWEQns		///
		NEQ(integer -1)		///
		noFOOTnote		///
		NOSKIP			///
		NOCNSReport		///
		TItle(passthru)		/// not to be documented
		NOTEST			///
		*			/// -eform/diparm- options
	]

	_get_diopts diopts options, `options'
	if "`plus'" != "" {
		local footnote nofootnote
	}

	if `neq' >= 0 {
		local neqopt neq(`neq')
	}
	// check syntax elements in `options'
	_get_eformopts , eformopts(`options') soptions allowed(__all__)
	local eform `s(eform)'
	// `diparm' should only contain -diparm()- options
	local diparm `s(options)'
	_get_diparmopts , diparmopts(`diparm') level(`level')

	if "`header'"=="" {
		_coef_table_header, `title'
		di
	}

	// display the table of results
	_coef_table, `first' level(`level') `neqopt' `plus' ///
		`noskip' `showeqns' `nocnsreport' `options' `notest' ///
		`diopts'

	if "`footnote'" == "" {
		ml_footnote
	}
end

exit
