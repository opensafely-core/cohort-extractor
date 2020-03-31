*! version 3.0.2  14nov1997
program define _crcrd, rclass /* a b c d level tbflg*/
	version 3.1
	local a `1'
	local b `2'
	local c `3'
	local d `4'
	local level `5'
	local tbflg `6'
	local iz=invnorm(1-(1-`level'/100)/2)
	local n1=`a'+`c'
	local n0=`b'+`d'
	local t=`n1'+`n0'

	ret scalar rd = `a'/`n1'-`b'/`n0'
	if "`tbflg'"=="" { 
		local sdrd=sqrt(`a'*(`n1'-`a')/`n1'^3+`b'*(`n0'-`b')/`n0'^3)
		ret scalar lb = return(rd)-`iz'*`sdrd'
		ret scalar ub = return(rd)+`iz'*`sdrd'
		exit
	}
	local m1=`a'+`b'
	local m0=`c'+`d'
	local x=(`a'-`n1'*`m1'/`t')/sqrt((`m1'*`m0'*`n1'*`n0')/(`t'^2*(`t'-1)))
	ret scalar lb = return(rd)*(1-`iz'/`x')
	ret scalar ub = return(rd)*(1+`iz'/`x')
	ret local label "(tb)"
end
exit
cumulative incidence data, risk difference
R-164	RD
R-172	se of RD
R-172	test based calculation
R-163	eq 11-6, definition of test x
