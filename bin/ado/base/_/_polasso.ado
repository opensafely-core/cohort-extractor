*! version 1.0.17  19jun2019
program _polasso
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

	if (`"`e(cmd)'"' != "poregress" & 	///
		`"`e(cmd)'"' != "xporegress" &	///
		`"`e(cmd)'"' != "pologit" &	///
		`"`e(cmd)'"' != "xpologit" &	///
		`"`e(cmd)'"' != "popoisson" &	///
		`"`e(cmd)'"' != "xpopoisson" ) {
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
		semi			///
		tolerance(passthru)	///
		XFOLDs(passthru)	/// number of cross-fitting
		technique(passthru)	///
		RESAMPLE1(passthru)	/// resampling cross-fit
		RESAMPLE		/// resample(10)
		vcetype(string)		///
		cluster(string)		///
		rseed(passthru)		///
		verbose			///
		dslog			///
		relog			///
		offset(passthru)	///
		exposure(passthru)	///
		noHEADer		///
		MISSingok		///
		*]

	/*----------------- parsing -------------------------------*/
						// rseed
	_lasso_rseed , `rseed'
						// rngstate
	_lasso_rngstate
	local rngstate `s(rngstate)'
						// diopts	
	_get_diopts diopts options, `options'
						//  touse	
	marksample touse

						//  parse varlist and options	
	_dslasso_parse `eq',	///
		model(`model')	///
		`controls'	///
		`common_opts'	///
		`sqrtlasso'	///
		`xfolds'	///
		`technique'	///
		`resample1'	///
		`resample'	///
		`options'	
	local depvar `s(depvar)'
	local Dvars `s(Dvars)'
	local Xvars `s(Xvars)'
	local raw_Xvars `s(raw_Xvars)'
	local full_lasso_names `s(full_lasso_names)'
	local full_lasso_cmds `s(full_lasso_cmds)'
	local full_lasso_opts `s(full_lasso_opts)'
	local xfolds `s(xfolds)'
	local dml `s(dml)'
	local resample_method `s(resample_method)'
	local resample_num `s(resample_num)'
	local dvars_omit `s(dvars_omit)'
	local dvars_full `s(dvars_full)'
	local irr_or `s(irr_or)'
	local lasso_noneed `s(lasso_noneed)'
	local eq `s(eq)'

						//  markout 	
	_dslasso_missingok,		///
		`missingok'		///
		touse(`touse') 		///
		depvar(`depvar')	///
		dvars(`Dvars')		///
		nuisance(`raw_Xvars')

	preserve	// PRESERVE START
						// keep only active sample
	qui keep if `touse'
						//  get touse for esample
	tempvar touse_esample
	GetTouseEsample, touse(`touse') touse_esample(`touse_esample')

						//  parse laout	
	_lasso_parse_laout
	local laout_name `s(laout_name)'
	local laout_replace `s(laout_replace)'

	/*----------------- partialed out -------------------------*/
						// begin dslog
	_dslasso_dslog_di, `dslog' 

	ResampleCrossFit,				///
		model(`model')				///
		dml(`dml')				///
		resample_num(`resample_num')		///
		resample_method(`resample_method')	///
		xfolds(`xfolds')			///
		touse(`touse')				///
		depvar(`depvar')			///
		controls(`Xvars')			///
		tt_vars(`Dvars')			///
		`reestimate' 				///
		full_lasso_cmds(`full_lasso_cmds')	///
		full_lasso_names(`full_lasso_names')	///
		full_lasso_opts(`full_lasso_opts')	///
		vce_spec(vce(`vce'))			///
		`qui'					///
		`semi'					///
		`constant'				///
		`tolerance'				///
		laout_name(`laout_name')		///
		laout_replace(`laout_replace')		///
		`offset'				///
		`exposure'				///
		`dslog'					///
		lasso_noneed(`lasso_noneed')		///
		eq(`eq')				///
		`relog'					///
		touse_esample(`touse_esample')
	local subspace_list `s(subspace_list)'
	local n_obs = `s(n_obs)'

	restore		// PRESERVE END

	/*----------------- post results ------------------------------*/
	nobreak PostResult, zero(`zero')	/// 
		depvar(`depvar')		///
		cmd(`cmd')			///
		`cmdline'			///
		touse(`touse')			///
		tt_vars(`Dvars')		///
		controls(`Xvars')		///
		raw_controls(`raw_Xvars')	///
		xfolds(`xfolds')		///
		model(`model')			///
		n_obs(`n_obs')			///
		dml(`dml')			///
		vce(`vce')			///
		vcetype(`vcetype')		///
		cluster(`cluster')		///
		`rngstate'			///
		`offset'			///
		`exposure'			///
		laout_name(`laout_name')	///
		subspace_list(`subspace_list')	///
		dvars_omit(`dvars_omit')	///
		dvars_full(`dvars_full')	///
		resample_num(`resample_num')	///
		lasso_noneed(`lasso_noneed')	///
		resample_method(`resample_method')

	/*----------------- display results -------------------------*/
	_polasso_display , `diopts' `verbose' `dslog' `header' `irr_or'
end
					//----------------------------//
					// resampling cross-fitting for linear
					// model
					//----------------------------//
program ResampleCrossFit, sclass
	syntax , 				///
		resample_num(string)		///
		resample_method(string)		///
		dml(string)			///
		depvar(string)			///
		xfolds(string)			///
		touse(string)			///
		touse_esample(string)		///
		[controls(string)		///
		model(passthru)			///
		tt_vars(string)			///
		reestimate			///
		vce_spec(string)		///
		full_lasso_cmds(passthru)	///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		semi				///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		tolerance(passthru)		///
		noconstant			///
		dslog				///
		relog				///
		offset(passthru)		///
		exposure(passthru)		///
		lasso_noneed(string)		///
		eq(string)			///
		qui]
	/*----------------------- no controls ----------------*/
	if (`lasso_noneed') {
		GetEstCmd, `model'
		local est_cmd `s(est_cmd)'
	
		`qui' `est_cmd' `eq' if `touse', `vce_spec' ///
			`constant' `tolerance' `exposure' `offset'

		sret local n_obs = e(N)
		Repost_b_nocontrols
		exit
		// NotReached
	}
	
	/*----------------------- cross fitting ----------------*/
	local n_obs = 0

	forvalues i=1/`resample_num' {
		_dslasso_relog_newline, resample_idx(`i') 	///
			resample_num(`resample_num')		///
			`relog'
		CrossFit, 					///
			`model'					///
			dml(`dml')				///
			xfolds(`xfolds')			///
			touse(`touse')				///
			depvar(`depvar')			///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`semi'					///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`constant'				///
			`tolerance'				///
			`qui'					///
			`dslog'					///
			`offset'				///
			`exposure'				///
			`relog'					///
			resample_idx(`i')			///
			resample_num(`resample_num')		///
			touse_esample(`touse_esample')		

		local subspace_list `s(subspace_list)'

		sum `touse_esample' if `touse', meanonly
		local n_obs = max(`n_obs', r(N))

		if (`xfolds' == 1) {
			sret local n_obs = `n_obs'
			sret local subspace_list `subspace_list'
			exit
			//NotReached
		}

		tempname b V
		mat `b' = e(b)
		mat `V' = e(V)
		local bs `bs' `b'
		local Vs `Vs' `V'
	}
					//-- get mean or median b and V  --//
	tempname b_out V_out
	mata : _LASSO_orth_resample(		///
		`"`bs'"',			///
		`"`Vs'"',			///
		`"`resample_method'"',		///
		`"`tt_vars'"',			///
		`"`b_out'"',			///
		`"`V_out'"')
					//-- post result --//
	Post_b_V, repost		///
		xfolds(`xfolds')	///
		bname(`b_out')		///
		vname(`V_out')			

	sret local n_obs = `n_obs'
	sret local subspace_list `subspace_list'
end
					//----------------------------//
					// CrossFit
					//----------------------------//
program CrossFit
	syntax [, model(string)		///
		tolerance(passthru)	///
		*]

	if (`"`model'"' == "linear") {
		CrossFitLinear , `options'
	}
	else if (`"`model'"' == "logit" ) {
		CrossFitGLM `0'
	}
	else if (`"`model'"' == "poisson" ) {
		CrossFitGLM `0'
	}
end
					//----------------------------//
					// cross-fitting for GLM model
					//----------------------------//
program CrossFitGLM, sortpreserve sclass
	syntax ,  model(string)			///
		dml(string)			///
		depvar(string)			///
		xfolds(string)			///
		touse(string)			///
		touse_esample(passthru)		///
		[controls(string)		///
		tt_vars(string)			///
		reestimate			///
		full_lasso_cmds(passthru)	///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		vce_spec(string)		///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		tolerance(passthru)		///
		noconstant			///
		qui				///
		offset(passthru)		///
		exposure(passthru)		///
		resample_idx(passthru)		///
		resample_num(passthru)		///
		relog				///
		dslog]
		
	/*----------------------- cross-fitting ----------------*/
						// xb
	tempvar xb
	qui gen double `xb' = .

						//  instruments for dvars and
	local k_tt_vars : list sizeof tt_vars
	local k_inst = `k_tt_vars'

	forvalues i=1/`k_inst' {
		tempvar z_`i'
		qui gen double `z_`i'' = .
		local inst `inst' `z_`i''
	}

					//-- initialize touse main --//
	tempvar touse_main
	qui gen byte `touse_main' = 0

					//-- case 1: no sample splitting --//
	if (`xfolds' == 1) {
		qui replace `touse_main' = 1

		PoIvGLM, model(`model')				/// 
			dml(dml1)				///
			xfolds(`xfolds')			///
			touse(`touse')				///
			touse_main(`touse_main')		///
			touse_aux(`touse_main')			///
			depvar(`depvar')			///
			inst(`inst')				///
			xb(`xb')				///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`constant'				///
			`tolerance'				///
			`qui'					///
			`offset'				///
			`touse_esample'				///
			`exposure'				

		tempname bname Vname
		mat `bname' = e(b)
		mat `Vname' = e(V)

		mat `bname' = `bname'[1, 1..`k_tt_vars']
		mat `Vname' = `Vname'[1..`k_tt_vars', 1..`k_tt_vars']

		Post_b_V, xfolds(`xfolds') 	///
			bname(`bname')		///
			vname(`Vname')


		sret local subspace_list `s(subspace_list)'
		exit
		// NotReached
	}
				// -- case 2: cross-fitting --//
					//-- partition data --//
	tempvar gr
	_dml_part_data, gr(`gr') xfolds(`xfolds')
					//-- cross-fit --//
	tempname B_dml
	forvalues k=1/`xfolds' {
		_dslasso_begin_cflog, `dslog' k(`k') xfolds(`xfolds')	///
			`resample_idx'	`resample_num'	`relog'
						//  set up main sample
		qui replace `touse_main' = (`gr'==`k')	

		PoIvGLM, model(`model')				/// 
			dml(`dml')				///
			xfolds(`xfolds')			///
			touse(`touse')				///
			touse_main(`touse_main')		///
			touse_aux(!`touse_main')		///
			depvar(`depvar')			///
			inst(`inst')				///
			xb(`xb')				///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`constant'				///
			`tolerance'				///
			`qui'					///
			`offset'				///
			`exposure'				///
			`resample_idx'				///
			`relog'					///
			`touse_esample'				///
			xfold_idx(`k')

		local subspace_list `s(subspace_list)'
		if (`"`dml'"' == "dml1") {
			mat `B_dml' = (nullmat(`B_dml') \ e(b))
		}

		_dslasso_end_cflog, `dslog' k(`k') xfolds(`xfolds') ignore
	}

					//-- get b and V for DML1 or DML2 --//
	if (`"`dml'"' == "dml2") {
		tempname B_dml 
		`qui' InstGLM , depvar(`depvar') 	///
			tt_vars(`tt_vars')		///
			xbvar(`xb')			///
			inst(`inst')			///
			touse(`touse')			///
			model(`model')			///
			xfolds(`xfolds')		///
			`touse_esample'
		mat `B_dml' = e(b)
	}

	tempname b V
	mata : _LASSO_orth_glm_DML(	///
		`"`dml'"',		///
		`"`model'"',		///
		`"`depvar'"',		///
		`"`tt_vars'"',		///
		`"`xb'"',		///
		`"`inst'"', 		///
		`"`B_dml'"',		///
		`"`gr'"', 		///
		`xfolds',		///
		`"`b'"',		///
		`"`V'"')

					//-- post result --//
	Post_b_V, xfolds(`xfolds')	///
		bname(`b')		///
		vname(`V')			

	sret local subspace_list `subspace_list'
end
					//----------------------------//
					// cross-fitting for linear model
					//----------------------------//
program CrossFitLinear, sortpreserve sclass
	syntax , 				///
		dml(string)			///
		depvar(string)			///
		xfolds(string)			///
		touse(string)			///
		touse_esample(passthru)		///
		[controls(string)		///
		tt_vars(string)			///
		reestimate			///
		full_lasso_cmds(passthru)	///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		vce_spec(string)		///
		semi				///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		noconstant			///
		qui				///
		resample_idx(passthru)		///
		resample_num(passthru)		///
		relog				///
		dslog]

	/*----------------------- case 1: cross-fitting ----------------*/

					//-- set up for rho and Z --//
	tempvar rho
	qui gen double `rho' = .
	forvalues i=1/`:list sizeof tt_vars' {
		tempvar z_`i'
		qui gen double `z_`i'' = .
		local inst `inst' `z_`i''
	}
					//-- initialize touse main --//
	tempvar touse_main  
	qui gen int `touse_main' = 0
					//-- case 1: no sample splitting --//
	if (`xfolds' == 1) {		
		qui replace `touse_main' = 1
		DoubleML, touse(`touse')			///
			touse_main(`touse_main')		///
			touse_aux(`touse_main')			///
			depvar(`depvar')			///
			rho(`rho')				///
			inst(`inst')				///
			controls(`controls')			///
			xfolds(`xfolds')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`semi'					///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`touse_esample'				///
			`qui'					

		sret local subspace_list `s(subspace_list)'
		exit
		// NotReached
	}
					//-- partition data --//
	tempvar gr
	_dml_part_data, gr(`gr') xfolds(`xfolds')
					//-- cross-fit --//
	tempname B_DML1
	forvalues k=1/`xfolds' {
		_dslasso_begin_cflog, `dslog' k(`k') xfolds(`xfolds')	///
			`resample_idx'	`resample_num'	`relog'
						//  set up main sample
		qui replace `touse_main' = (`gr'==`k')	
						//  double machine learning
		DoubleML, touse(`touse')			///
			touse_main(`touse_main')		///
			touse_aux(!`touse_main')		///
			depvar(`depvar')			///
			rho(`rho')				///
			inst(`inst')				///
			controls(`controls')			///
			xfolds(`xfolds')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`semi'					///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`qui'					///
			`resample_idx'				///
			`relog'					///
			`touse_esample'				///
			xfold_idx(`k')			

		local subspace_list `s(subspace_list)'
		mat `B_DML1' = (nullmat(`B_DML1') \ e(b))

		_dslasso_end_cflog, `dslog' k(`k') xfolds(`xfolds') ignore
	}

	sret local subspace_list `subspace_list'

					//-- get b and V for DML1 or DML2 --//
	tempname b V
	mata : _LASSO_orth_DML(		///
		`"`semi'"',		///
		`"`dml'"',		///
		`"`B_DML1'"',		///
		`"`rho'"', 		///
		`"`inst'"', 		///
		`"`gr'"', 		///
		`xfolds',		///
		`"`tt_vars'"',		///
		`"`b'"',		///
		`"`V'"')
					//-- post result --//
	Post_b_V, repost		///
		xfolds(`xfolds')	///
		bname(`b')		///
		vname(`V')			
end
					//----------------------------//
					// double machine learning
					//----------------------------//
program DoubleML, sclass
	syntax , touse(string)			///
		touse_esample(passthru)		///
		touse_main(string)		///
		touse_aux(string)		///
		depvar(string)			///
		rho(string)			///
		inst(string)			///
		xfolds(string)			///
		controls(string)		///
		tt_vars(string)			///
		full_lasso_cmds(passthru)	///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		[vce_spec(string)		///
		semi				///
		reestimate			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(passthru)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		relog				///
		qui]

	tempname b V

	if (`"`semi'"' != "") {		//-- IV for partial residuals --//
		IVFPR, touse_main(`touse_main')			///
			touse_aux(`touse_aux')			///
			depvar(`depvar')			///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			rho(`rho')				///
			inst(`inst')				///
			bname(`b')				///
			vname(`V')				///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			`subspace_list'				///
			`resample_idx'				///
			`xfold_idx'				///	
			`relog'					///
			`touse_esample'				///
			`qui'
	}
	else {				//-- standard IV --//
		SIV, touse_main(`touse_main')			///
			touse_aux(`touse_aux')			///
			depvar(`depvar')			///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`reestimate'				///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			rho(`rho')				///
			inst(`inst')				///
			bname(`b')				///
			vname(`V')				///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			`subspace_list'				///
			`resample_idx'				///
			`xfold_idx'				///
			`relog'					///
			`touse_esample'				///
			`qui'
	}
	sret local subspace_list `s(subspace_list)'
						// post result in double machine
						// learning
	Post_b_V, xfolds(`xfolds')	///
		bname(`b')		///
		vname(`V')			
end
					//----------------------------//
					// IV for partial residuals
					//----------------------------//
program IVFPR, sclass
	syntax , touse_main(string)		///
		touse_aux(string)		///
		touse_esample(string)		///
		depvar(string)			///
		rho(string)			///
		inst(string)			///
		controls(string)		///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		bname(string)			///
		vname(string)			///
		[vce_spec(string)		///
		laout_name(passthru)		///
		reestimate			///
		laout_replace(passthru)		///
		subspace_list(string)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		relog				///
		qui]

	_parse expand opts tmp : full_lasso_opts
	_parse expand names tmp : full_lasso_names
	_parse expand cmds tmp : full_lasso_cmds

/* 
	step 1: lasso y on tt_vars and controls, always keep tt_vars

		auxiliary sample
*/
						//  initialize subspace_list 
	_lasso_add_subspace, 		///
		`laout_name' 		///
		`laout_replace'		///
		opt(`opts_1')		///
		`reestimate'		///
		`resample_idx'		///
		`xfold_idx'		///
		subspace_list(`subspace_list')
	local opts_1 `s(opt)'
	local cmd_1 `cmds_1'
	local subspace_list `s(subspace_list)'

						// merge (`tt_vars') with
						// alinclude in controls
	ParseAinclude, tt_vars(`tt_vars') controls(`controls')
	local ainclude `s(ainclude)'
	local othervars `s(othervars)'
						// do lasso on y
	_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

	`cmd_1' linear `depvar' (`ainclude') `othervars' if `touse_aux',  ///
		`opts_1' 
	local Xs_y `e(allvars_sel)'	
	local Xs_y: list Xs_y - tt_vars

/*
	step 2: post-lasso y on tt_vars and Xs_y  

	auxiliary sample
*/
	`qui' regress `depvar' `tt_vars' `Xs_y' if `touse_aux'

/* 
	step 3: get partial residuals 

	main sample
*/
	qui replace `rho' = `depvar' - _b["_cons"] if `touse_main'
	foreach var of local Xs_y {
		qui replace `rho' = `rho' - `var'*_b[`"`var'"'] if `touse_main'
	}

/*
	step 4: lasso tt_vars on controls and get instrument
*/
	forvalues i=2/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
						//  initialize subspace_list 
		_lasso_add_subspace, 		///
			`laout_name' 		///
			`laout_replace'		///
			opt(`opt')		///
			`reestimate'		///
			`resample_idx'		///
			`xfold_idx'		///
			subspace_list(`subspace_list')
		local opt `s(opt)'
		local subspace_list `s(subspace_list)'

		tempvar dvar_tmp
		qui gen double `dvar_tmp' = `var' 
						//  lasso (auxiliary sample)
		_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

		`cmd' linear `dvar_tmp' `controls' if `touse_aux', 	///
			`opt' depname(`var')
		local selected_vars `e(allvars_sel)'
						//  post-Lasso (auxiliary sample)
		`qui' regress `dvar_tmp' `selected_vars' if `touse_aux'
		local k = `i' - 1
		local z_`i' : word `k' of `inst'
						// get instrument (main sample)
		tempvar tmp
		qui predict double `tmp' if `touse_main', residuals
		qui replace `z_`i'' = `tmp' if `touse_main'
	}

	_dslasso_relog_lasso_end, `relog'

/*
	step 5: theta = (Z'D)^(-1)*(Z'rho)
	see Chernozhukov(2018) at page C4 Equation 1.5
*/
	foreach dvar of local tt_vars {
		tempvar dvar_tmp
		qui gen double `dvar_tmp' = `dvar'
		local dvar_tmp_list `dvar_tmp_list' `dvar_tmp'

	}
	`qui' regress `rho' `dvar_tmp_list' (`inst') if `touse_main', 	///
		`vce_spec' noconstant
	mat `bname' = e(b)
	mat `vname' = e(V)
	mat colnames `bname' = `tt_vars'
	mat colnames `vname' = `tt_vars'
	mat rownames `vname' = `tt_vars'

	qui replace `touse_esample' = e(sample) if e(sample)

	sret local subspace_list `subspace_list'
end
					//----------------------------//
					// standard IV
					//----------------------------//
program SIV , sclass
	syntax , touse_main(string)		///
		touse_aux(string)		///
		touse_esample(string)		///
		depvar(string)			///
		rho(string)			///
		inst(string)			///
		controls(string)		///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		bname(string)			///
		vname(string)			///
		[vce_spec(string)		///
		reestimate			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		relog				///
		qui]

	_parse expand opts tmp : full_lasso_opts
	_parse expand names tmp : full_lasso_names
	_parse expand cmds tmp : full_lasso_cmds
/*
	step 1: lasso y on x in auxiliary sample
*/
						//  initialize subspace_list 
	_lasso_add_subspace, 		///
		`laout_name' 		///
		`laout_replace'		///
		opt(`opts_1')		///
		`reestimate'		///
		`resample_idx'		///
		`xfold_idx'		///
		subspace_list(`subspace_list')
	local opts_1 `s(opt)'
	local cmd_1 `cmds_1'
	local subspace_list `s(subspace_list)'

	_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

	`cmd_1' linear `depvar' `controls' if `touse_aux', `opts_1'
	local X_y `e(allvars_sel)'

/*
	step 2: post-lasso y on X_y in auxiliary sample
*/
	`qui' regress `depvar' `X_y' if `touse_aux'

/*
	step 3: get residuals in main sample
*/
	tempvar tmp_rho
	qui predict double `tmp_rho' if `touse_main', residuals
	qui replace `rho' = `tmp_rho' if `touse_main'

/*	
	step 4: lasso tt_vars on controls and get instruments
*/
	forvalues i=2/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
						//  initialize subspace_list 
		_lasso_add_subspace, 		///
			`laout_name' 		///
			`laout_replace'		///
			opt(`opt')		///
			`reestimate'		///
			`resample_idx'		///
			`xfold_idx'		///
			subspace_list(`subspace_list')
		local opt `s(opt)'
		local subspace_list `s(subspace_list)'

		tempvar dvar_tmp
		qui gen double `dvar_tmp' = `var'
						//  _lasso (auxiliary sample)
		_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

		`cmd' linear `dvar_tmp' `controls' if `touse_aux', 	///
			`opt' depname(`var')
		local selected_vars `e(allvars_sel)'
						//  post-Lasso (auxiliary sample)
		`qui' regress `dvar_tmp' `selected_vars' if `touse_aux'
		local k = `i' - 1
		local z_`k' : word `k' of `inst'
						// get instrument (main sample)
		tempvar tmp
		qui predict double `tmp' if `touse_main', residuals
		qui replace `z_`k'' = `tmp' if `touse_main'
	}
	_dslasso_relog_lasso_end, `relog'

/*
	step 5: OLS of rho on inst
*/
	`qui' regress `rho' `inst' if `touse_main', `vce_spec' noconstant
	mat `bname' = e(b)
	mat `vname' = e(V)
	mat colnames `bname' = `tt_vars'
	mat colnames `vname' = `tt_vars'
	mat rownames `vname' = `tt_vars'

	qui replace `touse_esample' = e(sample) if e(sample)

	sret local subspace_list `subspace_list'
end

					//----------------------------//
					// Post  b and V
					//----------------------------//
program Post_b_V, eclass
	syntax , xfolds(string)	///
		bname(string)	///
		vname(string)	///
		[repost]

						
	if (`xfolds' == 1) {
		eret post `bname' `vname'
	}
	else if (`"`repost'"'=="") {
		eret post `bname' `vname'
	}
	else if (`"`repost'"'!="") {
		eret repost b=`bname' V=`vname'
	}
end
					//----------------------------//
					// post final results
					//----------------------------//
program PostResult, eclass
	syntax , touse(string)		///
		depvar(string)		///
		tt_vars(string)		///
		xfolds(string)		///
		model(string)		///
		n_obs(string)		///
		dml(string)		///
		resample_num(string)	///
		resample_method(string)	///
		laout_name(string)	///
		cmd(string)		///
		[vce(string)		///
		controls(string)	///
		cmdline(string)		///
		zero(string)		///
		subspace_list(string)	///
		raw_controls(string)	///
		vcetype(string)		///
		rngstate(string)	///
		offset(string)		///
		exposure(string)	///
		dvars_omit(passthru)	///
		dvars_full(passthru)	///
		lasso_noneed(passthru)	///
		cluster(string)]
	
	eret repost, esample(`touse')
						//  add dummy variables
	_dslasso_stripe_b , `dvars_omit' `dvars_full' `lasso_noneed'

	eret local depvar `depvar'
	eret scalar N = `n_obs'
	eret scalar k_varsofinterest = `:list sizeof tt_vars'
	eret local varsofinterest `tt_vars'

	eret scalar k_controls =`:list sizeof raw_controls'

	if (!strpos(`"`cmd'"', "xpo")) {
		local hide_cs hidden
	}
	eret `hide_cs' scalar n_xfolds = `xfolds'
	eret `hide_cs' scalar n_resample = `resample_num'

	if (`xfolds' > 1) {
		local vce robust
		local vcetype Robust
		local clusterv
	}
	
	eret local offset `offset'
	if (`"`exposure'"' != "") {
		eret local offset ln(`exposure')
	}
	eret local controls `raw_controls'
	eret local model `model'
	eret local vce `vce'
	eret local vcetype `vcetype'
	eret local clusterv `cluster'
	eret hidden local dml `dml'
	eret hidden local resample_method `resample_method'

	if ("`model'" == "poisson") {
		local tit_model Poisson
	}
	else {
		local tit_model `model'
	}

	if (`xfolds' == 1) {
		eret local title `"Partialing-out `tit_model' model"'
	}
	else {
		eret local title `"Cross-fit partialing-out"'
		eret local title2 `"`tit_model' model"'
	}
	eret hidden local sel_title 	///
		title("Partialing-out LASSO selection summary")
	eret hidden local stxer stxer
	eret hidden local lasso lasso
	eret hidden local lasso_infer lasso_infer
	eret local marginsnotok _ALL
						// cmd
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
		subspace_list(`subspace_list')		///
		tt_vars(`tt_vars')

	_dslasso_fromeclass, laout_name(`laout_name')
end

					//----------------------------//
					// parse ainclude for tt_vars
					//----------------------------//
program ParseAinclude, sclass
	syntax [, tt_vars(string)	///
		controls(string) ]
						// parse controls	
	_lasso_parse_controls `controls'
	local ainclude `s(ainclude)'
	local othervars `s(othervars)'
						// merge tt_vars with ainclude
						// in controls()
	local ainclude `tt_vars' `ainclude' 

	sret local ainclude `ainclude'
	sret local othervars `othervars'
end
					//----------------------------//
					// get est cmd
					//----------------------------//
program GetEstCmd, sclass
	syntax , model(string)	

	if (`"`model'"' == "linear") {
		local est_cmd regress
	}
	else if (`"`model'"' == "logit") {
		local est_cmd logit
	}
	else if (`"`model'"' == "poisson") {
		local est_cmd poisson
	}
	sret loca est_cmd `est_cmd'
end

					//----------------------------//
					// Partialling out IV for glm model
					//----------------------------//
program PoIvGLM, sclass
	syntax , model(string)			///
		dml(string)			///
		touse(string)			///
		touse_main(string)		///
		touse_aux(string)		///
		touse_esample(passthru)		///
		depvar(string)			///
		inst(string)			///
		xfolds(string)			///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		xb(string)			///
		[vce_spec(string)		///
		controls(string)		///
		reestimate			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		noconstant			///
		tolerance(passthru)		///
		offset(passthru)		///
		exposure(passthru)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		relog				///
		qui]

	GetEstCmd, model(`model')
	local est_cmd `s(est_cmd)'
	
	/*----------------------- partialed out IV ----------------*/

	_parse expand opts tmp : full_lasso_opts
	_parse expand names tmp : full_lasso_names
	_parse expand cmds tmp : full_lasso_cmds

/*
	step 1.a : lasso y on x in auxiliary sample
*/
						//  initialize subspace_list 
	_lasso_add_subspace, 		///
		`laout_name' 		///
		`laout_replace'		///
		opt(`opts_1')		///
		`reestimate'		///
		`resample_idx'		///
		`xfold_idx'		///
		subspace_list(`subspace_list')
	local opts_1 `s(opt)'
	local cmd_1 `cmds_1'
	local subspace_list `s(subspace_list)'

	_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

	`cmd_1' `model' `depvar' `controls' `tt_vars' if `touse_aux',  ///
		`opts_1' `offset' `exposure'
	local X_y `e(allvars_sel)'
	local X_y : list X_y - tt_vars

/*
	step 1.b : post-lasso y on X_y and tt_vars in auxiliary sample
*/
	`qui' `est_cmd' `depvar' `tt_vars' `X_y' if `touse_aux', 	///
		`tolerance' `constant' `offset' `exposure'

/*
	step 1.c : get Xb in main sample
*/
	tempvar tmp_xb
	`qui' predict double `tmp_xb', xb

	`qui' replace `xb' = `tmp_xb' if `touse_main'
	foreach var of local tt_vars {
		`qui' replace `xb' = `xb' - _b[`"`var'"']*`var' if `touse_main'
	}

/*
	step 1.d : get weight based on step 1.b in auxiliary sample
*/
	tempvar wvar
	`qui' predict double `wvar' if `touse_aux'
	if (`"`model'"' == "logit") {
		`qui' replace `wvar' = `wvar'*(1-`wvar') if `touse_aux'
	}
	

/*
	step 2 : lasso linear d on x in auxiliary sample 
*/
	forvalues i=2/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
						//  initialize subspace_list 
		_lasso_add_subspace, 		///
			`laout_name' 		///
			`laout_replace'		///
			opt(`opt')		///
			`reestimate'		///
			`resample_idx'		///
			`xfold_idx'		///
			subspace_list(`subspace_list')
		local opt `s(opt)'
		local subspace_list `s(subspace_list)'

		tempvar dvar_tmp
		qui gen double `dvar_tmp' = `var'

						//  lasso (auxiliary sample)
		_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

		`cmd' linear `dvar_tmp' `controls' if `touse_aux' 	///
			[iw=`wvar'], `opt' depname(`var')
		local selected_vars `e(allvars_sel)'

						// post-Lasso (auxiliary sample)
		`qui' regress `dvar_tmp' `selected_vars' if `touse_aux'	///
			[iw=`wvar'] , `constant'
			
		local k = `i' - 1
		local z_`k' : word `k' of `inst'

						// get instrument (main sample)
		tempvar res
		`qui' predict double `res' if `touse_main', residuals
		`qui' replace `z_`k'' = `res' if `touse_main'
	}
	_dslasso_relog_lasso_end, `relog'

/*
	step 3 : instrumental GLM in main sample
*/
	if (`"`dml'"' != "dml2") {
		tempname bname vname
		`qui' InstGLM, depvar(`depvar') tt_vars(`tt_vars') 	 ///
			xbvar(`xb') inst(`inst')  touse(`touse_main') 	 ///
			model(`model') xfolds(`xfolds')  `touse_esample' 
	}

	sret local subspace_list `subspace_list'
end

					//----------------------------//
					// instrumental GLM via GMM 
					//----------------------------//
program InstGLM
	syntax , depvar(string)		///
		tt_vars(string)		///
		xbvar(string)		///
		inst(string)		///
		touse(string)		///
		model(string)		///
		xfolds(string)		///
		touse_esample(string)
	
	if (`"`model'"' == "logit") {
		local fcn_m _polasso_gmm_logit
		local est_cmd logit
	}
	else if ( `"`model'"' == "poisson") {
		local fcn_m _polasso_gmm_pois
		local est_cmd poisson
	}
						//  starting values
	`est_cmd' `depvar' `tt_vars' if `touse', offset(`xbvar') noconstant
	tempname b_from
	mat `b_from' = e(b)
						//  one step gmm
	gmm `fcn_m' if `touse', 					///
		nequations(1) parameters({`depvar':`tt_vars'})		///
		instruments(`inst', noconstant)				///
		depvar(`depvar') tt_vars(`tt_vars')			///
		xbvar(`xbvar') haslfderivatives onestep			///
		from(`b_from') winitial(identity) vce(robust)
	if (!e(converged)) {
		di as err "{p 4 4 2}gmm step failed to converge{p_end}"
		exit 498
	}

	qui replace `touse_esample' = e(sample) if e(sample)

	tempname bname Vname
	mat `bname' = e(b)
	mat `Vname' = e(V)
						// post result in double machine
						// learning
	Post_b_V, xfolds(`xfolds')	///
		bname(`bname')		///
		vname(`Vname')		///
		`repost'
end

					//----------------------------//
					// repost b and V in case of no controls
					//----------------------------//
program Repost_b_nocontrols, eclass
	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)

	local k : colsof `b'
	local k = `k' - 1
	mat `b' = `b'[1, 1..`k']
	mat `V' = `V'[1..`k', 1..`k']

	eret post `b' `V'
end

					//----------------------------//
					// get touse_esample for each resample
					//----------------------------//
program GetTouseEsample, sclass
	syntax , touse(string) 	///
		touse_esample(string) 
	
	qui gen byte `touse_esample' = . if `touse'
end



exit
Reference :

Chernozhukov, V., Chetverikov, D., Demirer, M., Duflo, E., Hansen, C., Newey,
W., & Robins, J. (2018). Double/debiased machine learning for treatment and
structural parameters. The Econometrics Journal, 21(1), C1-C68.
