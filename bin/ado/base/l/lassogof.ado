*! version 1.0.2  16sep2019
/*
	lassogof
*/
program lassogof
	version 16.0

	syntax [anything(name=names)]  [if] [in] [, *]
						//  hold current e()
	tempname current_est
	cap _est hold `current_est', copy restore
	local rc0 = _rc
						//  do fit computation
	cap noi Fit `names' `if' `in', `options' current_est(`current_est')
	local rc = _rc
						//  unhold old e()
	if (`rc0' ==0) _est unhold `current_est'
						//  exit if error out
	if (`rc') exit `rc'
end
					//----------------------------//
					// evaluate prediction performance
					//--------------------------//
program Fit
	syntax [anything(name=names)]  [if] [in] 	///
		[, * current_est(passthru) ]
	
	if (`"`names'"' != "") {
		Fit_list `0'
	}
	else {
		Fit_u `if' `in', `options'
	}

	Display
end
					//----------------------------//
					// fit names
					//----------------------------//
program Fit_list, rclass
	syntax anything(name=names)  [if] [in] [, * current_est(string)]
	
	tempname dev dev_k

	if (`"`names'"' == "_all" | `"`names'"' == "*") {
		qui est dir
		local names `r(names)'
	}

	local default .
	est_expand `"`names'"', default(`default')
	local names `r(names)'
	local names : list uniq names

	local not_linear = 0
	foreach laout of local names {
		PostLaout `laout', current_est(`current_est')
		Fit_u `if' `in', `options' laout(`laout') 
		mat `dev_k' = r(table)
		mat `dev' = (nullmat(`dev') \ `dev_k')
		if (`"`r(model)'"' != "linear") {
			local not_linear = `not_linear' + 1	
		}
		local over_var `r(over_var)'
		local over_levels `r(over_levels)'
		local postselection `r(postselection)'
		
		if (`"`laout'"' == "`default'") {
			_est hold `current_est'
		}
	}

	if (`not_linear' == 0) {
		local model linear
	}

	if (`not_linear') {
		matrix colname `dev' = dev dev_ratio n_obs
	}

	ret hidden local model `model'
	ret mat table = `dev'
	ret local names `names'
	ret local over_var `over_var'
	ret local over_levels `over_levels'
	ret hidden local postselection `"`postselection'"'
end
					//----------------------------//
					// fit only one laout
					//----------------------------//
program Fit_u, rclass sortpreserve
						//  check if it is valid e(cmd)
	if (`"`e(cmd)'"' != "lasso" &		///
		`"`e(cmd)'"' != "sqrtlasso" &	///
		`"`e(cmd)'"' != "elasticnet" &	///
		`"`e(cmd)'"' != "regress" &	///
		`"`e(cmd)'"' != "logit" &	///
		`"`e(cmd)'"' != "probit" &	///
		`"`e(cmd)'"' != "poisson" &	///
		`"`e(cmd)'"' != "cox" ) {
		error 301
	}
						//  syntax
	syntax 	[if] [in] 		///
		[, noWEIGHTs 		///
		over(varname) 		///
		laout(string) 		///
		POSTselection		///
		PENalized]
	
	if (`"`penalized'"' != "" & `"`postselection'"' != "") {
		di as err "only one of {bf:postselection} or "	///
			"{bf:penalized} is allowed"
		exit 198
	}

	if (`"`e(model)'"' == "linear" | `"`e(cmd)'"' == "regress") {
		local model linear
	}

						//  mark sample
	marksample touse
	markout `touse' `e(depvar)' `e(allvars_sel)' `e(wvar)'
	tempvar orig_touse 
	qui gen `orig_touse' = `touse'
						//  sort cox data if necessary
	SortCoxData, touse(`touse')
						//  parse over
	tempname over_val
	if (`"`over'"' != "") {
		qui tabulate `over', matrow(`over_val')	
		local is_over = 1
		local over_lb : value label `over'
	}
	else {
		tempvar over
		mat `over_val' = 1
		qui gen `over' = 1 if `orig_touse'
		local is_over = 0
	}
	local k : rowsof `over_val'

	tempname dev
						//  get dev over variable
	forvalues i=1/`k' {
		qui replace `touse' = `orig_touse'
		local val_k  = `over_val'[`i', 1]
		qui replace `touse' = 0 if `over' != `val_k' 

		mata : lasso_fit(`"`touse'"', `"`weights'"', "`postselection'")

		mat `dev' = nullmat(`dev') \ r(dev_table)

		if (`"`over_lb'"' != "") {
			local lb_k : label `over_lb' `val_k'
		}
		else {
			local lb_k `val_k'
		}
		local over_levels `over_levels' `lb_k'

	}

	ret matrix table = `dev'

	if (`is_over') {
		ret local over_var `over'
		ret local over_levels `over_levels'
	}

	ret hidden local postselection `"`postselection'"'
	ret hidden local model `model'
end
					//----------------------------//
					// PostLaout
					//----------------------------//
program PostLaout
	syntax anything(name=laout)	///
		[, current_est(string)	]
	
	local default .

	if (`"`laout'"' == "`default'") {
		qui _est unhold `current_est'
	}
	else {
		qui est restore `"`laout'"' , nostxerfile
	}
end
					//----------------------------//
					// Display
					//----------------------------//
program Display

	local default .

	mata : st_lasso_fit_display(	///
		`"r(table)"',		///
		`"`r(names)'"',		///
	 	`"`r(over_var)'"',	///
		`"`r(over_levels)'"',	///
		`"`r(postselection)'"',	///
		`"`r(model)'"',		///
		`"`default'"')
end
					//----------------------------//
					// SortCoxData
					//----------------------------//
program  SortCoxData
	syntax , touse(string)
	
	if (`"`e(model)'"' != "cox" ) {
		exit
		// NotReached
	}

	tempvar dinv
	gen byte `dinv' = cond(_d, 0, 1)
	sort _t `dinv' _t0, stable
						//  markout again
	markout `touse' _t _t0 _d _st
end
