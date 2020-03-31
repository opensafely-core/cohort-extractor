*! version 1.1.0  18jun2009
program define hetpr_lf
	version 7.0
	args todo b lnf g H g1 g2


	tempvar psi_b psi_g
	mleval `psi_b' = `b', eq(1)
	mleval `psi_g' = `b', eq(2) 

	tempvar eta yv
	qui gen byte `yv' = 2*($ML_y1 ~= 0) - 1 if $ML_samp == 1
	qui gen double `eta' = `psi_b'/exp(`psi_g') if $ML_samp == 1
	mlsum `lnf' = log(normprob(`yv'*`eta')) 

	if `todo' == 0 { exit }

	/* create scores */
	tempvar denom
	#delimit ;
	quietly replace `g1' = `yv'*normd(`eta')/(exp(`psi_g')* 
		 normprob(`yv'*`eta'))
		if $ML_samp == 1 ;
	#delimit cr
	quietly replace `g2' = - `psi_b'*`g1' if $ML_samp == 1

$ML_ec	tempvar d1 d2 
$ML_ec	mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec	mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec	mat `g' = (`d1',`d2') 

	if `todo' == 1 { exit }

	tempvar d11 ratio d12 d22
	mlmatsum `lnf' `d11' = `g1'*(`eta'/exp(`psi_g')+`g1'), eq(1)
	qui gen double `ratio' = normd(`eta')/normprob(`yv'*`eta')

	mlmatsum `lnf' `d12' = `g1'+`eta'/exp(`psi_g')*(`g2'-`ratio'^2),eq(1,2)

	mlmatsum `lnf' `d22' = `g2'*(1 - `eta'^2 + `g2'), eq(2)
	mat `H' = (`d11',`d12' \ `d12'', `d22')
end
