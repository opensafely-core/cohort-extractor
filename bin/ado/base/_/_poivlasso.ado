*! version 1.0.18  10feb2020
program _poivlasso
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

	if (`"`e(cmd)'"' != "poivregress" & 	///
		`"`e(cmd)'"' != "xpoivregress" ) {
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
		noHEADer		///
		MISSingok		///
		*]
	
	_get_diopts diopts options, `options'
	marksample touse

	/*-------------------- parsing ----------------------------*/
						// rseed
	_lasso_rseed, `rseed'
						// rngstate
	_lasso_rngstate
	local rngstate `s(rngstate)'

						//  parse varlist and options	
	_dslasso_parse `eq',	///
		`controls'	///
		`common_opts'	///
		`sqrtlasso'	///
		`xfolds'	///
		`technique'	///
		`resample1'	///
		`resample'	///
		iv		///
		model(`model')	///
		`options'	
	local depvar `s(depvar)'
	local Dvars `s(Dvars)'
	local endog `s(endog)'
	local exog `s(exog)'
	local Xvars `s(Xvars)'
	local raw_Xvars `s(raw_Xvars)'
	local Zvars `s(Zvars)'
	local full_lasso_names `s(full_lasso_names)'
	local full_lasso_cmds `s(full_lasso_cmds)'
	local full_lasso_opts `s(full_lasso_opts)'
	local xfolds `s(xfolds)'
	local dml `s(dml)'
	local resample_method `s(resample_method)'
	local resample_num `s(resample_num)'
	local dvars_omit `s(dvars_omit)'
	local dvars_full `s(dvars_full)'
	local eq `s(eq)'
	local raw_inst `s(raw_inst)'
	local lasso_noneed `s(lasso_noneed)'
	local irr_or `s(irr_or)'

						//  markout 	
	_dslasso_missingok,		///
		`missingok'		///
		touse(`touse') 		///
		depvar(`depvar')	///
		dvars(`Dvars')		///
		nuisance(`raw_Xvars' `raw_inst')

	preserve		// PRESERVE START
						// keep only active sample
	qui keep if `touse'
						//  get touse for esample
	tempvar touse_esample
	GetTouseEsample, touse(`touse') touse_esample(`touse_esample')

						//  parse laout	
	_lasso_parse_laout
	local laout_name `s(laout_name)'
	local laout_replace `s(laout_replace)'

	/*------------------ IV polasso ----------------------------*/
						// begin dslog
	_dslasso_dslog_di, `dslog'

	ResampleCrossFit,				///
		dml(`dml')				///
		resample_num(`resample_num')		///
		resample_method(`resample_method')	///
		xfolds(`xfolds')			///
		touse(`touse')				///
		depvar(`depvar')			///
		controls(`Xvars')			///
		tt_vars(`Dvars')			///
		endog(`endog')				///
		exog(`exog')				///
		inst_vars(`Zvars')			///
		raw_inst(`raw_inst')			///
		`reestimate' 				///
		full_lasso_cmds(`full_lasso_cmds')	///
		full_lasso_names(`full_lasso_names')	///
		full_lasso_opts(`full_lasso_opts')	///
		vce_spec(vce(`vce'))			///
		eq(`eq')				///
		`qui'					///
		`dslog'					///
		`relog'					///
		`constant'				///
		laout_name(`laout_name')		///
		lasso_noneed(`lasso_noneed')		///
		laout_replace(`laout_replace')		///
		touse_esample(`touse_esample')	
	local subspace_list `s(subspace_list)'
	local n_obs = `s(n_obs)'

	restore		// PRESERVE END

	/*----------------- post results ------------------------------*/
						//  Post result
	nobreak PostResult, zero(`zero')	/// 
		depvar(`depvar')		///
		cmd(`cmd')			///
		`cmdline'			///
		touse(`touse')			///
		tt_vars(`Dvars')		///
		endog(`endog')			///
		exog(`exog')			///
		controls(`Xvars')		///
		raw_controls(`raw_Xvars')	///
		inst_vars(`Zvars')		///
		xfolds(`xfolds')		///
		model(`model')			///
		n_obs(`n_obs')			///
		dml(`dml')			///
		vce(`vce')			///
		vcetype(`vcetype')		///
		cluster(`cluster')		///
		`rngstate'			///
		laout_name(`laout_name')	///
		subspace_list(`subspace_list')	///
		resample_num(`resample_num')	///
		dvars_omit(`dvars_omit')	///
		dvars_full(`dvars_full')	///
		lasso_noneed(`lasso_noneed')	///
		resample_method(`resample_method')

	/*----------------- display results ---------------------------*/
	_poivlasso_display, `diopts' `verbose' `dslog' `header' `irr_or'
end
					//----------------------------//
					// resampling cross-fitting
					//----------------------------//
program ResampleCrossFit, sclass
	syntax , 				///
		dml(string)			///
		resample_num(string)		///
		resample_method(string)		///
		xfolds(string)			///
		touse(string)			///
		touse_esample(string)		///
		depvar(string)			///
		tt_vars(string)			///
		inst_vars(string)		///
		full_lasso_names(string)	///
		full_lasso_cmds(passthru)	///
		full_lasso_opts(string)		///
		[vce_spec(string)		///
		controls(string)		///
		raw_inst(passthru)		///
		endog(string)			///
		exog(string)			///
		noconstant			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		reestimate			///
		eq(string)			///
		dslog				///
		relog				///
		lasso_noneed(string)		///
		qui]
	
	if (`lasso_noneed') {
		`qui' ivregress 2sls `eq', `constant' `vce_spec'

		sret local n_obs = e(N)
		Repost_b_nocontrols

		exit
		// NotReached
	}

	local n_obs = 0
	forvalues i=1/`resample_num' {
		_dslasso_relog_newline, resample_idx(`i') 	///
			resample_num(`resample_num')		///
			`relog'
		CrossFit, 					///
			dml(`dml')				///
			xfolds(`xfolds')			///
			touse(`touse')				///
			depvar(`depvar')			///
			tt_vars(`tt_vars')			///
			exog(`exog')				///
			endog(`endog')				///
			inst_vars(`inst_vars')			///
			controls(`controls')			///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`reestimate'				///
			`qui'					///
			`dslog'					///
			`raw_inst'				///
			`relog'					///
			resample_num(`resample_num')		///
			resample_idx(`i')			///
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
program CrossFit, sortpreserve sclass
	syntax , dml(string)			///
		xfolds(string)			///
		depvar(string)			///
		touse(string)			///
		touse_esample(passthru)		///
		tt_vars(string)			///
		full_lasso_cmds(passthru)	///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		[vce_spec(string)		///
		controls(string)		///
		inst_vars(string)		///
		exog(string)			///
		endog(string)			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		reestimate			///
		dslog				///
		relog				///
		resample_idx(passthru)		///
		resample_num(passthru)		///
		raw_inst(passthru)		///
		qui]
	
					//-- set up for ypx and dhatpx--//

						//  ypx is y partialed out X
	tempvar ypx	
	qui gen double `ypx' = .

	forvalues i=1/`:list sizeof tt_vars' {
						// dhat is predicted dvar based
						// on selected X and Z
		tempvar dhat_`i'
		qui gen double `dhat_`i'' = .
		local dhat_vars `dhat_vars' `dhat_`i''
						//  dhatpx_vars is dhat
						//  partialed out X
		tempvar z_`i' 
		qui gen double `z_`i'' = .
		local dhatpx_vars `dhatpx_vars' `z_`i''
						// dpX is original dvars
						// partialed out X
		tempvar dpx_`i'
		qui gen double `dpx_`i'' = .
		local dpx_vars `dpx_vars' `dpx_`i''
	}
					//-- initialize touse main --//
	tempvar touse_main
	qui gen int `touse_main' = 0
					//-- case 1: no sample splitting --//
	if (`xfolds' == 1) {
		tempname b V
		SIV, touse(`touse')				///
			depvar(`depvar')			///
			tt_vars(`tt_vars')			///
			exog(`exog')				///
			endog(`endog')				///
			inst_vars(`inst_vars')			///
			controls(`controls')			///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			ypx(`ypx')				///
			dpx_vars(`dpx_vars')			///
			dhat_vars(`dhat_vars')			///
			dhatpx_vars(`dhatpx_vars')		///
			bname(`b')				///
			vname(`V')				///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`reestimate'				///
			`raw_inst'				///
			`touse_esample'				///
			`qui'
	
		sret local subspace_list `s(subspace_list)'

		Post_b_V, xfolds(`xfolds')	///
			bname(`b')		///
			vname(`V')			
		exit
		// NotReached
	}
					//-- partition data --//
	tempvar gr
	_dml_part_data, gr(`gr') xfolds(`xfolds')

					//-- cross-fit --//
						//  Loop 1: get ypx and dhat for
						//  all the observations
	forvalues k=1/`xfolds' {
		_dslasso_begin_cflog, `dslog' k(`k') xfolds(`xfolds')	///
			`resample_idx'	`resample_num'	`relog'
						// set active sample
		qui replace `touse_main' = (`gr' == `k')	

		SIV_part1, 					///
			touse_main(`touse_main')		///
			touse_aux(!`touse_main')		///
			depvar(`depvar')			///
			tt_vars(`tt_vars')			///
			exog(`exog')				///
			endog(`endog')				///
			inst_vars(`inst_vars')			///
			controls(`controls')			///
			`full_lasso_cmds'			///
			full_lasso_names(`full_lasso_names')	///
			full_lasso_opts(`full_lasso_opts')	///
			ypx(`ypx')				///
			dhat_vars(`dhat_vars')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`reestimate'				///
			`qui'					///
			`resample_idx'				///
			`raw_inst'				///
			`relog'					///
			xfold_idx(`k')

		local subspace_list `s(subspace_list)'

		_dslasso_end_cflog, `dslog' k(`k') xfolds(`xfolds') 
	}

						// Loop 2: get dpx, dhatpx for
						// all the observations
	tempname B_DML1
	forvalues k=1/`xfolds' {
		_dslasso_begin_cflog, `dslog' k(`k') xfolds(`xfolds')	///
			`resample_idx'	`resample_num'	`relog'

		qui replace `touse_main' = (`gr' == `k')	

		tempname b V
		SIV_part2, 					///
			touse_main(`touse_main')		///
			touse_aux(!`touse_main')		///
			controls(`controls')			///
			tt_vars(`tt_vars')			///
			`full_lasso_cmds'			///
			full_lasso_opts(`full_lasso_opts')	///
			full_lasso_names(`full_lasso_names')	///
			ypx(`ypx')				///
			dpx_vars(`dpx_vars')			///
			dhat_vars(`dhat_vars')			///
			dhatpx_vars(`dhatpx_vars')		///
			bname(`b')				///
			vname(`V')				///
			vce_spec(`vce_spec')			///
			`laout_name'				///
			`laout_replace'				///
			subspace_list(`subspace_list')		///
			`reestimate'				///
			`resample_idx'				///
			xfold_idx(`k')				///
			`relog'					///
			`touse_esample'				///
			`qui'

		local subspace_list `s(subspace_list)'

		Post_b_V, xfolds(`xfolds')	///
			bname(`b')		///
			vname(`V')			

		mat `B_DML1' = (nullmat(`B_DML1') \ e(b))

		_dslasso_end_cflog, `dslog' k(`k') xfolds(`xfolds') ignore
	}

	sret local subspace_list `subspace_list'
					//-- get b and V for DML1 or DML2 --//
	tempname b V
	mata : _LASSO_ivorth_DML(	///
		`"`dml'"',		///
		`"`B_DML1'"',		///
		`"`ypx'"', 		///
		`"`dpx_vars'"',		///
		`"`dhatpx_vars'"', 	///
		`"`tt_vars'"',		///
		`"`gr'"', 		///
		`xfolds',		///
		`"`b'"',		///
		`"`V'"')
					//-- post result --//
	Post_b_V, repost		///
		xfolds(`xfolds')	///
		bname(`b')		///
		vname(`V')			
end
					//----------------------------//
					// standard IV approach 
					//----------------------------//
/*
	SIV implements Chernozhukov, alt. (2015a) Section 5 
	and Cherzhokov, alt. (2015b) Algorithm 1.
*/
program SIV, sclass
	syntax , touse(string)			///
		touse_esample(string)		///
		depvar(string)			///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		ypx(string)			///
		dhatpx_vars(string)		///
		dhat_vars(string)		///
		dpx_vars(string)		///
		bname(string)			///
		vname(string)			///
		[vce_spec(string)		///
		inst_vars(string)		///
		controls(string)		///
		exog(string)			///
		endog(string)			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		reestimate			///
		raw_inst(string)		///
		qui]

	ParseAinclude, exog(`exog') indeps(`controls' `raw_inst')
	local ainclude `s(ainclude)'
	local othervars `s(othervars)'
	
	_parse expand opts tmp : full_lasso_opts
	_parse expand names tmp : full_lasso_names
	_parse expand cmds tmp : full_lasso_cmds

/*
	Step 1: lasso y on x to select X_y
*/
	if (`"`controls'"' != "") {
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
		local cmds_1 `cmds_1'
		local subspace_list `s(subspace_list)'

		`cmds_1' linear `depvar' `controls' if `touse', `opts_1'
		local X_y `e(allvars_sel)'
	}


/*
	Step 2: post-lasso y on X_y
*/
	`qui' regress `depvar' `X_y' if `touse'

/*
	Step 3: get residuals: ypx = y - X_y*theta
*/
	tempvar tmp_ypx
	qui predict double `tmp_ypx' if `touse', residuals
	qui replace `ypx' = `tmp_ypx' if `touse'

	forvalues i=2/`names_n' {
/*
	Step 4: lasso tt_vars on controls and inst_vars to get predict tt_vars
*/
		local dvar `names_`i''
		local opt_orig `opts_`i''
		local cmd `cmds_`i''
				//--------------------- if dvar is endogenous
		if (`:list dvar in endog') {
			tempvar dvar_tmp
			qui gen double `dvar_tmp' = `dvar'
			
			if ( `"`controls'"' != "" | `"`inst_vars'"' != "") {
							//  initialize
							//  subspace_list 
				_lasso_add_subspace, 		///
					`laout_name' 		///
					`laout_replace'		///
					opt(`opt_orig')		///
					`reestimate'		///
					`resample_idx'		///
					`xfold_idx'		///
					subspace_list(`subspace_list')
				local opt `s(opt)'
				local subspace_list `s(subspace_list)'

						// lasso tt_vars on controls and
						// z with exog unpenalized
				`cmd' linear `dvar_tmp' `ainclude' 	///
					`othervars' if `touse',  	///
					`opt' depname(`dvar')
				local selected_vars `e(allvars_sel)'

						// check identification
				CheckIden, selected_vars(`selected_vars') ///
					raw_inst(`raw_inst')
			}

						// post lasso 
			`qui' regress `dvar_tmp' `selected_vars' if `touse'
			local k = `i' - 1
			local dhat : word `k' of `dhat_vars'
						// predict tt_vars
			tempvar tmp_dhat
			qui predict double `tmp_dhat' if `touse', xb
			qui replace `dhat' = `tmp_dhat' if `touse'
		}
		else {
				//--------------------- if dvar is exogenous
			local k = `i' - 1
			local dhat : word `k' of `dhat_vars'
			qui replace `dhat' = `dvar' if `touse'
		}

/*
	Step 5: lasso dhat on controls to get X_dhat
*/
		if (`"`controls'"' != "") {
						//  initialize subspace_list 
			_lasso_add_subspace, 		///
				`laout_name' 		///
				`laout_replace'		///
				opt(`opt_orig')		///
				`reestimate'		///
				`resample_idx'		///
				`xfold_idx'		///
				subspace_list(`subspace_list')
			local opt `s(opt)'
			local subspace_list `s(subspace_list)'

						// lasso dhat on controls
			`cmd' linear `dhat' `controls' if `touse', `opt' ///
				depname(pred(`dvar'))
			local X_dhat `e(allvars_sel)'
		}

						//  post-lasso
		`qui' regress `dhat' `X_dhat' if `touse'
		tempvar xv
		qui predict double `xv' if `touse', xb

		local dpx : word `k' of `dpx_vars'
		local dhatpx : word `k' of `dhatpx_vars'

						// form dvar - Xv
		qui replace `dpx' = `dvar' - `xv' if `touse'

						//  form dhat - Xv
		qui replace `dhatpx' = `dhat' - `xv' if `touse'
	}

/*
	Step 6: regress ypx on dpx with dhatpx_vars as instrument
*/
	`qui' regress `ypx' `dpx_vars' (`dhatpx_vars') if `touse', 	///
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
					// SIV_part1 : get ypx and dhat for all
					// the observations
					//----------------------------//
program SIV_part1, sclass
	syntax , touse_main(string)		///
		touse_aux(string)		///
		depvar(string)			///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_names(string)	///
		full_lasso_opts(string)		///
		ypx(string)			///
		dhat_vars(string)		///
		[qui				///
		inst_vars(string)		///
		controls(string)		///
		exog(string)			///
		endog(string)			///
		reestimate			///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		raw_inst(string)		///
		relog				///
		subspace_list(string)]

	ParseAinclude, exog(`exog') indeps(`controls' `raw_inst')
	local ainclude `s(ainclude)'
	local othervars `s(othervars)'
	
	_parse expand names tmp : full_lasso_names
	_parse expand opts tmp : full_lasso_opts
	_parse expand cmds tmp : full_lasso_cmds

/*
	1. lasso y on x in auxiliary sample
*/
	if (`"`controls'"' != "") {
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
		local cmds_1 `cmds_1'
		local subspace_list `s(subspace_list)'

		_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')
		`cmds_1' linear `depvar' `controls' if `touse_aux', `opts_1'
		local X_y `e(allvars_sel)'
	}

/*
	2. post-lasso y on X_y in auxiliary sample
*/
	`qui' regress `depvar' `X_y' if `touse_aux'

/*
	3. get ypx = y - x\theta in the main sample
*/
	tempvar tmp_ypx
	qui predict double `tmp_ypx' if `touse_main', res
	qui replace `ypx' = `tmp_ypx' if `touse_main'

/*
	Loop over tt_vars to do the following
*/
	forvalues i=2/`names_n' {
		local var `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''
				//--------------- if dvar is endogenous
		if (`:list var in endog') {
			tempvar dvar_tmp
			qui gen double `dvar_tmp' = `var'
			
			if (`"`controls'"' != "" | `"`inst_vars'"' !="") {
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

				/* 4. lasso d on x and z in auxiliary sample */

				_dslasso_relog_lasso_i, `relog'	///
					relog_i(`relog_i')

				`cmd' linear `dvar_tmp' `ainclude' 	///
					`othervars' if `touse_aux', 	///
					`opt' depname(`var')	
				local XZ_d `e(allvars_sel)'

						// check identification
				CheckIden, selected_vars(`XZ_d') ///
					raw_inst(`raw_inst') `relog'
			}

			/* 5. post-lasso d on ZX_d in auxiliary sample */
			`qui' regress `dvar_tmp' `XZ_d' if `touse_aux'

			/* 6. fill predicted d in main sample */
			tempvar tmp_dhat
			qui predict double `tmp_dhat' if `touse_main'
			local k = `i' - 1
			local dhat : word `k' of `dhat_vars'
			qui replace `dhat' = `tmp_dhat' if `touse_main'
		}
		else {
				//--------------- if dvar is exogenous
			local k = `i' - 1
			local dhat : word `k' of `dhat_vars'
			qui replace `dhat' = `var' if `touse_main'
			
		}
	}
	_dslasso_relog_lasso_end, `relog'

	sret local subspace_list `subspace_list'
end
					//----------------------------//
					// SIV_part2: get dpx, dhatpx 
					//----------------------------//
program SIV_part2, sclass
	syntax , touse_main(string)		///
		touse_aux(string)		///
		touse_esample(string)		///
		tt_vars(string)			///
		full_lasso_cmds(string)		///
		full_lasso_opts(string)		///
		full_lasso_names(string)	///
		ypx(string)			///
		dpx_vars(string)		///
		dhat_vars(string)		///
		dhatpx_vars(string)		///
		bname(string)			///
		vname(string)			///
		[vce_spec(string)		///
		controls(string)		///
		laout_name(passthru)		///
		laout_replace(passthru)		///
		subspace_list(string)		///
		reestimate			///
		xfold_idx(passthru)		///
		resample_idx(passthru)		///
		relog				///
		qui]

	_parse expand opts tmp  : full_lasso_opts
	_parse expand names tmp  : full_lasso_names
	_parse expand cmds tmp  : full_lasso_cmds

	forvalues i=2/`opts_n' {

		local k = `i' - 1
		local dhat : word `k' of `dhat_vars'
		local dvar `names_`i''
		local opt `opts_`i''
		local cmd `cmds_`i''

		if (`"`controls'"' != "") {
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

			/* 1. lasso dhat on x in auxiliary sample */
			_dslasso_relog_lasso_i, `relog' relog_i(`relog_i')

			`cmd' linear `dhat' `controls' if `touse_aux' ,  ///
				`opt' depname(pred(`dvar'))
			local X_dhat `e(allvars_sel)'
		}

		/* 2. post-lasso dhat on X_dhat in auxiliary sample */
		`qui' regress `dhat' `X_dhat' if `touse_aux'

		/* 3. get XV in main sample */
		tempvar xv
		qui predict double `xv' if `touse_main'

		/* 4. get dpx in the main sample */
		local dpx : word `k' of `dpx_vars'
		local dvar `names_`i''
		qui replace `dpx' = `dvar' - `xv' if `touse_main'

		/* 5. get dhatpx in the main sample */
		local dhatpx : word `k' of `dhatpx_vars'
		qui replace `dhatpx' = `dhat' - `xv' if `touse_main'
	}
	_dslasso_relog_lasso_end, `relog'

	/* 6. 2SLS ypx on dpx with dhatpx as instruments in the main sample */
	`qui' regress `ypx' `dpx_vars' (`dhatpx_vars') if `touse_main',  ///
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
					// Post  b and V
					//----------------------------//
program Post_b_V, eclass
	syntax , xfolds(string)		///
		bname(string)		///
		vname(string)		///
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
		inst_vars(string)	///
		xfolds(string)		///
		model(string)		///
		n_obs(string)		///
		dml(string)		///
		resample_num(string)	///
		resample_method(string)	///
		laout_name(string)	///
		cmd(string)		///
		[vce(string)		///
		exog(string)		///
		endog(string)		///
		controls(string)	///
		raw_controls(string)	///
		cmdline(string)		///
		zero(string)		///
		subspace_list(string)	///
		vcetype(string)		///
		rngstate(string)	///
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
	eret scalar k_inst = `:list sizeof inst_vars'
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
	
	eret local exog `exog'
	eret local endog `endog'
	eret local controls `raw_controls'
	eret local inst `inst_vars'
	eret local model `model'
	eret local vce `vce'
	eret local vcetype `vcetype'
	eret local clusterv `cluster'
	eret hidden local dml `dml'
	eret hidden local resample_method `resample_method'
	if (`xfolds' == 1) {
		eret local title "Partialing-out IV `model' model"
	}
	else {
		eret local title `"Cross-fit partialing-out"'
		eret local title2 `"IV `model' model"'
	}
	eret hidden local sel_title 	///
		title("Partialed-out IV LASSO selection summary")
	eret hidden local stxer stxer
	eret hidden local lasso lasso 
	eret hidden local lasso_infer lasso_infer
	eret local marginsnotok _ALL

						// cmd
	eret local rngstate `rngstate'
	eret local predict `cmd'_p
	eret local select_cmd `cmd'_select
	eret hidden local zero `zero'
	eret local cmdline `cmdline'
	eret local cmd `cmd' 

						// compute chi2
	_dslasso_chi2

						//  post subspace_list
	_dslasso_post_laout , laout_name(`laout_name') 	///
		subspace_list(`subspace_list') 		///
		inst_vars(`inst_vars')			///
		exog(`exog')				///
		iv

	_dslasso_fromeclass, laout_name(`laout_name')
end
					//----------------------------//
					// parse ainclude for tt_vars
					//----------------------------//
program ParseAinclude, sclass
	syntax [, exog(string)		///
		indeps(string) ]
						// parse indeps	
	_lasso_parse_controls `indeps'
	local ainclude `s(ainclude)'
	local othervars `s(othervars)'
						// merge exog with ainclude
						// in indeps()
	local ainclude `exog' `ainclude' 

	if (`"`ainclude'"' != "") {
		sret local ainclude (`ainclude')
	}
	sret local othervars `othervars'
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

					//----------------------------//
					// Check identification
					//----------------------------//
program CheckIden
	syntax [, selected_vars(string)		///
		raw_inst(string) 		///
		relog]
	
	local sel_inst : list selected_vars & raw_inst	

	if (`"`relog'"' != "") {
		local nl _newline
	}

	if (`"`sel_inst'"' == "") {
		di as err `nl' "equation not identified"
		di "{p 4 4 2}"
		di as err "Must have at least as many selected instruments " ///
			"not in the regression as there are instrumented "   ///
			"variables."
		di "{p_end}"
		exit 481
	}
end
 
exit

Reference:

Chernozhukov, Victor, Christian Hansen, and Martin Spindler. "Valid
Post-Selection and Post-Regularization Inference: An Elementary, General
Approach." Annu. Rev. Econ. 7.1 (2015a): 649-688.

Chernozhukov, Victor, Christian Hansen, and Martin Spindler. "Post-selection
and post-regularization inference in linear models with many controls and
instruments." American Economic Review 105.5 (2015b): 486-90.
