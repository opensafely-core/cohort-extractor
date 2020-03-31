*! version 3.0.2  5dec1997
program define _crcird, rclass /* a b n1 n0 level tbflg*/
	version 3.0
	local a `1'
	local b `2'
	local n1 `3'
	local n0 `4'
	local level `5'
	local tbflg `6'
	local iz=invnorm(1-(1-`level'/100)/2)
	ret scalar ird = `a'/`n1'-`b'/`n0'
	mac def S_1 = return(ird)
	if "`tbflg'"=="" { 
		local se=sqrt(`a'/`n1'^2 + `b'/`n0'^2)
		ret scalar lb_ird = return(ird)-`iz'*`se'
		ret scalar ub_ird = return(ird)+`iz'*`se'
		mac def S_2 = return(lb_ird)
		mac def S_3 = return(ub_ird)
		mac def S_4
		exit
	}
	local M1=`a'+`b'
	local T=`n1'+`n0'
	local x = (`a'-`n1'*`M1'/`T')/sqrt(`M1'*`n1'*`n0'/`T'^2)
	ret scalar lb_ird = return(ird)*(1-`iz'/`x')
	ret scalar ub_ird = return(ird)*(1+`iz'/`x')
	ret local label "(tb)"
	mac def S_2 = return(lb_ird)
	mac def S_3 = return(ub_ird)
	mac def S_4 "(tb)"
end
exit
incidence rate data, incidence rate difference
R-164	IRD
R-170	se of IRD
R-170	test based calculation
R-155	definition of test x
