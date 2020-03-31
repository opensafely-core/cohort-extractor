*! version 1.0.2  06apr2017
program _bayesmh_maxvar_err
	args nmparms nreparms

	local extrapars 6
	local is_re = ("`nreparms'"!="")
	if `is_re' {
		local nparms = `nmparms' + `nreparms'
		local multilevel " multilevel"
		local extra1 " and `: di %9.0gc `nreparms''"
		local extra1 "`extra1' random effects for a total of"
		local extra1 "`extra1' `: di %9.0gc `nparms''"
		local extra1 "`extra1' estimated parameters"
		local diparams for all or for a subset of random effects
	}
	else {
		local nparms = `nmparms'
		local diparams for a subset of parameters
	}
	// MP maxvar limit
	local mpmaxmaxvar = 120000
	// SE maxvar limit
	local semaxmaxvar = 32767
	// maximum number of variables stored by postfile in MP and SE
	local maxnparms = `mpmaxmaxvar'-`extrapars'
	local semaxnparms = `semaxmaxvar'-`extrapars'
	// flavor-specific limit of maxvar
	local maxmaxvar = (c(max_macrolen) - 200)/(c(namelenbyte) + 1)
	// currently set maxvar value
	local maxvar = c(maxvar)

	if (`nparms'+`extrapars'<=`maxvar') exit

	if (`nparms'<`maxmaxvar') {
		di as err ///
"{p}current {bf:set maxvar} setting of {bf:`maxvar'} is too low{p_end}"
	}
	else {	
		di as err ///
"{p}too many MCMC estimates to save in a simulation file{p_end}"
	}
	di as err "{p 4 4 2}"
    	di as err "You are trying to fit a Bayesian`multilevel' model"
	di as err "containing "  %9.0gc `nmparms' 
	di as err "model `=plural(`nmparms',"parameter")'`extra1'.  By default,"
	di as err "{help bayesian_estimation:Bayesian estimation commands} save"
	di as err "the MCMC estimates for all parameters in a simulation file."
	if (`nparms'+`extrapars'<=`maxmaxvar') {
		di as err "If you want to save MCMC estimates for all"
		di as err "parameters, you should {helpb set maxvar}"
		di as err "to at least " %9.0gc `=`nparms'+`extrapars''
		di as err "by typing {bind:{bf:set maxvar `=`nparms'+`extrapars''}}."
		di as err "Or, consider specifying"
	}
	else {
		di as err "The limit for the total number of parameters"
		di as err "that can be saved in a simulation file in"
		di as err "Stata/`c(flavor_real)' is" 
		di as err %9.0gc `=`maxmaxvar'-`extrapars'' "."

		if ("`c(flavor_real)'"!="MP") {
			if ("`c(flavor_real)'"=="IC" & (`nparms'>`maxnparms')) {
				local extra2 " and {help statase:Stata/SE}"
				local extra2 "`extra2' up to " 
				local extra2 "`extra2' `:di %9.0gc `semaxnparms''"
				local extra2 "`extra2' parameters" 
			}
			else if ("`c(flavor_real)'"=="IC") {
				local extra2 " or {help statase:Stata/SE}"
				local extra2 "`extra2' which allows up to" 
				local extra2 "`extra2' `:di %9.0gc `semaxnparms''"
				local extra2 "`extra2' parameters" 
			}
			if (`nparms'>`maxnparms') {
				di as err "Note that {help statamp:Stata/MP}"
				di as err "allows up to " %9.0gc `maxnparms' 
				di as err ///
				   "parameters to be saved`extra2'.  Specify"
			}
			else {
				di as err ///
				   "Consider using {help statamp:Stata/MP}"
				di as err "which allows up to" 
				di as err %9.0gc `maxnparms' 
				di as err ///
				  "parameters to be saved`extra2'.  Or, specify"
			}
		}
		else {
			di as err "Specify "
		}
	}
	di as err "option {help bayes##options_simulation:exclude()}"
	di as err "to prevent saving of MCMC estimates `diparams'."
	if (`is_re') {
		di as err "{help j_bayes_toomanyre:Click here} for details."
	}
	di as err "{p_end}"
	exit 103
end
