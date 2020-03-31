*! version 1.1.0  30mar2018
// spxtreg_re is used by spxtregress.ado. It fits the model for spatial panel
// data with random effects

program spxtreg_re
	version 15.0

	if replay() {
		Playback `0'
	}
	else {
		Estimate `0'
	}
end
					//-- Playback  --//
program Playback
	syntax [, *]

	if (`"`e(cmd)'"'!="spxtregress") {
		di as err "results for {bf:spxtregress} not found"
		exit 301
	}
	else {
		Display `0'
	}
end
					//-- Display --//
program Display
	syntax [anything] [if] [in] [,*]
	_get_diopts diopts tmp, `options'

 	Header
	_coef_table, `diopts' 
	Footnote
	ml_footnote
end
					//-- Estimate --//
program Estimate, eclass
	tempname SPXTREG_RE MLOPT
	capture noisily {
		syntax anything [if] [in] [,*]
		marksample touse
							// parse syntax
		ParseSyntax `SPXTREG_RE' `MLOPT',	///
			touse(`touse')			///
			: `0'
							// fit the model
 		mata : _st_SPXTREG_RE__fit("`SPXTREG_RE'")
	}

	local rc = _rc
	capture mata : rmexternal("`SPXTREG_RE'")
	capture mata : rmexternal("`MLOPT'"')
	capture drop `SPXTREG_RE'*
	if (`rc'!=0) exit `rc'

 	eret local predict spxtregress_p
 	eret local estat_cmd spxtregress_estat
	eret local cmdline spxtregress `0'
	eret local marginsok RForm xb direct indirect
	eret local marginsnotok 
	eret local cmd spxtregress
	Display `0'
end
					//-- ParseSyntax  --//
program ParseSyntax 
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'
	
	local 0 `before'
	syntax anything(name=obj_names) , touse(string)	
	local SPXTREG_RE : word 1 of `obj_names'
	local MLOPT : word 2 of `obj_names'

	local 0 `after'
	syntax anything(name=eq id="equation")	///
		[if] [in],			///
		re				///
		[SARPANel			///
		vce(passthru)			/// undocumented
		noCONstant			///
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
		*]				// repeatable ivarlag, dvarlag,
						// ielag
	
	_get_diopts diopts options, `options'

	ParseCrittype , `vce'
	local crittype `s(crittype)'

	 _spreg_mlopts `MLOPT': ,		///
	 		`difficult'		///
			`technique'		///
			`iterate'		///
			`log'			///
			`nolog'			///
			`trace'			///
			`gradient'		///
			`showstep'		///
			`hessian'		///
			`showtolerance'		///
			`tolerance'		///
			`nrtolerance'		///
			`nonrtolerance'		///
			crittype(`crittype')

	Parse_spxtreg_re `SPXTREG_RE' `MLOPT'	///
		, touse(`touse')		///
		: `eq',				///
		`constant'			///
		`sarpanel'			///
		`vce'				///
		`log' `nolog'			///
		`verbose'			///
		`force'				///
		`options'
end
					//-- Parse_spxtreg_re --//
program Parse_spxtreg_re
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0 `before'
	syntax anything(name=obj_names) , touse(string)	
	local SPXTREG_RE : word 1 of `obj_names'
	local MLOPT : word 2 of `obj_names'

	local 0 `after'
	syntax	anything(name=eq id="equation")	///
		[, noCONstant			///
		sarpanel			///
		vce(string)			///
		NOLOg LOg			///
		Verbose				///
		force				///
		*]
						// parse common options	
	_spxtreg_common_parse `SPXTREG_RE',	///
		touse(`touse'):			///
		`eq',				///
		`constant'			///
		`log' `nolog'			///
		`verbose'			///
		`force'				///
		`options'

	local depvar `r(depvar)'
	local indeps `r(indeps)'
	local indeps_lbs `r(indeps_lbs)'
	local rho_lbs `r(rho_lbs)'
	local dlmat_list `r(dlmat_list)'
	local elmat_list `r(elmat_list)'
	local lag_list_full `r(lag_list_full)'
	local touse `r(touse)'
	local id `r(id)'
	local covariates `r(covariates)'
	local timevar `r(timevar)'
	local panelvar `r(panelvar)'
	local timevalues `r(timevalues)'
	local log = `r(log)'
	local verbose	= `r(verbose)'
	local cn = `r(cn)'
						// auxiliary
	local test_vars `r(test_vars)'
	local exog_wy_lbs `r(exog_wy_lbs)'
	local exog_wy_index `r(exog_wy_index)'
	local x `r(x)'
						// label for sigma 
	local sig_u_lbs	= `"sigma_u:_cons"'
	local sig_e_lbs = `"sigma_e:_cons"'
						// Check SARAR(1,1)
	CheckSARAR, dlmat(`dlmat_list') elmat(`elmat_list')
						// Parse exog X
	ParseX_exog, dlmat(`dlmat_list') 	///
		indeps(`indeps')		///
		indeps_lbs(`indeps_lbs') 
	local X_exog `s(X_exog)'
	local X_exog_lbs `s(X_exog_lbs)'
	local endog_wy `s(endog_wy)'
	local endog_wy_lbs `s(endog_wy_lbs)'
						// Parse vce
	ParseVce , vce(`vce')	
	local vce `s(vce)'
	local vcetype `s(vcetype)'
						// sarpanel
	local sarpanel `sarpanel'
						//  CheckNoconstant
	CheckNoConstant, exog(`X_exog') `constant'

	capture mata : rmexternal("`SPXTREG_RE'")
	mata : _st_SPXTREG_RE__parse("`SPXTREG_RE'", "`MLOPT'")
end
					//-- check sarar(1,1)  --//
program CheckSARAR
	syntax [, dlmat(string) elmat(string)]

	if ( wordcount(`"`dlmat'"') > 1 ) {
		di as error "{bf:spxtregress, re} only allows one "	///
			"{bf:dvarlag()} option"
		exit(198)
	}
	if (wordcount(`"`elmat'"')>1 ) {
		di as error "{bf:spxtregress, re} only allows one "	///
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
	sret local endog_wy `endog_wy'
	sret local endog_wy_lbs `endog_wy_lbs'
end
					//-- Parse vce type --//
program	ParseVce , sclass
	syntax [, vce(string)]

	if (`"`vce'"' == ""){
		local vce oim
		local vcetype
	}
	else {
		_vce_parse, opt(OIM) : , vce(`vce')	
		if ("`r(vce)'" == "oim") {
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
					//-- Footnote --//
program Footnote
	if (`"`e(lag_list_full)'"'=="") exit
        di in gr  "Wald test of spatial terms:" 			///
		_col(38) "chi2(" in ye `e(df_c)' in gr ") = " 		///
		in ye %-8.2f e(chi2_c)					///
		_col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
end
					//-- Header --//
program Header
	di _n as txt "Random-effects spatial regression"		///
		_col(49) as txt "Number of obs" _col(67) "="	///
		_col(69) as res %10.0fc e(N)
	di as txt "Group variable: " as res abbrev(`"`e(idvar)'"',12)	///
		_col(49) as txt "Number of groups" _col(67) "="		///
		_col(69) as res %10.0fc e(N_g) 
	di as txt _col(49) "Obs per group" _col(67) "="	///
		_col(69) as res %10.0fc e(g)
	di 
	di as txt _col(49) "Wald chi2(" as res e(df_m) as txt ")"	///
		_col(67) "=" _col(70) as res %9.2f e(chi2)	
	di as txt _col(49) "Prob > chi2" _col(67) "="	///
		_col(73) as res %6.4f e(p)
	local crittype	= upper(substr("`e(crittype)'", 1, 1)) +  ///
		substr("`e(crittype)'", 2, length("`e(crittype)'"))
	di as txt "`crittype' =" _skip(1) as res %10.4f e(ll)	///
		_col(49) as txt "Pseudo R2" _col(67) "="	///	
		_col(73) as res %6.4f e(r2_p)	
	di
end
					//-- CheckNoConstant --//
program CheckNoConstant 
	syntax [, exog(string)	///
		noCONstant]
	
	if (`"`constant'"'=="noconstant" & `"`exog'"'=="") {
		di "{p 0 0 2}"
		di as err "one or more variables must be specified "	///
			"in indepvars when the option {bf:noconstant} "	///
			"is specified"
		di "{p_end}"
		exit 198
	}
end
