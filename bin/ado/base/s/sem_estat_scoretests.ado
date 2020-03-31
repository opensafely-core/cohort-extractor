*! version 1.0.0  26may2011
program sem_estat_scoretests, rclass
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}

	local vce "`e(vce)'"
	if !inlist("`vce'", "eim", "oim", "cluster", "robust") {
		di as err ///
"score tests not allowed with vce(`e(vce)') results"
		exit 322
	}
	if inlist("`vce'", "cluster", "robust") {
		checkestimationsample
	}

	syntax [, MINchi2(numlist max=1 >=0) SLOW]

	if "`e(Cns)'" == "" {
		di as txt "(no linear constraints to test)"
		tempname nobs
		matrix `nobs' = e(nobs)
		return matrix nobs = `nobs'
		return scalar N_groups = e(N_groups)
		exit
	}

	local slow : list sizeof slow

	if "`minchi2'" == "" {
		local minchi2 = invchi2(1, .95)
	}

	if `"`e(Cns_sctest)'"' == "" {
		if `slow' {
			mata: st_sem_estat_scoretests_slow()
		}
		else {
			mata: st_sem_estat_scoretests_build()
		}
	}

	// Set the following local macros and matrices
	// 	CNS	-- matrix of chi2 tests for the constraints
	// 	selCNS	-- indicates constraints selected to report

	mata: st_sem_estat_scoretests_select(`minchi2')

	if "`CNS'" != "" {
		di
		di as txt "Score tests for linear constraints"
		di
		mata: st_sem_estat_cnsreport("`selCNS'")
		_matrix_table `CNS', format(%9.3f %5.0f %5.2f)
		return matrix Cns_sctest `CNS'
		return hidden matrix Cns_select `selCNS'
	}
	else {
		di as txt ///
"(no score tests to report; all chi2 values less than `minchi2')"
	}

	tempname nobs
	matrix `nobs' = e(nobs)
	matrix rownames `nobs' = "N"
	return matrix nobs = `nobs'
	return scalar N_groups = e(N_groups)
end

exit
