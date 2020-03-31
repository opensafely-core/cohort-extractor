*! version 1.2.1  09sep2019
* test for multivariate normality
program mvtest_norm, rclass byable(recall)
	version 11

	#del ;
	syntax varlist(numeric) [if] [in] [fw]
	[,
		UNIvariate
		BIvariate
		STats(str)
		STatistics(str) // undocumented synonym for stats()
		ALL             // undocumented shorthand for stats(all)
	  /*	by(varlist) */	// undocumented (and disabled for now)
	  /*	MISSing     */	// undocumented (and disabled for now)
	  /*	TOTALonly   */	// undocumented (and disabled for now)
	];
	#del cr

	mvtest_dups "`varlist'"
	local k : word count `varlist'

	ParseStats `"`stats'"' `"`statistics'"' `"`all'"'
	local stats `s(stats)'

	if "`missing'"!="" & "`by'"=="" {
		dis as err "missing allowed only with by()"
		exit 198
	}
	if "`totalonly'"!="" & "`by'"=="" {
		dis as err "totalonly allowed only with by()"
		exit 198
	}

	marksample touse
	if "`by'"!="" & "`missing'"=="" {
		markout `touse' `by', strok
	}
	if "`weight'"!="" {
		local wght [`weight'`exp']
	}

	if "`bivariate'"!="" {
		if (`k'<2) {
			di as text ///
			 "only one variable specified; option bivariate ignored"
			local bivariate
		}
	}

	clear results
	if "`univariate'"!="" {
		if "`by'"=="" {
			UniVar   `varlist' if `touse' `wght'
		}
		else {
			UniVarby `varlist' if `touse' `wght', ///
							by(`by') `totalonly'
		}
		return add
	}

	if "`bivariate'"!="" {
		if "`by'"=="" {
			BiVar   `varlist' if `touse' `wght'
		}
		else {
			BiVarby `varlist' if `touse' `wght', ///
							by(`by') `totalonly'
		}
		return add
	}

	if "`by'"=="" {
		MVN   `varlist' if `touse' `wght', stats(`stats')
	}
	else {
		MVNby `varlist' if `touse' `wght', ///
				stats(`stats') by(`by') `totalonly'
	}
	return add
end

// ----------------------------------------------------------------------------

program ParseStats, sclass
	args stats statistics all

	if `"`stats'"'!="" & `"`statistics'"'!="" {
		dis as err "stats() and statistics() are synonyms"
		exit 198
	}
	if "`all'"!="" & `"`stats'`statistics'"'!="" {
		dis as err "all may not be combined with stats()"
		exit 198
	}
	if `"`statistics'"'!="" {
		local stats `statistics'
	}
	if "`all'"!="" {
		local stats all
	}

	local 0 ,`stats'
	syntax [, all DHansen HZirkler KUrtosis SKewness ]

	if "`all'"!="" {
		local sts dhansen hzirkler kurtosis skewness
	}
	else {
		local sts `dhansen' `hzirkler' `kurtosis' `skewness'
	}
	if "`stats'"=="" {
		local sts dhansen
	}

	sreturn clear
	sreturn local stats `sts'
end

// ----------------------------------------------------------------------------
// Univariate normality
// ----------------------------------------------------------------------------

program UniVar, rclass
	sktest `0', nodisplay

	dis as txt _n "Test for univariate normality"
	tempname tmpmat
	mat `tmpmat' = r(Utest)
	Skt_Out `tmpmat'
	return matrix Utest = `tmpmat'
end


program UniVarby, rclass
	syntax varlist if [fw], by(varlist) [ missing totalonly ]

	tempvar g
	tempname N CUtest tmpm

	if ("`weight'"!="") local wght [`weight'`exp']

	local k: list sizeof varlist
	qui egen `g' = group(`by') `if', missing label
	qui tab `g' `if' `wght', matcell(`N')
	local m = rowsof(`N')
	if `m'==1 {
		dis as err "only one group"
		exit 198
	}
	matrix `CUtest' = J(`k',4,0)

	if ("`totalonly'"=="") {
		dis as txt _n "Test for univariate normality"
	}

	forvalues j = 1/`m' {
		sktest `varlist' `if' & (`g'==`j') `wght', nodisplay

		if ("`totalonly'"=="") {
			local vl: label (`g') `j'
			if ("`vl'"=="`j'") local vl ""
			local disstr  `"{p 2 8}Group `j' (N="'
			local Npart = `N'[`j',1]
			local disstr `"`disstr'{res:`Npart'}): "'
			local ii 1
			foreach var of local by {
				if `ii' > 1 {
					local disstr `"`disstr', "'
				}
				local disstr `"`disstr'"' `"`var' = "' `"`: word `ii' of `vl' "'"'
				local ++ii
			}
				dis as txt _n `"`disstr'"'

			mat `tmpm' = r(Utest)
			Skt_Out `tmpm'
		}

		forvalues i=1/`k' {
			matrix `CUtest'[`i',1] = `CUtest'[`i',1] ///
					- 2*log(el(r(Utest),`i',1))
			matrix `CUtest'[`i',2] = `CUtest'[`i',2] ///
					- 2*log(el(r(Utest),`i',2))
			matrix `CUtest'[`i',3] = `CUtest'[`i',3] ///
					+ el(r(Utest),`i',3)
		}
	}

	forvalues i=1/`k' {
		matrix `CUtest'[`i',1] = chi2tail(2*`m',`CUtest'[`i',1])
		matrix `CUtest'[`i',2] = chi2tail(2*`m',`CUtest'[`i',2])
		matrix `CUtest'[`i',4] = chi2tail(2*`m',`CUtest'[`i',3])
	}
	matrix rownames `CUtest' = `varlist'
	matrix colnames `CUtest' = Pr(Skewness) Pr(Kurtosis) chi2 P

	if ("`totalonly'"!="") {
		dis as txt _n "Test for univariate normality, " ///
	           "combined over `m' groups"
	}
	else {
		dis _n as txt "  Combined statistics"
	}
	Skt_Out `CUtest'

	return matrix CUtest = `CUtest'
end

// ----------------------------------------------------------------------------
// Normality tests for all pairs of variables in varlist
// ----------------------------------------------------------------------------

program BiVar, rclass
	syntax varlist if [fw]

	if ("`weight'"!="") local wght [`weight'`exp']

	tempname Btest
	local k : list sizeof varlist
	matrix `Btest' = J(`k'*(`k'-1)/2,3,.)

	tokenize "`varlist'"
	local ivw = 0
	forvalues iv = 1/`k' {
		forvalues iw = `=`iv'+1'/`k' {
			local ++ivw
			local rnames `rnames' ``iv'':``iw''

			MVN ``iv'' ``iw'' `if' `wght', ///
						stats(dhansen) nodisplay

			matrix `Btest'[`ivw',1] = r(chi2_dh)
			matrix `Btest'[`ivw',2] = r(df_dh)
			matrix `Btest'[`ivw',3] = r(p_dh)
		}
	}
	matrix rownames `Btest' = `rnames'
	matrix colnames `Btest' = chi2 df p

	dis _n as txt "Doornik-Hansen test for bivariate normality"
	BiTable `Btest'

	return matrix Btest = `Btest'
end


// Normality tests for all pairs of variables in varlist
program BiVarby, rclass
	syntax varlist if [fw], by(varlist) [ missing totalonly ]

	if ("`weight'"!="") local wght [`weight'`exp']

	tempname g Bg Btest N

	qui egen `g' = group(`by') `if', missing label
	qui tab `g' `if' `wght', matcell(`N')
	qui tab `g' `wght', matcell(`N')
	local m = rowsof(`N')
	if `m'==1 {
		dis as err "only one group"
		exit 198
	}

	local k : list sizeof varlist
	matrix `Btest' = J(`k'*(`k'-1)/2,3,0)
	matrix `Bg' = `Btest'

	if "`totalonly'"=="" {
		dis _n as txt "Doornik-Hansen test for bivariate normality"
	}

	tokenize "`varlist'"
	forvalues j = 1/`m' {
		local ivw = 0
		local rnames
		forvalues iv = 1/`k' {
			forvalues iw =`=`iv'+1'/`k' {
				local ++ivw
				local rnames `rnames' ``iv'':``iw''

				MVN ``iv'' ``iw'' `if' & `g'==`j' `wght', ///
					 nodisplay stats(dhansen)
				matrix `Bg'[`ivw',1] = r(chi2_dh)
				matrix `Bg'[`ivw',2] = r(df_dh)
				matrix `Bg'[`ivw',3] = r(p_dh)

				matrix `Btest'[`ivw',1] = `Btest'[`ivw',1] ///
					+ `Bg'[`ivw',1]
				matrix `Btest'[`ivw',2] = `Btest'[`ivw',2] ///
					+ `Bg'[`ivw',2]
			}
		}

		if "`totalonly'"=="" {
			matrix colnames `Bg' = chi2 df p
			matrix rownames `Bg' = `rnames'

			local vl : label (`g') `j'
			if ("`vl'"=="`j'") local vl ""
			local disstr  `"{p 2 8}Group `j' (N="'
			local Npart = `N'[`j',1]
			local disstr `"`disstr'{res:`Npart'}): "'
			local ii 1
			foreach var of local by {
				if `ii' > 1 {
					local disstr `"`disstr', "'
				}
				local disstr `"`disstr'"' `"`var' = "' `"`: word `ii' of `vl' "'"'
				local ++ii
			}
				dis as txt _n `"`disstr'"'

			BiTable `Bg'
		}
	}

	local ivw = 0
	forvalues iv = 1/`k' {
		forvalues iw = `=`iv'+1'/`k' {
			local ++ivw
			matrix `Btest'[`ivw',3] = ///
				chi2tail(`Btest'[`ivw',2],`Btest'[`ivw',1])
		}
	}
	matrix colnames `Btest' = "chi2 df p"
	matrix rownames `Btest' = `rnames'

	if ("`totalonly'"!="") {
		dis as txt _n ///
	 "Doornik-Hansen test for bivariate normality, combined over `m' groups"
	}
	else {
		dis _n as txt "  Combined statistics over `m' groups"
	}
	BiTable `Btest'

	return matrix Btest = `Btest'
end

program BiTable
	args B

	local n = rowsof(`B')
	local rnames : rownames `B'
	local req    : roweq `B'

	dis as txt _n "    {hline 27}{c TT}{hline 28}"
	dis as txt "    Pair of variables          {c |}      chi2    df   Prob>chi2"
	dis as txt "    {hline 27}{c +}{hline 28}"
	forvalues i = 1/`n' {
		local v1old `v1'
		gettoken v1 req    : req
		gettoken v2 rnames : rnames
		local dv1 = cond("`v1'"!="`v1old'",abbrev("`v1'",12),"")
		local dv2 = abbrev("`v2'",12)

		dis as txt "    {lalign 12:`dv1'}  {lalign 12:`dv2'} {c |} " ///
			 as res %9.2f `B'[`i',1] %6.0f `B'[`i',2] " " %10.4f `B'[`i',3]
	}
	dis as txt "    {hline 27}{c BT}{hline 28}"
end

// ----------------------------------------------------------------------------
// Tests for multivariate normality
// ----------------------------------------------------------------------------

program MVN
	syntax varlist if/ [fw] [, stats(str) noDisplay]

	tempname n InvS M S
	tempvar  touse w

	qui gen byte `touse' = `if'
	local k: list sizeof varlist

	local skew = `:list posof "skewness"      in stats' > 0
	local kurt = `:list posof "kurtosis"      in stats' > 0
	local hz   = `:list posof "hzirkler"  in stats' > 0
	local dh   = `:list posof "dhansen" in stats' > 0
	local ntest = `skew'+`kurt'+`hz'+`dh'

	gen `w' = 1
	if "`weight'" != "" {
		qui replace `w' `exp'
		local wght [`weight'=`w']
	}

	if `skew' | `kurt' | `hz' {
		qui matrix accum `S' = `varlist' if `touse' `wght', ///
							nocons dev means(`M')
		scalar `n' = r(N)
		clear results /* otherwise r(N) ends up in final r() */
		matrix `InvS' = syminv(`S'/`n')  // ml S, not unbiased S
		if diag0cnt(`InvS')>0 {
			dis as err "sample covariance matrix is singular"
			exit 506
		}
	}

	if (`skew') mata: Skewness("`varlist'","`M'","`InvS'","`touse'","`w'")
	if (`kurt') mata: Kurtosis("`varlist'","`M'","`InvS'","`touse'","`w'")
	if (`hz')   mata: HenzeZirkler("`varlist'","`M'","`InvS'","`touse'","`w'")
	if (`dh')   mata: DoornikHansen("`varlist'","`touse'","`w'")

	if ("`display'"!="") exit
	dis _n as txt "Test for multivariate normality" _n

	if (`skew') DiSkew r(mskew) r(df_mskew) r(chi2_mskew) r(p_mskew)
	if (`kurt') DiKurt r(mkurt)           r(z_mkurt)    r(p_mkurt)
	if (`hz')   DiHZ   r(hz)            r(z_hz)     r(p_hz)
	if (`dh')   DiDH          r(df_dh)  r(chi2_dh)  r(p_dh)
end


program MVNby, rclass
	syntax varlist if/ [fw], by(varlist) [ stats(str) noDisplay totalonly ]

	tempname InvS M N S g n
	tempvar  touse touse2 w

	local k: list sizeof varlist
	local skew = `:list posof "skewness"      in stats' > 0
	local kurt = `:list posof "kurtosis"      in stats' > 0
	local hz   = `:list posof "hzirkler"  in stats' > 0
	local dh   = `:list posof "dhansen" in stats' > 0
	local ntest = `skew'+`kurt'+`hz'+`dh'

	if "`weight'"!="" {
		qui gen `w' `exp'
		local wght [`weight'=`w']
	}
	else {
		gen `w' = 1
	}

	qui gen byte `touse' = `if'
	qui egen `g' = group(`by') if `touse', missing label
	qui tab `g' `wght' if `touse', matcell(`N')
	local m = rowsof(`N')

	if (`kurt') {
		tempvar chi2_b2p df_b2p p_b2p
		scalar `chi2_b2p' = 0
		scalar `df_b2p'   = 0
	}
	if (`skew') {
		tempvar chi2_b1p df_b1p p_b1p
		scalar `chi2_b1p' = 0
		scalar `df_b1p'   = 0
	}
	if (`hz') {
		tempvar chi2_hz df_hz p_hz
		scalar `chi2_hz'  = 0
		scalar `df_hz'    = 0
		scalar `p_hz'     = 0
	}
	if (`dh') {
		tempvar chi2_dh df_dh p_dh
		scalar `chi2_dh'  = 0
		scalar `df_dh'    = 0
	}

	if ("`totalonly'"=="") {
		dis _n as txt "Test for multivariate normality"
	}
	return clear

	forvalues j = 1/`m' {
		if (`skew' | `kurt' | `hz') {
			qui matrix accum `S' = `varlist' if `touse' `wght', ///
				nocons dev means(`M')
			scalar `n' = r(N)
			// ml S, not unbiased S
			matrix `InvS' = syminv(`S'/`n')

			if diag0cnt(`InvS')>0 {
				dis as err 	///
					"sample covariance matrix is singular"
				xit 506
			}
		}

		capture drop `touse2'
		qui gen `touse2' = `touse' & (`g'==`j')

		if `skew' {
			mata: Skewness("`varlist'","`M'","`InvS'","`touse2'","`w'")
			scalar `chi2_b1p' = `chi2_b1p' + r(chi2_mskew)
			scalar `df_b1p'   = `df_b1p'   + r(df_mskew)
		}
		if `kurt' {
			mata: Kurtosis("`varlist'","`M'","`InvS'","`touse2'","`w'")
			scalar `chi2_b2p' = `chi2_b2p' + r(z_mkurt)^2
			scalar `df_b2p'   = `df_b2p'   + 1
		}
		if `hz' {
			mata: HenzeZirkler("`varlist'","`M'","`InvS'","`touse2'","`w'")
			scalar `chi2_hz' = `chi2_hz'   + r(z_hz)^2
			scalar `df_hz'   = `df_hz'     + 1
		}
		if `dh' {
			mata: DoornikHansen("`varlist'","`touse2'","`w'")
			scalar `chi2_dh' = `chi2_dh'   + r(chi2_dh)
			scalar `df_dh'   = `df_dh'     + r(df_dh)
		}

		if ("`display'"=="" & "`totalonly'"=="") {
			local vl : label (`g') `j'
			if ("`vl'"=="`j'") local vl ""
			local disstr  `"{p 2 8}Group `j' (N="'
			local Npart = `N'[`j',1]
			local disstr `"`disstr'{res:`Npart'}): "'
			local ii 1
			foreach var of local by {
				if `ii' > 1 {
					local disstr `"`disstr', "'
				}
				local disstr `"`disstr'"' `"`var' = "' `"`: word `ii' of `vl' "'"'
				local ++ii
			}
				dis as txt _n `"`disstr'"' _n

			if (`skew') DiSkew r(mskew) r(df_mskew) ///
					r(chi2_mskew) r(p_mskew)
			if (`kurt') DiKurt r(mkurt) r(z_mkurt) r(p_mkurt)
			if ( `hz' ) DiHZ   r(hz)            r(z_hz)     r(p_hz)
			if ( `dh' ) DiDH          r(df_dh)  r(chi2_dh)  r(p_dh)
		}
	}

	if (`skew') scalar `p_b1p' = chi2tail(`df_b1p',`chi2_b1p')
	if (`kurt') scalar `p_b2p' = chi2tail(`df_b2p',`chi2_b2p')
	if ( `hz' ) scalar `p_hz'  = chi2tail(`df_hz' ,`chi2_hz' )
	if ( `dh' ) scalar `p_dh'  = chi2tail(`df_dh' ,`chi2_dh' )

	if ("`display'"=="") {
		if ("`totalonly'"=="") {
			dis _n as txt "  Combined statistics for `m' groups" _n
		}
		else {
			dis _n as txt "Test for multivariate normality, " ///
				"combined over `m' groups" _n
		}
		if (`skew') DiComb "Mardia mSkewness" `df_b1p' `chi2_b1p' `p_b1p'
		if (`kurt') DiComb "Mardia mKurtosis" `df_b2p' `chi2_b2p' `p_b2p'
		if ( `hz' ) DiComb "Henze-Zirkler"    `df_hz'  `chi2_hz'  `p_hz'
		if ( `dh' ) DiComb "Doornik-Hansen"   `df_dh'  `chi2_dh'  `p_dh'
	}

	if (`skew') {
		return scalar chi2_mskew = `chi2_b1p'
		return scalar df_mskew   = `df_b1p'
		return scalar p_mskew    = `p_b1p'
	}
	if (`kurt') {
		return scalar chi2_mkurt = `chi2_b2p'
		return scalar df_mkurt   = `df_b2p'
		return scalar p_mkurt    = `p_b2p'
	}
	if (`hz') {
		return scalar chi2_hz  = `chi2_hz'
		return scalar df_hz    = `df_hz'
		return scalar p_hz     = `p_hz'
	}
	if (`dh') {
		return scalar chi2_dh  = `chi2_dh'
		return scalar df_dh    = `df_dh'
		return scalar p_dh     = `p_dh'
	}
end


program DiSkew
	args b1p df chi2 p

	#del ;
	dis as txt "    {lalign 16:Mardia mSkewness} = "
		 as res %9.0g `b1p'
		 as txt "{ralign 12:chi2({res:`=`df''})} ="
		 as res %9.3f `chi2'
		 as txt "   Prob>chi2 = "
		 as res %7.4f `p' ;
	#del cr
end

program DiKurt
	args b2p z p

	#del ;
	dis as txt "    {lalign 16:Mardia mKurtosis} = "
		 as res %9.0g `b2p'
		 as txt "{ralign 12:chi2({res:1})} ="
		 as res %9.3f `z'^2
		 as txt "   Prob>chi2 = "
		 as res %7.4f `p' ;
	#del cr
end

program DiHZ
	args HZ z p

	#del ;
	dis as txt "    {lalign 16:Henze-Zirkler} = "
		 as res %9.0g `HZ'
		 as txt "{ralign 12:chi2({res:1})} ="
		 as res %9.3f `z'^2
		 as txt "   Prob>chi2 = "
		 as res %7.4f `p' ;
	#del cr
end

program DiDH
	args df chi2 p

	#del ;
	dis as txt "    {lalign 16:Doornik-Hansen}   "
		 _skip(9)
		 as txt "{ralign 12:chi2({res:`=`df''})} ="
		 as res %9.3f `chi2'
		 as txt "   Prob>chi2 = "
		 as res %7.4f `p' ;
	#del cr
end

program DiComb
	args name df chi2 p

	#del ;
	dis as txt "    {lalign 16:`name'}   "
		 _skip(9)
		 as txt "{ralign 12:chi2({res:`=`df''})} ="
		 as res %9.3f `chi2'
		 as txt "   Prob>chi2 = "
		 as res %7.4f `p' ;
	#del cr
end

program Skt_Out // mimic -sktest- output, but with an indent
	args Utest indent

	if "`indent'" == "" local indent 4	// default to 4 space indent

	dis as txt ///
	    _n _col(`= `indent'+1') "{hline 13}{c TT}{hline 55}"	///
	    _n _col(`= `indent'+14') "{c |}"				///
	       _col(`= `indent'+50') "{hline 7} joint {hline 6}"	///
	    _n _col(`= `indent'+5') "Variable {c |}  Pr(Skewness)"	///
			"   Pr(Kurtosis)  adj chi2(2)    Prob>chi2"	///
	    _n _col(`= `indent'+1') "{hline 13}{c +}{hline 55}"

	local vnames : rownames `Utest'
	local i 0
	foreach v of local vnames {
		local ++i
		dis as txt _col(`= `indent'+1') %12s abbrev("`v'",12) ///
			   " {c |}" /// 
		    as res _col(`= 20+`indent'') %6.4f `Utest'[`i',1] ///
			   _col(`= 35+`indent'') %6.4f `Utest'[`i',2] ///
			   _col(`= 47+`indent'') %9.2f `Utest'[`i',3] ///
			   _col(`= 63+`indent'') %6.4f `Utest'[`i',4] 
	}
	dis as txt _col(`= `indent'+1') "{hline 13}{c BT}{hline 55}"
end

// ----------------------------------------------------------------------------
// Computation of tests in Mata
// ----------------------------------------------------------------------------

version 11

mata:

// ----------------------------------------------------------------------------
// Mardia mKurtosis
// ----------------------------------------------------------------------------

void Kurtosis( ///
	string scalar _vlist,
	string scalar _M,
	string scalar _InvS,
	string scalar _touse,
	string scalar _wvar )
{
	real matrix     InvS, X
	real rowvector  M, d
	real colvector  W
	real scalar     i, k, n, rank, b2p, z_b2p, p_b2p

	M    = st_matrix(_M)
	InvS = st_matrix(_InvS)
	rank = cols(InvS) - diag0cnt(InvS)

	// st_view(X=., ., st_varindex(tokens(_vlist)), _touse)
	X = st_data(., st_varindex(tokens(_vlist)), _touse)
	// st_view(W=., ., _wvar, _touse)
	W = st_data(., _wvar, _touse)

	// get b2p

	k   = cols(X)
	n   = sum(W)
	b2p = 0
	for (i=1; i<=rows(X); i++) {
		d   = X[i,.]-M
		b2p = b2p + W[i]*(d*InvS*d')^2
	}

	// limiting distribution b2p: see Rencher (2002, eq. 4.39)

	b2p   = b2p/n
	z_b2p = (b2p-k*(k+2)) / sqrt(8*k*(k+2)/n)
	p_b2p = 2*normal(-abs(z_b2p))

	// return

	st_numscalar("r(mkurt)",   b2p)
	st_numscalar("r(z_mkurt)", z_b2p)
	st_numscalar("r(chi2_mkurt)", z_b2p^2)
	st_numscalar("r(p_mkurt)", p_b2p)
	st_numscalar("r(rank_mkurt)",  rank)
}

// ----------------------------------------------------------------------------
// Mardia mSkewness
// ----------------------------------------------------------------------------

void Skewness( ///
	string scalar _vlist,
	string scalar _M,
	string scalar _InvS,
	string scalar _touse,
	string scalar _wvar )
{
	real matrix     InvS, X
	real rowvector  d, M
	real colvector  md, W
	real scalar     i, j, k, n, rank, b1p, chi2_b1p, df_b1p, p_b1p

	M    = st_matrix(_M)
	InvS = st_matrix(_InvS)
	rank = cols(InvS) - diag0cnt(InvS)

	// st_view(X=., ., st_varindex(tokens(_vlist)), _touse)
	X = st_data(., st_varindex(tokens(_vlist)), _touse)
	// st_view(W=., ., _wvar, _touse)
	W = st_data(., _wvar, _touse)

	// get b1p

	k   = cols(X)
	n   = sum(W)
	b1p = 0
	for (i=1; i<=rows(X); i++) {
		d   = X[i,.]-M
		md  = InvS*d'
		b1p = b1p + (W[i]^2)*(d*md)^3
		for (j=1; j<i; j++)
			b1p = b1p + 2*W[i]*W[j]*((X[j,.]-M)*md)^3
	}
	b1p = b1p/(n*n)

	// limiting distribution b1p: see Rencher (2002, eq. 4.38)

	chi2_b1p = (((k+1)*(n+1)*(n+3))/((n+1)*(k+1)-6)) * (b1p/6)
	df_b1p   = k*(k+1)*(k+2)/6
	p_b1p    = chi2tail(df_b1p,chi2_b1p)

	// return

	st_numscalar("r(mskew)",      b1p)
	st_numscalar("r(chi2_mskew)", chi2_b1p)
	st_numscalar("r(df_mskew)",   df_b1p)
	st_numscalar("r(p_mskew)",    p_b1p)
	st_numscalar("r(rank_mskew)",     rank)
}

// ----------------------------------------------------------------------------
// HenzeZirkler
// ----------------------------------------------------------------------------

void HenzeZirkler( ///
	string scalar _vlist,
	string scalar _M,
	string scalar _InvS,
	string scalar _touse,
	string scalar _wvar )
{
	real matrix  InvS, X, rank
	real vector  D, M, W
	real scalar  b, b2, b4, b8, i, j, k, n, pZ, w,
			T, T1, T2, ET, EZ, VT, VZ, Z

	M    = st_matrix(_M)
	InvS = st_matrix(_InvS)
	rank = cols(InvS) - diag0cnt(InvS)

	// st_view(X=., ., st_varindex(tokens(_vlist)), _touse)
	X = st_data(., st_varindex(tokens(_vlist)), _touse)
	// st_view(W=., ., _wvar, _touse)
	W = st_data(., _wvar, _touse)

	n = sum(W)
	k = cols(X)

	// optimal bandwidth, see Henze-Zirkler: (2.5)

	b  = sqrt(1/2)*((2*k+1)*n/4)^(1/(k+4))
	b2 = b^2

	// compute T = nD, where D is given by Henze-Zirkler (2.6)

	T1 = T2 = 0
	for (i=1; i<=rows(X); i++) {
		D  = X[i,.]-M
		T2 = T2 + W[i]*exp((-0.5*b2/(1+b2))*D*InvS*D')

		// get rid of i=j case
		T1 = T1 + W[i]^2
		// now for j<i
		for (j=1; j<i; j++) {
			D  = X[i,.]-X[j,.]
			T1 = T1 + 2*W[i]*W[j]*exp(-0.5*b2*D*InvS*D')
		}
	}
	T  = T1/n - 2*((1+b2)^(-k/2))*T2 + n*((1+2*b2)^(-k/2))

	// E(T) and Var(T) according to Henze-Zirkler, theorem 3.2

	w  = (1+b2)*(1+3*b2)
	b4 = b^4
	b8 = b^8

	ET = 1 - ((1+2*b2)^(-k/2)) *
		(1 + k*b2/(1+2*b2) + (k*(k+2)*b4)/(2*(1+2*b2)^2))
	VT = 2*((1+4*b2)^(-k/2)) +
		  2*((1+2*b2)^(-k))*( 1 + (2*k*b4)/(1+2*b2)^2 +
		 (3*k*(k+2)*b8)/(4*(1+2*b2)^4) ) -
		  4*(w^(-k/2))*( 1 + 3*k*b4/(2*w) + (k*(k+2)*b8)/(2*w^2) )

	// log-normal approximation

	VZ = ln1p(VT/ET^2)
	EZ = ln(ET) - 0.5*VZ
	Z  = (ln(T)-EZ)/sqrt(VZ)
	pZ = 2*normal(-abs(Z))

	// return

	st_numscalar("r(hz)",   T)
	st_numscalar("r(E_hz)", ET)
	st_numscalar("r(V_hz)", VT)
	st_numscalar("r(z_hz)", Z)
	st_numscalar("r(p_hz)", pZ)
	st_numscalar("r(rank_hz)", rank)
}

// ----------------------------------------------------------------------------
// DoornikHansen
// ----------------------------------------------------------------------------

void DoornikHansen(
	string scalar _vlist,
	string scalar _touse,
	string scalar _wvar )
{
	real scalar    n, nv, beta, w2, d1, d2, a, c, k, DH, j,
			b1, b2, y, z1, alp, chi, z2
	real matrix    H, L, M, S, V, T, X, Xj, W

	// st_view(X=., ., st_varindex(tokens(_vlist)), _touse)
	X = st_data(., st_varindex(tokens(_vlist)), _touse)
	// st_view(W=., ., _wvar, _touse)
	W = st_data(., _wvar, _touse)

	n  = sum(W)
	nv = cols(X)

	// orthonormalize the variables

	M = mean(X,W)
	S = variance(X,W)*((n-1)/n)
	if (diag0cnt(invsym(S))>0) {
		errprintf("sample covariance matrix is singular\n")
		exit(506)
	}
	V = (diagonal(S):^(-0.5))'
	symeigensystem(corr(S), H=., L=.)
	X = ((X:-M):*V)*(H:*(L:^(-0.5)))*H'

	// used in translating skewness b1 into z1

	beta = (3*(n^2+27*n-70)*(n+1)*(n+3))/((n-2)*(n+5)*(n+7)*(n+9))
	w2   = -1 + sqrt(2*(beta-1))
	d1   = (0.5*log(w2))^(-0.5)

	// used in translating kurtosis b2 into z2

	d2 = (n-3)*(n+1)*(n^2+15*n-4)
	a  = ((n-2)*(n+5)*(n+7)*(n^2+27*n-70))/(6*d2)
	c  = ((n-7)*(n+5)*(n+7)*(n^2+2*n-5))/(6*d2)
	k  = ((n+5)*(n+7)*(n^3+37*n^2+11*n-313))/(12*d2)

	// collect univariate statistics

	T = J(nv,4,.)
	DH = 0
	for (j=1; j<=nv; j++) {
		Xj = X[.,j]
		b1 = mean(Xj:^3, W)
		b2 = mean(Xj:^4, W)

		y  = b1 * sqrt(((w2-1)*(n+1)*(n+3)) / (12*(n-2)) )
		z1 = d1*log(y+sqrt(1+y^2))

		alp = a + b1^2*c
		chi = abs(2*k*(b2-1-b1^2))
		z2  = ((chi/(2*alp))^(1/3) - 1 + 1/(9*alp))*sqrt(9*alp)

		T[j,.] = (b1,b2,z1,z2)
		DH  = DH + z1^2 + z2^2
	}

	// return ...

	st_numscalar("r(chi2_dh)", DH)
	st_numscalar("r(df_dh)", 2*nv)
	st_numscalar("r(p_dh)", chi2tail(2*nv,DH))
	st_matrix("r(U_dh)", T)
	st_matrixrowstripe("r(U_dh)", (J(nv,1,""),tokens(_vlist)') )
	st_matrixcolstripe("r(U_dh)", ("","b1"\"","b2"\"","z1"\"","z2"))
}
end
exit

