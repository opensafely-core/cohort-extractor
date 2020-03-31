*! version 1.0.17  19jun2019
/*
	double selection Lasso
*/
program _dslasso
	version 16.0
					// do main work
	cap noi {
		syntax [anything(everything)] [, reestimate *]

		if (`"`reestimate'"' == "") {
			Estimate `0'
		}
		else {
			ReEstimate 
		}
	}
	local rc_now = _rc
					// clean e() if error happens
	nobreak _dslasso_clean, rc_now(`rc_now') 
end

					//----------------------------//
					// Re-estimate
					//----------------------------//
program ReEstimate

	if (`"`e(cmd)'"' != "dsregress" &	///
		`"`e(cmd)'"' != "dslogit" &	///
		`"`e(cmd)'"' != "dspoisson" ) {
		error 301	
	}

	_dslasso_begin_rngstate
	local state `s(state)'

	cap noi {
		local zero `e(zero)'
	
		local is_comma = ustrpos(`"`zero'"', ",")
	
		local reest reestimate
		local zero : list zero - reest
	
		if (`is_comma') {
			Estimate `zero' reestimate
		}
		else {
			Estimate `zero' , reestimate
		}
	}

	local rc = _rc
	_dslasso_end_rngstate, state(`state') rc(`rc')
end

					//----------------------------//
					// Estimate
					//----------------------------//
program Estimate

	local zero `0'

	syntax anything(name=eq)	///
		[if] [in] ,		///
		cmd(string)		///
		model(string)		///
		[ controls(passthru)	///
		cmdline(passthru)	///
		vce(string)		///
		common_opts(passthru)	///
		sqrtlasso		///
		qui			///
		reestimate		///
		noconstant		///
		vcetype(string)		///
		cluster(string)		///
		tolerance(passthru)	///
		rseed(passthru)		///
		verbose			///
		dslog			///
		offset(passthru)	///
		exposure(passthru)	///
		noHEADer		///
		MISSingok		///
		*]

	/*----------------- parsing -------------------------------*/
						// rseed
	_lasso_rseed, `rseed'
						// rngstate
	_lasso_rngstate
	local rngstate `s(rngstate)'
						// diopts	
	_get_diopts diopts options, `options'
	
	marksample touse
						//  parse varlist and options	
	_dslasso_parse `eq',	///
		`controls'	///
		`common_opts'	///
		`sqrtlasso'	///
		model(`model')	///
		`options'	
	local depvar `s(depvar)'
	local Dvars `s(Dvars)'
	local Xvars `s(Xvars)'
	local raw_Xvars `s(raw_Xvars)'
	local full_lasso_names `s(full_lasso_names)'
	local full_lasso_cmds `s(full_lasso_cmds)'
	local full_lasso_opts `s(full_lasso_opts)'
	local dvars_omit `s(dvars_omit)'
	local dvars_full `s(dvars_full)'
	local irr_or `s(irr_or)'
	local lasso_noneed `s(lasso_noneed)'
	local eq `s(eq)'
						//  parse laout	
	_lasso_parse_laout
	local laout_name `s(laout_name)'
	local laout_replace `s(laout_replace)'

						//  markout 	
	_dslasso_missingok,		///
		`missingok'		///
		touse(`touse') 		///
		depvar(`depvar')	///
		dvars(`Dvars')		///
		nuisance(`raw_Xvars')

	/*----------------- double selection -------------------------*/
						// begin dslog
	_dslasso_dslog_di, `dslog'

	DoubleSelect, model(`model')			///
		touse(`touse')				///
		depvar(`depvar')			///
		tt_vars(`Dvars')			///
		controls(`Xvars')			///
		full_lasso_cmds(`full_lasso_cmds')	///
		full_lasso_names(`full_lasso_names')	///
		full_lasso_opts(`full_lasso_opts')	///
		laout_name(`laout_name')		///
		laout_replace(`laout_replace')		///
		`qui' vce(`vce') `reestimate' 		///
		`constant'				///
		`tolerance'				///
		`offset'				///
		`exposure'				///
		eq(`eq')				///
		lasso_noneed(`lasso_noneed')
	local new_controls `s(new_controls)'
	local subspace_list `s(subspace_list)'

	/*----------------- post results -------------------------*/
	nobreak PostResult, 				///
		cmd(`cmd')				///
		`cmdline'				///
		model(`model')				///
		touse(`touse')				///
		depvar(`depvar')			///
		tt_vars(`Dvars')			///
		raw_controls(`raw_Xvars')		///
		full_lasso_names(`full_lasso_names')	///
		laout_name(`laout_name')		///
		new_controls(`new_controls')		///
		subspace_list(`subspace_list')		///
		vce(`vce')				///
		vcetype(`vcetype')			///
		cluster(`cluster')			///
		zero(`zero')				///
		`rngstate'				///
		`offset'				///
		`exposure'				///
		dvars_omit(`dvars_omit')		///
		dvars_full(`dvars_full')		///
		lasso_noneed(`lasso_noneed')

	/*----------------- display results -------------------------*/
	_dslasso_display , `diopts' `verbose' `dslog' `header' `irr_or'
end

					//----------------------------//
					// double selection
					//----------------------------//
program DoubleSelect
	syntax , model(string) [*]

	if (`"`model'"' == "linear") {
		DoubleSelectLinear , model(`model') `options'
	}
	else if (`"`model'"' == "logit" | `"`model'"' == "poisson" ) {
		DoubleSelectGLM , model(`model') `options'
	}
end
					//----------------------------//
					// linear double selection
					//----------------------------//
program DoubleSelectGLM, sclass
	syntax [, model(string)			///
		touse(string)			///
		depvar(string)			///
		tt_vars(string)			///
		controls(string)		///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		qui				///
		reestimate			///
		noconstant			///
		vce(passthru)			///
		offset(passthru)		///
		exposure(passthru)		///
		lasso_noneed(string)		///
		eq(string)			///
		tolerance(passthru)]
	
						// get est_cmd
	GetEstCmd, model(`model')
	local est_cmd `s(est_cmd)'
	
	/*----------------------- case 1: no controls ----------------*/
	if (`lasso_noneed') {
		`qui' `est_cmd' `eq' if `touse',	///
			`vce' `constant' `tolerance' `offset' `exposure'
		exit
		// NotReached
	}

	/*----------------------- case 2: double selection----------------*/
	_parse expand cmds tmp : full_lasso_cmds
	_parse expand names tmp : full_lasso_names
	_parse expand opts tmp : full_lasso_opts

	forvalues i=1/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
						//  initialize subspace_list 
		_lasso_add_subspace, 		///
			`laout_name' 		///
			`laout_replace'		///
			opt(`opt')		///
			`reestimate'		///
			subspace_list(`subspace_list')
		local opt `s(opt)'
		local subspace_list `s(subspace_list)'

		if ("`var'" == "`depvar'") {
/*
	step 1: lasso y on X and D (nonlinear)
*/
			`cmd' `model' `var' `controls' `tt_vars'  	///
				if `touse', `opt' `offset' `exposure'

			local sel_XD `e(allvars_sel)'
			local selected_vars `e(allvars_sel)'
						//  get weight
			tempvar wvar
			`qui' GetWeight, depvar(`var') indeps(`sel_XD')	///
				touse(`touse') est_cmd(`est_cmd')	///
				wvar(`wvar') model(`model') 		///
				tt_vars(`tt_vars') `tolerance'		///
				`offset' `exposure'
		}
		else {
/*
	step 2: lasso D on X with iw=wvar
*/
			tempvar tmp_var
			qui gen double `tmp_var' = `var' if `touse'
			`cmd' linear `tmp_var' `controls' if `touse' 	///
				[iw=`wvar'],  `opt' depname(`var')
			local selected_vars `e(allvars_sel)'
		}
		
		local selected_vars : list selected_vars - tt_vars

/*
	step 3: merge selected X
*/
		if ("`selected_vars'" != "") {
			local new_controls :list new_controls | selected_vars
		}
	}
	local new_controls : list sort new_controls

/*
	step 4: glm y on selected X 
*/
	`qui' `est_cmd' `depvar' `tt_vars' `new_controls' if `touse'	///
		, `vce' `constant' `tolerance' `offset' `exposure'

	sret local new_controls `new_controls'
	sret local subspace_list `subspace_list'
end

					//----------------------------//
					// linear double selection
					//----------------------------//
program DoubleSelectLinear, sclass
	syntax [, model(string)			///
		touse(string)			///
		depvar(string)			///
		tt_vars(string)			///
		controls(string)		///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		qui				///
		reestimate			///
		noconstant			///
		lasso_noneed(string)		///
		eq(string)			///
		vce(passthru)]
	
	/*----------------------- case 1: no controls ----------------*/
	if (`lasso_noneed') {
		`qui' regress `eq' if `touse', `vce' `constant'
		exit
		// NotReached
	}

	/*----------------------- case 2: double selection----------------*/
	_parse expand cmds tmp : full_lasso_cmds
	_parse expand names tmp : full_lasso_names
	_parse expand opts tmp : full_lasso_opts

	forvalues i=1/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
						//  initialize subspace_list 
		_lasso_add_subspace, 		///
			`laout_name' 		///
			`laout_replace'		///
			opt(`opt')		///
			`reestimate'		///
			subspace_list(`subspace_list')
		local opt `s(opt)'
		local subspace_list `s(subspace_list)'

		if ("`var'" == "`depvar'") {
/*
	step 1: lasso y on X (linear)
		or lasso y on X and D (nonlinear)
*/
			`cmd' linear `var' `controls' if `touse', `opt'
		}
		else {
/*
	step 2: lasso D on X
*/
			tempvar tmp_var
			qui gen double `tmp_var' = `var' if `touse'
			`cmd' linear `tmp_var' `controls' if `touse', 	///
				`opt' depname(`var')
		}
		local selected_vars `e(allvars_sel)'
		local selected_vars : list selected_vars - tt_vars

/*
	step 3: merge selected X
*/
		if ("`selected_vars'" != "") {
			local new_controls :list new_controls | selected_vars
		}
	}
	local new_controls : list sort new_controls

/*
	step 4: glm y on selected X
*/
	`qui' regress `depvar' `tt_vars' `new_controls' if `touse', 	///
		`vce' `constant'

	sret local new_controls `new_controls'
	sret local subspace_list `subspace_list'
end
					//----------------------------//
					// post double selection
					//----------------------------//
program PostResult, eclass
	syntax , model(string)			///
		touse(string)			///
		depvar(string)			///
		cmd(string)			///
		tt_vars(string)			///
		[new_controls(string)		///
		cmdline(string)			///
		full_lasso_names(string)	///
		raw_controls(string)		///
		laout_name(string)		///
		zero(string)			///
		vce(string)			///
		vcetype(string)			///
		cluster(string)			///
		rngstate(string)		///
		offset(string)			///
		exposure(string)		///
		subspace_list(string) 		///
		dvars_omit(passthru)		///
		lasso_noneed(string)		///
		dvars_full(passthru)]
	
	tempname b V b_full V_full
	mat `b_full' = e(b)
	mat `V_full' = e(V)
						//  select submatrix for tt_vars
	if (!`lasso_noneed') {
		local k_tt : list sizeof tt_vars
	}
	else {
		local k_tt : colsof `b_full'
		local k_tt = `k_tt' - 1
	}
	mat `b' = `b_full'[1, 1..`k_tt']
	mat `V' = `V_full'[1..`k_tt', 1..`k_tt']
	local n_obs = e(N)
						//  vce	
	local vce `vce'
	local vcetype `vcetype'
	local clusterv `cluster'
						//  post results
	eret post `b' `V', depname(`depvar') obs(`n_obs') esample(`touse')

						//  add dummy variables
	_dslasso_stripe_b , `dvars_omit' `dvars_full' 	///
		lasso_noneed(`lasso_noneed')
	eret scalar k_varsofinterest = `k_tt'
	eret local controls_sel `new_controls'
	eret local varsofinterest `tt_vars'
	eret scalar k_controls =`:list sizeof raw_controls'
	eret scalar k_controls_sel =`:list sizeof new_controls'
	eret local controls `raw_controls'
	eret local model `model'
	eret local vce `vce'
	eret local vcetype `vcetype'
	eret local clusterv `clusterv'
	if ("`model'" == "poisson") {
		local tit_model Poisson
	}
	else {
		local tit_model `model'
	}
	eret local title "Double-selection `tit_model' model"
	eret local offset `offset' 
	if (`"`exposure'"' != "") {
		eret local offset ln(`exposure')
	}
	eret hidden local sel_title title("Double-selection summary")
	eret hidden local stxer stxer
	eret hidden local lasso lasso 
	eret hidden local lasso_infer lasso_infer
	eret local marginsnotok _ALL
						//  cmd
	eret local predict `cmd'_p
	eret local select_cmd `cmd'_select
	eret hidden local zero `zero'
	eret local rngstate `rngstate'
	eret local cmdline `cmdline'
	eret local cmd `cmd' 
						// compute chi2
	_dslasso_chi2
						//  post subspace_list
	_dslasso_post_laout , laout_name(`laout_name') 	///
		subspace_list(`subspace_list') tt_vars(`tt_vars')

	_dslasso_fromeclass, laout_name(`laout_name')
end
					//----------------------------//
					// get est cmd
					//----------------------------//
program GetEstCmd, sclass
	syntax , model(string)	

	if (`"`model'"' == "logit") {
		local est_cmd logit
	}
	else if (`"`model'"' == "poisson") {
		local est_cmd poisson
	}
	sret loca est_cmd `est_cmd'
end
					//----------------------------//
					// get weight
					//----------------------------//
program GetWeight
	syntax [, depvar(string)	///
		indeps(string)		///
		touse(string)		///
		est_cmd(string)		///
		wvar(string)		///
		model(string) 		///
		tt_vars(string)		///
		offset(passthru)	///
		exposure(passthru)	///
		tolerance(passthru)]
	
	local union : list tt_vars | indeps

	`est_cmd' `depvar' `union' if `touse' , `tolerance' `offset' `exposure'

	if (`"`model'"' == "logit") {
		predict double `wvar', pr
		replace `wvar' = `wvar'*(1-`wvar')
	}
	else if (`"`model'"' == "poisson") {
		predict double `wvar', n
	}
end
