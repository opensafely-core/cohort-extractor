*! version 2.0.0  03jan2005
program nlexp2a, rclass

	if _caller() < 9 {
		nlexp2a_7 `0'
		exit
	}

	version 8
	
	syntax varlist(min=2 max=2) [aw fw iw] if
	tokenize `varlist'
	
	local fac 1.1	/* fudge factor for asymptote */
	tempname b1 b2
	tempvar Y
	quietly {
		generate double `Y' = `1'
		sum `Y' [`weight'`exp'] `if'
		local min = r(min)
		local max = r(max)
		reg `Y' `2' [`weight'`exp'] `if'
		if _b[`2'] > 0 {
			if `max' < 0 {
				scalar `b1' = `max'/`fac'
			}
			else {
				scalar `b1' = `max'*`fac'
			}
			replace `Y' = log(`b1' - `Y')
		}
		else {
			if `min' < 0 {
				scalar `b1' = `min'*`fac'
			}
			else {
				scalar `b1' = `min'/`fac'
			}
			replace `Y' = log(`Y' - `b1')
		}
		reg `Y' `2' [`weight'`exp'] `if'
		scalar `b2' = exp(_b[`2'])
	}
	
	return local eq "`1' = {b1=`=`b1''}*(1 - {b2=`=`b2''}^`2')"
	return local title /*
		*/ "2-parameter asymptotic regression, `1' = b1*(1 - b2^`2')"

end
