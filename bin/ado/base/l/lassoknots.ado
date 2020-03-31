*! version 1.0.7  28jan2020
program lassoknots
	version 16.0

	laout_estat check_cmd
	KnotTable `0'
end

					//----------------------------//
					// display Knottable
					//----------------------------//
program KnotTable, rclass
	syntax [, for(passthru)		///
		XFOLD(passthru)		///
		resample(passthru)	///
		DIsplay(string)		///
		steps			///
		ALLlambdas		///
		NOLSTRETCH		///
		LSTRETCH		///
	]

	opts_exclusive "`lstretch' `nolstretch'"

	ParseFor, `for' `xfold' `resample'
	local subspace `r(subspace)'
	
	ParseDisplay, `display' subspace(`subspace')
	local di_all `s(di_all)'

	ParseSteps, `steps'
	local allsteps `s(allsteps)'

	ParseAll, `alllambdas'
	local is_all = `s(is_all)'

	mata : st_lasso_knots(		///
		`"`subspace'"',		///
		`"`di_all'"',		///
		`"`allsteps'"',		///
		`is_all')
end

					//----------------------------//
					// parse display
					//----------------------------//
program ParseDisplay, sclass
	syntax [, NONZero	///
		cvmpe 		///
		cvmd		///
		CVDEVratio	///
		osr2		///
		bic		///
		r2		///
		DEVratio	///
		l1		///
		l2		///
		VARiables 	///
		subspace(passthru)]

	esrf default_filename
	local fn `s(stxer_default)'

	local di_cv `cvmpe' `cvmd'
	local di_cvdevratio `cvdevratio' `osr2'
	local di_dev `r2' `devratio'
	local di_all `nonzero' `di_cv' `di_cvdevratio'	///
		`di_dev' `bic' `l1' `l2' `variables'

	esrf get cv : e(cv), `subspace' using(`fn')
	esrf get model : e(model), `subspace' using(`fn')
	esrf get method : e(lasso_selection), `subspace' using(`fn')


					// parse di_cv
	if (!`cv' & "`di_cv'" != "") {
		di as err "option {bf:`di_cv'} not allowed when no "	///
			"cross-validation result is found"
		exit 198
	}

	local n_di_cv : list sizeof di_cv
	if (`n_di_cv' == 2) {
		di as err "only one of {bf:cvmpe} or {bf:cvmd} can be " ///
			"specified"
		exit 198
	}
					// parse di_cvdevratio
	if ("`model'" != "linear" & "`di_cvdevratio'" == "osr2") {
		di as err "option {bf:osr2} cannot be specified " ///
			"for `model' model"
		exit 198
	}

	if (!`cv' & "`di_cvdevratio'" != "") {
		di as err "option {bf:`di_cvdevratio'} not allowed when no " ///
			"cross-validation result is found"
		exit 198
	}

	local n_di_cvdevratio : list sizeof di_cvdevratio
	if (`n_di_cvdevratio' == 2) {
		di as err "only one of {bf:cvdevratio} or {bf:osr2} can be " ///
			"specified"
		exit 198
	}

	if ("`model'" != "linear" & "`di_cv'" == "cvmpe") {
		di as err "option {bf:cvmpe} cannot be specified " ///
			"for `model' model"
		exit 198
	}


					// parse di_dev
	local n_di_dev : list sizeof di_dev
	if (`n_di_dev' == 2) {
		di as err "only one of {bf:r2} or {bf:devratio} can be " ///
			"specified"
		exit 198
	}

	if ("`model'" != "linear" & "`di_dev'" == "r2") {
		di as err "option {bf:r2} cannot be specified " ///
			"for `model' model"
		exit 198
	}
					// parse di_all
	if ("`di_all'"' == "") {
		if (!`cv') {
			if (`"`model'"' == "linear") {
				local di_all nonzero r2 variables
			}
			else {
				local di_all nonzero devratio variables
			}
		}
		else if (`"`model'"' == "linear") {
			local di_all nonzero cvmpe variables
		}
		else {
			local di_all nonzero cvmd variables
		}
	}

	local n_di_all : list sizeof di_all
	if (`n_di_all' > 3) {
		di as err "too many options specified"

		di "{p 4 4 2}"
		di as err "only 3 options of {bf:nonzero}, "	///
			"{{bf:cvmpe} | {bf:cvmd}}, "		///
			"{{bf:cvdevratio} | {bf:osr2}}, "	///
			"{bf:bic}, "				///
			"{{bf:r2} | {bf:devratio}}, "		///
			"{bf:l1}, {bf:l2}, or {bf:variables} "	///
			"can be specified in {bf:display()}"
		di "{p_end}"
		exit 198
	}

	sret local di_all `di_all'
end
					//----------------------------//
					// Parse for
					//----------------------------//
program ParseFor
	syntax , [for(passthru)		///
		xfold(passthru)		///
		resample(passthru) ]
	
	if (`"`e(lasso_infer)'"' != "") {
		_lasso_check_for, estat_cmd(lassoknots) `for' `xfold' `resample'
		_lasso_est_for , `for' `xfold' `resample'
	}
	else if (`"`for'"' != "" |	///
		`"`xfold'"' != "" |	///
		`"`resample'"' != "") {
		di as err "options {bf:for()}, {bf:xfold()}, or "	///
			"{bf:resample()} not allowed"
		exit 198
	}
end
					//----------------------------//
					// parse all
					//----------------------------//
program ParseAll, sclass
	syntax [, alllambdas] 

	if (`"`alllambdas'"' != "") {
		local is_all = 1
	}
	else {
		local is_all = 0
	}

	sret local is_all = `is_all'
end
					//----------------------------//
					// parse steps
					//----------------------------//
program ParseSteps, sclass
	syntax [, steps]

	esrf default_filename
	local fn `s(stxer_default)'

	esrf get model : e(model), `subspace' using(`fn')
					// parse steps
	if (`"`method'"' != "adaptive" & `"`steps'"' != "") {
		di as err "option {bf:steps} can only be specified " ///
			"for {bf:selection(adaptive)}"
		exit 198
	}

	if (`"`steps'"' == "") {
		local allsteps
	}
	else {
		local allsteps allsteps
	}
	
	sret local allsteps `allsteps'
end

