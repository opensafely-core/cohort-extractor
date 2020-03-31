*! version 4.1.3  16aug2019
program define ttest, rclass byable(recall)
	version 6, missing

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname [=/exp] [if] [in] [, /*
	*/ BY(varname) UNPaired UNEqual Welch Level(cilevel) REVerse]

	tempvar touse
	mark `touse' `if' `in'

	if `"`exp'"'!="" {
		if "`by'"!="" {
			di as smcl as error ///
				"may not combine = and option {bf:by()}"
			exit 198
		}
		if "`reverse'"!="" {
			di as smcl as error	///
				"may not combine = and option {bf:reverse}"
			exit 198
		}

		if "`unpaire'"!="" { /* do two-sample (unpaired) test */

			confirm variable `exp'

			_ttest two ttesti `level' `touse' `varlist' `exp' /*
			*/ `unequal' `welch'
			ret add
			exit
		}

		/* If here, we do one-sample (paired) test. */

		if "`unequal'"!="" {
			di in red /*
		*/ "unequal option invalid for one-sample or paired tests"
			exit 198
		}
		if "`welch'"!="" {
			di in red /*
		*/ "welch option invalid for one-sample or paired tests"
			exit 198
		}

		capture confirm number `exp'
		if _rc==0 {
			_ttest one ttesti `level' `touse' `varlist' `exp'
			ret add
			exit
		}

		confirm variable `exp'

		Paired `level' `touse' `varlist' `exp'
		ret add
		exit
	}

	/* If here, do two-sample (unpaired) test with by(). */

	if "`by'"=="" {
                di as smcl as error "{bf:by()} option required"
                exit 100
        }

/*
        confirm variable `by'
        local nbyvars : word count `by'
        if `nbyvars' > 1 {
                di in red "only one variable allowed in by()"
                exit 103
        }
*/	
        _ttest by ttesti `level' `touse' `varlist' `by' `unequal' `welch' ///
		`reverse'			 
	ret add
end

program define Paired, rclass
	args level touse xvar1 xvar2

	/* Erase S_# -- will double save in S_# and r() */
        global S_1  /* will contain #obs 1 or #obs               */
        global S_2  /*              mean 1 or mean               */
        global S_3  /*              #obs 2 (or empty)            */
        global S_4  /*              mean 2 (or empty)            */
        global S_5  /*              df                           */
        global S_6  /*              t                            */
        global S_7  /*              two-sided p-value            */
        global S_8  /*              left  one-sided p-value      */
        global S_9  /*              right one-sided p-value      */
        global S_10 /*              std. err. (denominator of t) */
        global S_11 /*              std. dev. 1                  */
        global S_12 /*              std. dev. 2                  */
        global S_13 /*              empty for paired             */


	unabbrev `xvar2'
	local xvar2 "`s(varlist)'"

	tempvar diff

	quietly {
		gen double `diff' = `xvar1' - `xvar2' if `touse'

		summarize `diff'
		local n = r(N)
		local m = r(mean)
		local s = sqrt(r(Var))

		if `n' == 0 { noisily error 2000 }

		summarize `xvar1' if `diff'<.
		local m1 = r(mean)
		local s1 = sqrt(r(Var))

		summarize `xvar2' if `diff'<.
		local m2 = r(mean)
		local s2 = sqrt(r(Var))
	}

/* Compute statistics. */

        local t  = `m'*sqrt(`n')/`s'
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

	di _n in gr "Paired t test"

	_ttest header `level' `xvar1'

	_ttest table `level' `xvar1' `n' `m1' `s1'
	_ttest table `level' `xvar2' `n' `m2' `s2'
	_ttest divline

	_ttest table `level' "diff" `n' `m' `s'

	_ttest botline
	di as txt _col(6) "mean(diff) = mean(" as res /// 
		abbrev(`"`xvar1'"',16) as txt ///
		" - " as res abbrev(`"`xvar2'"',16) as txt ")" ///
		as txt _col(67) "t = " as res %8.4f `t'

/* Display Ho. */

	di as txt " Ho: mean(diff) = 0" _col(50) as txt ///
		"degrees of freedom = " as res %8.0f `n'-1

/* Display Ha. */

        local tt : di %8.4f `t'
        local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: mean(diff) < 0"  /*
	*/             "Ha: mean(diff) != 0" /*
	*/             "Ha: mean(diff) > 0"

        _ttest center2 "Pr(T < t) = @`p1'@"   /*
        */             "Pr(|T| > |t|) = @`p2'@" /*
        */             "Pr(T > t) = @`p3'@"

/* Save results. */

	/* double save in S_# and r() */
	ret scalar N_1  = `n'
	ret scalar mu_1 = `m1'
	ret scalar N_2  = `n'
	ret scalar mu_2 = `m2'
	ret scalar df_t = `n' - 1
	ret scalar t    = `t'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar p_u  = `pr'
	ret scalar se   = `se'
	ret scalar sd_1 = `s1'
	ret scalar sd_2 = `s2'
	ret scalar level = `level'

        global S_1  `n'
        global S_2  `m1'
	global S_3  `n'
	global S_4  `m2'
        global S_5 =`n' - 1
	global S_6  `t'
	global S_7  `p'
	global S_8  `pl'
	global S_9  `pr'
	global S_10 `se'
        global S_11 `s1'
        global S_12 `s2'

end
