*! version 1.1.0  19feb2019
program ereg2_ic_ll_fr 
	
	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnthe 
	mleval `xb' = `b', eq(1)
	mleval `lnthe' = `b', eq(2) scalar

	scalar `lnthe' = cond(`lnthe'<-20, -20, `lnthe')

	tempvar lambda theta itheta eta
	qui gen double `lambda' = exp(-`xb')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'
	qui gen double `eta' = `lambda'*`theta'

	qui replace `lnfj' = (`itheta'-1)*log1p(`t0'*`eta')  ///
			     -`xb' + log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'*log1p(`t0'*`eta') if `f' == 2
	qui replace `lnfj' = log1m((1+`t1'*`eta')^`itheta') if `f' == 3

	qui replace `lnfj' = log((1+`t0'*`eta')^`itheta' - ///
			     (1+`t1'*`eta')^`itheta') if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end
