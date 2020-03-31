*! version 1.1.0  19feb2019
program logis_ic_ll 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lng 
	mleval `xb' = `b', eq(1)
	mleval `lng' = `b', eq(2)
	
	tempvar theta2 lambda et0 et1
	qui gen double `theta2' = exp(`lng')
	qui gen double `lambda' = exp(-`xb'/`theta2')
	qui gen double `et0' = 1 + `lambda'*`t0'^(1/`theta2')
	qui gen double `et1' = 1 + `lambda'*`t1'^(1/`theta2')
	
	qui replace `lnfj' = log(`lambda'*`t0'^(1/`theta2'-1)) - ///
			     log(`theta2'*`et0'^2) if `f' == 1
	qui replace `lnfj' = log(1/`et0') if `f' == 2
	qui replace `lnfj' = log1m(1/`et1') if `f' == 3
	qui replace `lnfj' = log(1/`et0'- 1/`et1') if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit 
end

