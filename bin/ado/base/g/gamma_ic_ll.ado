*! version 1.1.0  19feb2019
program gamma_ic_ll 
	
	version 15

	args todo b lnfj g H

	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb lnsig userk
	mleval `xb' = `b', eq(1)
	mleval `lnsig' = `b', eq(2)
	mleval `userk' = `b', eq(3)

	tempvar k sigma r z0 z1 u0 u1
	qui gen double `k' = `userk'
	qui replace `k'= sign(`k')*0.01 if abs(`k')<0.01
	qui gen double `sigma' = exp(`lnsig')
	qui gen double `r' = abs(`k')^(-2)
	qui gen double `z0' = sign(`k')*(log(`t0')-`xb')/`sigma' 
	qui gen double `z1' = sign(`k')*(log(`t1')-`xb')/`sigma'
	qui gen double `u0' = `r'*exp(abs(`k')*`z0') 
	qui gen double `u1' = `r'*exp(abs(`k')*`z1')

	tempvar S_t0 S_t1 lnf_t0 
	qui gen double `S_t0' = 1 - gammap(`r', `u0') if `k'>=0.01
	qui replace `S_t0' = -`S_t0' if `k' <= -0.01
	qui replace `S_t0' = 1 - normal(`z0') if abs(`k')<0.01
	qui gen double `S_t1' = 1 - gammap(`r', `u1') if `k'>=0.01
	qui replace `S_t1' = -`S_t1' if `k' <= -0.01
	qui replace `S_t1' = 1 - normal(`z1') if abs(`k')<0.01
	qui gen double `lnf_t0' = `r'*log(`r') - `lnsig' - log(`t0') - ///
				  1/2*log(`r')-lngamma(`r') + ///
				  `z0'* sqrt(`r') - `u0' if abs(`k')>=0.01
	qui replace `lnf_t0' = -`lnsig' - log(`t0') - 1/2*log(2*c(pi)) - ///
				1/2 * `z0'^2 if abs(`k')<0.01

	qui replace `lnfj' = `lnf_t0' + log(`t0') if `f' == 1
	qui replace `lnfj' = log(`S_t0') if `f' == 2
	qui replace `lnfj' = log1m(`S_t1') if `f' == 3
	qui replace `lnfj' = log(`S_t0' - `S_t1') if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit 
end

