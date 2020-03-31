*! version 1.1.0  18jun2009
program define weibhet_ilfa
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
 	        tempvar b b0 c c0 f f0 h h0
	        scalar `p' = exp(`lnp')
	        scalar `th' = exp(`lntheta')
		
		gen double `h' = ln(`t')-`beta' if $ML_samp
		gen double `h0' = cond(`t0'>0,ln(`t0')-`beta',0) if $ML_samp
		gen double `b' = exp(`h'*`p') if $ML_samp
		gen double `b0' = cond(`t0'>0, exp(`h0'*`p'),0) /*
			*/ if $ML_samp
		gen double `c' = sqrt(1+2*`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,sqrt(1+2*`th'*`b0'),0) /*
			*/ if $ML_samp
	
		mlsum `lnf' = (1-`c')/`th' - cond(`t0'>0,(1-`c0')/`th',0) + /*
			*/ `d'*(-`beta'*`p' + `lnp' + `p'*ln(`t') - ln(`c'))

		if `todo'==0 | `lnf'==. {exit}

		gen double `f' = `b'/`c' if $ML_samp
		gen double `f0' = cond(`t0'>0,`b0'/`c0',0) if $ML_samp
		replace `g1' = `p'*(`f' - `f0' + `d'*(`f'*`th'/`c' - 1))
		replace `g2' = `p'*(`f0'*`h0'-`f'*`h'+`d'*(-`beta' + /* 
			*/ 1/`p' + ln(`t') - `f'*`th'*`h'/`c'))
		replace `g3' = -`f' + `f0' - (1-`c')/`th' + /*
			*/ cond(`t0'>0,(1-`c0')/`th',0) - `d'*`f'*`th'/`c'
		
$ML_ec		tempname d1 d2 d3

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }
	
		tempname d11 d12 d13 d22 d23 d33
		
		mlmatsum `lnf' `d11' = `p'*`p'*(`f'*(`f'*`th'/`c'-1) - /* 
			*/ cond(`t0'>0,`f0'*(`f0'*`th'/`c0'-1),0) + /*
			*/ `d'*`th'*`f'/`c'*(2*`f'/`c'*`th'-1)), eq(1)
		mlmatsum `lnf' `d12' = `g1' + `p'*`p'*(`f'*`h'* /*
			*/ (1-`f'*`th'/`c') - cond(`t0'>0, /*
			*/ `f0'*`h0'*(1-`f0'*`th'/`c0'),0) + `d'*`th'* /* 
			*/ `f'*`h'/`c'*(1-2*`f'*`th'/`c')), eq(1,2)
		mlmatsum `lnf' `d22' = `p'*`p'*(-`f'*`h'*`h'* /*
			*/ (1-`f'*`th'/`c') + cond(`t0'>0,`f0'*`h0'*`h0'* /*
			*/ (1-`f0'*`th'/`c0'),0) -`d'*`th'*`h'*`h'*`f'/`c'* /*
			*/ (1-2*`f'*`th'/`c')) -`d' + `g2', eq(2)

		mlmatsum `lnf' `d13' = `th'*`p'*(-`f'*`f'/`c' + /*
			*/ cond(`t0'>0,`f0'*`f0'/`c0',0) + `d'*`f'/`c'* /*
			*/ (1-2*`th'*`f'/`c')), eq(1,3)
		mlmatsum `lnf' `d23' = `p'*(`f'*`h'*`f'*`th'/`c' - /*
			*/ cond(`t0'>0,`f0'*`h0'*`f0'*`th'/`c0',0) - /*
			*/ `d'*`th'*`f'*`h'/`c'*(1-2*`f'*`th'/`c')), eq(2,3)
		mlmatsum `lnf' `d33' = `f'*(1+`f'*`th'/`c')+(1-`c')/`th' - /*
			*/ cond(`t0'>0, /*
			*/ `f0'*(1+`f0'*`th'/`c0')+(1-`c0')/`th',0) - /*
			*/ `d'*`f'*`th'/`c'*(1-2*`th'*`f'/`c'), eq(3)

		matrix `negH' = -(`d11',   `d12',  `d13' \ /* 
			*/       (`d12')', `d22',  `d23' \ /*
			*/       (`d13')',(`d23')',`d33')
	}
end
exit




