*! version 1.1.0  19feb2019
program weib_ic_ll 
	
	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnp  
	mleval `xb' = `b', eq(1)
	mleval `lnp' = `b', eq(2)

	tempvar lambda p
	qui gen double `lambda' = exp(`xb')
	qui gen double `p' = exp(`lnp')
	
	qui replace `lnfj' = -`lambda'*`t0'^`p' + `xb' + `lnp' + ///
				`p'*log(`t0') if `f' == 1
	qui replace `lnfj' = -`lambda'*`t0'^`p' if `f' == 2
	qui replace `lnfj' = log(-expm1(-`lambda'*`t1'^`p')) if `f' == 3
	qui replace `lnfj' = log(exp(-`lambda'*`t0'^`p')- ///
				 exp(-`lambda'*`t1'^`p')) if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end
