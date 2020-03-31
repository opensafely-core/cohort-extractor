*! version 1.0.0  04dec2015
program define ereghet2_ilf_sh     // AFT
	version 7.0, missing
	args todo b lnf g negH 

	tempvar beta 
	tempname lntheta
	mleval `beta' = `b', eq(1)
	mleval `lntheta' = `b', eq(2) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	local by  = "by $EREG_by" 	

	quietly {

/* Calculate the log-likelihood */

	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname th ith
 	        tempvar logs sums sumd a c bes
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')

		gen double `logs' = exp(-`beta')*(`t0'-`t') if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'), 0) if $ML_samp
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		`by': gen double `a' = sqrt(1-2*`th'*`sums'[_N]) if $ML_samp
		gen double `c' = 1/`a' if $ML_samp
		`by': gen double `bes' = /*
			*/ _lnbk(`th'*`c'[_N],`sumd'[_N]) if $ML_samp

		mlsum `lnf' = cond(`sumd'<., /*
			*/  (1-`a')*`ith' + `bes' , 0) + /*
			*/  `d'*(-`beta' + ln(`c') + ln(`t'))

		if `todo'==0 | `lnf'>=. {exit}

/* Calculate the gradient */

$ML_ec		tempname d1 d2 
		tempvar z 

		`by': replace `bes' = _dibk(`th'*`c'[_N],`sumd'[_N]) /*
			*/ if $ML_samp
		`by': gen double `z' = `th'*`sumd'[_N]*(`c'[_N])^2 /*
			*/ if $ML_samp
		replace `z' = `c' + `z' + `bes'*`th'^2*`c'^3 if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = -`z'*`logs' - `d', eq(1)

$ML_ec		mlvecsum `lnf' `d2' = cond(`sumd'<., /*
				*/  (`a'-1)*`ith' + `c'*`sums' + /*
				*/  `th'*`bes'*(`c'+`th'*`c'^3*`sums') + /*
				*/  `th'*`sumd'*`c'^2*`sums', 0), eq(2)

$ML_ec		matrix `g' = (`d1', `d2')

		if `todo'==1 | `lnf'>=. {exit}

/* Calculate the negative Hessian */

		tempname d11 d11i d12 d22 
		tempvar tribes dz w

		`by': gen double `tribes' = /*
			*/ _tribk(`th'*`c'[_N],`sumd'[_N]) if $ML_samp

		replace `a' = `c'^3 if $ML_samp

		`by': gen double `dz' = cond(_n==_N, `th'*`a' * ( /*
			*/ 1 + `th'^3*`a'*`tribes' + 3*`th'^2*`c'^2*`bes'+/*
			*/ 2*`th'*`c'*`sumd'[_N]), 0) if $ML_samp

		mlmatsum `lnf' `d11' = `z'*`logs', eq(1)
		_mlmatbysum `lnf' `d11i', eq(1) by($EREG_sh) /*
			*/ a(`dz') b(`logs')
		mat `d11' = -`d11' - `d11i'

		`by': gen double `w' = `th'*`c'^2*`sums'[_N] if $ML_samp

		`by': replace `dz' = (-`a'*`sums'[_N] + /*
			*/ `th'^2*-`a'*`c'*`tribes'*(1+`w')+ /*
			*/ `bes'*`th'*-`a'*(3*`w' + 2) - /*
			*/ `sumd'[_N]*`c'^2*(1 + 2*`w')) /*
			*/ if $ML_samp
			
		mlmatsum `lnf' `d12' = -`th'*`dz'*`logs', eq(1,2)

		replace `a' = cond(`sumd'<., `c'^2, 0)  if $ML_samp

		replace `dz' = cond(`sumd'<., /*
			*/ -(1/`c' - 1)*`ith'^2 + /*
			*/ `c'*`sums'*(`a'*`sums' - `ith') , 0) /*
			*/ if $ML_samp

		replace `dz' = cond(`sumd'<.,  `dz' + /*
			*/ `c'*`bes'*(1 + 3*`w' + /*
			*/ 3*`w'^2) , 0) if $ML_samp

		replace `dz' = cond(`sumd'<.,  `dz' + /*
			*/ `th'*`a'*`tribes'*(1 + 2*`w' + /*
			*/ `w'^2), 0) if $ML_samp

		mlmatsum `lnf' `d22' = cond(`sumd'<., -`th'*(`dz' + /*
			*/ `sumd'*`sums'*`a'*(1 + 2*`w')), 0) /*
			*/ , eq(2)

		mat `negH' = (`d11',`d12' \ `d12'',`d22')
	}
end
exit

