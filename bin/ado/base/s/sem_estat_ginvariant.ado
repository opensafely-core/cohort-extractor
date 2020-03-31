*! version 1.0.2  29jun2011
program sem_estat_ginvariant, rclass
	version 12

	if "`e(cmd)'"!="sem" {
		error 301
	}

	local prefix "`e(prefix)'"
	if "`prefix'" != "" {
		di as err ///
"estat ginvariant not allowed with `e(prefix)' results"
		exit 322
	}
	local vce "`e(vce)'"
	if !inlist("`vce'", "eim", "oim", "cluster", "robust") {
		di as err ///
"estat ginvariant not allowed with vce(`e(vce)') results"
		exit 322
	}

	syntax [, 	SHOWPclass(string) 	///
			CLAss 			///
			LEGend			///
			SLOW			/// NODOC
	]

	local showlg : list sizeof legend
	local showclass : list sizeof class
	local slow : list sizeof slow
	sem_parse_pclass `"`showpclass'"' showpclass
	local pclass `s(pclass)'

	local ng = `e(N_groups)'

	if `ng'==1 {
		dis as txt "(nothing to do in case of a single group)"
		exit
	}
	if "`pclass'" == "none" {
		dis as txt "(nothing to do)"
		exit
	}
	if `showlg' & !`showclass' {
		di as err ///
		"class must be specified if legend is specified"
		exit 198
	}

	// Set the following local macros and matrices
	// GINV	-- matrix of Wald chi2, df, pvalue and Score chi2, df, pvalue
	// GINV_class -- matrix of test results for classes (9x6)
	// pcGINV -- pclass row vector for GINV

	mata: st_sem_estat_ginvariant("`pclass'", `showclass', `slow')

	local fmt format(%9.3f %3.0f %8.4f %9.3f %3.0f %8.4f)
	if "`GINV'" != "" {
		di
		di as txt "Tests for group invariance of parameters"
		di
		_matrix_table `GINV',			///
				cmdextras		///
				pclassmatrix(`pcGINV')	///
				`fmt'
		return matrix test `GINV'
		return matrix test_pclass `pcGINV'
		if "`GINV_class'" != "" {
			di
			di as txt "Joint tests for each parameter class"
			di
			_matrix_table `GINV_class', `fmt'
			return matrix test_class `GINV_class'
			if `showlg' {
				Display_Legend, pclass(`pclass')
			}
		}
	}
	else {
		di as txt "(no tests to report)"
	}

	tempname nobs
	matrix `nobs' = e(nobs)
	return scalar N_groups = `ng'
	return matrix nobs = `nobs'
end

program Display_Legend
	syntax [, PCLASS(string)]

	local scoef 	"Structural coefficients"
	local scons 	"Structural intercepts"
	local mcoef 	"Measurement coefficients"
	local mcons 	"Measurement intercepts"
	local serrvar 	"Covariances of structural errors"
	local merrvar 	"Covariances of measurement errors"
	local smerrcov 	"Covariances of structural and measurement errors"
	local meanex 	"Means of exogenous variables"
	local covex 	"Covariances of exogenous variables"

	foreach pc of local pclass {
		di as txt %12s "`pc'" _col(14) "{c |} ``pc''"
	}
end

exit
