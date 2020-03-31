*! version 1.1.0  18jun2009
program define lnormhet_glf
	version 7.0, missing
	args todo b lnf g negH g1 g2 g3

	tempvar beta 
	tempname lnsigma lntheta
	mleval `beta' = `b', eq(1)
	mleval `lnsigma' = `b', eq(2) scalar
	mleval `lntheta' = `b', eq(3) scalar
 
	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"

	quietly {
	        scalar `lnsigma'=cond(`lnsigma'<-20,-20,`lnsigma')
	        scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

	        tempname sg th
 	        tempvar k k0 a b b0 ec ec0 f f0
	        scalar `sg' = exp(`lnsigma')
	        scalar `th' = exp(`lntheta')
	        gen double `k' = (ln(`t') - `beta')/`sg' if $ML_samp
	        gen double `k0' = cond(`t0'>0,(ln(`t0') - `beta')/`sg',0) /*
			*/ if $ML_samp 
	        gen double `a' = 1/`th' + `d' if $ML_samp
	        gen double `b' = ln(norm(-`k')) if $ML_samp
	        gen double `b0' = cond(`t0'>0,ln(norm(-`k0')),0) if $ML_samp
	        gen double `ec' = 1/(1-`th'*`b') if $ML_samp
	        gen double `ec0' = 1/(1-`th'*`b0') if $ML_samp
		gen double `f' = normd(`k') if $ML_samp
		gen double `f0' = cond(`t0'>0,normd(`k0'),0) if $ML_samp

		mlsum `lnf' = `a'*ln(`ec') + `d'*(ln(`f')-`lnsigma'-`b') - /*
		       	*/ ln(`ec0')/`th'
		if `todo'==0 | `lnf'>=. {exit}

		tempvar h h0 di di0
		gen double `h' = `f'*exp(-`b')	if $ML_samp
		gen double `h0' = cond(`t0'>0,`f0'*exp(-`b0'),0) if $ML_samp
		gen double `di' = `a'*`ec'*`h'*`th'+`d'*(`k'-`h') if $ML_samp
		gen double `di0' = `ec0'*`h0' if $ML_samp

		replace `g1' = (`di'-`di0')/`sg'
		replace `g2' = (`di'*`k'-`di0'*`k0')-`d'
		replace `g3' = `a'*`th'*`b'*`ec'+(ln(`ec0')-ln(`ec'))/`th' - /*
			*/ `b0'*`ec0'
		
$ML_ec		tempname d1 d2 d3

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'>=. { exit }
	
		replace `f' = exp(-2*`b')*(`f'*(`f'-`k'*exp(`b')))
		replace `f0' = exp(-2*`b0')*(`f0'*(`f0'-`k0'*exp(`b0')))
		replace `f' = `a'*`th'*`ec'*(`f'-`th'*`h'*`h'*`ec') + /*
			*/ `d'*(1-`f')
		replace `f0' = -`th'*`di0'*`di0' + `ec0'*`f0'

		tempname d11 d12 d13 d22 d23 d33
		
		mlmatsum `lnf' `d11' = (`f0'-`f')/(`sg'*`sg'), eq(1)
		mlmatsum `lnf' `d12' = (`k0'*`f0'-`k'*`f'+`di0'-`di')/`sg', /*
			*/ eq(1,2)
		mlmatsum `lnf' `d22' = `k0'*(`di0'+`f0'*`k0') - /* 
			*/ `k'*(`di'+`f'*`k'), eq(2)

		replace `f' = `h'*`ec'*(`a'*`th'*`ec'*`b' + `d')
		replace `f0' = -`di0'*`b0'*`ec0'

		mlmatsum `lnf' `d13' = (`f'+`f0')*`th'/`sg', eq(1,3)
		mlmatsum `lnf' `d23' = (`f'*`k'+`f0'*`k0')*`th', eq(2,3)
		mlmatsum `lnf' `d33' = `b'*`ec'*(`a'*`th'*`th'*`b'*`ec' + /* 
			*/ `d'*`th'-1) + (ln(`ec')-ln(`ec0'))/`th' - /*
			*/ `b0'*`ec0'*(`b0'*`ec0'*`th' - 1), eq(3)
		matrix `negH' = -(`d11',   `d12',  `d13' \ /* 
			*/       (`d12')', `d22',  `d23' \ /*
			*/       (`d13')',(`d23')',`d33')
	}
end
exit




