*! version 1.1.0  18jun2009
program define gamma_d2
	version 7
	args todo b lnf g negH g1 g2 g3 /* I s userk*/
	tempvar I s userk
	mleval `I' = `b', eq(1)
	mleval `s' = `b', eq(2)  
	mleval `userk' = `b', eq(3)
*	local lnf "`1'"
*       local I "`2'"
*       local s "`3'" /* ln_sigma */
*       local userk "`4'" /* kappa */
	quietly {
		tempvar k
		*sum `userk' if $ML_samp, meanonly
		gen double `k' = `userk' if $ML_samp
		replace `k'=sign(`k')*.01 if abs(`k')<0.01 & $ML_samp
 		local id : char _dta[st_id]
        	local t = "$ML_y1"       
       		local t0 = "$EREGt0"
        	local d = "$EREGd"        
	        tempvar  z z0 let let0 et et0 l sig u u0 detl det0l 
		tempvar ddetl ddet0l
		gen double `l'=(`k')^(-2) if $ML_samp
		gen double `sig'=exp(`s') if $ML_samp /* sigma */
		gen double `z' =(ln(`t')-`I')/`sig' if $ML_samp
		gen double `z0' =(ln(`t0')-`I')/`sig' if `t0'>0 & $ML_samp
		replace `z'  = -`z' if $ML_samp & `k'<0
		replace `z0' = -`z0' if $ML_samp & `k'<0
		quietly generate double `u' = `l'*exp(`z'/sqrt(`l'))/*
			*/ if $ML_samp
		quietly generate double `u0' = `l'*exp(`z0'/sqrt(`l')) /*
			*/ if $ML_samp
*		quietly _digammap `l' `u' if $ML_samp
*		quietly _digammap `l' `u0' if $ML_samp
		quietly generate double `et' = gammap(`l', `u') if $ML_samp
		quietly generate double `et0' = gammap(`l', `u0') if $ML_samp
		quietly generate double `detl' = dgammapda(`l', `u') if $ML_samp
		quietly generate double `det0l' = dgammapda(`l',`u0') if $ML_samp
		quietly generate double `ddetl' = dgammapdada(`l',`u') if $ML_samp
		quietly generate double `ddet0l' = dgammapdada(`l', `u0') if $ML_samp
		replace `et'=1-`et' if $ML_samp & `k'>0
		replace `et0'=1-`et0' if $ML_samp & `k'>0
	        gen double `let'= ln(`et')  if $ML_samp
	        gen double `let0'= ln(`et0') if `t0'>0 & $ML_samp
		tempvar templnf
/*
		gen double `templnf'= `d' * /*
		*/ (-0.5*ln(2*_pi)-0.5*(`z'^2)- ln(`sig')-`let') + /*
		*/ `let' if $ML_samp & abs(`k')<0.01
*/
		gen double `templnf' = `d'*(((`l'-0.5)*ln(`l')) /*
	   	*/  + (`z'*sqrt(`l'))-`u' /*
	   	*/ -lngamma(`l') - ln(`sig') -`let')+`let' /*
		*/ if $ML_samp & abs(`k')>=0.01

		replace `templnf'= `templnf'-`let0' if `t0'>0 & $ML_samp
		mlsum `lnf' = `templnf'
		if `todo'==0 {exit}
		
		tempvar dIdx dI0dx 
		generate double `dIdx' = dgammapdx(`l',`u')
		generate double `dI0dx' = dgammapdx(`l', `u0')

$ML_ec		tempname d1 d2 d3
		replace `g1' =  `dIdx'*`u'/ /*
		*/ (sqrt(`l')*`sig'*`et') if $ML_samp	

		replace `g1' = `g1' + `d'*( -`g1') if $ML_samp

		replace `g1' = `g1' + `d'*( /*
		*/ sign(`k')*(`u' - `l')/(`sig'*sqrt(`l'))) if $ML_samp

		replace `g1' = `g1' - /*
		*/ `dI0dx'*`u0'/   /*
		*/ (sqrt(`l')*`sig'*`et0') if $ML_samp & `t0'>0

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
	
		replace `g2' = `u'*`z'*sign(`k')* /*
		*/ `dIdx' / /*
		*/ (sqrt(`l')*`et') if $ML_samp

		replace `g2' = `g2' - `d'* `g2'

		replace `g2' = `g2' + `d'*( /*
		*/ (`z'* sqrt(`l'))*(`u'/`l' - 1) - 1) if $ML_samp

		replace `g2' = `g2' - `u0'*`z0'*sign(`k')* /*
		*/ `dI0dx'/ /*
		*/ (sqrt(`l')*`et0') if $ML_samp & `t0' > 0

$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)	

		replace `g3' = (2.0*`l'*sqrt(`l')*`detl' - /*
		*/ (`z' - 2.0*sqrt(`l'))* /*
		*/ `dIdx'*`u')/`et' if $ML_samp

		replace `g3' = `g3' - `d'*`g3' if $ML_samp

		replace `g3' = `g3' + `d'* /*
		*/ (-2.0*sign(`k')*`l'*sqrt(`l')* /*
		*/ (ln(`l') +(`l' -0.5)/`l' - digamma(`l')) - /*
		*/ sign(`k')*`z'*`l' - /*
		*/ sign(`k')*`u'*(`z' - 2.0*sqrt(`l'))) if $ML_samp

		replace `g3' = `g3' - /*
		*/  (2.0*`l'*sqrt(`l')*`det0l' - /*
		*/ (`z0' - 2.0*sqrt(`l'))* /*
		*/ `dI0dx'*`u0')/`et0'/*
		*/ if $ML_samp & `t0'> 0

$ML_ec		mlvecsum `lnf' `d3' = `g3', eq(3)

$ML_ec		matrix `g' = (`d1', `d2', `d3')


		if `todo'==1 {exit}

		tempvar d2Idxdx d2Idadx d2I0dxdx d2I0dadx
		generate double `d2Idxdx' = dgammapdxdx(`l', `u')
		generate double `d2Idadx' = dgammapdadx(`l', `u')
		generate double `d2I0dxdx' = dgammapdxdx(`l', `u0')
		generate double `d2I0dadx' = dgammapdadx(`l', `u0')

		tempvar d11
		gen double `d11' = (-`et'*`u'*sign(`k')*(`d2Idxdx'*`u' + /*
		*/ `dIdx') - `u'^2*`dIdx'^2)/((`et'^2)*`l'*`sig'^2) if $ML_samp

		/* /*
		*/ exp(-`u' + `l'*ln(`u') - lngamma(`l'))*( /*
		*/ sign(`k')*(`u' - `l')*`et' - /*
		*/  exp(-`u' + `l'*ln(`u')- lngamma(`l')))/ /*
		*/ (`l'*`sig'^2*`et'^2) /*
		*/  if $ML_samp */

		replace `d11' = (1 - `d')*`d11' if $ML_samp

		replace `d11' = `d11' - `d'*`u'/(`sig'*`sig'*`l') if $ML_samp

		replace `d11' = `d11' - (-`et0'*`u0'*sign(`k')*(`d2I0dxdx' /*
		*/ *`u0' + `dI0dx') - `u0'^2*`dI0dx'^2)/(`et0'^2*`l'*`sig'^2)/*
		*/ if $ML_samp & `t0'>0

		/* /*
		*/ exp(-`u0' + `l'*ln(`u0') - lngamma(`l'))*( /*
		*/ sign(`k')*(`u0' - `l')*`et0' - /*
		*/  exp(-`u0' + `l'*ln(`u0')- lngamma(`l')))/ /*
		*/ (`l'*`sig'^2*`et0'^2) /*
		*/  if $ML_samp & `t0' > 0 */

		tempvar d12
		generate double `d12' = -`u'*`z'*(`dIdx' +`u'*`d2Idxdx')/ /*
		*/ (`et'*`l'*`sig') - `u'*`dIdx'*(`et'*sqrt(`l') + /*
		*/ sign(`k')*`dIdx'*`u'*`z')/(`et'^2*`l'*`sig') if $ML_samp

		/* /*
		*/ exp(-lngamma(`l') - `u' + `l'*ln(`u'))* /*
		*/ (`et'*(`u'*`z'/sqrt(`l') - sqrt(`l')*`z' - 1) - /*
		*/ (sign(`k')*`z'/sqrt(`l'))* /*
		*/ exp(-lngamma(`l')-`u' + `l'*ln(`u')))/ /*
		*/ (sqrt(`l')*`sig'*`et'^2) if $ML_samp */

		replace `d12' = (1 - `d')*`d12' if $ML_samp

		replace `d12' = `d12' - `d'*sign(`k')/(`sig'*sqrt(`l'))*/*
		*/((`u' - `l') + `u'*`z'/sqrt(`l')) if $ML_samp

		replace `d12' = `d12' +`u0'*`z0'*(`dI0dx' +`u0'*`d2I0dxdx')/ /*
		*/ (`et0'*`l'*`sig') + `u0'*`dI0dx'*(`et0'*sqrt(`l') + /*
		*/ sign(`k')*`dI0dx'*`u0'*`z0')/(`et0'^2*`l'*`sig') /*
		*/ if $ML_samp & `t0'> 0

		/* /*
		*/ exp(-lngamma(`l') - `u0' + `l'*ln(`u0'))* /*
		*/ (`et0'*(`u0'*`z0'/sqrt(`l') - sqrt(`l')*`z0' - 1) - /*
		*/ (sign(`k')*`z0'/sqrt(`l'))* /*
		*/ exp(-lngamma(`l')-`u0' + `l'*ln(`u0')))/ /*
		*/ (sqrt(`l')*`sig'*`et0'^2) if $ML_samp & `t0'>0 */

		tempvar d13 d130
		generate double `d13' = `u'*sign(`k')* /*
		*/ ((`z'-2*sqrt(`l'))*(`dIdx'/*
		*/ + `u'*`d2Idxdx') - 2*`l'*sqrt(`l')*`d2Idadx')/ /*
		*/ (`et'*sqrt(`l')*`sig') - `u'*`dIdx'*(2*`l'*sqrt(`l')* /*
		*/ `detl' - sign(`k')*sqrt(`l')*`et' - /*
		*/ `u'*(`z' - 2*sqrt(`l'))*`dIdx')/((`et'^2)*sqrt(`l')*`sig')/*
		*/ if $ML_samp

		/*  sign(`k')*    /*
		*/ exp(-`u' + `l'*ln(`u')- lngamma(`l'))* /*
		*/ (-2*`l'*sqrt(`l')*ln(`u') - `u'*(`z'-2*sqrt(`l')) + /*
		*/ `l'*(`z'-2*sqrt(`l')))/(sqrt(`l')*`sig'*`et') if $ML_samp

		replace `d13' = `d13' + /*
		*/  exp(-`u' + `l'*ln(`u') - lngamma(`l'))*sign(`k')* /*
		*/ (1 + 2*`l'*digamma(`l'))/  /*
		*/ (`sig'*`et') if $ML_samp

		replace `d13' = `d13' - /*
		*/ exp(-`u' + `l'*ln(`u') - lngamma(`l'))*  /*
		*/ (-(`z' - 2*sqrt(`l'))*    /*
		*/ exp(-`u'+`l'*ln(`u') - lngamma(`l')) + /*
		*/ 2*`l'*sqrt(`l')*`detl')/(sqrt(`l')*`sig'*`et'^2) if $ML_samp
		*/ */

		/* YUCK!  That was awful! But still more to do.*/

		replace `d13' = (1 - `d')*`d13' if $ML_samp

		replace `d13' = `d13' + `d'*((`u' + `l')/`sig' + /*
		*/ `u'*(`z' - 2*sqrt(`l'))/(`sig'*sqrt(`l')) ) if $ML_samp

		generate double `d130' = /*
		*/ `u0'*sign(`k')*((`z0'-2*sqrt(`l'))*(`dI0dx'/*
		*/ + `u0'*`d2I0dxdx') - 2*`l'*sqrt(`l')*`d2I0dadx')/ /*
		*/ (`et0'*sqrt(`l')*`sig') - `u0'*`dI0dx'*(2*`l'*sqrt(`l')* /*
		*/ `det0l' - sign(`k')*sqrt(`l')*`et0' - /*
		*/ `u0'*(`z0' - 2*sqrt(`l'))*`dI0dx')//*
		*/ (`et0'^2*sqrt(`l')*`sig') /*
		*/ if $ML_samp & `t0'> 0


		/* sign(`k')*    /*
		*/ exp(-`u0' + `l'*ln(`u0')- lngamma(`l'))* /*
		*/ (-2*`l'*sqrt(`l')*ln(`u0') - `u0'*(`z0'-2*sqrt(`l')) + /*
		*/ `l'*(`z0'-2*sqrt(`l')))/(sqrt(`l')*`sig'*`et0') if $ML_samp

		replace `d130' = `d130' + /*
		*/  exp(-`u0' + `l'*ln(`u0') - lngamma(`l'))*sign(`k')* /*
		*/ (1+ 2*`l'*digamma(`l'))/  /*
		*/ (`sig'*`et0') if $ML_samp

		replace `d130' = `d130' - /*
		*/ exp(-`u0' + `l'*ln(`u0') - lngamma(`l'))*  /*
		*/ (-(`z0' - 2*sqrt(`l'))*    /*
		*/ exp(-`u0'+`l'*ln(`u0') - lngamma(`l')) + /*
		*/ 2*`l'*sqrt(`l')*`det0l')/(sqrt(`l')*`sig'*`et0'^2)/*
		*/ if $ML_samp */
		*/

		replace `d13' = `d13' - `d130' if $ML_samp & `t0' > 0

		tempvar d22
		generate double `d22' = (-`et'*sign(`k')*`u'*`z' /*
		*/ *(`d2Idxdx'*`u'*`z' + `z'*`dIdx' + sqrt(`l')*`dIdx') - /*
		*/ (`u'*`z')^2*`dIdx'^2)/(`et'^2*`l') if $ML_samp

		/*  /*
		*/ exp(-`u'+ `l'*ln(`u') - lngamma(`l'))*  /*
		*/ `z'*                     /*
		*/ ((`et'*sign(`k')*(`u'*`z' - `l'*`z' - sqrt(`l'))) - /*
		*/ exp(-`u' + `l'*ln(`u')-lngamma(`l'))*`z')/ /*
		*/ (`l'*`et'*`et') if $ML_samp 
		*/

		replace `d22' = (1-`d')*`d22' if $ML_samp

		replace `d22' = `d22' - (`d'/sqrt(`l'))* /*
		*/ (`z'*(`u'-`l') + `z'^2*`u'/sqrt(`l')) if $ML_samp

		replace `d22' = `d22' - /*
		*/ (-`et0'*sign(`k')*`u0'*`z0' /*
		*/ *(`d2I0dxdx'*`u0'*`z0' + `z0'*`dI0dx' + /*
		*/ sqrt(`l')*`dI0dx') - /*
		*/ (`u0'*`z0')^2*`dI0dx'^2)/(`et0'^2*`l') /*
		*/ if $ML_samp & `t0' > 0

		/* /*
		*/ exp(-`u0'+ `l'*ln(`u0') - lngamma(`l'))*  /*
		*/ `z0'*                     /*
		*/ ((`et0'*sign(`k')*(`u0'*`z0' - `l'*`z0' - sqrt(`l'))) - /*
		*/ exp(-`u0' + `l'*ln(`u0')-lngamma(`l'))*`z0')/ /*
		*/ (`l'*`et0'*`et0') if $ML_samp & `t0' > 0
		*/

		tempvar d23
		generate double `d23' = `u'*`z'*(`et'*sqrt(`l')*( /*
		*/ (`z'-2*sqrt(`l'))*(`u'*`d2Idxdx' + `dIdx') - /*
		*/ 2*`d2Idadx'*`l'*sqrt(`l')) - sign(`k')*`dIdx'*( /*
		*/ -`dIdx'*sqrt(`l')*`u'*(`z' - 2*sqrt(`l')) + /*
		*/ 2*`detl'*`l'^2 - `et'*sign(`k')*`l'))/(`et'^2*`l') /*
		*/ if $ML_samp

		/* /*
		*/ exp(-`u' + `l'*ln(`u') - lngamma(`l'))*`z'* /*
		*/ ( (sqrt(`l')*(`l'-`u')*(`z'-2*sqrt(`l')) +`l' + /*
		*/ 2*(`l'^2)*digamma(`l') -        /*
		*/ 2*(`l'^2)*ln(`u'))*`et'+     /*
		*/ sign(`k')*sqrt(`l')*         /*
		*/ exp(-`u' + `l'*ln(`u') - lngamma(`l'))*   /*
		*/ (`z' - 2*sqrt(`l')) - 2*sign(`k')*(`l'^2)*`detl' )/ /*
		*/ (`l'*`et'^2) if $ML_samp
		*/

		replace `d23' = (1-`d')*`d23' if $ML_samp

		replace `d23' = `d23' + `d'* /*
		*/ sign(`k')*(`z'*`u'+ `z'*`l' +          /*
		*/ `z'*`u'*(`z'- 2*sqrt(`l'))/sqrt(`l'))  /*
		*/ if $ML_samp

		replace `d23' = `d23' - /*
		*/ `u0'*`z0'*(`et0'*sqrt(`l')*( /*
		*/ (`z0'-2*sqrt(`l'))*(`u0'*`d2I0dxdx' + `dI0dx') - /*
		*/ 2*`d2I0dadx'*`l'*sqrt(`l')) - sign(`k')*`dI0dx'*( /*
		*/ -`dI0dx'*sqrt(`l')*`u0'*(`z0' - 2*sqrt(`l')) + /*
		*/ 2*`det0l'*`l'^2 - `et0'*sign(`k')*`l'))/(`et0'^2*`l') /*
		*/ if $ML_samp & `t0' > 0 


		/* /*
		*/ exp(-`u0' + `l'*ln(`u0') - lngamma(`l'))*`z0'* /*
		*/ ( (sqrt(`l')*(`l'-`u0')*(`z0'-2*sqrt(`l')) +`l' + /*
		*/ 2*(`l'^2)*digamma(`l') -        /*
		*/ 2*(`l'^2)*ln(`u0'))*`et0'+     /*
		*/ sign(`k')*sqrt(`l')*         /*
		*/ exp(-`u0' + `l'*ln(`u0') - lngamma(`l'))*   /*
		*/ (`z0' - 2*sqrt(`l')) - 2*sign(`k')*(`l'^2)*`det0l' )/ /*
		*/ (`l'*`et0'^2) if $ML_samp   /*
		*/ & `t0'>0
		*/


		tempvar d33
		generate double `d33' = 2*sign(`k')*`l'^2*(-3*`detl' /*
		*/ + `u'*(`z'-2*sqrt(`l'))*`d2Idadx'/sqrt(`l')         /*
		*/ - 2*`l'*`ddetl')/`et' if $ML_samp

		replace `d33' = `d33' - 2*`l'*sqrt(`l')*`detl'*(     /*
		*/ -`u'*(`z' - 2*sqrt(`l'))*`dIdx'                   /*
		*/ + 2*`l'*sqrt(`l')*`detl')/(`et'^2) if $ML_samp    

		replace `d33' = `d33' - sign(`k')*`u'*(              /*
		*/ ((`z'-2*sqrt(`l'))^2)*(`dIdx' + `u'*`d2Idxdx')    /*
		*/ + 2*`l'*`dIdx'                                    /*
		*/ - 2*`l'*sqrt(`l')*(`z'-2*sqrt(`l'))*`d2Idadx')/`et' /*
		*/ if $ML_samp

		replace `d33' = `d33' + `u'*(`z'-2*sqrt(`l'))*`dIdx'* /*
		*/ (-`u'*(`z'-2*sqrt(`l'))*`dIdx'                    /*
		*/  + 2*`l'*sqrt(`l')*`detl')/(`et'^2) if $ML_samp


		replace `d33' = (1-`d')*`d33' if $ML_samp

		replace `d33' = `d33' + `d'*(+6*`l'^2*( /*
		*/ ln(`l') + (`l' - .5)/`l' - digamma(`l')) + /*
		*/ 2*`l'^2*(2 + 1/`l' - 2*`l'* trigamma(`l')) + /*
		*/ 2*`z'*`l'*sqrt(`l') - `u'*(`z' - 2*sqrt(`l'))^2 - /*
		*/ 2*`u'*`l') if $ML_samp


		/* now for **0 */
		replace `d33' = `d33' - 2*sign(`k')*(`l'^2)*(-3*`det0l' /*
		*/ + `u0'*(`z0'-2*sqrt(`l'))*`d2I0dadx'/sqrt(`l')         /*
		*/ - 2*`l'*`ddet0l')/`et0' if $ML_samp & `t0'>0

		replace `d33' = `d33' + 2*`l'*sqrt(`l')*`det0l'*(     /*
		*/ -`u0'*(`z0' - 2*sqrt(`l'))*`dI0dx'                   /*
		*/ + 2*`l'*sqrt(`l')*`det0l')/(`et0'^2) if $ML_samp & `t0'>0   

		replace `d33' = `d33' + sign(`k')*`u0'*(              /*
		*/ ((`z0'-2*sqrt(`l'))^2)*(`dI0dx' + `u0'*`d2I0dxdx')    /*
		*/ + 2*`l'*`dI0dx'                                    /*
		*/ - 2*`l'*sqrt(`l')*(`z0'-2*sqrt(`l'))*`d2I0dadx')/`et0' /*
		*/ if $ML_samp & `t0'>0

		replace `d33' = `d33' - `u0'*(`z0'-2*sqrt(`l'))*`dI0dx'* /*
		*/ (-`u0'*(`z0'-2*sqrt(`l'))*`dI0dx'                    /*
		*/  + 2*`l'*sqrt(`l')*`det0l')/(`et0'^2) if $ML_samp & `t0'>0

		tempname g11 g12 g13 g22 g23 g33
		mlmatsum `lnf' `g11' = -`d11', eq(1)
		mlmatsum `lnf' `g12' = -`d12', eq(1,2)
		mlmatsum `lnf' `g13' = -`d13', eq(1,3)
		mlmatsum `lnf' `g22' = -`d22', eq(2)
		mlmatsum `lnf' `g23' = -`d23', eq(2,3)
		mlmatsum `lnf' `g33' = -`d33', eq(3)

*		noisily matrix list `g11' 
*		noisily matrix list `g12'
*		noisily matrix list `g13'
*		noisily matrix list `g22'
*		noisily matrix list `g23'
*		noisily matrix list `g33' 

		matrix `negH' = (`g11', `g12', `g13' \ `g12'', `g22', `g23' /*
		*/ \ `g13'', `g23'', `g33')
 

	}
end
