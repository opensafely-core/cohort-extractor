*! version 4.3.2  28dec2011
program define sdtesti, rclass
	version 6.0

	/* clear S_# -- will double save in S_# and r() */
	global S_1  /* will contain total #obs                               */
   	global S_2  /*              numerator df for F (or empty for chi2)   */
	global S_3  /* always empty                                          */
	global S_4  /* always empty                                          */
	global S_5  /*              denominator df for F or df for chi2      */
	global S_6  /*              F or chi2                                */
	global S_7  /*              two-sided p-value                        */
	global S_8  /*              left  one-sided p-value                  */
	global S_9  /*              right one-sided p-value                  */
	global S_10 /* always empty                                          */
	global S_11 /*              std. dev. 1 for F or for chi2            */
	global S_12 /*              std. dev. 2 for F (or empty for chi2)    */
	global S_13 /*              combined std. dev. for F (or empty chi2) */

/* Parse. */

	gettoken 1 0 : 0 , parse(", ")
	gettoken 2 0 : 0 , parse(", ")
	gettoken 3 0 : 0 , parse(", ")
	gettoken 4 0 : 0 , parse(", ")
	gettoken 5 : 0 , parse(", ")

	if `"`5'"'=="" | `"`5'"'=="," { /* Do chi-squared test */

		local args1 `"`1' `2' `3' `4'"'
		syntax [, Xname(string) Level(cilevel) ]

		_ttest check sdtest one `args1' /* check numbers */

		ChiSqi `args1' `level' `"`xname'"'
		ret add

		exit
	}

/* Here only if two-sample variance ratio test. */

	gettoken 5 0 : 0 , parse(", ")
	gettoken 6 0 : 0 , parse(", ")
	local arg1 `"`1' `2' `3'"'
	local arg2 `"`4' `5' `6'"'
	syntax [, Xname(string) Yname(string) Level(integer $S_level)]
	if `level' < 10 | `level' > 99 {
		local level 95
	}

	_ttest check sdtest first  `arg1' /* check numbers */
	_ttest check sdtest second `arg2' /* check numbers */

	VRTi `arg1' `arg2' `level' `"`xname'"' `"`yname'"'
	ret add
end

program define ChiSqi, rclass
	args n m s s0 level xname

/* Compute statistics. */

	if `n' == 1 { local s . } /* error check allows std dev to be 0 */

	ret scalar N    = `n'
	ret scalar df   = `n' - 1
	ret scalar chi2 = return(df)*(`s')^2/(`s0')^2
	ret scalar sd   = `s'
	ret scalar p_u  = chiprob(return(df), return(chi2))
	ret scalar p_l  = 1 - return(p_u)
	if return(p_l) < return(p_u) {
		ret scalar p = 2*return(p_l)
		local ptwo "C < c"
	}
	else {
		ret scalar p = 2*return(p_u)
		local ptwo "C > c"
	}

	/* double save in S_# and r() */
	global S_1   `return(N)'
	global S_5 = return(df)
	global S_6 = return(chi2)
	global S_11  `return(sd)'
	global S_9 = return(p_u)    /* one-sided: P > chi2 */
	global S_8 = return(p_l)    /* one-sided: P < chi2 */
	global S_7 = return(p)

/* Display table of mean, std err, etc. */

	di _n in gr "One-sample test of variance"
	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" { local xname "x" }

	_ttest table `level' `"`xname'"' `n' `m' `s'
	_ttest botline


/* Display Ho. */

	local chi2 : di %8.4f return(chi2)

	if length(`"`s0'"') > 6 {
		local s0 : di %7.0g `s0'
		local s0 = trim(`"`s0'"')
	}



 	di as txt "    sd = sd(" as res `"`xname'"' as txt ")" ///
                _col(60) as txt "c = chi2 = " as res %8.4f `chi2'

        di as txt "Ho: sd = " as res `"`s0'"' _col(50) as txt ///
                "degrees of freedom = " as res %8.0f (`n'-1)


/* Display Ha. */

	local p1 : di %6.4f return(p_l)
	local p2 : di %6.4f return(p)
	local p3 : di %6.4f return(p_u)

	  di
        _ttest center2 "Ha: sd < @`s0'@"  /*
        */             "Ha: sd != @`s0'@" /*
        */             "Ha: sd > @`s0'@"

        _ttest center2 " Pr(C < c) = @`p1'@"   /*
        */             "2*Pr(`ptwo') = @`p2'@" /*
        */             " Pr(C > c) = @`p3'@"


end

program define VRTi, rclass
	args n1 m1 s1 n2 m2 s2 level xname yname

/* Compute statistics. */

	if `n1' == 1 { local s1 . } /* error check allows std dev to be 0 */
	if `n2' == 1 { local s2 . }

	ret scalar N    = `n1' + `n2'
	ret scalar df_1 = `n1' - 1
	ret scalar df_2 = `n2' - 1
	ret scalar F    = (`s1'/`s2')^2
	ret scalar sd_1 = `s1'
	ret scalar sd_2 = `s2'
	ret scalar p_u  = fprob(return(df_1),return(df_2),return(F))
	ret scalar p_l  = 1 - return(p_u)

	if return(p_l) < return(p_u) {
                ret scalar p = 2*return(p_l)
                local ptwo "F < f"
        }
        else {
                ret scalar p = 2*return(p_u)
                local ptwo "F > f"
        }


/* Display table of mean, std err, etc. */

        di _n in gr "Variance ratio test"

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" { local xname "x" }
	if `"`yname'"'=="" { local yname "y" }

	_ttest table `level' `"`xname'"' `n1' `m1' `s1'
	_ttest table `level' `"`yname'"' `n2' `m2' `s2'
	_ttest divline

	local n = `n1' + `n2'

	tempname m s /* use scalars to get every possible digit of accuracy */

	scalar `m' = (`n1'*`m1'+`n2'*`m2')/`n'
	scalar `s' = sqrt(( (`n1'-1)*(`s1')^2 + `n1'*(`m'-`m1')^2 /*
	*/                + (`n2'-1)*(`s2')^2 + `n2'*(`m'-`m2')^2)/(`n'-1))
	ret scalar sd = `s'

	/* double save in S_# and r() */
	global S_1  `return(N)'
	global S_2  `return(df_1)'
	global S_5  `return(df_2)'
	global S_6  `return(F)'
	global S_11 `return(sd_1)'
	global S_12 `return(sd_2)'
	global S_9  `return(p_u)'           /* P > Fobs */
	global S_8  `return(p_l)'           /* P < Fobs */
	global S_7  `return(p)'
	global S_13 `return(sd)'

	_ttest table `level' "combined" `n' `m' `s'
	_ttest botline

/* Display Ho. */

	
        local dft "degrees of freedom = "

	local fo : di %8.4f return(F)
	di as txt _col(5) "ratio = sd(" as res abbrev(`"`xname'"',16) ///
                as txt ") / sd(" as res abbrev(`"`yname'"',16) ///
                as txt ")" _col(67) ///
                as txt "f = " as res %8.4f "`fo'"
/* determine the space for df */
		
	local df1=return(df_1)
	local df2=return(df_2)
	if (length("`df1'")<9) {
		local len1=length("`df1'")
		
	}
	else {
		local len1=9
	}

	if (length("`df2'")<9) {
                local len2=length("`df2'")
	
        }
        else {
                local len2=9
        }

	local len3= `len1'+`len2'
	
	if (`len3'<7) {
		local space1=77-`len3'	
		di as txt "Ho: ratio = 1" _col(50) as txt "`dft'" /* 
		*/ _col(`space1') as res `df1' ", "  `df2'
	}
	else {
		local space1=56-`len3'
                di as txt "Ho: ratio = 1" _col(`space1') as txt "`dft'" /*
                */ as res  `df1' ", " `df2'
 	
	}
			

/* Display Ha. */

	local p1 : di %6.4f return(p_l)
	local p2 : di %6.4f return(p)
	local p3 : di %6.4f return(p_u)

	if length(`"`xname'`yname'"') > 8 {
		local xname 1
		local yname 2
	}

	di
	_ttest center2 "Ha: ratio < 1" "Ha: ratio != 1" "Ha: ratio > 1"

        _ttest center2 " Pr(F < f) = @`p1'@"   /*
        */             "2*Pr(`ptwo') = @`p2'@" /*
        */             "   Pr(F > f) = @`p3'@"


end
