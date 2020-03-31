*! version 3.1.7  16aug2019
program define ttesti, rclass
	version 6.0

	/* Clearing S_# -- will double save in S_# and r() */
	global S_1  /* will contain #obs 1 or #obs                */
   	global S_2  /*              mean 1 or mean                */
	global S_3  /*              #obs 2 (or empty)             */
	global S_4  /*              mean 2 (or empty)             */
	global S_5  /*              df                            */
	global S_6  /*              t                             */
	global S_7  /*              two-sided p-value             */
	global S_8  /*              left  one-sided p-value       */
	global S_9  /*              right one-sided p-value       */
	global S_10 /*              std. err. (denominator of t)  */
	global S_11 /*              std. dev. 1 or std. dev.      */
	global S_12 /*              std. dev. 2 (or empty)        */
	global S_13 /*              combined std. dev. (or empty) */

/* Parse. */

	gettoken 1 0 : 0 , parse(" ,")
	gettoken 2 0 : 0 , parse(" ,")
	gettoken 3 0 : 0 , parse(" ,")
	gettoken 4 0 : 0 , parse(" ,")
	gettoken 5 : 0 , parse(" ,")

	if "`5'"=="" | "`5'"=="," { /* Do one-sample test */

		local args1 "`1' `2' `3' `4'"
		syntax [, Xname(string) Yname(string) Level(cilevel) reverse]

                _ttest check ttest one `args1' /* check numbers */

                OneTest `args1' `level' `"`xname'"'
		ret add

                exit
        }

/* Here only if two-sample test. */

	gettoken 5 0 : 0 , parse(" ,")
	gettoken 6 0 : 0 , parse(" ,")
        local arg1 "`1' `2' `3'"
        local arg2 "`4' `5' `6'"

	syntax [, Xname(string) Yname(string) UNEqual Welch	///
		Level(cilevel) REVerse]

        _ttest check ttest first  `arg1' /* check numbers */
        _ttest check ttest second `arg2' /* check numbers */

        TwoTest `arg1' `arg2' `level' `"`xname'"' `"`yname'"' /*
			*/ "`unequal'" "`welch'" "`reverse'"
	ret add
end

program define OneTest, rclass
	args n m s m0 level xname

/* Compute statistics. */

	if `n' == 1 { local s . } /* error check allows std dev to be 0 */

	local t = (`m' - `m0')*sqrt(`n')/`s'
	local se = `s'/sqrt(`n')

	local p = tprob(`n'-1,`t')
	if `t' < 0 {
		local pl = `p'/2
		local pr = 1 - `pl'
	}
	else {
		local pr = `p'/2
		local pl = 1 - `pr'
	}

/* Display table of mean, std err, etc. */

	di _n in gr "One-sample t test"

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" { local xname "x" }

	_ttest table `level' `"`xname'"' `n' `m' `s'
	_ttest botline

/* Display Ho. */

	if length("`m0'") > 8 {
		local m0 : di %8.0g `m0'
		local m0 = trim("`m0'")
	}

	di as txt "    mean = mean(" as res `"`xname'"' as txt ")" ///
		_col(67) as txt "t = " as res %8.4f `t'

	di as txt "Ho: mean = " as res `"`m0'"' _col(50) as txt ///
		"degrees of freedom = " as res %8.0f (`n'-1)

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: mean < @`m0'@"  /*
	*/             "Ha: mean != @`m0'@" /*
	*/             "Ha: mean > @`m0'@"

	_ttest center2 "Pr(T < t) = @`p1'@"   /*
	*/             "Pr(|T| > |t|) = @`p2'@" /*
	*/             "Pr(T > t) = @`p3'@"

	/* double save in S_# and r() */
	ret scalar N_1  = `n'
	ret scalar mu_1 = `m'
	ret scalar df_t = `n' - 1
	ret scalar t    = `t'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar p_u  = `pr'
	ret scalar se   = `se'
	ret scalar sd_1 = `s'
	ret scalar level = `level'
	global S_1  `n'
	global S_2  `m'
	global S_5 =`n' - 1
	global S_6  `t'
	global S_7  `p'
	global S_8  `pl'
	global S_9  `pr'
	global S_10 `se'
	global S_11 `s'
end

program define TwoTest, rclass
	args n1 m1 s1 n2 m2 s2 level xname yname unequal welch

/* Compute statistics. */

        if `n1' == 1 { local s1 . } /* error check allows std dev to be 0 */
        if `n2' == 1 { local s2 . }

	tempname var

	if "`unequal'"!="" | "`welch'"!="" {
		local un "un"

		scalar `var' = (`s1')^2/`n1' + (`s2')^2/`n2'

		if "`welch'"!="" {
			local df = -2 + `var'^2            /*
			*/ /( ((`s1')^2/`n1')^2/(`n1'+1)   /*
			*/  + ((`s2')^2/`n2')^2/(`n2'+1) )
		}
		else {
			local df = `var'^2                 /*
			*/ /( ((`s1')^2/`n1')^2/(`n1'-1)   /*
			*/  + ((`s2')^2/`n2')^2/(`n2'-1) )
		}
	}
	else {
		local df = `n1' + `n2' - 2
		scalar `var' = (((`n1'-1)*(`s1')^2+(`n2'-1)*(`s2')^2)/`df') /*
		*/             *(1/`n1' + 1/`n2')
	}

	local t  = (`m1'-`m2')/sqrt(`var')
	local se = sqrt(`var')

	local p = tprob(`df',`t')
	if `t' < 0 {
		local pl = `p'/2
		local pr = 1 - `pl'
	}
	else {
		local pr = `p'/2
		local pl = 1 - `pr'
	}

/* Display table of mean, std err, etc. */

	di _n in gr "Two-sample t test with `un'equal variances"

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" { local xname "x" }
	if `"`yname'"'=="" { local yname "y" }

	_ttest table `level' `"`xname'"' `n1' `m1' `s1'
	_ttest table `level' `"`yname'"' `n2' `m2' `s2'
	_ttest divline

/* Display combined mean, etc. */

	local n = `n1' + `n2'

	tempname m s /* use scalars to get every possible digit of accuracy */

	scalar `m' = (`n1'*`m1'+`n2'*`m2')/`n'
	scalar `s' = sqrt(( (`n1'-1)*(`s1')^2 + `n1'*(`m'-`m1')^2 /*
	*/                + (`n2'-1)*(`s2')^2 + `n2'*(`m'-`m2')^2)/(`n'-1))

	_ttest table `level' "combined" `n' `m' `s'
	_ttest divline 

/* Display difference. */

	_ttest dtable `level' "diff" `n' `m1'-`m2' `se' `df'

	_ttest botline

	if "`welch'"!="" {
		local dft "Welch's degrees of freedom = " 
		local dfc 42
	}
	else if "`unequal'"!="" {
		local dft "Satterthwaite's degrees of freedom = " 
		local dfc 34
	}
	else {
		local dft "degrees of freedom = " 
		local dfc 50
	}
	
/* Display error messages. */


/* Display Ho. */

	di as txt _col(5) "diff = mean(" as res abbrev(`"`xname'"',16) ///
		as txt ") - mean(" as res abbrev(`"`yname'"',16) ///
		as txt ")" _col(67) ///
		as txt "t = " as res %8.4f `t'
	di as txt "Ho: diff = 0" _col(`dfc') as txt "`dft'" as res %8.0g `df'

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: diff < 0" "Ha: diff != 0" "Ha: diff > 0"

	_ttest center2 "Pr(T < t) = @`p1'@"   /*
	*/             "Pr(|T| > |t|) = @`p2'@" /*
	*/             "Pr(T > t) = @`p3'@"

	/* double save in S_# and r() */
        ret scalar N_1  = `n1'
        ret scalar mu_1 = `m1'
        ret scalar N_2  = `n2'
        ret scalar mu_2 = `m2'
        ret scalar df_t = `df'
        ret scalar t    = `t'
        ret scalar p    = `p'
        ret scalar p_l  = `pl'
        ret scalar p_u  = `pr'
        ret scalar se   = `se'
        ret scalar sd_1 = `s1'
        ret scalar sd_2 = `s2'
        ret scalar sd   = `s'
	ret scalar level = `level'

	global S_1  `n1'
   	global S_2  `m1'
	global S_3  `n2'
	global S_4  `m2'
	global S_5  `df'
	global S_6  `t'
	global S_7  `p'
	global S_8  `pl'
	global S_9  `pr'
	global S_10 `se'
	global S_11 `s1'
	global S_12 `s2'
	global S_13 = `s'
end
