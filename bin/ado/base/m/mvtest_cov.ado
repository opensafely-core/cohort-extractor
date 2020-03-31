*! version 1.2.0  19feb2019
program mvtest_cov, byable(onecall)
	version 11

	if _by() {
		local bycmd by `_byvars':
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
		/* `bycmd' MultipleSamples `0'     To avoid multiple aweight
						   assumed messages ...
		*/
		`bycmd' MultipleSamples `varlist' `if' `in' [`weight'`exp'], ///
					by(`by') `options'
	}
end

// -----------------------------------------------------------------------------
// LR tests that covariance matrix has a particular pattern
// LR tests with Bartlett correction
// -----------------------------------------------------------------------------

program OneSample, rclass byable(recall)

	syntax varlist(numeric min=1) [if] [in] [aw fw] [, ///
		DETail			/// undocumented
		BLock(str)		///
		COMPound		///
		DIAGonal		///
		Equals(name)		///
		SPHerical		///
	]

	marksample touse

	local C `equals'
	local nopt = (`"`block'"'!="")  + ("`compound'"!="") + ///
		("`diagonal'"!="") + (`"`C'"'!="")  + ///
		("`spherical'"!="")
	if `nopt' > 1 {
		di as err "only one hypothesis may be specified"
		exit 198
	}
	if `nopt' == 0 {
		local diagonal diagonal
	}

	if `:word count `varlist'' < 2 {
		di as err "too few variables specified"
		exit 102
	}
	mvtest_dups "`varlist'"
	local k : word count `varlist'

	tempname a2 a3 chi2 df n p r s2 u R0 S S0 Si Tmp

	if "`weight'"!="" {
		local wght [`weight'`exp']
	}
	qui matrix accum `S' = `varlist' `wght' if `touse', nocons dev
	scalar `n' = r(N)-1
	matrix `S' = `S'/`n'

	matrix `Tmp' = syminv(`S')
	if diag0cnt(`Tmp')>0 {
		dis as err "sample covariance matrix is singular"
		exit 506
	}

	if `"`C'"'!="" {
		local pattdes "equals matrix `C'"
		local ctype   "Adjusted LR"

		matrix `S0' = `C'
		confirm matrix `S0'
		if (rowsof(`S0')!=`k') error 503

		// forces errmsg: mv's, symmetry, posdef
		matrix `R0' = cholesky(`S0')
		matrix drop `R0'

		// Rencher (2002, eq 7.1 and 7.2)
		matrix `u' = ln(det(`S0')/det(`S'))+trace(`S'*syminv(`S0'))-`k'
		scalar `chi2' = `u'[1,1]*`n'*(1-(2*`k'+1-2/(1+`k'))/(6*`n'-1))
		scalar `df' = `k'*(`k'+1)/2
		scalar `p' = chi2tail(`df',`chi2')
	}
	else if "`diagonal'"!="" {
		local pattdes "is diagonal"
		local ctype   "Adjusted LR"

		// Rencher (2002, eq 7.37 and 7.38)
		matrix `u'  = det(corr(`S'))
		scalar `chi2' = -(`n'-(2*`k'+5)/6)*ln(`u'[1,1])
		scalar `df' = `k'*(`k'-1)/2
		scalar `p' = chi2tail(`df',`chi2')
	}
	else if "`spherical'"!="" {
		local pattdes "is spherical"
		local ctype   "Adjusted LR"

		// Rencher (2002, eq 7.9)
		matrix `u' = `k'*ln(`k') + ln(det(`S')) - `k'*ln(trace(`S'))
		scalar `chi2' = -(`n' - (2*`k'^2+`k'+2)/(6*`k'))*`u'[1,1]
		scalar `df' = `k'*(`k'+1)/2 - 1
		scalar `p' = chi2tail(`df',`chi2')
	}
	else if "`compound'"!="" {
		local pattdes "is compound symmetric"
		local ctype   "Adjusted LR"

		// Rencher (2002, eq 7.15 and 7.16)
		matrix `s2' = trace(`S')/`k'
		matrix `r' = (J(1,`k',1)*`S'*J(`k',1,1)-trace(`S'))/(`k'* ///
							(`k'-1)*`s2'[1,1])
		matrix `u' = ln(det(`S')) - `k'*ln(`s2'[1,1]) ///
			- (`k'-1)*ln1m(`r'[1,1]) - ln1p((`k'-1)*`r'[1,1])
		scalar `chi2' = -(`n'-(`k'*(2*`k'-3)*(`k'+1)^2)/(6*(`k'-1)* ///
							(`k'^2+`k'-4)))*`u'[1,1]
		scalar `df' = `k'*(`k'+1)/2 - 2
		scalar `p' = chi2tail(`df',`chi2')
	}
	else if `"`block'"'!="" {
		local pattdes "is block diagonal"
		local ctype   "Adjusted LR"

		local vlist `varlist'
		tokenize "`block'", parse("||")
		local nblock = 0
		while "`1'"!="" {
			while "`1'"=="|" {
				mac shift
			}
			if "`1'"!="" {
				unab v   : `1'
				local d : list v - varlist
				if "`d'"!="" {
					dis as err "`d' not in varlist"
					exit 198
				}
				local d : list v - vlist
				if "`d'"!="" {
					dis as err "`d' specified more than once in block()"
					exit 198
				}
				local vlist : list vlist - v
				local block`++nblock' `v'
				mac shift
			}
		}
		if "`vlist'"!="" {
			local block`++nblock' `vlist'
		}

		// Rencher (2002, eq 7.35 and 7.36)
		scalar `a2' = `k'^2
		scalar `a3' = `k'^3
		matrix `u'  = ln(det(`S'))

		forvalues i = 1/`nblock' {
			SubMatrix `Si' `S' "`block`i''"
			matrix `u' = `u' - ln(det(`Si'))
			scalar `a2' = `a2' - rowsof(`Si')^2
			scalar `a3' = `a3' - rowsof(`Si')^3
		}
		scalar `chi2' = -(`n'-(2*`a3'+3*`a2')/(6*`a2'))*`u'[1,1]
		scalar `df' = `a2'/2
		scalar `p' = chi2tail(`df',`chi2')
	}
	else {
		/* unreached */
	}


	dis _n as txt "Test that covariance matrix `pattdes'"
	if "`detail'"!="" & "`block'"!="" {
		dis
		forvalues i =1/`nblock' {
			dis as txt "{p 4 15 2}block `i': `block`i''{p_end}"
		}
	}
	dis
	mvtest_chi2test "`ctype'" `chi2' `df' `p'

	return clear
	return local chi2type `"`ctype'"'
	return scalar chi2 = `chi2'
	return scalar df   = `df'
	return scalar p_chi2    = `p'
end

program SubMatrix
	args Si S varlist

	tempname T
	capture matrix drop `Si'
	foreach v of local varlist {
		matrix `T' = nullmat(`T') \ `S'["`v'",.]
	}
	foreach v of local varlist {
		matrix `Si' = nullmat(`Si') , `T'[.,"`v'"]
	}
end

// -----------------------------------------------------------------------------
// test equality of covariance matrices
// Box test, with F-approximation (see Rencher 2002 page 254-259)
// -----------------------------------------------------------------------------

program MultipleSamples, rclass byable(recall)

	syntax varlist(numeric min=1) [if] [in] [aw fw], ///
		by(varlist) [ MISSing DETail ] // -detail- is undocumented


	marksample touse
	if `: word count `varlist'' < 2 {
		di as err "too few variables specified"
		exit 102
	}

	mvtest_dups "`varlist'"
	local k : list sizeof varlist

	tempname a1 a2 b1 b2 c1 c2 Chi2 df df1 df2 g lnM lnSpl n ni ///
				pChi2 pF F Si Spl Tmp X

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

	scalar `n'   = 0
	scalar `c1'  = 0
	scalar `c2'  = 0
	scalar `lnM' = 0
	matrix `Spl' = J(`k',`k',0)
	matrix `X'   = J(`m',2,.)

	forvalues i = 1/`m' {
		qui matrix accum `Si'=`varlist' `wght' ///
					if `touse' & `g'==`i', nocons dev
		scalar `ni' = r(N)-1
		if `ni'<=`m' {
			dis as err "insufficient observations in sample `i'"
			exit 2001
		}

		matrix `Tmp'= syminv(`Si')
		if diag0cnt(`Tmp')>0 {
			dis as err "sample covariance matrix is singular"
			exit 506
		}

		scalar `n' = `n' + `ni'
		matrix `Spl' = `Spl' + `Si'

		matrix `X'[`i',1] = `ni'
		matrix `X'[`i',2] = ln(det(`Si'/`ni'))
		scalar `lnM' = `lnM' + `ni'*`X'[`i',2]

		scalar `c1' = `c1' + (1/`ni')
		scalar `c2' = `c2' + (1/`ni'^2)
	}
	matrix `lnSpl' = ln(det(`Spl'/`n'))
	scalar `lnM' = 0.5*(`lnM' - `n'*`lnSpl'[1,1])

	// Box's F and chi2 approximation (see Rencher 2002, 257)

	scalar `c1' = (`c1'-1/`n')*((2*`k'^2+3*`k'-1)/(6*(`k'+1)*(`m'-1)))
	scalar `c2' = (`c2'-1/`n'^2)*(((`k'-1)*(`k'+2))/(6*(`m'-1)))
	scalar `a1' = (`m'-1)*`k'*(`k'+1)/2
	scalar `a2' = (`a1'+2)/abs(`c2'-`c1'^2)
	scalar `b1' = (1-`c1'-`a1'/`a2')/`a1'
	scalar `b2' = (1-`c1'+2/`a2')/`a2'

	scalar `Chi2'  = -2*(1-`c1')*`lnM'
	if (`Chi2'<0) scalar `Chi2' = .
	scalar `df'    = `a1'
	scalar `pChi2' = chi2tail(`df',`Chi2')

	if `c2'>`c1'^2 {
		scalar `F' = -2*`b1'*`lnM'
	}
	else {
		scalar `F' = (2*`a2'*`b2'*`lnM')/(`a1'*(1+2*`b2'*`lnM'))
	}
	if (`F'<0) scalar `F' = .
	scalar `pF' =  Ftail(`a1',`a2',`F')

	dis _n as txt ///
		"Test of equality of covariance matrices across `m' samples" _n

	if "`detail'" != "" {
		dis as txt _col(5) " sample {c |}       Obs     ln(det(Cov))"
		dis as txt _col(5) "{hline 8}{c +}{hline 28}"
		forvalues i = 1/`m' {
			dis as txt _col(5) %5.0f `i' "   {c |}" ///
				as res %10.0fc `= `X'[`i',1]+1' ///
				"  " %13.4f `X'[`i',2]
		}
		dis as txt _col(5) "{hline 8}{c +}{hline 28}"
		dis as txt _col(5) " pooled {c |}" ///
			as res %10.0fc `= `n'+`m'' "  " %13.4f `lnSpl'[1,1]
		dis
	}

	dis as txt "{ralign 22:Modified LR chi2} = " as res %9.0g -2*`lnM'

	mvtest_ftest    "Box" `F' `a1' `a2' `pF'    "oneline"
	mvtest_chi2test "Box" `Chi2' `df'   `pChi2' "oneline"

	return clear
	return local  chi2type  Box
	return scalar F_Box    = `F'
	return scalar df_m_Box   = `a1'
	return scalar df_r_Box   = `a2'
	return scalar p_F_Box    = `pF'

	return scalar chi2  = `Chi2'
	return scalar df    = `df'
	return scalar p_chi2 = `pChi2'
end
exit
