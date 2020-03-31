*! version 1.1.0  18jun2009
program define fron_ex	/* frontier: exponential model,
			   Y_i = X_i*beta + E_i; E_i = V_i - $S_COST*U_i
		   	   $S_COST = 1, production function; -1, cost function
			   assume U_i ~ exp(0, sigma_u) 
				  V_i ~ N(0, sigma_v) noise
			*/
	version 8 
	args todo b lnf g negH g1 g2 g3
	tempvar xb lnsigv2 lnsigu2
	mleval `xb'=`b', eq(1)	/* xb */
	mleval `lnsigv2'=`b', eq(2)	/* ln(sigma_v^2) */
	mleval `lnsigu2'=`b', eq(3)	/* ln(sigma_u^2) */

	tempvar e z
	qui gen double `e'=$ML_y1-`xb'
	qui gen double `z'=-$S_COST*`e'*exp(-`lnsigv2'/2) /*
		*/ -exp((`lnsigv2'-`lnsigu2')/2)
	mlsum `lnf'=-1/2*`lnsigu2'+0.5*exp(`lnsigv2'-`lnsigu2')  /*
		*/ + ln(normprob(`z')) + $S_COST*`e'*exp(-`lnsigu2'/2)   

	if `todo'==0 | `lnf'==. {
		exit
	}
$ML_ec	tempname d1 d2 d3

	tempvar zr ztd1 ztd2 ztd3
	qui gen double `zr'=normd(`z')/normprob(`z')
	qui gen double `ztd1'=$S_COST*exp(-`lnsigv2'/2)
	qui gen double `ztd2'=1/2*$S_COST*`e'*exp(-`lnsigv2'/2) /*
		*/ - 1/2*exp((`lnsigv2'-`lnsigu2')/2)
	qui gen double `ztd3'=0.5*exp((`lnsigv2'-`lnsigu2')/2)
	qui replace `g1'=`zr'*`ztd1'-$S_COST*exp(-`lnsigu2'/2)
	qui replace `g2'=1/2*exp(`lnsigv2'-`lnsigu2')+`zr'*`ztd2'
	qui replace `g3'=-1/2-1/2*exp(`lnsigv2'-`lnsigu2') /*
		*/ + `zr'*`ztd3'-1/2*$S_COST*`e'*exp(-`lnsigu2'/2)
$ML_ec	mlvecsum `lnf' `d1'=`g1', eq(1)
$ML_ec	mlvecsum `lnf' `d2'=`g2', eq(2)
$ML_ec	mlvecsum `lnf' `d3'=`g3', eq(3)
$ML_ec	mat `g'=(`d1', `d2', `d3')

	if `todo'==1 | `lnf'==. {
		exit
	}
	tempname d11 d12 d13 d22 d23 d33
	tempvar ztd
	qui gen double `ztd'=`zr'*(`zr'+`z')
	mlmatsum `lnf' `d11'=`ztd'*`ztd1'*`ztd1', eq(1)
	mlmatsum `lnf' `d12'=`ztd'*`ztd2'*`ztd1' /*
		*/ - `zr'*(-1/2*$S_COST*exp(-`lnsigv2'/2)), eq(1,2)
	mlmatsum `lnf' `d13'=`ztd'*`ztd3'*`ztd1' /*
		*/ - 1/2*$S_COST*exp(-`lnsigu2'/2), eq(1,3)
	mlmatsum `lnf' `d22'=`ztd'*`ztd2'*`ztd2' /*
		*/ - `zr'*(-1/4*$S_COST*`e'*exp(-`lnsigv2'/2) /*
		*/ - 1/4*exp((`lnsigv2'-`lnsigu2')/2)) /*
		*/ - 1/2*exp(`lnsigv2'-`lnsigu2'), eq(2)
	mlmatsum `lnf' `d23'=`ztd'*`ztd2'*`ztd3' /*
		*/ - `zr'*(1/4*exp((`lnsigv2'-`lnsigu2')/2)) /*
		*/ + 1/2*exp(`lnsigv2'-`lnsigu2'), eq(2,3)
	mlmatsum `lnf' `d33'=`ztd'*`ztd3'*`ztd3' /*
		*/ - `zr'*(-1/4*exp((`lnsigv2'-`lnsigu2')/2)) /*
		*/ - 1/2*exp(`lnsigv2'-`lnsigu2') /*
		*/ - 1/4*$S_COST*`e'*exp(-`lnsigu2'/2), eq(3)
	matrix `negH' = (`d11', `d12', `d13' \ `d12'', `d22', `d23' /*
		*/ \ `d13'', `d23'', `d33')
end

