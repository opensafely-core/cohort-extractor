*! version 2.0.0  03jan2005
program nllog4, rclass

	if _caller() < 9 {
		nllog4_7 `0'
		exit
	}
	
	version 8
	
	syntax varlist(min=2 max=2) [aw fw iw] if
	tokenize `varlist'
	
/*
	Approximate initial values by estimating upper and lower asymptotes.
*/
	
	local fac 1.1
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
		replace `Y' = log((`Y'-`a')/(`b'-`Y'))
		reg `Y' `2' [`weight'`exp'] `if'
		scalar `b2' = _b[`2']
		scalar `b3' = -1*_b[_cons] / `b2'
		scalar `b0' = `a'
		scalar `b1' = `b' - `a'
	}
	
	local fun "`1' = {b0=`=`b0''} +"
	local fun "`fun' {b1=`=`b1''}/(1 +"
	local fun "`fun' exp(-{b2=`=`b2''}*(`2' - {b3=`=`b3''})))"
	
	return local eq "`fun'"
	return local title /*
*/ "4-parameter logistic function, `1' = b0 + b1/(1 + exp(-b2*(`2' - b3)))"

end
