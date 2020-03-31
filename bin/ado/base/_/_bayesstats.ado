*! version 1.1.0  22apr2019
program _bayesstats, rclass

	syntax [anything] [using], MCMCOBJECT(string) ///
		 [SHOWREffects SHOWREffects1(string)  ///
		 CHAINs(string) SEPCHAINs PREDictiondata *]
	gettoken subcmd anything : anything
	local anything `anything' //trim leading spaces

	if ("`e(cmd)'" == "bayesmh" | "`e(latparams)'" == "" ) & ///
		("`showreffects'" != "" | "`showreffects1'" != "") {
		di as err "{p}options {bf:showreffects} and " ///
			"{bf:showreffects()} are supported only after " ///
			"multilevel models fit using the {helpb bayes} " ///
			"prefix{p_end}"
		exit 198
	}

	local usefile
	if `"`using'"' != "" {
		gettoken tok using : using
		global BAYESPR_using `using'
		global BAYESPR_caller bayesstats `subcmd'
		_bayespredict estrestore `"`using'"'
		local usefile `s(predfile)'
		if `"`anything'"' == "" {
			local anything `s(predynames)' `s(predfnames)'
		}
		if `"`chains'"' == "" {
			local chains `"`s(chains)'"'
		}
		global BAYESPR_using `usefile'
		_bayespredict_parse `"`anything'"'
		if `"`s(expr)'"' != "" {
			local predictiondata predictiondata
		}
	}

	if `"`predictiondata'"' != "" {
		local thetas `anything'
	}
	else {
		// parse paramref
		_bayesmhpost_paramlist thetas : `"`anything'"' ///
			`"`showreffects'"' `"`showreffects1'"'
	}

	if "`sepchains'" != "" && `"`chains'"' == "" {
		local chains _all
	}
	_bayes_chains parse `"`chains'"'
	local chains `r(chains)'

	if "`subcmd'" == "grubin" {
		if "`sepchains'" != "" {
			di as err `"option {bf:sepchains} is not "' ///
			"supported by {bf:bayesstats grubin}"
			exit 198
		}
		if "`chains'" != "" {
			di as err `"option {bf:chains()} is not "' ///
			"supported by {bf:bayesstats grubin}"
			exit 198
		}
	}
		
	// call subcommand	
	if `"`chains'"' != "" {
		local chains `"chains(`chains')"' 
	}

	_bayesstats_`subcmd' "`mcmcobject'" `"`thetas'"' ///
	`"`chains' `sepchains' `options' using(`usefile') `predictiondata'"'
	return add
end

program _bayesstats_ess, rclass

	args mcmcobject thetas opts

	local vv = _caller()

	local 0 , `opts'
	syntax [, USING(string) CHAINs(string) SEPCHAINs PREDictiondata * ]

	// check and parse common options
	_bayesmhpost_options `"`options'"'
	local every = `s(skip)'+1
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	local opchains
	if `"`chains'"' != "" {
		local opchains `"chains(`chains')"' 
	}

	local nchains: word count `e(allchains)'
	if "`chains'" != "" {
		local nchains: word count `chains'
	}

	tempname essmat	meanmat medianmat
	tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail 
	tempname mcsemat mcsefail quantmat hpdmat covmat indepvars cnsmat

	local clevel 0.95
	
	// display results
	local col1len  = 13
	local linesize = 51
	
	if "`sepchains'" != "" {

		di
		di as txt "Efficiency summaries"

		if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
			di 
			_mcmc_expr legend `"`exprlegend'"'
		}

		local firstchain 0
		foreach ch of local chains {
		
	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels'	///
			    chains(`ch') `predictiondata'
	
	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'

	// check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_min_chain_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}

	// update maximum correlation lag based on current MCMC size
	qui _bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'
	
	// set m_LV_names needed in stata_report
	if "`e(eq_names)'" != "" {
		mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
	}
	if "`e(k_eq_base)'" != "" {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
	}
	mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0), 0, ///
		`corrlag', `corrtol', `clevel', J(1,0,0))
	
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`meanmat'",	"`medianmat'",				///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		0/*no HPD*/,	"`nobaselevels'" != "",			///
		""/*melabel*/, ""/*lpclassmat*/, "`cnsmat'")

	capture confirm matrix `essmat'
	if _rc {
		di as err "cannot obtain efficiency summaries " ///
		     `"for parameters {bf:`thetas'}"'
		exit _rc
	}
	
	// obtain the width of the table
	qui _matrix_table `essmat', formats(%10.2f %11.2f %12.4f) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-27
	local eqpos  = `linesize'-10
	local numpos = `linesize'-9
	
	di
	di as txt "Chain `ch'" _col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="  _col(`numpos') as res %10.0fc `mcmcsize'

	if `numpars' > 1 & `mineff' < `maxeff' { 
		local effpos = `labpos'+13
		di _col(`labpos') as txt "Efficiency:"		///
			_col(`effpos') "min ="	 	 	///
			_col(`numpos') as res %10.4g `mineff'
		di _col(`effpos') as txt "avg ="		///
			_col(`numpos') as res %10.4g `avgeff'
		di as txt `LML'					///
			_col(`effpos') as txt "max ="	 	///
			_col(`numpos') as res %10.4g `maxeff'
	}
		
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di
		_mcmc_expr legend `"`exprlegend'"'
	}
	_mcmc_table ess `numpars' `"`parnames'"' `essmat' `"`diopts'"' `linesize'
	_mcmc_mcsefailnote `mcsefail' `linesize'
	
	matrix colnames `essmat' = "ESS" "Corr time" "Efficiency"
	matrix rownames `essmat' = `parnames'

	if `firstchain' == 0 {
		local firstchain 1
		return clear
		_mcmc_expr return `"`exprlegend'"'
		return add
		return local names	= `"`parnames'"'
		return scalar corrtol	= `corrtol'
		return scalar corrlag	= `corrlag'
		return scalar skip	= `every'-1
		return scalar mcmcsize  = `mcmcsize'
	}
	return matrix ess_chain`ch' = `essmat'

		} // foreach ch of local chains

		return local  chains	= `"`chains'"'
		return scalar nchains   = `nchains'

		exit

	} // if "`sepchains'" != ""
	
	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels'	///
			    `opchains'  `predictiondata'
	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'

	// check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_min_chain_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}

	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	// set m_LV_names needed in stata_report
	if "`e(eq_names)'" != "" {
		mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
	}
	if "`e(k_eq_base)'" != "" {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
	}
	mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0), 0, ///
		`corrlag', `corrtol', `clevel', J(1,0,0))
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`meanmat'",	"`medianmat'",				///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		0/*no HPD*/,	"`nobaselevels'" != "",			///
		""/*melabel*/, ""/*lpclassmat*/, "`cnsmat'")

	capture confirm matrix `essmat'
	if _rc {
		di as err "cannot obtain efficiency summaries " ///
		     `"for parameters {bf:`thetas'}"'
		exit _rc
	}
	
	// obtain the width of the table
	qui _matrix_table `essmat', formats(%10.2f %11.2f %12.4f) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-27
	local eqpos  = `linesize'-10
	local numpos = `linesize'-9

	local labchains
	if "`chains'" != "" {
		local labchains "Chains: `chains'"
		if `nchains' == 1 {
			local labchains "Chain `chains'"
		}
		local labchains = abbrev("`labchains'", 23)
	}

	di
	if `nchains' > 1 | "`chains'" != "" {
		di as txt "Efficiency summaries"			///
			_col(`labpos') as txt "Number of chains"	///
			_col(`eqpos') "=" as res %10.0fc `nchains'
		
		di as txt "`labchains'"					///
			_col(`labpos') as txt "MCMC sample size"	///
			_col(`eqpos') "="  _col(`numpos') 		///
			as res %10.0fc `mcmcsize'
	}
	else {
		di as txt "Efficiency summaries"		///
		_col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="  _col(`numpos') as res %10.0fc `mcmcsize'
	}
	
	if `vv' >= 16.0 & `numpars' > 1 & `mineff' < `maxeff' { 
		local effpos = `labpos'+13
		di _col(`labpos') as txt "Efficiency:"		///
			_col(`effpos') "min ="	 	 	///
			_col(`numpos') as res %10.4g `mineff'
		di _col(`effpos') as txt "avg ="		///
			_col(`numpos') as res %10.4g `avgeff'
		di as txt `LML'					///
			_col(`effpos') as txt "max ="	 	///
			_col(`numpos') as res %10.4g `maxeff'
	}
		
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di
		_mcmc_expr legend `"`exprlegend'"'
	}

	_mcmc_table ess `numpars' `"`parnames'"' `essmat' `"`diopts'"' `linesize'
	_mcmc_mcsefailnote `mcsefail' `linesize'

	// return results
	matrix colnames `essmat' = "ESS" "Corr time" "Efficiency"
	matrix rownames `essmat' = `parnames'

	_mcmc_expr return `"`exprlegend'"'
	return add
	return local names	= `"`parnames'"'
	return matrix ess       = `essmat'
	return scalar corrtol	= `corrtol'
	return scalar corrlag	= `corrlag'
	return scalar skip	= `every'-1
	return local chains	= `"`chains'"'
	return scalar mcmcsize  = `mcmcsize'
	return scalar nchains   = `nchains'
end

program _bayesstats_summary, rclass
	args mcmcobject thetas opts

	local 0 , `opts'
	syntax [, USING(string) CHAINs(string) SEPCHAINs ///
		PREDictiondata matpvals(string) * ]

	local opchains
	if `"`chains'"' != "" {
		local opchains `"chains(`chains')"' 
	}

	local nchains: word count `e(allchains)'
	if "`chains'" != "" {
		local nchains: word count `chains'
	}

	// check and parse summary options
	_bayesmh_summaryopts `options'
	local batch  "`s(batch)'"
	local clevel "`s(clevel)'"

	local hpd    "`s(hpd)'"
	local every = `s(skip)'+1
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	tempname meanmat medianmat
	tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail essmat 
	tempname mcsemat mcsefail quantmat hpdmat covmat indepvars cnsmat
	local clev = `clevel'/100

	if "`sepchains'" != "" {
	
		di
		di as txt "Posterior summary statistics"
		
		if `batch' > 0 {
			di _col(`labpos') as txt "Batch size"		///
			_col(`eqpos') "="				///
			_col(`numpos') as res %10.0fc `batch'
		}

		if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
			di 
			_mcmc_expr legend `"`exprlegend'"'
		}

		local firstchain 0
		foreach ch of local chains {
		
	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels' 	///
			    chains(`ch') `predictiondata' matpvals(`matpvals')

	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'
	//check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}
	local maxsize = floor(`mcmcsize'/2)
	if (`batch' > `maxsize') {
		di as err "{p}option {bf:batch()} may not exceed half of "
		di as err "MCMC sample size, `maxsize'{p_end}"
		exit 198
		
	}
	// update maximum correlation lag based on current MCMC size
	qui _bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'
		
	// set m_LV_names needed in stata_report
	if "`e(eq_names)'" != "" {
		mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
	}
	if "`e(k_eq_base)'" != "" {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
	}
	mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

	// compute results
	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0),  ///
		`batch', `corrlag', `corrtol', `clev',J(1,0,0))
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`meanmat'",	"`medianmat'",				///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		"`hpd'" != "",	"`nobaselevels'" != "",			///
		""/*melabel*/, ""/*lpclassmat*/, "`cnsmat'")

	capture confirm matrix `mcmcsum'
	if _rc {
		di as err `"cannot summarize parameters {bf:`thetas'}"'
		exit _rc
	}
	
	// display results
	local col1len  = 13
	quietly _matrix_table `mcmcsum', ///
		formats(%9.0g %9.0g %9.0g %9.0g %9.0g %9.0g) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-28
	local eqpos  = `linesize'-11
	local numpos = `linesize'-10

	di
	di as txt "Chain `ch'" _col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="  _col(`numpos') as res %10.0fc `mcmcsize'
		
	_mcmc_table summary , numpars(`numpars')	///
		parnames(`parnames')			///
		clevel(`clev') ctype(``cikind'')	///
		mcmcsum(`mcmcsum') diopts(`diopts')
	_mcmc_batchnote `batch' `linesize'
	if (`batch'==0) {
		_mcmc_mcsefailnote `mcsefail' `linesize'
	}

	// return results
	matrix colnames `mcmcsum' = ///
		"Mean" "Std Dev" "MCSE" "Median" "CrI lower" "CrI upper"
	matrix rownames `mcmcsum' = `parnames'

	if `firstchain' == 0 {
		local firstchain 1
		return clear
		_mcmc_expr return `"`exprlegend'"'
		return add
		return local  names	= `"`parnames'"'
		return scalar corrtol	= `corrtol'
		return scalar corrlag	= `corrlag'
		return scalar skip	= `every'-1
		return scalar batch	= `batch'
		return scalar hpd	= `"`hpd'"' != ""
		return scalar clevel	= `clevel'
		return scalar mcmcsize  = `mcmcsize'
	}
	return matrix summary_chain`ch' = `mcmcsum'

		} // foreach ch of local chains

		return local  chains	= `"`chains'"'
		return scalar nchains   = `nchains'

		exit

	} // if "`sepchains'" != ""

	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')		///
			    thetas(`thetas') using(`"`using'"') ///
	 	 	    every(`every') `nobaselevels'	///
			    `opchains' `predictiondata' matpvals(`matpvals')

	local numpars	 `s(numpars)'
	local parnames   `"`s(parnames)'"'
	local exprlegend `"`s(exprlegend)'"'
	//check that mcmcobject is created
	mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
	if (`nomcmcobj') {
		di as err "{bf:`mcmcobject'} not found"
		exit 3498
	}
	
	// compute the corresponding MCMC sample size
	tempname mcmcsize
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	if `mcmcsize' < 2 {
		di as err "insufficient MCMC sample size"
		exit 2001
	}
	local maxsize = floor(`mcmcsize'/2)
	if (`batch' > `maxsize') {
		di as err "{p}option {bf:batch()} may not exceed half of "
		di as err "MCMC sample size, `maxsize'{p_end}"
		exit 198
	}
	
	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	// set m_LV_names needed in stata_report
	if "`e(eq_names)'" != "" {
		mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
	}
	if "`e(k_eq_base)'" != "" {
		mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
	}
	mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

	// compute results
	mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0),  ///
		`batch', `corrlag', `corrtol', `clev',J(1,0,0))
	mata: `mcmcobject'.stata_report(				///
		"numpars",	"parnames",	""/*noinitmat*/,	///
		"`mcmcsum'",	"`mcmcsize'",	"`meanfail'",		///
		"`meanmat'",	"`medianmat'",				///
		"`quantmat'",	"`hpdmat'",	"`cikind'",		///
		"`mcsemat'",	"`mcsefail'",				///
		"`essmat'",	"`covmat'",	"`acfail'",		///
		"`mineff'",	"`avgeff'",	"`maxeff'", 		///
		"`hpd'" != "",	"`nobaselevels'" != "",			///
		""/*melabel*/, ""/*lpclassmat*/, "`cnsmat'")

	capture confirm matrix `mcmcsum'
	if _rc {
		di as err `"cannot summarize parameters {bf:`thetas'}"'
		exit _rc
	}

	// display results
	local col1len  = 13
	quietly _matrix_table `mcmcsum', ///
		formats(%9.0g %9.0g %9.0g %9.0g %9.0g %9.0g) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-28
	local eqpos  = `linesize'-11
	local numpos = `linesize'-10
	
	local labchains
	if "`chains'" != "" {
		local labchains "Chains: `chains'"
		if `nchains' == 1 {
			local labchains "Chain `chains'"
		}
		local labchains = abbrev("`labchains'", 29)
	}

	di
	if `nchains' > 1 | "`chains'" != "" {
		di as txt "Posterior summary statistics"	///
			_col(`labpos') _col(`labpos') 		///
			as txt "Number of chains"		///
			_col(`eqpos') "=" as res %10.0fc `nchains'

		di as txt "`labchains'"					///
			_col(`labpos') as txt "MCMC sample size"	///
			_col(`eqpos') "=" as res %10.0fc `mcmcsize'
	}
	else {
		di as txt "Posterior summary statistics"	///
		_col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="				///
		as res %10.0fc `mcmcsize'
	}

	if `batch' > 0 {
		di _col(`labpos') as txt "Batch size"		///
		_col(`eqpos') "="				///
		_col(`numpos') as res %10.0fc `batch'
	}
	
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di 
		_mcmc_expr legend `"`exprlegend'"'		
	}
		
	_mcmc_table summary , numpars(`numpars')	///
		parnames(`parnames')			///
		clevel(`clev') ctype(``cikind'')	///
		mcmcsum(`mcmcsum') diopts(`diopts')
	_mcmc_batchnote `batch' `linesize'
	if (`batch'==0) {
		_mcmc_mcsefailnote `mcsefail' `linesize'
	}

	// return results
	matrix colnames `mcmcsum' = ///
		"Mean" "Std Dev" "MCSE" "Median" "CrI lower" "CrI upper"
	matrix rownames `mcmcsum' = `parnames'

	return clear
	_mcmc_expr return `"`exprlegend'"'
	return add

	return local  names	= `"`parnames'"'
	return matrix summary   = `mcmcsum'
	return scalar corrtol	= `corrtol'
	return scalar corrlag	= `corrlag'
	return scalar skip	= `every'-1
	return scalar batch	= `batch'
	return scalar hpd	= `"`hpd'"' != ""
	return scalar clevel	= `clevel'
	return local chains	= `"`chains'"'
	return scalar mcmcsize  = `mcmcsize'
	return scalar nchains   = `nchains'
end

program _bayesstats_grubin, rclass

	args mcmcobject thetas opts

	tempname ltemp Ru Rc

	local 0 , `opts'
	syntax [anything], [RUSTATistic USING(string) Level(string) sort * ]
	if "`level'" != "" & "`rustatistic'" == "" {
		di as err "option {bf:level(`level')} not allowed"
		exit 198
	}
	else {
		syntax [anything], [RUSTATistic USING(string) Level(cilevel) sort * ]
		if (`level' <= 0) {
			di as err "coverage probability should be positive"
			exit 198
		}
		if (`level' < 1) {
			local level = floor(100*`level')
		}
		else {
			if (`level' >= 100) {
				di as err "coverage percentage should be less than 100%"
				exit 198
			}
		}
		local alpha = (100-`level')/100
	}
	// check and parse common options
	_bayesmhpost_options `"`options'"'
	local every = `s(skip)'+1
	local nolegend `s(nolegend)'
	local nobaselevels `s(nobaselevels)'
	local diopts `"`s(diopts)'"'

	mata: `mcmcobject' = _c_mcmc_model()

	cap confirm matrix e(chain_sizes)
	if _rc {
		di as err "invalid estimation results: multiple chains not available"
di as err "{p 4 4 2}Command {helpb bayesstats grubin} requires at least"
di as err "two chains. Use option {bf:nchains()} with {helpb bayesmh}"
di as err "or {helpb bayes_prefix:bayes:} to simulate multiple chains.{p_end}"
		exit 198
	}
	mata: `ltemp' = st_matrix("e(chain_sizes)")
	mata: `mcmcobject'.set_chain_sizes(`ltemp')

	matrix `ltemp' = e(chain_sizes)
	local nchains: colsof `ltemp'
	local N = `ltemp'[1,1]

	local colnames : colfullnames e(chain_means)
	local extrapars : list thetas - colnames

	if `"`extrapars'"' == "" & `every' == 1 {
		// no need to load simulation file
		cap confirm matrix e(chain_means)
		if _rc {
			di as err "invalid estimation results: multiple chains not available"
			exit 198
		}
		mata: `ltemp' = st_matrix("e(chain_means)")
		mata: `mcmcobject'.set_chain_means(`ltemp')

		cap confirm matrix e(chain_sds)
		if _rc {
			di as err "invalid estimation results: multiple chains not available"
			exit 198
		}
		mata: `ltemp' = st_matrix("e(chain_sds)")
		mata: `mcmcobject'.set_chain_sds(`ltemp')
	}
	else {
		// load simulation dataset and create mcmcobject based on it
		_mcmc_read_simdata, mcmcobject(`mcmcobject') ///
			    thetas(`thetas')  every(`every') `nobaselevels' 
		local numpars	 `s(numpars)'
		local thetas     `"`s(parnames)'"'
		local colnames   `"`s(parnames)'"'
		local exprlegend `"`s(exprlegend)'"'

		mata:st_local("N", strofreal(`mcmcobject'.mcmc_size()/`nchains'))

		//check that mcmcobject is created
		mata:st_local("nomcmcobj",strofreal(findexternal("`mcmcobject'")==NULL))
		if (`nomcmcobj') {
			di as err "{bf:`mcmcobject'} not found"
			exit 3498
		}

		// set m_LV_names needed in stata_report
		if "`e(eq_names)'" != "" {
			mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
		}
		if "`e(k_eq_base)'" != "" {
			mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
		}
		mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

		local corrlag 0
		local corrtol 0
		local clev 0
		local batch 0

		tempname meanmat medianmat
		tempname mcmcsum meanfail mineff avgeff maxeff	cikind acfail essmat 
		tempname mcsemat mcsefail quantmat hpdmat covmat indepvars cnsmat
		mata: `mcmcobject'.summarize_matrix(J(0,0,""), J(0,0,0),  ///
			`batch', `corrlag', `corrtol', `clev', J(1,0,0))		
	}

	mata: `mcmcobject'.set_report_params(`"`e(report_params)'"')
	mata: `mcmcobject'.set_report_colnames(`"`e(report_colnames)'"')

	mata: `mcmcobject'.grubin_diagnostic(`"`colnames'"', `"`thetas'"', ///
		`alpha', "`sort'" != "")

	
	local MAX_GR_RC ///
			`""Max Gelman-Rubin Rc = " as res %10.4g `gr_max_rc'"'
			
	mata: st_local("thetas", `mcmcobject'.grubin_params())
	
	return clear

	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_v())
	matrix colnames `ltemp' = `thetas'
	return matrix V = `ltemp'
	
	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_w())
	matrix colnames `ltemp' = `thetas'
	return matrix W = `ltemp'
	
	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_b())
	matrix colnames `ltemp' = `thetas'
	return matrix B = `ltemp'
	
	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_ru_df2())
	matrix colnames `ltemp' = `thetas'
	if "`rustatistic'" != "" {
		return matrix F_df2 = `ltemp'
	}
	else {
		return hidden matrix F_df2 = `ltemp'
	}
	
	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_ru_df1())
	matrix colnames `ltemp' = `thetas'
	if "`rustatistic'" != "" {
		return matrix F_df1 = `ltemp'
	}
	else {
		return hidden matrix F_df1 = `ltemp'
	}
	mata: st_matrix("`ltemp'", `mcmcobject'.grubin_rc_df())
	matrix colnames `ltemp' = `thetas'
	return matrix t_df = `ltemp'
	
	mata: st_matrix("`Ru'", `mcmcobject'.grubin_ru())
	matrix colnames `Ru' = `thetas'
	if "`rustatistic'" != "" {
		return matrix Ru = `Ru'
	}
	else {
		return hidden matrix Ru = `Ru'
	}
	mata: st_matrix("`Rc'", `mcmcobject'.grubin_rc())
	matrix colnames `Rc' = `thetas'
	return matrix Rc = `Rc'

	tempname gr_max_rc
	mata: st_numscalar("`gr_max_rc'", max(`mcmcobject'.grubin_rc()))

	return add
	return scalar Rc_max = `gr_max_rc'
	if "`rustatistic'" != "" {
		return scalar level = `level'/100
	}
	else {
		return hidden scalar level = `level'/100
	}
	return scalar mcmcsize = `N'
	return scalar nchains = `nchains'

	if "`rustatistic'" != "" {
		mat `ltemp' = (return(Rc)', return(Ru)')
		matrix colnames `ltemp' = Rc `""`level'% Ru""'
	}
	else {
		mat `ltemp' = return(Rc)'
		matrix colnames `ltemp' = Rc
	}

	matrix rownames `ltemp' = `thetas'
	di
	di as txt "Gelman-Rubin convergence diagnostic"
	di
	di as txt "Number of chains     = " _col(26) as res %10.0g `nchains'
	di as txt "MCMC size, per chain = " _col(26) as res %10.0fc `N'
	di as txt "Max Gelman-Rubin Rc  = " _col(26) as res %10.7g `gr_max_rc'
	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di
		_mcmc_expr legend `"`exprlegend'"'
	}

	_ms_build_info `ltemp', row

	di
	_matrix_table `ltemp', `diopts'
	//_matrix_table `ltemp', noemptycells
	local tablen  = `s(width)'

	//di as txt "{p 0 6 0 `tablen'}{help j_bayes_grubin_conv:Convergence rules}: Rc < 1.1; Rc < Ru{p_end}"
	di as txt "{p 0 6 0 `tablen'}{help j_bayes_grubin_conv:Convergence rule}: Rc < 1.1{p_end}"
	
end
