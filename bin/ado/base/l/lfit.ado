*! version 3.4.5  25sep2017
program define lfit, rclass sort
	version 6.0, miss

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	tempvar touse p w yobs yexp x

	if "`e(cmd)'" == "ivprobit" {
		di in smcl as error "not available after {cmd:ivprobit}"
		exit 321
	}

	lfit_p `touse' `p' `w' `0'
	local obs   `s(N)'
	local y     "`s(depvar)'"
	local beta  "`s(beta)'"
	local rules "`s(rules)'"

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [, Group(integer 0) Table OUTsample ]

	if `group' != 0 { /* Hosmer-Lemeshow */

		if `group' < 0 {
			di in red `"group() cannot be negative"'
			exit 411
		}
		qui count if `touse'
		if `group' > r(N) {
			di in red `"number of groups cannot be greater than"' /*
			*/	  `" number of observations"'
			exit 498
		}

		HosLem `obs' `group' `y' `p' `w' `yobs' `yexp' `equal'

		local nvar 2
		local id   `"Hosmer-Lemeshow"'
	}
	else { /* Pearson */

		if `"`equal'"' != `""' {
			di in red `"must specify number of groups with "' /*
			*/	  `" equal option"'
			error 198
		}
		if `"`rules'"' != `""' | "`beta'" == "" {
			local beta e(b)
		}
		Getivars `beta'
		local ivars `"`r(ivars)'"'
		local nvar  `r(N_vars)'
		_ms_op_info `beta'
		local fvops = r(fvops)
		local tsops = r(tsops)
		quietly {
			if `fvops' | `tsops' {
				local oivars : copy local ivars
				fvrevar `ivars'
				local ivars `r(varlist)'
			}
			sort `touse' `ivars'
			by `touse' `ivars': gen double `yobs' = /*
			*/		    sum(`w'*(`y'!=0)) if `touse'
			by `touse' `ivars': gen double `yexp' = /*
			*/		    sum(`w'*`p') if `touse'
			by `touse' `ivars': replace `w' = /*
			*/		    cond(_n==_N,sum(`w'),.) if `touse'
			if `"`oivars'"' != "" {
				local ivars : copy local oivars
			}
		}
		local id `"Pearson"'
	}

	/* Compute chi-squared statistic. */

	quietly {
		replace `touse' = (`w'>0 & `w'<.)

		gen double `x' = sum(cond(`yexp'>0 & `yexp'<`w' & `touse', /*
		*/		 ((`yobs'-`yexp')^2)/(`yexp'*(1-`yexp'/`w')),0))

		count if `touse'
	}

	ret scalar N = `obs'		/* number obs		*/
	ret scalar m = r(N)	  	/* number of groups 	*/
	ret scalar chi2 = `x'[_N]	/* chi-square 		*/
	if `"`outsamp'"'==`""' {
		ret scalar df = return(m) - `nvar' /* estimation sample df */
	}
	else	ret scalar df = return(m) /* out of sample df */
	ret scalar p = chiprob(return(df), return(chi2))

	if (1) {   /* double save in S_# and r() */
		global S_1 = return(N)
		global S_2 = return(m)
		global S_3 = return(chi2)
		global S_4 = return(df)
	}
	if return(df) < 0 {
		di as err ///
			"not enough degrees of freedom to perform the test"
		exit 322
		}
	/* Display results. */

	di _n in smcl as txt "{title:" /*
		*/ (cond(`"`e(cmd)'"'=="probit"|`"`e(cmd)'"'=="dprobit", /*
		*/ 	"Probit","Logistic")) /*
		*/ `" model for `y', goodness-of-fit test}"'
		

	if `group' != 0 {
		di in gr _n /*
		*/ `"  (Table collapsed on quantiles of estimated probabilities)"' _c
		if return(m) < `group' {
			di in gr _n /*
			*/ `"  (There are only `return(m)' distinct "' /*
			*/ `"quantiles because of ties)"' _c
		}

		if `"`table'"' == "" { 
			di
		}
	}
	if `"`table'"' != `""' {
		drop `x'
		tempvar Obs_0 Exp_0 Group
		if `group' != 0 {
			qui gen int `Group' = _n in 1/`group'
		}
		else {
			sort `p'
			qui gen `Group' = sum(`touse')
		}
		qui gen `Obs_0' = `w' - `yobs'
		qui gen `Exp_0' = `w' - `yexp'

		char `Group'[varname] "Group"
		char `yobs'[varname] "Obs_1"
		char `yexp'[varname] "Exp_1"
		char `w'[varname] "Total"
		char `p'[varname] "Prob"
		char `Obs_0'[varname] "Obs_0"
		char `Exp_0'[varname] "Exp_0"

		format `p' %8.4f
		format `yexp' `Exp_0' %9.1f
		if `"`equal'"' == `""' {
			format `yobs' `Obs_0' `w' %9.0g
		}
		else format `yobs' `Obs_0' `w' %9.1f
		format `Group' %6.0f
		list `Group' `p' `yobs' `yexp' `Obs_0' `Exp_0' /*
			*/	 `w' if `touse', table noo subvar div
		if `group' == 0 {
			if `fvops' {
				foreach x of local ivars {
					_ms_parse_parts `x'
					if r(type) == "variable" {
						local IVARS `IVARS' `x'
					}
					else {
						unopvarlist `x', keepts
						local IVARS `IVARS' `r(varlist)'
					}
				}
				local IVARS : list uniq IVARS
			}
			else	local IVARS : copy local ivars
			list `Group' `p' `IVARS' if `touse', noobs subvar div
		}
		drop `Group' `yobs' `yexp' `w' `p' `Obs_0' `Exp_0'
	}
	di _n in gr _col(8) `"number of observations = "' in ye %9.0g return(N)
	if `group' == 0 {
		di in gr `" number of covariate patterns = "' /*
			*/ in ye %9.0g return(m)
	}
	else {
		di in gr _col(14) `"number of groups = "' in ye %9.0g return(m)
	}
	local skip = 29 - length(`"`id' chi2(`return(df)')"')
	#delimit ;
	di in gr _skip(`skip') `"`id' chi2("' in ye `"`return(df)'"'
	   in gr `") = "'
	   in ye %12.2f return(chi2) _n
	   in gr _col(19) `"Prob > chi2 = "'
	   in ye %14.4f chiprob(return(df), return(chi2)) ;
	#delimit cr
end

program define HosLem
	local obs   `"`1'"'  /* # of obs = sum of weights         */
	local group `"`2'"'  /* # of quantiles                    */
	local y     `"`3'"'  /* dependent variable                */
	local p     `"`4'"'  /* input:  predicted probabilities   */
                           /* output: quantiles of pred. prob.  */
	local w     `"`5'"'  /* input:  weights                   */
			   /* output: total counts per quantile */
                           /* p & w missing if obs marked out   */
	local yobs  `"`6'"'  /* input:  varname                   */
                           /* output: generated observed counts */
	local yexp  `"`7'"'  /* input:  varname                   */
                           /* output: generated expected counts */
	local equal `"`8'"'  /* equal option if specified         */

	tempvar m qx
	sort `p'
	quietly {
		/* Sum `w' and `w'*(`y'!=0). */
		local wtype : type `w'
		if `"`wtype'"' != `"double"' {
			tempvar ww
			gen double `ww' = `w'
			drop `w'
			rename `ww' `w'
		}
		gen double `yobs' = sum(`w'*(`y'!=0)) if `p'<.
		gen double `yexp' = sum(`w'*`p')      if `p'<.
		replace    `w'    = sum(`w')          if `p'<.

		/* Work with one obs per `p' value. */
		by `p': replace `w' = . if _n < _N
		replace `p' = . if `w'>=.

		Quantile `obs' `group' `p' `w' `m' `equal'

		/* Portion counts between quantiles. */

		if `"`equal'"' == `""' {
			Qportion `group' `m' `yobs'
			Qportion `group' `m' `yexp'
			Qportion `group' `m' `w'
			exit
		}

		/* Here only if `equal' option specified. */

		Eportion `obs' `group' `w' `m' `yobs'
		Eportion `obs' `group' `w' `m' `yexp'
		replace `w' = cond(_n<=`group',`obs'/`group',.)
	}
end

program define Quantile
	local obs   `"`1'"'  /* # of obs = sum of weights          */
	local group `"`2'"'  /* # of quantiles                     */
	local p     `"`3'"'  /* input:  predicted probabilities    */
                           /* output: quantiles of pred. prob.   */
	local w     `"`4'"'  /* input:  cumulative sum of weights  */
                           /* p & w missing if obs marked out    */
	local m     `"`5'"'  /* input:  varname                    */
                           /* output: obs. no. of _n-th quantile */
	local equal `"`6'"'  /* equal option if specified          */

	tempvar k i
	local eps = `group'* 1e-8
	sort `p'

	/* Integer floor of q gives quantiles. */
	local q  `"(`group'*`w'/`obs')"'
	local qm `"(`group'*`w'[_n-1]/`obs')"'
	local qp `"(`group'*`w'[_n+1]/`obs')"'

	quietly {
		/* `k'==1 gives ties. */
		#delimit ;
		gen byte `k' = `w'[_n+1]<. & abs(`q'-round(`q',1))<`eps'
			       & ( (`q'<=round(`q',1)&`qp'-round(`q',1)>=`eps')
			          |(`q'>=round(`q',1)
			            &(round(`q',1)-`qp'>=`eps'|_n==1)) ) ;
		#delimit cr

		/* Compute true quantile probabilities. */
		replace `p' = (`p'+`p'[_n+1])/2 if `k'

		replace `k' = cond(`k'|`w'[_n+1]>=., round(`q',1), int(`q'))

		/* Nonmissing values of `i' give quantiles. */
		gen int `i' = `k' if `k'!=`k'[_n-1] & `k'!=0

		/* `m' will be the obs. no. of the quantiles. */
		gen `c(obs_t)' `m' = _n

		Moveup `i' `m' if `i'<.

		count if `i'<. in 1/`group'
		local max = r(N)

		if `max' < `group' { /* fill in gaps */
			Matchup `i' `m'
			if `"`equal'"' == `""' { /* lag */
				replace `m' = `m'[_n-1] if `m'>=. in 1/`group'
			}
			else { /* reverse lag */
				Revlag `m' `group'
			}
		}

		drop `k' `i'

		/* Put quantile probabilities in the right place. */
		gen double `k' = `p'[`m']
		drop `p'
		rename `k' `p'
	}
end

program define Qportion
/*
   Program used when `equal' option NOT specified.
   Portions out expected and observed counts per quantile.
*/
	local group `"`1'"'  /* # of quantiles                     */
	local m     `"`2'"'  /* input:  obs. no. of _n-th quantile */
	local x     `"`3'"'  /* input:  variable to be portioned   */
                           /* output: portioned variable         */
	tempvar qx
	quietly {
		gen double `qx' = cond(`m'>`m'[_n-1],`x'[`m']-`x'[`m'[_n-1]], /*
		*/		  cond(`m'[_n-1]>=.,`x'[`m'],.)) in 1/`group'
		replace `x' = `qx'
	}
end

program define Eportion
/*
   Program used when `equal' option specified.
   Portions out expected and observed counts per quantile.
*/
	local obs   `"`1'"'  /* # of obs = sum of weights          */
	local group `"`2'"'  /* # of quantiles                     */
	local w     `"`3'"'  /* input:  cumulative sum of weights  */
	local m     `"`4'"'  /* input:  obs. no. of _n-th quantile */
	local x     `"`5'"'  /* input:  variable to be portioned   */
                           /* output: portioned variable         */
	tempvar qx
	tempname dw
	scalar `dw' = `obs'/`group'
	quietly {
		#delimit ;
		gen double `qx' = cond(`m'==1, `dw'*`x'[1]/`w'[1],
			cond((_n-1)*`dw'>=`w'[`m'-1],
			`dw'*(`x'[`m']-`x'[`m'-1])/(`w'[`m']-`w'[`m'-1]),
			(_n*`dw'-`w'[`m'-1])
			  *(`x'[`m']-`x'[`m'-1])/(`w'[`m']-`w'[`m'-1])
			  + `x'[`m'-1] ))
			in 1/`group' ;
		replace `qx' = `qx' - `x'[`m'[_n-1]]
                	+ cond(`m'[_n-1]==1,
			  (`w'[1]-(_n-1)*`dw')*`x'[1]/`w'[1],
			  (`w'[`m'[_n-1]]-(_n-1)*`dw')
			    *(`x'[`m'[_n-1]]-`x'[`m'[_n-1]-1])
			    /(`w'[`m'[_n-1]]-`w'[`m'[_n-1]-1]) )
			in 2/`group'
			if `m'>1 & (_n-1)*`dw'<`w'[`m'-1] ;
		#delimit cr
		replace `x' = `qx'
	}
end

program define Moveup
	syntax [varlist] [if] [in]
	tokenize `varlist'
	tempvar doit m mm
	mark `doit' `if' `in'
	quietly {
		gen `c(obs_t)' `mm' = cond(`doit'[_N],_N,.) in 1
		replace  `mm' = cond(`doit'[_N-_n+1],_N-_n+1,`mm'[_n-1]) in 2/l
		gen `c(obs_t)' `m' = `mm'[_N] in 1
		replace  `m' = `mm'[_N-`m'[_n-1]] in 2/l
		local i 1
		while `"``i''"' ~= `""' {
			replace ``i'' = ``i''[`m']
			local i = `i' + 1
		}
	}
end

/* What `"Moveup"' does:

. list
             x          n
  1.         .          1
  2.         2          2
  3.         .          3
  4.         6          4
  5.         7          5

. Moveup x if x<.

. list
             x          n
  1.         2          1
  2.         6          2
  3.         7          3
  4.         .          4
  5.         .          5

Note: Data other than x is left in place.
*/

program define Matchup  /* matchvar datavar */
	local m `"`1'"'  /* data must be sorted by `m' */
	local x `"`2'"'
	local type : type `x'
	tempvar k y
	quietly {
		gen long `k' = 1 in 1
		replace `k' = cond(`m'[`k'[_n-1]+1]==_n, /*
		*/	      `k'[_n-1]+1, `k'[_n-1]) in 2/-1
		gen `type' `y' = cond(`m'[`k']==_n, `x'[`k'], .)
		drop `x'
		rename `y' `x'
	}
end

/* What `"Matchup"' does:

. list
             m          x
  1.         2         56
  2.         4         14
  3.         5         11
  4.         .         65
  5.         .         61
  6.         .         69

. Matchup m x

. list
             m          x
  1.         2          .
  2.         4         56
  3.         5          .
  4.         .         14
  5.         .         11
  6.         .          .
*/

program define Revlag
	local x   `"`1'"'
	local max `"`2'"'
	tempvar y
	local type : type `x'
	quietly {
		gen `type' `y' = `x'[`max'-_n+1] in 1/`max'
		replace `y' = `y'[_n-1] if `y'>=. in 1/`max'
		replace `x' = `y'[`max'-_n+1] in 1/`max'
	}
end

/* What `"Revlag"' (reverse lag) does:  Consider the x above.

. Revlag x 6

. list x
             x
  1.        56
  2.        56
  3.        14
  4.        14
  5.        11
  6.         .
*/

program define Getivars, rclass
	local beta `"`1'"'

	if `"`beta'"' == `""' {
		local beta e(b)
	}
	local ivars : colnames `beta'
	local nvar  : word count `ivars'
	_ms_omit_info `beta'
	local nvar = `nvar' - r(k_omit)
	tokenize `ivars'
	if `"``nvar''"' == `"_cons"' { /* look at last element */
		local `nvar'       /* erase last macro */
		local ivars `"`*'"'
	}
	else if `"`1'"' == `"_cons"' { /* look at first element */
		macro shift
		local ivars `"`*'"'
	}
	else { /* step through elements to capture `"_cons"' */
		local ivars `"`1'"'
		local i 2
		while `"``i''"' != `""' {
			if `"``i''"' != `"_cons"' {
				local ivars `"`ivars' ``i''"'
			}
			local i = `i' + 1
		}
	}
	ret local ivars `ivars'
	ret local N_vars = `nvar'
end
