*! version 1.0.7  04sep2018

program bayes_parse_params, sclass
	version 15.0

	// create a _c_mcmc_model object
	mata: getfree_mata_object_name("mcmcobject", "_model")
	mata: `mcmcobject' = _c_mcmc_model()

	local cmdline `"`0'"'
	gettoken prefix : 0, parse("\ :,")
	if `"`prefix'"' == "bayes" {
		gettoken prefix 0 : 0, parse("\ :,")
	}

	// preserve previous estimation results
	tempname tmodel
	capture _estimates hold `tmodel'
	capture noisily _bayes_prefix build `mcmcobject' `0'
	local rc = _rc
	capture _estimates unhold `tmodel'
	if `rc' {
		sreturn local error `rc'
		_bayesmh_clear `mcmcobject'
		// clean up $MCMC_moptobjs
		local toklist $MCMC_moptobjs
		global MCMC_moptobjs
		gettoken tok toklist : toklist
		while `"`tok'"' != "" {
			capture mata: Mopt_moptobj_cleanup(`tok')
			gettoken tok toklist : toklist
		}
		exit `rc'
	}

	local mcmcobject `s(mcmcobject)'

	// save list of equation names
	local eqnames  `s(eqnames)'
	local fveqlist `s(fveqlist)'
	local reparams `s(reparams)'
	local defpriors `s(defpriors)'
	local nchains  `s(nchains)'

	local list `s(reparlist)'
	local reeqlist
	foreach tok of local list {
		local reeqlist `reeqlist' {`tok':}
	}

	sreturn clear

	sreturn local error 0

	local n_defpriors 0
	gettoken tok defpriors: defpriors, bind
	while `"`tok'"' != "" {
		local `n_defpriors++'
		sreturn local defprior`n_defpriors' `tok'
		gettoken tok defpriors: defpriors, bind
	}
	sreturn local n_defpriors = `n_defpriors'
	
	// build the model
	mata: `mcmcobject'.build_factors(NULL, NULL, 1)

	// export parameters of interest
	mata: `mcmcobject'.parse_equations_sreport()

	local allparams `s(params)'
	local reparams `s(reparams)'

	// place re-params after fixed-params
	local allparams: list allparams - reparams
	local allparams `allparams' `reparams'
	sreturn local params = `"`allparams'"'

	local equndefined
	foreach tok of local eqnames {
		tokenize `"`tok'"', parse("}")
		if regexm(`"`s(defined)'"', `"^`1'"') == 0 {
			local equndefined `equndefined' `tok'
		}
	}

	local bayes_equndefined `equndefined'
	if `"`reparams'"' != "" {
		local undefined `s(undefined)'
		local pardiff : list reparams - undefined
		if `"`pardiff'"' != `"`reparams'"' {
			local undefined : list undefined - reparams
			local equndefined `equndefined' `reeqlist'
			sreturn local undefined `undefined'
		}
		sreturn local reparams `reparams'
	}

	local noreparams `allparams'
	local noreparams : list noreparams - reparams
	sreturn local noreparams `noreparams'

	// export list of equation names {eqname:}
	if `"`fveqlist'"' != "" {
		local eqnames `eqnames' `fveqlist'
	}
	if `"`reeqlist'"' != "" {
		local eqnames `eqnames' `reeqlist'
	}
	local eqnames : list eqnames - allparams
	sreturn local eqnames `eqnames'
	
	sreturn local equndefined `equndefined'
	sreturn local bayes_equndefined `bayes_equndefined'

	local exclude
	if `"`cmdline'"' == `"`e(cmdline)'"' {
		local exclude `e(exclude)'
	}
	local postparams `allparams'
	if `"`exclude'"' != "" {
		local postparams : list postparams - exclude
	}
	sreturn local postparams `postparams'

	sreturn local nchains  `nchains'
	
	////////////////////////////////////////////////////////////////////////

	_bayesmh_clear `mcmcobject'

	// clean up $MCMC_moptobjs
	local toklist $MCMC_moptobjs
	global MCMC_moptobjs
	gettoken tok toklist : toklist
	while `"`tok'"' != "" {
		capture mata: Mopt_moptobj_cleanup(`tok')
		gettoken tok toklist : toklist
	}
	
	exit `rc'
end

