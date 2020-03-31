*! version 1.0.6  13jun2019
program _poivlasso_display
	version 16.0 

	syntax [,* verbose dslog noheader irr or coef]

	_dslasso_display_opts, `or' `irr' `coef'
	local coef_opts `s(coef_opts)'

	_get_diopts diopts , `options'
						//  title
	local title as txt "`e(title)'"
						// title2
	if (`"`e(title2)'"' != "") {
		local title2 as txt "`e(title2)'"
	}

	local col = 36
						//  nobs
	local nobs _col(`col') as txt "Number of obs" _col(67) "="	///
		_col(69) as res %10.0fc e(N)
						//  number of controls
	local k_controls _col(`col') as txt "Number of controls"	///
		_col(67) "=" _col(69) as res %10.0fc e(k_controls)

						//  number of instruments
	local k_inst _col(`col') as txt "Number of instruments"	///
		_col(67) "=" _col(69) as res %10.0fc e(k_inst)

						//  number of sel. controls
	local k_controls_sel _col(`col') as txt	///
		"Number of selected controls" 		///
		_col(67) "=" _col(69) as res %10.0fc e(k_controls_sel)

						//  number of sel. instruments
	local k_inst_sel _col(`col') as txt 		///
		"Number of selected instruments" 	///
		_col(67) "=" _col(69) as res %10.0fc e(k_inst_sel)

						//  number of crossfit
	local crossfit _col(`col') as txt "Number of folds in cross-fit"  ///
		_col(67) "=" _col(69) as res %10.0fc e(n_xfolds)

						//  number of resampling
	local resample _col(`col') as txt "Number of resamples"	///
		_col(67) "=" _col(69) as res %10.0fc e(n_resample)


						// display 
	if (`"`e(subspace_list)'"' == "") {
		// do nothing
	}
	else if (`"`verbose'"' == "" & `"`dslog'"' == "") {
		di
	}
 	else if (`"`verbose'"' == "" & `"`dslog'"' != "") {
 		di
 	}

	if (`"`header'"' != "noheader") {
		di `title' `nobs'
		di `title2' `k_controls'
		di `k_inst'
		di `k_controls_sel'
		di `k_inst_sel'
		if (e(n_xfolds)>1) {
			di `crossfit'
			di `resample'
		}
		_dslasso_di_wald, col(`col')
		di
	}

	_coef_table, `diopts' `coef_opts'
	Footnote
	_dslasso_chi2note
end

					//----------------------------//
					// footnote
					//----------------------------//
program Footnote
	if (`"`e(endog)'"' == "") {
		di as text "(no endogenous regressors)"
		exit
		// NotReached
	}

	local endog `e(endog)'
	local exog `e(exog)'

	di as smcl "{p2colset 0 15 15 2}{...}"
	di as smcl "{text}{p2col: Endogenous:}`endog'{p_end}" 
	if (`"`exog'"' != "") {
		di as smcl "{text}{p2col: Exogenous:}`exog'{p_end}"
	}
	di as smcl "{p2colreset}{...}"
end
