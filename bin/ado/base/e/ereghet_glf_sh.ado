*! version 1.3.0  19feb2019
program define ereghet_glf_sh
	version 7.0, missing
	args todo b lnf g negH 

	tempvar beta 
	tempname lntheta
	mleval `beta' = `b', eq(1)
	mleval `lntheta' = `b', eq(2) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	local by "by $EREG_by" 	

	quietly {

/* Calculate the log-likelihood */

	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname th ith
 	        tempvar sums sumd logs
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')

		gen double `logs' = exp(`beta')*(`t0'-`t') if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'),.) if $ML_samp
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		mlsum `lnf' = cond(`sumd'<., lngamma(`ith' + /*
			*/  `sumd') - lngamma(`ith') - /*
			*/  (`ith'+`sumd')*ln1m(`th'*`sums') , 0) + /*
			*/  `d'*(`beta'+ln(`t')+`lntheta')

		if `todo'==0 | `lnf'>=. {exit}

/* Calculate the gradient */

		tempname d1 d2 digm
		tempvar z

		scalar `digm' = digamma(`ith')

		`by': gen double `z' =  (1 + `th'*`sumd'[_N]) * /* 
			*/  `logs'/(1 - `th'*`sums'[_N]) if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `z' + `d', eq(1)

$ML_ec		mlvecsum `lnf' `d2' = cond(`sumd'<., (`digm' - /*
			*/  digamma(`ith' + `sumd'))*`ith' + /*
			*/  `sumd' + (1 + `th'*`sumd')/ /*
			*/  (1-`th'*`sums')*`sums' + /*
			*/  ln1m(`th'*`sums')*`ith', 0), eq(2)

$ML_ec		matrix `g' = (`d1',`d2')

		if `todo'==1 | `lnf'>=. {exit}

/* Calculate the negative Hessian */
		
		tempname d11 d11i d12 d22 trigm
		tempvar w

		scalar `trigm' = trigamma(`ith') 

		`by': replace `z' = 1/(1 - `th'*`sums'[_N]) if $ML_samp

		mlmatsum `lnf' `d22' = cond(`sumd'<.,      /*
			*/   (`trigm' - trigamma(`ith'+`sumd'))*`ith'^2 + /*
			*/   (`digm' - digamma(`ith'+`sumd'))*`ith' - /*
			*/   `th'*(1 + `th'*`sumd')*(`z'*`sums')^2 + /*
			*/   (1 - `th'*`sumd')*`z'*`sums' + /*
			*/   `ith'*ln1m(`th'*`sums') /*
			*/   ,0), eq(2)

		`by': replace `z' = (1 + `th'*`sumd'[_N])*`z' /*
			*/ if $ML_samp

		`by': gen double `w' = (`z'*`sums'[_N] + `sumd'[_N])/ /*
			*/ (1 - `th'*`sums'[_N]) if $ML_samp

		mlmatsum `lnf' `d12' = -`th'*`w'*`logs', eq(1,2)

		`by': replace `w' = cond(_n==_N,  /*
			*/ `z'/(1 - `th'*`sums')*`th' ,0) if $ML_samp
		mlmatsum `lnf' `d11' = `z'*`logs', eq(1)
		_mlmatbysum `lnf' `d11i', eq(1) by($EREG_sh) a(`w') /*
			*/ b(`logs')
		mat `d11' = - `d11' - `d11i'

		mat `negH' = (`d11',`d12' \ `d12'',`d22') 
	}
end

