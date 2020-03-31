*! version 1.1.0  18jun2009
program define fron_hn	/* frontier: half-normal model,
			   Y_i = X_i*beta + E_i; E_i = V_i - $S_COST*U_i
		   	   $S_COST = 1, production function; -1, cost function
			   assume U_i ~ nonnegative N(0, sigma_u) 
				  V_i ~ N(0, sigma_v) noise
			*/
 	version 8 
 	args todo b lnf g negH g1 g2 g3
 	tempvar xb lnsigv2 lnsigu2
 	mleval `xb'=`b', eq(1)	/* linear form xb */
 	mleval `lnsigv2'=`b', eq(2)	/* ln(sigma_v^2) */
 	mleval `lnsigu2'=`b', eq(3)	/* ln(sigma_u^2) */

 	tempvar sigmaV2 sigmaU2 lambda sigma e z 
	qui gen double `sigmaV2'=exp(`lnsigv2')
	qui gen double `sigmaU2'=exp(`lnsigu2')
 	qui gen double `sigma'=sqrt(`sigmaV2'+`sigmaU2')
 	qui gen double `lambda'=sqrt(`sigmaU2'/`sigmaV2')
 	qui gen double `e'=$ML_y1-`xb'
 	qui gen double `z'=-$S_COST*`e'*`lambda'/`sigma'
 	mlsum `lnf'=0.5*ln(2/_pi)-ln(`sigma')+ln(normprob(`z')) /*
 		*/ - 0.5*`e'^2/`sigma'^2

  	if `todo'==0 | `lnf'==. {
		exit
	}
	#delimit ;
$ML_ec	tempname d1 d2 d3;
 	tempvar den prob zr zr1 ztd1 ztd2 ztd3;

	qui gen double `zr'=cond(`z'>=-37, normd(`z')/norm(`z'), -`z');
					
				/* derivatives: dz/dthetas */
 	qui gen double `ztd1'=$S_COST*`lambda'/`sigma';
 	qui gen double `ztd2'=-$S_COST*`e'*( 
		- `lambda'/(`sigma'^2)*(0.5*`sigmaV2'/`sigma') 
 		+ 1/`sigma'*(-0.5*`lambda') );
 	qui gen double `ztd3'=-$S_COST*`e'*( 
		- `lambda'/(`sigma'^2)*(0.5*`sigmaU2'/`sigma')
  		+ 1/`sigma'*(0.5*`lambda') );

	qui replace `g1'=`zr'*`ztd1'+`e'/`sigma'^2;
 	qui replace `g2'=`zr'*`ztd2'-0.5*`sigmaV2'/`sigma'^2
 		+ `e'^2/(`sigma'^3)*(0.5*`sigmaV2'/`sigma');
 	qui replace `g3'=`zr'*`ztd3'-0.5*`sigmaU2'/`sigma'^2
 		+ `e'^2/(`sigma'^3)*(0.5*`sigmaU2'/`sigma');
$ML_ec 	mlvecsum `lnf' `d1'=`g1', eq(1);
$ML_ec	mlvecsum `lnf' `d2'=`g2', eq(2);
$ML_ec	mlvecsum `lnf' `d3'=`g3', eq(3);
$ML_ec	mat `g'=(`d1', `d2', `d3');

	#delimit cr
	if `todo'==1 | `lnf'==. {
		exit
	}

	#delimit ;
	tempname d11 d12 d13 d22 d23 d33;
	tempvar ztd;
				/* derivative of -normd(z)/normprob(z) */
	qui gen double `ztd'=`zr'*(`zr'+`z'); 

	mlmatsum `lnf' `d11'=`ztd'*`ztd1'*`ztd1' + 1/`sigma'^2, eq(1);

	mlmatsum `lnf' `d12'=`ztd'*`ztd1'*`ztd2' - `zr'*(-`ztd2'/`e')
		+ 2*`e'/(`sigma'^3)*(0.5*`sigmaV2'/`sigma'), eq(1,2);

	mlmatsum `lnf' `d13'=`ztd'*`ztd1'*`ztd3' - `zr'*(-`ztd3'/`e')
		+ 2*`e'/(`sigma'^3)*(0.5*`sigmaU2'/`sigma'), eq(1,3);

	mlmatsum `lnf' `d22'=`ztd'*`ztd2'*`ztd2' - `zr'*$S_COST*(-`e')*(
		1.5*sqrt(`sigmaV2'*`sigmaU2')
		/`sigma'^4*(0.5*`sigmaV2'/`sigma')
 		- 0.5*sqrt(`sigmaV2'*`sigmaU2')/`sigma'^3*(0.5)
		+ 0.5*(`ztd2'/`e') )
 		+ 0.5*`sigmaV2'*`sigmaU2'/`sigma'^4 
		- 0.5*`e'^2*(`sigmaV2'*`sigmaU2'-`sigmaV2'^2)/`sigma'^6
		, eq(2);

 	mlmatsum `lnf' `d23'=`ztd'*`ztd2'*`ztd3' - `zr'*$S_COST*(-`e')*(
		1.5*sqrt(`sigmaV2'*`sigmaU2')
		/`sigma'^4*(0.5*`sigmaU2'/`sigma')
 		- 0.5*sqrt(`sigmaV2'*`sigmaU2')/`sigma'^3*(0.5)
		+ 0.5*(`ztd3'/`e') )
 		- 0.5*`sigmaV2'*`sigmaU2'/`sigma'^4 
		+ `e'^2*`sigmaV2'*`sigmaU2'/`sigma'^6
		, eq(2,3);

 	mlmatsum `lnf' `d33'=`ztd'*`ztd3'*`ztd3' - `zr'*$S_COST*(-`e')*( 
		1.5*`sigmaU2'*`sigma'
		/`sigma'^4*(0.5*`sigmaU2'/`sigma')
 		- 0.5*`sigmaU2'*`sigma'/`sigma'^3*(1.5)
		+ 0.5*(-`ztd3'/`e') )
		+ 0.5*`sigmaV2'*`sigmaU2'/`sigma'^4 
		- 0.5*`e'^2*(`sigmaV2'*`sigmaU2'-`sigmaU2'^2)/`sigma'^6
		, eq(3);

	matrix `negH' = (`d11', `d12', `d13' \ `d12'', `d22', `d23'
		\ `d13'', `d23'', `d33');

	#delimit cr
end

