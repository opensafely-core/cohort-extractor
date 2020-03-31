*! version 4.8.9  31jul2013
program define alpha, rclass byable(recall)
	version 8, missing

	* undocumented: coo == casewise
	syntax varlist(min=2 numeric) [if] [in] [, Asis Casewise Coo Detail Item /*
	 */ Generate(string) Label Min(integer 1) Reverse(varlist numeric) Std ]

	DropDup varlist : "`varlist'"
	local k : word count `varlist'

	if `min' < 1 | `min' > `k' {
		di as err "invalid option min()"
		exit 198
	}

	if "`coo'" != "" {
		local casewise casewise
	}

	* scratch

	tempvar cnt nobs rest test touse x
	tempname ac acor acorr alph alpha av avar C mIIC MEAN nc ncor nv nvar Obs IRC ITC VAR

/* begin */ quietly {

	* --------------------------------------------------------------------------
	* select and count cases; treatment of missing values
	* --------------------------------------------------------------------------

	*   N = #obs selected via if/in/min
	*  NC = #complete obs

	if "`casewise'" == "" & `min' < `k' {      /* incomplete cases allowed */

		marksample touse, novarlist
		egen `nobs' = robs(`varlist') if `touse'
		replace `touse' = (`nobs' < . & `nobs' >= `min')
		count if `touse'
		local N = r(N)		/* # if in */
		count if `nobs'==`k' & `touse'
		local NC = r(N)         /* # if in & complete */
	}
	else {                                   /* only complete cases */
		marksample touse
		count if `touse'
		local N = r(N)
		local NC `N'
	}
	if `N' == 0 {
		error 2000
	}

	* --------------------------------------------------------------------------
	* drop constant variables
	* note: we do not check again whether #obs >= min
	* --------------------------------------------------------------------------

	foreach v of local varlist {
		summ `v' if `touse', meanonly
		if r(min) == r(max) {
			local vardrop `vardrop' `v'
		}
		else	local varkeep `varkeep' `v'
	}
	if "`vardrop'" != "" {
		noi di as txt /*
		 */ "`vardrop' constant in analysis sample, dropped from analysis"
		local varlist `varkeep'
		local k : word count `varlist'
	}
	* below the varlist is kept tokenized
	tokenize `varlist'

	if `k' == 1 {
		error 102
	}

	* --------------------------------------------------------------------------
	* signs of variables sgn1, sgn2, ...
	* --------------------------------------------------------------------------

	forvalues i = 1/`k' {
		local sgn`i' 1
	}
	if "`reverse'" != "" {            /* signs specified by user */
		local restlist
		foreach v of local reverse {
			ListIndex "`varlist'"  "`v'"
			if `r(index)' > 0  {
				local sgn`r(index)' -1
				local revlist "`revlist'`v' "
			}
			else {
				local restlist "`restlist'`v' "
			}
		}
		if "`restlist'" != "" {
			noi di as txt /*
			 */ "`restlist'included in reverse-list, but not in varlist"
		}
	}
	else if "`asis'" == "" {     /* automatic signs via -factor- */
		tempname score ehold
		_est hold `ehold', restore nullok
		capture factor `varlist' if `touse'
		if _rc==2000 {
			di as err "cannot determine the sense empirically;" /*
			*/ " must specify option asis or reverse()"
			exit 459
		}
		score `score'
		capture confirm var `score'
		if _rc==111 {
			di as err "cannot determine the sense empirically;" /*
                        */ " must specify option asis or reverse()"
                        exit 459
		}	
		forvalues i = 1/`k' {
			corr ``i'' `score' if `touse'
			if r(rho) < 0 {
				local revlist "`revlist' ``i''"
				local sgn`i' -1
			}
		}
	}

	* --------------------------------------------------------------------------
	* compute OBS, MEAN, VAR and COV/CORR
	* --------------------------------------------------------------------------

	* matrix C    = corr/cov for signed variables
	* matrix Obs  = pairwise number of non-missing cases
	* matrix MEAN = unsigned means of variables
	* matrix VAR  = variance of variables
	* var cnt     = #non-mv's

	if `N' != `NC' {                    /* some cases contain missing values */

		mat `Obs'  = J(`k',`k',0)
		mat `C'    = `Obs'
		mat `MEAN' = J(1,`k',0)
		mat `VAR'  = J(1,`k',0)
		gen int `cnt' = 0

		if "`std'" == "" {
			local corropt  cov
			local r_arg    cov_12
		}
		else {
			local r_arg rho
		}

		forvalues i = 1/`k' {
			summ ``i'' if `touse'
			mat `Obs'[`i',`i'] = r(N)
			mat `MEAN'[1,`i']  = r(mean)
			mat `VAR'[1,`i']   = r(Var)
			if "`std'" == "" {
				mat `C'[`i',`i'] = r(Var)
			}
			else {
				mat `C'[`i',`i'] = 1
			}
			replace `cnt' = `cnt' + 1 if `touse' & ``i'' < .

			local imin1 = `i'-1
 			forvalues j = 1/`imin1' {
				corr ``i'' ``j'' if `touse', `corropt'
				if r(N) != 0 {
					mat `C'[`i',`j'] = `sgn`i'' * `sgn`j'' * r(`r_arg')
					mat `C'[`j',`i'] = `C'[`i',`j']
				}
				else {
					di as err "no simultaneous obs on ``i'' and ``j''"
					exit 498
				}
				mat `Obs'[`i',`j'] = r(N)
				mat `Obs'[`j',`i'] = r(N)
			}
		} /* forvalues i */
	}

	else {                                     /* all cases complete */

		mat acc `C' = `varlist' if `touse', dev mean(`MEAN') nocons
		mat `C' = (1/(r(N)-1)) * `C'
		mat `VAR' = vecdiag(`C')

		* adapt C for the signs of variables
		if "`revlist'" != "" {
			forvalues i = 1/`k' {
				local imin1 = `i'-1
				forvalues j = 1/`imin1' {
					mat `C'[`i',`j'] = `C'[`i',`j'] * `sgn`i'' * `sgn`j''
					mat `C'[`j',`i'] = `C'[`i',`j']
				}
			}
		}

		* modification in case of correlations
		if "`std'" != "" {
			mat `C' = corr(`C')
		}
		mat `Obs' = J(`k',`k',`N')
		gen int `cnt' = `k'
	}

	* --------------------------------------------------------------------------
	* test scores
	* --------------------------------------------------------------------------

	gen `test' = 0 if `touse'
	forvalues i = 1/`k' {
		if "`std'" == "" {
			replace `test' = `test' + `sgn`i'' * ``i'' if `touse' & ``i'' < .
		}
		else {
			replace `test' = `test' + /*
			 */  `sgn`i'' * (``i''-`MEAN'[1,`i']) / sqrt(`VAR'[1,`i']) /*
			 */  if `touse' & ``i'' < .
		}
	}
	* note: at this point, cnt>0 is ensured
	replace `test' = `test' / `cnt' if `touse'

	* --------------------------------------------------------------------------
	* compute statistics for the additive scale in all items
	* --------------------------------------------------------------------------

	if "`std'" != "" {
		scalar `avar' = 1
		scalar `nvar' = 1
	}
	else {
		scalar `avar' = 0
		scalar `nvar' = 0
		forvalues i = 1/`k' {
			scalar `avar' = `avar' + `Obs'[`i',`i'] * `C'[`i',`i']
			scalar `nvar' = `nvar' + `Obs'[`i',`i']
		}
	}

	scalar `acor' = 0                         /* weighted sum of variances */
	scalar `ncor' = 0                         /* sum of weights */
	forvalues i = 1/`k' {
		local imin1 = `i'-1
		forvalues j = 1/`imin1' {
			scalar `acor' = `acor' + `Obs'[`i',`j']*`C'[`i',`j']
			scalar `ncor' = `ncor' + `Obs'[`i',`j']
		}
	}

	scalar `acorr' = `acor'/`ncor'
	scalar `alpha' = (`k'*`acorr')/(`avar'/`nvar'+(`k'-1)*`acorr')
	if scalar(`alpha') < 0 {
		scalar `alpha' = .
	}

	* double save in r() and S_#
 	if "`std'" == "" {
 		return scalar cov = scalar(`acorr' )
 	}
	else {
		return scalar rho = scalar(`acorr')
	}

	return scalar k     = `k'
	return scalar alpha = scalar(`alpha')

	global S_4 = scalar(`acorr')
	global S_5 = `k'
	global S_6 = scalar(`alpha')

	* --------------------------------------------------------------------------
	* compute statistics for additive scales formed by removing single items
	* --------------------------------------------------------------------------

	if `k' == 2 & "`item'" != "" {
		di as txt "option -item- ignored with 2 variables"
		local item
	}

	if "`item'" != "" {
		mat `ITC'  = J(1,`k',0)          /* item-test correlations */
		mat `IRC'  = J(1,`k',0)          /* item-rest correlations */
		mat `mIIC' = J(1,`k',0)          /* mean InterItem corr/cov */
		mat `alph' = J(1,`k',0)          /* alpha */

		if "`std'" != "" {
			scalar `av' = 1
			scalar `nv' = 1
		}
		forvalues i = 1/`k' {
			scalar `ac' = `acor'
			scalar `nc' = `ncor'
			forvalues j = 1/`k' {
				if `i' != `j' {
					scalar `ac' = `ac' - `Obs'[`i',`j']*`C'[`i',`j']
					scalar `nc' = `nc' - `Obs'[`i',`j']
				}
			}
			if "`std'" == "" {
				scalar `av' = `avar' - `Obs'[`i',`i']*`C'[`i',`i']
				scalar `nv' = `nvar' - `Obs'[`i',`i']
			}
			mat `mIIC'[1,`i'] = `ac'/`nc'
			mat `alph'[1,`i'] = /*
			 */ ((`k'-1)*`ac'/`nc') / ((`av'/`nv')+(`k'-2)*`ac'/`nc')
			if `alph'[1,`i'] < 0 {
				mat `alph'[1,`i'] = .
			}

			* Item-Test correlations
			corr ``i'' `test' if `touse'
			mat `ITC'[1,`i'] = `sgn`i'' * r(rho)

			* Item-Rest (=Test-Item) correlations
			if "`std'" == "" {
				gen `x' = `sgn`i'' * ``i'' if `touse' & ``i''<.
			}
			else {
				gen `x' = `sgn`i''*(``i''-`MEAN'[1,`i'])/sqrt(`VAR'[1,`i']) /*
				 */ if `touse' & ``i''<.
			}

			gen `rest' = (`cnt'*`test'-`x') / (`cnt'-1) /*
			 */ if `touse' & ``i'' < . & `cnt' > 1
			corr ``i'' `rest' if `touse'
			mat `IRC'[1,`i'] = `sgn`i'' * r(rho)

			drop `x' `rest'
		}
	}

/* end quietly */ }

	* --------------------------------------------------------------------------
	* display and related results
	* --------------------------------------------------------------------------

	if "`std'" == "" {
		local un un
	}
	local testtxt "mean(`un'standardized items)"

	di as txt _n "Test scale = `testtxt'"
	local linesize : set linesize

	/*
		compact output if -item- is not specified
	*/

	if "`item'" == "" {
		if "`std'" == "" {
			local lab "covariance"
			local fmt "%9.0g"
		}
		else {
			local lab "correlation"
			local fmt "%9.4f"
		}
 		if "`revlist'" != "" {
 			local nrev : word count `revlist'
			local itemtxt = cond(`nrev'>1, "items", "item")
			di as txt "Reversed `itemtxt': {res:`revlist'}"
		}
		di
		di as txt "Average interitem `lab':"       _col(34) as res `fmt' `acorr'
		di as txt "Number of items in the scale:"  _col(34) as res %9.0f `k'
		di as txt "Scale reliability coefficient:" _col(34) as res %9.4f `alpha'
	}

	/*
		item is specified, no label
	*/

	if "`item'" != "" & "`label'" == "" {
		if "`std'" == "" {
			local lab "covariance "
			local fmt "%9.0g"
		}
		else {
			local lab "correlation"
			local fmt "%9.4f"
		}

    		di as txt _n "                                                            average"
		di as txt    "                             item-test     item-rest       interitem"
		di as txt "Item         {c |}  Obs  Sign   correlation   correlation     `lab'     alpha"
		di as txt "{hline 13}{c +}{hline 65}"
		forvalues i = 1/`k' {
			di as txt abbrev("``i''",12) "{col 14}{c |}" as res /*
			 */ _col(16) %4.0f `Obs'[`i',`i'] /*
			 */ _col(24)       =cond("`sgn`i''"=="1","+","-") /*
			 */ _col(31) %7.4f `ITC'[1,`i']   /*
			 */ _col(45) %7.4f `IRC'[1,`i']   /*
			 */ _col(59) `fmt' `mIIC'[1,`i']  /*
			 */ _col(73) %7.4f `alph'[1,`i']
		}
		di as txt "{hline 13}{c +}{hline 65}"
		di as txt "Test scale{col 14}{c |}" /*
		 */ as res _col(59) `fmt' `acorr' _col(73) %7.4f `alpha'
		di as txt "{hline 13}{c BT}{hline 65}"
	}

	/*
		item and label specified; linesize<100
	*/

	if "`item'" != "" & "`label'" != "" & `linesize' < 100 {
		if "`std'" == "" {
			local lab "cov"
			local fmt "%7.0g"
		}
		else {
			local lab "cor"
			local fmt "%7.3f"
		}

		MaxVarLab "`varlist'"
		local lenlabel = max(r(llen),length(`"`testtxt'"'))
		if `linesize' < 55 {
			local lenpiece = 3
		}
		else {
			local lenpiece = min(`lenlabel',`linesize'-52)
		}
		local duplen   = 38 + `lenpiece'

		di _n as txt "Items        {c |} S  it-cor  ir-cor   ii-`lab'   alpha   label"
		di    as txt "{hline 13}{c +}{hline `duplen'}"
		forvalues i = 1/`k' {
			di as txt abbrev("``i''", 12) "{col 14}{c |} " as res /*
		 	 */          =cond("`sgn`i''" == "1", "+", "-") /*
			 */ _col(19) %6.3f `ITC'[1,`i']           /*
			 */ _col(27) %6.3f `IRC'[1,`i']           /*
			 */ _col(35) `fmt' `mIIC'[1,`i']          /*
			 */ _col(44) %6.3f `alph'[1,`i']          /*
			 */ _col(53) _c

			DiVarLab ``i'' `lenpiece' 55
		}

		di as txt "{hline 13}{c +}{hline `duplen'}"
		di as txt "Test scale{col 14}{c |}" as res /*
		 */ _col(35) `fmt' `acorr' /*
		 */ _col(44) %6.3f `alpha' /*
		 */ _col(53) as txt `"`testtxt'"'
		di as txt "{hline 13}{c BT}{hline `duplen'}"
	}

	/*
		item and label specified; linesize>=100
	*/

	if "`item'" != "" & "`label'" != "" & `linesize' >= 100 {
		if "`std'" == "" {
			local lab "cov. "
			local fmt "%9.0g"
		}
		else {
			local lab "corr."
			local fmt "%8.4f"
		}
		MaxVarLab "`varlist'"
		local lenlabel = max(r(llen),length(`"`testtxt'"'))
		local lenpiece = min(`lenlabel',`linesize'-69)
		local duplen   = 55 + `lenpiece'

		di
		di as txt "                          item-test  item-rest  interitem"
		di as txt "Item         {c |}  Obs  Sign   corr.      corr.       `lab'     alpha   Label"
		di    as txt "{hline 13}{c +}{hline `duplen'}"

		forvalues i = 1/`k' {
			di as txt abbrev("``i''", 12) "{col 14}{c |} " as res /*
			 */ _col(16) %4.0f `Obs'[`i',`i']   /*
			 */ _col(24)       =cond("`sgn`i''" == "1", "+", "-") /*
			 */ _col(28) %7.4f `ITC'[1,`i']   /*
			 */ _col(39) %7.4f `IRC'[1,`i']   /*
			 */ _col(49) `fmt' `mIIC'[1,`i']  /*
			 */ _col(61) %6.4f `alph'[1,`i']  /*
			 */ _col(70) _c

			DiVarLab ``i'' `lenpiece' 72
		}

		di as txt "{hline 13}{c +}{hline `duplen'}"
		di as txt "Test scale{col 14}{c |}" as res /*
		 */ _col(49) `fmt' `acorr' /*
		 */ _col(61) %6.4f `alpha' /*
		 */ _col(70) as txt `"`testtxt'"'
		di as txt "{hline 13}{c BT}{hline `duplen'}"
	}

	* --------------------------------------------------------------------------
	* detail: table with interitem correlations / covariances
	* --------------------------------------------------------------------------

	if "`detail'" != "" {
		if `N' == `NC' {
			local obs "(obs=`N' in all pairs)"
		}
		else {
			local obs "(obs=pairwise, see below)"
		}

		if "`revlist'" != "" {
			local rev "(reverse applied) "
		}

		mat rownames `C' = `varlist'
		mat colnames `C' = `varlist'

		if "`std'" != "" {
			di as txt _n "Interitem correlations `rev'`obs'"
			mat list `C', noheader format(%6.4f)
		}
		else {
			di as txt _n "Interitem covariances `rev'`obs'"
			mat list `C', noheader format(%9.4f)
		}

		if `N' != `NC' {
			di as txt _n "Pairwise number of observations"
			mat rownames `Obs' = `varlist'
			mat colnames `Obs' = `varlist'
			mat list `Obs', noheader format(%5.0f)
		}
	}

	* --------------------------------------------------------------------------
	* generate(): save test scale
	* --------------------------------------------------------------------------

	if "`generate'" != "" {
		confirm new var `generate'
		qui gen `generate' = `test' if `touse'
		label var `generate' "mean(`un'standardized items)"
	}

	if "`item'" != "" {
		* information about rest-scales
		matrix colnames `ITC'  = `varlist'
		matrix colnames `IRC'  = `varlist'
		matrix colnames `mIIC' = `varlist'
		matrix colnames `alph' = `varlist'
		return matrix ItemTestCorr `ITC'
		return matrix ItemRestCorr `IRC'
		if "`std'" == "" {
			return matrix MeanInterItemCov `mIIC'
		}
		else {
			return matrix MeanInterItemCorr `mIIC'
		}
		return matrix Alpha `alph'
	}
end

* ============================================================================
* subroutines
* ============================================================================

/* ListIndex list word
   returns in r(index) the index of word in list, or 0 if not found
*/
program define ListIndex, rclass
	args list word

	local word = trim(`"`word'"')
	tokenize `list'
	local i 1
	local ifound 0
	while "``i''" != ""  & `ifound' == 0 {
		if "``i''" == `"`word'"' {
			local ifound `i'
		}
		local i = `i'+1
	}
	return local index `ifound'
end

/* MaxVarLab "varlist"
   returns in scalar r(vlen) the maximum length of the names of variables in a varlist,
                 and r(llen) the maximum variable length of these variables
*/
program define MaxVarLab, rclass
	args varlist

	tempname llen vlen
	scalar `llen' = 0
	scalar `vlen' = 0
	foreach v of local varlist {
		scalar `vlen' = max(`vlen', length("`v'"))
		local vl : var label `v'
		scalar `llen' = max(`llen', length(`"`vl'"'))
	}
	return scalar vlen = `vlen'
	return scalar llen = `llen'
end


/* DiVarLab v lpiece col
   displays the varlabel of variable v, starting at the current cursor
   location, in pieces of length lpiece, with further pieces starting
   at position col.
*/
program define DiVarLab
	args v lpiece col

	local vlab : var label `v'
	local vl : piece 1 `lpiece' of `"`vlab'"'
	di as txt `"`vl'"'
	local j 2
	local vl : piece `j' `lpiece' of `"`vlab'"'
	while `"`vl'"' != "" {
		di as txt `"{col 14}{c |}{col `col'}`vl'"'
		local j = `j'+1
		local vl : piece `j' `lpiece' of `"`vlab'"'
	}
end

/* DropDup newlist : quoted-list
   drops all duplicate tokens from list -- copied from hausman.ado
*/
program DropDup
	args newlist	///  name of macro to store new list
	     colon      ///  ":"
	     list       //   list with possible duplicates

	gettoken token list : list
	while "`token'" != "" {
		local fixlist `fixlist' `token'
		local list : subinstr local list "`token'" "", word all
		gettoken token list : list
	}

	c_local `newlist' `fixlist'
end

exit

HISTORY

4.7.2  drops duplicate vars;
       bug fix: after dropping constant or duplicate variables there
         should still be >=2 vars;
       bug fix: location in code of check whether "item suppressed"

4.7.1  added varlist as row/column labels in corr/cov of items

4.7.0  missing values in results
       fixed bug with constant variables
       fixed minor display "bug"

4.5.1  fixed bug in restlist
       fixed bug in the varlabel of the generated variable
       negative alpha's in sublists are also shown as missing

4.5.0  ported to version 7

4.4.1  fixed some misalignments in labels

4.4.0  various minor changes in coding and layout
       additional checks
       -- N>0
       -- drop constant variables
       -- with incomplete data: check that there are >=2 obs for each pair
          of variables

4.3.0  return extra results

4.2.0  support for -display linesize-

4.1.0  ListIndx no longer returns values via macro S_1

4.0.4  improved varlabel handling in with option -label

4.0.3  added option numeric to varlist
       improved handling of long variable labels, and labels than contain quotes
       bug fix: -nvar=2, item-
       used matrix expressions
       modified display of signs in detail tables (the old version would crash
       if the name of a reversed variable was 8 char


