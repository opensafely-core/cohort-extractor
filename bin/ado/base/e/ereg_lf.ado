*! version 6.2.0  18jun2009
* (also see ereg.ado) 
program define ereg_lf 
	version 10.0
	args todo b lnf g negH g1

	tempvar I
	mleval `I' = `b'
	mlsum `lnf' = $ML_y2*`I'-exp(`I')*$ML_y1
	scalar `lnf' = `lnf' + $EREGa
	if (`todo'==0 | missing(`lnf')) exit

	quietly replace `g1' = $ML_y2-exp(`I')*$ML_y1
$ML_ec	mlvecsum `lnf' `g' = `g1'
	if (`todo'==1 | missing(`lnf')) exit

	mlmatsum `lnf' `negH' = exp(`I')*$ML_y1
end
exit

globals used:

	macro ML_y1	name of time variable
	macro ML_y2	name of 0/1 dead variable
	macro EREGa	(#) adjustment to log likelihood function

