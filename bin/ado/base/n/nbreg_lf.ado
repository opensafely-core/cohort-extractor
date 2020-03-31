*! version 1.4.0  19feb2019
program define nbreg_lf
        version 6.0
	args todo b lnf g H sc1 sc2

/* Calculate the log-likelihood. */

	tempvar xb
	tempname lnalpha m
	mleval `xb' = `b', eq(1)
	mleval `lnalpha' = `b', eq(2) scalar

	local y "$ML_y1"
	scalar `m' = exp(-`lnalpha')
	
	if `lnalpha' < -20 {
		mlsum `lnf' = -lngamma(`y'+1) - exp(`xb') /*
		*/ + `y'*`xb'
 	}
	else {
		mlsum `lnf' = lngamma(`m'+`y') - lngamma(`y'+1) /*
		*/ - lngamma(`m') - `m'*ln1p(exp(`xb'+`lnalpha')) /*
		*/ - `y'*ln1p(exp(-`xb'-`lnalpha'))
	}
	if `todo' == 0 | `lnf'==. { exit }

/* Calculate the scores and gradient. */

	tempname alpha
	tempvar mu p
	quietly {
		gen double `mu' = exp(`xb') if $ML_samp
		gen double `p' = 1/(1+exp(`xb'+`lnalpha')) if $ML_samp

		if `lnalpha'<-20 {
			replace `sc1' = `y'-`mu' if $ML_samp
			replace `sc2' = 0 if $ML_samp
		}
		else {
			replace `sc1' = `p'*(`y'-`mu') if $ML_samp
			replace `sc2' = /*
			*/ `m'*(digamma(`m') - digamma(`y'+`m') - ln(`p')) /*
			*/ + `p'*(`y'-`mu') if $ML_samp
		}
	}

$ML_ec	tempname g1 g2
$ML_ec	mlvecsum `lnf' `g1' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `g2' = `sc2', eq(2)
$ML_ec	matrix `g' = (`g1',`g2')

	if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

	tempname alpha d11 d12 d22
	scalar `alpha' = exp(`lnalpha')

	if `lnalpha' < -20 {
		mlmatsum `lnf' `d11' = `mu', eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	} 
	else {
		mlmatsum `lnf' `d11' = `mu'*`p'*(`alpha'*`p'*(`y'-`mu')+1), eq(1)
		mlmatsum `lnf' `d12' = `alpha'*`mu'*`p'^2*(`y'-`mu'), eq(1,2)
		mlmatsum `lnf' `d22' = `m'*(digamma(`m') - digamma(`y'+`m') - ln(`p') /*
		*/ - `m'*(trigamma(`y'+`m') - trigamma(`m'))) /*
		*/ + `mu'*`p'*(`alpha'*`p'*(`y'-`mu')- 1), eq(2)
	}
	
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end
