*! version 1.0.4  17oct2018
program tpoiss_d2
	args todo b lnf g negH score
	version 11.0
	local tp $ZTP_tp_
	tempvar xb
	mleval `xb' = `b'
	mlsum `lnf' = -exp(`xb') + `xb'*$ML_y1 - lngamma($ML_y1+1) /*
		*/ -ln(poissontail(exp(`xb'),`tp'+1))

	if (`todo' == 0 | `lnf'>=.) exit

	tempvar z1 z2
	qui gen double `z1'= exp(`xb')
	qui gen double `z2' = poissonp(`z1',`tp')/ ///
		poissontail(`z1', `tp'+1)
	qui replace `score' = $ML_y1 - `z1'- `z1'*`z2' if $ML_samp
	$ML_ec mlvecsum `lnf' `g' = `score'

	if (`todo' == 1 | `lnf'>=.)   exit

	mlmatsum `lnf' `negH' =`z1' - ///
		(`z1'^2* `z2'+ `z2'^2 * `z1'^2 - (`tp'+1)* `z2'*`z1')


 end
