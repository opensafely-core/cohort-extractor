*! version 1.0.3  11mar2019
program _bayespredict_maxvar_err
	args nparms

	local diparams for a subset of parameters
	local extrapars 4
	
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
    	di as err "You are trying to predict "  %9.0gc `nparms' 
	di as err "`=plural(`nparms',"parameter")'. 
	if (`nparms'+`extrapars'<=`maxmaxvar') {
		di as err "You should {helpb set maxvar}"
		di as err "to at least " %9.0gc `=`nparms'+`extrapars''
		di as err "by typing {bind:{bf:set maxvar `=`nparms'+`extrapars''}}."
	}
	else {
		di as err "The limit for the total number of parameters"
		di as err "that can be saved in a prediction file in"
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
	}
	di as err "{p_end}"
	exit 103
end
