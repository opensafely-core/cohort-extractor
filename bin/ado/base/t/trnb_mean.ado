*! version 1.4.0  19feb2019
program define trnb_mean
	version 8.0
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
		*/ + `y'*`xb'-ln1m(exp(-exp(`xb')))
 	}
	else {
		mlsum `lnf' = lngamma(`m'+`y') - lngamma(`y'+1) /*
		*/ - lngamma(`m') - `m'*ln1p(exp(`xb'+`lnalpha')) /*
		*/ - `y'*ln1p(exp(-`xb'-`lnalpha')) /*
                */ - ln1m((1+exp(`xb')/ `m')^(-`m'))

	}
	if (`todo' == 0 | `lnf'==.)  exit 

/* Calculate the scores and gradient. */

	tempname alpha
	tempvar mu p z1 z2
	quietly {
		gen double `mu' = exp(`xb') if $ML_samp
                gen double `z1'= exp(-`mu') if $ML_samp
                gen double `p' = 1/(1+exp(`xb'+`lnalpha')) if $ML_samp
        	gen double `z2'= 1- `p'^`m' if $ML_samp
 
		if `lnalpha'<-20 {
			replace `sc1' = `y'-`mu'- `z1'*`mu'/(1-`z1') /*
                         */  if $ML_samp
			replace `sc2' = 0 if $ML_samp
		}
		else {
			replace `sc1' = `p'*(`y'-`mu') - /*
                       */ `p'^(`m'+1)*`mu'/ `z2' if $ML_samp
			replace `sc2' = /*
			*/ `m'*(digamma(`m') - digamma(`y'+`m') - ln(`p')) /*
			*/ + `p'*(`y'-`mu') + /*
                        */ `p'^`m'*(-`m'^2*ln(`p')-`m'*`mu'*`p')/`z2'/ `m' /*
                        */ if $ML_samp
		}
	}

$ML_ec	tempname g1 g2
$ML_ec	mlvecsum `lnf' `g1' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `g2' = `sc2', eq(2)
$ML_ec	matrix `g' = (`g1',`g2')

	if (`todo' == 1 | `lnf'==. ) exit 

/* Calculate negative hessian. */

	tempname alpha d11 d12 d22
        tempvar  z3
        qui gen double `z3'= - `m'^2*ln(`p')-`m'*`mu'*`p' if $ML_samp
	scalar `alpha' = exp(`lnalpha')

	if `lnalpha' < -20 {
		mlmatsum `lnf' `d11' = `mu'- /*
                 */ (`mu'^2* `z1'+ `z1'^2 * `mu'-`z1'*`mu')/((1-`z1')^2) /*
                 */ , eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	} 
	else {
		mlmatsum `lnf' `d11' = `mu'*`p'*(`alpha'*`p'*(`y'-`mu')+1)- /*
                    */ `p'^(`m'+2)*(`mu'^2-`mu')/(`z2'^2) - /*
                    */ `p'^(2*(`m'+1))*`mu'/(`z2'^2), eq(1)
		mlmatsum `lnf' `d12' = `alpha'*`mu'*`p'^2*(`y'-`mu')-/*
                    */ `p'^(`m'+1)*(-`mu'*`z3'/`m'+`mu'-`mu'*`p')/(`z2'^2)+ /*
                    */ `p'^(2*`m'+1)*(`mu'-`mu'*`p')/(`z2'^2), eq(1,2)
		mlmatsum `lnf' `d22' = `m'*(digamma(`m') - digamma(`y'+`m') /*
                    */ - ln(`p') /*
	            */ - `m'*(trigamma(`y'+`m') - trigamma(`m'))) /*
		    */ + `mu'*`p'*(`alpha'*`p'*(`y'-`mu')- 1)- /*
                    */ `p'^`m'*(`z3'^2/`m' - `z3'+(`mu'*`p')^2)/`m'/(`z2'^2) /*
                    */ +`p'^(2*`m')*(-`z3'+(`mu'*`p')^2)/`m'/(`z2'^2)  , eq(2)
	}
	
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end
