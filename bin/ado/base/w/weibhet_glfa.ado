*! version 1.2.0  19feb2019
program define weibhet_glfa
	version 7.0
	args todo b lnf g negH g1 g2 g3

	tempvar beta lnp lntheta
	mleval `beta' = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"	

	quietly {
	        scalar `lnp'=cond(`lnp'<-20,-20,`lnp')
	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname p th
 	        tempvar a b b0 c c0 f f0 h h0
	        scalar `p' = exp(`lnp')
	        scalar `th' = exp(`lntheta')

		gen double `a' = 1/`th' + `d' if $ML_samp
		gen double `b' = exp(-`beta'*`p')*`t'^`p' if $ML_samp
		gen double `b0' = cond(`t0'>0, exp(-`beta'*`p')*`t0'^`p',0) /*
			*/ if $ML_samp
		gen double `c' = ln1p(`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,ln1p(`th'*`b0'),0) if $ML_samp
	
		mlsum `lnf' = -`a'*`c' + `d'*(-`beta'*`p' + `lnp' + /*
			*/ `p'*ln(`t')) + cond(`t0'>0,`c0'/`th',0)

		if `todo'==0 | `lnf'==. {exit}
		
		gen double `f' = `th'*`b'*`p'/(1+`th'*`b') if $ML_samp
		gen double `f0' = cond(`t0'>0, /*
			*/ `th'*`b0'*`p'/(1+`th'*`b0'),0) if $ML_samp
		gen double `h' = (ln(`t')-`beta') if $ML_samp
		gen double `h0' = cond(`t0'>0, /*
			*/ (ln(`t0')-`beta'),0) if $ML_samp
		replace `g1' = `a'*`f' - `f0'/`th' -`d'*`p'
		replace `g2' = -`a'*`f'*`h' + /*
			*/ cond(`t0'>0,`f0'*`h0'/`th',0) + /*
			*/ `d'*(`p'*`h' + 1)
		replace `g3' = -`a'*`f'/`p' + (`c'-`c0')/`th' + `f0'/(`th'*`p')
		
$ML_ec		tempname d1 d2 d3

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }
	
		tempname d11 d12 d13 d22 d23 d33
		
		replace `b' = `f'/(1+`th'*`b')
		replace `b0' = cond(`t0'>0,`f0'/(1+`th'*`b0'),0)
 
		mlmatsum `lnf' `d11' = (-`a'*`b' + `b0'/`th')*`p', eq(1)
		mlmatsum `lnf' `d12' = `a'*(`f'+`b'*`h'*`p') - /*
			*/ (`f0'+`b0'*`h0'*`p')/`th' - `d'*`p', eq(1,2)
		mlmatsum `lnf' `d22' = -`a'*((`f'+`b'*`p'*`h')*`h') + /*
			*/ ((`f0'+`b0'*`p'*`h0')*`h0')/`th' + /*
			*/ `d'*`p'*`h', eq(2)

		mlmatsum `lnf' `d13' = `a'*`b' + (`f0'-`f'-`b0')/`th', eq(1,3)
		mlmatsum `lnf' `d23' = -`a'*`b'*`h' + (`f'*`h' + /*
			*/ `h0'*(`b0' - `f0'))/`th' , eq(2,3)
		mlmatsum `lnf' `d33' = -`a'*`b'/`p' + /* 
			*/ (2*(`f'-`f0')+`b0')/(`th'*`p') + /*
			*/ (`c0'-`c')/`th', eq(3)

		matrix `negH' = -(`d11',   `d12',  `d13' \ /* 
			*/       (`d12')', `d22',  `d23' \ /*
			*/       (`d13')',(`d23')',`d33')
	}
end
exit




