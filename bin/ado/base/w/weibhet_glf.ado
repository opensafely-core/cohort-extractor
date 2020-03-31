*! version 1.2.0  19feb2019
program define weibhet_glf
	version 7.0
	args todo b lnf g negH g1 g2 g3

	tempvar beta lnp lntheta
	mleval `beta' = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar

	scalar `lnp' = cond((`lnp'<-20),-20,`lnp')
	scalar `lntheta' = cond((`lntheta'<-20),-20,`lntheta')
	
	local t  = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"

	tempname p theta
	tempvar a b b0 lnt lnt0
	scalar `p' = exp(`lnp')
	scalar `theta' = exp(`lntheta')
	qui gen `lnt' = ln(`t') if $ML_samp
	qui gen `lnt0' = cond(`t0'>0,ln(`t0'),0) if $ML_samp 
	qui gen double `a' = 1/`theta' + `d' if $ML_samp
	qui gen double `b' = ln1p(`theta'*exp(`beta')*exp(`p'*`lnt')) /*
		*/ if $ML_samp
	qui gen double `b0' = cond(`t0'>0, /*
		*/ ln1p(`theta'*exp(`beta')*exp(`p'*`lnt0')),0) /*
		*/ if $ML_samp
	
	mlsum `lnf' = -`a'*`b' + `d'*(`beta'+`lnp'+`p'*`lnt') + /*
		*/	`b0'/`theta'
 
	if `todo'==0 | `lnf'==. { exit }

$ML_ec	tempname d1 d2 d3
	tempvar c c0
	qui gen double `c' = `theta'*exp(`beta'+`p'*`lnt') if $ML_samp
	qui gen double `c0' = cond(`t0'>0, /*
		*/ `theta'*exp(`beta'+`p'*`lnt0'),0) if $ML_samp
	qui replace `c' = `c'/(1+`c')
	qui replace `c0' = `c0'/(1+`c0')

	qui replace `g1' = -`a'*`c' + `c0'/`theta' + `d'
	qui replace `g2' =  `p'*(`lnt'*(-`a'*`c' + `d') + /*
		*/	      `lnt0'*`c0'/`theta') + `d'
	qui replace `g3' = -`a'*`c' + (`b'-`b0'+`c0')/`theta'
$ML_ec	mlvecsum `lnf' `d1' = `g1', eq(1) 
$ML_ec	mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec	mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec	matrix `g' = (`d1',`d2',`d3')

	if `todo'==1 | `lnf'==. { exit }

	tempname d11 d12 d13 d22 d23 d33
	tempvar f f0
	qui gen double `f' = `c'*exp(-`b') if $ML_samp
	qui gen double `f0' = cond(`t0'>0,`c0'*exp(-`b0'),0) if $ML_samp
	mlmatsum `lnf' `d11' = -`a'*`f' + `f0'/`theta', eq(1)
	mlmatsum `lnf' `d12' = `p'*(-`a'*`f'*`lnt' + /* 
		*/		`f0'*`lnt0'/`theta'), eq(1,2)
	mlmatsum `lnf' `d13' = -`a'*`f'+(`f0'+`c'-`c0')/`theta', eq(1,3)
	mlmatsum `lnf' `d22' = `p'*(`p'*(-`a'*`f'*`lnt'^2 +             /*
		*/		`f0'*`lnt0'^2/`theta') -                /*
		*/		(`a'*`c' - `d')*`lnt' +                 /*
		*/		`lnt0'*`c0'/`theta'), eq(2)
	mlmatsum `lnf' `d23' = `p'*(`lnt'*(-`a'*`f'+`c'/`theta') +      /*
		*/             `lnt0'*(`f0'-`c0')/`theta'), eq(2,3)
	mlmatsum `lnf' `d33' = -`a'*`f'+(2*`c'+`b0'-`b'-`c0')/`theta' - /*
		*/		`f0'*exp(`beta'+`p'*`lnt0'), eq(3)
	matrix `negH' = -(`d11',`d12',`d13' \ (`d12')',`d22',`d23'\     /* 
		*/	 (`d13')',(`d23')',`d33')
end
exit

