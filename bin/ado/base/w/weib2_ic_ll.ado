*! version 1.1.0  19feb2019
program weib2_ic_ll		/* AFT metric */ 
	
	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb
	tempname lnp 

	mleval `xb' = `b', eq(1)
	mleval `lnp' = `b', eq(2)

	tempvar lambda p eta
	qui gen double `p' = exp(`lnp')
	qui gen double `lambda' = exp(-`p'*`xb')
	qui gen double `eta' = cond(log(`t0')!=.,`p'*log(`t0'), 0)
	
	qui replace `lnfj' = -`lambda'*`t0'^`p' -`p'*`xb' + `lnp' + `eta' ///
				if `f' == 1
	qui replace `lnfj' = -`lambda'*`t0'^`p' if `f' == 2
	qui replace `lnfj' = log(-expm1(-`lambda'*`t1'^`p')) if `f' == 3
	qui replace `lnfj' = log(exp(-`lambda'*`t0'^`p')- ///
				 exp(-`lambda'*`t1'^`p')) if `f'==4

/*

	tempvar lnt0 lnt1
	qui gen double `lnt0' = ln(`t0')
	qui gen double `lnt1' = ln(`t1')

	tempvar npxb p
	qui gen double `p' = exp(`lnp')
	qui gen double `npxb' = -`p'*`xb'

	tempvar eplnt0 eplnt1
	qui gen double `eplnt0' = - exp(`p'*`lnt0' + `npxb')
	qui gen double `eplnt1' = - exp(`p'*`lnt1' + `npxb')

	qui replace `lnfj' = `eplnt0' + `npxb' + `lnp' + `p'*`lnt0' if `f' == 1
	qui replace `lnfj' = `eplnt0'	if `f' == 2
	qui replace `lnfj' = log(-expm1(`eplnt1')) if `f' == 3
	qui replace `lnfj' = log(exp(`eplnt0')-exp(`eplnt1')) if `f'==4

*/
	if (`todo'==0 | missing(`lnfj')) exit 
end
