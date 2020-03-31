*! version 1.4.1  01may2019
program define scob_lf
        version 6
	args todo b lnf g H sc1 sc2

/* Calculate the log-likelihood. */

        tempvar xb alpha
	mleval `xb' = `b', eq(1)
	mleval `alpha' = `b', eq(2) scalar

	local bound 18
	if abs(`alpha') > `bound' { scalar `alpha' = `bound'*sign(`alpha') }
	scalar `alpha' = exp(`alpha')

	if `todo' == 0 {
		local f "((1+exp(`xb'))^(-`alpha'))"
		mlsum `lnf' = cond($ML_y1!=0, ln1m(`f'), ln(`f'))
		exit
	}

	quietly {
		tempvar f
$ML_ec		tempname g1 g2

		replace `xb' = exp(`xb')
		gen double `f' = (1+`xb')^(-`alpha') if $ML_samp

		mlsum `lnf' = cond($ML_y1!=0, ln1m(`f'), ln(`f'))

		if `lnf'==. { exit }

/* Calculate the scores and gradient. */

		local ff "cond($ML_y1!=0, -`f'/(1-`f'), 1)"

		replace `sc1' = -`ff'*`alpha'*`xb'/(1+`xb') if $ML_samp
		replace `sc2' = -`ff'*`alpha'*ln1p(`xb')    if $ML_samp

$ML_ec		mlvecsum `lnf' `g1' = `sc1', eq(1)
$ML_ec		mlvecsum `lnf' `g2' = `sc2', eq(2)
$ML_ec		matrix `g' = (`g1',`g2')

		if `todo' == 1 | `lnf'==. { exit }

/* Calculate the negative hessian. */

		tempname d11 d12 d22
		mlmatsum `lnf' `d11' = cond($ML_y1!=0, /*
		*/ -`f'*(1-`alpha'*`xb'/(1-`f'))/(1-`f'), 1) /*
		*/ *`alpha'*`xb'/(1+`xb')^2, eq(1)

		replace `f' = -`f'*(1-`alpha'*ln1p(`xb')/(1-`f'))/(1-`f') /*
		*/ if $ML_y1!=0 & $ML_samp

		mlmatsum `lnf' `d12' = cond($ML_y1!=0,`f',1) /*
		*/ *`alpha'*`xb'/(1+`xb'), eq(1,2)

		mlmatsum `lnf' `d22' = cond($ML_y1!=0,`f',1) /*
		*/ *`alpha'*ln1p(`xb'), eq(2)

		matrix `H' = (`d11',`d12' \ `d12'',`d22')
	}
end
