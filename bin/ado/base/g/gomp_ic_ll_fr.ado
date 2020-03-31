*! version 1.1.0  19feb2019
program gomp_ic_ll_fr 
	
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

	tempvar xb gamma ln_the
	mleval `xb' = `b', eq(1)
	mleval `gamma' = `b', eq(2) scalar
	mleval `ln_the' = `b', eq(3) scalar
	
	tempvar lambda theta itheta et0 et1
	qui gen double `lambda' = exp(`xb')
	qui gen double `theta' = exp(`ln_the')
	qui gen double `itheta' = -1 / `theta'
	qui gen double `et0' = 1 + `theta'*`lambda'/`gamma' * ///
					(expm1(`gamma'*`t0'))
	qui gen double `et1' = 1 + `theta'*`lambda'/`gamma' * ///
					(expm1(`gamma'*`t1')) 
	
	qui replace `lnfj' = (`itheta'-1)*log(`et0')+`xb'+`gamma'*`t0'+ ///
					log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'*log(`et0') if `f' == 2
	qui replace `lnfj' = log1m(`et1'^`itheta') if `f' == 3
	qui replace `lnfj' = log(`et0'^`itheta' - `et1'^`itheta') if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end

program define gamma2 			/* gamma == 0, reduce to exponential */

	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnthe
	mleval `xb' = `b', eq(1)
	mleval `lnthe' = `b', eq(3) scalar

	scalar `lnthe' = cond(`lnthe'<-20, -20, `lnthe')

	tempvar lambda theta itheta eta
	qui gen double `lambda' = exp(`xb')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'
	qui gen double `eta' = `lambda'*`theta'

	qui replace `lnfj' = (`itheta'-1)*log1p(`t0'*`eta')  ///
			     +`xb' + log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'*log1p(`t0'*`eta') if `f' == 2
	qui replace `lnfj' = log1m((1+`t1'*`eta')^`itheta') if `f' == 3
	qui replace `lnfj' = log((1+`t0'*`eta')^`itheta' - ///
			     (1+`t1'*`eta')^`itheta') if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 

end
