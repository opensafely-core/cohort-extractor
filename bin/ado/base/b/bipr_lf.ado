*! version 1.2.0  18jun2009
program define bipr_lf
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

	if `kappa' < -14 { scalar `kappa' = -14 }
	if `kappa' >  14 { scalar `kappa' =  14 }

	scalar `rho' = (exp(2*`kappa')-1) / (exp(2*`kappa')+1) 

	tempname m alpha

	tempvar q1i q2i Phi2 
	qui gen byte   `q1i'  = (2*($ML_y1~=0)-1)
	qui gen byte   `q2i'  = (2*($ML_y2~=0)-1)
	qui gen double `Phi2' = binorm(`q1i'*`xb1',`q2i'*`xb2',/*
				*/ `q1i'*`q2i'*`rho')
 
	mlsum `lnf' = log(`Phi2')  

	if `todo' == 0 { exit }

	tempvar w1i w2i rhoi di v1i v2i g1i g2i phi2 
	qui gen double `rhoi' = `q1i'*`q2i'*`rho' 
	qui gen double `w1i'  = `q1i'*`xb1' 
	qui gen double `w2i'  = `q2i'*`xb2' 
	qui gen double `di'   = 1/(sqrt(1-`rhoi'^2)) 
	qui gen double `v1i'  = `di' * (`w2i' - `rhoi'*`w1i')
	qui gen double `v2i'  = `di' * (`w1i' - `rhoi'*`w2i')
	qui gen double `g1i'  = normd(`w1i')*normprob(`v1i')
	qui gen double `g2i'  = normd(`w2i')*normprob(`v2i')
	qui gen double `phi2' = exp(-.5*(`w1i'^2+`w2i'^2-/*
		*/ 2*`rhoi'*`w1i'*`w2i')/ /*
		*/ (1-`rhoi'^2))/(2*_pi*sqrt(1-`rhoi'^2)) 

	tempname drdk
	scalar `drdk' = 4*exp(2*`kappa')/(exp(2*`kappa')+1)^2

	qui replace `sc1' = `q1i'*`g1i'/`Phi2'
	qui replace `sc2' = `q2i'*`g2i'/`Phi2'
	qui replace `sc3' = `q1i'*`q2i'*`phi2'/`Phi2'*`drdk'

$ML_ec	tempname g1 g2 g3
$ML_ec	mlvecsum `lnf' `g1' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `g2' = `sc2', eq(2)
$ML_ec	mlvecsum `lnf' `g3' = `sc3', eq(3)

$ML_ec	mat `g' = (`g1', `g2', `g3')

        if `todo' == 1 { exit }

	tempname d1d1 d1d2 d1d3 d2d2 d2d3 d3d3 d2rdk2

	#delimit ;

	scalar `d2rdk2' = 
		8*exp(2*`kappa')*(1-exp(2*`kappa')) / (exp(2*`kappa')+1)^3 ;

	mlmatsum `lnf' `d1d1' = 
		(`w1i'*`g1i'+`rhoi'*`phi2'+`g1i'^2/`Phi2')/`Phi2', eq(1) ;

	mlmatsum `lnf' `d1d2' = 
		(`q1i'*`q2i')/`Phi2'*(`g1i'*`g2i'/`Phi2'-`phi2'), eq(1,2) ;

	mlmatsum `lnf' `d1d3' = 
		`q2i'*`phi2'/`Phi2'*`drdk'* 
			(-`rhoi'*`di'*`v1i'+`w1i'+`g1i'/`Phi2'), eq(1,3) ;

	mlmatsum `lnf' `d2d2' = 
		(`w2i'*`g2i'+`rhoi'*`phi2'+`g2i'^2/`Phi2')/`Phi2', eq(2) ;
		
	mlmatsum `lnf' `d2d3' = 
		`q1i'*`phi2'/`Phi2'*`drdk'*
			(-`rhoi'*`di'*`v2i'+`w2i'+`g2i'/`Phi2'), eq(2,3) ;

	mlmatsum `lnf' `d3d3' = 
		(`phi2'/`Phi2') * (`di'^2*`rhoi'*(-1+`di'^2*
			(`w1i'^2+`w2i'^2-2*`rhoi'*`w1i'*`w2i'))-
			`di'^2*`w1i'*`w2i'+`phi2'/`Phi2')*(`drdk'^2) -
			`q1i'*`q2i'*`phi2'/`Phi2'*`d2rdk2' , eq(3) ;

	matrix `H' =    (`d1d1',  `d1d2',   `d1d3' \ 
			`d1d2'',  `d2d2',   `d2d3' \
			`d1d3'',  `d2d3'',  `d3d3') ; 

	#delimit cr
end
