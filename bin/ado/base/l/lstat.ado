*! version 3.2.0  24oct2017
program define lstat, rclass
	local vcaller = string(_caller())
	version 6.0, missing

	if "`e(wtype)'"=="iweight" {
		di as err "`e(wtype)' not allowed
		exit 101
	}

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	tempvar touse p w

	if "`e(cmd)'"=="ivprobit" {
		local vv version `vcaller':
	}
	`vv' ///
	lfit_p `touse' `p' `w' `0'

	local y "`s(depvar)'"

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [, CUToff(real 0.5)]

	if `cutoff'<0 | `cutoff'>1 { 
		di in red `"cutoff() must be between 0 and 1"'
		exit 198
	}

	quietly { 
		summ `touse' [fw=`w'] if `y'!=0 & `p'>=`cutoff' & `touse'
		local a = round(r(sum_w),1)
		summ `touse' [fw=`w'] if `y'==0 & `p'>=`cutoff' & `touse'
		local b = round(r(sum_w),1)
		summ `touse' [fw=`w'] if `y'!=0 & `p'< `cutoff' & `touse'
		local c = round(r(sum_w),1)
		summ `touse' [fw=`w'] if `y'==0 & `p'< `cutoff' & `touse'
		local d = round(r(sum_w),1)
	}
	/* double save in S_# and r() */
					          /* correctly classified */
	ret scalar P_corr = ((`a'+`d')/(`a'+`b'+`c'+`d'))*100 
	ret scalar P_p1 = (`a'/(`a'+`c'))*100     /* sensitivity          */
	ret scalar P_n0 = (`d'/(`b'+`d'))*100     /* specificity          */
	ret scalar P_p0 = (`b'/(`b'+`d'))*100     /* false + given ~D     */
	ret scalar P_n1 = (`c'/(`a'+`c'))*100     /* false - given D      */
	ret scalar P_1p = (`a'/(`a'+`b'))*100     /* + pred value         */
	ret scalar P_0n = (`d'/(`c'+`d'))*100     /* - pred value         */
	ret scalar P_0p = (`b'/(`a'+`b'))*100     /* false + given +      */
	ret scalar P_1n = (`c'/(`c'+`d'))*100     /* false - given -      */
	global S_1 "`return(P_corr)'"
	global S_2 "`return(P_p1)'"
	global S_3 "`return(P_n0)'"
	global S_4 "`return(P_p0)'"
	global S_5 "`return(P_n1)'"
	global S_6 "`return(P_1p)'"
	global S_7 "`return(P_0n)'"
	global S_8 "`return(P_0p)'"
	global S_9 "`return(P_1n)'"

	matrix Classified = J(3,3,.)
	matrix colnames Classified = D ~D Total 
	matrix rownames Classified = + - Total
	mat Classified[1,1] = `a'
	mat Classified[1,2] = `b'
	mat Classified[1,3] = `a'+`b'
	mat Classified[2,1] = `c'
	mat Classified[2,2] = `d'
        mat Classified[2,3] = `c'+`d'
	mat Classified[3,1] = `a'+`c'
	mat Classified[3,2] = `b'+`d'
	mat Classified[3,3] = `a'+`b'+`c'+`d'
	return mat ctable Classified

	#delimit ; 
	di _n in gr (cond(`"`e(cmd)'"'=="probit"|`"`e(cmd)'"'=="dprobit"| 
			  `"`e(cmd)'"'=="ivprobit",
			"Probit","Logistic")) `" model for `y'"' ;
	di _n in smcl in gr _col(15) "{hline 8} True {hline 8}" _n
                    `"Classified {c |}"' _col(22) `"D"' _col(35) 
		    `"~D  {c |}"' _col(46) `"Total"' ;
	di    in smcl in gr "{hline 11}{c +}{hline 26}{c +}{hline 11}"  ;
        di    in smcl in gr _col(6) "+" _col(12) `"{c |} "'
              in ye %9.0g `a' _col(28) %9.0g `b'
              in gr `"  {c |}  "'
              in ye %9.0g `a'+`b' ;
        di    in smcl in gr _col(6) "-" _col(12) "{c |} "
              in ye %9.0g `c' _col(28) %9.0g `d'
              in gr `"  {c |}  "'
              in ye %9.0g `c'+`d' ;
	di    in smcl in gr "{hline 11}{c +}{hline 26}{c +}{hline 11}"  ;
	di    in smcl in gr `"   Total   {c |} "'
              in ye %9.0g `a'+`c' _col(28) %9.0g `b'+`d'
              in gr `"  {c |}  "'
              in ye %9.0g `a'+`b'+`c'+`d' ;
        di _n in gr `"Classified + if predicted Pr(D) >= `cutoff'"' _n
                    `"True D defined as `y' != 0"' ;
	di    in smcl in gr "{hline 50}" ;
	di    in gr `"Sensitivity"' _col(33) `"Pr( +| D)"'
              in ye %8.2f return(P_p1) `"%"' _n
	      in gr `"Specificity"' _col(33) `"Pr( -|~D)"'
              in ye %8.2f return(P_n0) `"%"' _n
	      in gr `"Positive predictive value"' _col(33) `"Pr( D| +)"'
              in ye %8.2f return(P_1p) `"%"' _n
	      in gr `"Negative predictive value"' _col(33) `"Pr(~D| -)"'
              in ye %8.2f return(P_0n) `"%"' ;
	di    in smcl in gr "{hline 50}"  ;
	di    in gr `"False + rate for true ~D"' _col(33) `"Pr( +|~D)"'
              in ye %8.2f return(P_p0) `"%"' _n
	      in gr `"False - rate for true D"' _col(33) `"Pr( -| D)"'
              in ye %8.2f return(P_n1) `"%"' _n
	      in gr `"False + rate for classified +"' _col(33) `"Pr(~D| +)"'
              in ye %8.2f return(P_0p) `"%"' _n
	      in gr `"False - rate for classified -"' _col(33) `"Pr( D| -)"'
              in ye %8.2f return(P_1n) `"%"' ;
	di    in smcl in gr "{hline 50}"  ;
	di    in gr `"Correctly classified"' _col(42) 
	      in ye %8.2f return(P_corr) `"%"' ;
	di    in smcl in gr "{hline 50}"  ;
end ;
