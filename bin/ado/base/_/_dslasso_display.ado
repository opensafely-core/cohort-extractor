*! version 1.0.6  13jun2019
program _dslasso_display
	version 16.0

	syntax [, verbose 	///
		dslog		///
		noheader	///
		or		///
		irr		///
		coef		///
		*]
	
	_dslasso_display_opts, `or' `irr' `coef'
	local coef_opts `s(coef_opts)'

	_get_diopts diopts , `options'
						//  title
	local title as txt "`e(title)'"

	local col = 39
						//  nobs
	local nobs _col(`col') as txt "Number of obs" _col(67) "="	///
		_col(69) as res %10.0fc e(N)
						//  number of controls
	local k_controls _col(`col') as txt "Number of controls"	///
		_col(67) "=" _col(69) as res %10.0fc e(k_controls)
						//  number of selected controls
	local k_controls_sel _col(`col') as txt	///
		"Number of selected controls" ///
		_col(67) "=" _col(69) as res %10.0fc e(k_controls_sel)

						// display 
	if (`"`e(subspace_list)'"' == "") {
		// do nothing
	}
	else if (`"`verbose'"' == "" & `"`dslog'"' == "" ) {
		di
	}
 	else if (`"`verbose'"' == "" & `"`dslog'"' != "") {
 		di
 	}

	if (`"`header'"' != "noheader") {
		di `title' `nobs'
		di `k_controls'
		di `k_controls_sel'
		_dslasso_di_wald, col(`col')
		di 
	}

	_coef_table, `diopts' `coef_opts'
	_dslasso_chi2note
end

