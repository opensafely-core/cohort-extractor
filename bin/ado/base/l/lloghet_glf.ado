*! version 1.2.0  19feb2019
program define lloghet_glf
	version 7
	args todo b lnf g negH g1 g2 g3

	tempvar beta lngamma lntheta 
	mleval `beta' = `b', eq(1)
	mleval `lngamma' = `b', eq(2) scalar 
	mleval `lntheta' = `b', eq(3) scalar

 	local t = "$EREGt" 
	local t0 = "$EREGt0"
	local d = "$EREGd"
	
	quietly {
   		scalar `lngamma'=cond(`lngamma'<-20,-20,`lngamma')
                scalar `lntheta'=cond(`lntheta'<-20,-20,`lntheta')

		tempname th ga
		tempvar a b b0 c c0 f f0
	
		scalar `ga' = exp(-`lngamma')  /* gamma really 1/gamma */
		scalar `th' = exp(`lntheta')
		
		gen double `a' = 1/`th'+`d' if $ML_samp
		gen double `b' = 1+(`t'*exp(-`beta'))^`ga' if $ML_samp
		gen double `b0' =cond(`t0'>0,1+(`t0'*exp(-`beta'))^`ga',0) /*
			*/ if $ML_samp
		gen double `c' = ln1p(`th'*ln(`b')) if $ML_samp
		gen double `c0' =cond(`t0'>0,ln1p(`th'*ln(`b0')),0) /*
			*/ if $ML_samp
		gen double `f' = ln(`b') if $ML_samp
		gen double `f0' = cond(`t0'>0,ln(`b0'),0) if $ML_samp

		mlsum `lnf' = -`a'*`c' + `c0'/`th' + `d'*(`ga'*(ln(`t') - /*
			*/	`beta') - `lngamma' - ln(`b'))

		if `todo'==0 | `lnf'==. { exit }
		
$ML_ec		tempname d1 d2 d3
	        
		replace `g3' = -`a'*`th'*exp(-`c')*`f' + /* 
			*/ (`c'-`c0')/`th' + exp(-`c0')*`f0' 

		replace `b' = (`b'-1)*`ga'/`b'
		replace `b0' = cond(`t0'>0,(`b0'-1)*`ga'/`b0',0)

		replace `g1' = `a'*`th'*`b'*exp(-`c') -  /*
			*/ `b0'*exp(-`c0') + /*
			*/ `d'*(-`ga' + `b')

		replace `b' = -`b'*(ln(`t')-`beta')
		replace `b0' = cond(`t0'>0,-`b0'*(ln(`t0')-`beta'),0)

		replace `g2' = -`a'*`th'*exp(-`c')*`b' + exp(-`c0')*`b0' + /*
			*/ `d'*(`ga'*(`beta'-ln(`t'))-1-`b')
		
$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }

		tempname d11 d12 d22 d13 d23 d33		
		tempvar h h0
		
		gen double `h' = -`b'*`ga'* /*
			*/ (-`b'*(`t'*exp(-`beta'))^(-`ga')+1) if $ML_samp
		gen double `h0' = cond(`t0'>0,-`b0'*`ga'* /*
			*/ (-`b0'*(`t0'*exp(-`beta'))^(-`ga')+1),0) if $ML_samp

		replace `c' = exp(-`c')
		replace `c0' = cond(`t0'>0,exp(-`c0'),0)
		
		mlmatsum `lnf' `d22' = (-`a'*`th'*`c'*(`h' - /*
			*/ `b'*`b'*`th'*`c'*`ga') + /* 
			*/ `c0'*(`h0' - `b0'*`b0'*`c0'*`th'*`ga') + /*
			*/ `d'*(ln(`t')*`ga'*`ga' - /*
			*/ `beta'*`ga'*`ga'-`h'))/`ga', eq(2)

		mlmatsum `lnf' `d23' = `b'*`c'*(1-`a'*`th'*`c') + /*
			*/ `b0'*`c0'*(`c0' - 1), eq(2,3)

		mlmatsum `lnf' `d33' = `f'*`c'*(2-`a'*`c'*`th') + /*
			*/ (ln(`c')-cond(`t0'>0,ln(`c0'),0))/`th' - /*
			*/ `f0'*`c0'*(1+`f0'*`c0'*`th'), eq(3) 

		replace `f' = -`ga'*(`t'*exp(-`beta'))^`ga'
		replace `f0' = -`ga'*(`t0'*exp(-`beta'))^`ga'
		replace `b' = 1/(1-`f'/`ga')
		replace `b0' = cond(`t0'>0,1/(1-`f0'/`ga'),0)
		
		mlmatsum `lnf' `d11' = `a'*`th'*`f'*`c'*`b'*(`ga' + /*
			*/ `f'*`b'*(`th'*`c'+1)) - /*
			*/ `b0'*`c0'*`f0'*(`ga'+`f0'*`b0'*(`th'*`c0'+1)) + /* 
			*/ `d'*`b'*`f'*(`ga'+`f'*`b'), eq(1)
		
		mlmatsum `lnf' `d13' = `f'*`b'*`c'*(1 - /*
			*/ `a'*`th'*`c') + /*
			*/ `f0'*`th'*cond(`t0'>0,ln(`b0'),0)* /*
			*/ `b0'*`c0'*`c0', eq(1,3)
		
		replace `h'=-`f'*`ga'*(1+`ga'*(ln(`t')-`beta'))
		replace `h0'=cond(`t0'>0, /*
			*/ -`f0'*`ga'*(1+`ga'*(ln(`t0')-`beta')),0)
		replace `f'=`f'*`f'*`ga'*(ln(`t')-`beta')
		replace `f0'=cond(`t0'>0, /*
			*/ `f0'*`f0'*`ga'*(ln(`t0')-`beta'),0)

		mlmatsum `lnf' `d12' = (-`a'*`th'*`b'*`c'*(`h'- /*
			*/ `f'*`b'*(`th'*`c'+1)) + /*
			*/ `b0'*`c0'*(`h0' - `f0'*`b0'*(`th'*`c0'+1)) + /*
			*/ `d'*(`ga'*`ga'-`b'*(`h'-`b'*`f')))/`ga', eq(1,2)

		matrix `negH' = -(`d11',   `d12',  `d13' \  /* 
			*/	 (`d12')', `d22',  `d23' \  /*
			*/	 (`d13')',(`d23')',`d33')
	}
end
exit

