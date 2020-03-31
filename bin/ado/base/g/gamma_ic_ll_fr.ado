*! version 1.1.0  19feb2019
program gamma_ic_ll_fr 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnsig k lnthe
	mleval `xb' = `b', eq(1)
	mleval `lnsig' = `b', eq(2)
	mleval `k' = `b', eq(3)
	mleval `lnthe' = `b', eq(4) scalar
	
	tempvar sigma r z0 z1 u0 u1 theta itheta
	qui gen double `sigma' = exp(`lnsig')
	qui gen double `r' = abs(`k')^(-2)
	qui gen double `z0' = sign(`k')*(log(`t0')-`xb')/`sigma' 
	qui gen double `z1' = sign(`k')*(log(`t1')-`xb')/`sigma'
	qui gen double `u0' = `r'*exp(abs(`k')*`z0') 
	qui gen double `u1' = `r'*exp(abs(`k')*`z1')
	qui gen double `theta' = exp(`lnthe')
	qui gen double `itheta' = -1/`theta'

	tempvar S_t0 S_t1 h_t0 
	qui gen double `S_t0' = 1 - gammap(`r', `u0') if `k'>=0.01
	qui replace `S_t0' = -`S_t0' if `k' <= -0.01
	qui replace `S_t0' = 1 - normal(`z0') if abs(`k')<0.01
	qui gen double `S_t1' = 1 - gammap(`r', `u1') if `k'>=0.01
	qui replace `S_t1' = -`S_t1' if `k' <= -0.01
	qui replace `S_t1' = 1 - normal(`z1') if abs(`k')<0.01
	qui gen double `h_t0' = (`r'^`r')*exp(`z0'*sqrt(`r')-`u0')/ ///
		(`sigma'*`t0'*sqrt(`r')*exp(lngamma(`r'))*`S_t0')
	qui replace `h_t0' = exp(`z0'*sqrt(`r')-`u0')/ ///
		(`sigma'*`t0'*sqrt(2*c(pi))*(1-normal(`z0'))) if abs(`k')<0.01

	qui replace `lnfj' = (`itheta'-1)*log1m(`theta'*log(`S_t0')) +  ///
			log(`h_t0') + log(`t0') if `f' == 1
	qui replace `lnfj' = `itheta'*log1m(`theta'*log(`S_t0')) if `f' == 2
	qui replace `lnfj' = log1m((1-`theta'*log(`S_t1'))^`itheta') if `f' == 3
	qui replace `lnfj' = log((1-`theta'*log(`S_t0'))^`itheta' - ///
			(1-`theta'*log(`S_t1'))^`itheta') if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit 
end

