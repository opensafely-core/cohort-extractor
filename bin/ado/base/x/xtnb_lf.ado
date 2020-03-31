*! version 2.0.1  17mar1999
program define xtnb_lf  /* random-effects xtnbreg log likelihood */
        version 6
	args todo b lnf g H

        tempvar lam sumlam sumy f
	tempname r s lngrs
	mleval `lam' = `b', eq(1)
	mleval `r' = `b', eq(2) scalar
	mleval `s' = `b', eq(3) scalar

	local bound 20
	if abs(`r') > `bound' { scalar `r' = sign(`r')*`bound' }
	if abs(`s') > `bound' { scalar `s' = sign(`s')*`bound' }

	scalar `r' = exp(`r')
	scalar `s' = exp(`s')
	scalar `lngrs' = lngamma(`r'+`s') - lngamma(`r') - lngamma(`s')

	local y "$ML_y1"
	local by "by $S_XTby"

	quietly {

/* Calculate the log-likelihood. */

		replace `lam' = exp(`lam') if $ML_samp
		`by': gen double `sumlam' = cond(_n==_N,sum(`lam'),.) /*
		*/ if $ML_samp
		`by': gen double `sumy' = cond(_n==_N,sum(`y'),.) if $ML_samp

					/* Note: missing values for _n < _N
					   makes evaluations of below fast
					*/

		`by': gen double `f' = cond(_n==_N, sum(cond(`y'==0, 0, /*
		*/ lngamma(`lam'+`y') - lngamma(`lam') - lngamma(`y'+1))) /*
		*/ + `lngrs' + lngamma(`r'+`sumlam') + lngamma(`s'+`sumy') /*
		*/ - lngamma(`r'+`s'+`sumlam'+`sumy'), 0) if $ML_samp

		capture assert `f' < 0 if `sumy'!=.
		if _rc {
			scalar `lnf' = .
			exit
		}

		mlsum `lnf' = `f'

		if `todo' == 0 | `lnf'==. { exit }

/* Calculate gradient. */

		drop `f'
		tempname g1 g2 g3 digr digs
		tempvar dfr dfs
		`by': gen double `dfr' = digamma(`r'+`sumlam') /*
		*/ - digamma(`r'+`s'+`sumlam'+`sumy') if _n==_N & $ML_samp
		`by': replace `dfr' = `dfr'[_N]
		`by': gen double `dfs' = digamma(`s'+`sumy') /*
		*/ - digamma(`r'+`s'+`sumlam'+`sumy') if _n==_N & $ML_samp

		mlvecsum `lnf' `g1' = `lam'*(`dfr'+ digamma(`lam'+`y') /*
		*/ - digamma(`lam')), eq(1)

		scalar `digr' = digamma(`r'+`s') - digamma(`r')
		mlvecsum `lnf' `g2' = cond(`sumy'!=., /*
		*/ `r'*(`digr'+`dfr'), 0), eq(2)

		scalar `digs' = digamma(`r'+`s') - digamma(`s')
		mlvecsum `lnf' `g3' = cond(`sumy'!=., /*
		*/ `s'*(`digs'+`dfs'), 0), eq(3)

		mat `g' = (`g1',`g2',`g3')

		if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

		tempname d11 d11i d12 d13 d22 d23 d33 trig
		tempvar triall
		`by': gen double `triall' = trigamma(`r'+`s'+`sumlam'+`sumy') /*
		*/ if _n==_N & $ML_samp
		`by': replace `triall' = `triall'[_N]

		scalar `trig' = trigamma(`r'+`s') - trigamma(`s')
		mlmatsum `lnf' `d33' = cond(`sumy'!=., /*
		*/ -`s'*(`digs' + `dfs' + `s'*(`trig' + /*
		*/ trigamma(`s'+`sumy') - `triall')), 0), eq(3)

		`by': replace `dfs' = trigamma(`r'+`sumlam') /*
		*/ if _n==_N & $ML_samp
		`by': replace `dfs' = `dfs'[_N]

		scalar `trig' = trigamma(`r'+`s') - trigamma(`r')
		mlmatsum `lnf' `d22' = cond(`sumy'!=., /*
		*/ -`r'*(`digr' + `dfr' + `r'*(`trig' + /*
		*/ `dfs' - `triall')), 0), eq(2)

		scalar `trig' = trigamma(`r'+`s')
		mlmatsum `lnf' `d23' = cond(`sumy'!=., /*
		*/ -`r'*`s'*(`trig'-`triall'), 0), eq(2,3)

		mlmatsum `lnf' `d12' = -`r'*`lam'*(`dfs'-`triall'), eq(1,2)
		mlmatsum `lnf' `d13' = `s'*`lam'*`triall', eq(1,3)

		replace `dfr' = `dfr' + digamma(`lam'+`y') /*
		*/ - digamma(`lam') + `lam'*(trigamma(`lam'+`y') /*
		*/ - trigamma(`lam')) if $ML_samp

		local names : colnames(`b')
		tokenize `names'
		local n : word count `names'
		local i 1
		while `i' <= `n' - 2 {
			if "``i''"=="_cons" { local `i' 1 }

			`by': replace `sumlam' = sum(`lam'*``i'') if $ML_samp
			`by': replace `sumlam' = -`lam'*(`dfr'*``i'' /*
			*/ + (`dfs'-`triall')*`sumlam'[_N]) if $ML_samp

			mlvecsum `lnf' `d11i' = `sumlam'

			if `lnf'==. { exit }

			mat `d11' = nullmat(`d11') \ `d11i'

			local i = `i' + 1
		}

		mat `d11' = 0.5*(`d11' + `d11'') /* make perfectly symmetric */

		mat `H' = (`d11',`d12',`d13' \ `d12'',`d22',`d23' /*
		*/       \ `d13'',`d23',`d33')
	}
end
