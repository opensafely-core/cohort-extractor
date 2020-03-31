*! version 1.2.0  18jun2009
program define weibhet_ilf_sh
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

	        tempname th ith p
 	        tempvar logs sums sumd a c bes
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')
		scalar `p' = exp(`lnp')
		local thc (`th'*`c')

		gen double `logs' = exp(`beta')*( /*
			*/     cond(`t0'>0,exp(`p'*ln(`t0')),0) - /*
			*/     exp(`p'*ln(`t'))) if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'), .) if $ML_samp 
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		`by': gen double `a' = sqrt(1-2*`th'*`sums'[_N]) if $ML_samp
		gen double `c' = 1/`a' if $ML_samp

		`by': gen double `bes' = _lnbk(`thc',`sumd'[_N]) /*
			*/ if $ML_samp

		mlsum `lnf' = cond(`sumd'!=., (1-`a')*`ith' + `bes', 0) + /*
			*/  `d'*(ln(`c') + `beta' + `lnp' + `p'*ln(`t'))

		if `todo'==0 | `lnf'==. {exit}

/* Calculate the gradient */

$ML_ec		tempname d1 d2 d3
		tempvar z logst

		`by': replace `bes' = _dibk(`thc', `sumd'[_N]) if $ML_samp

		`by': gen double `z' = `c'*(1 + `thc'*(`bes'*`thc' + /*
			*/ `sumd'[_N])) if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `z'*`logs' + `d', eq(1)

		gen double `logst' = `p'*exp(`beta')*( /*
			*/     cond(`t0'>0,ln(`t0')*exp(`p'*ln(`t0')),0) - /*
			*/     ln(`t')*exp(`p'*ln(`t'))) if $ML_samp

$ML_ec		mlvecsum `lnf' `d2' = `z'*`logst' + `d'*(1+`p'*ln(`t')), eq(2)

$ML_ec		mlvecsum `lnf' `d3' = cond(`sumd'!=., /*
			*/ `ith'*(`a'-1) + `thc'*`bes'* /*
			*/ (1 + `thc'*`c'*`sums') + /*
			*/ (`thc'*`sumd' + 1)*`c'*`sums', 0),  eq(3)

$ML_ec		matrix `g' = (`d1', `d2', `d3') 

		if `todo'==1 | `lnf'==. {exit}

/* Calculate the negative Hessian */

		tempname d11 d11i d12 d13 d22 d23 d33
		tempvar tribes dz logstt w

		`by': gen double `tribes' = /*
			*/ _tribk(`thc', `sumd'[_N]) if $ML_samp

		replace `a' = `c'^3 if $ML_samp

		`by': gen double `dz' = `th'*`a'*(1 + `thc'*(`thc'* ( /* 
			*/ 3*`bes' + `thc'*`tribes') + 2*`sumd'[_N])) /*
			*/ if $ML_samp

		`by': gen double `w' = `dz'*`sums'[_N] if $ML_samp

		mlmatsum `lnf' `d12' = -(`z' + `w')*`logst', eq(1,2)

		`by': replace `logst' = cond(_n==_N, sum(`logst'), 0) /*
			*/ if $ML_samp

		gen double `logstt' = `p'*exp(`beta')*( /*
			*/     cond(`t0'>0,ln(`t0')^2*exp(`p'*ln(`t0')),0) - /*
			*/     ln(`t')^2*exp(`p'*ln(`t'))) if $ML_samp
		`by': replace `logstt' = cond(_n==_N, sum(`logstt'), 0) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d22' = -cond(`sumd'!=., /*
			*/ `z'*`logst' + `p'*`z'*`logstt' + /*
			*/ `dz'*`logst'^2, 0) - `p'*`d'*ln(`t'), eq(2)

		`by': replace `dz' = cond(_n==_N, `dz', 0) if $ML_samp
		mlmatsum `lnf' `d11' = `z'*`logs', eq(1)
		_mlmatbysum `lnf' `d11i', eq(1) by($EREG_sh) /*
			*/ a(`dz') b(`logs')
		mat `d11' = - `d11' - `d11i'

		`by': replace `w' = `th'*`c'^2*`sums'[_N] if $ML_samp

		`by': replace `dz' = (`a'*`sums'[_N] + /*
			*/ `th'^2*`a'*`c'*`tribes'*(1+`w') + /*
			*/ `bes'*`th'*`a'*(3*`w' + 2) + /*
			*/ `sumd'[_N]*`c'^2*(1 + 2*`w')) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d13' = -`th'*`dz'*`logs', eq(1,3)

		mlmatsum `lnf' `d23' = cond(`sumd'!=., /*
			*/ -`th'*`dz'*`logst', 0) , eq(2,3)

		replace `a' = cond(`sumd'!=.,`c'^2, 0)  if $ML_samp

		replace `dz' = cond(`sumd'!=., /*
			*/ -(1/`c' - 1)*`ith'^2 + /*
			*/ `c'*`sums'*(`a'*`sums' - `ith') , 0) /*
			*/ if $ML_samp

		replace `dz' = cond(`sumd'!=.,  `dz' + /*
			*/ `c'*`bes'*(1 + 3*`w' + /*
			*/ 3*`w'^2) , 0) if $ML_samp

		replace `dz' = cond(`sumd'!=.,  `dz' + /*
			*/ `th'*`a'*`tribes'*(1 + 2*`w' + /*
			*/ `w'^2), 0) if $ML_samp

		mlmatsum `lnf' `d33' = cond(`sumd'!=., -`th'*(`dz' + /*
			*/ `sumd'*`sums'*`a'*(1 + 2*`w')), 0), eq(3) 

		mat `negH' = (`d11' , `d12' , `d13'   \    /*
			*/    `d12'', `d22' , `d23'   \    /*
			*/    `d13'', `d23'', `d33' )
	}
end
exit

