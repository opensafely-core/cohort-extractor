*! version 1.1.0  30mar2018
program _spreg_ml_parse
	version 15.0

	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local 0 `before'
	syntax anything(name=obj_names), 	///
		touse(string) 			///
		cns(string)			

	local SPREG : word 1 of `obj_names'
	local MLOPT : word 2 of `obj_names'

	local 0 `after'
	syntax anything(name = eq 		///
		id="equation")			///
		[if] [in]			///
		[, ml				///
		noCONStant			///
		CONSTraints(passthru)		///
		GRIDsearch(passthru) 		///
		vce(passthru)			///
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
		Verbose				/// undocumented
		*]				//  ivarlag,  errorlag, dvarlag
	
	_get_diopts diopts options, `options'

	ParseCrittype , `vce'
	local crittype `s(crittype)'
	 
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
	
	CheckTechnique, `technique'
	
	Parse_spreg_ml  `SPREG' `MLOPT'	///
		, touse(`touse')	///
		cns(`cns')		///
		: `eq',			///
		`constant'		///
		`log' `nolog'		///
		`verbose'		///
		`constraints'		///
		`gridsearch'		///
		`vce'			///
		`force'			///
		`options'
end

					//-- Parse spreg ml  --//
program Parse_spreg_ml, rclass

	_on_colon_parse `0'

	local before `s(before)'
	local after `s(after)'
	
	local 0 `before'
	syntax anything(name=obj_names),	///
		touse(string)		///
		cns(string)		

	local SPREG : word 1 of `obj_names'
	local MLOPT : word 2 of `obj_names'
	
	local 0 `after'
	syntax anything(name = eq 		///
		id="equation")			///
		[,				///
		noCONStant			///
		CONSTraints(string)		///
		GRIDsearch(passthru) 		///
		vce(string)			///
		Verbose				///
		NOLOg LOg			///
		force				///
		*]				// ivarlag, dvarlag, errorlag
	
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
	local exog_wy_lbs `r(exog_wy_lbs)'
	local exog_wy_index `r(exog_wy_index)'
	local cn = `r(cn)'
	local test_vars `r(test_vars)'
						// label for sigma	
	local sig2_lbs	= `"sigma:_cons"'
						// Parse Gridsearch
	ParseGridSearch , `gridsearch'
	local gridsearch = `s(gridsearch)'
						// Parse Constraints
	ParseConstraints , cns(`cns') 		///
		constraints(`constraints')	///
		indeps_lbs(`indeps_lbs')	///
		rho_lbs(`rho_lbs')		///
		sig2_lbs(`sig2_lbs')		///
		depvar(`depvar')
	local Cns  `e(Cns)'
	local k_autoCns = `e(k_autoCns)'
						// Check SARAR(1,1)
	CheckSARAR, dlmat(`dlmat_list') elmat(`elmat_list')
						// Parse exog X
	ParseX_exog, dlmat(`dlmat_list') 	///
		indeps(`indeps')		///
		indeps_lbs(`indeps_lbs') 
	local X_exog `s(X_exog)'
	local X_exog_lbs `s(X_exog_lbs)'
						// Parse vce
	ParseVce , vce(`vce')	
	local vce `s(vce)'
	local vcetype `s(vcetype)'
	
	capture mata : rmexternal("`SPREG'")
	mata : _st_SPREG_ML__parse("`SPREG'", "`MLOPT'")
end
					//-- Parse Grid search  --//
program ParseGridSearch, sclass
	syntax [, GRIDsearch(real 0.1)] 		///

	if (`gridsearch' < 0.001 | `gridsearch' > 0.1) {
		di as error "option {bf:gridsearch()} requires a real " ///
			"number between 0.001 and 0.1 inclusive"
		exit(198)
	}
	sret local gridsearch	= `gridsearch'
end
					//-- Parse Constraints  --//
program ParseConstraints, eclass
	syntax , cns(string)		///
		[CONSTraints(string)	///
		indeps_lbs(string)	///
		rho_lbs(string)		///
		sig2_lbs(string)	///
		depvar(string)]

	local coef_label `indeps_lbs' `rho_lbs' `sig2_lbs'
	mata : extract_lb(`"`coef_label'"',`"`depvar'"')
	local k : word count `coef_label'	
	tempname b V
	mat `b'	= J(1, `k', 1)
	mat `V'	= `b''*`b'
	matrix colnames `b' = `coef_label'
	matrix colnames `V' = `coef_label'
	matrix rownames `V' = `coef_label'
	ereturn post `b' `V'

	makecns `constraints'	

	if (`"`e(Cns)'"'== "matrix") {
		mat `cns'	= e(Cns)
		local Cns	= `"`cns'"'
		local k_autoCns	= r(k_autoCns)
	}
	else {
		local Cns	= ""
		local k_autoCns	= 0
	}

	eret local Cns `Cns'
	eret local k_autoCns = `k_autoCns'
end
					//-- check sarar(1,1)  --//
program CheckSARAR
	syntax [, dlmat(string) elmat(string)]

	if ( wordcount(`"`dlmat'"') > 1) {
		di as error "{bf:spregress, ml} only allows one "	///
			"{bf:dvarlag()} option"
		exit(198)
	}

	if ( wordcount(`"`elmat'"')>1 ) {
		di as error "{bf:spregress, ml} only allows one "	///
			"{bf:errorlag()} option"
		exit(198)
	}
end
					//-- Parse X_exog  --//
program ParseX_exog, sclass
	syntax [, dlmat(string) 	///
		indeps(string)		///
		indeps_lbs(string) ]

	local k	= wordcount(`"`indeps'"')

	if (wordcount(`"`dlmat'"')==1) {
		local endog_wy : word `k' of `indeps'
		local endog_wy_lbs : word `k' of `indeps_lbs'
	}
	local X_exog : list indeps - endog_wy
	local X_exog_lbs : list indeps_lbs - endog_wy_lbs
	sret local X_exog `X_exog'
	sret local X_exog_lbs `X_exog_lbs'
end
					//-- Parse vce type --//
program	ParseVce , sclass
	syntax [, vce(string)]

	if (`"`vce'"' == ""){
		local vce oim
		local vcetype
	}
	else {
		_vce_parse, opt(OIM Robust) : , vce(`vce')	
		if ("`r(vce)'"=="robust") {
			local vce robust
			local vcetype Robust
		}
		else if ("`r(vce)'" == "oim") {
			local vce oim	
			local vcetype
		}
	}
	sret local vce `vce'
	sret local vcetype `vcetype'
end
					//-- Parse crittype --//
program ParseCrittype, sclass
	syntax [,vce(passthru)]
	ParseVce , `vce'
	local vce `s(vce)'
	if (`"`vce'"'=="robust") {
		local crittype "log pseudolikelihood"	
	}
	else {
		local crittype "log likelihood"
	}
	sret local crittype `crittype'
end

program CheckTechnique
	syntax [, technique(string) ]

	if (`"`technique'"'== "") {
		exit
		// NotReached
	}
	local bhhh bhhh
	local in : list bhhh in technique

	if (`in') {
		di as error "{bf:spregress, ml} does not "	///
			"allow {bf:bhhh} technique"
		exit 198
	}
end

					//-- remove all the parts before "*",
					//for example, endog*W1:y becomes W1:y
mata :
void extract_lb(			///
	string scalar coef_label,	///
	string scalar depvar)
{
	transmorphic		t
	string rowvector	lbs, s, lbs_out
	real scalar		i
	
	lbs	= tokens(coef_label)
	lbs_out	= J(1, cols(lbs), "")
	t 	= tokeninit("","*")
	
	for (i=1; i<cols(lbs); i++) {
		tokenset(t, lbs[i])	
		s	= tokengetall(t)

		if (cols(s)==1) {
			lbs_out[i]	= s
		}
		else if (cols(s)==3) {
			lbs_out[i]	= s[3]
		}
	}

	lbs_out[cols(lbs)] = "/var:e."+depvar

	lbs_out	= invtokens(lbs_out)
	st_local("coef_label", lbs_out)
}
end
