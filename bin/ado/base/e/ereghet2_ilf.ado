*! version 1.0.0  04dec2015
program define ereghet2_ilf     // AFT
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
 	        tempvar  b b0 c c0 f f0 
	        scalar `th' = exp(`lntheta')

		gen double `b' = exp(-`beta')*`t' if $ML_samp
		gen double `b0' = cond(`t0'>0, exp(-`beta')*`t0',0) /*
			*/ if $ML_samp
		gen double `c' = sqrt(1+2*`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,sqrt(1+2*`th'*`b0'),0) /*
			*/ if $ML_samp
	
		mlsum `lnf' = (1-`c')/`th' - cond(`t0'>0, (1-`c0')/`th',0) + /*
			*/ `d'*(ln(`t') - `beta' - ln(`c'))  

		if `todo'==0 | `lnf'>=. {exit}
		
		gen double `f' = `b'/`c' if $ML_samp
		gen double `f0' = cond(`t0'>0,`b0'/`c0',0) if $ML_samp
		replace `g1' = `f' - `f0' - `d'*(1-`f'*`th'/`c')	
		replace `g2' = -`f' + `f0' - (1-`c')/`th' + /*
			*/ cond(`t0'>0, (1-`c0')/`th',0) - `d'*`f'*`th'/`c'

$ML_ec		tempname d1 d2 

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		matrix `g' = (`d1',`d2')

		if `todo'==1 | `lnf'>=. { exit }
	
		tempname d11 d12 d22 
		tempvar dt

		mlmatsum `lnf' `d11' = -`f'*(1-`f'*`th'/`c') + /* 
			*/ cond(`t0'>0, `f0'*(1-`f0'*`th'/`c0'),0) - /*
			*/ `d'*`th'*`f'/`c'*(1-2*`f'*`th'/`c'), eq(1)
		gen double `dt' = `th'*(`f'*`f'/`c' - cond(`t0'>0, /*
			*/ `f0'*`f0'/`c0',0) - `d'*`f'/`c'* /*
			*/ (1-2*`th'*`f'/`c'))
		mlmatsum `lnf' `d12' = -`dt', eq(1,2)
		mlmatsum `lnf' `d22' = `dt' + (1-`c')/`th' - cond(`t0'>0, /*
			*/ (1-`c0')/`th',0) + `f' - `f0', eq(2)

		matrix `negH' = -(`d11',   `d12'\ /* 
			*/       (`d12')', `d22')
	}
end
exit




