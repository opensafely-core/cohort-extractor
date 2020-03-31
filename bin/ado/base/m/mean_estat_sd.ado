*! version 1.0.0  17may2018
program mean_estat_sd, rclass
	version 16
	syntax [,			///
		VARiance		///
		SRSsubpop		///
		noLegend		///
		VERBose			///
	]

	if !inlist("`e(cmd)'", "", "mean") {
		exit
	}
	if `"`e(poststrata)'"' != "" {
		exit
	}
	if `"`e(stdize)'"' != "" {
		exit
	}
	if `"`e(V)'"' != "matrix" {
		exit
	}

	if "`srssubpop'" != "" {
		if `"`e(subpop)'`e(over)'"' == "" {
			di as err ///
"option srssubpop requires subpopulation estimation results"
			exit 322
		}
	}

	tempname mean vpop sdpop
	matrix `mean' = e(b)
	matrix `vpop' = e(b)
	matrix `sdpop' = e(b)
	local cols = colsof(`mean')
	if !inlist("`e(prefix)'", "", "svy") {
		di as err "estat sd is not allow after `e(prefix)' estimation"
		exit 322
	}
	local nobs _N
	if "`e(prefix)'" == "" {
		if "`e(wtype)'" == "pweight" | "`e(cluster)'" != "" {
			local vsrs V_srs
		}
		else	local vsrs V
		if inlist("`e(wtype)'", "iweight", "fweight") {
			local nobs _N_subp
		}
	}
	else if "`e(fpc1)'" == "" {
		if "`srssubpop'" == "" {
			local vsrs V_srs
		}
		else	local vsrs V_srssub
	}
	else {
		if "`srssubpop'" == "" {
			local vsrs V_srswr
		}
		else	local vsrs V_srssubwr
	}
	if "`e(`vsrs')'" != "matrix" {
		di as err "variance estimates not found"
		error 301
	}
	forval i = 1/`cols' {
		matrix `vpop'[1,`i'] = el(e(`nobs'),1,`i')*el(e(`vsrs'),`i',`i')
		matrix `sdpop'[1,`i'] = sqrt(`vpop'[1,`i'])
	}

	if "`variance'" == "" {
		local colopts c(`sdpop' "Std. Dev.")
	}
	else	local colopts c(`vpop' "Variance")

	if c(noisily) & "`e(cmd)'" != "" {
		svy_estat DisplayTable sd, ///
			`colopts' `legend' `verbose' sd `colopts'
	}
	// saved results
	return local srssubpop	`"`srssubpop'"'
	return matrix mean	`mean'
	return matrix variance	`vpop'
	return matrix sd	`sdpop'
end

exit
