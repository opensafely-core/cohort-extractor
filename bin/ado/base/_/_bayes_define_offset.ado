*! version 1.0.0  18mar2019

program _bayes_define_offset, sclass

	args ylabel offset exposure respec gtouse

	local noshow
	if "`exposure'" != "" {
		capture confirm name exposure_`exposure'
		if _rc == 0 {
			_mcmc_definename exposure_`exposure'
			local expvar `s(define)'
		}
		else {
			_mcmc_definename `ylabel'
			local expvar `s(define)'
			local noshow `noshow' `expvar'
		}

		quietly generate double `expvar' = ln(`exposure') if `gtouse'
		// MCMC_xbdeflabs is used for assigning parameters to a
		// specific label, in this case `label'
		global MCMC_xbdeflabs $MCMC_xbdeflabs `ylabel'
		global MCMC_xbdefvars $MCMC_xbdefvars `expvar'
		global MCMC_genvars $MCMC_genvars `expvar'
		// assume offset == ""
		local offset `expvar'
	}

	_mcmc_definename `ylabel'
	local tmpvar `s(define)'
	global MCMC_xbdeflabs $MCMC_xbdeflabs `ylabel'
	global MCMC_xbdefvars $MCMC_xbdefvars `tmpvar'
	global MCMC_genvars $MCMC_genvars `tmpvar'

	if "`offset'" != "" {
		quietly generate double `tmpvar' = `offset' if `gtouse'
		if `"`respec'"' != "" {
			// remove `offset' from output
			local noshow `noshow' `offset'
		}
	}
	else {
		quietly generate double `tmpvar' = 0 if `gtouse'
	}

	sreturn clear
	sreturn local offset = `"`offset'"'
	sreturn local tmpvar = `"`tmpvar'"'
	sreturn local noshow = `"`noshow'"'
end