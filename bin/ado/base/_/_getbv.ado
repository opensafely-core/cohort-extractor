*! version 1.0.2  09feb2012
* subroutine called by lincom.ado and svylc.ado
program define _getbv /* test_stat b V formula */
	version 5.0
	local x "`1'"  /* test statistic with q = 0 */
	local b "`2'"
	local V "`3'"
	macro shift 3
	tempname U w r
/*
   Test statistic x = (Cb - q)*(CVC')^(-1)*(Cb - q).
*/
	local dim = colsof(`b')
*r	local eqnames : coleq(`b')
*r	local cnames  : colnames(`b')
	matrix `w' = `b'
	matrix `w'[1,1] = J(1,`dim',0)
	matrix `U' = `V'

*r	matrix `w' = J(1, `dim', 0)
*r	matrix coleq    `w' = `eqnames'
*r	matrix colnames `w' = `cnames'
	matrix coleq    `w' = `eqnames'
	matrix colnames `w' = `cnames'

	quietly {
		matrix post `w' `V'

	/* With q = +c or -c, get same result unless there is a constant. */

		test `*' =  0.9192837465
		if `"`r(F)'"' != "" { scalar `w' = r(F) }
		else if `"`r(chi2)'"' != "" { scalar `w' = r(chi2) }
		test `*' = -0.9192837465
		if `"`r(F)'"' != "" { scalar `w' = abs(`w' - r(F))/`w' }
		else if `"`r(chi2)'"' != "" { 
			scalar `w' = abs(`w' - r(chi2))/`w'
		}
		if `w' > 1e-4 & `w'!=. {
			di in red "additive constant terms not allowed"
			exit 198
		}

	/* b = 0, true V, q = 1 gives test statistic = (CVC')^(-1). */

		test `*' = 1
		if `"`r(F)'"' != "" { scalar `w' = r(F) }
		else if `"`r(chi2)'"' != "" { scalar `w' = r(chi2) }

	/* Var(Cb) = CVC' = 1/w. */

		matrix `V' = (0)
		if 1/`w'!=. { matrix `V'[1,1] = 1/`w' }
		matrix colnames `V' = (1)
		matrix rownames `V' = (1)

	/* We earlier computed x = (Cb)^2*(CVC')^(-1).
   	   Thus, r = |Cb| = sqrt(x/w).
	*/
		scalar `r' = sqrt(`x'/`w')

		if `r'==. {
			di in red "estimate equals missing value"
			exit 504
		}

	/* Determine sign of r = Cb. */

		matrix post `b' `U'  /* same as original post. */
		test `*' = `r'
		if `"`r(F)'"' != "" { scalar `w' = r(F) }
		else if `"`r(chi2)'"' != "" { scalar `w' = r(chi2) }
		test `*' = -`r'
		tempname stat
		if `"`r(F)'"' != "" { scalar `stat' = r(F) }
		else if `"`r(chi2)'"' != "" { scalar `stat' = r(chi2) }
		if `stat' < `w' { scalar `r' = -`r' }

		matrix `b' = (0)
		matrix `b'[1,1] = `r'
		matrix colnames `b' = (1)
	}
end
