*! version 1.0.0  10jun2016
program lnorm_ic_ll 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnsig
	mleval `xb' = `b', eq(1)
	mleval `lnsig' = `b', eq(2)
	
	tempvar sigma et0 et1
	qui gen double `sigma' = exp(`lnsig')
	qui gen double `et0' = (log(`t0')-`xb')/`sigma'
	qui gen double `et1' = (log(`t1')-`xb')/`sigma'
	
	qui replace `lnfj' = log(normalden(log(`t0'), `xb',`sigma')) ///
						if `f' == 1
	qui replace `lnfj' = log(normal(-`et0')) if `f' == 2
	qui replace `lnfj' = log(normal(`et1')) if `f' == 3
	qui replace `lnfj' = log(normal(`et1')-normal(`et0')) if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit 
end

