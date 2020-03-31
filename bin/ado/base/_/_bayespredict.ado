*! version 1.2.3  21aug2019

program _bayespredict, rclass
	gettoken cmd 0 : 0
	_bayespredict_`cmd' `0'
	return clear
end

program _bayespredict_simulate

	tempfile tmpdta tmpster
	global BAYESPR_tmpdta  `tmpdta'
	global BAYESPR_tmpster `tmpster'

	_bayespredict build `0'

	local mcmcobject `"`s(mcmcobject)'"'
	local predfile   `"`s(predfile)'"'
	local estfile    `"`s(estfile)'"'
	local simpars    `"`s(simpars)'"'
	local predobs    `"`s(predobs)'"'
	local summstats  `"`s(summstats)'"'
	local repopts    `"`s(repopts)'"'

	if `"`summstats'"' != "" {
		_bayespredict save_summstat using `"`estfile'"',	///
		mcmcobject(`mcmcobject') predfile(`predfile')	///
		`summstats' `repopts' 
	}
end

program _bayespredict_build, sclass

	local cmdline `0'

	// options
	syntax [anything] [if/] [in], [	///
		MCMCOBJECT(string)	///
		CHAINs(string)		///
		USING(string)		///
		RSEED(string)		///
		SAVing(string asis)	///
		mean std median cri mcse(string) Outcome(string) ///
		CLEVel(string)		///
		HPD BATCH(passthru)	///
		CORRLAG(passthru)	///
		CORRTOL(passthru)	///
		nreps(string)		///
		NODOTS			///
		DOTS			///
		DOTS1(string)		///
		debug ]

	if `"`cri'"' == "" & `"`clevel'"' != "" {
		di as err `"option {bf:clevel(`clevel')} not allowed"'
		exit 198
	}
	if `"`mean'"' == "" {
		if `"`batch'"' != "" {
			di as err `"option {bf:`batch'} not allowed"'
			exit 198
		}
		if `"`corrlag'"' != "" {
			di as err `"option {bf:`corrlag'} not allowed"'
			exit 198
		}
		if `"`corrtol'"' != "" {
			di as err `"option {bf:`corrtol'} not allowed"'
			exit 198
		}
	}
	
	_bayesmh_summaryopts `batch' clevel(`clevel') `corrlag' `corrtol' `hpd' 
	local clevel "`s(clevel)'"
	local hpd    "`s(hpd)'"
	local batch  "`s(batch)'"
	local repopts clevel(`clevel') `corrlag' `corrtol' `hpd'
	if `"`batch'"' != "0" {
		local repopts `repopts' batch(`batch')
	}

	// check dots and dots()
	_bayes_dot_options `"`nodots'"' `"`dots'"' `"`dots1'"'
	local dots `s(dots)'
	local dotsevery `s(dotsevery)'

	tempname curest ltemp
	marksample touse

	if `"`mcmcobject'"' == "" {
		assert 0
	}
	// provide a common expression parser object for all equations
	global MCMC_exprcount = 0
	mata: getfree_mata_object_name("exprobject", "_mcmc_exprobj")
	global MCMC_mexprobj `exprobject'
	mata: `exprobject' = __bayes_expr(1)

	local yvarlist0 `"`anything'"'
	
	////////////////////////////////////////////////////////////////////////
	// setup globals used in _bayespredict_parse
	global BAYESPR_predfile `predfile'
	global BAYESPR_using
	local yvarlist `"`e(depvars)'"'
	global BAYESPR_ysimvars `yvarlist'
	global BAYESPR_predynames
	global BAYESPR_caller bayespredict

	local nlist
	qui summarize `touse', meanonly
	if r(min) < r(max) {
		mata: st_local("nlist", strOfTouseObservations("`touse'"))
	}

	local n = _N
	local i = 0
	foreach yvar of local yvarlist {
		local i = `i' + 1
		global BAYESPR_ysim`i'  `yvar'
		global BAYESPR_resid`i' `yvar'
		global BAYESPR_mu`i'    `yvar'
		// BAYESPR_predynames: initial list of allowed predict vars
		local simvars $BAYESPR_predynames
		if `"`nlist'"' != "" {
			foreach tok of local nlist {
				tokenize `"`tok'"', parse("/")
				if `"`2'"' == "/"  {
					local simvars `simvars' _ysim`i'_`1'-_ysim`i'_`3'
				}
				else {
					local simvars `simvars' _ysim`i'_`tok'
				}
			}
			global BAYESPR_predynames `simvars'
			global BAYESPR_ysim`i'_obs = `"`nlist'"'
			global BAYESPR_resid`i'_obs = `"`nlist'"'
			global BAYESPR_mu`i'_obs = `"`nlist'"'
		}
		else if `n' > 1 {
			global BAYESPR_predynames `simvars' _ysim`i'_1-_ysim`i'_`n'
			global BAYESPR_ysim`i'_obs = `"1/`n'"'
			global BAYESPR_resid`i'_obs = `"1/`n'"'
			global BAYESPR_mu`i'_obs = `"1/`n'"'
		}
		else {
			global BAYESPR_predynames `simvars' _ysim`i'_1
			global BAYESPR_ysim`i'_obs = "1"
			global BAYESPR_resid`i'_obs = "1"
			global BAYESPR_mu`i'_obs = `"1"'
		}
	}
	local nyvarlist: list sizeof yvarlist

	////////////////////////////////////////////////////////////////////////
	
	local predfile
	local estfile

	local vtype
	local vformat

	local newvars
	local summstats `mean' `std' `median' `cri'
	if `"`summstats'`mcse'`nreps'"' != "" {
		
		if `:list sizeof summstats' > 1 {
			di as err `"options {bf:`summstats'} cannot be combined"'
			exit 198
		}
		
		local noutcomes : list sizeof yvarlist

		local anything `"`yvarlist0'"'
		local yvarlist0
		local types byte int long float double
		local formats %8.0g %8.0g %12.0g %9.0g %10.0g
		gettoken vtype anything : anything
		if !`:list vtype in types' {
			local anything `vtype' `anything'
			local vtype float
		}
		local k : list posof "`vtype'" in types
		tokenize "`formats'"
		local vformat "``k''"

		local outlist `outcome'
		if `:list sizeof outlist' > 1 {
			di as err `"only one outcome at a time is allowed"'
			exit 198
		}
		local outcome
		local outcomevars
		foreach tok of local outlist {
			local nvar : list tok in yvarlist
			if `nvar' == 0 {
				di as err `"outcome {bf:`tok'} not found"'
				if `:list sizeof yvarlist' == 1 {
				di as err `"{bf:`yvarlist'} is the only available outcome"'
				}
				else {
				di as err `"available outcomes: {bf:`yvarlist'}"'
				}
				exit 198
				// in case #num is allowed
				local nvar `tok'
				gettoken hash nvar : nvar, parse("#")
				if "`hash'" != "#" {
					local nvar `hash'
				}
				else {
					local tok `nvar'
				}
			}
			cap confirm number `nvar'
			if _rc {
				di as err `"outcome {bf:`tok'} not found"'
				exit 198
			}
			if `nvar' <= 0 | `nvar' > `nyvarlist' {
				di as err `"outcome {bf:`tok'} not found"'
				exit 198
			}
			// request `outcome' equation only
			local yvarlist0 `yvarlist0' {_ysim`nvar'}
			local outcome `outcome' `nvar'
			local outcomevars `outcomevars' `tok'
		}
		
		if `"`nreps'"' != "" {
			if `"`summstats'"' != "" {
di as err `"{bf:nreps(`nreps')} cannot be combined with "' ///
`"options {bf:mean}, {bf:std}, {bf:median}, {bf:mcse()}, or {bf:cri()}."'
				exit 198
			}
			// first outcome is the default
			if `"`outcome'"' == "" {
				gettoken outcomevars foo : yvarlist
				local outcome 1
			}
			// only one outcome is allowed
			if `:list sizeof outcome' > 1 {
				di as err `"only one outcome is allowed"'
				exit 198
			}
			cap confirm integer number `nreps'
			if _rc {
				di as err `"number of replicates must be integer"'
				exit 198
			}
			if `nreps' < 1 {
				di as err `"number of replicates must be positive integer"'
				exit 198
			}
		}

		local newvars
		local anything : list uniq anything

		if `"`cri'"' != "" {
			if `:list sizeof anything' != 2 {
			di as err `"option {bf:cri} expects 2 new variable names"'
				exit 198
			}
			gettoken crilow crihigh : anything
			gettoken crilow star1  : crilow, parse("*")
			gettoken crihigh star2 : crihigh, parse("*")
			if `"`star1'`star2'"' != "" {
				if `"`star1'"' != `"`star2'"' {
					di as err `"option {bf:cri} expects 2 "' ///
					`"stubs for variable names"'
					exit 198
				}
				if `"`outcome'"' == "" {
					forvalues nvar = 1/`nyvarlist' {
						local outcome `outcome' `nvar'
					}
				}
			}
			else {
				if `"`outcome'"' == "" {
					gettoken outcomevars foo : yvarlist
					local outcome 1
				}
			}
			local noutcomes 2
		}

		gettoken anything star : anything, parse("*")
		if `"`star'"' == "*" {
			local newvar `anything'
			cap confirm name `newvar'
			if _rc {
				di as err `"invalid name {bf:`newvar'}"'
				exit 198
			}
			local anything
			if `"`nreps'"' != "" {
				forvalues i = 1/`nreps' {
					local anything `anything' `newvar'`i'
				}
			}
			else {
				forvalues i = 1/`noutcomes' {
					local anything `anything' `newvar'`i'
				}
			}
		}
		foreach newvar of local anything {
			cap confirm name `newvar'
			if _rc {
				di as err `"invalid name {bf:`newvar'}"'
				exit 198
			}
			gen `newvar' = 0
			qui drop `newvar'
			local newvars `newvars' `newvar'
		}
		local nnewvars : list sizeof newvars
		if `nnewvars' == 1 & `"`outcome'"' == "" {
			gettoken outcomevars foo : yvarlist
			local outcome 1
		}

		local manyfew
		local nout `noutcomes'
		if `"`nreps'"' != "" {
			local nout `nreps'
			if `nnewvars' > `nreps' {
				local manyfew many
			}
			if `nnewvars' < `nreps' {
				local manyfew few
			}	
		}
		else {
			if `nnewvars' > `nout' {
				local manyfew many
			}
			if `nnewvars' > 1 & `nnewvars' < `nout' {
				local manyfew few
			}
		}
		if `"`manyfew'"' != "" {
			di as err "too `manyfew' variables specified"
			if `nout' > 1 {
			di as err `"{p 4 4 2}You must specify `nout' "' ///
	`"new variable names or {help newvarlist##stub:variable stub}.{p_end}"'
			}
			else {
			di as err `"{p 4 4 2}You must specify one "' ///
				`"new variable name.{p_end}"'
			}
			exit 198
		}

		if `"`outcome'"' == "" {
			local outcomevars `yvarlist'
			forvalues nvar = 1/`nyvarlist' {
				local outcome `outcome' `nvar'
			}
		}

		if `"`mcse'"' !="" {
			if `"`mean'"' == "" {
		di as err `"option {bf:mcse()} is only available with the {bf:mean} option"'
				exit 198
			}
			if `:list sizeof mcse' < 1 {
		di as err `"option {bf:mcse()} expects at least one variable name"'
				exit 198
			}
			local toks `mcse'
			local mcse
			foreach newvar of local toks {
				gettoken newvar star : newvar, parse("*")
				confirm name `newvar'
				gen `newvar' = 0
				drop `newvar'
				local mcse `mcse' `newvar'
			}
		}

		if `"`saving'"' != "" {
			if `"`nreps'"' != "" {
				di as err `"{bf:saving()} not allowed"'
			}
			else {
di as err `"{bf:saving()} cannot be combined with "' ///
`"options {bf:mean}, {bf:std}, {bf:median}, {bf:mcse()}, or {bf:cri()}."'
			}
			exit 198
		}
		local predfile $BAYESPR_tmpdta
		local estfile  $BAYESPR_tmpster

		local summstats outcome(`outcome') outcomevars(`outcomevars') ///
			type(`vtype')
		if `"`mean'"' != "" {
			local summstats `summstats' mean(`newvars')
		}
		else if `"`std'"' != "" {
			local summstats `summstats' std(`newvars')
		}
		else if `"`median'"' != "" {
			local summstats `summstats' median(`newvars')
		}
		if `"`mcse'"' != "" {
			local summstats `summstats' mcse(`mcse')
		}
		if `"`crilow'"' != "" {
			local summstats `summstats' crilow(`crilow')
		}
		if `"`crihigh'"' != "" {
			local summstats `summstats' crihigh(`crihigh')
		}
	}
	else {
		if "`yvarlist0'" == "" {
			_something_required_error
		}
		if `"`outcome'"' != "" {
			di as err `"option {bf:outcome(`outcome')} not allowed"'
			exit 198
		}
	}

	if `"`chains'"' == "" {
		local chains _all
	}
	_bayes_chains parse `"`chains'"'
	local chains `r(chains)'
	local nchains: word count `chains'
	
	_bayesmhpost_options `options'
	local every = `s(skip)'+1
 
 	local opchains
	if `"`chains'"' != "" {
		local opchains `"chains(`chains')"' 
	}

	local thetas `e(parnames)'
	// load simulation dataset and create mcmcobject based on it
	_mcmc_read_simdata, mcmcobject(`mcmcobject')	///
		thetas(`thetas') using(`"`using'"')	///
		every(`every') `opchains'
	// these are the parameters in the simulation dataset
	mata: st_local("simpars", `mcmcobject'.parnames())

	mata: `mcmcobject'.set_depvar_names(`"`e(depvars)'"')
	
	global MCMC_debug  0
	if "`debug'" != "" {
		global MCMC_debug  1
		mata: `mcmcobject'.m_debug = 1
	}

	// check integrity of the current dataset
	local covarlist `"`e(indepvars)'"'
	if `"`covarlist'"' != "" {
		cap confirm variable `covarlist'
		if _rc {
		di as err "current data not compatible with last estimation model"
		confirm variable `covarlist'
		}
	}

	local predyids
	local definevars
	forvalues ivar = 1/`e(predvar_n)' {
		local predyvars `"`e(predvar_`ivar')'"'
		local eqline `"`e(predeq_`ivar')'"'

		_mcmc_parse equation `eqline'
		if `"`s(dist)'"' == "define" {
			local definevars `definevars' `predyvars'
			cap confirm variable `predyvars'
			if _rc == 111 {
				global MCMC_genvars $MCMC_genvars `predyvars'
				cap generate double `predyvars' = 0
			}
			if _rc {
				confirm variable `predyvars'
			}
			mata: `mcmcobject'.add_factor()	
			mata: `mcmcobject'.set_factor(		///
	 		NULL,	 	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`s(eval)'"', "`s(evallist)'", 	///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 		///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",				///
		 	"`s(yomit)'",				///
		 	"`s(x)'",	 	 	 	///
		 	"`s(xisvar)'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",	 	 	 	///
		 	"`s(xomit)'",	 	 	 	///
		 	"`s(nocons)'",	 	 		///
			"", "", "", "", "", "")
		}
		else {
			local predyids `predyids' `ivar'
		}
	}

	if  `"`yvarlist0'"' != "" {

	local ct 1
	while `ct' > 0 {
		local yvarlist0 : subinstr local yvarlist0 "}{" "} {", count(local ct)
	}

	local predyids
	local yvarlist `"`yvarlist0'"'	
	gettoken tok yvarlist : yvarlist, match(lmatch) bind
	while `"`tok'"' != "" {

		gettoken lab tok : tok, parse(":") bindcurly
		if `"`lab'"' != "" & `"`tok'"' != "" {
			gettoken col tok : tok, parse(":")
		}
		else {
			local tok `lab'
			local lab
		}
		local tok `tok'
		local lab `lab'
		local tokspec
		tokenize `"`tok'"', parse("{}")
		if `"`1'"' != "{" | `"`3'"' != "}" | `"`4'"' != "" {
			gettoken fspec tok : tok, parse("@")
			if `"`fspec'"' != "@" {
				if `"`saving'"' == "" {
					_something_required_error
				}
				else if `"`lab'"' != "" {
			di as err `"invalid specification {bf:`lab':`fspec'`tok'}"'
				}
				else {
			di as err `"invalid specification {bf:`fspec'`tok'}"'
				}
				exit 198
			}
			local tokspec `fspec'`tok'
			
			local ct 1
			while `ct' > 0 {
				local tok : subinstr local tok ", " ",", count(local ct)
			}
			local ct 1
			while `ct' > 0 {
				local tok : subinstr local tok " ," ",", count(local ct)
			}
			// allow for space separator in programs
			tokenize "`tok'", parse("()\ ")
			if `"`2'"' == "(" & `"`4'"' == ")" {
				local fun `1'
				local tok `3'
			}
			else {
				gettoken fun tok : tok
			}
		}
		else {
			local tok {`2'}
			local tokspec `tok'
		}

		_bayespredict_parse `"`tok'"'
		local toklist `s(varlist)'

		if `"`fun'"' == "" & `"`s(hasresid)'"' == "1" {
			di as err `"residuals allowed only within functions or programs"'
			exit 198
		}

		foreach tok of local toklist {
			local found 0
			forvalues ivar = 1/`e(predvar_n)' {
				local ispredvar `e(predvar_`ivar')'
				local ispredvar : list tok in ispredvar
				if `ispredvar' {
					local found 1
					local predyids `predyids' `ivar'

			if `"`s(usernumspec)'"' != "" {
				if "`_BAYESPR_ytouse`ivar''" == "" {
					mata: st_local("ytouse", st_tempname())
					qui gen `ytouse' = 0
				}
				cap replace `ytouse' = 1 in `s(usernumspec)'
				if !_rc {
					local _BAYESPR_ytouse`ivar' `ytouse'
				}
			}

				}
			}
			if !`found' {

		if `: list sizeof tok' > 1 {
			di as err `"prediction variables {bf:`tok'} not available"'
		}
		else {
			di as err `"prediction variable {bf:`tok'} not available"'
		}
				exit 198
			}
			local found: list tok in definevars
		}

		gettoken tok yvarlist : yvarlist, match(lmatch) bind
	}

	if "`predyids'" == "" {
		di as err `"invalid specification {bf:`tokspec'}"'
		exit 198
	}
	
	}

	if `"`summstats'`mcse'`nreps'"' == "" {
		if `"`saving'"' != "" {
			_savingopt_parse predfile savereplace : ///
				saving ".dta" `"`saving'"'
			local replacenote 0
			if ("`savereplace'"=="") {
				confirm new file `"`predfile'"'
				_bayespredict_check_estfile `"`predfile'"'
			}
			else {
				cap confirm new file `"`predfile'"'
				if _rc==0 {
					local replacenote 1
				}
			}
		}
		else {
			di as err "{p}you must specify option {bf:saving()} " ///
			"with {bf:bayespredict} to save prediction results{p_end}"
			exit 321
		}
		_bayespredict_estname estfile : `"`predfile'"'
	}

	// set BAYESPR_predfile to be used in error messages
	global BAYESPR_predfile `predfile'
	global BAYESPR_using `predfile'

	// list of equation numbers to be used in prediction
	local predyids : list uniq predyids
	foreach ivar of local predyids {

		local predyvars `"`e(predvar_`ivar')'"'
		local eqline `"`e(predeq_`ivar')'"'

		local list_sub_exprs `"`e(predsubexpr_`ivar')'"'
		local sub_exprs_vars `"`e(predsubexprvars_`ivar')'"'

		_mcmc_scan_identmats `eqline'
		local eqline `s(eqline)'
			
		_mcmc_parse equation `eqline'
		
		if `"`s(dist)'"' == "logdensity" {
			di as err `"predictions not available with {bf:llf()} likelihood option"'
			exit 198
		}
		
		local moptobject
		// replace the likelihood evaluators with list_sub_exprs
		local evallist = `"`s(eval)'"'
		local eval
		gettoken next evallist : evallist
		gettoken sexpr list_sub_exprs : list_sub_exprs
		while `"`next'"' != "" & `"`sexpr'"' != "" & `"`sexpr'"' != "xb" {
			local eval `"`eval' "`sexpr'""'
			gettoken next evallist : evallist
			gettoken sexpr list_sub_exprs : list_sub_exprs
		}
		while `"`next'"' != "" {
			local eval `"`eval' "`next'""'
			gettoken next evallist : evallist
		}

		local xisvar   `s(xisvar)'
		local eval     `"`eval'"'
		local evallist `s(evallist)'
		if "`moptobject'" != "" {
			while regexm(`"`xisvar'"', "1") {
				local xisvar = regexr(`"`xisvar'"', "1", "0")
			}
			while regexm(`"`eval'"', "xb") {
				local eval = regexr(`"`eval'"', "xb", "NULL")
			}
			while regexm(`"`evallist'"', "xb") {
				local evallist = regexr(`"`evallist'"', "xb", "NULL")
			}
		}

		mata: `mcmcobject'.add_factor()
		mata: `mcmcobject'.set_factor(			///
		 	NULL,	 	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`eval'"', "`evallist'",		///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 	 	///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",	 	 	 	///
		 	"`s(yomit)'",	 	 	 	///
		 	"`s(x)'",				///
		 	"`xisvar'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",				///
		 	"`s(xomit)'",				///
		 	"`s(nocons)'",				///
			"`exparams'",                           ///
		 	`"`llevaluator'"',			///
		 	`"`s(exvarlist)'"',			///
			`"`passthruopts'"',                     ///
			"`moptobject'",				///
			"predict")
		// markout missing observations from varlist
		markout `touse' `touse' `sub_exprs_vars'

		local ytouse `_BAYESPR_ytouse`ivar''
		if `"`ytouse'"' != "" {
			mata: `mcmcobject'.set_touse( ///
			NULL, st_data(., "`ytouse'"), "", J(1,0,0), "", "")
		}
		else {
			mata: `mcmcobject'.set_touse( ///
			NULL, st_data(., "`touse'"), "", J(1,0,0), "", "")
		}
	}

	// build the model
	mata: `mcmcobject'.build_factors(NULL, NULL, 0)

	// set nchains before calling set_rngstate()
	mata: `mcmcobject'.set_mcmc_chains(`nchains')

	_mcmc_set_seed "`mcmcobject'" "`rseed'"
	mata: `mcmcobject'.set_rngstate()

	mata: `mcmcobject'.setPredictStatNames("")

	_bayespredict_parse_stats `mcmcobject' `"`yvarlist0'"'

	mata: st_local("prednames", `mcmcobject'.savedPredictNames())
	mata: st_local("predstatnames", `mcmcobject'.predictStatNames())
	if "`prednames'`predstatnames'" == "" {
		di as err `"invalid specification {bf: `yvarlist0'}"'
		exit 198
	}

	// call `mcmcobject'.predict within _bayespredict_build, 
	// to have consistent st_tempname()s
	// write to the default prediction dataset
	
	if `"`nreps'"' != "" {

		confirm number `nreps'
		if `:list sizeof outcome' > 1 {
			di as err `"only one outcome at a time is allowed"'
			exit 198
		}

		mata: `mcmcobject'.predict_reps(`"`simpars'"', ///
			`dots', `dotsevery', `"`predfile'"', `nreps')

		local replnames `newvars'
		_bayesreps_check_names `"`replnames'"' `nreps'

		gettoken eq outcome : outcome

		local isstub = `:list sizeof replnames' < `nreps' & `nreps' > 1
		local repvarlist
		forvalues i = 1/`nreps' {
			if `"`replnames'"' != "" {
				gettoken stub replnames : replnames
				local newvar `stub'
			}
			if `isstub' {
				local newvar `stub'`i'
			}
			local repvarlist `repvarlist' `newvar'
		}

		_bayespredict_parse `"_ysim`eq'"'

		tempname tmpdta
		preserve
		use _index `s(predobs)' using `"`predfile'"', clear
		qui replace _index = _n
		qui reshape long _ysim`eq'_, i(_index) j(_obs)
		label variable _ysim`eq'_ "`newvar'"
		qui reshape wide _ysim`eq'_, i(_obs) j(_index)
		drop _obs
		local tlist `repvarlist'
		forvalues i = 1/`nreps' {
			gettoken tok tlist : tlist
			rename _ysim`eq'_`i' `tok'
			label variable `tok' "Replicate `i' for `outcomevars'"
		}
		if `"`vtype'"' != "" {
			qui recast `vtype' `repvarlist'
		}
		if `"`vformat'"' != "" {
			qui format `vformat' `repvarlist'
		}

		qui save `tmpdta', replace
		restore
		qui merge 1:1 _n using `tmpdta'
		qui drop _merge
		qui rm `tmpdta'.dta

		exit
	}

	mata: `mcmcobject'.predict(`"`simpars'"', ///
			`dots', `dotsevery', `"`predfile'"', `"`chains'"')

	if `"`saving'"' != "" {
		di ""
		di as txt _c
		_bayesmh_saving_notes `replacenote' `"`predfile'"'
	}

	if `"`saving'`summstats'"' != "" {
		local reportnote = `"`saving'"' != ""
		_bayespredict eststore `mcmcobject' `"`predfile'"' ///
		`"`estfile'"' `"`reportnote'"' `"`savereplace'"'   ///
		`"`cmdline'"' `"`chains'"'
	}

	sreturn local simpars    = `"`simpars'"'
	sreturn local predfile   = `"`predfile'"'
	sreturn local estfile    = `"`estfile'"'
	sreturn local mcmcobject = `"`mcmcobject'"'
	sreturn local summstats  = `"`summstats'"'
	sreturn local repopts    = `"`repopts'"'
end

program _bayespredict_parse_stats, sclass

	args mcmcobject yvarlist

	_mcmc_parse expand `yvarlist'
	local yvarlist `s(eqline)'
	if  `"`yvarlist'"' == "" {
		exit
	}

	local outlist
	local predobs
	local predfunc
	local residlist
	local mulist
	local proglist
	local ignoreobs

	// don't save observation predictions unless requested
	mata: `mcmcobject'.setPredictSave("", 0)

	gettoken tok yvarlist : yvarlist, match(lmatch) bind
	while `"`tok'"' != "" {

		local alltok `tok'
		if `"`lmatch'"' == "(" {
			local alltok (`alltok')
		}

		gettoken lab tok : tok, parse(":") bindcurly
		if `"`lab'"' != "" & `"`tok'"' != "" {
			gettoken col tok : tok, parse(":")
		}
		else {
			local tok `lab'
			local lab
		}
		local tok `tok'
		local lab `lab'

		local fun
		local prog
		local suf `"`tok'"'

		tokenize `"`tok'"', parse("{}")
		if `"`1'"' != "{" | `"`3'"' != "}" | `"`4'"' != "" {
			gettoken fspec tok : tok, parse("@")
			if `"`fspec'"' == "@" {
				// allow for space separator in programs
				tokenize "`tok'", parse("() ")
				if `"`2'"' == "(" {
					tokenize "`tok'", parse("()")
					if `"`2'"' != "(" | `"`4'"' != ")" {
			di as err `"invalid specification {bf:`tok'}"'
						exit 198
					}
					if `"`5'"' != "" {
			di as err `"invalid function specification {bf:`tok'}"'
						exit 198
					}
					local fun `1'
					local tok `3'
				}
				else {
					gettoken prog tok : tok

			if !regexm(`"`tok'"', "\{[A-Za-z0-9_\ :]*\}") {
				di as err `"invalid specification {bf:@`prog'}"'
				exit 198
			}
					local 0 `tok'
					syntax [anything] [,		///
						PARAMeters(string)	///
						EXTRAVARS(string)	///
						PASSTHRUopts(string) *]
					if `"`options'"' != "" {
			di as err `"invalid program options {bf:`options'}"'
						exit 198
					}
					local tok `anything'
					
				if `"`extravars'"' != "" {
					capture confirm variable `extravars'
					if _rc {
						local tok: word count `extravars'
						if `tok' > 1 {
	di as err "invalid option {bf:extravars()}:"
	di as err `"{bf:`extravars'} must be variables"'
						}
						else {
	di as err "invalid option {bf:extravars()}:"
	di as err `"{bf:`extravars'} must be a variable"'
						}
						exit 198
					}
				}

				}
			}
			else {
				local tok `fspec'
			}
		}

		if `"`fun'`prog'"' == "" & `"`lmatch'"' == "(" {
			local tok (`tok')
		}

		if `"`fun'`prog'"' != "" {
			local argtoks `tok'
			if `"`fun'"' != "" {
				local argtoks = regexr(`"`argtoks'"', ",", " ")
			}
			local uniqtok : list uniq argtoks
			local uniqtok : list argtoks - uniqtok
			if `"`uniqtok'"' != "" {
				di as err `"repeating argument {bf:`uniqtok'} not allowed"'
				exit 198
			}
			_bayespredict_regexm braces regpat1 :
			_bayespredict_regexm nobraces regpat2 :
			
			while `"`argtoks'"' != "" {
				gettoken argtok argtoks : argtoks, bindcurly bind
				if !regexm(`"`argtok'"', "`regpat1'") & ///
				!regexm(`"`argtok'"', "`regpat2'") {
					local where program
					if `"`fun'"' != "" {
						local where function
					}
					di as err `"argument {bf:`argtok'} not allowed "' ///
					`"in `where' {bf:`fun'`prog'}"'
					exit 198
				}
			}
		}

		_bayespredict_parse `"`tok'"'

		local tok      `s(varlist)'
		local simtok   `s(simvarlist)'
		local residtok `s(residvarlist)'
		local mutok    `s(muvarlist)'
		local ignoreobs `ignoreobs' `s(ignoreobs)'

		if `"`s(predobs)'"' == "" {
			local par `s(expr)'
			if regexm(`"`par'"', "\{[A-Za-z0-9_\ :]*\}") {
				local par = regexs(0)
			}
			di as err `"{bf:`par'} not found"'
			_bayespredict_notfound `"`par'"' `"$BAYESPR_using"' `"$BAYESPR_caller"'
			exit 198
		}

		local predobs `predobs' `s(predobs)'

		if `"`s(hasresid)'"' == "1" {
			local residlist `residlist' `s(predobs)'
		}
		if `"`s(hasmu)'"' == "1" {
			local mulist `mulist' `s(predobs)'
		}

		if `"`s(varlist)'"' == "" {
			local outlist `outlist' `alltok'
			gettoken tok yvarlist : yvarlist, match(lmatch) bind
			continue
		}

	scalar found = 0
	if `"`fun'"' != "" {
		if `: list sizeof simtok' > 2 {
			di as err `"only one or two arguments allowed "' ///
				`"in function {bf:`fun'}"'
			exit 198
		}
		local nargs : list sizeof simtok
		if `"`s(usernumlist)'"' != "" {
		di as err "subset specifications not allowed"
di as err `"{p 4 4 2}Subset specifications {bf:_ysim[{it:numlist}]}, "' ///
`"{bf:_mu[{it:numlist}]}, and {bf:_resid[{it:numlist}]} are not allowed as "' ///
"arguments to Mata functions and Stata programs.{p_end}"
			//di as err `"numlist {bf:[`s(usernumlist)']} not allowed "' ///
			//	`"within function {bf:`fun'}"'
			exit 198
		}
		mata: st_numscalar("found", findexternal("`fun'()") != NULL)		
		if !found {
			di as err `"function {bf:`fun'} not found"'
			exit 198
		}
		mata: `mcmcobject'.check_predict_func(`"`fun'"', `nargs')
	}
	else if `"`prog'"' != "" {
		if `: list sizeof simtok' > 2 {
			di as err `"only one or two arguments allowed "' ///
				`"in function {bf:`fun'}"'
			exit 198
		}
		// check if it is a program
		local nargs : list sizeof simtok
		gettoken yvar : tok
		mata: `mcmcobject'.check_predict_prog(`"`prog'"', `"`yvar'"', ///
			`nargs', `"`extravars'"', `"`passthruopts'"')
		scalar found = 1
		local fun `prog'
		local proglist `proglist' `prog'
	}
	if !found {
		// single prediction observations are requested
		local parlist `s(predobs)'

		mata: `mcmcobject'.setPredictSave(`"`parlist'"', 1)
		if `"`fun'"' != "" {
			foreach par of local parlist {		
				local tok `fun'(`par')
				if `"`lab'"' != "" {
					local tok `lab':`tok'
				}
				local outlist `outlist' (`tok')
			}
		}
		else {
			local hasparen 0
			if `"`lmatch'"' == "(" {
				// tok is expression: put it in parentheses 
				// if it doesn't have ones
				gettoken foo1 foo2 : tok, match(lmatch) bind
				if `"`lmatch'"' == "" {
					local hasparen 1
					
				}
			}
			local toklist `s(expr)'
			if `"`suf'"' != "" & `"`lab'"' != "" {
				local tmplist `toklist'
				local toklist
				local i 0
				while `"`tmplist'"' != "" {
					gettoken tok tmplist : tmplist, ///
						match(lmatch) bind
					if `"`lmatch'"' == "(" {
						local tok (`tok')
					}
					local i = `i' + 1
					if `i'==1 & `"`tmplist'"'=="" {
						// no index for single expressions
						local i
					}
					local tok `lab'`i':`tok'
					if `hasparen' {
						local tok (`tok')
					}
					local toklist `toklist' `tok'
				}
			
			}
			local outlist `outlist' `toklist'
		}
		gettoken tok yvarlist : yvarlist, match(lmatch) bind
		continue
	}

		tempname tmplab
		local `tmplab' `lab'
		if `"``tmplab''"' == "" {
			gettoken `tmplab' : simtok
			// default label to functions
			local `tmplab' ``tmplab''_`fun'
		}

		mata: `mcmcobject'.add_predict_stat(`"`tmplab'"',	///
			`"`tok'"', `"`fun'"', "`mutok'", "`residtok'",	///
			`"`extravars'"', `"`passthruopts'"')
		local predfunc `predfunc' ``tmplab''
		local outlist `outlist' ``tmplab''
		
		gettoken tok yvarlist : yvarlist, match(lmatch) bind
	}

	sreturn clear

	local predobs   : list uniq predobs
	local residlist : list uniq residlist
	local mulist    : list uniq mulist

	sreturn local predobs   = `"`predobs'"'
	sreturn local predfunc  = `"`predfunc'"'
	sreturn local outlist   = `"`outlist'"'
	sreturn local residlist = `"`residlist'"'
	sreturn local mulist    = `"`mulist'"'
	sreturn local proglist  = `"`proglist'"'
	sreturn local ignoreobs = `"`ignoreobs'"'
end

program _bayespredict_eststore, eclass

	args mcmcobject predfile estfile reportnote replace cmdline chains

	local bayescmdline `"`e(cmd)' `e(cmdline)'"'
	local mcmcfile `"`e(filename)'"'

	if `"`chains'"' == `"`e(allchains)'"' {
		local chains
	}
	if `"`chains'"' != "" {
		local nchains : list sizeof chains
	}
	else {
		mata: st_local("nchains", strofreal(`mcmcobject'.mcmc_chains()))
	}
	forvalues i = 1/`nchains' {
		local erngstate`i' `e(rngstate`i')'
	}
	local erngstate `e(rngstate)'
	ereturn hidden local erng = `"`e(rng)'"'

	tempname curest ltemp
	qui estimates store `curest' 

	ereturn clear
	ereturn post

	ereturn hidden local chains = `"`chains'"'

	ereturn local rngstate = `"`erngstate'"'
	forvalues i = 1/`nchains' {
		ereturn local rngstate`i' = `"`erngstate`i''"'
	}
	ereturn hidden local rng = `"`erng'"'

	forvalues i = 1/`nchains' {
		mata: st_local("`ltemp'", `mcmcobject'.get_rngstate(`i'))
		ereturn local predrngstate`i' = `"``ltemp''"'
	}
	mata: st_local("`ltemp'", `mcmcobject'.get_currng())
	ereturn hidden local predrng = `"``ltemp''"'

	// update BAYESPR_predynames to only saved once
	mata: st_local("predynames", `mcmcobject'.savedPredictNames())
	global BAYESPR_predynames `predynames'

	mata: st_local("predfnames", `mcmcobject'.predictStatNames())
	global BAYESPR_predstats `predfnames'

	mata: `mcmcobject'.predict_save_eresult()
	
	ereturn local mcmcfile  = `"`mcmcfile'"' 

	global BAYESPR_predfile `predfile'
	ereturn local predfile = `"`predfile'"'

	ereturn local est_cmdline = `"`bayescmdline'"'
	ereturn local cmdline = `"bayespredict `cmdline'"' 
	ereturn local est_cmd = "bayesmh" 
	ereturn local cmd     = "bayespredict" 
	
	if `reportnote' {
		local replacenote 0
		if ("`replace'"=="") {
			cap confirm new file `"`estfile'"'
			if _rc == 602 {
				qui estimates restore `curest'
				exit 602
			}
		}
		else {
			cap confirm new file `"`estfile'"'
			if _rc==0 {
				local replacenote 1
			}
		}

		di as txt _c
		_bayesmh_saving_notes `replacenote' `"`estfile'"'
	}

	qui estimates save `"`estfile'"', replace
	qui estimates restore `curest'
end

program _bayespredict_estrestore, sclass

	args using mcmcobject

	tempname curest
	local estrestore 0
	cap estimates store `curest' 
	if !_rc {
		local estrestore 1
	}
	
	local estfile `using'
	_bayespredict_estname estfile : `"`estfile'"'

	cap estimates use `"`estfile'"'
	local rc = _rc
	if `rc' {
		di as err `"estimation results {bf:`estfile'} not found"'
		// don't error if it doesn't exist
		if `estrestore' {
			qui estimates restore `curest'
		}
		exit `rc'
	}

	local ysimvars
	local ysimlist
	local predstatnames

	if `"`e(cmd)'"' != `"bayespredict"' {
		di as err "last estimates not found"
		if `estrestore' {
			qui estimates restore `curest'
		}
		exit 301
	}
	local predfile `e(predfile)'
	if regexm(`"`predfile'"', ".dta$") {
		local predest = regexr(`"`predfile'"', ".dta$", ".ster")
	}
	else {
		local predest = `"`predfile'.ster"'
	}
	if regexm(`"`estfile'"', `"`predest'.ster"') {
		local predfile = regexr(`"`estfile'"', `"`predest'.ster"', `"`predfile'"')
	}
	else if regexm(`"`estfile'"', `"`predest'"') {
		local predfile = regexr(`"`estfile'"', `"`predest'"', `"`predfile'"')
	}

	global BAYESPR_predfile `predfile'

	cap confirm file `"`predfile'"'
	if _rc == 601 {
		di as err "prediction dataset {bf:`predfile'} not found"
		if `estrestore' {
			qui estimates restore `curest'
		}
		exit 601
	}

	if `"`mcmcobject'"' != "" {
		cap mata: `mcmcobject'
		if !_rc {
			mata: `mcmcobject'.predict_read_eresult()
		}
	}

	local ysimvars `e(depvars)'
	local i 0
	foreach tok of local ysimvars {
		local i = `i' + 1
		local ysimlist `ysimlist' _ysim`i'
	}
	global BAYESPR_ysimvars `ysimvars'

	local yvarlist `e(depvars)'
	local i = 0
	while `"`yvarlist'"' != "" {
		local i = `i' + 1
		gettoken yvar yvarlist : yvarlist
		global BAYESPR_ysim`i'  `yvar'
		global BAYESPR_resid`i' `yvar'
		global BAYESPR_mu`i'    `yvar'
		if `"`e(_ysim`i'_obs)'"' != "" {
			global BAYESPR_ysim`i'_obs  = `"`e(_ysim`i'_obs)'"'
			global BAYESPR_resid`i'_obs = `"`e(_ysim`i'_obs)'"'
			global BAYESPR_mu`i'_obs    = `"`e(_ysim`i'_obs)'"'
		}
	}
	global BAYESPR_predynames `e(predynames)'

	local predfnames `e(predfnames)'
	global BAYESPR_predstats `predfnames'

	sreturn clear

	sreturn local savedOutcomes    = `"`e(savedOutcomes)'"'
	sreturn local savedIndOutcomes = `"`e(savedIndOutcomes)'"'

	sreturn local predfile     = `"`predfile'"'
	sreturn local ysimlist     = `"`ysimlist'"'
	sreturn local ysimvars     = `"`ysimvars'"'
	sreturn local predynames   = `"`e(predynames)'"'
	sreturn local predyvars    = `"`e(predyvars)'"'
	sreturn local predfnames   = `"`e(predfnames)'"'
	sreturn local nchains      = `"`e(nchains)'"'
	sreturn local chains       = `"`e(chains)'"'
	sreturn local mcmcsize     = `"`e(mcmcsize)'"'
	sreturn local N            = `"`e(N)'"'

	if `estrestore' {
		qui estimates restore `curest'
	}
end

program _save_summstat
	args mcmcobject type newvar varlist matsumm matind
	qui gen `type' `newvar' = .
	mata: st_store(	///
		`mcmcobject'.get_predict_yvar_touse_colvec(`"`varlist'"'), ///
		`"`newvar'"', st_matrix("`matsumm'")[,`matind'])
end

program _bayespredict_save_summstat

	tempname matsumm

	syntax [anything] [using], MCMCOBJECT(string) predfile(string) [	///
	type(string) mean(string) std(string) median(string)			///
	mcse(string) crilow(string) crihigh(string) 				///
	outcome(string) outcomevars(string) * ]
	
	local repopts `options'
	
	local neq : list sizeof outcome

	if `"`median'`mcse'`crilow'`crihigh'"' != "" {
		local newvars `median'`mcse'
		local newvarsl `crilow'
		local newvarsh `crihigh'
		local isstub  = `:list sizeof newvars' < `neq'
		local isstubl = `:list sizeof newvarsl' < `neq'
		local isstubh = `:list sizeof newvarsh' < `neq'
		
		local outvarlist `outcomevars'
		foreach eq of local outcome {
			gettoken otcomevar outvarlist : outvarlist

			//_bayespredict_parse {_ysim`eq'}
			//local varlist `"`s(varlist)'"'			
			local yvar BAYESPR_ysim`eq'
			local varlist $`yvar'

			cap _bayesstats summary {_ysim`eq'} `using', ///
				mcmcobject(`mcmcobject') `repopts'
			if _rc {
				exit _rc
			}
			mat `matsumm' = r(summary)
			if `"`median'"' != "" {
				if `"`newvars'"' != "" {
					gettoken stub newvars : newvars
					local newvar `stub'
				}
				if `isstub' {
					local newvar `stub'`eq'
				}
				local matind 4
				_save_summstat `mcmcobject' `type' `newvar' ///
					`"`varlist'"' `matsumm' `matind'
				label variable `newvar' "Posterior median for `otcomevar'"
			}
			
			if `"`mcse'"' != "" {
				if `"`newvars'"' != "" {
					gettoken stub newvars : newvars
					local newvar `stub'
				}
				if `isstub' {
					local newvar `stub'`eq'
				}
				local matind 3
				_save_summstat `mcmcobject' `type' `newvar' ///
					`"`varlist'"' `matsumm' `matind'
				label variable `newvar' "MCMC standard error for `otcomevar'"
			}
			
			if `"`crilow'"' != "" {
				if `"`newvarsl'"' != "" {
					gettoken stubl newvarsl : newvarsl
					local newvar `stubl'
				}
				if `isstubl' {
					local newvar `stubl'`eq'
				}
				local matind 5
				_save_summstat `mcmcobject' `type' `newvar' ///
					`"`varlist'"' `matsumm' `matind'
				label variable `newvar' "CrI lower bound for `otcomevar'"
			}
				
			if `"`crihigh'"' != "" {
				if `"`newvarsh'"' != "" {
					gettoken stubh newvarsh : newvarsh
					local newvar `stubh'
				}
				if `isstubh' {
					local newvar `stubh'`eq'
				}
				local matind 6
				_save_summstat `mcmcobject' `type' `newvar' ///
					`"`varlist'"' `matsumm' `matind'
				label variable `newvar' "CrI upper bound for `otcomevar'"
			}
		}
	}

	local outvarlist `outcomevars'
	
	if `"`mean'"' != "" {
		local isstub = `:list sizeof mean' < `neq'
		foreach eq of local outcome {
			gettoken otcomevar outvarlist : outvarlist

			if `"`mean'"' != "" {
				gettoken stub mean : mean
				local newvar `stub'
			}
			if `isstub' {
				local newvar `stub'`eq'
			}
			qui gen `type' `newvar' = .

			_bayespredict_parse `"_ysim`eq'"'

			mata: st_store( ///
			`mcmcobject'.get_predict_yvar_touse_colvec(`"`s(varlist)'"'), ///
			`"`newvar'"', `mcmcobject'.predictMean(`"`s(predobs)'"')')
			
			label variable `newvar' "Posterior mean for `otcomevar'"
		}
	}

	if `"`std'"' != "" {
		local isstub = `:list sizeof std' < `neq'
		foreach eq of local outcome {
			gettoken otcomevar outvarlist : outvarlist

			if `"`std'"' != "" {
				gettoken stub std : std
				local newvar `stub'
			}
			if `isstub' {
				local newvar `stub'`eq'
			}
			qui gen `type' `newvar' = .

			_bayespredict_parse `"_ysim`eq'"'

			mata: st_store( ///
			`mcmcobject'.get_predict_yvar_touse_colvec(`"`s(varlist)'"'), ///
			`"`newvar'"', `mcmcobject'.predictStd(`"`s(predobs)'"')')
			
			label variable `newvar' "Posterior standard deviation for `otcomevar'"
		}
	}
end

program _bayesreps_check_names
	args replnames nreps
	cap confirm num `nreps'
	if _rc {
		exit
	}
	local isstub = `:list sizeof replnames' < `nreps' & `nreps' > 1
	forvalues i = 1/`nreps' {
		if `"`replnames'"' != "" {
			gettoken stub replnames : replnames
			local newvar `stub'
		}
		if `isstub' {
			local newvar `stub'`i'
		}
		cap confirm var `newvar'
		if !_rc {
			di as err `"variable {bf:`newvar'} already defined"'
			exit 198
		}
	}
end

mata:

string scalar strOfTouseObservations(string scalar tousevar) {
	real scalar n1, n2
	real colvector vtouse
	string scalar str
	vtouse = st_data(., tousevar)
	str = ""
	n1 = 0
	n2 = 1
	while (n2 < length(vtouse)) {
		n1 = n2
		while (n1 < length(vtouse) & vtouse[n1] == 0) n1 = n1 + 1
		if (vtouse[n1] == 0) return(str)
		n2 = n1
		while (n2 < length(vtouse) & vtouse[n2] != 0) n2 = n2 + 1
		if (n2 == length(vtouse) & vtouse[n2] != 0) n2 = n2 + 1
		if (n2 > n1+1) str = sprintf("%s %g/%g", str, n1, n2-1)
		else str = sprintf("%s %g", str, n1)
	}
	return(str)
}
end

program _bayespredict_check_estfile

	args predfile

	gettoken name tok : predfile, parse(".")
	local estfile `name'.ster
	cap confirm new file `"`estfile'"'
	if _rc == 602 {
		cap confirm file `"`predfile'"'
		if !_rc {
			exit
		}
		tempname curest
		qui estimates store `curest' 
		estimates use `"`estfile'"'
di as err `"{bf:saving()}: estimation file {bf:`estfile'} exists"'
		if `"`e(cmd)'"' == `"bayespredict"' {
di as err `"{p 4 4 2}In addition to saving prediction results in {bf:`predfile'}, "'	///
`"{helpb bayespredict} also saves auxiliary estimation results in "'			///
`"{bf:`estfile'}. It appears that {bf:`estfile'} was previously created by "'		///
`"{bf:bayespredict}. You can remove this file or "'					///
"specify suboption {bf:replace} within {bf:bayespredict}'s {bf:saving()} "		///
`"option, {bf:saving(`name', replace)}.{p_end}"'
		}
		else {
di as err `"{p 4 4 2}In addition to saving prediction results in {bf:`predfile'}, "'	///
`"{helpb bayespredict} also saves auxiliary estimation results in "'			///
`"{bf:`estfile'}. If you no longer need this file, you can remove it or "'		///
"specify suboption {bf:replace} within {bf:bayespredict}'s {bf:saving()} "		///
`"option, {bf:saving(`name', replace)}.{p_end}"'
		}
		qui estimates restore `curest'
		exit 602
	}
end

program _something_required_error
	di as err "something is required"
di as err "{p 4 4 2}To compute Bayesian predictions, you must specify "		///
"simulated outcomes or their functions and option {bf: saving()}. "		///
"To compute posterior summaries of simulated outcomes, you must specify "	///
"one or more new variable names and one of options "				///
"{bf:mean}, {bf:median}, {bf:std}, or {bf:cri}. See {helpb bayespredict}.{p_end}"
	exit 321
end
