*! version 1.0.2  18mar2019

program bayesreps, eclass
	version 16.0
	local vv : di "version " string(_caller()) ", missing :"
	
	_parse comma lhs rhs : 0, bindcurly
	if (`"`rhs'"'=="") {
		local rhs , 
	}

	if (`"`e(cmd)'"' != "bayesmh") {
		di as err "last estimates not found"
		exit 301
	}
	
	_bayesmh_check_saved bayesmh "" bayesreps
	
	if (`"`e(filename)'"'=="") {
		di as err "simulation results not found"
		exit 301
	}
	cap confirm number `e(predvar_n)'
	if _rc {
		di as err "prediction variables not found"
		exit 301
	}
	if `e(predvar_n)' < 1 {
		di as err "prediction variables not found"
		exit 301
	}
	
	// other bayesstats subcommands require an mcmc object
	mata: getfree_mata_object_name("mcmcobject", "__g_mcmc_model")

	local 0 `rhs'
	syntax , [nreps(string) *]
	if `"`nreps'"' == "" {
di as err "number of replicates must be specified using {bf:nreps()} option"
		exit 198
	}

	`vv' cap noi _bayespredict simulate `lhs' `rhs' mcmcobject(`mcmcobject')
	local rc = _rc

	// clean up
	_bayesmh_clear `mcmcobject'

	exit `rc'
end
