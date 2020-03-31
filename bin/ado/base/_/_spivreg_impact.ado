*! version 1.0.7  05apr2017
program _spivreg_impact, rclass sortpreserve
	version 15.0
	syntax [varlist(default=none fv numeric)] 		///
		[if] [in]					///
		[, vce(string) 					///
		nolog						///
		*]
						// CheckEmptyCovariates
	CheckEmptyCovariates	
						// parse id
	__sp_parse_id	
	local id `s(id)'
						// parse diopts 
	_get_diopts diopts, `options'
						//  vce type
	ParseVCE `if' `in', vce(`vce')
	local vcetype `s(vcetype)'
	local vce `s(vce)'
						//  touse
	if (`"`if'"' !="" | `"`in'"'!="") {
		marksample touse, novarlist		
	}
	else {
		tempvar touse
		qui gen byte `touse' = e(sample)
	}
						//  Check no observation errors
	NoObsError, touse(`touse')
						//  esample
	tempvar esample
 	qui gen byte `esample' = e(sample)
						// make sure that esample is a
						// bigger set than touse
	CheckTouse, touse(`touse') esample(`esample') 

	tempname fv_info
	ParseXvars `varlist', fv_info(`fv_info')
	local xvars `s(xvars)'
						// MatchID
	local lag_list `e(lag_list_full)'
	_spreg_match_id, id(`id') touse(`esample') lag_list(`lag_list')

	mata : _spivreg_impact(		///
		`"`esample'"', 		///
		`"`touse'"',		///
		`"`xvars'"', 		///
		`"`fv_info'"',		///
		`"`vce'"',		///
		`"`log'"')
	tempname b V
	mat `b'	= return(b)
	mat `V'	= return(V)
	local n_obs = return(N)
	ret local xvars `xvars'

	Display , n_obs(`n_obs')	///
		vcetype(`vcetype') 	///
		b(`b') 			///
		v(`V') 			///
		`diopts' 		///
		xvars(`xvars')
end

program ParseVCE, sclass
	syntax [if] [in] [, vce(string)]

	if (`"`vce'"'=="") local vce delta

	if (`"`vce'"'=="unconditional") {
		local vcetype Unconditional
		local vce unconditional
	}
	else if(`"`vce'"'=="delta") {
		local vcetype Delta-Method
	}
	else {
		di as err "vcetype `vce' not allowed"
		exit 198
	}

	if (`"`vce'"'== "unconditional" 	///
		& ( `"`if'"'!="" | `"`in'"' !="") ) {
		di as err "if and in are not allowed when option "	///
			"{bf:vce(unconditional)} is specified"	
		exit 198
	}
	sret local vcetype `vcetype'
	sret local vce `vce'
end

program Display
	syntax ,n_obs(string)		///
		b(string) 		///
		v(string) 		///
		[ vcetype(string) 	///
		xvars(passthru) * ]
	Head, `xvars' n_obs(`n_obs')
	tempname ehold
	_est hold `ehold', restore
	PostIt, b(`b') v(`v') vcetype(`vcetype')
	_coef_table, `options' noempty coeftitle(dy/dx)
end

program Head
	syntax , xvars(string)	///
		n_obs(string)
	di 
	di as txt "Average impacts" 			///
		_col(49) "Number of obs" _col(67) "="	///
		_col(69) as res %10.0fc `n_obs'
	di
end

program PostIt, eclass
	syntax , b(string) v(string) [ vcetype(string)]
	eret post `b' `v'
	eret local vcetype `vcetype'
	eret local cmd spivreg_impact
end

program ParseXvars, sclass
	syntax [varlist(default=none fv numeric)],	///
		fv_info(string)

	if (`"`varlist'"'=="") {
		local xvars `e(covariates)'
	}
	else {
		fvexpand `varlist'
		local varlist `r(varlist)'
		cap _ms_dydx_parse `varlist'
		if _rc {
			di as err "{bf:`varlist'} not found "	///
				"in list of covariates"
			exit _rc
		}
		local xvars `r(varlist)'
	}

	_sp_build_fv_info, xvars(`xvars') fv_info(`fv_info')
	sret local xvars `s(xvars)'
end

					//-- CheckEmptyCovariates --//
program CheckEmptyCovariates 
	if (`"`e(covariates)'"' == "") {
		di as err "model contains no indepvars"	
		exit 322
	}
end
					//-- Check touse is subsample of touse
program CheckTouse
	syntax , touse(string) esample(string)
	cap qui assert `esample' == 1 if `touse'
	if _rc {
		di as err "prediction sample must be a subset of e(sample)" 
		exit 498
	}
end
					//-- NoObsError --//
program NoObsError
	syntax [, touse(string)	]
	qui sum `touse' if `touse'
	local n_obs	= r(N)
	if (`n_obs'==0) {
		error 2000
	}
end
