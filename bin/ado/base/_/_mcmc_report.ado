*! version 1.7.1  05nov2019

program _mcmc_report, eclass
	version 14.0
	local vv = _caller()

	syntax ,  MCMCOBJECT(string) [				///
		CLEVel(string)					///
		Level(passthru) 				///
		HPD						///
		BATCH(string)					///
		CORRLAG(string)					///
		CORRTOL(string)					///
		NOTABle NOHEADer NOMODELSUMMary	NOMESUMMary	///
		NOEXPRession					///
		BLOCKSUMMary					///
		SAVing(string asis)				///
		saveandexit					///
		NOSHOW(string) SHOW(string)			///
		INITSUMMary					///
		TITLE(string asis)			 	///
		POSTdata(string)			/// internal
		MODEQUS(string) MODDAG(string)		/// internal
		NOECOV					/// internal
		NOTWOCOLHEADER				/// internal
		eformopts(string) 			/// eform display option
		headerstr1(string)			///
		headerstr2(string)			///
		headerstr3(string)			///
		subjects(string)			///
		censor(string)				///
		footnotes(string)			///
		NOGRoup					///
		melabel					///
		SHOWREffects 				///
		SHOWREffects1(passthru)			///
		remargl					///
		nchains(string)				///
		chainsdetail				///
	 	  * ]

	if "`noshow'" != "" & "`show'" != "" {
		di as err "options {bf:noshow(`noshow')} and {bf:show(`show')} " ///
			"cannot be combined"
		exit 198
	}

	if "`showreffects'" != "" & "`showreffects1'" != "" {
		di as err "options {bf:`showreffects'} and {bf:`showreffects1'} " ///
			"cannot be combined"
		exit 198
	}

	if `"`nchains'"' != "" {
		gettoken nchains opts : nchains, parse(",")
		local opts `opts'
		if "`opts'" == "detail" {
			local chainsdetail chainsdetail
		}
	}

	// check summary options common to bayesstats summary
	local summopts batch(`batch') clevel(`clevel') `level' `hpd' 
	local summopts `summopts' corrlag(`corrlag') corrtol(`corrtol')
	local summopts `summopts' mcmcsize(`mcmcsize')
	_bayesmh_summaryopts `summopts'
	local batch  "`s(batch)'"
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	local corrlag `s(corrlag)'
	local corrtol `s(corrtol)'

	if `"`saving'"' != "" {
		_savingopt_parse fname replace : saving ".dta" `"`saving'"'
		local postfile `"`e(filename)'"'
		cap confirm file `"`postfile'"'
		if _rc {
			di as err "current simulation results do not exist" 
			exit _rc
		}
		local replacenote 0
		if ("`replace'"=="") {
			confirm new file `"`fname'"'
		}
		else {
			cap confirm new file `"`fname'"'
			if _rc==0 {
				local replacenote 1
			}
		}
		if `"`postfile'"' != `"`fname'"' {
			qui copy `"`postfile'"' `"`fname'"', `replace'
			di as txt "note: " _c
			_bayesmh_saving_notes `replacenote' `"`fname'"'
			mata: st_global("e(filename)",`"`fname'"')
		}
		if `"`saveandexit'"' != "" {
			exit
		}
	}

	_get_diopts diopts, `options'

	local 0 ,`diopts'
	syntax [anything], [BASElevels ALLBASElevels *]
	local nobaselevels = "`baselevels'" == "" & "`allbaselevels'" == ""
	if `vv' >= 15.0 {
		// include omitted parameters
		local nobaselevels 0
	}

	local clevel = `clevel'/100

	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err "mcmc object not found"
		exit _rc
	}

	tempname ltemp lburnin lacr	///
		numpars mcmcsize llml	///
		lmre ltotaliter initmat	///
		citype acfail thetas	///
		meanmat medianmat 	///
		essmat mcsemat hpdmat 	///
		quantmat covmat 	///
		mcmcsum mcmcmat 	///
		meanfail mappars 	///
		mineff avgeff maxeff	///
		mindsize avgdsize maxdsize ///
		indepvars mcsefail matinit ///
		pclassmat ty pcnsmat	///
		lchains gr_max_rc predict_vars

	local importall importall
	if "`remargl'" == "" {
		local importall
	}

	local chain_var 0
	if `vv' >= 16.0 {
		local chain_var 1
	}

	if `"`postdata'"' != "" {
		preserve

		mata: st_local("`ltotaliter'",	///
			strofreal(`mcmcobject'.total_iter()))
		mata: st_local("`lburnin'",	///
			strofreal(`mcmcobject'.burnin_iter()))
		mata: st_local("`lacr'",	///
			strofreal(`mcmcobject'.arate()))
		mata: st_matrix("`lacr'", `mcmcobject'.chain_arate())

		_mcmc_show_params, mcmcobject(`mcmcobject')	///
			noshow(`noshow') show(`show')		///
			`showreffects' `showreffects1'
		if `"`e(noshowex)'"' != "" {
			mata: `mcmcobject'.show_params(`"`e(noshowex)'"', 0)
		}

		if "`importall'" != "" {
			mata: st_local("`ltemp'",	///
				invtokens(`mcmcobject'.form_simdata_colnames()))
			use `"`postdata'"', clear
		}
		else {
			mata: st_local("`ltemp'",	///
			invtokens(`mcmcobject'.form_simdata_import_colnames(`chain_var')))
			use ``ltemp'' using `"`postdata'"', clear
		}

		quietly ds
		if "``ltemp''" != "`r(varlist)'" {
			di as err `"incompatible data file `postdata'"'
			exit 198
		}

		mata: `mcmcobject'.import_simdata(`"``ltemp''"')

		scalar `llml' = .

		restore
	}
	else {
		if `"`e(filename)'"' != "" local postdata `"`e(filename)'"'
		
		if `"`postdata'"' == "" {
			error 301
		}

		mata: `mcmcobject'.m_parNames	  = tokens(`"`e(parnames)'"')
		mata: `mcmcobject'.m_parEquMap	  = tokens(`"`e(pareqmap)'"')
		mata: `mcmcobject'.m_postVarNames = tokens(`"`e(postvars)'"')
		mata: `mcmcobject'.m_parInit	  = st_matrix("e(init)")
	
		if `"`e(exclude)'"' != "" {
			mata: `mcmcobject'.m_paramExcluded = 1
		}

		mata: `mcmcobject'.set_par_names(	///
			tokens(`"`e(scparams)'"'  ),	///
			tokens(`"`e(discparams)'"'),	///
			tokens(`"`e(matparams)'"' ),	///
			tokens(`"`e(latparams)'"' ),	///
			tokens(`"`e(predictnames)'"'),	///
			tokens(`"`e(predictyvars)'"'),	///
			tokens(`"`e(predsumnames)'"'))

		// call set_omit_scparams after set_par_names
		mata: `mcmcobject'.set_omit_scparams(`"`e(omitscparams)'"')

		// call set_constrain_scparams after set_par_names
		mata: `mcmcobject'.set_constrain_scparams(`"`e(cnscparams)'"')

		if "`e(nchains)'" != "" {
			mata: `mcmcobject'.m_simfile_chainvar = 1
			mata: `mcmcobject'.set_mcmc_chains(`e(nchains)')
			mata: `mcmcobject'.update_chain_init()
		}
		else {
			local chain_var 0
			mata: `mcmcobject'.m_simfile_chainvar = 0
		}

		// needed for BIC
		mata: `mcmcobject'.set_data_size("e(_N)")
		if "`e(dic)'" != "" {
			mata: `mcmcobject'.set_dic(`e(dic)')
		}
		cap confirm matrix e(dic_chains)
		if !_rc {
			mata: `ltemp' = st_matrix("e(dic_chains)")
			mata: `mcmcobject'.set_chain_dic(`ltemp')
		}
		if "`e(llatmean)'" != "" {
			mata: `mcmcobject'.set_llatmean(`e(llatmean)')
		}
		cap confirm matrix e(llatmean_chains)
		if !_rc {
			mata: `ltemp' = st_matrix("e(llatmean_chains)")
			mata: `mcmcobject'.set_chain_llatmean(`ltemp')
		}
		cap confirm matrix e(lml_lm_chains)
		if !_rc {
			mata: `ltemp' = st_matrix("e(lml_lm_chains)")
			mata: `mcmcobject'.set_chain_laplace_loglik(`ltemp')
		}
		cap confirm matrix e(margRE_lm_chains)
		if !_rc {
			mata: `ltemp' = st_matrix("e(margRE_lm_chains)")
			mata: `mcmcobject'.set_chain_margRE_loglik(`ltemp')
		}
		cap confirm matrix e(eff_chains)
		if !_rc {
			mata: `ltemp' = st_matrix("e(eff_chains)")
			mata: `mcmcobject'.set_chain_eff(`ltemp')
		}

		if "`e(eq_names)'" != "" {
			mata: `mcmcobject'.set_eq_names(`"`e(eq_names)'"')
		}
		if "`e(k_eq_base)'" != "" {
			mata: `mcmcobject'.set_eq_base(`e(k_eq_base)', `"`e(baselab)'"')
		}

		mata: `mcmcobject'.set_LV_names(`"`e(lv_names)'"', `"`e(lv_pathnames)'"', `"`e(lv_prefix)'"', `"`e(lv_varlist)'"')

		_mcmc_show_params, mcmcobject(`mcmcobject')	///
			noshow(`noshow') show(`show')		///
			`showreffects' `showreffects1'
		if `"`e(noshowex)'"' != "" {
			mata: `mcmcobject'.show_params(`"`e(noshowex)'"', 0)
		}
	
		mata: st_local("`ltemp'",	///
			invtokens(`mcmcobject'.form_simdata_colnames()))
		if `"`postdata'"' != "" {
			preserve
			if "`importall'" != "" {
				use `"`postdata'"', clear
			}
			else {
				mata: st_local("`ltemp'",	///
				invtokens(`mcmcobject'.form_simdata_import_colnames(`chain_var')))
				use ``ltemp'' using `"`postdata'"', clear
			}
			if _rc {
	 	 		di as err `"cannot open `postdata'"'
	 	 		exit _rc
			}
		}

		// check whether varnames and e(parnames) are the same 
		quietly ds
		if `"``ltemp''"' != `"`r(varlist)'"' {
			di as err `"incompatible data file `postdata'"'
			exit 198
		}

		mata: `mcmcobject'.import_simdata(`"``ltemp''"')

		if `"`postdata'"' != "" restore

		scalar `llml' = `e(lml_lm)'
		scalar `lmre' = `e(margRE_lm)'

		if (`llml' != .) {
			mata: `mcmcobject'.set_laplace_loglik(st_numscalar("`llml'"))
		}
		if (`lmre' != .) {
			mata: `mcmcobject'.set_margRE_loglik(st_numscalar("`lmre'"))
		}

		local `lacr' `e(arate)'
		matrix `lacr' = e(chain_arate)
		
		mata: `mcmcobject'.m_method = `"`e(method)'"'
		mata: `mcmcobject'.m_title  = `"`e(title)'"'
		
		if `"`headerstr1'"' == "" {
			local headerstr1 = `"`e(headerstr1)'"'
		}
		if `"`headerstr2'"' == "" {
			local headerstr2 = `"`e(headerstr2)'"'
		}
		if `"`headerstr3'"' == "" {
			local headerstr3 = `"`e(headerstr3)'"'
		}
		if `"`subjects'"' == "" {
			local subjects = `"`e(subjects)'"'
		}
		if `"`censor'"' == "" {
			local censor = `"`e(censor)'"'
		}
	}

	// load model equations from e 
	local modequs `"`e(modequs)'"'
	local moddag  `"`e(moddag)'"'

	local `lchains' 1
	if "`e(nchains)'" != "" {
		local `lchains' `e(nchains)'
	}
	local `ltotaliter' `e(mcmciter)'
	local `lburnin'	   `e(burnin)'
	if ``lchains'' < 2 {
		local chainsdetail
	}
	if ``lchains'' >= 2 {
		local `ltotaliter' = ``ltotaliter'' / ``lchains''
	}

	if `"`title'"' != "" {
		mata: `mcmcobject'.m_title  = `"`title'"'
	}

	local eformstr
	if "`eformopts'" != "" {
		capture _get_eformopts , eformopts(`eformopts') allowed(__all__)
		if _rc == 0 {
			local eformstr `s(str)'
			local eformstr = abbrev(`"`eformstr'"', 10)
			if "`eformstr'" == "" & `"`s(eform)'"' != "" {
				local eformstr = upper("`s(opt)'")
			}
			local eformopts `"`s(eform)'"'
			if "`e(cmdname)'" == "binreg" {
				if "`s(opt)'" == "hr" {
					local eformstr "Hlth Ratio"
					local eformopts "eform(Hlth Ratio)"
				}
				if "`s(opt)'" == "rrr" | "`s(opt)'" == "rr" {
					local eformstr "Risk Ratio"
					local eformopts "eform(Risk Ratio)"
				}
			}
		}
		else {
			local eformstr = "exp(b)"
			if "`eformopts'" == "rd" {
				local eformstr "Risk Diff."
			}
		}
		local 0 ,`eformopts'
		capture syntax [, EForm1(string) EForm *]
		if _rc == 0 {
		if "`eform1'" != "" || "`eform'" != "" {
			mata: `mcmcobject'.transform_simdata("eform")
		}
		
		}

		_bayes_eform_footnotes `eformopts'
		local footnotes `s(footnotes)'`footnotes' 
	}

	// some MCMC sample size dependencies
	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_min_chain_size())
	if `mcmcsize' < 1 {
		di as err "no MCMC sample observations"
		exit 2000
	}
	// update maximum correlation lag based on current MCMC size
	_bayesmh_chk_corrlag corrlag : `corrlag' `mcmcsize'

	mata: st_numscalar("`mcmcsize'", `mcmcobject'.mcmc_size())
	// update batch size based on current MCMC size
	if `batch' > `mcmcsize'/2 {
		local batch = floor(`mcmcsize'/2)
		di as txt "note: option {cmd:batch()} changed to {cmd:`batch'}"
	}

	local extraopts
	if `"`melabel'"' != "" {
		local melabel `e(cmd)'
		local extraopts cmdextras
	}

	local margl = "`remargl'" != ""
	mata: `mcmcobject'.summarize(`batch', `corrlag', `corrtol', `clevel', `margl')
	mata: `mcmcobject'.stata_report(	///
		"`numpars'",  "`thetas'",	///
		"`initmat'",  "`mcmcsum'",	///
		"`mcmcsize'", "`meanfail'",	///
		"`meanmat'",  "`medianmat'",   	///
		"`quantmat'", "`hpdmat'",   	///
		"`citype'",   "`mcsemat'",	///
		"`mcsefail'", "`essmat'",	///
		"`covmat'",   "`acfail'",	///
		"`mineff'",   "`avgeff'",	///
		"`maxeff'",   "`hpd'" != "",	///
		`nobaselevels', "`melabel'", "`pclassmat'", "`pcnsmat'")

	capture confirm matrix `mcmcsum'
	if _rc {
		local notable notable
	}

	capture confirm matrix `pclassmat'
	if !_rc {
		// needed by _matrix_table for the -cmdextras- option
		ereturn hidden matrix b_pclass = `pclassmat'
	}

	if ``lchains'' > 1 {
		local alpha = 1-`clevel'
		mata: `mcmcobject'.grubin_diagnostic(`"``thetas''"', ///
			`"``thetas''"', `alpha', 0)
		mata: st_numscalar("`gr_max_rc'", max(`mcmcobject'.grubin_rc()))
		local MAX_GR_RC ///
			`""Max Gelman-Rubin Rc = " as res %10.4g `gr_max_rc'"'
	}

	mata:`mcmcobject'.data_size( ///
			"`mindsize'", "`avgdsize'", "`maxdsize'", "_N")

	// begin output 
	local col1len  = 13
	local linesize = 78
	if "`notable'" == "" {
		_ms_build_info `mcmcsum', row
		quietly _matrix_table `mcmcsum',			///
			formats(%9.0g %9.0g %8.0g %9.0g %9.0g %9.0g)	///
			notitles `diopts'
		local linesize = `s(width)'
		local col1len  = `s(width_col1)'
	}

	local labpos = `linesize'-28
	local effpos = `linesize'-15
	local eqpos  = `linesize'-11
	local numpos = `linesize'-9	
	if `"`censor'"' != "" {
		local labpos = `linesize'-29
	}
	if `mindsize' < `maxdsize' {
		local labpos = `linesize'-30
	}


	if ``lchains'' > 1 {
		local labpos = `labpos' - 3
		local eff_label {help j_bayesmh_nchains_avg:Avg} efficiency
		local arate_label {help j_bayesmh_nchains_avg:Avg} acceptance rate
	}
	else {
		local eff_label Efficiency
		local arate_label Acceptance rate
	}

if "`noheader'" == "" {

		if "`nomodelsummary'" == "" {
			_mcmc_model , mcmcobject(`mcmcobject')     ///
			lmodel(`"`modequs'"') linesize(`linesize') ///
			`noexpression' 
		}
		if "`blocksummary'" != "" {
			_mcmc_blocksummary, linesize(`linesize')
		}

		if "`initsummary'" != "" {
			mata: `mcmcobject'.initsummary_ereport()
		}
	
	if ("`notwocolheader'"=="") { // leave style as is

		// extra separation line 
		di
	
	if ``lchains'' > 1 {
	
		mata: st_local("`ltemp'", `mcmcobject'.m_title)
		di as txt `"``ltemp''"'				 ///
			_col(`labpos') as txt "Number of chains" ///
			_col(`eqpos') "="	 	 	 ///
			_col(`numpos') as res %10.0fc ``lchains''
		mata: st_local("`ltemp'", `mcmcobject'.m_method)
		di as txt `"``ltemp''"'				 ///
			_col(`labpos') as txt "Per MCMC chain:"

		local perchainsize = `mcmcsize'/``lchains''
		local labpos1 = `labpos' + 4
		di as txt _col(`labpos1') as txt "Iterations"	///
			_col(`eqpos') "="	 	 	///
			_col(`numpos') as res %10.0fc ``ltotaliter''
		di as txt _col(`labpos1') as txt "Burn-in"	///
			_col(`eqpos') "="			///
			_col(`numpos') as res %10.0fc ``lburnin''
		di as txt _col(`labpos1') as txt "Sample size" 	///
			_col(`eqpos') "="	 	 	///
			_col(`numpos') as res  %10.0fc `perchainsize'
	}
	else {
		mata: st_local("`ltemp'", `mcmcobject'.m_title)
		di as txt `"``ltemp''"'				///
			_col(`labpos') as txt "MCMC iterations"	///
			_col(`eqpos') "="	 	 	 ///
			_col(`numpos') as res %10.0fc ``ltotaliter''
		mata: st_local("`ltemp'", `mcmcobject'.m_method)
		di as txt `"``ltemp''"'	 	 		///
			_col(`labpos') as txt "Burn-in"		///
			_col(`eqpos') "="			///
			_col(`numpos') as res %10.0fc ``lburnin''
		di _col(`labpos') as txt "MCMC sample size" ///
			_col(`eqpos') "="	 	 	 ///
			_col(`numpos') as res  %10.0fc `mcmcsize'
	}
	
		local n_subj
		local n_fail
		local n_risk
		if `"`subjects'"' != "" {
			local subjs `subjects'
			gettoken n_subj subjs : subjs
			if "`n_subj'" == "0" || "`n_subj'" == "." {
				local n_subj
			}
			else {
				local len = 11-bstrlen("`n_subj'")
	local n_subj = `""No. of subjects =" _skip(`len') as res "`n_subj'""'
			}
			gettoken n_fail subjs : subjs
			if "`n_fail'" == "0" || "`n_fail'" == "." {
				local n_fail
			}
			else {
				local len = 11-bstrlen("`n_fail'")
	local n_fail = `""No. of failures =" _skip(`len') as res "`n_fail'""'
			}
			gettoken n_risk subjs : subjs
			if "`n_risk'" == "0" || "`n_risk'" == "." {
				local n_risk
			}
			else {
				local len = 11-bstrlen("`n_risk'")
	local n_risk = `""No. at risk" _skip(5) "=" _skip(`len') as res "`n_risk'""'
			}
		}

		// me group information
		if `"`e(ivars)'"' != "" & "`nogroup'" == "" {
			_me_group_table, numoffset(`labpos')
		}

		if `numpars' > 1 & `mindsize' < `maxdsize' { 
			di as txt `n_subj'`headerstr1'	 	 	///
				_col(`labpos') as txt "Number of obs:"	///
				_col(`effpos') "min ="	 	 	///
				_col(`numpos') as res %10.0fc `mindsize'
			di `n_fail' _col(`effpos') as txt "avg ="	///
				_col(`numpos') as res %10.0fc `avgdsize'
			di `n_risk'_col(`effpos') as txt "max ="	///
				_col(`numpos') as res %10.0fc `maxdsize'
		}
		else {
			di as txt `n_subj'`headerstr1'		 	 ///
				_col(`labpos') as txt "Number of obs"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res  %10.0fc `mindsize'
			if `"`n_fail'"' != "" {
				di as txt `n_fail'
			}
			if `"`n_risk'"' != "" {
				di as txt `n_risk'
			}
		}

		local headerstr2temp `"`headerstr2'"'
		if "`e(cmdname)'" == "glm" {
			local scale = e(glm_scale)
			if "`scale'" != "" & "`scale'" != "." {
				di as txt `headerstr2temp' ///
				_col(`labpos') as txt "Scale parameter"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res  %10.8g `scale'
				local headerstr2temp
			}
		}

		if (inlist("`e(likelihood)'","intreg","tobit")) {
			_censobs_header 67
		}
		
		if `"`censor'"' != "" { 
			local scensor `censor'
			gettoken tok scensor : scensor
			if "`tok'" == "" || "`tok'" == "." {
				local tok 0
			}
			local cpos = `eqpos'-bstrlen("Nonselected")-1
			di as txt `headerstr2temp'	 	 	///
				_col(`cpos') as txt "Selected"		///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.0gc `tok'
			gettoken tok scensor : scensor
			if "`tok'" != "" & "`tok'" != "." {
				di ///
				_col(`cpos') as txt "Nonselected"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.0gc `tok'
			}
			di _col(`labpos') as txt "`arate_label'"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g ``lacr''
		}
		else {
			di as txt `headerstr2temp'	 	 	///
				_col(`labpos') as txt "`arate_label'"   ///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g ``lacr''
		}

		if (`llml'== .) {
			mata: st_numscalar("`llml'", ///
				`mcmcobject'.laplace_loglik())
			mata: st_numscalar("`lmre'", ///
				`mcmcobject'.margRE_loglik())
		}
		if (`llml'==.) {
			local lmltitle Log marginal-likelihood
			if ``lchains'' > 1 {
				local lmltitle Avg log marginal-likelihood
			}
			mata: st_numscalar("`ltemp'", `mcmcobject'.k_latparams())
			if `ltemp' > 0 {
				local LML ///
			`""{help j_bayes_remargl:Log marginal-likelihood}""'
			}
			else {
				local LML ///
`""{help j_bayesmh_marglmiss:`lmltitle'} = " as res %10.0g `llml'"'
			}
		}
		else {
			if ``lchains'' > 1 {
				local LML ///
`""{help j_bayesmh_nchains_avg:Avg} log marginal-likelihood = " as res %10.0g `llml'"'
			}
			else {
				local LML ///
			`""Log marginal-likelihood = " as res %10.0g `llml'"'
			}
		}
		
		if (`numpars' > 1 & `mineff' < `maxeff') | `"`headerstr3'"' != "" { 
			di as txt `headerstr3'	 	 		///
				_col(`labpos') as txt "`eff_label':"	///
				_col(`effpos') "min ="	 	 	///
				_col(`numpos') as res %10.4g `mineff'
			di _col(`effpos') as txt "avg ="		///
				_col(`numpos') as res %10.4g `avgeff'
			if ``lchains'' > 1 {
				di as txt _col(`effpos') "max ="	 ///
				_col(`numpos') as res %10.4g `maxeff'
				di as txt `LML'	_col(`labpos')		///
		as txt "{help j_bayes_grubin_rc:Max Gelman-Rubin Rc}"	///
				_col(`eqpos') "=" _col(`numpos')	///
				as res %10.4g `gr_max_rc'
			}
			else {
				di as txt `LML'				///
				_col(`effpos') as txt "max ="		///
				_col(`numpos') as res %10.4g `maxeff'
			}
		}
		else {
			if ``lchains'' > 1 {
				di _col(`labpos') as txt "`eff_label'"	///
				_col(`eqpos') "=" _col(`numpos')   	///
				as res %10.4g `avgeff'
				
				di as txt `LML'	_col(`labpos')		///
		as txt "{help j_bayes_grubin_rc:Max Gelman-Rubin Rc}"	///
				_col(`eqpos') "=" _col(`numpos') 	///
				as res %10.4g `gr_max_rc'
			}
			else {
				di as txt `LML'				///
				_col(`labpos') as txt "`eff_label'"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g `avgeff'
			}
		}
	}

	if ``lchains'' > 1 & "`chainsdetail'" != "" {

		mata: st_matrix("`ltemp'", `mcmcobject'.chain_laplace_loglik())
		forval chain = 1/``lchains'' {
			
			di 
			
			scalar `llml' = `ltemp'[1,`chain']
			local LML ///
			`""Log marginal-likelihood = " as res %10.0g `llml'"'

			di as txt "Chain `chain'"	 	 	///
				_col(`labpos') as txt "Acceptance rate"   ///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g `=`lacr'[1,`chain']'
			cap confirm scalar `mineff'_`chain'
			if _rc != 0 {
				continue
			}
			if `numpars' > 1 & `mineff' < `maxeff' { 
				di as txt _col(`labpos') as txt "Efficiency:" ///
					_col(`effpos') "min ="	 	 ///
					_col(`numpos') as res %10.4g `mineff'_`chain'
				di _col(`effpos') as txt "avg ="	///
					_col(`numpos') as res %10.4g `avgeff'_`chain'
				di as txt `LML'				///
					_col(`effpos') as txt "max ="	///
					_col(`numpos') as res %10.4g `maxeff'_`chain'
			}
			else {
				di as txt `LML'				///
				_col(`labpos') as txt "Efficiency"	///
				_col(`eqpos') "="	 	 	///
				_col(`numpos') as res %10.4g `avgeff'_`chain'
			}
		}
	}
	
} //end notwocolheader

	global MCMC_matsizemin = `numpars'

	tempname tmcmcsum
	capture confirm matrix `mcmcsum'
	if _rc == 0 {
		matrix `tmcmcsum' = `mcmcsum'
		// _mcmc_table_summary changes the rownames of tmcmcsum
	}
	local shownotes 1
	if "`notable'" == "" {
	// thetas' in compound quotes for may contain multi-word names in quotes 
		_mcmc_table summary , numpars(`numpars')	///
			parnames(``thetas'')			///
			clevel(`clevel') ctype(``citype'')	///
			mcmcsum(`tmcmcsum') diopts(`diopts')	///
			eform(`eformstr') `extraopts'
	}
	else {
		local shownotes 0
	}
	if "`noheader'" != "" {
		local shownotes 0
	}

	if `"`e(offset1)'"' != "" & `shownotes' {
		di as txt `"Note: Variable {bf:`e(offset1)'} is included "' ///
"in the first equation as {help estimation_options##options:offset}."
	}
	if `"`e(offset2)'"' != "" & `shownotes' {
		di as txt `"Note: Variable {bf:`e(offset2)'} is included "' ///
"in the second equation as {help estimation_options##options:offset}."
	}
	if `"`e(offset1)'`e(offset2)'"' == "" & `"`e(offset)'"' != "" & `shownotes' {
		di as txt `"Note: Variable {bf:`e(offset)'} is included "' ///
		"in the model as the {help estimation_options##options:offset}."
	}
	
	if `"`e(exposure)'"' != "" & `shownotes' {
		di as txt `"Note: Variable {bf:`e(exposure)'} is included "' ///
		"in the model as the {help estimation_options##options:exposure}."
	}

	if `"`footnotes'"' != "" & `shownotes' {
		di as txt `"`footnotes'"'
	}

	mata: st_numscalar("`ltemp'", `mcmcobject'.defaultInitialUsed())
	if ``lchains'' > 1 & `ltemp' == 1 {
		di as txt ///
	"{p 0 6 0 `linesize'}Note: {help j_bayes_nchainsinit:Default initial values} " ///
		"are used for multiple chains.{p_end}"
	}

	if "`notable'" == "" {
		_mcmc_batchnote `batch' `linesize'
		if (`batch'==0) {
			_mcmc_mcsefailnote `mcsefail' `linesize'
		}
		if `"`eformopts'"' != "" & `"`eformstr'"' == "" {
			mata: `mcmcobject'.eform_params("lname_eformp")
			mata: `mcmcobject'.eform_transform("lname_eformt")
			di as txt "{p 0 6 0 `linesize'}Note: Parameters " ///
	"{bf:{c -(}`lname_eformp':{c )-}} are in `lname_eformt' form.{p_end}"
		}
	}

	mata: st_numscalar("`ltemp'", `mcmcobject'.adapt_aftburnin())
	if `ltemp' == 1 {
		if `shownotes' {
		local NOTE {help j_bayesmh_adaptsim:Note:}
		di as txt "{p 0 6 0 `linesize'}`NOTE' Adaptation " ///
			"continues during simulation.{p_end}"
		}
		ereturn hidden scalar adapt_duringsim = 0
	}

	local chainprefix
	if ``lchains'' > 1 {
		local chainprefix = `" in at least one of the chains"'
	}
			
	if "``acfail''" != "" & `corrlag' > 0 {
		if `shownotes' {

		di as txt "{p 0 6 0 `linesize'}Note: There is a " ///
			"{help j_bayesmh_highcorr:high autocorrelation} " ///
			"after `corrlag' "	///
			`"`=plural(`corrlag',"lag")'`chainprefix'.{p_end}"'
		}
		ereturn hidden scalar is_highcorr = 1
	}
	else {
		ereturn hidden scalar is_highcorr = 0
	}

	mata: st_numscalar("`ltemp'", `mcmcobject'.is_adapttol_notmet())
	local NOTE Note: {help j_bayesmh_adapttol:Adaptation tolerance}
	if `ltemp' == 2 {
		if `shownotes' {
		di as txt "{p 0 6 0 `linesize'}`NOTE' " ///
			"is not met in at least one of the blocks`chainprefix'.{p_end}"
		}
		ereturn hidden scalar is_aratemet = 0
	}
	else if `ltemp' == 1 {
		if `shownotes' {
		di as txt "{p 0 6 0 `linesize'}`NOTE' " ///
			"is not met`chainprefix'.{p_end}"
		}
		ereturn hidden scalar is_aratemet = 0
	}
	else {
		ereturn hidden scalar is_aratemet = 1
	}

	if "`notable'" == "" {	
		mata: st_numscalar("`ltemp'", `mcmcobject'.re_onlyshown())
		if `ltemp' >= 0 {
			local `ltemp' = `ltemp'
		
			if `vv' >= 16.0 {
				di as txt ///
	"{p 0 6 0 `linesize'}Note: {help j_bayes_displayre:Only the first}"
			}
			else {
				di as txt ///
	"{p 0 6 0 `linesize'}Note: {help j_bayes_displayre15:Only the first}"
			}
			di as txt "``ltemp'' random effects are displayed"
			di as txt "and stored in {bf:e()}.{p_end}"
		}
	}
	
	// ereturn 
	mata: st_local("`ltemp'", `mcmcobject'.m_title)
	ereturn local title = `"``ltemp''"'

	ereturn hidden local headerstr1 = `"`headerstr1'"'
	ereturn hidden local headerstr2 = `"`headerstr2'"'
	ereturn hidden local headerstr3 = `"`headerstr3'"'
	ereturn hidden local subjects   = `"`subjects'"'
	ereturn hidden local censor     = `"`censor'"'
	
	ereturn scalar batch	= `batch'
	ereturn scalar corrlag  = `corrlag'
	ereturn scalar corrtol  = `corrtol'

	if ``lchains'' > 1 {
		ereturn scalar Rc_max = `gr_max_rc'
	}

	ereturn scalar eff_min  = `mineff'
	ereturn scalar eff_max  = `maxeff'
	ereturn scalar eff_avg  = `avgeff'

	mata: st_numscalar("`ltemp'", `mcmcobject'.get_dic())
	ereturn scalar dic = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.get_llatmean())
	ereturn hidden scalar llatmean = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.mean_logposter())
	ereturn hidden scalar lp_mean = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.harmonic_loglik())
	ereturn hidden scalar lml_h = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.laplace_loglik())
	ereturn scalar lml_lm = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.margRE_loglik())
	ereturn hidden scalar margRE_lm = `ltemp'
	mata: st_numscalar("`ltemp'", `mcmcobject'.adapt_iters())
	ereturn hidden scalar adapt_iters = `ltemp'

	mata: st_local("`ltemp'", `mcmcobject'.report_params())
	ereturn hidden local report_params = `"``ltemp''"'
	mata: st_local("`ltemp'", `mcmcobject'.report_colnames())
	ereturn hidden local report_colnames = `"``ltemp''"'

	mata: st_numscalar("`ltemp'", `mcmcobject'.m_simfile_chainvar)
	ereturn hidden local simfile_chainvar = `ltemp'

	if ``lchains'' > 1 {
		tempname parnames
		mata: st_matrix("`ltemp'", `mcmcobject'.chain_sizes())
		ereturn hidden matrix chain_sizes = `ltemp'
		mata: st_local("parnames", `mcmcobject'.summ_params())
		mata: st_matrix("`ltemp'", `mcmcobject'.chain_means())
		matrix colnames `ltemp' = `parnames'
		ereturn hidden matrix chain_means = `ltemp'
		mata: st_matrix("`ltemp'", `mcmcobject'.chain_sds())
		matrix colnames `ltemp' = `parnames'
		ereturn hidden matrix chain_sds = `ltemp'
		mata: st_matrix("`ltemp'", `mcmcobject'.get_chain_eff())
		matrix rownames `ltemp' = `parnames'
		ereturn hidden matrix eff_chains = `ltemp'

		local chainnames
		forvalues i = 1/``lchains'' {
			local chainnames `chainnames' chain`i'
		}

		mata: st_matrix("`ltemp'", `mcmcobject'.chain_harmonic_loglik())
		matrix rownames `ltemp' = "lml_h"
		matrix colnames `ltemp' = `chainnames'
		ereturn hidden matrix lml_h_chains = `ltemp'
		
		mata: st_matrix("`ltemp'", `mcmcobject'.chain_laplace_loglik())
		matrix rownames `ltemp' = "lml_lm"
		matrix colnames `ltemp' = `chainnames'
		ereturn matrix lml_lm_chains = `ltemp'

		mata: st_matrix("`ltemp'", `mcmcobject'.chain_margRE_loglik())
		matrix rownames `ltemp' = "margRE_lm"
		matrix colnames `ltemp' = `chainnames'
		ereturn hidden matrix margRE_lm_chains = `ltemp'
	
		mata: st_matrix("`ltemp'", `mcmcobject'.get_chain_llatmean())
		matrix rownames `ltemp' = "llatmean"
		matrix colnames `ltemp' = `chainnames'
		ereturn hidden matrix llatmean_chains = `ltemp'
	
		matrix `ltemp' = J(1, ``lchains'', .)
		forvalues i = 1/``lchains'' {
			matrix `ltemp'[1,`i'] = `maxeff'_`i'
		}
		matrix rownames `ltemp' = "maxeff"
		matrix colnames `ltemp' = `chainnames'
		ereturn matrix eff_max_chains = `ltemp'

		matrix `ltemp' = J(1, ``lchains'', .)
		forvalues i = 1/``lchains'' {
			matrix `ltemp'[1,`i'] = `avgeff'_`i'
		}
		matrix rownames `ltemp' = "avgeff"
		matrix colnames `ltemp' = `chainnames'
		ereturn matrix eff_avg_chains = `ltemp'

		matrix `ltemp' = J(1, ``lchains'', .)
		forvalues i = 1/``lchains'' {
			matrix `ltemp'[1,`i'] = `mineff'_`i'
		}
		matrix rownames `ltemp' = "mineff"
		matrix colnames `ltemp' = `chainnames'
		ereturn matrix eff_min_chains = `ltemp'

		matrix rownames `lacr' = "arate"
		matrix colnames `lacr' = `chainnames'
		ereturn matrix arate_chains = `lacr'

		mata: st_matrix("`ltemp'", `mcmcobject'.get_chain_dic())
		matrix rownames `ltemp' = "dic"
		matrix colnames `ltemp' = `chainnames'
		ereturn matrix dic_chains = `ltemp'
	}

	capture confirm matrix `initmat'
	if !_rc {
		capture matrix `mcmcmat' = `initmat''
	}
	if !_rc {
		ereturn matrix init = `mcmcmat'
	}
	if _rc == 908 {
		di as txt "{p 0 6 0 `linesize'}Note: Starting values were not saved " ///
			"due to small matsize.{p_end}"
	}

	capture confirm matrix `essmat'
	if !_rc {
		matrix `mcmcmat'	= `essmat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix ess	= `mcmcmat'
	}

	if `"`noecov'"' == "" {
		capture confirm matrix `covmat'
		if !_rc {
			ereturn matrix Cov  = `covmat'
		}
	}
	
	ereturn scalar clevel = `clevel'*100
	if `"`hpd'"' != "" {
		capture confirm matrix `hpdmat'
		if !_rc {
			ereturn scalar hpd	= 1
			matrix `mcmcmat'	= `hpdmat'[1..`numpars',1..2]
			matrix `mcmcmat'	= `mcmcmat''
			ereturn matrix cri	= `mcmcmat'
		}
	}
	else {
		capture confirm matrix `quantmat'
		if !_rc {
			ereturn scalar hpd	= 0
			matrix `mcmcmat'	= `quantmat'[1..`numpars',1..2]
			matrix `mcmcmat'	= `mcmcmat''
			ereturn matrix cri	= `mcmcmat'
		}
	}

	capture confirm matrix `mcmcsum'
	if _rc {
		global MCMC_matsizemin = `numpars'
	}

	capture confirm matrix `medianmat'
	if !_rc {
		matrix `mcmcmat'	= `medianmat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix median 	= `mcmcmat'
	}

	capture confirm matrix `mcsemat'
	if !_rc {
		matrix `mcmcmat'	= `mcsemat'[1..`numpars',2]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix mcse	= `mcmcmat'
		
		matrix `mcmcmat'	= `mcsemat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix sd 	= `mcmcmat'
	}

	capture confirm matrix `meanmat'
	if !_rc {
		matrix `mcmcmat'	= `meanmat'[1..`numpars',1]
		matrix `mcmcmat'	= `mcmcmat''
		ereturn matrix mean 	= `mcmcmat'
	}
	
	capture confirm matrix `pcnsmat'
	if !_rc {
		ereturn hidden matrix cns = `pcnsmat'
	}

end
	
exit

