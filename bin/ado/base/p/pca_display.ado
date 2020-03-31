*! version 1.1.0  12jan2015
program pca_display
	version 9

	if has_eprop(V) {
		pca_display_NormalSE `0'
	}
	else {
		pca_display_Std `0'
	}
end

// ================================================================== normal SE

program pca_display_NormalSE
	#del ;
	syntax [,
		Blanks(numlist max=1 >=0)
		LEVel(cilevel)
		noROTated
		MEans
		noVCE
	] ;
	#del cr

	if "`vce'" != "" { 
		pca_display_Std `0' 
		exit
	}
	else if "`e(r_criterion)'" != "" & "`rotated'" == "" {  
		dis as txt "(display with SEs of unrotated results)"
	}

// header

	dis _n      as txt `"`e(title)'/`e(Ctype)'"'  ///
	   _col(50) as txt "Number of obs    = "  as res %10.0fc e(N)

	dis _col(50) as txt "Number of comp.  = " as res %10.0f e(f)
	if !inlist("`e(trace)'", ".", "") {
		dis as txt _col(50) "Trace            =  " /// 
		     as res %9.0g e(trace)
	}
	dis _col(50) as txt "Rho              = " /// 
	             as res %10.4f e(rho)
	
	dis          as txt "SEs assume multivariate normality" ///
	    _col(50) as txt "SE(Rho)          = " /// 
	             as res %10.4f sqrt(e(v_rho))
	dis

// coef table

	ereturn display, level(`level')

// footer with tests

	#del ;
	dis as txt "LR test for independence:"
	    _col(33) "chi2(" as res e(df_i) as txt ")"
	    _col(43) "= " as res %10.2f e(chi2_i)
	    _col(58) as txt "Prob > chi2 = " as res %7.4f e(p_i) ;

	dis as txt "LR test for   sphericity: "
	    _col(33) "chi2(" as res e(df_s) as txt ")"
	    _col(43) "= " as res %10.2f e(chi2_s)
	    _col(58) as txt "Prob > chi2 = " as res %7.4f e(p_s) ;
	#del cr

// explained variance

	tempname bias ELC
	matrix `bias' = e(Ev_bias)
	matrix `ELC'  = e(Ev_stats)

	dis as txt _n "Explained variance by components"
	dis as txt _n "  Components {c |} Eigenvalue  Proportion " ///
	              " SE_Prop  Cumulative   SE_Cum       Bias"
	dis as txt "{hline 13}{c +}{hline 64}"

	forvalues i = 1 / `=rowsof(`ELC')' {
		#del ;
		dis as txt "{ralign 12:Comp`i'  } {c |}"
		    as res _col(17) %9.0g  `ELC'[`i',1]
		           _col(30) %8.4f  `ELC'[`i',2]
		           _col(39) %8.4f  sqrt(`ELC'[`i',3])
		           _col(51) %8.4f  `ELC'[`i',4]
		           _col(60) %8.4f  sqrt(`ELC'[`i',5])
		           _col(71) %8.0g  `bias'[1,`i'] ;
		#del cr
	}
	dis as txt "{hline 13}{c BT}{hline 64}"

	if "`means'" != "" {
		Means
	}
end

// ======================================================================== std

program pca_display_Std
	#del ;
	syntax [,
		Blanks(numlist max=1 >=0)
		LEVel(str)
		noROTated
		MEans
		noVCE
	];
	#del cr

	local ortho = 1		
	local Evtxt "Eigenvalue"		
	local rprefix
	if "`rotated'" != "" {
		if "`e(r_criterion)'" == "" {
			dis as err "rotated pca results not found"
			exit 301
		}
		local ttxt "Unrotated principal components (eigenvectors)" 	
		local rtxt "Rotation: (unrotated = principal)"
	}
	else {
		if "`e(r_criterion)'" != "" {
			_rotate_text 
			local rtxt "Rotation:`r(rtext)'"
			local ttxt "Rotated components" 
			local rprefix  r_
			local Evtxt "  Variance"
			local ortho = ("`e(r_class)'" == "orthogonal") 
		}
		else {
			local ttxt "Principal components (eigenvectors)" 
			local rtxt "Rotation: (unrotated = principal)"
		}
	}

	tempname csum Ev L Lj rho Psi

	matrix `Ev'   = e(`rprefix'Ev)  // Explained Variance / eigvals
	matrix `L'    = e(`rprefix'L)   // loadings / eigvecs
	matrix `Psi'  = e(Psi)          // unexplained variance of vars
	scalar `rho'  = e(rho)          // %expl variance by retained comp
	local nEv     = colsof(`Ev')	
	local Cname   = cond("`e(Ctype)'"=="correlation","corr","cov")
	
	local nvar    = rowsof(`L')
	local nf      = colsof(`L')
	local varlist : rownames `L'

// header

	dis _n       as txt `"`e(title)'/`e(Ctype)'"' ///
	    _col(50) as txt "Number of obs    = " as res %10.0fc  e(N)
	dis _col(50) as txt "Number of comp.  = " as res %10.0f  e(f)
	dis _col(50) as txt "Trace            " ///
   	    _col(67) "=  " as res %9.0g  e(trace)
	dis _col( 5) as txt "`rtxt'" ///
	    _col(50) as txt "Rho              = " as res %10.4f  `rho'
	dis
	
// eigenvalues / explained variances

	if `ortho' { 
		scalar `csum'  = 0
		dis as txt _col(5) "{hline 13}{c TT}{hline 60}"
		dis as txt _col(5) "   Component {c |}   `Evtxt'   " ///
		    "Difference         Proportion   Cumulative"
		dis as txt _col(5) "{hline 13}{c +}{hline 60}"
		
		forvalues j = 1 / `nEv' {
			scalar `Lj' = `Ev'[1,`j']
			#del ;
			dis as txt _col(5) "{ralign 12:Comp`j'} {c |}"
			    as res " " %12.6g `Lj'
			    as res " " %12.6g `Lj'-`Ev'[1,`j'+1]
			    _skip(6)
			    as res " " %12.4f `Lj'/`e(trace)' 
			    as res " " %12.4f (`csum'+`Lj')/`e(trace)' ; 
			#del cr
			scalar `csum' = `csum' + `Lj'
		}
		
		dis as txt _col(5) "{hline 13}{c BT}{hline 60}"
	}
	else {
		dis as txt _col(5) "{hline 13}{c TT}{hline 60}"
		dis as txt _col(5) ///
		    "   Component {c |}     Variance   Proportion   " ///
		    "  Rotated comp. are correlated"
		dis as txt _col(5) "{hline 13}{c +}{hline 60}"
		
		forvalues j = 1 / `nEv' {
			scalar `Lj' = `Ev'[1,`j']
			#del ;
			dis _col(5) as txt "{ralign 12:Comp`j'} {c |}"
			    as res " " %12.6g `Ev'[1,`j']
			    as res " " %12.4f `Lj'/`e(trace)' ;
			#del cr
		}
		dis as txt _col(5) "{hline 13}{c BT}{hline 60}"
	}
	
// display components

	if e(f) > 0 { 
		if "`blanks'" != "" {
			_small2dotz `L' `blanks'
			local btxt " (blanks are abs(loading)<{res:`blanks'})"
		}
		matrix `L' = `L' , `Psi''
	
		forvalues i = 1/`nf' {
			if (`i'>1) local csp `csp' &
			local csp `csp' %8.4f
		}
		forvalues j = 2/`nvar' {
			local hsp `hsp'&
		}

		dis as txt _n "`ttxt' `btxt'"
		matlist `L', row(Variable) nodotz ///
		   cspec(o4& %12s | `csp' | C %11.4g o1&) /// 
		   rsp(--`hsp'-)
	}
	
// rotation 

	if "`rprefix'" != "" { 
		dis _n as txt "Component rotation matrix"
		matlist e(r_T) , format(%8.4f) border(row) left(4)
	}

// summary statistics

	if "`means'" != "" {
		Means
	}
end


program Means
	tempname C
	matrix `C' = e(C)
	local varlist : colnames `C'
	capture confirm numeric variable `varlist'
	if _rc {
		dis as txt "(impossible to display summary statistics)"
		exit
	}

	dis as txt _n "Summary statistics of the variables"
	estat_summ `varlist', noheader
end
exit
