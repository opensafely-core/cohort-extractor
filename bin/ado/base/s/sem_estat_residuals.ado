*! version 1.0.1  29jun2011
program sem_estat_residuals, rclass
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}

	if `e(N_missing)' {
		di as err "multiple missing-value patterns present;"
		di as err "residual calculations cannot be computed"
		exit 322
	}

	syntax [, NORMalized 		///
		  STANDardized		///
		  SAMple		///
		  FORmat(str) 		///
		  NM1			///
		  ZEROtolerance(str)	///
		  ]

	if "`format'"!="" {
		local junk : display `format' 1.2345
		local fmt `format'
	}
	else {
		local fmt %9.3f
	}

	local means  = `e(modelmeans)'
	local norm = `:length local normalized'
	local stand = `:length local standardized'
	local sample = `:length local sample' > 0
	local nm1 = `:length local nm1' > 0

	if "`e(xconditional)'" != "" {
		if `stand' {
			local rc = 0
	   		if "`e(vce)'" != "oim" {
				local rc = 322
				di as err ///
				"standardized residuals not allowed with" ///
				" vce(`e(vce)') and xconditional results;"
			}
			else if !inlist("`e(method)'", "ml", "mlmv") {
				local rc = 322
				di as err ///
				"standardized residuals not allowed with" ///
				" method(`e(method)') and xconditional results;"
			}
			if `rc' {
				di as err ///
			"refit model and specify the noxconditional option"
				exit 322
			}
		}
	}

	local copt left(4) twidth(12) border(bottom) format(`fmt')

	if "`zerotolerance'" != "" {
		capture confirm number `zerotolerance'
		if _rc {
			di as err "invalid value `zerotolerance'" ///
				" for zerotolerance()"
			exit 198
		}
		if `zerotolerance' >= 1 {
			di as err "zerotolerance() must be less than one"
			exit 198
		}
		local zerotol `zerotolerance'
 	}
	else {
		local zerotol 0
	}
	local ng = e(N_groups)
	tempname nobs X
	matrix `nobs' = e(nobs)

	dis as txt _n "Residuals of observed variables"

	// Set the following local macros and matrices
	// res_mean  - raw mean residuals
	// res_cov   - raw covariance residuals
	// nres_mean - normalized mean residuals
	// nres_cov  - normalized covariance residuals
	// sres_mean - standardized mean residuals
	// sres_cov  - standardized covariance residuals

	mata: st_sem_estat_residuals(`sample',`nm1', `stand', `zerotol')

	forvalues g = 1/`ng' {
		local gg = cond(`ng'>1, "_`g'", "")
		sem_groupheader `g', noafter

		if `means' {
			mat `X' = `res_mean`gg''
			if `norm' & "`nres_mean`gg''" != "" {
				mat `X' = `X' \ `nres_mean`gg''
			}
			if `stand' & "`sres_mean`gg''" != "" {
				mat `X' = `X' \ `sres_mean`gg''
			}
			dis _n as txt "  Mean residuals"
			matlist `X' , `copt'
		}

		if "`res_cov`gg''" != "" {
			dis _n as txt "  Covariance residuals"
			matlist `res_cov`gg'', `copt'
		}

		if `norm' & "`nres_cov`gg''" != "" {
			dis _n as txt "  Normalized covariance residuals"
			matlist `nres_cov`gg'', `copt'
		}
		if `stand' & "`sres_cov`gg''" != "" {
			dis _n as txt "  Standardized covariance residuals"
			matlist `sres_cov`gg'', `copt'
		}

	}

	// return in rclass

	return scalar N_groups =   `ng'
	if `sample' {
		return local sample = "sample"
	}
	if `nm1' {
		return local nm1 = "nm1"
	}
	return matrix nobs = `nobs'

	forvalues g = 1/`ng' {
		local gg = cond(`ng'>1, "_`g'", "")

		return matrix res_cov`gg' = `res_cov`gg''
		return matrix nres_cov`gg' = `nres_cov`gg''
		if "`sres_cov`gg''" != "" {
			return matrix sres_cov`gg' = `sres_cov`gg''
		}
		if `means' {
			return matrix res_mean`gg' = `res_mean`gg''
			return matrix nres_mean`gg' = `nres_mean`gg''
			if "`sres_mean`gg''" != "" {
				return matrix sres_mean`gg' = `sres_mean`gg''
			}
		}
	}
end
exit

