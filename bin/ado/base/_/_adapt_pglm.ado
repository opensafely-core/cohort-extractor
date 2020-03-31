*! version 1.0.7  17jun2019
/*
	Adaptive Lasso for generalized linear model
*/
program _adapt_pglm, eclass
	version 16.0
	syntax anything 		///
		[if] [in] 		///
		, 			///
		[penaltywt(passthru)	/// lasso penalty for the first step
		alasso(passthru)	/// adaptive lasso step
		wgt(string)		///
		laout(string)		///
		nodebug			///
		ridge			///
		nosamegroup		///
		unpenalized		///
		nolog			///
		ratioseq(passthru)	/// not documented
		*]			//  other options in _pglm

	local state = c(rngstate)
	if (`"`samegroup'"' != "nosamegroup") {
		local set_state set rngstate `state'	
	}
						//  touse
	marksample touse	
						//  laout
	_lasso_parse_laout `laout'
	local laout_name `s(laout_name)'
	local laout_isreplace `s(laout_isreplace)'
						//  lasso step
	ParseAlassoStep, `alasso'
	local alasso `s(alasso)'
						//  ridge
	if (`"`ridge'"' != "") {
		local alphas alphas(0)
		local adapt_ridge adapt_ridge
	}
						// ratio sequence
	ParseRatioSeq, `ratioseq'
	local ratio1  `s(ratio1)'
	local ratio2  `s(ratio2)'
						//  options for each steps
	local options `options' adapt `log' `adapt_ridge'
	local step1_opts `penaltywt' `options' nodisplay	///
		`alphas' `unpenalized' `ratio1'
	local step2_opts `options' nodisplay `ratio2'
						//  first step lasso
	ShowLog, `log' i(1) alasso(`alasso')

	tempname out1 selected_pfactor
	`set_state'
	_pglm `anything' `if' `in' `wgt', `step1_opts' 	///
		laout(`out1', replace) nopost
	local laout_list `out1'
	local selected_indeps `e(allvars_sel)'
	mat `selected_pfactor' = e(selected_pfactor)
	local preklp = e(n_lambda)
	local model `e(model)'
	local err_cv = e(err_cv)
						//  cox model do not need depvar
	if (`"`model'"' == "cox") {
		local depvar 
	}
	else if (`"`model'"' == "linear") {
		local depvar `e(depvar_var)'
	}
	else {
		local depvar `e(depvar)'
	}

						//  adaptive lasso step 
	forvalues i=2/`alasso'{
		local full_allin = e(full_allin)
		if (`"`selected_indeps'"'!="" & !`full_allin' & !`err_cv') {
		
			ShowLog, `log' i(`i') alasso(`alasso')

			tempname out_aux
			`set_state'
			_pglm `model' `depvar' `selected_indeps' 	///
				if e(sample) `wgt', 			///
				penaltywt(`selected_pfactor') 		///
				`step2_opts'   				///
				adaptstep(`i')				///
				laout(`out_aux', replace)		///
				preklp(`preklp')			///
				nopost
			local selected_indeps `e(allvars_sel)'
			mat `selected_pfactor' = e(selected_pfactor)
			local preklp = `preklp' + e(n_lambda)
			local laout_list `laout_list' `out_aux'
		}
	}
	`set_state'
						//  merge laout results
	mata : _LASYS_merge(		///
		"`laout_list'", 	///
		`"`laout_name'"',	///
		`laout_isreplace',	///
		`"`touse'"')
						// display results
	_pglm_display, `debug'
end
					//----------------------------//
					// parse adaptive lasso step
					//----------------------------//
program ParseAlassoStep, sclass
	syntax [, alasso(numlist integer min=1 max=1 >=1)]

	if (`"`alasso'"' == "") {
		local alasso = 2
	}
	sret local alasso = `alasso'
end
					//----------------------------//
					// show adaptive lasso log
					//----------------------------//
program ShowLog
	syntax [, nolog i(string) alasso(string)]

	if (`"`log'"' == "nolog") {
		exit
		// NotReached
	}

	di
	di "{p 0 2 2}"
	di as txt "Lasso step " 	///
		as res `i'  		///
		as txt " of " 		///
		as res "`alasso'"	///
		as txt ":"
	di "{p_end}"
end

					//----------------------------//
					// Parse ratio sequence
					//----------------------------//
program ParseRatioSeq, sclass
	syntax [, ratioseq(string)]

	if (`"`ratioseq'"' == "") {
		exit
		// NotReached
	}

	local k : list sizeof ratioseq

	if (`k' == 1) {
		local ratio1 `ratioseq'
		local ratio2 `ratio1'
	}
	else if (`k' == 2) {
		gettoken ratio1 ratio2 : ratioseq

	}
	else {
		di as err "option {bf:ratioseq()} allows maximum two integers"
		exit 198
	}

	sret local ratio1 grid(, ratio(`ratio1'))
	sret local ratio2 grid(, ratio(`ratio2'))
end
