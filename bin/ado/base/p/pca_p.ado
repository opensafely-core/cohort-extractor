*! version 1.0.4  15apr2019
program pca_p, rclass
	version 8

	if "`e(cmd)'" != "pca" {
		dis as err "pca estimation results not found"
		exit 301
	}

	if e(f) == 0 { 
		dis as err "no components retained"
		exit 321
	}
	
// check that variables are available for prediction (no abbreviation!)

	local vnames : rownames e(C)
	unab evnames : `vnames' 
	if !`:list evnames == vnames' { 
		dis as err "impossible to predict; variables not found"
		exit 111
	}
	capture noisily confirm numeric variable `vnames'
	if _rc {
		dis as err "impossible to predict"
		dis as err "pca variables no longer numeric"
		exit 111
	}

// parse

	#del ;
	syntax  anything(name=vlist) [if] [in]
	[,
		Fit 
		RESidual 
		SCore 
		Q 
		QStd         // undocumented   
		NORM(str)
		noRotated    // help says: noROTated
		noTABle
		FORmat(str)
		CENter
	] ;
	#del cr

	if "`fit'`residual'`score'`q'`qstd'" == "" {
		dis "{txt}({bf:score} assumed)"
		local score score
	}

	local nf = e(f)                      // #factors
	local npcavar = colsof(e(C))         // #vars in PCA
	if "`score'" != "" {
		local nv `nf'
		local stubstar stubstar
	}
	else if "`fit'`residual'" != "" {
		local nv `npcavar'
		local stubstar stubstar
	}
	if strpos("`vlist'","*") & "`stubstar'" != "" {
		_stubstar2names `vlist', nvars(`nv')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
	}
	else {
		if strpos("`vlist'","*") & "`q'" !="" {
			di as err "one variable expected with option q"
			exit 198
		}
		local myif `if'
		local myin `in'
		local 0 `vlist'
		syntax newvarlist(numeric)
		local if `myif'
		local in `myin'
	}
	local nnewvar : list sizeof varlist  // #generated vars

	local what `fit' `q' `qstd' `residual' `score'
	if `:list sizeof what' > 1 {
		opts_exclusive "`what'" 
	}

	if "`fit'`residual'" != "" & `nnewvar' != `npcavar' {
		dis as err "number of new variables should equal " /// 
		           "number of variables in pca"
		exit =cond(`nnewvar'>`npcavar', 103, 102)
	}
	
	if "`score'" != "" {
		if `nnewvar' > `nf' {
			dis as txt "(extra variables dropped)"
			local nnewvar = `nf'
		}
		else if `nnewvar' < `nf' {
			dis as txt "(`=`nf'-`nnewvar'' components skipped)"
		}
	}
	
	if "`q'" != "" & `nnewvar' != 1 {
		dis as err "one variable expected with option q"
		exit 103
	}
	
	if "`qstd'" != "" & `nnewvar' != 1 {
		dis as err "one variable expected with option qstd"
		exit 103
	}

	if "`rotated'" != "" & "`score'" == "" { 
		local rotated
	}
	
	if "`norm'" != "" { 
		if "`e(r_criterion)'" != "" & "`rotated'" == "" { 
			dis as txt "(norm() implies norotated)" 
			local rotated norotated
		}
		ParseNorm `norm'
		local norm `s(norm)' 
	}
	else {
		local norm unit
	}	

// scoring coefficients //////////////////////////////////////////////////////

	tempname b DEv Ev L means nzero sds P Z
	
	local rprefix = /// 
	      cond("`rotated'"=="" & "`e(r_criterion)'"!="", "r_", "" )
	   
	matrix `L'  = e(`rprefix'L)    // loadings
	matrix `Ev' = e(`rprefix'Ev)   // eigenvalues
	local   f   = e(`rprefix'f)    // number of components 
	
	if "`norm'" == "eigen" { 
		matrix `DEv' = I(`f')
		forvalues i = 1/`f' {
			matrix `DEv'[`i',`i'] = sqrt(`Ev'[1,`i'])
		}
		matrix `L' = `L' * `DEv'
		local normtxt "sum of squares(column-loading) = eigenvalue"
	}
	else if "`norm'" == "inveigen" { 
		matrix `DEv' = I(`f')
		forvalues i = 1/`f' {
			matrix `DEv'[`i',`i'] = 1/sqrt(`Ev'[1,`i'])
		}
		matrix `L' = `L' * `DEv'
		local normtxt "sum of squares(column-loading) = 1/eigenvalue"
	}
	else if inlist("`norm'","unit","") {
		local normtxt "sum of squares(column-loading) = 1"
	}
	else { 
		_stata_internalerror
	}
	
	// L are the component loadings that we use for scoring
	// turn L into the scoring matrix Z and into the projection P 
	//
	// deal with oblique loadings and the non full rank case
	
	matrix `Z' = syminv(`L''*`L')
	scalar `nzero' = diag0cnt(`Z')
	matrix `Z' = `L' * `Z'
	
	// projection matrix
	matrix `P' = `Z' * `L''

	// PCA-variables are exposed via macros 1,2,3,...
	local vnames : rownames `Z'
	tokenize `vnames'

// display scoring coefficients //////////////////////////////////////////////

	if "`score'" != "" &  "`table'" == "" {
	
		if "`e(r_criterion)'" != "" {
			if "`rotated'" == "" { 
				local wh   `e(r_class)' `e(r_ctitle)' 
				local rtxt "for `wh' rotation"
			}
			else { 
				local rtxt "for unrotated results" 
			}	
		}
		
		if `"`format'"' == "" {
			local format %8.4f
		}	
		
		dis _n as txt `"Scoring coefficients `rtxt'"'
		if "`normtxt'" != "" { 
			dis as txt _col(5) "`normtxt'"
		}
		
		matlist `Z', rowtitle(Variable) left(4) /// 
		   border(row) format(`format')
	}

// saved results

	return matrix scoef = `Z', copy 

// extract MEANs and SDs of the variables ////////////////////////////////////

	marksample touse, novarlist

	if "`e(means)'" != "matrix" {
		dis as txt "(means e(means) of variables not available;" /// 
		           " 0 assumed)"
		matrix `means' = J(1,`npcavar',0)
	}
	else {
		matrix `means' = e(means)
	}

	matrix `sds' = J(1,`npcavar',1)
	if "`e(Ctype)'" == "correlation" {
		if "`e(sds)'" == "matrix" {
			matrix `sds' = e(sds)
		}
		else {
			dis as txt "(Standard deviations e(sds) of " /// 
			           "variables not available; 1 assumed)"
		}
	}

// scoring variables /////////////////////////////////////////////////////////

if "`score'" != "" {
	
	if "`e(Ctype)'" == "covariance" & "`center'" == "" {
		matrix `means' = J(1,`=colsof(`means')',0)
	}
		
	tempvar sj
	forvalues j = 1/`nnewvar' {
	
		capture drop `sj'
		quietly gen double `sj' = 0 if `touse'
		forvalues i = 1/`npcavar' {
			quietly replace `sj' = `sj' + ///
			   `Z'[`i',`j'] *             /// 
			   ((``i''-`means'[1,`i'])/`sds'[1,`i']) if `touse'
		}
			
		gettoken vn varlist : varlist
		gettoken tp typlist : typlist
		quietly gen `tp' `vn' = `sj' if `touse'
		label var `vn' "Scores for component `j'"
		
	}
	exit
}

// fitted values/residuals ///////////////////////////////////////////////////

if "`fit'`residual'" != "" {
	
	tempname fj
	forvalues j = 1/`nnewvar' {
	
		// fitted values in transformed units
		capture drop `fj'
		quietly gen double `fj' = 0 if `touse'
		forvalues h = 1/`npcavar' {
			quietly replace `fj' = `fj' + ///
			   `P'[`h',`j'] * /// 
			   ((``h''-`means'[1,`h'])/`sds'[1,`h']) if `touse'
		}

		// transform back to original units
		gettoken tp typlist : typlist
		gettoken vn varlist : varlist
		quietly gen `tp' `vn' = /// 
		   `means'[1,`j'] + `sds'[1,`j']*`fj' if `touse'
			   
		// transform to residuals, if needed; and label 
		local v : word `j' of `vnames'
		if "`residual'" != "" {
			quietly replace `vn' = ``j'' - `vn' if `touse'
			label var `vn' "residual `v'-pca_fit(`nf')"
		}
		else {
			// fitted values
			label var `vn' "pca_fit(`nf') for `v'"
		}
	}
	exit
}

// residual sum-of-squares ///////////////////////////////////////////////////

if "`q'`qstd'" != "" {
	
	tempname fj rss
	quietly gen double `rss' = 0 if `touse'
	forvalues j = 1/`npcavar' {
	
		capture drop `fj'
		quietly gen double `fj' = 0 if `touse'
		forvalues h = 1/`npcavar' {
			quietly replace `fj' = `fj' + ///
			   `P'[`h',`j'] * ///
			   ((``h''-`means'[1,`h'])/`sds'[1,`h']) if `touse'
		}
		
		// rss in transformed units
		quietly replace `rss' = `rss' + ///
		   ((``j''-`means'[1,`j'])/`sds'[1,`j'] - `fj')^2 if `touse'
	}

	// raw rss in transformed units

	if "`q'" != "" {
		quietly gen `typlist' `varlist' = `rss' if `touse'
		label var `varlist' "residual sum of squares"
		exit
	}

	// normalized rss (J Edward Jackson 1991: p36)

	tempname h0 h1 th1 th2 th3
		
	scalar `th1' = 0
	scalar `th2' = 0
	scalar `th3' = 0
	forvalues j = `=`nf'+1'/`npcavar' {
		scalar `th1' = `th1' + `Ev'[1,`j']
		scalar `th2' = `th2' + `Ev'[1,`j']^2
		scalar `th3' = `th3' + `Ev'[1,`j']^3
	}
		
	scalar `h0' = 1 - (2*`th1'*`th3')/(3*`th2'^2)
	scalar `h1' = (`th2'*`h0'*(`h0'-1))/(`th1'^2)
		
	quietly gen `typlist' `varlist' = ///
	   `th1'*((`rss'/`th1')^(`h0')-`h1'-1)/sqrt(2*`th2'*`h0'^2) if `touse'
		   
	label var `varlist' "normalized rss"
	exit
}
end


program ParseNorm, sclass
	local 0 , `0' 
	syntax [, Unit Eigen Inveigen ]

	local norm `unit' `eigen' `inveigen'
	local nnorm : list sizeof norm
	if `nnorm' > 1 {
		opts_exclusive "`norm'" norm
	}
	else if "`norm'" == "" {
		local norm unit
	}
	
	sreturn clear
	sreturn local norm `norm'
end	
exit

predicted f1 f2 ... and fitted values fit_j

ABOUT COMPONENTS SCORES AND FITTED VALUES

Let Y be the variables, an n x m matrix, and U the variables that were 
PCA-ed: 
  
  PCA/correlation: U are the Z-scores of Y
  PCA/covariance : U are the (variable-)centered Y

We assume loadings L (m x k), and so the column j are the loadings for 
the j-th component. These may be the principal components in any of
the normalizations, but also some rotation of the principal components. 
For what follows, the nature of L is not important. We do assume that it
is full rank. 
  
The component scores A are chosen by OLS-estimation of the regression
  
  U = A*L' + E
   
and so the component scores are
  
  A = U * L * inv(L'*L) = U * Z 
  
with

  Z = L * inv(L'*L) is the scoring matrix. 
    
The U_fitted values are A*L' = U * L*inv(L'*L)*L' = U*P, 
with P the ortho projection on L.  If we want to compute the
fitted values, we do this projection, and do circumvent computing
the component scores. 
  
The Y_fitted values "undo" the transformation from Y to U. -predict-
after -pca- only returns the Y_fitted scores

The residuals Y - Y_fitted are computed simple as the difference
between the observed and fitted values
