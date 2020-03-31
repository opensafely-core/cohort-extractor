*! version 1.1.7  04sep2018
program bayesmh_parse_params, sclass
	version 14
	
	// trim white space
	local 0 `0'

	local cmdline `"`0'"'
	// create a _c_mcmc_model object
	mata: getfree_mata_object_name("mcmcobject", "g_mcmc_model")
	mata: `mcmcobject' = _c_mcmc_model()
	global MCMC_debug  0
	global MCMC_genvars ""

	local 1 `"`0'"'
	gettoken next 1 : 1, parse(",") bind
	if `"`0'"' != "," & `"`1'"' == "" {
		local 0 `0',
	}

	capture noisily _bayesmh_import_model `0' ///
		mcmcobject(`mcmcobject') parseonly
	local rc = _rc
	if `rc' != 0 {
		global MCMC_debug ""
		capture mata: mata drop `mcmcobject'
		exit `rc'
	}

	// save list of equation names
	local eqnames  `s(eqnames)'
	local fveqlist `s(fveqlist)'
	local reparams `s(reparams)'
	local reeqlist `s(relablist)'
	local xbdeflabs $MCMC_xbdeflabs
	local nchains  `s(nchains)'

	sreturn clear 

	// build the model
	mata: `mcmcobject'.build_factors(NULL, NULL, 1)

	// export parameters of interest
	mata: `mcmcobject'.parse_equations_sreport()

	local allparams `s(params)'

	local equndefined
	local toklist `eqnames'
	gettoken tok toklist : toklist
	while `"`tok'"' != "" {
		tokenize `"`tok'"', parse("}")
		if regexm(`"`s(defined)'"', `"`1'"') == 0 {
			local equndefined `equndefined' `tok'
		}
		gettoken tok toklist : toklist
	}

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

	sreturn local regroups `reeqlist'

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
	
	exit `rc'
end

