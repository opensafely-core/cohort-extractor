*! version 1.0.0  22feb2005
program factor_rotate, eclass
	version 9

	if "`e(cmd)'" != "factor" {
		dis as err "factor estimation results not found"
		error 301
	}
	if e(f) == 0 { 
		dis as err "no factors retained"
		exit 321
	}	

	local k = e(f)
	syntax [,                                               /// 
		DETail                                          /// 
		Factors(   numlist integer max=1 >=1 <=`k')     ///  
		COMponents(numlist integer max=1 >=1 <=`k')     /// 
		BLanks(passthru)				///
		ALTDIVisor					///
		*                                               /// 
	]
	local rotatemat_opts `options' `blanks'

	if "`factors'" != "" & "`components'" != "" { 
		dis as err "factors() and components() are synonyms"
		exit 198
	}
	else if "`components'" != "" { 
		local factors `components' 
	}

	local k = e(f) 	
	if `"`factors'"' != "" {
		confirm integer number `factors' 
		local k = min(`k',clip(`factors',1,`k'))
	}
	
// extract factor loadings

	tempname L r_Ev r_L r_Phi r_T r_fmin
	
	matrix `L' = e(L)
	local fnames : colnames `L' 
	
	if `k' < e(f) { 
		tempname LL L0
		
		// split L into free and fixed factors
		matrix `L0' = `L'[1...,`=`k'+1'...]
		matrix `LL' = `L'[1...,1..`k']
	}
	else { 
		local LL `L' 
	}
	
// rotate

	if "`detail'" == "" {
		local display nodisplay
	}
	
	rotatemat `LL' , `rotatemat_opts' `display' ///
	   matname(Factor loadings) colnames(factors)

	local r_class         `r(class)' 
	local r_criterion     `r(criterion)' 
	local r_ctitle        `r(ctitle)' 
	local r_normalization `r(normalization)'
	
	// return e(r_L), e(r_T) so that e(r_L) = e(L)*inv(e(T)'
	// 
	// Note that e(L) e(Phi) e(L)' = e(r_L) e(r_Phi) e(r_L)' 

	scalar `r_fmin' = r(f)	
	matrix `r_L'    = r(AT)  // rotated factors
	matrix `r_T'    = r(T)   // rotation matrix
	
	// add fixed factors
	if `k' < e(f) { 
		local fk = e(f) - `k' 
		matrix `r_L' = `r_L',`L0' 
		matrix `r_T' = (    `r_T'      , J(`k',`fk',0) \ ///
		                 J(`fk',`k',0) ,    I(`fk')    ) 
	}
	
	matrix `r_Phi'  = `r_T'' * `r_T' 
	matrix `r_Phi'  = 0.5*(`r_Phi' + `r_Phi'')    /// symmetrize
	
	// explained variance = sum of squared correlations between
	//   variables and common factors
	
	matrix `r_Ev' = vecdiag(`r_Phi' * (`r_L'' * `r_L') * `r_Phi')
	
// sort factors in decreasing order of r_Ev 

	tempname P R_Ev R_L R_Phi R_T 
	
	local nEv = e(f)
	forvalues i = 1/`nEv' {
		local rEvlist `rEvlist' `=`r_Ev'[1,`i']'
	}
	
	_qsort_index "`rEvlist'" \ "*" , desc
	local order `r(order)' 
	
	matrix `P' = J(`nEv',`nEv',0)
	forvalues i = 1/`nEv' {
		matrix `P'[`:word `i' of `order'', `i'] = 1
	}
	matrix rownames `P' = `fnames'
	matrix colnames `P' = `fnames'
	
	matrix `R_L'   = `r_L'  * `P' 
	matrix `R_Ev'  = `r_Ev' * `P' 
	matrix `R_T'   = `P'' * `r_T' * `P'
	matrix `R_Phi' = `R_T''*`R_T'
	matrix `R_Phi' = 0.5*(`R_Phi' + `R_Phi'')    // symmetrize

// store results in e() with prefix r_

	ereturn local r_ctitle         `"`r_ctitle'"'
	ereturn local r_criterion      `"`r_criterion'"'
       	ereturn local r_class          `"`r_class'"'
       	ereturn local r_normalization  `"`r_normalization'"' 
	if `r_fmin' != . {
		ereturn scalar r_fmin = `r_fmin' 
	}
	ereturn scalar r_f = e(f)
		
		                       // return e(r_L) = e(L)*inv(e(r_T)') 
	ereturn matrix r_L   = `R_L'   // rotated factors
	ereturn matrix r_T   = `R_T'   // rotation matrix
	ereturn matrix r_Phi = `R_Phi' // correlation matrix of common factors
	
	ereturn matrix r_Ev  = `R_Ev'  // sum of squared rotated corr 
	
	_returnclear

// display using factor-replay

	if ("`detail'" != "") {
		display
	}
	factor , `blanks' `altdivisor'
end
exit
