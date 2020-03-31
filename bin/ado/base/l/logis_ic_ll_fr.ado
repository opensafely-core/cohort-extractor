*! version 1.1.0  19feb2019
program logis_ic_ll_fr 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lngamma lnthe 
	mleval `xb' = `b', eq(1)
	mleval `lngamma' = `b', eq(2)
	mleval `lnthe' = `b', eq(3) scalar
	
	tempvar lambda igamma theta itheta et0 et1 ht0
	qui gen double `igamma' = 1/exp(`lngamma')
	qui gen double `lambda' = exp(-`xb')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'
	qui gen double `et0' = (1 + (`lambda'*`t0')^`igamma')^(-1)
	qui gen double `et1' = (1 + (`lambda'*`t1')^`igamma')^(-1)
	qui gen double `ht0' = `igamma'/`t0'* ///
		(`lambda'*`t0')^`igamma'/(1+(`lambda'*`t0')^`igamma')
	
	qui replace `lnfj' = (`itheta'-1)*log1m(`theta'*log(`et0')) + ///
			log(`ht0') + log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'* log(1-`theta'*log(`et0')) if `f' == 2
	qui replace `lnfj' = log1m((1-`theta'*log(`et1'))^`itheta') if `f' == 3
	qui replace `lnfj' = log((1-`theta'*log(`et0'))^`itheta'- ///
				 (1-`theta'*log(`et1'))^`itheta') if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit 
end

