*! version 1.3.7  10jul2019

program _mcmc_run, eclass
	version 14.0
	local vv : di "version " string(_caller()) ", missing :"

	syntax ,   MCMCOBJECT(string) 	 	///
		[	 	 		///
		MCMCSize(string)	 	///
		BURNin(string)		 	///
		THINning(string)	 	///
		RSEED(string)	 	 	///
		NCHAINs(integer 1)		///
/* adaptation */	 	 	 	///
		EVERY(string)		 	///
		MINITER(string)		 	///
		MAXITER(string)  	 	///
		ALPHA(string)		 	///
		BETA(string)	 		///
		GAMMA(string)		 	///
		TARATE(string)	 		///
		TOLerance(string)		///
/* advanced */					///	
		SEARCH(string) 			///
		SEARCHREPEAT(string)	 	///
		SCale(real 2.38)	 	///
		COVariance(string)	 	///
/* reporting */				 	///
		CLEVel(string)	 		///
		HPD	 	 	 	///
		DOTS(string) 	 		///
		DOTSEVERY(string) 	 	///
		BATCH(string)	 		///
		CORRLAG(string)		 	///
		CORRTOL(string)		 	///
		NOTABle	 	 		///
		NOHEADer	 	 	///
		NOMODELSUMMary	 		///
		NOEXPRession			///
		BLOCKSUMMary			///
		TITLE(string asis)	 	///
		SAVing(string asis)	 	///
/* eform display option */			///
		eformopts(string)		///
/* undocumented */				///
		EPSilon(real 0)	 		///
		NOECOV	 	 		///
		KEEPINITial	 	 	///
		BROWSE(integer 0)	 	///
		TEMPStart(real 0)	 	///
		TEMPGradient(real 0)	 	///
		RESTart(integer 0)	 	///
		NOREPORT			///
/* to save in ereturn */			///
		EXCLude(string)			///
		* ]

	// save for later: display options
	local dioptions `options'
	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err "mcmc object not found"
		exit _rcmcmcobject
	}

	cap confirm number `mcmcsize'
	if _rc {
		di as err "invalid MCMC size {bf:`mcmcsize'}"
		exit 198
	}
	cap confirm number `burnin'
	if _rc {
		di as err "invalid burn-in {bf:`burnin'}"
		exit 198
	}

	local adaptevery `every' // fot notational reason

	// most options are checked in _bayesmh_check_opts.ado;
	if `browse' < 0 {
		di as err "option {bf:browse()} must contain an integer >= 0"
		local browse 0
	}
	if `tempstart' < -1 {
		di as err "option {bf:tempstart()} must contain a number >= -1"
		exit 198
	}
	if `tempgradient' < 0 {
		di as err "option {bf:tempgradient()} must contain a " ///
			"number >= 0"
		exit 198
	}
	// check covariance()
	tempname stemp 
	if "`covariance'" != "" {
		mata: st_numscalar("`stemp'", `mcmcobject'.num_params())
		if `stemp' < 2 {
			di as err "option {bf:covariance()} may not be " ///
			  "specified for models with fewer than two parameters"
			exit 198
		}
		capture confirm matrix `covariance'
		if _rc == 0 {
			if !issymmetric(`covariance') {
				di as err "matrix {bf:`covariance'} must " ///
				   "be symmetric in option {bf:covariance()}"
				exit 505
			}
			tempname minv
			matrix `minv' = invsym(`covariance')
			if det(`minv') <= 0 {
				di as err "matrix {bf:`covariance'} must " ///
					"be positive definite in option " ///
					"{bf:covariance()}"
				exit 506
			}
			local rn: rowfullnames `covariance'
			local cn: colfullnames `covariance'
			mata: mcov = st_matrix(`"`covariance'"')
			mata: rnames = tokens(st_local("rn"))
			mata: cnames = tokens(st_local("cn"))
			mata: `mcmcobject'.init_upar_tucov(rnames, cnames, mcov)
			mata: mata drop mcov
		}
		else {
			di as err "option {bf:covariance()} must contain matrix"
			exit 198
		}
	}

	if "`noreport'" != "" local nosummary 1
	else                  local nosummary 0

	if `nchains' < 1 {
		di as err "option {bf:nchains()} must contain an integer >= 1"
		local browse 0
	}
	if `nchains' > 32767 {
		di as err "option {bf:nchains()} must contain an integer <= 32767"
		local browse 0
	}

	// parse saving()
	_mcmc_parse_saving `saving'
	local simdatapath `s(simdatapath)'
	local replacenote `s(replacenote)'

	tempname hasevaluators
	mata: st_numscalar("`hasevaluators'", `mcmcobject'.has_evaluators())
	if `hasevaluators' == 0 {
		// set post file
		local postdata `"`simdatapath'"'
	}
	else {
		// save simulation results to _bayesmh_sim.dta initially
		mata: st_local("_bayesmh_sim",  st_tempfilename())
		_mcmc_getfilename postdata : `"`_bayesmh_sim'"'
	}

	global MCMC_postdata `"`postdata'"'
	mata: `mcmcobject'.set_data_filename(`"`postdata'"')

	mata: `mcmcobject'.run(		///
	 	`mcmcsize',		/// 
	 	`burnin',	 	/// 
	 	`thinning',		/// 
	 	`adaptevery',		/// 
	 	`miniter',	 	/// 
		`maxiter',	 	/// 
	 	`alpha',	 	/// 
	 	`beta',	 		/// 
	 	`epsilon',	 	///
	 	`gamma',	 	/// 
	 	`tarate',	 	/// 
	 	`tolerance',		/// 
	 	`scale',	 	///
	 	`browse',	 	///  
	 	`tempstart',	 	/// 
	 	`tempgradient',		///
	 	`searchrepeat',	 	///
	 	`restart',	 	///
	 	`dots',	 		/// 
	 	`dotsevery',		/// 
		`"`keepinitial'"'!="",	///
	 	`"`postdata'"',		///
		`nchains')

	tempname smcmcsize
	mata: st_numscalar("`smcmcsize'", `mcmcobject'.mcmc_size())
	if `smcmcsize' < 1 {
		di "no MCMC sample observations"
		exit 2000
	}

	////////////////////////////////////////////////////////////////////////
	// post e()

	tempname ltemp
	tempvar touse
	qui gen `touse' = 0
	qui summ `touse', meanonly
	local rn = r(N)
	mata: st_store(., "`touse'", `mcmcobject'.touse_union(NULL, `rn'))
	capture ereturn post, esample("`touse'") keepbayesmhtmpfn

	if `"`postdata'"' != `"`simdatapath'"' {
		// copy simulated data to the specified or temporary file 
		capture copy `"`postdata'"' `"`simdatapath'"', replace
		if _rc {
			di as txt "{p}Warning: file copy failed;"
			di as txt `"results are saved in {bf:`postdata'}.{p_end}"'
		}
		else { // erase duplicate simulation results
			erase `"`postdata'"'
			global MCMC_postdata ""
			local postdata `"`simdatapath'"'
		}
	}
	else {
		global MCMC_postdata ""
	}
	ereturn local filename = `"`postdata'"'

	// post search()
	if ("`search'"=="") {
		local search on
	}
	ereturn local search = `"`search'"'

	if `nchains' > 1 {
		forvalues i = 1/`nchains' {
			mata: st_local("`ltemp'", `mcmcobject'.get_rngstate(`i'))
			ereturn local rngstate`i' = `"``ltemp''"'
		}
		mata: st_local("`ltemp'", `mcmcobject'.get_currng())
		ereturn hidden local rng = `"``ltemp''"'
	}
	else {
		mata: st_local("`ltemp'", `mcmcobject'.get_rngstate())
		ereturn local rngstate = `"``ltemp''"'
	}

	// model related
	mata: st_local("modequs", `mcmcobject'.model())
	ereturn hidden local modequs = `"`modequs'"'
	mata: st_local("moddag", `mcmcobject'.build_dag_model())
	ereturn hidden local moddag  = `"`moddag'"'

	mata: st_local("`ltemp'", `mcmcobject'.parequmap())
	ereturn local pareqmap  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.parnames())
	ereturn local parnames  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.predictNames())
	ereturn hidden local predictnames  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.predictVarNames())
	ereturn hidden local predictyvars  = `"``ltemp''"'
	
	mata: st_local("`ltemp'", `mcmcobject'.postvar_names())
	ereturn local postvars  = `"``ltemp''"'

	mata: st_local("`ltemp'", `mcmcobject'.indepvar_names())
	ereturn hidden local indepvars = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.indepvar_labels())
	ereturn hidden local indeplabels = `"``ltemp''"'

	mata: st_local("`ltemp'", `mcmcobject'.matparams())
	ereturn local matparams = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.scparams())
	ereturn local scparams  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.omit_scparams())
	ereturn hidden local omitscparams  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.constrain_scparams())
	ereturn hidden local cnscparams  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.latparams())
	ereturn hidden local latparams = `"``ltemp''"'
	
	mata: st_numscalar("`stemp'", `mcmcobject'.max_data_size())
	ereturn scalar N = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_params())
	ereturn scalar k = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_scparams())
	ereturn scalar k_sc  = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_matparams())
	ereturn scalar k_mat = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.k_latparams())
	ereturn hidden scalar k_lat = `stemp'
	
	mata: st_local("`ltemp'", `mcmcobject'.eq_names())
	ereturn hidden local eq_names = `"``ltemp''"'
	mata: st_numscalar("`stemp'", `mcmcobject'.n_eq())
	ereturn hidden scalar k_eq = `stemp'
	mata: st_local("`ltemp'", `mcmcobject'.eq_baselab())
	ereturn hidden local baselab = `"``ltemp''"'
	mata: st_numscalar("`stemp'", `mcmcobject'.n_eq_base())
	ereturn hidden scalar k_eq_base = `stemp'

	mata: st_numscalar("`stemp'", `mcmcobject'.start_loglik())
	ereturn hidden scalar ll_start = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.start_prior())
	ereturn hidden scalar lprior_start = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.start_posterior())
	ereturn hidden scalar lposterior_start = `stemp'

	mata: st_numscalar("`stemp'", `mcmcobject'.last_loglik())
	ereturn hidden scalar ll_last = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.last_prior())
	ereturn hidden scalar lprior_last = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.last_posterior())
	ereturn hidden scalar lposterior_last = `stemp'
	
	mata: `mcmcobject'.equations_ereport() 

	_bayesmh_eqlablist export

	// refresh nchains, may be different from the requested
	mata: st_local("nchains", strofreal(`mcmcobject'.mcmc_chains()))
	ereturn scalar nchains  = `nchains'
	if `nchains' >= 1 {
		local allchains
		forvalues i = 1/`nchains' {
			local allchains `allchains' `i'
		}
		ereturn hidden local allchains  = `"`allchains'"'
	}
	
	// simulation related 
	mata: st_numscalar("`stemp'", `mcmcobject'.mcmc_size())
	ereturn scalar mcmcsize = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.burnin_iter())
	ereturn scalar burnin   = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.total_iter())
	ereturn scalar mcmciter = `stemp'

	ereturn scalar thinning = `thinning'

	ereturn scalar scale	 = `scale'
	ereturn hidden local covariance = `"`covariance'"'

	ereturn scalar adapt_every	= `adaptevery'
	ereturn scalar adapt_miniter	= `miniter'
	ereturn scalar adapt_maxiter	= `maxiter'
	ereturn scalar adapt_alpha	= `alpha'
	ereturn scalar adapt_beta	= `beta'
	ereturn scalar adapt_gamma	= `gamma'
	if (`tarate'!=0) {
		ereturn hidden scalar adapt_tarate     = `tarate'
	}
	ereturn scalar adapt_tolerance      = `tolerance'
	ereturn hidden scalar adapt_epsilon = `epsilon'

	ereturn local exclude = `"`exclude'"'

	mata: st_numscalar("`stemp'", `mcmcobject'.arate())
	ereturn scalar arate  = `stemp'
	mata: st_matrix("`stemp'", `mcmcobject'.chain_arate())
	ereturn hidden matrix chain_arate  = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.runtime())
	ereturn hidden scalar simtime = `stemp'
	mata: st_numscalar("`stemp'", `mcmcobject'.search_iter())
	ereturn scalar repeat  = `stemp'

	// save LV info
	mata: `mcmcobject'.write_LV_names_ereport()

	// block update parameters 
	mata: `mcmcobject'.blocks_ereport() 

	mata: st_local("`ltemp'", `mcmcobject'.m_method)
	ereturn local method   = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.m_cmdline)
	ereturn local cmdline  = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.m_command)
	ereturn local cmd      = `"``ltemp''"'

	mata: `mcmcobject'.save_predict_factors()

	if !`nosummary' {
		`vv' _mcmc_report, mcmcobject(`mcmcobject') 	///
			postdata(`"`postdata'"') 		///
	 	 	clevel(`clevel') 			///
			`hpd' batch(`batch')			///
	 	 	corrlag(`corrlag') corrtol(`corrtol')	///
	 	 	modequs(`"`modequs'"')			///
			moddag(`"`moddag'"')			///
	 	 	`notable' `noheader' `noeqtable'	///
			`nomodelsummary'	 		///
			`noexpression'				///
			`blocksummary'				///
	 	 	`dioptions' `noecov' 			///
			eformopts(`eformopts')			///
			title(`title') 
	}

	// display notes about saved files
	if (`"`saving'"'!="") {
		di
		_bayesmh_saving_notes `replacenote' `"`simdatapath'"'
	}
	
	// clear simulation parameters 
	mata: `mcmcobject'.clear_sample()
end
