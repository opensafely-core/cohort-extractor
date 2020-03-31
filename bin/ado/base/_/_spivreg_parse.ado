*! version 1.1.0  30mar2018
program _spivreg_parse
	version 15.0

	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local 0 `before'
	syntax anything(name=obj_names), 	///
		touse(string)			

	local SPREG : word 1 of `obj_names'
	local MLOPT : word 2 of `obj_names'

	local 0 `after'
	syntax anything(name = eq 		///
		id="equation")			///
		[if] [in]			///
		[, gs2sls			///
		ERRorlag(passthru)		///
		noCONstant			///
		HETeroskedastic			///
		impower(passthru)		/// 
		force				///
		DIFficult	    		/// Maximization Options 
		TECHnique(passthru)    		///
		ITERate(passthru)     		///
		NOLOg LOg		   	///
		TRace        			///
		GRADient     			///
		showstep    			///
		HESSian     			///
		SHOWTOLerance			///
		TOLerance(passthru)   		///
		LTOLerance(passthru)  		///
		NRTOLerance(passthru) 		///
		NONRTOLerance			///
		Verbose				/// not documented
		*]				//  ivarlag, dvarlag, errorlag

	local crittype "GMM criterion"
	 _spreg_mlopts `MLOPT': ,		///
	 		`difficult'		///
			`technique'		///
			`iterate'		///
			`log' `nolog'		///
			`trace'			///
			`gradient'		///
			`showstep'		///
			`hessian'		///
			`showtolerance'		///
			`tolerance'		///
			`nrtolerance'		///
			`nonrtolerance'		///
			crittype(`crittype')
		
	_get_diopts diopts options, `options'

	Parse_spivreg  `SPREG' 		///
		, touse(`touse'):	///
		`eq',			///
		`errorlag'		///
		`constant'		///
		`heteroskedastic'	///
		`impower'		///
		`log' `nolog'		///
		`verbose'		///
		`force'			///
		`options'
	
end
					//-- Parse spivreg  --//
program Parse_spivreg, rclass

	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local 0 `before'
	syntax anything(name=SPREG), 	///
		touse(string)		

	local 0 `after'
	syntax anything(name = eq 		///
		id="equation")			///
		[if] [in]			///
		[, ERRorlag(passthru)		///
		noCONstant			///
		NOLOg LOg			///
		HETeroskedastic			///
		impower(passthru)		/// 
		Verbose				/// not documented
		force				///
		*]				//  ivarlag, dvarlag, errorlag

						// parse common options
	_spreg_common_parse `SPREG', 	///
		touse(`touse'):		///
		`eq',			///
		`errorlag'		///
		`constant'		///
		`verbose'		///
		`log' `nolog'		///
		`force'			///
		`options'		
	local depvar `r(depvar)'	
	local indeps `r(indeps)'
	local indeps_lbs `r(indeps_lbs)'
	local rho_lbs `r(rho_lbs)'
	local exog `r(exog)'
	local exog_lbs `r(exog_lbs)'
	local endog `r(endog)'
	local endog_lbs `r(endog_lbs)'
	local dlmat_list_full `r(dlmat_list_full)'
	local dlmat_list `r(dlmat_list)'
	local elmat_list `r(elmat_list)'
	local lag_list_full `r(lag_list_full)'
	local verbose = `r(verbose)'
	local log = `r(log)'
	local touse `r(touse)'
	local id `r(id)'
	local covariates `r(covariates)'
						// auxiliary
	local x `r(x)'
	local x_lbs `r(x_lbs)'
	local wy_list `r(wy_list)'
	local wy_index `r(wy_index)'
	local wy_vars `r(wy_vars)'
	local wy_lbs `r(wy_lbs)'
	local const_var `r(const_var)'
	local wy_n = `r(wy_n)'
	local endog_wy_lbs `r(endog_wy_lbs)'
	local exog_wy_lbs `r(exog_wy_lbs)'
	local exogr `r(exogr)'
	local inst `r(inst)'
	local instd `r(instd)'
	local cn = `r(cn)'
	local endog_wy_index `r(endog_wy_index)'
	local exog_wy_index `r(exog_wy_index)'
	local test_vars `r(test_vars)'
						// parse heteroskedastic
	ParseHetero, `heteroskedastic'
	local hetero = `s(hetero)'
						// parse impower
	ParseImpower, `impower'
	local impower = `s(impower)'

	capture mata : rmexternal("`SPREG'")
 	mata : _st_SPREG__parse("`SPREG'")
end
					//-- Parse Heteroskedastic  --//
program ParseHetero, sclass
	syntax [, HETeroskedastic]
	
	if ("`heteroskedastic'" == "heteroskedastic") {
		local hetero	= 1
	}
	else {
		local hetero	= 0
	}
	sret local hetero = `hetero'
end
					//-- Parse impower --//
program ParseImpower, sclass
	syntax [, impower(integer 2)]

	if (`impower' >= 6  | `impower' < 1) {
		di as error "option {bf:impower()} requires an integer " ///
			"number between 1 and 5"
		exit(198)
	}

	sret local impower = `impower'
end
