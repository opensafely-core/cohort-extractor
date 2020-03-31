*! version 1.0.2  13may2019
program _dslasso_select
	version 16.0

	if ( `"`e(cmd)'"' != "dsregress" &	///
		`"`e(cmd)'"' != "dslogit" &	///
		`"`e(cmd)'"' != "dspoisson" &	///
		`"`e(cmd)'"' != "poregress" &	///
		`"`e(cmd)'"' != "xporegress" &	///
		`"`e(cmd)'"' != "pologit" &	///
		`"`e(cmd)'"' != "xpologit" &	///
		`"`e(cmd)'"' != "popoisson" &	///
		`"`e(cmd)'"' != "xpopoisson" &	///
		`"`e(cmd)'"' != "poivregress" &	///
		`"`e(cmd)'"' != "xpoivregress" ) {
		error 301
	}

	Select `0'
end

					//----------------------------//
					// Select
					//----------------------------//
program Select, eclass
	syntax [anything(equalok name=expr)]	///
		[, 				///
		for(passthru)			///
		XFOLD(passthru)		///
		resample(passthru)		///
		*]

	_lasso_check_for, estat_cmd(lassoselect) `for' `xfold' `resample'
	
	tempname  est_current

	_est hold `est_current', copy restore
	
	_lasso_est_for, `for' `xfold' `resample'
	local subspace `r(subspace)'

	esrf default_filename
	local laout `s(stxer_default)'

 	tempvar touse 
 	qui gen `touse' = e(sample)
 						// post e() from subspace
	esrf post `laout', subspace(`subspace')
	ereturn repost, esample(`touse')
						//  do select
	_lasso_select `expr', subspace(`subspace') `options' nopostsel

/*
	  note: The stxer file get updated. But the e() results for dslasso has
	  	not been updated yet at this point.

		To update e(), run -dslasso, reestimate-
*/
end
