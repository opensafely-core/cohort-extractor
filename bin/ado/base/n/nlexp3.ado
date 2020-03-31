*! version 2.0.0  03jan2005
program nlexp3, rclass

	if _caller() < 9 {
		nlexp3_7 `0'
		exit
	}

	version 8
	
	syntax varlist(min=2 max=2) [aw fw iw] if
	tokenize `varlist'
	
/*
	Approximate initial values by estimating upper asymptote
	if growth is positive, otherwise lower asymptote ($b0).
*/
	local fac 1.1	/* fudge factor for asymptote */
	tempname b0 b1 b2
	tempvar Y
	quietly {
		generate double `Y' = `1' 
		sum `Y' [`weight'`exp'] `if'
		local min = r(min)
		local max = r(max)
		reg `Y' `2' [`weight'`exp'] `if'
		if _b[`2']>0 {
			if `max'<0 { 
				scalar `b0' = `max'/`fac' 
			}
			else { 
				scalar `b0' = `max'*`fac' 
			}
			replace `Y' = log(`b0'-`Y')
			reg `Y' `2' [`weight'`exp'] `if'
			scalar `b1' = -exp(_b[_cons])
		}
		else {
			if `min'<0 { 
				scalar `b0' = `min'*`fac' 
			}
			else { 
				scalar `b0' = `min'/`fac' 
			}
			replace `Y' = log(`Y'-`b0')
			reg `Y' `2' [`weight'`exp'] `if'
			scalar `b1' = exp(_b[_cons])
		}
		scalar `b2' = exp(_b[`2'])
	}

	return local eq "`1' = {b0=`=`b0''} + {b1=`=`b1''}*{b2=`=`b2''}^`2'"
	return local title /*
	*/	"3-parameter asymptotic regression, `1' = b0 + b1*b2^`2'"

end

