*! version 7.3.0  03feb2015
program define drawnorm
	local xeqversion : di "version " string(_caller()) ":"
	version 8.2
	local version _caller()

	gettoken first 0: 0, parse(",")
	#del;
	syntax [,
		n(string)
		SEED(string)
		Double
		CORR(string)
		COV(string)
		CStorage(string)
		Means(string)
		SDs(string)
		CLEAR
		FORCEPSD
		TOL(passthru) // undocumented
	] ;
	#del cr

	quietly count
	local curn = r(N)
	if `"`n'"' != "" {
		confirm integer n `n'
		if `n' == `curn' {
			local n
		}
	}
	if `"`n'"' == "" {	/* add newvarlist to existing dataset */
		local nobs = r(N)
		if `nobs' <= 0 {
			error 2000
		}
		if "`clear'" != "" {
			drop _all
			qui set obs `nobs'
			local n `nobs'
		}
	}
	else {			/* generate new dataset */
		if `n' <= 0 {
			error 2000
		}
		qui count
		if `n' != r(N) {
			qui des, short
			if r(changed) & ("`clear'" == "" ) {
				error 4
			}
			drop _all
		}
		local nobs = `n'
		qui set obs `nobs'
	}

	local 0 "`first'"
	syntax newvarlist
	local k : word count `varlist'

	if "`seed'" != "" {
		`xeqversion' set seed `seed'
	}


	tempname C D L M P S
	
	if "`cov'" != "" | "`corr'" != "" { 
		if "`cov'" != "" & "`corr'" != "" {
			dis as err "cov() and corr() " ///
			    "may not be specified together"
			exit 198
		}
		
		if `"`corr'"' != "" {
			_m2matrix `C' corr `k' "`corr'" "`cstorage'"
			local Cname `corr' 
		}
		else {
			_m2matrix `C' cov  `k' "`cov'"  "`cstorage'"		
			local Cname `cov' 
		}
	
		_checkpd `C', matname(`Cname') check(psd) `forcepsd' `tol'  

		if r(npos)==`k' {
			// C is positive definite; 
			// for backward compatibility: use Cholesky root 
			matrix `P' = cholesky(`C')
		}
		else {
			// in the singular case, we use eigen decomposition
			// already available from _checkpd
			matrix `L' = r(L)
			matrix `D' = r(Ev) 
			forvalues i = 1/`k' {
				matrix `D'[1,`i'] = sqrt(max(0,`D'[1,`i']))
			}
			matrix `P' = `L'*diag(`D') 
		}
	}
	else {
		matrix `P' = I(`k')
	}	
	
							/* M = means */
	if "`means'" != "" {
		_m2matrix `M' means `k' "`means'"
	}
	else {
		matrix `M' = J(1,`k', 0)
	}
							/* S = stds */
	if `"`sds'"' != "" {
		if `"`cov'"' != "" {
			dis as err "cov() and sds() may not be specified together"
			exit 198
		}
		_m2matrix `S' sds `k' "`sds'"
	}
	else {
		matrix `S' = J(1,`k',1)
	}

						/* generate new variables */
	tokenize `varlist'
	local newlist `varlist'
	foreach var of local newlist {
		if `version' <= 10 {
			qui gen `double' `var' = invnormal(uniform())
		}
		else {
			qui gen `double' `var' = rnormal()
		}
	}
					/* transform to desired corr */
	mat roweq `P' = " "
	mat coleq `P' = " "	/* remove possible equation names from P */
	mat rownames `P' = `varlist'
	mat colnames `P' = `varlist'
	forvalues i = 1 / `k' {
		tempname new`i' row
		mat `row' = `P'[`i', 1...]
		mat score `new`i'' = `row'
	}

				/* transform to desired means and std */
	tokenize `varlist'
	forvalues i = 1 / `k' {
		qui replace ``i'' = `new`i'' * `S'[1,`i'] + `M'[1,`i']
	}

	if "`n'" != "" {
		local nobs = string(`nobs',"%12.0fc")
		dis as txt "(obs `nobs')"
	}
end
