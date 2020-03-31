*! version 3.0.3  04jun2011
program define _crcirr, rclass /* a b n1 n0 level tbflg*/
	version 3.0
	local a `1'
	local b `2'
	local n1 `3'
	local n0 `4'
	local level `5'
	local tbflg `6'
	local M1=`a'+`b'
	local irr = (`a'/`n1')/(`b'/`n0')
	if `n1'==0 | `n0'==0 { 
		ret scalar irr = .
		ret scalar lb_irr = .
		ret scalar ub_irr = .
		mac def S_1 .
		mac def S_2 .
		mac def S_3 .
		mac def S_4
		exit
	}
	if "`tbflg'"=="" { 
		quietly cii `M1' `a', level(`level')
		ret scalar irr = `irr'
		ret scalar lb_irr = r(lb)*`n0'/((1-r(lb))*`n1')
		ret scalar ub_irr = r(ub)*`n0'/((1-r(ub))*`n1')
		ret local label "(exact)"
		mac def S_1 `irr'
		mac def S_2 = return(lb_irr)
		mac def S_3 = return(ub_irr)
		mac def S_4 "(exact)"
		exit
	}
	local iz=invnorm(1-(1-`level'/100)/2)
	local T=`n1'+`n0'
	local x = (`a'-`n1'*`M1'/`T')/sqrt(`M1'*`n1'*`n0'/`T'^2)
	ret scalar irr = `irr'
	ret scalar lb_irr = return(irr)^(1-`iz'/`x')
	ret scalar ub_irr = return(irr)^(1+`iz'/`x')
	if return(lb_irr)>return(ub_irr) { 
		tempname hold
		scalar `hold' = return(lb_irr)
		ret scalar lb_irr = return(ub_irr)
		ret scalar ub_irr = `hold'
	}
	ret local label "(tb)"
	if `a'==0 {
		ret scalar lb_irr = .
		ret scalar ub_irr = .
	}
	mac def S_1 `irr'
	mac def S_2 = return(lb_irr)
	mac def S_3 = return(ub_irr)
	mac def S_4 "(tb)"
end
exit
incidence rate data, incidence rate ratio
R-164	IRD
R-166   exact conf interval calculation
R-172	test based calculation
R-155	definition of test x
