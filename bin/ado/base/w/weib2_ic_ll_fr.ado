*! version 1.1.0  19feb2019
program weib2_ic_ll_fr 
	
	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnp lnthe 
	mleval `xb' = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	mleval `lnthe' = `b', eq(3) scalar

	tempvar lambda p theta itheta eta0 eta1
	qui gen double `p' = exp(`lnp')
	qui gen double `lambda' = exp(-`p'*`xb')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'
	qui gen double `eta0' = 1 + exp(`lnthe'-`p'*`xb')*`t0'^`p'
	qui gen double `eta1' = 1 + exp(`lnthe'-`p'*`xb')*`t1'^`p'
	
	qui replace `lnfj' = (`itheta'-1)* log(`eta0')+`lnp' - `p'*`xb' + /// 
				`p'*log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'*log(`eta0') if `f' == 2
	qui replace `lnfj' = log1m(`eta1'^`itheta') if `f' == 3
	qui replace `lnfj' = log(`eta0'^`itheta'- `eta1'^`itheta') if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end
