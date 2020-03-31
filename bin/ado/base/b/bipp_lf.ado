*! version 1.4.0  19feb2019
program define bipp_lf
        version 6.0
        local todo "`1'"  /* whether to calculate gradient      */
        local b    "`2'"  /* Name of beta matrix                */
        local lnf  "`3'"  /* Name of scalar to hold likelihood  */
        local g    "`4'"  /* Name of matrix to hold gradient    */
        local H    "`5'"  /* Name of matrix to hold -Hessian    */
        local sc1  "`6'"  /* Name of score variable 1           */
        local sc2  "`7'"  /* Name of score variable 2           */
        local sc3  "`8'"  /* Name of score variable 2           */

        /* Calculate the log-likelihood */

	tempname kappa rho
        tempvar xb1 xb2 
	mleval `xb1' = `b', eq(1)
	mleval `xb2' = `b', eq(2)
	mleval `kappa' = `b', eq(3) scalar

	if `kappa' < -8 { scalar `kappa' = -8 }
	if `kappa' >  8 { scalar `kappa' =  8 }

	scalar `rho' = (expm1(2*`kappa')) / (exp(2*`kappa')+1) 

	tempname m alpha

	tempvar prod
	qui gen byte `prod' = ($ML_y1!=0)*($ML_y2!=0)

	tempvar Phi2 
	qui gen double `Phi2' = binorm(`xb1',`xb2',`rho')
	qui replace `Phi2' = 1 - `Phi2' if `prod'==0
 
	mlsum `lnf' = log(`Phi2')  

	if `todo' == 0 { exit }

	tempvar sgn v1i v2i g1i g2i phi2 
	qui gen byte   `sgn'  = 2*(`prod'!=0) - 1
	qui gen double `v1i'  = (`xb2' - `rho'*`xb1') / sqrt(1-`rho'^2)
	qui gen double `v2i'  = (`xb1' - `rho'*`xb2') / sqrt(1-`rho'^2)
	qui gen double `g1i'  = normd(`xb1')*normprob(`v1i')
	qui gen double `g2i'  = normd(`xb2')*normprob(`v2i')
	qui gen double `phi2' = exp(-.5*(`xb1'^2+`xb2'^2-/*
		*/ 2*`rho'*`xb1'*`xb2')/ /*
		*/ (1-`rho'^2))/(2*_pi*sqrt(1-`rho'^2)) 

	tempname drdk
	scalar `drdk' = 4*exp(2*`kappa')/(exp(2*`kappa')+1)^2

	qui replace `sc1' = `sgn'*`g1i'/`Phi2'
	qui replace `sc2' = `sgn'*`g2i'/`Phi2'
	qui replace `sc3' = `sgn'*`phi2'/`Phi2'*`drdk'

$ML_ec	tempname g1 g2 g3
$ML_ec	mlvecsum `lnf' `g1' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `g2' = `sc2', eq(2)
$ML_ec	mlvecsum `lnf' `g3' = `sc3', eq(3)

$ML_ec	mat `g' = (`g1', `g2', `g3')

        if `todo' == 1 { exit }

	tempname di
	scalar `di' = 1/sqrt(1-`rho'^2)

	* OK to here

	tempname d1d1 d1d2 d1d3 d2d2 d2d3 d3d3 d2rdk2

	#delimit ;

	scalar `d2rdk2' = 
		8*exp(2*`kappa')*(-expm1(2*`kappa')) / (exp(2*`kappa')+1)^3 ;

	mlmatsum `lnf' `d1d1' = 
		(`sgn'*`xb1'*`g1i'+`sgn'*`rho'*`phi2'+`g1i'^2/`Phi2')/`Phi2', 
		eq(1) ;

	mlmatsum `lnf' `d1d2' = 
		(`g1i'*`g2i'/`Phi2'-`sgn'*`phi2')/`Phi2', eq(1,2) ;

	mlmatsum `lnf' `d1d3' = 
		`sgn'*`phi2'/`Phi2'*`drdk'* 
			(-`rho'*`di'*`v1i'+`xb1'+`sgn'*`g1i'/`Phi2'), eq(1,3) ;

	mlmatsum `lnf' `d2d2' = 
		(`sgn'*`xb2'*`g2i'+`sgn'*`rho'*`phi2'+`g2i'^2/`Phi2')/`Phi2', 
		eq(2) ;
		
	mlmatsum `lnf' `d2d3' = 
		`sgn'*`phi2'/`Phi2'*`drdk'*
			(-`rho'*`di'*`v2i'+`xb2'+`sgn'*`g2i'/`Phi2'), eq(2,3) ;

	mlmatsum `lnf' `d3d3' = 
		(`sgn'*`phi2'/`Phi2') * (`di'^2*`rho'*(-1+`di'^2*
			(`xb1'^2+`xb2'^2-2*`rho'*`xb1'*`xb2'))-
			`di'^2*`xb1'*`xb2'+`sgn'*`phi2'/`Phi2')*(`drdk'^2) -
			`sgn'*`phi2'/`Phi2'*`d2rdk2' , eq(3) ;

	matrix `H' =    (`d1d1',  `d1d2',   `d1d3' \ 
			`d1d2'',  `d2d2',   `d2d3' \
			`d1d3'',  `d2d3'',  `d3d3') ; 

	#delimit cr
end
exit

linear form version
program define bipp_lf
        version 6.0
        local ll    "`1'"  /* Log l */
        local xb1   "`2'"  /* x1*b1 */
        local xb2   "`3'"  /* x2*b2 */
        local kappa "`4'"  /* atanh(rho)   */


        local rr = (expm1(2*`kappa')) / (exp(2*`kappa')+1)

	if `kappa' < -18 { local rr = -1 }
	if `kappa' >  18 { local rr =  1 }

        quietly {
		replace `ll' = binorm(`xb1',`xb2',`rr')
		replace `ll' = 1-`ll' if $ML_y1 == 0
		replace `ll' = log(`ll')
        }
end
