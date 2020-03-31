*! version 1.1.0  19feb2019
program gomp_ic_ll 
	
	version 15

	args todo b lnfj g H
	quietly {	
		tempvar gamma  
		mleval `gamma' = `b', eq(2)
		qui cap assert `gamma' == 0

		if _rc == 0 {
			gamma2 `todo' `b' `lnfj' `g' `H'
			exit 
		}

		replace `gamma' = ///
		    cond(`gamma'<0, `gamma'- 0.000001, `gamma'+ 0.000001) ///
		    if abs(`gamma') < 1e-6

		gamma1 `todo' `b' `lnfj' `g' `H'
	}
end

program define gamma1				/* gamma != 0 */

	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb gamma
	mleval `xb' = `b', eq(1)
	mleval `gamma' = `b', eq(2)
	
	tempvar lambda et0 et1
	qui gen double `lambda' = exp(`xb')/`gamma'
	qui gen double `et0' = expm1(`gamma'*`t0') 
	qui gen double `et1' = expm1(`gamma'*`t1')  
	
	qui replace `lnfj' = `xb' + `gamma'*`t0' - `lambda'*`et0' + ///
					log(`t0') if `f' == 1
	qui replace `lnfj' = -`lambda' * `et0' if `f' == 2
	qui replace `lnfj' = log(-expm1(-`lambda'*`et1')) if `f' == 3
	qui replace `lnfj' = log(exp(-`lambda'*`et0')- ///
				 exp(-`lambda'*`et1')) if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end

program define gamma2 			/* gamma == 0, reduce to exponential */

	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb
	mleval `xb' = `b', eq(1)
	
	tempvar lambda
	qui gen double `lambda' = exp(`xb')

	qui replace `lnfj' = `xb'-`t0'*`lambda' + log(`t0') if `f' == 1
	qui replace `lnfj' = -`t0'*`lambda' if `f' == 2
	qui replace `lnfj' = log(-expm1(-`t1'*`lambda')) if `f' == 3
	qui replace `lnfj' = log(exp(-`t0'*`lambda')-exp(-`t1'*`lambda')) ///
							if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 

end
