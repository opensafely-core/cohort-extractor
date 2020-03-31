*! version 1.2.0  19feb2019
program define zip_plf
        version 6.0
	args todo b lnf g H sc1 sc2

        /* Calculate the log-likelihood */

        tempvar xb zg
	mleval `xb' = `b', eq(1)
	mleval `zg' = `b', eq(2)

	#delimit ;
	mlsum `lnf' = cond($ML_y1 == 0 , 
		ln(normprob(`zg') + (1-normprob(`zg'))*exp(-exp(`xb'))),
		ln1m(normprob(`zg')) - exp(`xb') + `xb'*$ML_y1 - 
			lngamma($ML_y1+1) ) ;
	#delimit cr 

	if `todo' == 0 { exit }

	/* Calculate the score and gradient */

	tempvar f1 f2 lambda
	qui gen double `f1'     = 1-normprob(`zg') if $ML_samp
	qui gen double `lambda' = exp(`xb') if $ML_samp
	qui gen double `f2'     = normprob(`zg') + `f1'*exp(-`lambda') /*
					*/ if $ML_samp

	#delimit ;
	qui replace `sc1' = cond($ML_y1 == 0,
		-(`f1'*`lambda'*exp(-`lambda'))/`f2', 
		$ML_y1 - `lambda')  if $ML_samp ;
	qui replace `sc2' = cond($ML_y1 == 0 ,
		normd(`zg')*(-expm1(-`lambda')) /`f2',
		-normd(`zg')/`f1')  if $ML_samp ;
	#delimit cr

$ML_ec	tempname db dg
$ML_ec	mlvecsum `lnf' `db' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `dg' = `sc2', eq(2)
$ML_ec	matrix `g' = (`db',`dg')

	if `todo' == 1 { exit }

	/* Calculate the hessian */

	tempname dbdb dbdg dgdg
	tempvar ttt
	qui gen double `ttt' = .

	#delimit ;
	qui replace `ttt' = cond($ML_y1 == 0,
		(`f1'*`lambda'*(1-`lambda')*exp(-`lambda'))/`f2' + 
		((`f1'*`lambda'*exp(-`lambda'))/`f2')^2 , 
		`lambda')  if $ML_samp ;
	mlmatsum `lnf' `dbdb' = `ttt', eq(1) ; 
		
	qui replace `ttt' = cond($ML_y1 == 0,
		-normd(`zg')*`lambda'*exp(-`lambda') / `f2' -
		normd(`zg')*(-expm1(-`lambda'))*`f1'*
			`lambda'*exp(-`lambda') / `f2'^2,
		0)  if $ML_samp ;
	mlmatsum `lnf' `dbdg' = `ttt', eq(1,2) ;
		

	qui replace `ttt' = cond($ML_y1 == 0 ,
		`zg'*normd(`zg')*(-expm1(-`lambda')) / `f2' + 
		(normd(`zg')*(-expm1(-`lambda')) / `f2')^2 , 
		-`zg'*normd(`zg')/`f1' + (normd(`zg')/`f1')^2)  if $ML_samp ;
	mlmatsum `lnf' `dgdg' = `ttt', eq(2) ;
	#delimit cr

	matrix `H' = (`dbdb',`dbdg' \ `dbdg'',`dgdg')
end
