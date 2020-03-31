*! version 2.4.0  19feb2019
program define trnb_cons
	version 8.0
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
		*/	+`y'*`xb'-ln1m(exp(-exp(`xb')))
	}
	else {
	    mlsum `lnf' = lngamma(`y'+`m') - lngamma(`y'+1) - lngamma(`m') /*
		*/ + `lndelta'*`y' - (`y'+`m')*`lnoned' /*
                */  - ln1m((1+`delta')^(-`m'))
                
	}

	if (`todo' == 0 | `lnf'==.)  exit

/* Calculate the scores and gradient. */
        tempvar z1 z2 z3
        qui gen double `z1'= exp(-`mu') if $ML_samp
        qui gen double `z2'= `m'*(digamma(`y'+`m') - digamma(`m') - `lnoned')/*
                      */ if $ML_samp
        qui gen double `z3'=1-(1+`delta')^(-`m') if $ML_samp
	if `lndelta' < -20 {
		qui replace `g1' = `y' - `mu'- `z1'*`mu'/(1-`z1') if $ML_samp
		qui replace `g2' = 0 if $ML_samp
	}
	else {
		qui replace `g1' = `z2'-(1+`delta')^(-`m')*`lnoned'*`m' /*
                */ / `z3' if $ML_samp

		qui replace `g2' = `y' -(`y'+`m')*`delta'/(1+`delta') - `z2' /*
                */ + (1+ `delta')^(-`m')*(`m'*ln1p(`delta') /*
                */ -`mu'/(1+`delta') )/ `z3'  if $ML_samp
	}
$ML_ec	tempname d1 d2
$ML_ec	mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec	mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec	matrix `g' = (`d1',`d2')

	if (`todo' == 1 | `lnf'==.)  exit

/* Calculate negative hessian. */

	tempname d11 d12 d22
	tempvar dd
        tempvar z4 z5

        qui gen double `z4'=(1+`delta')^(-`m')*ln1p(`delta')*(-`m') if $ML_samp
        qui gen double `z5'=(1+`delta')^(-`m')*(-ln1p(`delta')*(`m') /*
                     */ +`mu'/(1+`delta')) if $ML_samp
	if `lndelta' < -20 {
		mlmatsum `lnf' `d11' = `mu'- /*
                    */ (`mu'^2* `z1'+ `z1'^2 * `mu'-`z1'*`mu')/((1-`z1')^2) /*
                    */, eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	}
	else {	
		qui gen double `dd' = -`m'*(digamma(`y'+`m') - digamma(`m') /*
		   */ - `lnoned' + `m'*(trigamma(`y'+`m') - trigamma(`m'))) /*
                   */ if $ML_samp

		mlmatsum `lnf' `d11' = `dd'+ (`z4'*(`lnoned'*`m'-1)*`z3'-/*
                   */ (`z4')^2)/(`z3')^2, eq(1)

		mlmatsum `lnf' `d12' = `m'*`delta'/(1+`delta') - `dd' /*
                   */ -((1-`z3')*(`lnoned'*`m'-`mu'/(1+`delta'))* /*
                   */ (-`lnoned'*`m'+1)*`z3'+ /*
                   */ `z4'*(1-`z3')*(`m'*`lnoned'-`mu'/(1+`delta'))) /*
                   */ /(`z3')^2, eq(1,2)

		mlmatsum `lnf' `d22' = `delta'*(`y'-`m'*(1+2*`delta')) /*
	           */ /(1+`delta')^2 + `dd'- /*
                   */ ((1-`z3')*((-`mu'/(1+`delta')+`m'*`lnoned')^2+ /*
                   */ `mu'*`delta'/((1+`delta')^2)-`m'*`lnoned'+ /*
                   */ `mu'/(1+`delta'))*`z3'+ /*
                   */ `z5'^2)/(`z3')^2, eq(2)
	}
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end
