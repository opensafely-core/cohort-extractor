*! version 1.2.0  16jan2015
program	procrustes, eclass byable(onecall)
	version 9

	if replay() {
		if "`e(cmd)'" != "procrustes" {
			error 301
		}
		if _by() {
			error 190
		}
		Display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0': Estimate `0'
	}
	else {
		Estimate `0'
		ereturn local cmdline `"procrustes `0'"'
	}
end


program Estimate, eclass byable(recall)

	#del ;
	syntax  anything [if] [in] [aw fw]
	[,
		TRansform(str) 
		noCONstant
		noRHo
		FORCE
		noFIt
		SCale  // undocumented option transform(ortho)
		LOG    // undocumented option transform(oblique)
	] ;
	#del cr
	
	local display_options `fit' 
	
	ParseTransform  `transform' 
	local transform `s(transform)' 
	
	gettoken ylist anything : anything, match(parens)
	gettoken xlist anything : anything, match(parens)
	if `"`anything'"' != "" { 
		dis as err `"unexpected input `anything'"' 
		exit 198
	}	
	if (`"`xlist'"' == "") | (`"`ylist'"' == "") {
		dis as err "two varlists expected"
		exit 198
	}
	unab xlist : `xlist' , name(varlist_x) min(1) 
	unab ylist : `ylist' , name(varlist_y) min(1) 
	if ("`:list dups xlist'" != "") & ("`force'" == "") {
		dis as err "duplicate variables in varlist-x"
		dis as err "specify option force to proceed anyway"
		exit 198
	}
	if ("`:list dups ylist'" != "") & ("`force'" == "") {
		dis as err "duplicate variables in varlist-y"
		dis as err "specify option force to proceed anyway"
		exit 198
	}
	if ("`:list xlist & ylist'" != "") & ("`force'" == "") {
		dis as err "varlist-x and varlist-y are not disjoint"
		dis as err "specify option force to proceed anyway"
		exit 198
	}
	confirm numeric var `xlist' `ylist'

	if "`weight'" != "" { 
		local wght [`weight'`exp'] 
	}	
	
	marksample touse, novarlist
	quietly summarize `touse' if `touse' `wght', meanonly
	local n0 = r(N)

	markout `touse' `xlist' `ylist'
	quietly summarize `touse' if `touse' `wght', meanonly
	local nobs = r(N)

	if (`nobs' == 0) error 2000
	if (`nobs' == 1) error 2001

	local nx : list sizeof xlist
	local ny : list sizeof ylist

// optimal transformation (A,rho,c)

	if "`transform'" == "orthogonal" {  
		Ortho "`ylist'" "`xlist'" `"`wght'"' "`touse'" /// 
		   "`scale'" "`constant'" "`rho'"
	}
	else if "`transform'" == "oblique" { 
		Oblique "`ylist'" "`xlist'" `"`wght'"' "`touse'" /// 
		   "`scale'" "`constant'" "`rho'" "`log'"
	}
	else if "`transform'" == "unrestricted" {
		local rho norho
		Unrestricted "`ylist'" "`xlist'" `"`wght'"' "`touse'" /// 
		   "`scale'" "`constant'" "`rho'"
	}
	else {
		_stata_internalerror	
	}

// extract results 

	tempname A c Rho
	
	matrix `A'   = r(A)
	matrix `c'   = r(c)
	scalar `Rho' = r(rho)
	
	local uniqueA  `r(uniqueA)' 

// degrees of freedom of model and residual

	tempname df_m df_r
	
	scalar `df_m' = `ny'*`nx' + ("`rho'"=="") + `ny'*("`constant'"=="")
	if "`transform'" == "orthogonal" { 
		scalar `df_m' = `df_m' - `nx'*(`nx'+1)/2 
	}
	else if "`transform'" == "oblique" { 
		scalar `df_m' = `df_m' - `nx'
	}
	scalar `df_r' = `nobs'*`ny' - `df_m'

// fit statistics per y-variable

	tempname b P rmse rss ss urmse ystats
	tempvar  res yhat

	matrix `ystats' = J(5,`ny',.)
	matrix colnames `ystats' = `ylist' 
	matrix rownames `ystats' = SS RSS RMSE Procrustes Corr_y_yhat
	
	local iy = 0
	foreach y of local ylist { 
		capture drop `yhat'
		capture drop `res' 
		local ++iy
	// ss
		SS `y' `touse' "`wght'" "`constant'" 
		matrix `ystats'[1,`iy'] = r(ss)
		
	// rss	
		matrix `b' = `A'[1...,`iy']'
		matrix score double `yhat' = `b' if `touse'
		quietly replace `yhat' = `Rho'*`yhat' + `c'[1,`iy'] if `touse'
		
		quietly gen double `res' = (`y'-`yhat')^2  if `touse' 
		quietly summ `res' if `touse' `wght' , meanonly 
		matrix `ystats'[2,`iy'] = r(N)*r(mean)
		
	// rmse	
		matrix `ystats'[3,`iy'] = sqrt(`ystats'[2,`iy']/(`df_r'/`ny'))
		
	// P = rss/ss	
		matrix `ystats'[4,`iy']	= `ystats'[2,`iy']/`ystats'[1,`iy']
		
	// pcorr(y,yhat)	
		quietly corr `y' `yhat' if `touse' `wght' 
		matrix `ystats'[5,`iy'] = r(rho)
	}
	
// overall statistics
	
	scalar `ss'  = 0 
	scalar `rss' = 0
	forvalues iy = 1/`ny' {
		scalar `ss'  = `ss'  + `ystats'[1,`iy']
		scalar `rss' = `rss' + `ystats'[2,`iy']
	}

	// procrustes statistic
	scalar `P'     = `rss' / `ss'
	scalar `urmse' = sqrt( `rss' / (`nobs'*`ny'))
	scalar `rmse'  = sqrt( `rss' / `df_r' )
	tempname ny
	scalar  `ny'  = `: list sizeof ylist'

// save results 

	ereturn post, obs(`nobs') esample(`touse') properties(nob noV)

	ereturn local ylist       `ylist'
	ereturn local xlist       `xlist'
	ereturn local wtype       `weight'
	ereturn local wexp        `"`exp'"' 

	ereturn local transform   `transform'
	ereturn local uniqueA     `uniqueA' 
	
	ereturn matrix A          = `A'
	ereturn matrix c          = `c'
	ereturn scalar rho        = `Rho'
	
	ereturn matrix ystats     = `ystats'  

	ereturn scalar N          = `nobs'
	ereturn scalar ss         = `ss' 
	ereturn scalar rss        = `rss'
	ereturn scalar P          = `P'
	ereturn scalar rmse       = `rmse'
	ereturn scalar urmse      = `urmse'
	ereturn scalar df_m       = `df_m'
	ereturn scalar df_r       = `df_r'
	ereturn scalar ny         = `ny'

	ereturn local predict     procrustes_p
	ereturn local estat_cmd   procrustes_estat
	ereturn local marginsnotok _ALL
	
	ereturn local cmd         procrustes

// display	

	Display , `display_options' 
end

// ----------------------------------------------------------------------------

program Display
	syntax [, noFIt ]

// header

	dis _n as txt "Procrustes analysis (`e(transform)')" ///
	    _col(44) "Number of observations" ///
	    _col(67) "= " as res %10.0fc e(N)
	    
	dis _col(44) as txt "Model df (df_m)"    ///
	    _col(67) "= " as res %10.0fc e(df_m)
	dis _col(44) as txt "Residual df (df_r)" ///
	    _col(67) "= " as res %10.0fc e(df_r)

	if "`e(scale)'" != "" {
		dis as txt "X and Y are scaled to trace(XX') = trace(YY') = 1"
	}
	
	dis _col(44) as txt "SS(target)" ///
	    _col(67) "=  " as res %9.0g e(ss)
	dis _col(44) as txt "RSS(target)" ///
	    _col(67) "=  " as res %9.0g e(rss)
	dis _col(44) as txt "RMSE = root(RSS/df_r)" ///
	    _col(67) "=  " as res %9.0g e(rmse)
	dis _col(44) as txt "Procrustes = RSS/SS" ///
	    _col(67) "= " as res %10.4f e(P)

// shift c

	dis as txt "Translation c"
	matlist e(c), left(4) border(top bot) 

// rotation A

	dis _n as txt "Rotation & reflection matrix A (`e(transform)')"
	matlist e(A), left(4) border(top bot) nohalf
	
	if "`e(uniqueA)'" == "0" {
		dis as txt _col(5) "(Warning: rotation A not unique)"
	}

// dilation factor

	if "`e(transform)'" != "unrestricted" { 
		dis _n as txt "Dilation factor " _n(2) ///
		    _col(14) "rho = " as res %9.4f e(rho)
	}	
	
// statistics

	if "`fit'" == "" { 
		dis _n as txt "Fit statistics by target variable"
		matlist e(ystats), row(Statistics) /// 
		   left(4) border(top bot) 
	}
end


// ============================================================================
// procrustes analysis:  y(i) = c + rho A' x(i) + e(i) , i = 1..nobs
//  in matrix notation:    Y  = 1c' + rho X A + E
//
//          orthogonal:  A is orthonormal A'A = AA' = I 
//             oblique:  A is normal      diag(A'A) = 1
//        unrestricted:  no restrictions on A, and rho = 1
//
// if norho  is specified,  rho is fixed at 1
// if nocons is specified,  cons = 0-vector
// ============================================================================
	
program Ortho, rclass
	args ylist xlist wght touse scale cons rho
	
	tempname A b c P Rho 
	tempname m traceX traceY traceW U V W x XtX YtX YtY Z 

// append zero x-vars so that # yvars = # xvars 

	local ny  : list sizeof ylist  
	local nx0 : list sizeof xlist 
	
	if `ny' < 2 {
		dis as err "at least two y-variables expected"
		exit 102
	}
	if `nx0' < 2 {
		dis as err "at least two x-variables expected"
		exit 102
	}
	if `nx0' > `ny' {
		dis as err "#x-variables should not exceed #y-variables"
		exit 198
	}
	local xxlist `xlist'
	if `nx0' < `ny' {
		tempvar zero
		gen byte `zero' = 0
		forvalues j = `=`nx0'+1' / `ny' {
			local xxnames `xxnames' zero
			local xxlist  `xxlist'  `zero'
		}
	}
	
// unscaled cross-products [X Y]'[X Y] 

	if "`cons'" == "" {
		local Dev dev
	}
	quietly matrix accum `Z' = `xxlist' `ylist' `wght' /// 
	   if `touse' , `Dev' means(`m') nocons

	local ny   : list sizeof ylist 
	local p    = `ny'   
	local pp1  = `p'+1

	matrix `XtX' = `Z'[1..`p', 1..`p']
	matrix `YtY' = `Z'[`pp1'..., `pp1'...]
	matrix `YtX' = `Z'[`pp1'..., 1..`p']
	matrix drop `Z'

	_m2scalar `traceX' = trace(`XtX')
	_m2scalar `traceY' = trace(`YtY')
	
	if `traceX' < 1e-8 {
		dis as err "no variation in x-variables" 
		exit 198
	}	
	if `traceY' < 1e-8 {
		dis as err "no variation in y-variables" 
		exit 198
	}	
	
	if "`scale'" != "" {
		matrix `XtX' = `XtX' / `traceX'
		matrix `YtY' = `YtY' / `traceY'
		matrix `YtX' = `YtX' / sqrt(`traceX'*`traceY')
		scalar `traceX' = 1
		scalar `traceY' = 1
	}

	matrix svd `U' `W' `V' = `YtX'

	matrix `A' = `V' * `U''
	_m2scalar `traceW' = `W' * J(colsof(`W'),1,1)
	
	UniqueA `W' 
	local uniqueA = `r(unique)'

	if "`rho'" == "" {
		scalar `Rho' = `traceW'/`traceX'
		// equivalent, 
		// matlist trace(`A'*`YtX') / trace(`XtX') 
	}
	else {
		scalar `Rho' = 1
	}

	if "`cons'" == "" {
		matrix `c' = `m'[1,`pp1'...] - `Rho'*`m'[1,1..`p']*`A'
	}
	else {
		matrix `c' = J(1,`ny',0)
		matrix colnames `c' = `ylist'
		matrix rownames `c' = _cons
	}
	
	if `nx0' < `ny' {
		matrix `A' = `A'[1..`nx0',1...]
	}
	
	return matrix A       = `A'
	return matrix c       = `c'
	return scalar rho     = `Rho'
	return local  uniqueA = `uniqueA' 
end


// ----------------------------------------------------------------------------
// Oblique Procrustes -- we may treat each y-variable separately if rho==1 
//                    -- otherwise we use a binary search 
//
// Browne, M.W. (1967)
//    On oblique Procrustes rotation.
//    Psychometrika 32: 125-132.
//
// Cramer, E.M. (1974) 
//    On Browne's solution for oblique Procrustes rotation.
//    Psychometrika 39: 159-163.
//
// Ten Berge, J.M.F. & K. Nevels (1977) 
//    A general solution to Mosier's oblique Procrustes problem
//    Psychometrika 42: 593-600.
//
// Ten Berge, J.M.F. (2004)
//    Personal communication
// ----------------------------------------------------------------------------
//
program Oblique, rclass
	args ylist xlist wght touse scale cons rho log
	
	tempname a A c Rho 
	tempname ev m mu Rho_new Rho_lower Rho_upper XtX YtX U V w W Z

	if "`cons'" == "" {
		local Dev dev
	}
	quietly matrix accum `Z' = `xlist' `ylist' `wght' /// 
	   if `touse', `Dev' means(`m') nocons

	local p  : list sizeof xlist
	local pp = `p'+1
	local ny : list sizeof ylist
	
	matrix `XtX' = `Z'[1..`p', 1..`p'] 
	matrix `YtX' = `Z'[`pp'...,1..`p'] 
		
// rotation and dilation

	if "`rho'" != "" { 
		matrix symeigen `V' `ev' = `XtX'
		scalar `Rho' = 1
		ObliqueA `A' `Rho_new' = `XtX' `YtX' `V' `ev' `Rho' "`log'"
	}
	else {
		// start with ortho solution
		
		if `p' == `ny'  { 
			local YtX0 `YtX' 
		}
		else { 
			tempname YtX0 
			if `p' < `ny' { 
				matrix `YtX0' = `YtX' , J(`ny',`ny'-`p',0)
			}
			else {
				matrix `YtX0' = `YtX' \ J(`p'-`ny',`p',0)
			}
		}
		
		matrix svd `U' `W' `V' = `YtX0'
		matrix `A' = `V' * `U''
		_m2scalar `Rho_new' = trace(`A'*`YtX0') / trace(`XtX') 
		
		matrix symeigen `V' `ev' = `XtX'		
		
		/*
			local iter = 0
			scalar `Rho' = 1
			while reldif(`Rho',`Rho_new') > 1e-8 { 
				local ++ iter
				scalar `Rho' = `Rho_new'
				if "`log'" != "" { 
					dis as txt "Iteration " as res `iter' ///
					    as txt " Rho = " as res %9.0g `Rho' 
				}
				ObliqueA `A' `Rho_new' = /// 
				   `XtX' `YtX' `V' `ev' `Rho' "`log'"	
			}
		*/
			
		if 1 { 
			// find upper and lower bounds to solution
			
			scalar `Rho' = `Rho_new'			
			ObliqueA `A' `Rho_new' = `XtX' `YtX' `V' `ev' `Rho'
			if `Rho_new' > `Rho' { 
				scalar `Rho_lower' = `Rho' 
				while `Rho_new' > `Rho' {
					scalar `Rho' = 2*`Rho'
					ObliqueA `A' `Rho_new' = /// 
					   `XtX' `YtX' `V' `ev' `Rho' "`log'"
				}	
				scalar `Rho_upper' = `Rho' 
			}
			else { 
				scalar `Rho_upper' = `Rho' 
				while `Rho_new' < `Rho' {
					scalar `Rho' = 0.5*`Rho'
					ObliqueA `A' `Rho_new' = /// 
					   `XtX' `YtX' `V' `ev' `Rho' "`log'"
				}	
				scalar `Rho_lower' = `Rho' 
			}

			// binary search on [Rho_lower,Rho_upper]
	
			local iter = 0
			while reldif(`Rho_upper',`Rho_lower') > 1e-9 {
				local ++iter
				if "`log'" != "" { 
					#del ;
					dis as txt "bisearch iteration " 
					    as res `iter' 
					    as txt " Rho in [ " 
					    as res %9.0g `Rho_lower' 
					    as txt " , " 
					    as res %9.0g `Rho_upper' 
					    as txt " ]" ;
					#del cr
				}
				scalar `Rho' = (`Rho_lower'+`Rho_upper')/2
				
				ObliqueA `A' `Rho_new' = /// 
				   `XtX' `YtX' `V' `ev' `Rho' "`log'"
				   
				if `Rho_new' > `Rho' { 
					scalar `Rho_lower' = `Rho'
				}
				else {
					scalar `Rho_upper' = `Rho' 
				}
			}
		}	
	}
	matrix colnames `A' = `ylist' 
	matrix rownames `A' = `xlist' 

// translation 

	if "`cons'" == "" { 
		matrix `c' = `m'[1,`pp'...] - `Rho'*`m'[1,1..`p']*`A'
	}
	else {
		matrix `c' = J(1,`ny',0)
	}
	matrix colnames `c' = `ylist'
	matrix rownames `c' = _cons

// saved results 

	return matrix A       = `A'
	return matrix c       = `c'
	return scalar rho     = `Rho'
	return local  uniqueA = 1
end


// ----------------------------------------------------------------------------
// Unrestricted -- this is also the "maximum congruence" approach 
// 
// see Korth and Tucker (1976), 
//    Procrustes matching by congruence coefficients
//    Psychometrika 41: 531-535. 
// ----------------------------------------------------------------------------

program Unrestricted, rclass
	args ylist xlist wght touse scale cons rho
	
	tempname A c m Z
	
	if "`cons'" == "" {
		local Dev dev
	}
	quietly matrix accum `Z' = `xlist' `ylist' `wght' /// 
	   if `touse', `Dev' means(`m') nocons
		
	local p  : list sizeof xlist
	local pp = `p'+1
	local ny : list sizeof ylist
		
	matrix `A' = syminv(`Z'[1..`p',1..`p'])*`Z'[1..`p',`pp'...]
	
	if "`cons'" == "" { 
		matrix `c' = `m'[1,`pp'...] - `m'[1,1..`p']*`A'
	}
	else {
		matrix `c' = J(1,`ny',0)
	}
	matrix colnames `c' = `ylist'
	matrix rownames `c' = _cons

// saved results 

	return matrix A       = `A'
	return matrix c       = `c'
	return scalar rho     =  1
	return local  uniqueA =  1
end

// utility subroutines ////////////////////////////////////////////////////////

program ParseTransform, sclass
	local 0 , `0'
	syntax [, ORthogonal OBlique UNrestricted ]
	
	local opt `orthogonal' `oblique' `unrestricted'
	if `: list sizeof opt' == 0 {
		local opt orthogonal
	}
	opts_exclusive "`opt'"

	sreturn clear
	sreturn local transform `opt' 
end	


// Returns in r(unique) whether the following two conditions are met 
//   (1)  all singular values (elements of the row matrix W) 
//        are distinct
//   (2)  all singular values are strictly positive  
// Tests are conducted within reldif-tolerance tol (default 1e-8)
//
// The singular values in W computed by -matrix svd- need not be sorted
//
program UniqueA, rclass 
	args W tol

	confirm matrix `W' 
	assert rowsof(`W') == 1
	
	tempname Tol sumW
	
	_m2scalar `sumW' = `W' * J(colsof(`W'),1,1)
	if "`tol'" == "" { 
		scalar `Tol' =  1e-8 * `sumW' 
	}
	else {
		scalar `Tol' = abs(`tol') * `sumW' 
	}	
	
	local ok = 1
	forvalues i = 1 / `=colsof(`W')' { 
		if `W'[1,`i'] < `Tol' {
			local ok = 0
			continue, break
		}
		
		forvalues j = 1 / `=`i'-1' {  
			if abs(`W'[1,`i']-`W'[1,`j']) < `Tol' {
				local ok = 0
				continue, break
			}
		}
	}

	return local unique = `ok' 
end


program SS, rclass
	args exp touse wght cons

	tempname ss
	tempvar  x
	
	quietly gen double `x' = `exp' if `touse'
	quietly summ `x' `wght' if `touse'
	
	// centered sum of squares
	scalar `ss' = (r(N)-1) * r(Var) 
	if "`cons'" != "" {
		// uncentered sum of squares
		scalar `ss' = `ss' + r(N)*r(mean)^2
	}
	
	return scalar ss = `ss' 
end


program ObliqueA
	args A Rho_new colon XtX YtX V ev Rho log
	
	tempname a ev2 mu w w2 
	
	local p  = colsof(`YtX')
	local ny = rowsof(`YtX')
	
	capture matrix drop `A' 
	forvalues i = 1 / `ny' { 
		matrix `w' = `YtX'[`i', 1...] * `V'
		matrix `w2'  = `Rho'   * `w' 
		matrix `ev2' = `Rho'^2 * `ev' 
		ObliqueSolve `a' = `ev2' `w2' `V' "`log'"
		matrix `A' = nullmat(`A'), `a'	
	}
			
	_m2scalar `Rho_new' = trace(`A'*`YtX') / trace(`XtX'*`A'*`A'')
end	


program ObliqueSolve
	args a equal ev w V log 
	assert "`equal'" == "="
	
	tempname dfmu fmu mu mu0 s x
	
	// multiplicity q of smallest eigenvalue ev

	local m = colsof(`ev')
	local i = `m'-1
	while (`i'>0) & (reldif(`ev'[1,`i'],`ev'[1,`m'])<1e-10) {
		local --i
	}
	local q = `m'-`i'

	matrix `x' = J(`m',1,0)
	
	// distinguishes three cases (see TenBerge & Nevels 1977)
	
	scalar `s' = 0
	forvalues i = `=`m'-`q'+1' / `m' { 
		scalar `s' = `s' + `w'[1,`i']^2
	}	
	
	scalar `mu0' = `ev'[1,`m'] - sqrt(`s')
	if `s' > 0 {
		local newton = 1
		local mn = `m' 
		EvalF `fmu' =  0 `ev' `w' `m' 
		
		forvalues i = 1 / `=`m'-`q'' {
			scalar `mu0' = min(`mu0',`ev'[1,`i']-abs(`w'[1,`i']))
		}
		if `fmu' <= 0 {
			scalar `mu0' = min(0,`mu0')
		}
	}
	else {
		EvalF `fmu' =  `ev'[1,`m'] `ev' `w' `=`m'-`q''
		if `fmu' >= 0 {
			// solution is not unique
			local newton = 0
			forvalues i = 1/`=`m'-`q'' {
				matrix `x'[`i',1] = ///
				   `w'[1,`i'] /(`ev'[1,`i']-`ev'[1,`m'])
			}
			matrix `x'[`m'-`q'+1,1] = sqrt(`fmu') 
		}
		else { 
			local newton = 1
			scalar `mu0' = `ev'[1,`m']
			local mn = `m'-`q'
		}
	}
	
	if `newton' {
		local iter = 0
		scalar `mu' = `mu0'
		while (`iter'==0) | ((reldif(`mu',`mu0') > 1e-9) & (`iter' < 1000)) { 
			local ++iter
			scalar `mu0' = `mu'
			if "`log'" != "" { 
				dis as txt "  NR iter {res:`iter'} mu = " /// 
				    as res %9.0g `mu0'
			}
			EvalF   `fmu' = `mu' `ev' `w' `mn' 
			dEvalF `dfmu' = `mu' `ev' `w' `mn' 
			scalar   `mu' = `mu' - `fmu'/`dfmu' 
		}
		
		forvalues i = 1/`m' { 
			matrix  `x'[`i',1]  = cond( `ev'[1,`i']-`mu'!=0 , /// 
			   `w'[1,`i']/(`ev'[1,`i']-`mu'), 0)
		}
	}
	
	matrix `a' = `V' * `x' 
end


program EvalF
	args fmu equal mu ev w h
	assert "`equal'" == "="

	scalar `fmu' = 1
	forvalues i = 1 / `h' {
	   scalar `fmu' = `fmu' - ((`w'[1,`i']/(`ev'[1,`i']-`mu'))^2)
	}
end


program dEvalF
	args dfmu equal mu ev w h
	assert "`equal'" == "="

	scalar `dfmu' = 0
	forvalues i = 1 / `h' {
	   scalar `dfmu' = `dfmu' - ((2*`w'[1,`i']^2)/((`ev'[1,`i']-`mu')^3))
	}
end
exit
