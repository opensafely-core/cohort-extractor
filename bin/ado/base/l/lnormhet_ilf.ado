*! version 1.2.0  19feb2019
program define lnormhet_ilf
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
 	        tempvar k k0 c c0 f f0 h h0 
	        scalar `sg' = exp(`lnsigma')
	        scalar `th' = exp(`lntheta')
		gen double `k' = (ln(`t') - `beta')/`sg' if $ML_samp
        	gen double `k0' = cond(`t0'>0,(ln(`t0') - `beta')/`sg',0) /*
			*/ if $ML_samp
        	gen double `f' = 1-2*`th'*ln(norm(-`k')) if $ML_samp 
        	gen double `f0' = cond(`t0'>0,1-2*`th'*ln(norm(-`k0')),0) /*
			*/ if $ML_samp
        	gen double `c' = (1-sqrt(`f'))/`th' /*
			*/ if $ML_samp
        	gen double `c0' = cond(`t0'>0,(1-sqrt(`f0'))/`th',0) /*
			*/ if $ML_samp
		gen double `h' = normd(`k')/norm(-`k') if $ML_samp
		gen double `h0' = cond(`t0'>0,normd(`k0')/norm(-`k0'),0) /*
			*/ if $ML_samp

	        mlsum `lnf' = `c'-`c0'+`d'*(-`lnsigma'+ ln(normd(`k')) - /*
                */    ln1m(norm(`k')) - 0.5*ln(`f'))
		
		if `todo'==0 | `lnf'>=. {exit}
		
$ML_ec		tempname d1 d2 d3
		tempvar di di0
		replace `f' = 1/sqrt(`f')
		replace `f0' = cond(`t0'>0,1/sqrt(`f0'),0)
		gen double `di' = `h'*`f' - `d'*(-`k'+`h'*(1-`th'*`f'*`f')) /*
			*/ if $ML_samp
		gen double `di0' = `h0'*`f0' if $ML_samp
		
		replace `g1' = 	(`di'-`di0')/`sg'
		replace `g2' = (`di'*`k' - `di0'*`k0') -`d'
		replace `g3' = `f'*ln(norm(-`k'))*(1+`d'*`th'*`f') - /*
			*/ `c' + `c0' - `f0'*ln(norm(-`k0'))  
			
$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)
$ML_ec		matrix `g' = (`d1',`d2',`d3')
		
		if `todo'==1 | `lnf'>=. {exit}

		tempname d11 d12 d13 d22 d23 d33
		
		replace `h' = ln(norm(-`k'))
		replace `h0' = cond(`t0'>0,ln(norm(-`k0')),0)

		mlmatsum `lnf' `d33' = `c' - `c0' + /*
			*/ `f'*`h'*(`th'*(`f'*`f')*(`h'+`d'*`f')-1) - /*
			*/ `f0'*`h0'*(`th'*`h0'*(`f0'*`f0')-1), eq(3)

		replace `h' = normd(`k')/(norm(-`k'))
		replace `h0' = cond(`t0'>0,normd(`k0')/norm(-`k0'),0)

		replace `c' = `h'*(`h'-`k')
		replace `c0' = `h0'*(`h0'-`k0')
		replace `c' = `f'*(`c'-`th'*`h'*`h'*`f'*`f') - /* 
			*/ `d'*(-1+2*`th'*`th'*`h'*`h'*(`f'^4) + /*
			*/ (1-`th'*`f'*`f')*`c')
		replace `c0' = `f0'*(`c0'-`th'*`h0'*`h0'*`f0'*`f0')

		mlmatsum `lnf' `d11' = (`c0'-`c')/(`sg'*`sg'), eq(1)
		mlmatsum `lnf' `d12' = (`k0'*`c0' - `k'*`c' + /* 
			*/ `di0'-`di')/`sg', eq(1,2)
		mlmatsum `lnf' `d22' = `k0'*(`k0'*`c0' + `di0') - /*
			*/ `k'*(`k'*`c' + `di'), eq(2)

		replace `c' = `h'*(`f'^3)*ln(norm(-`k')) + /*
			*/ `d'*`h'*(`f'^4)
		replace `c0' = `h0'*(`f0'^3)*ln(norm(-`k0'))

		mlmatsum `lnf' `d13' = `th'/`sg'*(`c'-`c0'), eq(1,3)
		mlmatsum `lnf' `d23' = `th'*(`k'*`c'-`k0'*`c0'), eq(2,3)
		
		matrix `negH' = -(`d11'  , `d12',  `d13' \ /* 
			*/       (`d12')', `d22'  ,`d23' \ /*
                        */       (`d13')',(`d23')',`d33')
	}
end
exit




