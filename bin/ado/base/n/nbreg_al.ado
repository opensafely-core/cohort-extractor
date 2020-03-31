*! version 1.4.0  19feb2019
program define nbreg_al
	version 6.0
	args todo b lnf g H g1 g2

/* Calculate the log-likelihood. */

	tempvar m
	tempname lndelta delta lnoned

	mleval `m' = `b', eq(1)
	mleval `lndelta' = `b', eq(2) scalar

	scalar `delta' = exp(`lndelta')
	scalar `lnoned' = ln1p(`delta')
	
	tempvar xb mu
	qui generate `xb' = `m' if $ML_samp
	qui generate `mu' = exp(`xb') if $ML_samp
	qui replace `m' = exp(`m'-`lndelta')  if $ML_samp

	local y "$ML_y1"

	if `lndelta' < -20 {
		mlsum `lnf' = -lngamma(`y'+1) - `mu' /*
		*/	+`y'*`xb'
	}
	else {
		mlsum `lnf' = lngamma(`y'+`m') - lngamma(`y'+1) - lngamma(`m') /*
		*/ + `lndelta'*`y' - (`y'+`m')*`lnoned'
	}

	if `todo' == 0 | `lnf'==. { exit }

/* Calculate the scores and gradient. */

	if `lndelta' < -20 {
		qui replace `g1' = `y' - `mu' if $ML_samp
		qui replace `g2' = 0 if $ML_samp
	}
	else {
		qui replace `g1' = `m'*(digamma(`y'+`m') - digamma(`m') - `lnoned') /*
		*/ if $ML_samp

		qui replace `g2' = `y' - (`y'+`m')*`delta'/(1+`delta') - `g1' /*
		*/ if $ML_samp
	}
$ML_ec	tempname d1 d2
$ML_ec	mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec	mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec	matrix `g' = (`d1',`d2')

	if `todo' == 1 | `lnf'==. { exit }

/* Calculate negative hessian. */

	tempname d11 d12 d22
	tempvar dd

	if `lndelta' < -20 {
		mlmatsum `lnf' `d11' = `mu', eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	}
	else {	
		qui gen double `dd' = -`m'*(digamma(`y'+`m') - digamma(`m') /*
		*/  - `lnoned' + `m'*(trigamma(`y'+`m') - trigamma(`m'))) if $ML_samp

		mlmatsum `lnf' `d11' = `dd', eq(1)

		mlmatsum `lnf' `d12' = `m'*`delta'/(1+`delta') - `dd', eq(1,2)

		mlmatsum `lnf' `d22' = `delta'*(`y'-`m'*(1+2*`delta')) /*
		*/ /(1+`delta')^2 + `dd', eq(2)
	}
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end
