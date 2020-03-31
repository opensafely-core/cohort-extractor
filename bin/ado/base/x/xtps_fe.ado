*! version 1.0.0  26feb1999
program define xtps_fe /* fixed-effects xtpoisson log likelihood */
        version 6
	args todo b lnf g H

        tempvar z lam sumlam sumy
	mleval `z' = `b'
	local y "$ML_y1"
	local by "by $S_XTby"

	quietly {

/* Calculate the log-likelihood. */

		gen double `lam' = exp(`z') if $ML_samp
		`by': gen double `sumlam' = cond(_n==_N,sum(`lam'),.) /*
		*/ if $ML_samp
		`by': gen double `sumy' = cond(_n==_N,sum(`y'),.) if $ML_samp

					/* Note: missing values for _n < _N
					   makes evaluations of cond() below
					   fast
					*/

		mlsum `lnf' = cond(`sumy'!=., lngamma(`sumy'+1) /*
		*/ - `sumy'*ln(`sumlam'), 0) - lngamma(`y'+1) + `y'*`z'

		if `todo' == 0 | `lnf'==. { exit }

/* Calculate gradient. */

		`by': replace `z' = `sumy'[_N]/`sumlam'[_N] if $ML_samp

		mlvecsum `lnf' `g' = `y' - `z'*`lam'

		if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

		capture mat drop `H'
		tempname Hi
		local names : colnames(`b')
		tokenize `names'
		local i 1
		while "``i''"!="" {
			if "``i''"=="_cons" { local `i' 1 }

			`by': replace `sumy' = sum(`lam'*``i'') if $ML_samp
			`by': replace `sumy' = `z'*`lam'*(``i'' /*
			*/ - `sumy'[_N]/`sumlam'[_N]) if $ML_samp

			mlvecsum `lnf' `Hi' = `sumy'

			if `lnf'==. { exit }

			mat `H' = nullmat(`H') \ `Hi'

			local i = `i' + 1
		}

		mat `H' = 0.5*(`H' + `H'') /* make perfectly symmetric */
	}
end
