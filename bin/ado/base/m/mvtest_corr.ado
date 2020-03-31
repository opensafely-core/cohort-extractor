*! version 1.2.0  16jan2015
program mvtest_corr, byable(onecall)
	version 11

	if _by() {
		local bycmd by `_byvars':
	}

	syntax varlist [if] [in] [aw fw] [, by(varlist) * ]
	if "`by'"=="" {
		/* `bycmd' OneSample `0'     To avoid  multiple aweight assumed
					     messages must do the following
		*/
		`bycmd' OneSample `varlist' `if' `in' [`weight'`exp'], ///
					`options'
	}
	else {
		/* `bycmd' MultipleSamples `0'    To avoid multiple aweight
						  assumed messages ...
		*/
		`bycmd' MultipleSamples `varlist' `if' `in' [`weight'`exp'], ///
					by(`by') `options'
	}
end

// -----------------------------------------------------------------------------
// LR tests that correlation matrix has a particular pattern
// see Jennrich (1970) & Lawley   (1963)
// -----------------------------------------------------------------------------

program OneSample, rclass byable(recall)

	syntax varlist(numeric min=2) [if] [in] [aw fw], [ ///
		COMPound Equal Equals(name) ]
	// option equal is synonym for compound

	if "`compound'" != "" local equal equal

	mvtest_dups "`varlist'"
	local k: list sizeof varlist

	tempname chi2 df p z InvP N P R T Tmp Z

	if "`equal'`equals'" == "" { // default is -equal- (i.e., -compound-)
		local equal equal
	}
	
	if ("`equal'"!="")+("`equals'"!="")!= 1 {
		dis as err "only one test may be specified"
		exit 198
	}
	if "`equals'" != "" {
		local fixed `equals'
	}

	if "`equal'" != "" {
		if `k' < 3 {
			dis as err		///
		     "compound symmetry test requires at least three variables"
			exit 102
		}

		local pattdes "is compound symmetric (all correlations equal)"
	}
	else if "`fixed'"!="" {
		local C `fixed'
		confirm matrix `C'
		capture matrix `P' = cholesky(`C')
		if (_rc==504) dis as err 	///
			"specified correlation matrix has missing values"
		if (_rc==505) dis as err	///
			"specified correlation matrix is not symmetric"
		if (_rc==506) dis as err 	///
			"specified correlation matrix is not positive definite"
		if (_rc) exit _rc

		matrix `P' = corr(`C')
		if mreldif(`P',`C') > 1e-8 {
			dis as txt "(matrix `C' is not a correlation matrix)"
		}

		local pattdes = "equals specified pattern " + trim("`C'")
	}
	else {
		/* unreached */
	}

	marksample touse
	if "`weight'"!="" {
		local wght [`weight'`exp']
	}
	qui matrix accum `R' = `varlist' `wght' if `touse', nocons dev
	scalar `N' = r(N)
	if (`N'<`k') error 2001

	capture matrix `Tmp' = syminv(`R')
	if diag0cnt(`Tmp')>0 {
		dis as err "sample correlation matrix is singular"
		exit 506
	}

	capture matrix `R' = corr(`R')
	if _rc==504 {
		dis as err "constant variable"
		exit 504
	}

	if "`equal'"!="" {
		// test equal correlations (Lawley 1963)

		local chi2type Lawley
		scalar `chi2' = .
		mata: EqualCorr("`R'","`N'","`chi2'")
		scalar `df' = `k'*(`k'-1)/2 - 1
		scalar `p'  = chi2tail(`df',`chi2')
	}
	else {
		// test correlations equals specified pattern (Jennrich 1970)

		local chi2type Jennrich
		matrix `InvP' = syminv(`P')
		matrix `Z' = sqrt(`N')*`InvP'*(`R'-`P')
		matrix `z' = vecdiag(`Z')
		matrix `T' = trace(`Z'*`Z')/2 ///
			- `z'*syminv(I(`k')+hadamard(`P',`InvP'))*`z''
		scalar `chi2' = `T'[1,1]
		scalar `df' = `k'*(`k'-1)/2
		scalar `p'  = chi2tail(`df',`chi2')
	}

	dis _n as txt "Test that correlation matrix `pattdes'" _n
	mvtest_chi2test "`chi2type'" `chi2' `df' `p'

	return clear
	return local chi2type `chi2type'
	return scalar chi2 = `chi2'
	return scalar df   = `df'
	return scalar p_chi2    = `p'
end

// -----------------------------------------------------------------------------
// test equality of correlation matrices
// see Jennrich (1970)
// -----------------------------------------------------------------------------

program MultipleSamples, rclass byable(recall)

	syntax varlist(numeric min=2) [if] [in] [aw fw], ///
		by(varlist) [ MISSing DETail ] // -detail- is undocumented

	mvtest_dups "`varlist'"
	local k : list sizeof varlist

	tempname chi2 df g max mean min p InvR InvS N R T Tmp zi Zi

	marksample touse
	if "`weight'"!="" {
		local wght [`weight'`exp']
	}
	qui egen `g' = group(`by') if `touse', `missing'
	qui summ `g' if `touse', meanonly
	local m = r(max)
	if `m' < 2 {
		dis as err "by() variables constant -- only one group found"
		exit 198
	}

	scalar `N'   = 0
	scalar `max' = 0
	scalar `min' = _N
	matrix `R' = J(`k',`k',0)

	forvalues i = 1/`m' {
		tempname R`i' N`i'

		qui matrix accum `R`i'' = `varlist'  `wght' ///
			 if `touse' & `g'==`i', nocons dev
		scalar `N`i'' = r(N)
		scalar `max' = max(`max', `N`i'')
		scalar `min' = min(`min', `N`i'')
		if `N`i''<=`m' {
			dis as err "size of sample `i' too small"
			exit 2001
		}

		matrix `Tmp' = syminv(`R`i'')
		if diag0cnt(`Tmp')>0 {
			dis as err "sample correlation matrix is singular"
			exit 506
		}

		capture matrix `R`i'' = corr(`R`i'')
		if _rc==504 {
			dis as err "constant variable in sample `i'"
			exit 504
		}

		scalar `N' = `N' + `N`i''
		matrix `R' = `R' + `N`i''*`R`i''
	}
	matrix `R' = `R'/`N'

	matrix `InvR' = syminv(`R')
	if diag0cnt(`InvR')>0 {
		dis as err "mean of sample correlation matrices is singular"
		exit 506
	}

	matrix `InvS' = syminv(I(`k') + hadamard(`R',`InvR'))
	matrix `T'    = J(`m',1,0)
	scalar `chi2' = 0
	forvalues i = 1/`m' {
		matrix `Zi' = sqrt(`N`i'')*`InvR'*(`R`i''-`R')
		matrix `zi' = vecdiag(`Zi')
		matrix `T'[`i',1] = trace(`Zi'*`Zi')/2 - `zi'*`InvS'*`zi''
		scalar `chi2' = `chi2' + `T'[`i',1]
	}
	scalar `df' = (`m'-1)*`k'*(`k'-1)/2
	scalar `p'  = chi2tail(`df',`chi2')


	dis _n as txt ///
		"Test of equality of correlation matrices across samples" _n

	if "`detail'"!="" {
		dis as txt _col(5) " sample {c |}       Obs     Contribution"
		dis as txt _col(5) "{hline 8}{c +}{hline 28}"
		forvalues i = 1/`m' {
			dis as txt _col(5) %5.0f `i' "   {c |}" ///
				as res %10.0fc `N`i'' "  " %13.4f `T'[`i',1]
		}
		dis as txt _col(5) "{hline 8}{c +}{hline 28}"
		dis as txt _col(5) "  total {c |}" ///
			 as res %10.0fc `N' "  " %13.4f `chi2'
		dis
	}
	mvtest_chi2test "Jennrich" `chi2' `df' `p'

	return clear
	return local chi2type Jennrich
	return scalar chi2 = `chi2'
	return scalar df   = `df'
	return scalar p_chi2    = `p'
end

// ---------------------------------------------------------------------------
// test that correlation matrix is compound symmetric, i.e., all correlations
// are equal; See Lawley (1963) and Johnson and Wichern (2007, 457-458)
// ---------------------------------------------------------------------------

version 11

mata:

void EqualCorr(string scalar _R, string scalar _Nobs, string scalar _chi2)
{
	real matrix  R
	real scalar  chi2, k, mu, N, r, t1, t2
	real scalar i, j

	R = st_matrix(_R)
	N = st_numscalar(_Nobs)
	k = cols(R)
	r = (sum(R)-k)/(k*(k-1)) // mean correlation

	t1 = 0
	for (i=1; i<=k; i++)
		for (j=1; j<i; j++)
			 t1 = t1 + (R[i,j]-r)^2

	t2   = sum(((colsum(R):-1):/(k-1) :- r):^2)
	mu   = ((k-1)^2*(1-(1-r)^2))/(k-(k-2)*(1-r)^2)

        // Johnson and Wichern (2007, 458) show N-1 (not N) in the formula
        // below (just like we have it).  Do not get confused looking at
        // Lawley (1963, 151) where he uses n; you need to look at Lawley
        // (1963, 149) where he says "... sample of size n+1. ..." to realize
        // the equivalence.
	chi2 = ((N-1)/(1-r)^2)*(t1 - mu*t2)

	st_numscalar(_chi2, chi2)
}
end
exit
