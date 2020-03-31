*! version 1.2.8  25feb2019
program bayesstats
	version 14.0
	local vv : di "version " string(_caller()) ", missing :"

	_parse comma lhs rhs : 0, bindcurly
	if (`"`rhs'"'=="") {
		local rhs , 
	}
	gettoken subcmd lhs : lhs

	local 0 , `subcmd'
	syntax [, SUMMary ESS IC GRubin PPVALues* ]
	local subcmd `summary'`ess'`ic'`grubin'`ppvalues'
	if ("`options'"!="") {
		di as err `"subcommand {bf:`options'} is not "' ///
			"supported by {bf:bayesstats}"
		exit 198
	}
	if ("`subcmd'"=="") {
		di as err "{bf:bayesstats} requires subcommand " ///
			"{bf:summary}, {bf:ess}, or {bf:ic}"
		exit 198
	}
	
	// call to _bayesstats_ic
	if ("`subcmd'"=="ic") {
		// paramref check
		_mcmc_expand_paramlist `"`lhs'"'
		_bayesstats_`subcmd' `lhs' `rhs'
		exit
	}

	// other bayesstats subcommands require an mcmc object
	mata: getfree_mata_object_name("mcmcobject", "__g_mcmc_model")

	if ("`subcmd'"=="ppvalues") {
		cap noi ///
		_bayesstats_ppvalues `lhs' `rhs' mcmcobject(`mcmcobject')
	}
	else {	
		if (`"`e(cmd)'"' != "bayesmh" & `"`e(prefix)'"' != "bayes") {
			if `"`e(cmd)'"' != "bayespredict" {
				di as err "last estimates not found"
				exit 301
			}
		}
		else {
			if (`"`e(filename)'"'=="") {
				di as err "simulation results not found"
				exit 301
			}

			// load parameters sorted by eqnames in global macros 
			// to be used by _mcmc_fv_decode in _mcmc_expand_paramlist
			_bayesmh_eqlablist import

			// paramref check
			_mcmc_expand_paramlist `"`lhs'"'
		}

		`vv' cap noi ///
		_bayesstats `subcmd' `lhs' `rhs' mcmcobject(`mcmcobject')
	}

	local rc = _rc

	// clean up
	_bayesmh_clear `mcmcobject'

	exit `rc'
end
