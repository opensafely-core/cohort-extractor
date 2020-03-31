*! version 1.1.0  18jun2009
program define weibhet_ilf
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
 	        tempvar b b0 c c0 f f0 lnt lnt0
	        scalar `p' = exp(`lnp')
	        scalar `th' = exp(`lntheta')

		gen double `lnt' = ln(`t') if $ML_samp
		gen double `lnt0' = cond(`t0'>0,ln(`t0'),0) if $ML_samp 
		gen double `b' = exp(`beta')*`t'^`p' if $ML_samp
		gen double `b0' = cond(`t0'>0, exp(`beta')*`t0'^`p',0) /*
			*/ if $ML_samp
		gen double `c' = sqrt(1+2*`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,sqrt(1+2*`th'*`b0'),0) /*
			*/ if $ML_samp
	
		mlsum `lnf' = (1-`c')/`th' - cond(`t0'>0,(1-`c0')/`th',0) + /*
			*/ `d'*(`beta' + `lnp' + `p'*`lnt' - ln(`c'))

		if `todo'==0 | `lnf'==. {exit}
	
		gen double `f' = `b'/`c' if $ML_samp
		gen double `f0' = cond(`t0'>0,`b0'/`c0',0) if $ML_samp

		replace `g1' = -`f' + `f0' + `d'* /*
			*/ (1 - `th'*`f'/`c')
		replace `g2' = (-`f'*`lnt' + `f0'*`lnt0' + `d'*`lnt'* /*
			*/ (1-`th'*`f'/`c'))*`p' + `d'
		replace `g3' = -`f' +  `f0' + /*
			*/ cond(`t0'>0,(1-`c0')/`th',0) - (1-`c')/`th' - /*
			*/ `d'*`th'*`f'/`c'
		
$ML_ec		tempname d1 d2 d3
		
$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }
	
		tempname d11 d12 d13 d22 d23 d33
		
		mlmatsum `lnf' `d11' = `f'*(`f'*`th'/`c'-1) + /*
			*/ cond(`t0'>0,`f0'*(1-`f0'*`th'/`c0'),0) - /*
			*/ `d'*`th'*`f'/`c'*(1-2*`f'*`th'/`c'), eq(1)
		mlmatsum `lnf' `d12' = `p'* /*
			*/ (-`f'*`lnt'*(1-`th'*`f'/`c') + /*
			*/ cond(`t0'>0, /*
			*/ `f0'*`lnt0'*(1-`th'*`f0'/`c0'),0) - /*
			*/ `d'*`th'*`f'*`lnt'* /*
			*/ (1-2*`f'*`th'/`c')/`c'), eq(1,2)
		mlmatsum `lnf' `d22' = (`g2'-`d') + `p'*`p'* /* 
			*/ (-(`b'-`f'*`f'*`th')*`lnt'*`lnt'/`c' + /*
			*/ cond(`t0'>0, /*
			*/ (`b0'-`f0'*`f0'*`th')*`lnt0'*`lnt0'/`c0', /*
			*/ 0) - `d'*`lnt'*`lnt'*`th'*`b'* /* 
			*/ (1-2*`f'*`th'/`c')/(`c'*`c')), eq(2)

		mlmatsum `lnf' `d13' = `th'*(`f'*`f'/`c' - cond(`t0'>0, /*
			*/ `f0'*`f0'/`c0',0) + `d'*`f'* /* 
			*/ (2*`th'*`f'/`c'-1)/`c'), eq(1,3)
		mlmatsum `lnf' `d23' = `th'*`p'*(`lnt'*`f'*`f'/`c' - /*
			*/ cond(`t0'>0,`lnt0'*`f0'*`f0'/`c0',0) + /*
			*/ `d'*`f'*`lnt'/`c'*(2*`th'*`f'/`c'-1)), eq(2,3)
		mlmatsum `lnf' `d33' = `th'*`f'*`f'/`c' + `f' + /*
			*/ (1-`c')/`th' - cond(`t0'>0, /*
			*/ `th'*`f0'*`f0'/`c0' + `f0' + (1-`c0')/`th',0) - /*
			*/ `d'*`th'*`f'/`c'*(1-2*`th'*`f'/`c'), eq(3)

		matrix `negH' = -(`d11',   `d12',  `d13' \ /* 
			*/       (`d12')', `d22',  `d23' \ /*
			*/       (`d13')',(`d23')',`d33')
	}
end
exit




