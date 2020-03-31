*! version 1.1.0  19feb2019
program lnorm_ic_ll_fr 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnsig lnthe
	mleval `xb' = `b', eq(1)
	mleval `lnsig' = `b', eq(2)
	mleval `lnthe' = `b', eq(3) scalar
	
	tempvar sigma theta itheta et0 et1 
	qui gen double `sigma' = exp(`lnsig')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'
	qui gen double `et0' = ///
		cond(`t0'==0, 0, log(1-normal((log(`t0')-`xb')/`sigma')))
	qui gen double `et1' = ///
		cond(`t1'==0, 0, log(1-normal((log(`t1')-`xb')/`sigma')))
	

	qui replace `lnfj' = (`itheta'-1)*log1m(`theta'*`et0') + ///
			log(normalden(log(`t0'), `xb', `sigma')) - ///
 			`et0' if `f' == 1
	qui replace `lnfj' = `itheta'*log1m(`theta'*`et0') if `f' == 2
	qui replace `lnfj' = log1m((1-`theta'*`et1')^`itheta') if `f' == 3
	qui replace `lnfj' = log((1-`theta'*`et0')^`itheta'- ///
				 (1-`theta'*`et1')^`itheta') if `f'==4
	if (`todo'==0 | missing(`lnfj')) exit 
end

