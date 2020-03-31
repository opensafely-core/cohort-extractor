*! version 2.4.0  19feb2019
program define heck_d2 
	version 6.0
	args 	    todo	/*  whether to calculate gradient
		*/  b		/*  Name of beta matrix
		*/  lnf		/*  Name of scalar to hold likelihood
		*/  g		/*  Name of matrix to hold gradient
		*/  H		/*  Name of matrix to hold -Hessian
		*/  sc1		/*  Name of score variable 1
		*/  sc2		/*  Name of score variable 2
		*/  sc3		/*  Name of score variable 3
		*/  sc4		/*  Name of score variable 4	*/

	if "$ML_y2" == "" {
		tempvar y2
		quietly gen byte `y2' = $ML_y1 < .
	}
	else	local y2 $ML_y2

	tempname tau lns
	tempvar Is Ir 
	mleval `Ir'  = `b', eq(1)
	mleval `Is'  = `b', eq(2)
	mleval `tau' = `b', scalar eq(3)
	mleval `lns' = `b', scalar eq(4)
	
	tempname rho sig dlr dlr2
        scalar `rho'  = (expm1(2*`tau'))  /  (exp(2*`tau')+1)
	scalar `sig'  = exp(`lns')
	scalar `dlr'  = 4*exp(2*`tau') / ((exp(2*`tau')+1)^2)
	scalar `dlr2' = (8*exp(2*`tau')*(-expm1(2*`tau'))) / (exp(2*`tau')+1)^3

	tempvar eta
	qui gen double `eta' = (`Is' +   /*
		*/ ($ML_y1-`Ir')*`rho'/`sig') / sqrt(1-`rho'^2)

	mlsum `lnf' = cond(`y2',				   /*
		*/  (   ln(normprob(`eta')) - 0.5*ln(2*_pi*`sig'^2)   /*
		*/  	- 0.5*(($ML_y1-`Ir')/`sig')^2)             /*
		*/  , 						   /*
		*/      ln(normprob(-`Is'))			   /*
		*/  )

	if `todo'==0 { exit }

	tempname rr r2
	tempvar M ym Mp

	qui gen double `M' = normd(`eta') / normprob(`eta')
	qui gen double `ym' = ($ML_y1-`Ir') / `sig'
	drop `Ir'
	scalar `rr' = 1/sqrt(1-`rho'^2)
	qui gen double `Mp' = normd(-(`Is')) / normprob(-(`Is'))

$ML_ec	tempname gb gv gr go

	qui replace `sc1' = cond(`y2',`ym'/`sig'-`M'*`rho'/`sig'*`rr',0)
	qui replace `sc2' = cond(`y2',`M'*`rr' , -`Mp')
	qui replace `sc3' = /*
		*/ cond(`y2',`M'*(`ym'*`rr'+`eta'*`rho'*`rr'^2)*`dlr',0)
	qui replace `sc4' = cond(`y2',-`M'*`ym'*`rr'*`rho'+`ym'*`ym'-1,0)

$ML_ec	mlvecsum `lnf' `gb' = `sc1'  if `y2', eq(1)
$ML_ec	mlvecsum `lnf' `gv' = `sc2',            eq(2)
$ML_ec	mlvecsum `lnf' `gr' = `sc3'  if `y2', eq(3)
$ML_ec	mlvecsum `lnf' `go' = `sc4'  if `y2', eq(4)

$ML_ec	matrix `g' = (`gb',`gv',`gr',`go')

	if `todo'==1 { exit }

	tempvar N eta2 t2
	qui gen double `N' = `M'*(`eta'+`M')
	tempname dbdb dbdv dbdr dbdo dvdv dvdr dvdo drdr drdo dodo
	tempname s1 s2 s3 s4 s5 s6 s7 s8 s9 sa sb sc sd se

	scalar `s1' = `rr'*`rho' / `sig'
	scalar `s2' = 1 / (`sig'*`sig')
	scalar `s3' = `s1'^2
	scalar `s4' = `s1'*`rr'
	scalar `s5' = `rr' / `sig' + `rho'^2 / `sig'*`rr'^3
	scalar `s6' = 2 / `sig'
	scalar `s7' = `s4'*`rho'
	scalar `s8' = `rr'^2
	scalar `s9' = `rho'*`rr'^3
	scalar `sa' = `rho'*`rr'^2
	scalar `sb' = 2*`s9'
	scalar `sc' = `rr'^2 + 3*`rho'^2*`rr'^4
	scalar `sd' = `rho'*`rr'
	scalar `se' = `rr' + `rho'^2*`rr'^3

	qui gen double `t2' = `ym'*`rr'+`eta'*`sa'

	#delimit ;
	mlmatsum `lnf' `dbdb' = 
		`s2'+`N'*`s3' if `y2',                         eq(1) ;

	mlmatsum `lnf' `dbdv' = 
		-`N'*`s4'  if `y2',                            eq(1,2) ;

	mlmatsum `lnf' `dbdr' = 
		(-`N'*`s1'*(`t2')+`M'*`s5')*`dlr' if `y2',     eq(1,3) ;

	mlmatsum `lnf' `dbdo' = 
		`ym'*`s6'+`N'*`ym'*`s7'-`M'*`s1' if `y2' ,     eq(1,4) ;

	mlmatsum `lnf' `dvdv' = 
		cond(`y2',`N'*`s8',-(`Is')*`Mp'+(`Mp'^2)),     eq(2) ;

	mlmatsum `lnf' `dvdr' = 
		(`N'*(`rr')*(`t2') - `M'*`s9')*`dlr' if `y2',  eq(2,3) ;

	mlmatsum `lnf' `dvdo' = 
		-`N'*`ym'*`sa' if `y2',                        eq(2,4) ;

	mlmatsum `lnf' `drdr' = 
		(`N'*(`t2')^2 -`M'*(`ym'*`sb'+`eta'*`sc'))*
		(`dlr'^2) - `M'*(`t2')*`dlr2' if `y2',         eq(3) ;

	mlmatsum `lnf' `drdo' = 
		(-`N'*(`t2')*(`ym'*`sd') + 
		`M'*(`ym'*`se'))*`dlr' if `y2',                eq(3,4) ;

	mlmatsum `lnf' `dodo' = 	
		`N'*(`ym'*`sd')^2+
		2*`ym'^2- `M'*`ym'*`sd' if `y2',               eq(4) ;


	mat   `H' =  (  `dbdb'  , `dbdv'  , `dbdr'  , `dbdo'  \ 
			`dbdv'' , `dvdv'  , `dvdr'  , `dvdo'  \
			`dbdr'' , `dvdr'' , `drdr'  , `drdo'  \
			`dbdo'' , `dvdo'' , `drdo'' , `dodo'  ) ;

	#delimit cr
end

exit


We use the following parameterizations:

                            exp(2*tau)-1
       rho = atanh(tau) =   ------------        ensures that -1 <= rho <= 1
                            exp(2*tau)+1

       sig = exp(lns)                           ensures that  0 <= sig


such that the likelihood is really maximized for tau and lns.  This must
be reparameterized at report time.

