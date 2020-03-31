*! version 1.2.0  19feb2019
program trpoiss_d2
        version 8
	args todo b lnf g negH score
        tempvar xb
	mleval `xb' = `b'
	mlsum `lnf' = -exp(`xb') + `xb'*$ML_y1 - lngamma($ML_y1+1) /*
            */ -ln1m(exp(-exp(`xb')))
        
	if (`todo' == 0 | `lnf'>=.) exit 
        tempvar z1 z2
        qui gen double `z1'= exp(`xb')
        qui gen double `z2' = exp(-`z1')
	qui replace `score' = $ML_y1 - `z1'- `z2'*`z1'/(1-`z2') if $ML_samp
$ML_ec	mlvecsum `lnf' `g' = `score'
	
        if (`todo' == 1 | `lnf'>=.)   exit
	mlmatsum `lnf' `negH' =`z1' - /*
          */ (`z1'^2* `z2'+ `z2'^2 * `z1'-`z2'*`z1')/((1-`z2')^2)

 end
