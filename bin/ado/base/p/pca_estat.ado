*! version 1.0.2  20jan2015 
program pca_estat, rclass
	version 9

	if "`e(cmd)'" != "pca" {
		error 301
	}

	return clear
	gettoken key args : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == "anti" {
		AntiImage `args'
	}
	else if `"`key'"' == "kmo" {
		KMO `args'
	}
	else if `"`key'"' == bsubstr("loadings",1,max(3,`lkey')) {
		Loadings `args'
	}
	else if `"`key'"' == bsubstr("residuals",1,max(3,`lkey')) {
		Residual `args'
	}
	else if `"`key'"' == "rotateclear" {
		// undocumented
		_rotate_clear `args'
	}
	else if `"`key'"' == bsubstr("rotatecompare",1,max(3,`lkey')) {
		Rotated `args'
	}
	else if `"`key'"' == "smc" {
		SMC `args'
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) { 
		// override default handler
		Summarize `args'
	}
	else {
		estat_default `0'
	}
	return add
end


program Loadings, rclass
	syntax [, CNorm(str) FORmat(str) ]

	if e(f) == 0 { 
		dis as err "no components retained"
		exit 198
	}	
	
	if `"`cnorm'"' == "" {
		local cnorm unit
	}
	else {
		local 0 , `cnorm'
		syntax [, Unit Eigen Inveigen ]
		local cnorm `unit' `eigen' `inveigen'
		if `:list sizeof norm' != 1 {
			opts_exclusive "`norm'" norm
		}
	}
	
	if `"`format'"' == "" { 
		local format %8.4g
	}
	else {
		local junk : display `format' 0.5
	}	

	tempname DEv Ev L
	matrix `L'  = e(L)    // eigvecs
	matrix `Ev' = e(Ev)   // eigvals

	local m = e(f)
	matrix coleq `Ev' = _
	matrix `DEv' = diag(`Ev'[1,1..`m'])

	// compare U/V/W normalization of principal components
	// in e.g. Jackson (1991)
	
	if "`cnorm'" == "unit" {
		local tnorm "sum of squares(column) = 1"
	}
	else if "`cnorm'" == "eigen" {
		forvalues i = 1/`m' {
			matrix `DEv'[`i',`i'] = sqrt(`DEv'[`i',`i'])
		}
		matrix `L' = `L' * `DEv'
		local tnorm "sum of squares(column) = eigenvalue"
	}
	else if "`cnorm'" == "inveigen" {
		forvalues i = 1/`m' {
			matrix `DEv'[`i',`i'] = 1/sqrt(`DEv'[`i',`i'])
		}
		matrix `L' = `L' * `DEv'
		local tnorm "sum of squares(column) = 1/eigenvalue"
	}
	else {
		_stata_internalerror
	}

	dis _n as txt "Principal component loadings " _c 
	if "`e(r_criterion)'" == "" { 
		dis as txt "(unrotated)"
	}
	else 	display
	dis _col(5) as txt "component normalization: `tnorm'"
	
	matlist `L' , border(row) format(`format') left(4) nohalf
		
	return local  norm `cnorm' 
	return matrix A  = `L' 	
end


program Residual, rclass
	syntax [, Obs Fitted FORmat(passthru) ]

	if e(f) == 0 { 
		dis as err "no retained components" 
		exit 198
	}

	tempname D Fit Obs Res
	
	matrix `D'   = e(Ev)                // eigenvals
	matrix `D'   = `D'[1,1..`e(f)']
	matrix `Fit' = e(L) * diag(`D') * e(L)'
	matrix `Fit' = (`Fit'+`Fit'')/2
	matrix `Obs' = e(C)
	matrix `Res' = `Obs' - `Fit'
	
	local mopt `format' left(4) tind(0) border(row) row(Variable)

	if "`obs'" != "" {
		matlist `Obs', title(Observed `e(Ctype)' matrix) `mopt'
	}
	if "`fitted'" != "" {
		matlist `Fit', title(Fitted `e(Ctype)' matrix) `mopt'
	}
	matlist `Res', title(Residual `e(Ctype)' matrix) `mopt'

	return matrix residual = `Res'
	return matrix fit      = `Fit'
end


program Rotated
	syntax [, FORmat(passthru) ]
	
	factor_pca_rotated , name(component) `format' 
end	


// overrule default handler to pass correct varlist
program Summarize, rclass
	syntax [, VARlist(str) *]

	if `"`varlist'"' != "" {
		dis as err "option varlist() invalid"
		exit 198
	}

	if "`e(matrixname)'" != "" {
		dis as txt "sample information not available after pcamat"
		error 321
	}

	tempname C
	matrix `C' = e(C)
	local vlist : colnames `C'
	
	estat_summ `vlist', `options' 
	
	if "`e(Ctype)'" == "correlation" { 
		dis as txt "(PCA of correlation matrix, " ///
		           "i.e., based on standardized variables)"
	}	
	
	return add
end


// squared multiple correlations
program SMC, rclass
	corr_smc e(C) `0'
	return add
end


// anti-image correlation = minus - partial correlation
// anti-image covariance  = minus - partial covariances
program AntiImage, rclass
	corr_anti e(C) `0'
	return add
end


// Kaiser-Meyer-Olkin measure of sampling adequacy
program KMO, rclass
	corr_kmo e(C) `0'
	return add
end


// utility commands ----------------------------------------------------------

program GetCorr
	args C

	matrix `C' = e(C)
	if "`e(Ctype)'" == "correlation" {
		matrix `C' = corr(`C')
	}
end
exit
