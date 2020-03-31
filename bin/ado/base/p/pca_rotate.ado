*! version 1.0.2  02feb2012
program pca_rotate, eclass
	version 8

	if "`e(cmd)'" != "pca" {
		dis as err "pca estimation results not found"
		error 301
	}
	if e(f) == 0 { 
		dis as err "no components retained"
		exit 321
	}	

	local k = e(f)
	syntax 	[,                                              ///
		DETail                                          ///
		Factors(numlist integer max=1 >=1 <=`k')        ///
		COMponents(numlist integer max=1 >=1 <=`k')     ///
		BLanks(passthru)				///
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
	
	if "`factors'" != "" { 
		local k = min(`k',`factors')
	}	

// extract factor loadings

	tempname L r_Ev r_L r_T r_fmin 
	tempname R_Ev R_L R_T  

	matrix `L'  = e(L) 
		
	if `k' < e(f) { 
		tempname LL L0
		
		// omit fixed components
		
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
	
	rotatemat `LL', `rotatemat_opts' `display' ///
	   matname(Component loadings) colnames(components)
	   
	local r_class         `r(class)' 
	local r_criterion     `r(criterion)' 
	local r_ctitle        `r(ctitle)' 
	local r_normalization `r(normalization)' 
	
	scalar `r_fmin' = r(f) 
       	matrix `r_L'    = r(AT) // rotated components
	matrix `r_T'    = r(T)  // rotation matrix

	// add fixed components
	if `k' < e(f) { 
		local fk = e(f) - `k' 
		matrix `r_L' = `r_L',`L0' 
		matrix `r_T' = (    `r_T'      , J(`k',`fk',0) \ ///
		                 J(`fk',`k',0) ,    I(`fk')    ) 
	}
	
	// variance of rotated components
	matrix `r_Ev' = vecdiag(`r_L'' * e(C) * `r_L') 

// sort components in decreasing order of 
//
//    r_EV = explained variance by the rotated components
//
// this is not unproblematic with correlated components after oblique
// rotations, resembling the problem of defining "importance" of
// an X in a regression model with correlated x variables. 
//
// we store the solution (r_L,r_T,r_Ev) sorted by importance in R_L,R_T,R_Ev

	local cnams : colnames `r_Ev'

	local nEv = e(f)
	forvalues i = 1/`nEv' {
		local rEvlist `rEvlist' `=`r_Ev'[1,`i']'
	}
	
	_qsort_index "`rEvlist'" \ "*" , desc
	local order `r(order)' 
	
	foreach i of local order {
		matrix `R_Ev' = nullmat(`R_Ev') , `r_Ev'[1,`i']
		matrix `R_L'  = nullmat(`R_L')  , `r_L'[1...,`i']
	}
	// the reordering above has scrambled our column names
	// reset them to Comp1 ...
	matrix colnames `R_Ev' = `cnams'
	matrix colnames `R_L'  = `cnams'

	matrix `R_T' = syminv(`L''*`L')*(`L''*`R_L')

		
// store rotation results in e() in r_*

	ereturn local r_class          `"`r_class'"'
	ereturn local r_criterion      `"`r_criterion'"'
	ereturn local r_ctitle         `"`r_ctitle'"'
	ereturn local r_normalization  `"`r_normalization'"'       	
	
	if `r_fmin' != . {
		ereturn scalar r_fmin = `r_fmin' 
	}
	ereturn scalar r_f  = e(f)
	                               // return: e(R_L) = e(L) * inv(e(R_T)')
	ereturn matrix r_L  = `R_L'    // rotated comp (no longer eigvecs)
	ereturn matrix r_T  = `R_T'    // rotation matrix
	
	// Note that e(Ev) are the eigenvalues of e(C), and are the 
	// variances of the principal components if normed to 1
	//
	// By abuse of notation, we return in e(r_Ev) the variances of 
	// the rotated principal components. These are of course not
	// equal to the eigenvalues, 
	
	ereturn matrix r_Ev = `R_Ev'   
	
	_returnclear

// display via pca-replay

	if ("`detail'" != "") {
		display
	}
	
	pca_display, novce `blanks'
end
exit
