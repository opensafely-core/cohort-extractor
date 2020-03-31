*! version 1.2.0  19feb2019
program define gomphet_ilf
	version 7
	args todo b lnf g negH g1 g2 g3

	tempvar beta ga lntheta 
	mleval `beta' = `b', eq(1)
	mleval `ga' = `b', eq(2) scalar 
	mleval `lntheta' = `b', eq(3) scalar

 	local t = "$EREGt" 
	local t0 = "$EREGt0"
	local d = "$EREGd"
	
	quietly {
                scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')
		if (abs(`ga')<1e-8) {
			scalar `ga'=cond(`ga'>0,1e-8,-1e-8)
		}

		tempname th  
		tempvar b b0 c c0  
			
		scalar `th'= exp(`lntheta')

		gen double `b' = 2*`th'/`ga'*exp(`beta')* /*
			*/ (expm1(`ga'*`t')) if $ML_samp
		gen double `b0' = cond(`t0'>0,2*`th'/`ga'*exp(`beta')* /*
			*/ (expm1(`ga'*`t0')),0) if $ML_samp
		gen double `c' = sqrt(1+`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,sqrt(1+`b0'),0) if $ML_samp

		mlsum `lnf' = (1-`c')/`th' - cond(`t0'>0,(1-`c0')/`th',0) + /*
			*/ `d'*(`beta'+`ga'*`t'-ln(`c')+ln(`t'))

		if `todo'==0 | `lnf'==. { exit }
		
$ML_ec		tempname d1 d2 d3
		tempvar f f0
		
		gen double `f' = (2*`th'*exp(`beta')*`t'* /*
			*/ exp(`ga'*`t')-`b')/`ga' if $ML_samp
		gen double `f0' = cond(`t0'>0,(2*`th'*exp(`beta')*`t0'* /*
			*/ exp(`ga'*`t0')-`b0')/`ga',0) if $ML_samp

		replace `g1' = (cond(`t0'>0,`b0'/`c0',0)-`b'/`c')/(2*`th') + /*
			*/ `d'*(1-`b'/(2*`c'*`c'))
		replace `g2' = (cond(`t0'>0,`f0'/`c0',0)-`f'/`c')/(2*`th') + /*
			*/ `d'*(`t'-`f'/(2*`c'*`c'))
		replace `g3' = cond(`t0'>0,(1-`c0')/`th',0) - (1-`c')/`th' + /*
			*/ (cond(`t0'>0,`b0'/`c0',0)-`b'/`c')/(2*`th') - /*
			*/ `d'*`b'/(2*`c'*`c')

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }

		tempname d11 d12 d22 d13 d23 d33		
		
		mlmatsum `lnf' `d11' = (cond(`t0'>0, /*
			*/ `b0'*(1-`b0'/(2*`c0'*`c0'))/`c0',0) - /*
			*/ `b'*(1-`b'/(2*`c'*`c'))/`c')/(2*`th') - `d'* /*
			*/ `b'*(1-`b'/(`c'*`c'))/(2*`c'*`c'), eq(1)
		mlmatsum `lnf' `d12' = (cond(`t0'>0, /*
			*/ `f0'*(1-`b0'/(2*`c0'*`c0'))/`c0',0) - /*
			*/ `f'*(1-`b'/(2*`c'*`c'))/`c')/(2*`th') - `d'* /*
			*/ `f'*(1-`b'/(`c'*`c'))/(2*`c'*`c'), eq(1,2)
		mlmatsum `lnf' `d13' = (`b'*`b'/(`c'^3) - /*
			*/ cond(`t0'>0,`b0'*`b0'/(`c0'^3),0))/(4*`th') - /*
			*/ `d'/2*`b'*(1-`b'/(`c'*`c'))/(`c'*`c'), eq(1,3)
		mlmatsum `lnf' `d23' = (`f'*`b'/(`c'^3) - /*
			*/ cond(`t0'>0,`f0'*`b0'/(`c0'^3),0))/(4*`th') - /*
			*/ `d'/2*`f'*(1-`b'/(`c'*`c'))/(`c'*`c'), eq(2,3)
		mlmatsum `lnf' `d33' = (`b'*`b'/(`c'^3) - /*
			*/ cond(`t0'>0,`b0'*`b0'/(`c0'^3),0))/(4*`th') + /*
			*/ (`b'/`c' - cond(`t0'>0,`b0'/`c0',0))/(2*`th') + /*
			*/ ((1-`c') - cond(`t0'>0,(1-`c0'),0))/`th' - `d'/2* /*
			*/ `b'*(1-`b'/(`c'*`c'))/(`c'*`c'), eq(3)
		
		replace `b' = 2*`th'/`ga'*exp(`beta')*exp(`ga'*`t')* /*
			*/ `t'*(`t'-1/`ga') - `f'/`ga' + `b'/(`ga'*`ga')
		replace `b0' = cond(`t0'>0, /*
			*/ 2*`th'/`ga'*exp(`beta')*exp(`ga'*`t0')* /*
			*/ `t0'*(`t0'-1/`ga') - `f0'/`ga' + `b0'/(`ga'*`ga'),0)

		mlmatsum `lnf' `d22' = (cond(`t0'>0, /*
			*/ (`b0'/`c0')-`f0'*`f0'/(2*`c0'^3),0) - /*
			*/ (`b'/`c') + `f'*`f'/(2*`c'^3))/(2*`th') - `d'/2 * /*
			*/ ((`b' - `f'*`f'/(`c'*`c'))/(`c'*`c')), eq(2)

		matrix `negH' = -(`d11',   `d12',  `d13' \  /* 
			*/	 (`d12')', `d22',  `d23' \  /*
			*/	 (`d13')',(`d23')',`d33')
	}
end
exit



