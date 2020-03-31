*! version 3.2.1  20dec2017
program define hausman, rclass
	version 8

// translate old syntax into new syntax

	gettoken tok : 0, parse(" ,")
	if `"`0'"' == "" | `"`tok'"' == "," {

		OldSyntax `0'
		local 0 `"`r(newsyntax)'"'
		if `"`0'"'=="" {
			exit 0
		}
	}

// process new syntax

	// undocumented options: syminv sigmaless reveq

	syntax [anything] [, Alleqs Constant SIGmamore SIGMALess FORCE  /*
	  */ SKipeqs(string) SYMINV EQuations(string) REVEQ 		/*
	  */ TCONsistent(str) TEFFicient(str) 				/*
	  */ df(numlist integer >0 <11000 max=1) ]
	/*
   	BEWARE:
   		<object>1  refers to the always-consistent estimator
   		<object>2  refers to the efficient-under-Ho estimator,
	*/

	if `"`: word count `anything''"'	== "1" {
		local anything `"`anything' ."'
	}
	est_expand `"`anything'"', min(1) max(2)
	local name1 : word 1 of `r(names)'
	local name2 : word 2 of `r(names)'
	if "`name1'" == "`name2'" {
		di as err "the two models need to be different"
		exit 198
   	}

   	local tname1 `tconsistent'
	if `"`tname1'"' == "" {
		local tname1 `name1'
	}
   	local tname2 `tefficient'
   	if `"`tname2'"' == "" {
		local tname2 `name2'
	}

	if `"`equations'"' != "" {
		local alleqs ""
		local skipeqs ""
 		Mlist `"`equations'"'
		local est1 `s(opt1)'
		local est2 `s(opt2)'
		if "`reveq'" != "" {
			local est2 `s(opt1)'
			local est1 `s(opt2)'
		}
	}

// extract information about models needed in test

	tempname hcurrent b1 V1 b2 V2 V12 s2_1 s2_2 res rank chi2 esample d se

	_est hold `hcurrent', nullok restore estsystem
	forvalues i = 1/2 {
		nobreak {
			if "`name`i''" != "." {
				est_unhold `name`i'' `esample'
			}
			else {
				_est unhold `hcurrent'
			}

			capture break noisily {
				if "`e(cmd2)'" != "" {
					local cmd`i' `e(cmd2)'
				}
				else {
					local cmd`i' `e(cmd)'
				}
				if (`"`e(clustvar)'"' != ""          ||	///
				    `"`e(vce)'"'  == "robust"        || ///
				    `"`e(wtype)'"'    == "pweight" ) &	///
				   `"`force'"' == "" {
					  display as err "{p}{bf:hausman} " ///
						"cannot be used with " ///
						"{bf:vce(robust)},  " ///
        					"{bf:vce(cluster} " ///
						      "{it:cvar}{bf:)}, " ///
						"or p-weighted data{p_end}"
					  exit 198
				}

				GetbV `name`i'' `b`i'' `V`i''
				if "`e(cmd)'" == "xtreg" {
					if "`e(model)'" == "fe" ||	///
					   "`e(model)'" == "ml" {
						scalar `s2_`i'' = e(sigma_e)
					}
					else {
						scalar `s2_`i'' = e(rmse)
					}
				}
				else {
					scalar `s2_`i'' = e(sigma)
					if `s2_`i'' == . {
						scalar `s2_`i'' = e(rmse)
					}
				}
			}
			local rc = _rc

			if "`name`i''" != "." {
				est_hold  `name`i'' `esample'
			}
			else {
				_est hold `hcurrent', nullok restore estsystem
			}
		}
		if `rc' {
			exit `rc'
		}
	}

// compute test statistic

	Strik0 `b1' `V1'
	Strik0 `b2' `V2'

	if `"`skipeqs'"' != "" {
		SkipEqs row `b1' `"`skipeqs'"'
		SkipEqs mat `V1' `"`skipeqs'"'
		SkipEqs row `b2' `"`skipeqs'"'
		SkipEqs mat `V2' `"`skipeqs'"'
	}
	else if `"`equations'"' != "" {
		Select `b1' `V1' "`est1'"
		Select `b2' `V2' "`est2'"
	}
	else if "`alleqs'" == "" {
		Get1steq row `b1'
		Get1steq mat `V1'
		Get1steq row `b2'
		Get1steq mat `V2'
	}

	if "`constant'" == "" {
		Rmcons `b1'
		Rmcons `V1'
		Rmcons `b2'
		Rmcons `V2'
	}

	if "`sigmamore'" != "" | "`sigmaless'" != "" {
		if `s2_1' == . | `s2_2' == . {
			di as err "Estimators do not save e(sigma) or e(rmse),"
			di as err "sigma option not allowed"
			exit 198
		}
		if "`sigmamore'" != "" {
			matrix `V1' = ((`s2_2'/`s2_1')^2) * `V1'
		}
		else {
			matrix `V2' = ((`s2_1'/`s2_2')^2) * `V2'
		}
	}

	capture MatConf `b1' `V1' `b2' `V2'
	if _rc {
		di as err "no coefficients in common; " ///
			"specify equations(matchlist)"
		di as err "for problems with different equation names."
		exit 498
	}

	matrix `V2' = `V1' - `V2'
	SymPosDef `V2'
	local posdef `r(posdef)'
	MatGinv `V12' `rank' : `V2' `syminv'
	matrix `res' = (`b1'-`b2') * `V12' * (`b1'-`b2')'
	scalar `chi2' = `res'[1,1]

// display test

	Abbrev tname1ab : `"`tname1'"'
	Abbrev tname2ab : `"`tname2'"'

	di _n as txt ///
		_col(18) "{hline 4} Coefficients {hline 4}" _n  ///
		_col(14) "{c |}" _col(21) "(b)" _col(34) "(B)"  ///
		_col(49) "(b-B)"                                ///
		_col(59) "sqrt(diag(V_b-V_B))" _n               ///
		_col(14) "{c |}" _col(17) %~12s `"`tname1ab'"'  ///
		_col(30) %~12s `"`tname2ab'"'                   ///
		_col(46) "Difference" _col(66) "S.E." _n        ///
			      "{hline 13}{c +}{hline 64}"


	local eqnames : coleq `b1', quote
	local eqnames : list clean eqnames
	local uniqeq : list uniq eqnames
	local numeq : word count `uniqeq'

	local names : colnames `b1'
	tokenize `"`names'"'

	local omit 0
	local i 1
	local ieq 0
	local ipos 1
	while `i' <= colsof(`b1') {

		if `numeq' > 1 {
			local eq : word `i' of `eqnames'
			if "`eq'" != "`holdeq'" {
				if `i' != 1 {
					di as txt "{hline 13}{c +}{hline 64}"
				}
				di as res "`eq'" _col(14) as txt "{c |}"
				local holdeq `eq'
				local ++ieq
				local ipos 1
			}
		}
		else	local ieq 1

		scalar `d'  = `b1'[1,`i'] - `b2'[1,`i']
		scalar `se' = sqrt(`V2'[`i',`i'])

		_ms_display, eq(#`ieq') el(`ipos') matrix(`b1') vsquish
		di as res _col(18) %9.0g `b1'[1,`i']               ///
			  _col(31) %9.0g `b2'[1,`i']               ///
			  _col(47) %9.0g `d'                       ///
			  _col(63) %9.0g `se' _c

		if "`syminv'" != "" & `V12'[`i',`i'] == 0 {
			di "  (omitted)" _c
			local ++omit
		}
		di
		local ++i
		local ++ipos
	}

	di as txt "{hline 13}{c BT}{hline 64}"
	di as txt "{ralign 78:b = consistent under Ho and Ha; obtained from `cmd1'}"
	di as txt "{ralign 78:B = inconsistent under Ha, efficient under Ho; obtained from `cmd2'}"

	if "`df'" == "" {
		local df = `rank'
	}

	di _n as txt "    Test:  Ho:  difference in coefficients not systematic"
	di _n as txt "{ralign 25:chi2({res:`=`df''})}" ///
	   " = (b-B)'[(V_b-V_B)^(-1)](b-B)"

	if `chi2' >= 0 {
		di as txt _col(27) "=  " as res %10.2f `chi2' _n ///
		   as txt _col(17) "Prob>chi2 =  "               ///
		   as res %10.4f chiprob(`df', `chi2')

		if ! `posdef' {
			dis as txt _col(17) "(V_b-V_B is not positive definite)"
		}
	}
	else {
		di as txt _col(27) "=" as res %9.2f `chi2' as txt    ///
		   _col(41) "chi2<0 ==> model fitted on these" _n ///
		   _col(41) "data fails to meet the asymptotic" _n   ///
		   _col(41) "assumptions of the Hausman test;" _n    ///
		   _col(41) "see {help suest##|_new:suest} for a generalized test"
	}


	ret scalar p    = chiprob(`df', `chi2')
	ret scalar df   = `df'
	ret scalar chi2 = `chi2'
	ret scalar rank = `rank'
end


// ============================================================================
// subroutines
// ============================================================================


program define Get1steq /* row|mat matname */
	args type m

	local eq : coleq `m', quote
	local eq : list clean eq
	local eq : word 1 of `eq'
	if "`type'" == "row" {
		mat `m' = `m'[1,"`eq':"]
		/* mat coleq `m' = _: */
	}
	else {
		mat `m' = `m'["`eq':", "`eq':"]
		/* mat coleq `m' = _: */
		/* mat roweq `m' = _: */
	}
end


program define SkipEqs /* row|mat matname eq_skip_list */
	args type M skiplst

	_ms_lf_info, matrix(`M')
	tempname T
	local curk 0
	forval i = 1/`r(k_lf)' {
		local eq = r(lf`i')
		local unused  : subinstr local skiplst "`eq'" "`eq'" , ///
			word count(local count)
		if `count' == 0 {
			if "`type'" == "mat" {
				if `curk' > 0 {
					mat `T' =  nullmat(`T'),	/*
					 */ `M'[1..`curk', "`eq':"] \	/*
					 */ `M'["`eq':", 1..`curk'] ,	/*
					 */ `M'["`eq':", "`eq':"]
				}
				else {
					mat `T' = `M'["`eq':", "`eq':"]
				}
				local curk = colsof(`T')
			}
			else {
				mat `T' = nullmat(`T') , `M'[1, "`eq':"]
			}
			local skipped 1
		}
	}

	if "`skipped'" != "" {
		mat `M' = `T'
	}
end


program define Mlist, sclass
	sreturn clear
	args list

	gettoken thing1 0 : list , parse(":")
	while "`thing1'" != "" {
		IsThing integer number `thing1'
		gettoken colon 0 : 0 , parse(" ,:")
		IsToken : `colon'
		gettoken thing2 0 : 0, parse(" ,")
		IsThing integer number `thing2'
		local opt1 "`opt1' `thing1'"
		local opt2 "`opt2' `thing2'"
		gettoken thing1 0 : 0, parse(",:")
		if "`thing1'"== "," {
			gettoken thing1 0 : 0, parse(":")
		}
	}
	sreturn local opt1  "`opt1'"
	sreturn local opt2  "`opt2'"
end


program define IsToken
	args exp opt

	if "`exp'" != "`opt'"	{
		dis as err "\``opt'' found where \``exp'' expected"
		exit 198
	}
end


program define IsThing
	args type1 type2  opt

	confirm `type1' `type2' `opt'
end


/*
	Select equations to be included in the matrix
*/
program define Select       /* b V  select_list */
	args b V  list

	tempname T
					/* selection */
	local enames : coleq `b', quote
	local enames : list clean enames
	local senames : list uniq enames
	local num : word count `senames'
	if `num' == 0 {
		local i 1
		while `i' <= colsof(`b') {
			local neweq "`neweq' comp1"
			local ++i
		}
	}
	else {
		tokenize `"`senames'"'
		forvalues i = 1/`num' {
			local junk : subinstr local list "`i'" "`i'", /*
			 */ word count(local count)
			if `count' == 0 {
				SkipEqs row `b' "``i''"
				SkipEqs mat `V' "``i''"
			}
		}
	}

					/* equation rename */
	if "`neweq'" == "" {
		local enames : coleq `b', quote
		local enames : list clean enames
	}
	else {
		local enames "`neweq'"
	}

	local cnames : colnames `b'
	tokenize `"`enames'"'
	local i 1
	local j 0
	while `i' <= colsof(`b') {
		local col : word `i' of `cnames'
		if "``i''" != "`old'" {
			local ++j
			local old "``i''"
		}
		local newname "`newname' comp`j':`col'"
		local ++i
	}

	version 13: mat colnames `b' = `newname'
	version 13: mat colnames `V' = `newname'
	version 13: mat rownames `V' = `newname'
end


program define Rmcons /* matname */
	args m

	local names : colnames `m'
	local ct : word count `names'
	tokenize `"`names'"'
	local i 1
	local strkcol 1
	while "``i''" != "" {
		if "``i''" == "_cons" {
			if `i' == `ct' & `strkcol' == 1 {
				di as err "no common coefficients names (eq:coef)," /*
				 */ " nothing to test"
				exit 498
			}
			else {
				matstrik `m' `strkcol'
				local --strkcol
			}
		}
		local ++i
		local ++strkcol
	}
end


/*! version 1.0.0  23 May 1998 */
program define MatConf /* b1 V1 b2 V2 */
	version 6
	args b1 V1 b2 V2

	tempname e wrk map

	local eq1  : coleq    `b1', quote
	local nam1 : colnames `b1'
	local eq2  : coleq    `b2', quote
	local nam2 : colnames `b2'

				/* make `e' = (1, 2, 3, ...)	*/
	local n2 = colsof(`b2')
	mat `e' = `b2'
	forvalues i = 1/`n2' {
		mat `e'[1,`i'] = `i'
	}

	local n1 = colsof(`b1')
	local i 1
	while `i' <= `n1' {
		local eq : word `i' of `eq1'
		local name : word `i' of `nam1'
		local name "`eq':`name'"
		capture mat `wrk' = `e'[1,`"`name'"']
		if _rc {
			if _rc != 111 {
				error _rc
			}
			if `n1'==1 {
				mat drop `b1' `V1' `b2' `V2'
				exit 111
			}
			* drop row/column i
			matstrik `b1' `i'
			matstrik `V1' `i'
			local eq1  : coleq    `b1', quote
			local nam1 : colnames `b1'
			local --n1
		}
		else {
			mat `map' = nullmat(`map'), `wrk'
			local ++i
		}
	}

	/* we know `n1' >= 1 */

	tempname newb2 newV2

	mat `newb2' = `b1'	/* just to dcl and obtain names */
	mat `newV2' = `V1'

	forvalues i = 1/`n1' {
		local ip = `map'[1,`i']
		mat `newb2'[1,`i'] = `b2'[1,`ip']
		forvalues j = 1/`n1' {
			mat `newV2'[`i',`j'] = `V2'[`ip',`map'[1,`j']]
			mat `newV2'[`j',`i'] = `newV2'[`i',`j']
		}
	}
	mat `b2' = `newb2'
	mat `V2' = `newV2'
end


/*
	MatGinv A

	computes the Moore-Penrose inverse Ai of A, i.e., the unique
	matrix that satisfies the 4 conditions
	 (1)  Ai*A*Ai = Ai
	 (2)  A*Ai*A  = A
	 (3)  Ai*Ai'  is a projection on the null space of A
	 (4)  Ai'*Ai  is a projection on the image of A

	if A is invertible, Ai = inverse(A)

	if A is n by m, Ai = m by n

	If A is a matrix of zeros, the MP-inverse is all-zeroes also.

	The first two requirements, (1) and (2) above, have been checked
	using tough matrices from ./sim/sim_mcfad7 and the requirements
	are met to reasonable accuracy.

	adapted from Jeroen Weesie/ICS  STB-39 dm49
*/
program define MatGinv
	args	invmat   ///  matrix name to hold inverted matrix
		   rank     ///  scalar name to hold rank of matrix
		   colon    ///  ":"
		   A        ///  name of matrix to be inverted (mat be invmat)
		   syminv   ///  "" or "syminv" for use syminv
		   tol      //   tolerance or ""

	tempname At U W V Wmax

	if "`syminv'" != "" {		// Just a syminv requested
		matrix `invmat' = syminv(`A')
		scalar `rank'   = colsof(`A') - diag0cnt(`invmat')
		if diag0cnt(`invmat') > 0 {
			RankMsg `=`rank'' `=colsof(`A')'
		}
		exit
	}

	local nrA = rowsof(`A')
	local ncA = colsof(`A')

	// singular value decomposition
	if `nrA' < `ncA' {
		matrix `At' = `A''
		matrix svd `V' `W' `U' = `At''
	}
	else {
		matrix svd `U' `W' `V' = `A'
	}

	// tolerance for inverting the diagonal elements of W
	local nc = colsof(`W')
	if "`tol'" == "" {
					// max of singular values
		scalar `Wmax' = 0
		forvalues i = 1/`nc' {
			scalar `Wmax' = max(`Wmax', `W'[1,`i'])
		}
		tempname tol
		scalar `tol' = `Wmax' * `nc' * 1.0e-9
	}

	// invert the elements of W
	local rnk 0
	forvalues i = 1/`nc' {
		if `W'[1,`i'] > `tol' {
			matrix `W'[1,`i'] = 1/(`W'[1,`i'])
			local rnk = `rnk' + 1
		}
		else {
			matrix `W'[1,`i'] = 0
		}
  	}

	// produce InvA
	if `rnk' == 0 {
		matrix `invmat' = J(`ncA',`nrA',0)
	}
	else {
		matrix `invmat' = `V' * diag(`W') * `U''
	}

	if `rnk' != colsof(`A') {
		RankMsg `rnk' `=colsof(`A')'
	}
	if "`rank'" != "" {
		scalar `rank' = `rnk'
	}
end

program RankMsg
	args rank coefs

	di ""
di as text in smcl "{p 0 8}Note: the rank of the differenced variance matrix ({result:`rank'}) does not equal the number of coefficients being tested ({result:`coefs'}); be sure this is what you expect, or there may be problems computing the test.  Examine the output of your estimators for anything unexpected and possibly consider scaling your variables so that the coefficients are on a similar scale." 

end


program SymPosDef, rclass
	args W

	tempname X V
	capture matrix symeigen `X' `V' = `W'
	if _rc == 505 {
		// `W' (the diff between 2 cov. matrices wasn't symmetric,
		// we force it to be symmetric
		mat `W' = (`W' + `W'')*.5
		matrix symeigen `X' `V' = `W'
	}
	return local posdef = `V'[1,colsof(`V')] > 0
end


/* Remove all coefficients with Var==0 */
program define Strik0
	args b V

	while diag0cnt(`V') {
		if colsof(`V')==1 {
			di as err "nothing to test"
			exit 498
		}
		Find0 `V'
		local i `r(i)'
		* drop row/column i
		matstrik `b' `i'
		matstrik `V' `i'
	}
end


/* Find0 V
   returns in r(i) the first index for which V[i,i]=0
*/
program define Find0, rclass
	args V

	local i 1
	while `V'[`i',`i'] != 0 {
		local ++i
	}
	ret local i `i'
end


/* Abbrev abname : name
   returns in abname the 12char abbreviation of name,
   or . if this abbreviation is empty
*/
program define Abbrev
	args abname colon name

	local abn = abbrev("`name'",12)
	if "`abn'" == "" {
		local abn .
	}
	c_local `abname' `abn'
end


/* GetbV name b V
   returns e(b) and e(V) with error messages if not found
*/
program define GetbV
	args name b V

	foreach n in b V {
		capt confirm matrix e(`n')
		if _rc {
			di as err "e(`n') not found in `name'"
			exit 198
		}
		matrix ``n'' = e(`n')
	}
end


/* OldSyntax

   Processes subcommands -save-  and -clear- not dealt with by the
   new syntax/command due to -estimates-.

   return in r(newsyntax) the translation of version 7 syntax
   into version 8 syntax.
*/
program define OldSyntax, rclass
	syntax [, Alleqs CLEAR Constant CURrent(string) Less More  ///
		Prior(string) Save SIGMAMore SIGMALess SKipeqs(passthru) ///
		SYMINV EQuations(passthru) ]

	NewSyntaxMsg

	if "`save'" != "" {
		syntax, save
		di as txt "(storing estimation results as _HAUSMAN)"
		est store _HAUSMAN, title("estimation results saved by hausman")
		exit 0
	}

	if "`clear'" != "" {
		syntax, clear
		capt est drop _HAUSMAN
		exit 0
	}

	// get information about models to be compared: _HAUSMAN and . (last)

	capt est_cfexist _HAUSMAN
	if _rc {
		di as err "no estimation results were previously stored by hausman"
		exit 198
	}
	if "`e(cmd)'" == "" {
		error 301
	}
	if "`e(_estimates_name)'" == "_HAUSMAN" {
		di as err "the last estimation results were already " /*
		 */ "saved by hausman"
		di as err "thus, no test can be performed"
		exit 301
	}

	if "`more'" != "" & "`less'" != "" {
		di as err "more and less cannot be combined"
		exit 198
	}
	if "`less'" != "" {
		// . is the "less efficient" estimator
		local spec1 .
		local spec2 _HAUSMAN
		local teff `"`current'"'
		local tcon `"`prior'"'
		local reveq reveq
	}
	else {
		// . is the "more efficient" estimator
		local spec1 _HAUSMAN
		local spec2 .
		local teff  `"`prior'"'
		local tcon  `"`current'"'
	}
	if "`teff'" == "" {
		local teff Efficient
	}
	if "`tcon'" == "" {
		local tcon Consistent
	}

	// assemble new syntax line
	return local newsyntax `spec1' `spec2' , `constant' `alleqs' /*
	  */ `equations' `reveq' `skipeqs' `sigmamore' `sigmaless' /*
	  */ teff(`teff') tcon(`tcon') `syminv'
end


program define NewSyntaxMsg
	di as txt "{p}You used the old syntax of {cmd:hausman}. Click " ///
	   "{help hausman##|_new:here} to learn about the new syntax.{p_end}" _n
end

exit
