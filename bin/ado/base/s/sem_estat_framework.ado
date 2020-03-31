*! version 1.0.1  26may2011
program sem_estat_framework, rclass
	version 12

	if "`e(cmd)'"!="sem" {
		error 301
	}

	syntax [, 		///
		STANDardized 	///
		COMpact 	///
		FITted 		///
		FORmat(string) 	///
		]

	local stand = `:length local standardized' > 0
	if `stand' {
		local std "(standardized)"
	}
	if "`format'"!="" {
		local junk : display `format' 1
	}
	else {
		local format %9.0g
	}

	local haslatent = "`e(lyvars)'`e(lxvars)'"!=""
	local nx = `e(k_ox)' + `e(k_lx)'

	if !`haslatent' {
		dis as txt "(model contains no latent variables)"
	}
	else {
		local ltxt " and latent"
	}

	if `nx'==0 {
		dis as txt "(model contains no exogenous variables)"
	}

	local ng = e(N_groups)
	tempname nobs
	matrix `nobs' = e(nobs)

	forvalues g = 1/`ng' {
		// the following Mata function generates the following named
		// matrices, storing their name in the corresponding local
		// macro name:
		// 	Beta_`g'
		// 	Gamma_`g'
		// 	Psi_`g'
		// 	Phi_`g'
		// 	alpha_`g'
		// 	kappa_`g'
		// 	Sigma_`g'
		// 	mu_`g'

		mata: st_sem_estat_framework(`stand', `g')

		sem_groupheader `g', noafter

		Framework_matlist 		///
			`Beta_`g''  		///
			"Beta"  		///
			"`format'" 		///
			"`compact'" 		///
		    "Endogenous variables on endogenous variables `std'"

		Framework_matlist 		///
			`Gamma_`g'' 		///
			"Gamma" 		///
			"`format'" 		///
			"`compact'" 		///
		    "Exogenous variables on endogenous variables `std'"

		Framework_matlist 		///
			`Psi_`g''   		///
			"Psi"   		///
			"`format'" 		///
			"`compact'" 		///
			"Covariances of error variables `std'"

		if "`e(modelmeans)'"=="1" {
			Framework_matlist 	///
				`alpha_`g'' 	///
				"alpha" 	///
				"`format'" 	///
				"`compact'" 	///
				"Intercepts of endogenous variables `std'"
		}

		Framework_matlist 		///
			`Phi_`g''   		///
			"Phi"   		///
			"`format'" 		///
			"`compact'" 		///
			"Covariances of exogenous variables `std'"

		if "`e(modelmeans)'"=="1" {
			Framework_matlist 	///
				`kappa_`g'' 	///
				"kappa" 	///
				"`format'" 	///
				"`compact'" 	///
				"Means of exogenous variables `std'"
		}

		if "`fitted'"!="" {
			Framework_matlist 	///
				`Sigma_`g'' 	///
				"Sigma" 	///
				"`format'" 	///
				"`compact'" 	///
			"Fitted covariances of observed`ltxt' variables `std'"

			if "`e(modelmeans)'"=="1" {
				Framework_matlist 	///
					`mu_`g'' 	///
					"mu" 		///
					"`format'" 	///
					"`compact'" 	///
			 "Fitted means of observed`ltxt' variables `std'"
			}
		}
	}

	return clear
	return scalar N_groups = `ng'
	return scalar standardized = `stand'
	return matrix nobs = `nobs'
	forvalues g = 1/`ng' {
		local gg = cond(`ng'>1, "_`g'", "")

		if "`Beta_`g''" != "" {
			return matrix Beta`gg'  = `Beta_`g''
		}
		if "`Gamma_`g''" != "" & `nx'!=0 {
			return matrix Gamma`gg' = `Gamma_`g''
		}
		if "`Psi_`g''" != "" {
			return matrix Psi`gg'   = `Psi_`g''
		}
		if "`Phi_`g''" != "" {
			return matrix Phi`gg'   = `Phi_`g''
		}
		if "`e(modelmeans)'"=="1" {
			if "`alpha_`g''" != "" {
				return matrix alpha`gg' = `alpha_`g''
			}
			if "`kappa_`g''" != "" {
				return matrix kappa`gg' = `kappa_`g''
			}
		}

		return matrix Sigma`gg' = `Sigma_`g''
		if "`e(modelmeans)'"=="1" {
			return matrix mu`gg'    = `mu_`g''
		}
	}
end

program Framework_matlist
	args M name fmt compact title

	capture confirm matrix `M'
	if _rc {
		exit
	}

	local nr = rowsof(`M')
	local nc = colsof(`M')
	if ("`compact'"!="") & (`nr'>1 | `nc'>1) {
		tempname J
		matrix `J' = J(`nr',`nc',0)
		if mreldif(`M',`J') < 1e-10 {
			dis as txt _n "`title'" _n
			dis as txt "    `name' = `nr' x `nc' matrix of 0's"
			exit
		}
		if (`nr'==`nc') {
			matrix `J' = diag(vecdiag(`M'))
			if mreldif(`M',`J') < 1e-10 {
				matrix `J' = vecdiag(`M')
				matrix rownames `J' = diagonal
				local M `J'
				local title ///
				   `"`title'; diagonal only, off-diagonal=0"'
			}
		}
	}

	local ceq colorcoleq(res)

	matlist `M', rowtitle(`name') left(4) border(bot) ///
		format(`fmt') title("`title'") `ceq'
end

exit
