*! version 7.3.0  03feb2015
program corr2data
	version 8.2

	query sortseed
	local sortseed = r(sortseed)
	local currseed = c(seed)
	capture noisily  Make `0'
	set seed `currseed'
	set sortseed `sortseed'
	if _rc {
		exit _rc
	}
end


program Make
	gettoken first 0: 0, parse(",")
	#del ;
	syntax [,
		n(string)
		CORR(string)
		COV(string)
		CStorage(string)
		Means(string)
		SDs(string)
		SEED(int 0)
		Double
		CLEAR
		FORCEPSD
		TOL(passthru) // undocumented
	] ;
	#del cr

	if `"`n'"' != "" {
		confirm integer n `n'
		if `n' == _N {
			local n
		}
	}
	if "`n'" == "" {	/* add newvarlist to existing dataset */
		local nobs = _N
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

	if `nobs' <= `k' {
		dis as err "number of observations should exceed number of variables"
		exit 2001
	}

	
	tempname C D L M P S T
	
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

		tempname Cmatrix
		matrix `Cmatrix' = `C'

		local rows = rowsof(`"`Cmatrix'"')
		local cols = colsof(`"`Cmatrix'"')

		if `rows' != `cols' | `rows' != `k' | `cols' != `k' {
			di as err "{p}" ///
			"matrix is not conformable with the number of " ///
			"variables requested:  rows and columns must " ///
			"equal the number of specified variables{p_end}"
			exit 503
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
	if `"`means'"' != "" {
		_m2matrix `M' means `k' "`means'"
	}
	else {
		matrix `M' = J(1,`k', 0)
	}
							/* S = stds */
	if "`sds'" != "" {
		if "`cov'" != "" {
			dis as err "cov() and sds() may not be specified together"
			exit 198
		}
		_m2matrix `S' sds `k' "`sds'"
	}
	else {
		matrix `S' = J(1,`k',1)
	}

						/* generate new variables */
	set seed0 `seed'
	foreach var of local varlist {
		qui gen `double' `var' = invnorm(uniform0())
		qui sum `var'
		qui replace `var' = `var' - r(mean)
	}

					/* reform them to be zero corr */
	qui mat accum `T' = `varlist', noc dev
	mat `T' = `T'/(`nobs'-1)
	mat `T' = cholesky(syminv(`T'))
	forvalues i = 1 / `k' {
		tempname new`i' row
		mat `row' = (`T'[1..., `i'])'
		mat score `new`i'' = `row'
	}

	tokenize `varlist'
	forvalues i = 1 / `k' {
		qui replace ``i'' = `new`i''
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
		dis as txt  "(obs `nobs')"
	}
end
