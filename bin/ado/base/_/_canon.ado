*! version 1.3.2  03feb2015
program define _canon, eclass byable(recall)
	version 9

	local options `"Level(cilevel) STDCoef COEFMatrix Format(string) NOTESTs TESTs(numlist ascending integer >0)"'
	
	if _caller() < 9 {
		canon_8 `*'
		exit
	}

	CheckLevel `0'

	if !replay() {
		local cmdline : copy local 0
		if bsubstr("`1'",1,1)=="(" {
			GetEq `0'
			local eq1 `s(name)'
			local vl1 `s(varlist)'
			local nl1 : word count `vl1'
			
			GetEq `s(rest)'
			local eq2 `s(name)'
			local vl2 `s(varlist)'
			local nl2 : word count `vl2'
			
			local 0 `"`s(rest)'"'
			sret clear
			if "`eq1'" == "" {
				local eq1 "u"
			}
			if "`eq2'"== "" { 
				local eq2 "v"
			}
		}
		else {
		/* this seems to be antiquated syntax for specifying equations
		   via the eq command, from Stata 5 */
			local iseq True
			gettoken eq1 0 : 0, parse(" ,")
			gettoken eq2 0 : 0, parse(" ,")
			if "`eq2'" == "," {
				di as err "equation   not found"
				exit 111
			}
		}

		syntax [aw fw] [if] [in] [, `options' noConstant	///
			LC(numlist int min=1 max=1) 			///
			FIrst(numlist int min=1	max=1) ]
	
		local constan `constant'

		if "`constan'"=="" { 
			local dev "dev"
		}
		else 	local nocons "nocons" 

		if `"`stdcoef'"'!="" & `"`coefmatrix'"'!="" {
			di as err "cannot specify stdcoef and coefmatrix " ///
				"options together"
			error(198)
		}
		if `"`stdcoef'"'=="" & `"`coefmatrix'"'=="" & `"`format'"' != "" {
			di as err "format() may only be specified with stdcoef or coefmatrix"
			exit(198)
		}
		if "`format'" =="" {
			local format format(%8.4f)
		} 
		else {
			quietly di `format' 0
			local format format(`format')
		}
	
		marksample touse

		if "`iseq'"=="True" {
		/* this seems to be antiquated syntax for specifying equations
		   via the eq command, from Stata 5 */
			eq ? `eq1'
			local vl1 `"`r(eq)'"'
			local eq1 `"`r(eqname)'"'
			local nl1 : word count `vl1'
			eq ? `eq2'
			local vl2 `"`r(eq)'"'
			local eq2 `"`r(eqname)'"'
			local nl2 : word count `vl2'
		}

		markout `touse' `vl1' `vl2'

		if "`lc'"!="" & "`first'"!="" {
			di as err ///
			"options lc() and first() may not be specified together"
			exit 198
		}
		if "`notests'"!="" & "`tests'"!="" {
			di as err ///
		      "options test() and notests may not be specified together"
			exit 198
		}
		local ncc = min(`nl1', `nl2')
		if "`lc'"!="" {
			if `lc' > `ncc' | `lc' < 1 {
				di as err "lc() must be one "	///
				"of the `ncc' "	///
				"canonical correlations"
				exit 198
			}
		}
		if "`first'" !="" {
			if `first' > `ncc' {
				di as err "first() cannot be greater "	///
				"than `ncc', the number of "	///
				"canonical correlations"
				exit 198
			}
			if `first' < 1 {
				di as err "first() must be greater " ///
				"than 0"
				exit 198
			}
		}
		if "`tests'"!="" {
			local ltest : word count `tests'
			local ltest : word `ltest' of `tests'
			if (`ltest' > `ncc') {
				if `ncc' == 1 {
		di as err "test() may only test the one canonical correlation"
					exit 125
				}
				else {
	di as err "test() may only test the `ncc' canonical correlations"
					exit 125
				}
			}
		}


		tempname bigABC ABC A B C Ai Ci T TR TC TCR L LL SD V SD1 SD2
		tempname sse t r2 tt ccor foo D1 D2
		tempname corr_ind corr_dep corr_mixed
		tempvar xx yy

		/* `ABC' is almost the covariance matrix for the two
		    variable sets, all it needs is to divide by nobs-1 */
		qui capture mat accum `ABC' = `vl2' `vl1' if `touse' /*
			*/ [`weight'`exp'] , nocons `dev'
		if _rc == 2000 {
			di as error "insufficient observations"
			exit 2000
		}
		else{
			if _rc {
			 	return _rc
			}
		}
		capture matrix `foo' = cholesky(`ABC')
		if _rc == 506 {
			di as error "matrix not positive definite"
			di as error "failure for overall model"
			exit 506
		} 
		local nobs = r(N)
		local nobs1 = `nobs' - 1
		scalar `sse' = 1/(`nobs1')
		mat def `ABC' = `ABC' * `sse' /* convert to covariance */
		local v2e = rowsof(`ABC')
		local v1e : word count `vl2'
		local p `v1e'
		local q = `v2e' - `v1e' 
		local v2 = `v1e' + 1
		mat `SD' = vecdiag(`ABC')
		mat `ABC' = corr(`ABC')  /* correlation transform */
		mat `A' = `ABC'[1..`v1e',1..`v1e'] /* first quadrant 
				correlations of first variable set */
		matrix `corr_dep' = `A'
		mat `B' = `ABC'[1..`v1e',`v2'..`v2e'] /* off diagonal 
				correlations between first and second 
				variable set */
		matrix `corr_mixed' = `B'
		mat `C' = `ABC'[`v2'..`v2e',`v2'..`v2e'] /* last quadrant 
				correlations of last variable set */
		matrix `corr_ind' = `C'
		mat `Ai' = syminv(`A')
		mat `Ci' = syminv(`C')
		local n2e = `v2e' - `v1e'
		if (`n2e' > `v1e') { /* first varlist is shorter */
			local r1list "vl1"
			local r2list "vl2"
		 	* looking for left symeigenvectors of B' Ai B Ci
			mat `SD1' = `SD'[1,`v2'..`v2e'] /* variances vars1*/
			mat `SD2' = `SD'[1,1..`v1e']  /* variances vars2 */
			mat `D1' = `SD1'
			mat `D2' = `SD2'
			mat `T' = (`B'' * `Ai') * `B'
			mat `L' = cholesky(`Ci')
			mat `T' = (`L'' * `T') * `L'
			mat symeigen `V' `LL' = `T'
			mat `LL' = `LL'[1,1..`v1e']
			local n2s = `v1e' +1
			local XXi `Ai'
			local YYi `Ci'
			local XY `B''
		}
		else { /* second varlist is shorter */
			local r1list "vl2"
			local r2list "vl1"
			local x `eq1'
			local eq1 `eq2'
			local eq2 `x'
			* looking for left symeigenvectors of B Ci B' Ai
			mat `SD2' = `SD'[1,`v2'..`v2e']
			mat `SD1' = `SD'[1,1..`v1e']
			mat `D1' = `SD1'
			mat `D2' = `SD2'
			mat `T' = (`B' * `Ci') * `B''
			mat `L' = cholesky(`Ai')
			mat `T' = (`L'' * `T') * `L'
			mat symeigen `V' `LL' = `T'
			mat `LL' = `LL'[1,1..`n2e']
			local n2s = `n2e' + 1
			local XXi `Ci'
			local YYi `Ai'
			local XY `B'
			local flip True
		}
		mat colnames `SD1' = `eq1':
		mat `SD1' = syminv(cholesky(diag(`SD1')))
		mat `V' = `L' * `V'       /* Undo the similarity transform */

		mat `L' = (`V''*`XY')*`XXi' 	/* the other lin. comb. */
		mat colnames `SD2' = `eq2':
		mat `SD2' = syminv(cholesky(diag(`SD2')))
		mat `V' = `V'' * `SD1'
		local lcs = `n2s' - 1
		if "`lc'"!="" {
			local beglc `lc'
			local endlc `lc'
		}
		else {
			local beglc 1
			local endlc `lcs'
			if "`first'"!="" {
				local endlc `first'
			}
		}
		mat `L' = `L' * `SD2'
		tempname zerom zeromT
		forvalues kc = `beglc'/`endlc' {
			tempname V`kc' L`kc' T`kc' TC`kc' XXi2 YYi2
			mat `V`kc'' = `V'[`kc',1...]  
			mat `L`kc'' = `L'[`kc',1...]  
		/* The linear combination we want above */	
			scalar `r2' = `LL'[1,`kc']
			scalar `t' = 1 / sqrt(`r2')
			mat `L`kc'' = `L`kc'' * `t'
			mat `T`kc'' = `L`kc'', `V`kc''
			local nv : colnames(`T`kc'')
			local ne : coleq(`T`kc'')
			local ne2
			foreach equa of local ne {
				local ne2  `ne2' `equa'`kc'
			}
		/* conditional variance calculation */
			mat `XXi2' = `SD2' * (`XXi' * `SD2')
			scalar `tt' = (1 - `r2')/`r2'/(1/`sse'-colsof(`XXi'))
			mat `XXi2' = `XXi2' * `tt'
			mat `YYi2' = `SD1' * (`YYi' * `SD1')
			scalar `tt' = (1 - `r2')/`r2'/(1/`sse'-colsof(`YYi'))
			mat `YYi2' = `YYi2' * `tt'
			mat rownames `ABC' = `nv'
			mat roweq `ABC' = `ne2'
			mat colnames `ABC' = `nv'
			mat coleq `ABC' = `ne2'
			mat coleq `T`kc'' = `ne2'
			mat `ABC' = `ABC' * 0
			mat subst `ABC'[1,1] = `XXi2'
			mat subst `ABC'[`n2s',`n2s'] = `YYi2'

						/* post results */
			matrix `ccor' = vecdiag(cholesky(diag(`LL')))
			tempname tp1 tp2
			forvalues eqn = 1/2 {
				local mqn = `eqn'
				if "`flip'"!="" {
					local mqn = mod(`eqn',2) + 1
				}
				mat `tp2' = `T`kc''[1, "`eq`mqn''`kc':"]
				matrix `tp1' = cholesky(diag(`D`mqn''))*`tp2''
				local tp1r = rowsof(`tp1')
				local tp1c = colsof(`tp1')
				local pos
				forvalues ii = 1/`tp1r' {
					forvalues jj = 1/`tp1c' {
						if `tp1'[`ii', `jj'] > 0 {
							local pos pos
						}
					}
				}
				if "`pos'" =="" {
					matrix `tp1' = -1*`tp1'
				}
				local mynms : colfullnames `tp2'
				mat roweq `tp1' = `mynms'
				if `eqn' == 1 {
					mat `TC`kc'' = `tp1''
				}
				else {
					mat `TC`kc'' = (`TC`kc'', `tp1'')
				}
			}
			if "`flip'"=="" {		/* sic */
				mat `T`kc'' = (`T`kc''[1,"`eq1'`kc':"], `T`kc''[1,"`eq2'`kc':"])
				tempname Z
				mat `Z' = `ABC'["`eq1'`kc':", "`eq2'`kc':"] * 0
				mat `ABC' = ( /*
				*/ (`ABC'["`eq1'`kc':","`eq1'`kc':"], `Z'  ) \ /*
				*/ (`Z'', `ABC'["`eq2'`kc':","`eq2'`kc':"] ))
			}
			if `kc'==`beglc' {
				mat `bigABC' = `ABC'
				mat `T' = `T`kc''
				mat `TR' = (`T`kc'')'
				mat `TC' = `TC`kc''
				mat `TCR' = (`TC`kc'')'
				mat `zerom' = `ABC'*0
				mat `zeromT' = `zerom'
			}
			else {
				local nenew : coleq(`ABC')
				mat coleq `zerom' = `nenew'
				mat roweq `zeromT' = `nenew'
			mat `bigABC' = `bigABC', `zerom' \ `zeromT', `ABC'
				mat `T' = `T' ,  `T`kc''
				mat `TR' = `TR', (`T`kc'')'
				mat `TC' = `TC' ,  `TC`kc''
				mat `TCR' = `TCR', (`TC`kc'')'
				mat `zerom' = `zerom' \ `ABC'*0
				mat `zeromT' = `zeromT', `ABC'*0
			}
		}
		/* get labels right, no equations here, just variables */
		mat roweq `TCR' = "_:"
		local myrownms : rownames `TCR'
		matrix roweq `TR' = "_:"
		matrix rownames `TR' = `myrownms'
		
		/* Now lets compute the canonical loadings 
		   We have A = cov matrix for first set of vars
		   We have C = cov matrix for second set of vars
		   We have SD1 and SD2 which are diagonal matrices
		   of one over standard deviations of the two
		   equations sets.  SD1 goes with eq1 and SD2 with
		   eq2, but this may have been reversed due to 
		   the flip ... beware.
		   We have the coefficients in TR -- we'll
		   have to subdivide to get the individual coeffs.

		   I'm using _Applied Multivariate Statistical Analysis_
		   3rd Ed. by R. A. Johnson and D. W. Wichern, 
		   Prentice Hall, 1992 as a reference here.
		   Section 10.3, pp 466-467 in my edition
		*/
		local colA : colnames `A' /* a is correlation matrix (rho
		or R) for a variable set, C is for the other set,
		and B is the cross correlations.  Since there can be a flip
		depending on which variable set is shortest, all
		I'm doing here is figuring out what goes where.  */
		if "`colA'" == "``r1list''" {
			local SDA `SD1'
			local SDC `SD2'
			local rAlist ``r1list''
			local rClist ``r2list''
		}
		else{
			local SDA  `SD2'
			local SDC  `SD1' 
			local rAlist ``r2list''
			local rClist ``r1list''
		}
		/* now extract submatrices from TR.  TR is the matrix
		of coefficients from the original variables to make
		the canonical variables.  coefA, coefC are what
		Johnson and Wichern are calling A and B in U=AX(1)
		and V=BX(2).*/
		local wc : word count `rAlist'
		local w1 : word 1 of `rAlist'
		local last : word `wc' of `rAlist'
		tempname coefA coefC stdcoefA stdcoefC
		matrix `coefA' = `TR'["`w1'".."`last'", 1...]
		matrix `stdcoefA' = `TCR'["`w1'".."`last'", 1...]
		local wc : word count `rClist'
		local w1 : word 1 of `rClist'
		local last : word `wc' of `rClist'
		matrix `coefC' = `TR'["`w1'".."`last'", 1...]
		matrix `stdcoefC' = `TCR'["`w1'".."`last'",1...]
		tempname canloadA canloadC SDAi SDCi canloadM canloadM2 
		/* SDAi is what Johnson and Wichern call V^(1/2) 
		   SDA is V^(-1/2).  We need SDAi to convert
		   our correlation matrix to covariance
		   via cov = V^(1/2) corr V^(1/2) 
		   Then we calculate the loadings via
		   rholoadA = A*cov*V^(-1/2) in book speak or
		   canloadA = coefA'*SDAi*A*SDAi*SDA here.
		            = coefA'*SDAI*A
		*/
		matrix `SDAi' = syminv(`SDA')
		matrix `SDCi' = syminv(`SDC')
		matrix `canloadA' = `coefA''*`SDAi'*`A'
		matrix `canloadC' = `coefC''*`SDCi'*`C'
		matrix `canloadM' = `coefA''*`SDAi'*`B'
		matrix `canloadM2' = `coefC''*`SDCi'*`B''
		eret post `T' `bigABC', dof(`nobs1') esample(`touse')
		if _caller()<6 {
			mat S_E_ccor = `ccor'
		}
		eret matrix corr_mixed = `corr_mixed'
		eret matrix corr_var2 = `corr_dep'
		eret matrix corr_var1 = `corr_ind'
		eret matrix ccorr `ccor'
		mat rownames `TC' = ":1"
*		eret matrix bstdcoef `TC'
		/* put correct column labels on 
		these matrices and save them out. */
		local colnam : colnames `coefC'
		if `"`lc'"' =="" {
			local wc : word count `colnam'
			local ncn ":1"
			forv i=2/`wc' {
				local ncn "`ncn' :`i'"
			}
			matrix colnames `coefC' = `ncn'
			matrix colnames `coefA' = `ncn'
			matrix colnames `stdcoefC' = `ncn'
			matrix colnames `stdcoefA' = `ncn'
		}
		else {
			matrix colnames `coefC' = ":`lc'"
			matrix colnames `coefA' = ":`lc'"
			matrix colnames `stdcoefA' = ":`lc'"
			matrix colnames `stdcoefC' = ":`lc'"
		}
		eret matrix stdcoef_var2 = `stdcoefA', copy
		eret matrix stdcoef_var1 = `stdcoefC', copy
		eret matrix rawcoef_var2 = `coefA',copy
		eret matrix rawcoef_var1 = `coefC',copy
		/* put correct row labels on these matrices and
		save them out */
		if `"`lc'"' == "" {
			mat rownames `canloadC' = `ncn'
			mat rownames `canloadA' = `ncn'
			mat rownames `canloadM' = `ncn'
			mat rownames `canloadM2' = `ncn'
		}
		else {
			mat rownames `canloadC' = ":`lc'"
			mat rownames `canloadA' = ":`lc'"
			mat rownames `canloadM' = ":`lc'"
			mat rownames `canloadM2' = ":`lc'"
		}
			
		/* I'd like these all transposed
		before putting them out, so let's do that... */
		mat `canloadC' = `canloadC''
		mat `canloadA' = `canloadA''
		mat `canloadM' = `canloadM''
		mat `canloadM2' = `canloadM2''
		eret matrix canload21 `canloadM2'
		eret matrix canload12 `canloadM'
		eret matrix canload22 `canloadA'
		eret matrix canload11 `canloadC'
		/* double save in S_E_<stuff> and e()  */
		eret scalar N = `nobs'
		eret scalar df = `nobs1'
		eret scalar n_cc = `ncc'
		if "`lc'" != "" {
			eret scalar n_lc = `lc'
			eret scalar n_cc = 1
			
		}
		if `"`first'"' != "" {
			eret scalar n_cc = `first'
		}
		global S_E_nobs `e(N)'
		global S_E_tdf `e(df)'
		global S_E_lc `e(n_lc)'

		eret local estat_cmd "canon_estat"
		eret local predict "canon_p"
		eret local cmdline `"canon `cmdline'"'
		eret local cmd "canon"
		eret local wtype "`weight'"
		eret local wexp "`exp'"
		global S_E_cmd "canon"
		GetTests `p' `q' `nobs'
		MoreTests `p' `q' `nobs'
		
	}
	else {
		if `"`e(cmd)'"'!="canon" { 
			error 301 
		}
		if _by() { 
			error 190 
		}
		syntax [, `options' ]
		if `"`stdcoef'"'!="" & `"`coefmatrix'"'!="" {
			di as err "options stdcoef and coefmatrix " ///
				"may not be specified together"
			error(198)
		}
		if `"`stdcoef'"'=="" & `"`coefmatrix'"'=="" & ///
							`"`format'"' != "" {
			di as err ///
		    "format() may only be specified with stdcoef or coefmatrix"
			exit(198)
		}
		if "`format'" =="" {
			local format format(%8.4f)
		} 
		else {
			quietly di `format' 0
			local format format(`format')
		}
		if "`notests'"!="" & "`tests'"!="" {
			di as err ///
		    "options test() and notests may not be specified together"
			exit 198
		}
		di
		local lcs = e(n_cc)
	}
	/* Display output now that calculations are done */
	local lcl 76 /* line length */
	if `"`stdcoef'"' != "" {
		di _n in gr "Canonical correlation analysis " _col(53) ///	
		"Number of obs = " in ye %10.0f e(N)
		di _n in gr "Standardized coefficients for the first variable set" 
		matlist e(stdcoef_var1), left(4) `format' border(bottom)
		di
		di _n in gr "Standardized coefficients for the second variable set"
		matlist e(stdcoef_var2), left(4) `format' border(bottom)
		di
		di in smcl in gr "{hline `lcl'}"
	}
	else if `"`coefmatrix'"' != "" {
		di _n in gr "Canonical correlation analysis " _col(53) ///	
		"Number of obs = " in ye %10.0f e(N)
		di _n in gr "Raw coefficients for the first variable set"
		matlist e(rawcoef_var1), left(4) `format' border(bottom)
		di _n in gr "Raw coefficients for the second variable set"
		matlist e(rawcoef_var2), left(4) `format' border(bottom)
		di
		di in smcl in gr "{hline `lcl'}"
	}
	else {
		if "`lc'"!="" {
			di _n in gr "Linear combinations for canonical " ///
			"correlation " `lc'  _col(53) "Number of obs = " ///
			in ye %10.0f e(N)
		}
		else {
			di _n in gr "Linear combinations for canonical " ///
			"correlations " _col(53) "Number of obs = "     ///
			in ye %10.0f e(N)
		}	
		eret di, level(`level')
		di in gr _col(38) "(Standard errors estimated conditionally)"
	}
	di in gr "Canonical correlations:"
	mat list e(ccorr), nohead nonames noblank format(%9.4f)
	if "`notests'"=="" {
		di
		di in gr in smcl "{hline `lcl'}"
		di in gr "Tests of significance of all canonical correlations"
		tempname tmat
		mat define `tmat' = e(stat_m)
		di
		DisplayTest `tmat'
		foreach num of local tests {
			di in smcl in green  "{hline `lcl'}"
			if `num' < `lcs' {
di in gr "Test of significance of canonical correlations `num'-`lcs'"
			}
			else {
				if `num' == `lcs' {
di in gr "Test of significance of canonical correlation `lcs'"	
				}
			}
			if `num' <= `lcs' {
				di
				mat define `tmat' = e(stat_`num')
				mat rownames `tmat' = Wilks 
				DisplayTest `tmat'
			}
			else {
/* SHOULD NOT GET HERE */
di in gr "Cannot display tests for nonexistent canonical correlation `num'."
			}
		}
		di in smcl in green "{hline `lcl'}"
		di in smcl in gr "{ralign `lcl':e = exact, a = approximate, u = upper bound on F}"
	}
end

program CheckLevel
	syntax [anything] [aw fw] [if] [in] [, Level(str) STDCoef COEFMatrix *]
	if `"`level'"' != "" {
		if "`stdcoef'`coefmatrix'" != "" {
			di as err ///
			    "level() may be specified only with stderr"
			exit 198
		}
	}
end

/* Tests of subsequent canonical correlations after the first. */
program define MoreTests, eclass
	version 8.1
	local p `1'
	local q `2'
	local n `3'
	tempname ccorr
	mat `ccorr' = e(ccorr)
	local ncc = colsof(`ccorr')
	tempname df1 df2 w t wilks wilksF fu testm
	scalar `wilks' = 1
	forvalues i = 1/`ncc' {
		scalar `wilks' = `wilks'*(1-`ccorr'[1,`i']^2)
	}
	forvalues i = 1/`ncc' {
		local pn `p' - `i' + 1
		local qn `q' - `i' + 1
		scalar `df1' = (`pn')*(`qn')
		scalar `w' = `n' - (`p' + `q' + 3)/2.0
		if `pn'*`qn' == 2 {
			scalar `t' = 1
		}
		else{ 
			scalar `t' = sqrt(((`pn')^2 *(`qn')^2 -4)/	///
			((`pn')^2 + (`qn')^2 - 5))
		}
		if `ncc' - `i' + 1 <= 2 {
			local wEx = 1
		} 
		else {
			local wEx = 0
		}
		scalar `df2' = `w'*`t' - .5*((`pn')*(`qn')) + 1
		if `i' > 1 {
			scalar `wilks' = `wilks'/(1-`ccorr'[1,`i'-1]^2)
		}
		scalar `fu' = (`wilks')^(1/`t')
		scalar `wilksF' = ((1-`fu')/`fu')*(`df2'/`df1')
		mat `testm' = (`wilks', `df1', 	///
			`df2', `wilksF', fprob(`df1', `df2', `wilksF'), `wEx')
		mat colnames `testm' =  statistic df1 df2 F pvalue exact
		mat rownames `testm' = Wilks
		ereturn matrix stat_`i' = `testm'
	}
end
		
		

/* Notes: s = min(p,q) = ncc = colsof(`ccorr')
          m = 1/2(max - s - 1)
	  N = 1/2(n - q - p - 2) = 1/2(n - max - ncc - 2)
	  see p. 368 Rencher, A. _Methods of Multivariate Analysis_ 2nd Ed.
	These relationships are used to calculate many of the df's for
	the various statistics
*/
program define GetTests, eclass
	version 8.0
	local p `1'
	local q `2'
	local n `3'
	local max = max(`p', `q')
	tempname df1 df2 w t ccorr wilks wilksF fo pillai pillaiF 
	tempname lawley lawleyF roy royF dfp1 dfp2 dfl2 dfr1 dfr2
	scalar `df1' = `p'*`q'
	scalar `w' = `n' - (`p' + `q' + 3)/2.0
	scalar `t' = sqrt(((`p')^2*(`q')^2 - 4)/((`p')^2 + (`q')^2 -5))
	if (`p'*`q' == 2) scalar `t' = 1
	scalar `df2' = `w'*`t'- .5*`p'*`q' + 1.0
	ereturn scalar df1 = `df1'
	ereturn scalar df2 = `df2'
	mat `ccorr' = e(ccorr)
	local ncc = colsof(`ccorr')
	if `ncc' <= 2 {
		local wEx = 1
	} 
	else {
		local wEx = 0
	}
	if `ncc' == 1 {
		local rEx = 1
	}
	else {
		local rEx = 0
	}
	scalar `wilks' = 1
	scalar `pillai' = 0
	scalar `lawley' = 0
	scalar `roy' = `ccorr'[1,1]^2
	scalar `roy' = `roy'/(1-`roy')
	forvalues i = 1/`ncc' {
		scalar `fo' = `ccorr'[1,`i']^2
		scalar `wilks' = `wilks'*(1-`fo')
		scalar `pillai' = `pillai' + `fo'
		scalar `lawley' = `lawley' + `fo'/(1-`fo')
	}
	scalar `fo' = (`wilks')^(1/`t')
	scalar `wilksF' = ((1-`fo')/`fo')*(`df2'/`df1')
	scalar `pillaiF' = `pillai'/`ncc'
	scalar `dfp1' = `max'*`ncc'  
	scalar `dfp2' = (`n' - `max' - 1)*`ncc'
	if ((`dfp1' == `df1') & (`dfp2' == `df2')) {
		local pEx = 1
	}
	else {
		local pEx = 0
	}
	scalar `pillaiF' = (`pillaiF'*`dfp2')/(`dfp1'*(1 - `pillaiF'))
	scalar `dfl2' = `ncc'*(`n'-`max'-`ncc' -2) + 2
	scalar `lawleyF' = `lawley'*`dfl2'/(`ncc'*`dfp1')
	if ((`dfp1' == `df1') & (`dfl2' == `df2')) {
		local lEx = 1
	}
	else {
		local lEx = 0
	}
	scalar `dfr1' = `max'
	scalar `dfr2' = `n' - `max' - 1
	scalar `royF' = `roy'*`dfr2'/(`dfr1')
	tempname testmat
	matrix `testmat' = (`wilks', `df1', `df2', `wilksF',	///
		fprob(`df1',`df2', `wilksF'), `wEx' \			///
		`pillai', `dfp1', `dfp2', `pillaiF',		///
		fprob(`dfp1',`dfp2',`pillaiF'), `pEx' \		///
		`lawley', `dfp1', `dfl2', `lawleyF', 		///
		fprob(`dfp1', `dfl2', `lawleyF'), `lEx' \		///
		`roy',`dfr1',`dfr2', `royF',			///
		fprob(`dfr1', `dfr2', `royF'), `rEx')
	mat colnames `testmat' = statistic df1 df2 F pvalue exact
	mat rownames `testmat' = Wilks Pillai Lawley Roy
	ereturn matrix stat_m = `testmat'
end
	

program define GetEq, sclass 
	sret clear
	gettoken open 0 : 0, parse("(") 
	if `"`open'"' != "(" {
		error 198
	}
	gettoken next 0 : 0, parse(")")
	while `"`next'"' != ")" {
		if `"`next'"'=="" { 
			error 198
		}
		local list `list'`next'
		gettoken next 0 : 0, parse(")")
	}
	sret local rest `"`0'"'
	tokenize `list', parse(" :")
	if "`2'"==":" {
		sret local name "`1'"
		mac shift 2
	}
	local 0 `*'
	syntax varlist
	sret local varlist "`varlist'"
end

program DisplayTest
	version 8.0
	args mat
	tempname tm
	local fo = rowsof(`mat')
	di in green in smcl "{col 26}Statistic {col 41}df1" 	///
	"{col 50}df2 {col 65}F {col 71}Prob>F"
	forvalues i = 1/`fo' {
		matrix `tm' = `mat'[`i', 1...]
		local test : rownames `tm'
		if "`test'" == "Wilks"  local test "Wilks' lambda"
		if "`test'" == "Pillai" local test "Pillai's trace"
		if "`test'" == "Lawley" local test "Lawley-Hotelling trace"
		if "`test'" == "Roy"    local test "Roy's largest root"
		if `mat'[`i',6] == 1 {
			local ex e /* exact */
		}
		else {
			if bsubstr("`test'",1,1)!="R" {
				local ex a /* approximate */
			}
			else {
				local ex u /* Roy's is upper bound */
			}
		}
		di in green %23s "`test' " ///
		in yellow %11.6g `mat'[`i',1] " " %8.0g `mat'[`i',2] 	///
			" " %8.0g `mat'[`i',3] " " %12.4f `mat'[`i',4] 	///
			" " %10.4f `mat'[`i',5] %2s "`ex'"
	}
end
