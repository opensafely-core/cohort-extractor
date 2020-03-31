*! version 1.1.1  09sep2019
program mvtest_mean, byable(onecall)
	version 11

	if _by() {
		local bycmd by `_byvars' :
	}

	syntax varlist [if] [in] [aw fw] [, by(varlist) *]
	if "`by'"=="" {
		/* `bycmd' OneSample `0'     To avoid multiple aweight assumed
					     messages must do the following
		*/
		`bycmd' OneSample `varlist' `if' `in' [`weight'`exp'], ///
					`options'
	}
	else {
		/* `bycmd' MultipleSamples `0'       To avoid multiple aweight
						     assumed messages ...
		*/
		`bycmd' MultipleSamples `varlist' `if' `in' [`weight'`exp'], ///
					by(`by') `options'
	}
end

// -----------------------------------------------------------------------------
// Tests that the mean-vector satisfies some specified pattern
// -----------------------------------------------------------------------------

program OneSample, rclass byable(recall)

	syntax varlist(numeric min=1) [if] [in] [aw fw] [, DETail ///
		Equal Equals(name) Linear(name) Zero ]
	// -detail- is undocumented

	mvtest_dups "`varlist'"
	local k : word count `varlist'

	local fixed `equals'
	local nopt = ("`equal'"!="") + (`"`fixed'"'!="") + ///
			(`"`linear'"'!="") + ("`zero'"!="")
	if `nopt' == 0 {
		local equal equal
		local nopt 1
	}
	if `nopt'>1 {
		dis as err "exactly one hypothesis should be specified"
		exit 198
	}

	tempname b d N dfm dfr p A F M M0 S T V X

	marksample touse
	if "`weight'"!="" {
		local wght [`weight'`exp']
	}
	qui matrix accum `S' = `varlist' `wght' if `touse', nocons dev means(`M')
	scalar `N' = r(N)
	matrix `S' = `S'/`N'	// note: ML, not unbiased
				// must use N-1 multiplier for T (below)

	// implementation allows singular covariance matrix

	if "`equal'"!="" {
		local pattdes "all means are the same"

		if (`k'==1) error 102
		matrix `A' = I(`k'-1),J(`k'-1,1,-1)
		matrix `b' = J(`k'-1,1,0)
	}
	else if "`fixed'"!="" {
		local pattdes "means equal vector `fixed'"

		matrix `M0' = `fixed'
		if (matmissing(`M0')) error 504
		if (colsof(`M0')==1) matrix `M0' = `M0''
		if (rowsof(`M0')!=1 | colsof(`M0')!=`k') error 503
	}
	else if "`linear'"!="" {
		local pattdes "mean vector satisfies linear hypothesis `linear'"

		matrix `A' = `linear'
		if (matmissing(`A')) error 504
		if colsof(`A')==`k' {
			matrix `b' = J(rowsof(`A'),1,0)
		}
		else if colsof(`A')==`k'+1 {
			matrix `b' = `A'[1...,`k'+1]
			matrix `A' = `A'[1...,1..`k']
		}
		else {
			error 503
		}
	}
	else if "`zero'"!="" {
		local pattdes "all means are 0"

		matrix `M0' = J(1,`k',0)
	}
	else {
		/* not reached */
	}

	if "`fixed'"!="" | "`zero'"!="" {
		// see Mardia, page 125-126,131 - Hotelling 1-sample test
		matrix `d'   = `M'' - `M0''
		matrix `V'   = syminv(`S')
		scalar `dfm' = colsof(`V') - diag0cnt(`V')
	}
	else {
		// see Mardia, page 132/3
		matrix `V'   = syminv(`A'*`S'*`A'')
		scalar `dfm' = colsof(`V') - diag0cnt(`V')
		matrix `d'   = `S'*`A''*`V'*(`A'*`M'' - `b')
		matrix `V'   = syminv(`S')
	}

	matrix `T'   = `d'' * `V' * `d'
	scalar `F'   = ((`N'-`dfm')/`dfm')*`T'[1,1]
	matrix `T'   = (`N'-1) * `T'
	scalar `dfr' = `N'-`dfm'
	scalar `p'   = Ftail(`dfm',`dfr',`F')
	local Ftype Hotelling

	dis _n as txt "Test that `pattdes'"
	if "`linear'"!="" & "`detail'"!="" {
		matrix `X' = (`A',`b')
		matrix colnames `X' = `varlist' _cons
		matlist `X', names(col) border left(4)
	}
	dis _n as txt "{ralign 22:Hotelling T2} = " as res %9.2f `T'[1,1]
	mvtest_ftest "`Ftype'" `F' `dfm' `dfr' `p'

	return clear
	return local  Ftype `Ftype'
	return scalar T2  = `T'[1,1]
	return scalar F   = `F'
	return scalar df_m = `dfm'
	return scalar df_r = `dfr'
	return scalar p_F   = `p'
end

// -----------------------------------------------------------------------------
// Same means in multiple samples
// -----------------------------------------------------------------------------

program MultipleSamples, sortpreserve byable(recall) rclass

	#del ;
	syntax varlist(numeric min=1) [if] [in] [aw fw], by(varlist)
	[
		MISSing
		HOMogeneous	// documented
		HOMogenous	// not documented
		HOMoskedastic	// not documented
		HETerogeneous	// documented
		HETerogenous	// not documented
		HETeroskedastic	// not documented
		DETail		// undocumented
		LR
		PROTect(string)
	] ;
	#del cr

	if `"`homogenous'"' != "" /* not documented */ | ///
						`"`homogeneous'"' != "" {
		local homoskedastic homoskedastic
	}
	if `"`heterogenous'"' != "" /* not documented */ | ///
						`"`heterogeneous'"' != "" {
		local heteroskedastic heteroskedastic
	}

	if "`homoskedastic'" != "" & "`heteroskedastic'" != "" {
		di in smcl as err "{p}options homogeneous and heterogeneous"
		di in smcl as err "may not be specified together{p_end}"
		exit 198
	}
	
	if "`protect'" != "" & "`lr'" == "" {
		di as err "must specify lr with protect()"
		exit 198
	}
	if `"`protect'"' != "" {
		Parse_protect `"`protect'"'
		local pmethod	`s(pmethod)'
		local pargs	`s(pargs)'  
	}

	tempname g wvar Obs

	mvtest_dups "`varlist'"
	local k : word count `varlist'

	marksample touse
	if ("`weight'"!="") local wght [`weight'`exp']

	qui egen `g' = group(`by') if `touse', `missing'
	label variable `g' "bygroups"
	qui tab `g' `wght' if `touse', matcell(`Obs')
	if (r(N)==0) error 2000
	local m = rowsof(`Obs')
	if `m'==1 {
		dis as err "only one group specified"
		exit 198
	}

	if ("`lr'"!="") & ("`homoskedastic'"!="") {
		di as err "options lr and homogeneous may not be specified together"
		exit 198
	}
	if ("`lr'"!="") local heteroskedastic 1
	if "`heteroskedastic'"!="" {
		sort `touse' `g'
		if "`weight'"!="" {
			// Mata handles all weights as iweights
			// note that exp has a leading "="
			qui gen `wvar' `exp' if `touse'
			if "`weight'"=="aweight" {
				qui summ `wvar' if `touse'
				qui replace `wvar' =	///
					 (`wvar'/r(sum))*r(N) if `touse'
			}
		}
		else {
			qui gen `wvar' = 1 if `touse'
		}

		if "`lr'"!="" | `m'>2 {
			MBFtest "`varlist'" "`wvar'" "`touse'" "`g'"	///
				"`m'" "`Obs'" "`detail'" "`lr'" 	///
				"`pmethod'" "`pargs'" 
		}
		else {
			BFtest "`varlist'" "`wvar'" "`touse'" "`g'"	///
				"`Obs'" "`detail'"
		}
	}
	else {
		HomoTest "`varlist'" "`weight'" "`exp'" "`touse'" "`g'"	///
			"`m'" "`Obs'" "`detail'"
	}
	return add
end


// MNV test for 2-group Behrens-Fisher problem
// work is done in Mata
program BFtest
	args varlist wvar touse g Obs detail

	mata: BF_MNV( "`varlist'", "`wvar'", "`touse'", "`g'" )

	dis _n as txt ///
"Test for equality of {res:2} group means, allowing for heterogeneity" _n
	if ("`detail'"!="") mvtest_samples `Obs'
	mvtest_ftest "`r(Ftype)'" r(F) `r(df_m)' `r(df_r)' r(p_F)
end


// Comparison of >2 groups, allowing for heterogeneous variances
// work is done in Mata
program MBFtest
	args varlist wvar touse g m Obs detail lr pmethod pargs

	if "`lr'"!="" {
		mata: MBF_LR( "`varlist'", "`wvar'", "`touse'", "`g'", ///
			"`detail'", "`pmethod'", "`pargs'" )
	}
	else {
		mata: MBF_James( "`varlist'", "`wvar'", "`touse'", "`g'" )
	}

	dis _n as txt ///
"Test for equality of {res:`m'} group means, allowing for heterogeneity" _n
	if ("`detail'"!="") mvtest_samples `Obs'
	if "`lr'"!="" {
		mvtest_chi2test "LR" r(chi2) r(df) r(p_chi2)
		if "`r(nprotect)'"!="" {
			dis _n "{p 4 4 2}"
			if "`r(uniq)'"=="1" {
			dis as txt ///
"All `r(nprotect)' protection runs converged to the same solution"
			}
			else {
				dis as txt	///
"Multiple local optima found for different starting values; the minimal value is reported"
			}
			dis "{p_end}"
		}
		else {
/*
			dis _n "{p 4 4 2}"
			dis as txt	///
"(Specify option protect(#) to ascertain that a global minimum was attained)"
			dis "{p_end}"
*/
		}
	}
	else {
		mvtest_chi2test "Wald" r(chi2) r(df) r(p_chi2) "" _continue
		dis as txt "  (chi-squared approximation)"
		dis as txt "{ralign 22:Prob > chi2} = " ///
			as res %9.4f r(p_chi2_James) ///
			as txt "  (James' approximation)"
	}
end


// Comparison of >=2 groups, assuming homogeneous variances
// work is done by -manova-
program HomoTest, rclass
	args varlist weight wexp touse g m Obs detail

	tempname hold T

	_estimates hold `hold', restore nullok
	if ("`weight'"!="") local wght [`weight'`wexp']
	capture manova `varlist' = `g' `wght' if `touse'
	local rc = _rc
	if `rc' {
		capture noisily manova `varlist' = `g' `wght' if `touse'
		/* dis as err "mvtest call through to manova failed" */
		exit `rc'
	}
	local name `"`: variable label `g''"'
	matrix `T' = e(stat_m)

	dis _n as txt ///
"Test for equality of {res:`m'} group means, assuming homogeneity" _n
	if ("`detail'"!="") mvtest_samples `Obs'
	mvtest_manotab `T'
/* No new information is presented in the following -- therefore omitted
	if `m' == 2 {
		di
		mvtest_ftest "Hotelling"  `T'[1,2] `T'[1,3] `T'[1,4] `T'[1,5]
	}
*/

	return local  Ftype  "Wilks/LR"
	return scalar F     = `T'[1,2]
	return scalar df_m  = `T'[1,3]
	return scalar df_r  = `T'[1,4]
	return scalar p_F   = `T'[1,5]

	return matrix stat_m = `T'
end

program Parse_protect, sclass 
	args protect
	
	gettoken keyw rest : protect, parse(", ")
	local len = strlen(`"`keyw'"')
	if `"`keyw'"' == bsubstr("groups",1,max(1,`len')) {
		local method groups
		if `"`rest'"'!="" { 
			dis as err `"extraneous input: `rest'"'  
			dis as err `"  in protect(groups)"'
			exit 198
		}
	}
	else if `"`keyw'"' == bsubstr("randobs",1,max(1,`len')) {	
		local 0 `rest'  
		capture noi syntax , REPs(numlist integer max=1 >=1)
		if _rc {
			dis as err "  in option protect()"
			exit _rc
		}
		local method randobs
		local args `reps' 
	}	
	else if real(`"`protect'"')!=. {
		capt noi numlist `"`protect'"', integer max(1) range(>=1)
		if _rc {
			dis as err "  in option protect()"
			exit _rc
		}
		local method randobs
		local args `r(numlist)' 
	}
	else {
		dis as err "`protect' invalid specification of protect()" 
		exit 198
	}	

	sreturn clear	
	sreturn local pmethod 	`method' 
	sreturn local pargs	`args' 
end
		
// ----------------------------------------------------------------------------

version 11

mata:

// ----------------------------------------------------------------------------
// MNV test
//  Invariant test (Krishnamoorthy & Yu 2004) for the 2-group Behrens-Fisher
//  problem, dubbed "Modified Nel and Vandermerwe"
// ----------------------------------------------------------------------------

void BF_MNV( 
	string scalar 	_varlist, 
	string scalar 	_weight,
	string scalar 	_touse, 
	string scalar 	_by 
)
{
	real matrix     MV, InvS, S1, S2, S, X, Xi
	real colvector  M1, M2, g, d
	real scalar     F, T2, dfm, dfr, k, n1, n2, p, v
	real scalar	w, wi

	st_view(X=., ., tokens(_varlist), _touse)
	st_view(w=., ., tokens(_weight),  _touse)
	st_view(g=., ., _by,              _touse)

	k = cols(X)
	if (min(g)!=1 & max(g)!=2) {
		// should not be reached
		errprintf("too many groups for 2-group Behrens-Fischer test\n")
		_error(3410)
	}

	Xi  = select(X, g:==1)
	wi  = select(w, g:==1)
	n1  = sum(wi)
	MV  = meanvariance(Xi,wi)
	M1  = MV[1,.]'
	S1  = MV[|2,1 \ .,.|]/n1

	Xi  = select(X, g:==2)
	wi  = select(w, g:==2)
	n2  = sum(wi)
	MV  = meanvariance(Xi,wi)
	M2  = MV[1,.]'
	S2  = MV[|2,1 \ .,.|]/n2

	d   = M1-M2
	S   = S1 + S2
	InvS = invsym(S)
	if (diag0cnt(InvS)>0) {
		errprintf("singular covariance matrix\n")
		exit(506)
	}
	T2  = d'*InvS*d

	v   = (k+k^2)/( (trace((S1*InvS)*(S1*InvS))+ trace(S1*InvS)^2)/(n1-1) +
		(trace((S2*InvS)*(S2*InvS))+ trace(S2*InvS)^2)/(n2-1) )
	F   = ((v-k+1)/(v*k))*T2
	dfm = k
	dfr = v-k+1
	p   = Ftail(dfm,dfr,F)

	st_rclear()
	st_global("r(Ftype)", "MNV")
	st_numscalar("r(F)", F)
	st_numscalar("r(df_m)", dfm)
	st_numscalar("r(df_r)", dfr)
	st_numscalar("r(p_F)", p)
}


// ----------------------------------------------------------------------------
// James test for the multiple-group Behrens-Fisher problem
// See Seber 445-447
// ----------------------------------------------------------------------------

real scalar MBF_James_util( real scalar p, pointer vector Ptr )
{
	real scalar a, b, r, t

	a = *Ptr[1]
	b = *Ptr[2]
	r = *Ptr[3]
	t = *Ptr[4]

	return( (invchi2(r,1-p)*(a+b*invchi2(r,1-p)) - t)^2 )
}


void MBF_James(
	string scalar 	_varlist, 
	string scalar 	_weight,
	string scalar 	_touse, 
	string scalar 	_by
)
{
	pointer(real colvector) colvector pM
	pointer(real    matrix) colvector pW
	pointer Ptr

	real matrix     D, InvW, IV, MV, X, Xi, W
	real colvector  mn, g, y, d, n, w, wi
	real scalar     i, k, m, t1, t2, t, a, b, r, p, pJ, rc, fv


	st_view(X=., ., tokens(_varlist), _touse)
	st_view(w=., ., tokens(_weight),  _touse)
	st_view(g=., ., _by,              _touse)

	k = cols(X)
	m = max(g)

	n  = J(m,1,0)
	y  = J(k,1,0)
	W  = J(k,k,0)
	pM = pW = J(m,1,NULL)
	for (i=1; i<=m; i++) {
		Xi    = select(X, g:==i)
		wi    = select(w, g:==i)
		n[i]  = sum(wi)
		MV    = meanvariance(Xi,wi)
		mn    = MV[1,.]'

		// MV[|2,1 \ .,.|] is cov with a Ni-1 divisor (just like
		// Seber (1984) and James (1954)), so divide by Ni to get IV.
		// When comparing to manual entry, realize it has cov with
		// Ni divisor and then divides by Ni-1 for IV.  The two
		// ways are equivalent
		IV    = invsym(MV[|2,1 \ .,.|] :/ n[i])

		if (diag0cnt(IV)>0) {
			errprintf("singular covariance matrix\n")
			exit(506)
		}

		W     = W + IV
		y     = y + IV*mn

		pM[i] = &(J(k,1,0)); *pM[i] = mn
		pW[i] = &(J(k,k,0)); *pW[i] = IV
	}
	InvW = invsym(W)
	y = InvW*y

	r = k*(m-1)
	t = a = b = 0
	for (i=1; i<=m; i++) {
		d  = (*pM[i]) - y
		t  = t + d'*(*pW[i])*d

		D  = I(k) - InvW*(*pW[i])
		t1 = trace(D)^2
		t2 = trace(D*D)
		a  = a + t1 / (n[i]-1)
		b  = b + (t2 + 0.5*t1) / (n[i]-1)
	}
	a = 1 + a/(2*r)
	b = b/(r*(r+2))
	p = chi2tail(r,t)

	// use minbound to solve for the p-value in the equation
	//   invchi2(r,1-p)*(a+b*invchi2(r,1-p)) = t
	Ptr = (&a,&b,&r,&t)
	rc = _mds_minbound(&MBF_James_util(), (0,1), pJ=p, fv=., (.,.,0), Ptr)
	pragma unused fv
	if (rc!=0) {
		errprintf("James' modified p-value could not be computed")
		exit(498)
	}

	st_rclear()
	st_global("r(chi2type)", "Wald")
	st_numscalar("r(chi2)", t)
	st_numscalar("r(df)", r)
	st_numscalar("r(p_chi2)", p)
	st_numscalar("r(p_chi2_James)", pJ)
}


// ----------------------------------------------------------------------------
// Likelihood ratio test for the multiple-group Behrens-Fisher problem
// algorithm: see Mardia, but with multiple starting points
// beware that global convergence is not ensured; see Bout & Richards.
// ----------------------------------------------------------------------------

// subroutine for MBP_LR, iterate till convergence
real scalar MBF_LR_iterate( 
	real vector 	n, 
	pointer vector 	pM, 
	pointer vector 	pV,
	real scalar 	maxiter, 
	real scalar 	tol, 
	real vector 	M, 
	real scalar 	chi2 
)
{
	real scalar  i, iter, k, m, rc
	real matrix  D, IV, M2, V

	k    = rows(M)
	m    = rows(n)
	iter = 0
	rc   = 1
	while (rc & ++iter<=maxiter) {
		M2 = M
		M  = J(k,1,0)
		V  = J(k,k,0)
		for (i=1; i<=m; i++) {
			D  = (*pM[i])-M2
			IV = n[i]*invsym((*pV[i]) + D*D')
			if (diag0cnt(IV)>0) {
				errprintf("singular covariance matrix/n")
				exit(506)
			}
			V  = V + IV
			M  = M + IV*(*pM[i])
		}

		IV = invsym(V)
		if (diag0cnt(IV)>0) {
			errprintf("singular covariance matrix/n")
			exit(506)
		}

		M  = IV*M
		rc = mreldif(M,M2)>tol
	}

	// LR test statistic
	chi2 = 0
	for (i=1; i<=m; i++) {
		D    = (*pM[i])-M
		chi2 = chi2 + n[i]*ln1p( D'*invsym(*pV[i])*D)
	}

	return(rc)
}

void MBF_LR( 	
	string scalar 	_varlist, 
	string scalar 	_weight,
	string scalar 	_touse, 
	string scalar 	_by, 
	string scalar 	detail, 
	string scalar 	pmethod,
	string scalar	pargs
)
{
	pointer(real colvector) colvector pM
	pointer(real    matrix) colvector pV

	real matrix     IV, MV, X, Xi, V
	real colvector  bM, M, g, n, s, w, wi
	real scalar     bchi2, brc, chi2, df, i, k, m, maxiter, 
			np, p, rc, tol, uniq, D

	pragma unset chi2
	pragma unset bchi2

// view on Stata data

	st_view(X=., ., tokens(_varlist), _touse)
	st_view(w=., ., tokens(_weight),  _touse)
	st_view(g=., ., _by,              _touse)

// allocate the means pM[i] and dispersion matrices pV[i]
// g should be 1,2,... coded
// I don't expect very many groups; store full covariance matrices

	k = cols(X)
	m = max(g)
	n = J(m,1,0)
	pM = pV = J(m,1,NULL)
	for (i=1; i<=m; i++) {
		pM[i] = &(J(k,1,0))   // means are column vectors
		pV[i] = &(J(k,k,0))
	}

// compute and store mean and dispersion matrices over the samples

	for (i=1; i<=m; i++) {
		Xi     = select(X,g:==i)
		wi     = select(w,g:==i)
		n[i]   = sum(wi)
		MV     = meanvariance(Xi,wi)
		*pM[i] = MV[1,.]'
		*pV[i] = MV[|2,1 \ .,.|]*((n[i]-1)/n[i])
	}

// iteration constants

	maxiter	= 1000
	tol	= 1e-8
	uniq	= -1
	np	= 0
	
// estimate common mean M,
// initializing of M according to Mardia/Kent/Bibby (page 142-3)

	M = J(k,1,0)
	V = J(k,k,0)
	for (i=1; i<=m; i++) {
		IV = n[i]*invsym((*pV[i]))
		if (diag0cnt(IV)>0) {
			errprintf("singular covariance matrix\n")
			exit(506)
		}
		V  = V + IV
		M  = M + IV*(*pM[i])
	}
	IV = invsym(V)
	if (diag0cnt(IV)>0) {
		errprintf("singular covariance matrix\n")
		exit(506)
	}
	bM  = IV *M
	brc = MBF_LR_iterate( n,pM,pV, maxiter,tol, bM,bchi2 )

	if (detail!="") {
		printf("{txt}\nInitialization common mean {col 34}     LR chi2    rc")
		printf("\n{hline 52}\n")
		printf("{txt}Weighted mean of sample" +
			" means {col 34}{res}%12.0g %5.0f\n", bchi2, brc)
		displayflush()
	}

// for protection: initialize with group/sample means

	if (pmethod=="groups") {
		uniq = 1
		np   = m
		for (i=1; i<=m; i++) {
			M  = *pM[i]
			rc = MBF_LR_iterate( n,pM,pV, maxiter,tol, M,chi2 )

			if (detail!="") {
				printf("{txt}Mean of sample "+
					"%f {col 34}{res}%12.0g %5.0f\n",
					i, chi2, rc)
				displayflush()
			}

			if (reldif(chi2,bchi2) > 100*tol) {
				uniq = 0
				if (chi2 < bchi2) {
					bchi2 = chi2
					bM    = M
					brc   = rc
				}
			}
		}
	}

	// initialize with randomly selected observations
	
	if (pmethod=="randobs") {
		uniq 	= 1
		np	= min((strtoreal(pargs), rows(X)))
		s  	= jumble(1::rows(X))
		for (i=1; i<=np; i++) {
			M  = X[s[i],.]'
			rc = MBF_LR_iterate( n,pM,pV, maxiter,tol, M,chi2 )

			if (detail!="") {
				printf("{txt}Observation %f " +
					"{col 34}{res}%12.0g %5.0f\n",
					s[i], chi2,rc)
				displayflush()
			}

			if (reldif(chi2,bchi2) > 100*tol) {
				uniq = 0
				if (chi2 < bchi2) {
					bchi2 = chi2
					bM = M
					brc = rc
				}
			}
		}
	}

	if (detail!="") {
		printf("{txt}{hline 52}\n")
		displayflush()

		printf("\nCommon Means\n")
		bM'

		for (i=1; i<=m; i++) {
			printf("\ncovariance matrix in sample %f\n", i)
			D = *pM[i]-bM
			*pV[i]+D*D'
		}
	}

// return results

	df = (m-1)*k
	p  = chi2tail(df,bchi2)

	st_rclear()
	st_global("r(chi2type)", "LR")
	st_matrix("r(M)", bM)
	st_matrixrowstripe("r(M)", (J(k,1,""),tokens(_varlist)'))
	st_matrixcolstripe("r(M)", ("","means"))
	st_numscalar("r(rc)", brc)
	st_numscalar("r(chi2)", bchi2)
	st_numscalar("r(df)", df)
	st_numscalar("r(p_chi2)", p)
	if (np>0) {
		st_numscalar("r(nprotect)", np)
		st_numscalar("r(uniq)", uniq)
	}
}

end
exit
