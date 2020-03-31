*! version 1.2.0  18jun2009
program define lnormhet_ilf_sh
	version 7.0, missing
	args todo b lnf g negH 

	tempvar beta 
	tempname lnsigma lntheta
	mleval `beta' = `b', eq(1)
	mleval `lnsigma' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	local by  = "by $EREG_by" 	

	quietly {
	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')
		scalar `lnsigma'=cond(`lnsigma'<-20,-20,`lnsigma')

	        tempname ith th sg
 	        tempvar logs sums sumd F F0 a bes c
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')
		scalar `sg' = exp(`lnsigma')

		local k ((`beta'-ln(`t'))/`sg')
		local k0 ((`beta'-ln(`t0'))/`sg')
		local f (normd(`k'))
		local f0 (normd(`k0'))
		local thc (`th'*`c')

		gen double `F' = norm(`k') if $ML_samp
		gen double `F0' = cond(`t0'>0,norm(`k0'),0) if $ML_samp

		gen double `logs' = ln(`F') - cond(`t0'>0, /*
			*/ ln(`F0'), 0) if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'),0) if $ML_samp
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		`by': gen double `a' = sqrt(1-2*`th'*`sums'[_N]) if $ML_samp
		gen double `c' = 1/`a' if $ML_samp

		`by': gen double `bes' = _lnbk(`thc',`sumd'[_N]) /*
			*/ if $ML_samp

		mlsum `lnf' = cond(`sumd'<., (1-`a')*`ith' + `bes', 0) + /*
			*/  `d'*(ln(`c') + ln(`f') - ln(`F') - `lnsigma')

		if `todo'==0 | `lnf'>=. {exit}

/* Calculate the gradient */

$ML_ec		tempname d1 d2 d3 
		tempvar z logsu logst

		`by': replace `bes' = _dibk(`thc', `sumd'[_N]) if $ML_samp

		`by': gen double `z' = `c'*(1 + `thc'*(`bes'*`thc' + /*
			*/ `sumd'[_N])) if $ML_samp

		gen double `logsu' = (`f'/`F' - /*
			*/ cond(`t0'>0, `f0'/`F0', 0) )/`sg' /*
			*/ if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `z'*`logsu' - `d' * ( /*
			*/ `f'/`F' + `k')/`sg', eq(1)

		gen double `logst' = (cond(`t0'>0, `k0'*`f0'/`F0', 0)-/*
			*/ `k'*`f'/`F') if $ML_samp

$ML_ec		mlvecsum `lnf' `d2' = `z'*`logst' + `d' * ( /*
			*/ `k'*(`k' + `f'/`F') - 1), eq(2)

$ML_ec		mlvecsum `lnf' `d3' = cond(`sumd'<., /*
			*/ `ith'*(`a'-1) + `thc'*`bes'* /*
			*/ (1 + `thc'*`c'*`sums') + /*
			*/ (`thc'*`sumd' + 1)*`c'*`sums', 0),  eq(3)

$ML_ec		matrix `g' = (`d1', `d2', `d3')
	
		if `todo'==1 | `lnf'>=. {exit}

/* Calculate the negative Hessian */

		tempname d11 d11i d12 d13 d22 d23 d33
		tempvar tribes dz w 

		`by': gen double `tribes' = /*
			*/ _tribk(`thc', `sumd'[_N]) if $ML_samp

		local v (-`f'*(`k'*`F' + `f')/(`F'^2)) 
		local v0 (-`f0'*(`k0'*`F0' + `f0')/(`F0'^2)) 

		replace `a' = `c'^3 if $ML_samp

		`by': gen double `dz' = `th'*`a'*(1 + `thc'*(`thc'* ( /* 
			*/ 3*`bes' + `thc'*`tribes') + 2*`sumd'[_N])) /*
			*/ if $ML_samp

		`by': gen double `w' = sum(`logst') if $ML_samp
		`by': replace `w' = `dz'*`w'[_N] if $ML_samp

		mlmatsum `lnf' `d12' = -`w'*`logsu' - `z'* /*
			*/ ((cond(`t0'>0, `v0'*`k0', 0) - /*
			*/ `v'*`k')/`sg' - `logsu') - /*
			*/ `d'*(`k'/`sg'*(1 + `v') + /*
			*/ (`k'+`f'/`F')/`sg'), eq(1,2)

		`by': replace `logst' = cond(_n==_N, sum(`logst'), 0) /*
			*/ if $ML_samp

		replace `w' = `k'^2*`v' - /*
			*/ cond(`t0'>0, `k0'^2*`v0', 0) if $ML_samp
		`by': replace `w' = cond(_n==_N, sum(`w'), 0) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d22' = -cond(`sumd'<., /*
			*/ `z'*(`w' - `logst') + `logst'^2*`dz', 0) + /*
			*/ `d'*`k'*(`k'*(1+`v') + `k' + `f'/`F'), /*
			*/ eq(2)

		`by': replace `dz' = cond(_n==_N, `dz', 0) if $ML_samp

		mlmatsum `lnf' `d11' = (`z'*(`v'-cond(`t0'>0,`v0',0)) - /*
			*/ `d'*(1+`v'))/`sg'^2 , eq(1)
		_mlmatbysum `lnf' `d11i', eq(1) by($EREG_sh) /*
			*/ a(`dz') b(`logsu')
		mat `d11' = - `d11' - `d11i'

		`by': replace `w' = `th'*`c'^2*`sums'[_N] if $ML_samp

		`by': replace `dz' = (`a'*`sums'[_N] + /*
			*/ `th'^2*`a'*`c'*`tribes'*(1+`w') + /*
			*/ `bes'*`th'*`a'*(3*`w' + 2) + /*
			*/ `sumd'[_N]*`c'^2*(1 + 2*`w')) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d13' = -`th'*`dz'*`logsu', eq(1,3)

		mlmatsum `lnf' `d23' = cond(`sumd'<., /*
			*/ -`th'*`dz'*`logst', 0) , eq(2,3)

		replace `a' = cond(`sumd'<.,`c'^2, 0)  if $ML_samp

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

		mlmatsum `lnf' `d33' = cond(`sumd'<., -`th'*(`dz' + /*
			*/ `sumd'*`sums'*`a'*(1 + 2*`w')), 0), eq(3) 

		mat `negH' = (`d11' , `d12' , `d13'   \    /*
			*/    `d12'', `d22' , `d23'   \    /*
			*/    `d13'', `d23'', `d33' )

	}
end
exit

