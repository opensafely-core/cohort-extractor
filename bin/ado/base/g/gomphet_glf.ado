*! version 1.2.0  19feb2019
program define gomphet_glf
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
		tempvar a b b0 c c0 
			
		scalar `th'= exp(`lntheta')

		gen double `a' = 1/`th' + `d' if $ML_samp
		gen double `b' = `th'/`ga'*exp(`beta')*(expm1(`ga'*`t')) /*
			*/ if $ML_samp
		gen double `b0' = cond(`t0'>0, /*
			*/ `th'/`ga'*exp(`beta')*(expm1(`ga'*`t0')),0) /*
			*/ if $ML_samp
		gen double `c' = ln1p(`b') if $ML_samp 
		gen double `c0' = cond(`t0'>0,ln1p(`b0'),0) if $ML_samp

		mlsum `lnf' = -`a'*`c'+`c0'/`th'+`d'*(`beta'+`ga'*`t'+ln(`t'))

		if `todo'==0 | `lnf'==. { exit }
		
$ML_ec		tempname d1 d2 d3
		tempvar f f0
		
		replace `g1' = -`a'*`b'/(1+`b') + `b0'/(`th'*(1+`b0')) + `d'

		gen double `f' = (exp(`beta')*`th'*(`t'*exp(`ga'*`t') - /*
			*/ (expm1(`ga'*`t'))/`ga'))/`ga' if $ML_samp
		gen double `f0' = cond(`t0'>0, /*
			*/ (exp(`beta')*`th'*(`t0'*exp(`ga'*`t0') - /*
			*/ (expm1(`ga'*`t0'))/`ga'))/`ga',0) if $ML_samp
		
		replace `g2' = -`a'*`f'/(1+`b') + `f0'/(`th'*(1+`b0')) + /*
			*/ `d'*`t'

		replace `g3' = -`a'*`b'/(1+`b') + `c'/`th' + /*
			*/ `b0'/(`th'*(1+`b0')) - `c0'/`th'

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }

		tempname d11 d12 d22 d13 d23 d33		
		
		mlmatsum `lnf' `d11' = -`a'*`b'/((1+`b')^2) + /*
			*/ `b0'/(`th'*(1+`b0')^2), eq(1)
		mlmatsum `lnf' `d12' = -`a'*`f'/((1+`b')^2) + /*
			*/ `f0'/(`th'*(1+`b0')^2), eq(1,2)
		mlmatsum `lnf' `d13' = -`a'*`b'/((1+`b')^2) + /*
			*/ (`b'/(1+`b') - `b0'/(1+`b0') + /*
			*/ `b0'/((1+`b0')^2))/`th', eq(1,3)
		mlmatsum `lnf' `d23' = `f'/(1+`b')*(-`a'/(1+`b')+1/`th') + /*
			*/ `f0'/(`th'*(1+`b0'))*(1/(1+`b0')-1), eq(2,3)
		mlmatsum `lnf' `d33' = (`c0'-`c')/`th' -`a'*`b'/((1+`b')^2)+ /*
			*/ 2*`b'/(`th'*(1+`b')) -2*`b0'/(`th'*(1+`b0')) + /*
			*/ `b0'/(`th'*((1+`b0')^2)), eq(3)
		
		replace `c' = (-`f'+exp(`beta')*`th'*(`t'*`t'*exp(`ga'*`t')- /*
			*/ `t'*exp(`ga'*`t')/`ga' + (expm1(`ga'*`t'))/ /*
			*/ (`ga'*`ga')))/`ga'
		replace `c0' = cond(`t0'>0, /*
			*/ (-`f0'+exp(`beta')*`th'*(`t0'*`t0'* /*
			*/ exp(`ga'*`t0')- /*
			*/ `t0'*exp(`ga'*`t0')/`ga' + (expm1(`ga'*`t0'))/ /*
			*/ (`ga'*`ga')))/`ga',0)

		mlmatsum `lnf' `d22' = -`a'*(`c'*(1+`b') - /*
			*/ `f'*`f')/((1+`b')^2) + /*
			*/ (`c0'*(1+`b0')-`f0'*`f0')/(`th'*(1+`b0')^2), eq(2)

		matrix `negH' = -(`d11',   `d12',  `d13' \  /* 
			*/	 (`d12')', `d22',  `d23' \  /*
			*/	 (`d13')',(`d23')',`d33')
	}
end
exit




