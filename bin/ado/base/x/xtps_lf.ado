*! version 1.1.0  19feb2019
program define xtps_lf  /* random-effects xtpoisson log likelihood */
        version 6
	args todo b lnf g H

	tempname lnalpha alpha m lngm
        tempvar z lam sumlam sumy
	mleval `z' = `b', eq(1)
	mleval `lnalpha' = `b', eq(2) scalar

	local bound -30
	if `lnalpha' < `bound' { scalar `lnalpha' = `bound' }

	scalar `alpha' = exp(`lnalpha')
	scalar `m'     = exp(-`lnalpha')
	scalar `lngm'  = lngamma(`m')

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

		mlsum `lnf' = cond(`sumy'!=., lngamma(`m'+`sumy') /*
		*/ - `lngm' - (`m'+`sumy')*ln1p(`alpha'*`sumlam') /*
		*/ + `lnalpha'*`sumy', 0) - lngamma(`y'+1) + `y'*`z'

		if `todo' == 0 | `lnf'==. { exit }

/* Calculate gradient. */

		tempname g1 g2 digm
		scalar `digm' = digamma(`m')

		`by': replace `z' = /*
		*/ (1+`alpha'*`sumy'[_N])/(1+`alpha'*`sumlam'[_N]) if $ML_samp

		mlvecsum `lnf' `g1' = `y' - `z'*`lam', eq(1)

		mlvecsum `lnf' `g2' = cond(`sumy'!=., /*
		*/ `m'*(`digm' - digamma(`m'+`sumy') /*
		*/ + ln1p(`alpha'*`sumlam')) + `sumy' /*
		*/ - `z'*`sumlam', 0), eq(2)

		matrix `g' = (`g1',`g2')

		if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

		tempname d11 d11i d12 d22 trigm

		`by': replace `z' = `alpha'*(`sumy'[_N]-`sumlam'[_N]) /*
		*/ /(1+`alpha'*`sumlam'[_N])^2 if $ML_samp

		mlmatsum `lnf' `d12' = `z'*`lam', eq(1,2)

		scalar `trigm' = trigamma(`m')

		mlmatsum `lnf' `d22' = cond(`sumy'!=., /*
		*/ `m'*(`digm' - digamma(`m'+`sumy') /*
		*/ + ln1p(`alpha'*`sumlam')) /*
		*/ + `m'^2*(`trigm' - trigamma(`m'+`sumy')) /*
		*/ - `sumlam'/(1+`alpha'*`sumlam') + `z'*`sumlam', 0), eq(2)

		local names : colnames(`b')
		tokenize `names'
		local n : word count `names'
		local i 1
		while `i' < `n' {
			if "``i''"=="_cons" { local `i' 1 }

			`by': replace `z' = sum(`lam'*``i'') if $ML_samp
			`by': replace `z' =  ((1+`alpha'*`sumy'[_N]) /*
			*/ /(1+`alpha'*`sumlam'[_N]))*(`lam'*``i'' /*
			*/ - `alpha'*`z'[_N]*`lam'/(1+`alpha'*`sumlam'[_N])) /*
			*/ if $ML_samp

			mlvecsum `lnf' `d11i' = `z', eq(1)

			if `lnf'==. { exit }

			mat `d11' = nullmat(`d11') \ `d11i'

			local i = `i' + 1
		}

		mat `d11' = 0.5*(`d11' + `d11'') /* make perfectly symmetric */

		matrix `H' = (`d11',`d12' \ `d12'',`d22')
	}
end
