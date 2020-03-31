*! version 1.0.1  17mar1999
program define xtnb_fe /* fixed-effects xtnbreg log likelihood */
        version 6
	args todo b lnf g H

        tempvar lam sumlam sumy f
	mleval `lam' = `b'
	local y "$ML_y1"
	local by "by $S_XTby"

	quietly {

/* Calculate the log-likelihood. */

		replace `lam' = exp(`lam') if $ML_samp
		`by': gen double `sumlam' = cond(_n==_N,sum(`lam'),.) /*
		*/ if $ML_samp
		`by': gen double `sumy' = cond(_n==_N,sum(`y'),.) if $ML_samp

					/* Note: missing values for _n < _N
					   makes evaluations below fast
					*/

		`by': gen double `f' = cond(_n==_N, sum(cond(`y'==0, 0, /*
		*/ lngamma(`lam'+`y') - lngamma(`lam') - lngamma(`y'+1))) /*
		*/ + lngamma(`sumlam') + lngamma(`sumy'+1) /*
		*/ - lngamma(`sumlam'+`sumy'), 0) if $ML_samp

		capture assert `f' < 0 if `sumy'!=.
		if _rc {
			scalar `lnf' = .
			exit
		}

		mlsum `lnf' = `f'

		if `todo' == 0 | `lnf'==. { exit }

/* Calculate gradient. */

		drop `f'
		`by': gen double `f' = digamma(`sumlam') /*
		*/ - digamma(`sumlam'+`sumy') if _n==_N & $ML_samp
		`by': replace `f' = `f'[_N] + digamma(`lam'+`y') /*
		*/ - digamma(`lam') if $ML_samp

		mlvecsum `lnf' `g' = `lam'*`f'

		if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

		replace `f' = `f' + `lam'*(trigamma(`lam'+`y') /*
		*/ - trigamma(`lam')) if $ML_samp

		replace `sumy' = trigamma(`sumlam') - trigamma(`sumlam'+`sumy')

		capture mat drop `H'
		tempname Hi
		local names : colnames(`b')
		tokenize `names'
		local i 1
		while "``i''"!="" {
			if "``i''"=="_cons" { local `i' 1 }

			`by': replace `sumlam' = sum(`lam'*``i'') if $ML_samp
			`by': replace `sumlam' = -`lam'*(`f'*``i'' /*
			*/ + `sumy'[_N]*`sumlam'[_N]) if $ML_samp

			mlvecsum `lnf' `Hi' = `sumlam'

			if `lnf'==. { exit }

			mat `H' = nullmat(`H') \ `Hi'

			local i = `i' + 1
		}

		mat `H' = 0.5*(`H' + `H'') /* make perfectly symmetric */
	}
end
