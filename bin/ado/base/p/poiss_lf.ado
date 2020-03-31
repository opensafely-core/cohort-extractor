*! version 1.1.0  18jun2009
program define poiss_lf
        version 6
	args todo b lnf g H score
        tempvar xb
	mleval `xb' = `b'
	mlsum `lnf' = -exp(`xb') + `xb'*$ML_y1 - lngamma($ML_y1+1)

	if `todo' == 0 | `lnf'==. {
		exit
	}

	qui replace `score' = $ML_y1 - exp(`xb') if $ML_samp
$ML_ec	mlvecsum `lnf' `g' = `score'

	if `todo' == 1 | `lnf'==.  {
		exit
	}

	mlmatsum `lnf' `H' = exp(`xb')
end
