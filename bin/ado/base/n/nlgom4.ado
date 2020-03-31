*! version 2.0.0  03jan2005
program nlgom4, rclass

	if _caller() < 9 {
		nlgom4_7 `0'
		exit
	}
	
	version 8
	
	syntax varlist(min=2 max=2) [aw fw iw] if
	tokenize `varlist'
	
/*
	Approximate initial values by estimating upper and lower asymptotes.
*/
	local fac 1.1	/* fudge factor for asymptotes */
	tempvar Y
	tempname b0 b1 b2 b3
	quietly {
		generate double `Y' = `1'
		sum `Y' [`weight'`exp'] `if'
		local min = r(min)
		local max = r(max)
		if `max'<0 { 
			local b = `max'/`fac' 
		}
		else { 
			local b = `max'*`fac' 
		}
		if `min'<0 { 
			local a = `min'*`fac' 
		}
		else { 
			local a = `min'/`fac' 
		}
		replace `Y' = -ln(-ln((`Y'-`a')/`b'))
		reg `Y' `2' [`weight'`exp'] `if'
	}
	scalar `b2' = _b[`2']
	scalar `b3' = -1*_b[_cons] / `b2'
	scalar `b0' = `a'
	scalar `b1' = `b' - `a'

	return local eq ///
"`1' = {b0=`=`b0''} + {b1=`=`b1''}*exp(-exp(-{b2=`=`b2''}*(`2'-{b3=`=`b3''})))"

	return local title ///
"4-parameter Gompertz function, `1' = b0 + b1*exp(-exp(-b2*(`2' - b3)))"

end
