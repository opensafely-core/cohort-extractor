*! version 1.2.0  19feb2019
program define ereghet_glf
	version 7.0, missing
	args todo b lnf g negH g1 g2 

	tempvar beta lntheta
	mleval `beta' = `b', eq(1)
	mleval `lntheta' = `b', eq(2) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"	

	quietly {
	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname th
 	        tempvar a b b0 c c0 f f0 
	        scalar `th' = exp(`lntheta')

		gen double `a' = 1/`th' + `d' if $ML_samp
		gen double `b' = exp(`beta')*`t' if $ML_samp
		gen double `b0' = cond(`t0'>0, exp(`beta')*`t0',0) /*
			*/ if $ML_samp
		gen double `c' = ln1p(`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,ln1p(`th'*`b0'),0) if $ML_samp
	
		mlsum `lnf' = -`a'*`c' + `d'*(`beta' + /*
			*/ ln(`t')) + cond(`t0'>0,`c0'/`th',0)

		if `todo'==0 | `lnf'>=. {exit}
		
		gen double `f' = exp(-`c') if $ML_samp
		gen double `f0' = cond(`t0'>0,exp(-`c0'),0) if $ML_samp
		replace `g1' = -`a'*`b'*`f'*`th' + /*
			*/ cond(`t0'>0,`b0'*`f0',0) + `d'
		replace `g2' = -`a'*`b'*`f'*`th' + `c'/`th' + /*
			*/ cond(`t0'>0, `b0'*`f0' - `c0'/`th',0)
		
$ML_ec		tempname d1 d2 

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		matrix `g' = (`d1',`d2')

		if `todo'==1 | `lnf'>=. { exit }
	
		tempname d11 d12 d22 
		tempvar dt

		mlmatsum `lnf' `d11' = -`a'*`b'*`f'*`f'*`th' + /*
			*/ cond(`t0'>0, `b0'*`f0'*`f0',0), eq(1)
		gen double `dt' = `th'*((`b'*`f')^2 - cond(`t0'>0, /*
			*/ (`b0'*`f0')^2,0) - `d'*`b'*`f'*(1-`th'*`b'*`f'))
		mlmatsum `lnf' `d12' = `dt', eq(1,2)
		mlmatsum `lnf' `d22' = `dt' + `b'*`f' - `c'/`th' + /*
			*/ cond(`t0'>0, `c0'/`th' - `b0'*`f0',0), eq(2)

		matrix `negH' = -(`d11',   `d12'\ /* 
			*/       (`d12')', `d22')
	}
end
exit




