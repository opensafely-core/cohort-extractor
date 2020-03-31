*! version 1.3.0  19feb2019
program define weibhet_glf_sh
	version 7.0
	args todo b lnf g negH 

	tempvar beta 
	tempname lntheta lnp
	mleval `beta' = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	local by  = "by $EREG_by" 	

	quietly {

/* Calculate the log-likelihood */

	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname ith th p
 	        tempvar sums sumd logs 
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')
		scalar `p' = exp(`lnp')
		
		gen double `logs' = exp(`beta')*( /*
			*/     cond(`t0'>0,exp(`p'*ln(`t0')),0) - /*
			*/     exp(`p'*ln(`t'))) if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'), .) if $ML_samp 
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		mlsum `lnf' = cond(`sumd'!=., lngamma(`ith' + `sumd') -/*
			*/  lngamma(`ith') + `sumd'*`lntheta' - /*
			*/  (`ith'+`sumd')*ln1m(`th'*`sums') , 0) + /*
			*/  `d'*(`beta'+`lnp'+`p'*ln(`t'))

		if `todo'==0 | `lnf'==. {exit}

/* Calculate the gradient */

		tempname d1 d2 d3 digm
		tempvar z logst

		scalar `digm' = digamma(`ith')

		`by': gen double `z' = (1+`th'*`sumd'[_N])/ /* 
			*/ (1-`th'*`sums'[_N]) if $ML_samp
	
$ML_ec		mlvecsum `lnf' `d1' = `z'*`logs' + `d', eq(1)

		gen double `logst' = exp(`beta')*( /*
			*/     cond(`t0'>0,ln(`t0')*exp(`p'*ln(`t0')),0) - /*
			*/     ln(`t')*exp(`p'*ln(`t'))) if $ML_samp

$ML_ec		mlvecsum `lnf' `d2' = `d'*(1 + `p'*ln(`t')) + /*
			*/ `p'*`z'*`logst', eq(2)

$ML_ec		mlvecsum `lnf' `d3' = cond(`sumd'!=., /*
			*/ `ith'*(`digm' - digamma(`ith'+`sumd')) + /*
			*/ `z'*`sums' + `ith'*ln1m(`th'*`sums') + /*
			*/ `sumd', 0), eq(3)

$ML_ec		matrix `g' = (`d1', `d2', `d3')

		if `todo'==1 | `lnf'==. {exit}

/* Calculate the negative Hessian */

		tempname d11 d11i d12 d13 d22 d23 d33 trigm
		tempvar dz w logstt

		scalar `trigm' = trigamma(`ith')

		`by': gen double `dz' = `th'*`z'/(1-`th'*`sums'[_N]) /*
			*/ if $ML_samp

		`by': gen double `w' = `dz'*`sums'[_N] if $ML_samp

		mlmatsum `lnf' `d12' = -`p'*(`z' + `w')*`logst', eq(1,2)

		`by': replace `w' = (`z'*`sums'[_N] + `sumd'[_N]) /   /*
			*/ (1 - `th'*`sums'[_N]) if $ML_samp

		mlmatsum `lnf' `d13' = -`th'*`w'*`logs', eq(1,3)

		`by': replace `logst' = cond(_n==_N, sum(`logst'), 0) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d23' = cond(`sumd'!=., /*
			*/ -`th'*`p'*`w'*`logst', 0), eq(2,3)

		gen double `logstt' = exp(`beta')*( /*
			*/     cond(`t0'>0,ln(`t0')^2*exp(`p'*ln(`t0')),0) - /*
			*/     ln(`t')^2*exp(`p'*ln(`t'))) if $ML_samp
		`by': replace `logstt' = cond(_n==_N, sum(`logstt'), 0) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d22' = -`p'*( cond(`sumd'!=., /*
			*/ `z'*`logst' + `p'*(`z'*`logstt' + /*
			*/ `logst'^2*`dz'), 0) + `d'*ln(`t') ), eq(2)

		`by': replace `logst' = cond(_n==_N, /*
			*/ 1 - `th'*`sums', 0) if $ML_samp

		mlmatsum `lnf' `d33' = cond(`sumd'!=., /*
			*/ `ith'^2*(`trigm' - trigamma(`ith'+`sumd')) + /*
			*/ `ith'*(`digm' - digamma(`ith'+`sumd')) - /*
			*/ `th'*`sums'*`w' + `sums'/`logst' + /*
			*/ `ith'*ln(`logst'), 0), eq(3)

		`by': replace `dz' = cond(_n==_N,`dz',0) if $ML_samp
		mlmatsum `lnf' `d11' = `z'*`logs', eq(1)
		_mlmatbysum `lnf' `d11i', eq(1) by($EREG_sh) /*
			*/ a(`dz') b(`logs')
		mat `d11' = - `d11' - `d11i'

		mat `negH' = (`d11' , `d12' , `d13'   \    /*
			*/    `d12'', `d22' , `d23'   \    /*
			*/    `d13'', `d23'', `d33' )
	}
end
exit

