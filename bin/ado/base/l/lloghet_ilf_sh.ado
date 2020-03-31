*! version 1.2.0  18jun2009
program define lloghet_ilf_sh
	version 7.0, missing
	args todo b lnf g negH 

	tempvar beta 
	tempname lngamma lntheta
	mleval `beta' = `b', eq(1)
	mleval `lngamma' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	local by  = "by $EREG_by" 	

	quietly {
	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')
		scalar `lngamma'=cond(`lngamma'<-20,-20,`lngamma')

	        tempname th ith ga iga
 	        tempvar logs sums sumd a bes c
	        scalar `th' = exp(`lntheta')
		scalar `ith' = exp(-`lntheta')
		scalar `ga' = exp(`lngamma') 
		scalar `iga' = exp(-`lngamma')

		local F (1+(exp(-`beta')*`t')^`iga')
		local F0 (cond(`t0'>0,1+(exp(-`beta')*`t0')^`iga',1))
		local lntmu (ln(`t') - `beta')
		local lntmu0 (cond(`t0'>0, ln(`t0') - `beta', 0))
		local thc (`th'*`c')

		gen double `logs' = cond(`t0'>0,ln(`F0'),0) - ln(`F')  /*
			*/ if $ML_samp
		`by': gen double `sums' = cond(_n==_N, /*
			*/ sum(`logs'),0) if $ML_samp
		`by': gen double `sumd' = cond(_n==_N, /*
			*/ sum(`d'),.) if $ML_samp 

		`by': gen double `a' = sqrt(1-2*`th'*`sums'[_N]) if $ML_samp
		gen double `c' = 1/`a' if $ML_samp

		`by': gen double `bes' = _lnbk(`thc',`sumd'[_N]) /*
			*/ if $ML_samp

		mlsum `lnf' = cond(`sumd'<., (1-`a')*`ith' + `bes', 0) + /*
			*/  `d'*(ln(`c') + `iga'*`lntmu' - ln(`F') - `lngamma')

		if `todo'==0 | `lnf'>=. {exit}

/* Calculate the gradient */

$ML_ec		tempname d1 d2 d3 
		tempvar z logsu logst

		`by': replace `bes' = _dibk(`thc', `sumd'[_N]) if $ML_samp

		`by': gen double `z' = `c'*(1 + `thc'*(`bes'*`thc' + /*
			*/ `sumd'[_N])) if $ML_samp

		gen double `logsu' = `iga'*(1/`F0' - 1/`F') if $ML_samp

$ML_ec		mlvecsum `lnf' `d1' = `z'*`logsu' - `d' *  /*
			*/ `iga'/`F', eq(1)

		gen double `logst' = `iga'*((1-1/`F')*`lntmu' - /*
			*/ (1-1/`F0')*`lntmu0' )
			*/ if $ML_samp

$ML_ec		mlvecsum `lnf' `d2' = `z'*`logst' - `d'*   /*
			*/ (1 + `iga'/`F'*`lntmu'), eq(2)

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

		local v  (`iga'*(1-`F')/`F'^2*`lntmu')
		local v0 (cond(`t0'>0, `iga'*(1-`F0')/`F0'^2*`lntmu0', 0))
		local k  (`iga'^2*(1-`F')/`F'^2)
		local k0 (cond(`t0'>0, `iga'^2*(1-`F0')/`F0'^2, 0))

		replace `a' = `c'^3 if $ML_samp

		`by': gen double `dz' = `th'*`a'*(1 + `thc'*(`thc'* ( /* 
			*/ 3*`bes' + `thc'*`tribes') + 2*`sumd'[_N])) /*
			*/ if $ML_samp

		`by': gen double `w' = sum(`logst') if $ML_samp
		`by': replace `w' = `dz'*`w'[_N] if $ML_samp

		mlmatsum `lnf' `d12' = - `w'*`logsu' - `z'*`iga'* /*
			*/ (1/`F' + `v' - 1/`F0' - `v0') - /*
			*/ `d'*`iga'*(`v' + 1/`F'), eq(1,2) 

		`by': replace `logst' = cond(_n==_N, sum(`logst'), 0) /*
			*/ if $ML_samp

		replace `w' = `iga'*(`v'*`lntmu' - `v0'*`lntmu0') /*
			*/ if $ML_samp

		`by': replace `w' = cond(_n==_N, sum(`w'), 0) /*
			*/ if $ML_samp

		mlmatsum `lnf' `d22' = -cond(`sumd'<., /*
			*/ `z'*(`w' - `logst') + `logst'^2*`dz', 0) - /*
			*/ `d'*`lntmu'*`iga'*(`v' + 1/`F'), eq(2)

		`by': replace `dz' = cond(_n==_N, `dz', 0) if $ML_samp

		mlmatsum `lnf' `d11' = `z'*(`k'-`k0') + `d'*`k', eq(1) 
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

