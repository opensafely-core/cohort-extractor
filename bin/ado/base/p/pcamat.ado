*! version 2.2.0  01may2009
program pcamat, eclass
	version 8

	if replay() {
		if "`e(cmd)'" != "pca" {
			error 301
		}
		pca_display `0'
	}
	else {
		Estimate `0'
		ereturn local cmdline `"pcamat `0'"'
	}
end


program Estimate, eclass

	#del ;
	syntax  anything(name=Cin id="covariance or correlation matrix"),
 	        n(numlist max=1 >=0 integer)
	[
	     // display options
	     	// MEans		not allowed with pcamat
	     	noDISPLAY
	        Level(passthru)
	        BLanks(passthru)
	        
	     // matrix data specification
 	        SDS(str)
 	        MEANS2(str)
 	        NAMes(passthru)
 	        SHape(passthru)
 	        FORCE	// undocumented (do not enforce same name stripes)
 	        
	     // model
 	        COMponents(numlist integer max=1 >0)
 	        FActors(numlist integer max=1 >0)  // synonym of components()
 	        MINEigen(numlist max=1 >=0)
 	        CORrelation
 	        COVariance
 	        
	     // SE/VCE
	     	noVCE
	     	VCE2(string)
 	        IGNORE
 	        TOL(numlist max=1 >=0)
 	        FORCEPSD

 	     // not to be documented -- used internally to speed up pca
 	        matrixtype(str)
	] ;
	#del cr
	local display_options  `blanks' `level' `means' `std' `vce'

	if `:list sizeof Cin' > 1 {
		dis as err "exactly one matrix name expected"
		exit 103
	}
	confirm matrix `Cin'

	ParseVCE `vce2' 
	if "`s(vce)'" == "normal" { 
		local normal normal
		local vce_arg vce(normal)
	}
	
	if "`correlation'" != "" & "`covariance'" != "" {
		dis as err "options correlation and covariance are exclusive"
		exit 198
	}	
	if "`covariance'" == "" { 
		local correlation correlation
	}	
	if "`normal'" != "" & "`correlation'" != "" {
		dis as txt /// 
		   "(with PCA/correlation, SEs and tests are approximate)"
	}

	if "`normal'" == "" {
		if ("`level'"  != "") Invalid level()
	}

// get the matrix for PCA

	if "`matrixtype'" == "" {
		tempname C
		if `"`means2'"' != "" { 
			local mopt means(`means2')
		}
		if "`sds'" != "" {
			local sopt sds(`sds')
		}
		if "`check'" == "" { 
			local check psd	
		}
		
		_getcovcorr `Cin', `covariance' `correlation' ///
		   `sopt' `mopt' `names' `shape' `force' /// 
		   check(`check') `forcepsd'
		   
		matrix `C' = r(C)
		local Ev_npos = r(npos)
		local type `r(Ctype)'
		if "`r(means)'" == "matrix" {
			tempname Means
			matrix `Means' = r(means)
		}
		if "`r(sds)'" == "matrix" {
			tempname Sds
			matrix `Sds' = r(sds)
		}

		local Cname `Cin'  
	}
	else {
		// called by pca; no worry about invalid data

		local C     `Cin'
		local type  `matrixtype'
		local Means `means2' 
		local Sds   `sds' 
		local Cname "the sample `type' matrix" 
	}

	local nvar = rowsof(`C')
	local varlist : rownames `C'

//  number of components (factors) to be extracted

	if `"`components'"' != "" & `"`factors'"' != "" {
		dis as err "components() and factors() are synonyms"
		exit 198
	}
	if `"`factors'"' != "" {
		local optname factors()
		local nf = `factors'
	}
	if "`components'" != "" {
		local optname components()
		local nf = `components'
	}
	if "`nf'" == "" {
		local nf = `nvar'
	}
	else if !inrange(`nf',1,`nvar') {
		dis as err "`optname' should be between 1 and `nvar'"
		exit 125
	}
	if "`tol'" == "" {
		local tol = 1e-5
	}
	if "`mineigen'" == "" {
		local mineigen = `tol'
	}

// ---------------------------------------------------------------------------
// do actual PCA of C -- a spectral decomposition
// notes on symeigen
//   returns (eigenvectors,eigenvalues), sorted on eigvals (decreasing order)
//   returns eigenvectors e signed positively, i.e., with e'1 > 0
// ---------------------------------------------------------------------------

	tempname b bV nobs condW lndetW Rho traceW Psi Ev L

	quietly matrix symeigen `L' `Ev' = `C'
		
	if "`matrixtype'" == "" { 	
		// set the small eigenvalues to 0
		forvalues i = `=`Ev_npos'+1'/`nvar' {
			matrix `Ev'[1,`i'] = 0
		}
	}
	else {
		forvalues i = 1/`nvar' {
			if `Ev'[1,`i']/`Ev'[1,1] < 1E-8 { 
				matrix `Ev'[1,`i'] = 0 
			}	
		}
	}
	
	CheckEigenvalues `Ev' `tol' "`Cname'" "`type'" "`ignore'" "`normal'"
	
	scalar `traceW' = r(trace)
	scalar `lndetW' = r(lndet)
	scalar `condW'  = r(cond)
	
	scalar `nobs' = `n'

	forvalues i = 1 / `nvar' {
		local facnames `facnames' Comp`i'
	}
	matrix colnames `Ev' = `facnames'   // eigenvalues
	matrix coleq    `Ev' = Eigenvalues
	matrix colnames `L'  = `facnames'   // eigenvectors

// retain factors

	forvalues i = `nf'(-1)1 {
		if `Ev'[1,`i'] < `mineigen' {
			local --nf
		}
	}
	
	if `nf' == 0 {
		dis as txt "(no components retained)"
		
		ereturn post , obs(`=`nobs'') properties(nob noV eigen)
		
		ereturn scalar f   = 0
		ereturn scalar rho = 0 
		ereturn matrix Ev  = `Ev'
	
		ereturn matrix C = `C'            // covar/corr matrix
		ereturn local Ctype `type'
		ereturn scalar trace = `traceW'   // trace of C
		if "`Means'" != "" {
			ereturn matrix means = `Means'
		}
		if "`Sds'" != "" {
			ereturn matrix sds   = `Sds'
		}
		
		ereturn local title      "Principal components/`type'"
		ereturn local predict    pca_p
		ereturn local rotate_cmd pca_rotate
		ereturn local estat_cmd  pca_estat
		ereturn local marginsnotok _ALL
		
		ereturn local cmd  pca

		if "`display'" == "" {
			pca_display , `display_options'
		}
		exit
	}

	scalar `Rho' = 0
	forvalues i = 1 / `nf' {
		scalar `Rho' = `Rho' + `Ev'[1,`i']
	}
	scalar `Rho' = `Rho' / `traceW'

// ---------------------------------------------------------------------------
// VCE assuming multivariate normality
// ---------------------------------------------------------------------------

	if "`normal'" != "" {

		tempname b0 st1 st2 biasEv varEv ELC
		tempname chi2_i df_i p_i chi2_s df_s p_s 
		tempname e ee ei ej lsum llsum t Vi

		forvalues i = 1 / `nf' {
			matrix `b0' = `L'[1...,`i']'
			matrix coleq `b0' = Comp`i'
			matrix `b' = nullmat(`b'), `b0'
		}
		matrix drop `b0'

	// test for independence (Basilevsky: 187)

		if "`covariance'" != "" {
			tempname cC
			matrix `cC' = corr(`C')
		}
		else {
			local cC `C'
		}

		scalar `chi2_i' = -(`nobs'-(2*`nvar'+5)/6) * ln(det(`cC'))
		scalar `df_i'   = `nvar'*(`nvar'-1)/2
		scalar `p_i'    = chi2tail(`df_i', `chi2_i')

	// test for sphericity (Basilevsky: 192)

		scalar `chi2_s' = ///
		        -(`nobs' - (2*`nvar'^2+`nvar'+2)/(6*`nvar')) * ///
		         (`lndetW' - `nvar'*ln(`traceW'/`nvar'))
		scalar `df_s'   = (`nvar'+2)*(`nvar'-1)/2
		scalar `p_s'    = chi2tail(`df_i', `chi2_s')

	// compute bias(Ev) and var(Ev) of eigenvalues Ev
	// (asymptotic values based on normality)

		matrix `biasEv' = J(1,     `nvar',0)    // bias(Ev)
		matrix `varEv'  = J(`nvar',`nvar',0)    // var(Ev)
		matrix colnames `biasEv' = `facnames'
		matrix rownames `biasEv' = bias

		// estimate V(lambda) with terms of order 1/n and 1/n^2
		//
		// if this estimator that are not posdef, we switch to the
		// estimator that uses terms up to order 1/n only
		
		local EV_order2 = 1
		forvalues i = 1/`nvar' {
		    scalar `st1' = 0
		    scalar `st2' = 0
		    forvalues j = 1 / `nvar' {
		        if (`j' == `i')  continue

		        scalar `t' = `Ev'[1,`j'] / (`Ev'[1,`i']-`Ev'[1,`j'])
		        scalar `st1' = `st1' +  `t'
		        scalar `st2' = `st2' + (`t')^2

		        // cov(L_i,L_j)
		        matrix `varEv'[`i',`j'] = /// 
		           (2/`nobs'^2) * (`Ev'[1,`i']*`t')^2

		    }
		    matrix `biasEv'[1,`i']  = (`Ev'[1,`i']/`nobs') * `st1'
		    matrix `varEv'[`i',`i'] = ///
		       (2/`nobs')*`Ev'[1,`i']^2 * (1-`st2'/`nobs')
		      
		    if (`varEv'[`i',`i'] <= 0) local EV_order2 = 0
		}
		
		if (`EV_order2' == 0) { 	
		    // estimate var(Ev) with order 1/n term only
		    matrix `varEv'  = J(`nvar',`nvar',0)
		    forvalues i = 1/`nvar' {
		        matrix `varEv'[`i',`i'] =  (2/`nobs')*`Ev'[1,`i']^2
	            }
		}

	// Compute variance bV of eigvecs, asymptotic based on normality

		local nr = colsof(`b')
		local vfnames : colfullnames(`b')
		matrix `bV' = J(`nr',`nr',0)
		matrix rownames `bV' = `vfnames'
		matrix colnames `bV' = `vfnames'

		// diagonal block associated with variance matrices 
		// of eigenvectors (components)

		local ic = 1
		forvalues i = 1 / `nf' {
		    matrix `Vi' = J(`nvar',`nvar',0)
		    forvalues j = 1 / `nvar' {
		        if (`i'==`j')  continue
		      
		        scalar `t'  = (`Ev'[1,`i']*`Ev'[1,`j']) / ///
		                      (`Ev'[1,`i']-`Ev'[1,`j'])^2 
		        matrix `e'  = `L'[1...,`j']
		      
		        matrix `Vi' = `Vi' + `t' * `e'*`e'' 
		    }
		    matrix `bV'[`ic',`ic'] = `Vi'
		    local ic = `ic' + `nvar'
		}
		matrix drop `Vi' `e'

		// off-diagonal blocks associated with covariances of 
		// eigenvectors (components)

		local ic = 1
		forvalues i = 1 / `nf' {
		    matrix `ei' = `L'[1...,`i']
		    local jc = 1
		    forvalues j = 1 / `=`i'-1' {
		        scalar `t'  = (`Ev'[1,`i']*`Ev'[1,`j']) / ///
		                    (`Ev'[1,`i']-`Ev'[1,`j'])^2
		        matrix `ej' = `L'[1...,`j']
		        matrix `ee' = - `t' * `ej' * `ei''

		        matrix `bV'[`ic',`jc'] = `ee'
		        matrix `bV'[`jc',`ic'] = `ee''
		        local jc = `jc' + `nvar'
		    }
		    local ic = `ic' + `nvar'
		}

		// scale and attch name

		matrix `bV' = (1/`nobs') * `bV'

		capture matrix drop `ei'
		capture matrix drop `ej'
		capture matrix drop `ee'

	// additional statistics

		VarExplainedSE `nobs' `Ev' `ELC'

	// create (b,V) by concatenate eigenvalues and eigenvectors and 
	// their V-parts

		matrix `b' = `Ev'[1,1..`nf'] , `b'
		local names : colfullnames `b'

		matrix `bV' = ( `varEv'[1..`nf',1..`nf'] , J(`nf',`nr',0) \ ///
		                J(`nr',`nf',0)           , `bV'           )
		matrix colnames `bV' = `names'
		matrix rownames `bV' = `names'
	}

// ----------------------------------------------------------------------------
// post results
// ----------------------------------------------------------------------------
	
	matrix `L' = `L'[1...,1..`nf']
	matrix `Psi' = vecdiag( `C' - `L'*diag(`Ev'[1,1..`nf'])*`L'' )
	forvalues j = 1/`=colsof(`Psi')' {
		matrix `Psi'[1,`j'] = chop(`Psi'[1,`j'],1e-6)
	}
	matrix rownames `Psi' = Unexplained

	ereturn clear
	if "`normal'" != "" {
		ereturn post `b' `bV' , obs(`=`nobs'') properties(b V eigen)
		ereturn local  vce    "multivariate normality"

		ereturn scalar v_rho  = `ELC'[`nf',5]  // asymptotic var(rho)

		ereturn scalar chi2_i = `chi2_i'       // test for independence
		ereturn scalar df_i   = `df_i'
		ereturn scalar p_i    = `p_i'

		ereturn scalar chi2_s = `chi2_s'       // test for sphericity
		ereturn scalar df_s   = `df_s'
		ereturn scalar p_s    = `p_s'

		ereturn matrix Ev_bias  = `biasEv'     // bias of eigenvalues
		ereturn matrix Ev_stats = `ELC'        // stats on expl var
		_post_vce_rank
	}
	else {
		ereturn post , obs(`=`nobs'') properties(nob noV eigen)
	}

	ereturn matrix L  = `L'                        // eigvecs = components
	ereturn matrix Ev = `Ev'                       // eigenvalues
	ereturn matrix Psi  = `Psi'                    // unexplained corr/cov

	ereturn matrix C = `C'                         // covar/corr matrix
	ereturn local Ctype `type'

	if "`Means'" != "" {
		ereturn matrix means = `Means'
	}
	if "`Sds'" != "" {
		ereturn matrix sds   = `Sds'
	}

	ereturn scalar f     = `nf'                    // #comps=factors ret.
	ereturn scalar rho   = `Rho'                   // %explained variance
	
	ereturn scalar trace = `traceW'                // trace of C
	ereturn scalar lndet = `lndetW'                // ln(det) of C
	ereturn scalar cond  = `condW'                 // condition number(C)

	ereturn local predict    pca_p
	ereturn local rotate_cmd pca_rotate
	ereturn local estat_cmd  pca_estat
	ereturn local marginsnotok _ALL

	ereturn local title   "Principal components"
	ereturn local cmd     pca                      // sic !

// and now display

	if "`display'" == "" {
		pca_display , `display_options'
	}
	_returnclear
end


program CheckEigenvalues, rclass
	args Ev       /// row-matrix: eigenvalues of PCA-matrix
	     tol      ///    numeric: tolerance for EV=zero and EV1=EV2
	     matname  ///     string: name of PCA-matrix 
	     mattype  ///     string: "correlation" or "covariance" 
	     ignore   ///     switch: whether to ignore problems for asympt theory
	     normal    //     switch: if set, SEs are computed
	
	tempname cond trace lndet Tol
	
	local n      = colsof(`Ev')
	local nzero  = 0  // exactly zero 
	local npzero = 0  // "positive zero" 
	local nnzero = 0  // "negative zero" 
	local npos   = 0
	
	scalar `Tol' = abs(`tol' * `Ev'[1,1])
	forvalues i = 1 / `n' {
		if `Ev'[1,`i'] < -`Tol' {
			dis as err "negative eigenvalue found where none expected" 
			exit 198
		}
		else if `Ev'[1,`i'] < 0 { 
			local ++nnzero
		}	
		else if `Ev'[1,`i'] == 0 { 
			local ++nzero
		}	
		else if `Ev'[1,`i'] < `Tol' { 
			local ++npzero
		}
		else 	local ++npos
	}
	
	if "`normal'" != "" & `nnzero' + `nzero' > 0 { 
		dis as err "{p}standard errors assuming multivariate " ///
		    "normality are only computed for a nonsingular " ///
		    "covariance matrix{p_end}" 
		matlist `Ev', rowtitle(Eigenvalues) left(4)
		exit 506		    
	}	
		
// compute some statistics

	scalar `cond'  = sqrt(`Ev'[1,1]/`Ev'[1,`n'])
	scalar `lndet' = 0
	forvalues i = 1 / `n' {
		scalar `lndet' = `lndet' + ln(`Ev'[1,`i'])
	}
	
	scalar `trace' = 0 
	forvalues i = 1 / `n' {
		scalar `trace' = `trace' + `Ev'[1,`i']
	}	
	// return trace as integer if close to integer 
	scalar `trace' = chop(`trace',abs(`trace')*1e-6)

// check for small positive eigenvalues zero or (almost) equal eigenvalues

	if "`normal'" != "" {
		local equal = 0
		forvalues i = 2 / `n' {
			if `Ev'[1,`i'-1]-`Ev'[1,`i'] < `Tol' {
				local equal = 1
			}
		}
		
		if `equal' | `npzero' {
			if `equal' {
				dis as txt "`mattype' matrix " /// 
				    "has (almost) equal eigenvalues"
			}
			if `npzero' { 
				dis as txt "`mattype' matrix " ///
				    "is (nearly) singular"
			}
			
			if "`ignore'" == "" { 
				matlist `Ev', rowtitle(Eigenvalues) left(4)
				dis _n as err "SEs are suspect; specify " /// 
				    "option ignore to proceed nonetheless"
				error 498
			}
			else 	dis as txt "Beware: SEs are suspect" 
		}
	}

	return scalar cond  = `cond'    // condition number of C
	return scalar trace = `trace'   // trace(C)
	return scalar lndet = `lndet'   // ln(det(C))
end


// inference on percentage and cumulative percentage of variance
// explained by the "largest eigenvectors". See Kshirsagar (1972:454)
//
program VarExplainedSE
	args nobs   /// input:  number of obs
	     Ev	    /// input:  sorted eigenvalues, 1xnv ROWVECTOR
	     ELC     // output: nv x 5 matrix

	tempname EvC rho sEv sEv2

	local nvar = colsof(`Ev')
	matrix `EvC'  = J(`nvar',2,0)
	matrix `EvC'[1,1] = `Ev'[1,1]
	matrix `EvC'[1,2] = `Ev'[1,1]^2
	forvalues i = 2 / `nvar' {
		matrix `EvC'[`i',1] = `EvC'[`i'-1,1] + `Ev'[1,`i']
		matrix `EvC'[`i',2] = `EvC'[`i'-1,2] + `Ev'[1,`i']^2
	}
	scalar `sEv'  = `EvC'[`nvar',1]
	scalar `sEv2' = `EvC'[`nvar',2]

	matrix `ELC' = J(`nvar',5,.)
	forvalues i = 1 / `nvar' {
		matrix `ELC'[`i',1] = `Ev'[1,`i']
		matrix `ELC'[`i',2] = `Ev'[1,`i'] / `sEv'
		matrix `ELC'[`i',3] = ///
		   (2*`Ev'[1,`i']^2 / (`nobs'*`sEv'^2)) * ///
		   (1 - (2*`Ev'[1,`i']/`sEv') + (`sEv2'/`sEv'^2))

		// rho = cumulative percentage of variance explained
		scalar `rho' = `EvC'[`i',1] / `sEv'
		matrix `ELC'[`i',4] = `rho'

		// asymptotic variance of rho
		matrix `ELC'[`i',5] = /// 
		   (2/`nobs') * ( (1-`rho')^2 * `EvC'[`i',2]  ///
		   + `rho'^2 * (`sEv2' - `EvC'[`i',2])) / (`sEv'^2)
	}
	matrix rownames `ELC' = `:colnames `Ev''
	matrix colnames `ELC' = /// 
	   Eigenvalue Proportion var_Prop Cumulative var_Cum
end


program Invalid
	args optname
	
	dis as err "option `optname' only valid " /// 
	           "in combination with option vce(normal)"
	exit 198
end	


program ParseVCE, sclass
	local arg `0'
	local 0 ,`0' 
	capture syntax [, NORmal NONe ] 
	if _rc {
		dis as err "option vce() invalid" 
		dis as err `"`arg' not allowed"'
		exit 198
	}
	
	local arg `normal' `none' 
	if `:list sizeof arg' > 1 {
		exclusive_opts `"`arg'"' "vce()" 
	}
	
	sreturn clear
	sreturn local vce `arg' 
end
exit
