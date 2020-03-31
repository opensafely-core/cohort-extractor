*! version 1.0.2  31mar2014
program sem_estat_eqtest, rclass
	version 12
	
	if "`e(cmd)'" != "sem" { 
		error 301
	}	

	local is_svy = "`e(prefix)'" == "svy"
	local adj 0
	local DDF "*"
	local dfr 0
	if `is_svy' {
		if !missing(e(df_r)) {
			local adj 1
			local dfr = e(df_r)
			local DDF DDF
		}
	}

	syntax [, 		///
		TOTal 		///
		noSVYadjust	///
		]

	if !`is_svy' & "`svyadjust'" != "" {
		di as err "option nosvyadjust is allowed only with svy data"
		exit 198
	}

	if `adj' {
		local adj = "`svyadjust'" == ""
	}

	local ng = `e(N_groups)'	
	if (e(k_ly) + e(k_oy) == 0) {
		di as txt "(model has no endogenous variables)"
		exit 
	}
	if (e(k_lx) + e(k_ox) == 0) {
		di as txt "(model has no exogenous variables)"
		exit 
	}
	if (`ng' == 1) & ("`total'" != "") {
		dis as err "option total only allowed with multiple groups"
		exit 198
	}
	local fmt format(%8.2f %3.0f %8.4f)	

	tempname nobs
	matrix `nobs' = e(nobs)

	// display tests
	if `adj' {
		di _n as txt "Adjusted Wald tests for equations"
	}
	else {
		di _n as txt "Wald tests for equations"
	}
	 
	forvalues g = 1/`ng' { 
		sem_groupheader `g', nohline
		tempname test_`g'
		mata: st_sem_estat_eqwald(`g', `dfr', `adj', "`test_`g''")
		_matrix_table `test_`g'', `fmt'
		`DDF'
	}
	
	if "`total'" != "" { 
		sem_groupheader 0, nohline
		tempname test
		mata: st_sem_estat_eqwald(0, `dfr', `adj', "`test'")
		_matrix_table `test', `fmt'
		`DDF'
	}
	
	// return results
      	return scalar N_groups = `ng'
	return matrix nobs = `nobs'
	forvalues g = 1/`ng' { 
		local gg = cond(`ng'>1, "_`g'", "")
		return matrix test`gg' = `test_`g''
	}	
	if "`total'" != "" {
		return matrix test_total = `test'
	}
	if `dfr' {
		return scalar df_r = `dfr'
	}
end

program DDF
	di as txt %12s "Design" as res %17.0f e(df_r)
end

exit
