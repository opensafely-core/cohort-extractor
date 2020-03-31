*! version 1.1.0  11apr2017
program sem_estat_mindices, rclass
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}

	local prefix "`e(prefix)'"
	if "`prefix'" != "" {
		di as err ///
"modification indices not allowed with `e(prefix)' results"
		exit 322
	}
	local vce "`e(vce)'"
	if !inlist("`vce'", "eim", "oim", "cluster", "robust") {
		di as err ///
"modification indices not allowed with vce(`e(vce)') results"
		exit 322
	}
	if inlist("`vce'", "cluster", "robust") {
		checkestimationsample
	}

	syntax [,	SHOWPclass(string) 		///
			MINchi2(numlist max=1 >=0) 	///
			SLOW				/// NODOC
	]

	if "`minchi2'" == "" {
		local minchi2 = invchi2(1, .95)
	}

	sem_parse_pclass `"`showpclass'"' showpclass
	local pclass `s(pclass)'
	if "`pclass'" == "" {
		di as txt "(nothing to do)"
		exit
	}

	local slow : list sizeof slow

	if `"`e(mindices)'"' == "" {
		if `slow' {
			mata: st_sem_estat_mindices_slow()
		}
		else {
			mata: st_sem_estat_mindices_build()
		}
	}

	// Set the following local macros and matrices
	// 	MODS	-- matrix of MI, pvalue, and EPC values
	// 	pcMODS	-- pclass row vector for MODS
	// 	CNS	-- matrix of chi2 tests for the constraints
	// 	selCNS	-- indicates constraints selected to report

	mata: st_sem_estat_mindices_select(`minchi2', "`pclass'")

	if "`MODS'" != "" {
		di
		di as txt "Modification indices"
		di
		local fmt format(%9.3f %5.0f %5.2f)
		_matrix_table `MODS',			///
				cmdextras		///
				pclassmatrix(`pcMODS')	///
				puttab			///
				`fmt'
		di as txt "EPC = expected parameter change"
		return add

		return matrix mindices `MODS'
		return matrix mindices_pclass `pcMODS'
	}
	else {
		di as txt ///
"(no modification indices to report, all MI values less than `minchi2')"
	}

	tempname nobs
	matrix `nobs' = e(nobs)
	return matrix nobs = `nobs'
	return scalar N_groups = e(N_groups)
end

exit
