*! version 1.2.0  19feb2019
program define lloghet_ilf
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
		tempvar b b0 c c0 k k0
	
		scalar `ga' = exp(-`lngamma')  /* gamma really 1/gamma */
		scalar `th' = exp(`lntheta')
	
		gen double `k' = (`t'*exp(-`beta'))^`ga' if $ML_samp
		gen double `k0' = cond(`t0'>0,(`t0'*exp(-`beta'))^`ga',0) /*
			*/ if $ML_samp
		gen double `b' = ln1p(`k') if $ML_samp
		gen double `b0' = cond(`t0'>0,ln1p(`k0'),0) if $ML_samp
		gen double `c' = sqrt(1+2*`th'*`b') if $ML_samp
		gen double `c0' = cond(`t0'>0,sqrt(1+2*`th'*`b0'),0) /*
			*/ if $ML_samp

		mlsum `lnf' = (1-`c')/`th'-cond(`t0'>0,(1-`c0')/`th',0) + /*
			*/ `d'*(-`lngamma' + ln(`t')*`ga' -`beta'*`ga' - /*
			*/ `b' - ln(`c'))

		if `todo'==0 | `lnf'==. { exit }
		
$ML_ec		tempname d1 d2 d3
		tempvar f f0 h h0

		gen double `f' = `k'/(1+`k') if $ML_samp
		gen double `f0' = `k0'/(1+`k0') if $ML_samp
		
		replace `g3' = cond(`t0'>0,(1-`c0')/`th',0) - /*
			*/ (1-`c')/`th'
		replace `c' = 1/`c'
		replace `c0' = cond(`t0'>0,1/`c0',0)
	
		replace `g3' = `g3' + `b0'*`c0' - `b'*`c' - /*
			*/ `d'*`th'*`b'*`c'*`c'
		
		replace `g1' = `ga'*(`f'*`c' - `f0'*`c0' + `d'* /*
			*/ (`f'*(1+`th'*`c'*`c') - 1))
	        
		gen double `h' = -`f'*`ga'*`ga'*(ln(`t')-`beta') if $ML_samp
		gen double `h0' = cond(`t0'>0, /*
			*/ -`f0'*`ga'*`ga'*(ln(`t0')-`beta'),0) if $ML_samp

		replace `g2' = (`h0'*`c0' - `h'*`c')/`ga' - `d'* /*
			*/ (1 + ln(`t')*`ga' - `beta'*`ga' + `h'/`ga'* /*
			*/ (`th'*`c'*`c'+1))

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')

		if `todo'==1 | `lnf'==. { exit }

		tempname d11 d12 d22 d13 d23 d33		
		
		mlmatsum `lnf' `d13' = `th'*`ga'*(`b0'*(`c0'^3)*`f0' - /*
			*/ `f'*`c'*`c'*(`b'*`c' - `d'*(1 - /*
			*/ 2*`b'*`c'*`c'*`th'))), eq(1,3) 
		
		mlmatsum `lnf' `d23' = `th'/`ga'*(`h'*`c'*`c'* /*
			*/ (`b'*`c' + `d'*(2*`th'*`b'*`c'*`c'-1)) - /*
			*/ `h0'*`b0'*(`c0'^3)), eq(3) 
		
		mlmatsum `lnf' `d33' = (-cond(`t0'>0,1-1/`c0',0) + /*
			*/ (1-1/`c'))/`th' + /*
			*/ `b'*`c'*(1+`th'*`b'*`c'*`c') - /*
			*/ `b0'*`c0'*(1+`th'*`b0'*`c0'*`c0') - /*
			*/ `d'*`th'*`b'*`c'*`c'*(1-2*`th'*`b'*`c'*`c'), eq(3) 

		mlmatsum `lnf' `d11' = `ga'*`ga'*(`f'*`f'*(`th'*(`c'^3)* /*
			*/ (1+2*`th'*`d'*`c') - /*
			*/ (`d'+`d'*`th'*`c'*`c'+`c')/`k') + /*
			*/ `c0'*`f0'*`f0'*(cond(`t0'>0,1/`k0',0) /*
			*/  - `th'*`c0'*`c0')), eq(1)
 
		replace `b' = `th'*`f'*(`c'^3)*`ga'*`ga'*(ln(`t')-`beta')
		replace `b0' = cond(`t0'>0, /*
			*/ `th'*`f0'*(`c0'^3)*`ga'*`ga'*(ln(`t0')-`beta'),0)
		replace `k' = -`f'*`f'*`ga'*`ga'/`k'*(ln(`t')-`beta')
		replace `k0' = cond(`t0'>0, /*
			*/ -`f0'*`f0'*`ga'*`ga'/`k0'*(ln(`t0')-`beta'),0)

		mlmatsum `lnf' `d12' = -`g1' + `c'*`k' + `b'*`f' - /*
			*/ `c0'*`k0' - `b0'*`f0' + `d'*( /*
			*/ 2*`f'*`th'*`c'*`b' + (1+`th'*`c'*`c')*`k'), eq(1,2)
 
		replace `f' = (2*`f'-`k'/`ga')*(`ga'^3)*(ln(`t')-`beta')
		replace `f0' = cond(`t0'>0, /*
			*/ (2*`f0'-`k0'/`ga')*(`ga'^3)*(ln(`t0')-`beta'),0)

		mlmatsum `lnf' `d22' = (`h0'*`c0'-`h'*`c')/`ga' + /*
			*/ (`f0'*`c0'+`h0'*`b0'-`f'*`c'-`h'*`b')/(`ga'*`ga') /*
			*/ - `d'/`ga'*((`beta'-ln(`t'))*`ga'*`ga' + /*
			*/ 2*`h'*`th'*`c'*`b'/`ga' + (`th'*`c'*`c'+1)* /*
			*/ (`h' + `f'/`ga')), eq(2) 
		
		matrix `negH' = -(`d11',   `d12',  `d13' \  /* 
			*/	 (`d12')', `d22',  `d23' \  /*
			*/	 (`d13')',(`d23')',`d33')
	}
end
exit

