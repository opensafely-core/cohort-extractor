*! version 3.0.2  14nov1997
program define _crcrr, rclass /* a b c d level tbflg*/
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

	ret scalar rr = (`a'/`n1')/(`b'/`n0')
	if "`tbflg'"=="" { 
		local sdlnrr = sqrt(`c'/(`a'*`n1')+`d'/(`b'*`n0'))
		ret scalar lb = exp(ln(return(rr))-`iz'*`sdlnrr')
		ret scalar ub = exp(ln(return(rr))+`iz'*`sdlnrr')
		exit
	}
	local m1=`a'+`b'
	local m0=`c'+`d'
	local x=(`a'-`n1'*`m1'/`t')/sqrt((`m1'*`m0'*`n1'*`n0')/(`t'^2*(`t'-1)))
	ret scalar lb = return(rr)^(1-`iz'/`x')
	ret scalar ub = return(rr)^(1+`iz'/`x')
	if return(lb)>return(ub) { 
		tempname hold
		scalar `hold' = return(lb)
		ret scalar lb = return(ub)
		ret scalar ub = `hold'
	}
	ret local label "(tb)"
	if `a'==0 { 
		ret scalar lb = .
		ret scalar ub = .
	}
end
exit
cumulative incidence data, risk ratio
R-165	RR
R-173	se of RR
R-173	test based calculation
R-163	eq 11-6, definition of test x
