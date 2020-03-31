*! version 1.1.4  28oct2004
program define nlexp3_7
	version 6
	if "`1'"=="?" {
		global S_2 /*
		*/ "3-parameter asymptotic regression, `e(depvar)'=b0+b1*b2^`2'"
		global S_1 "b0 b1 b2"
/*
	Approximate initial values by estimating upper asymptote
	if growth is positive, otherwise lower asymptote ($b0).
*/
		local fac 1.1	/* fudge factor for asymptote */
		local exp "[`e(wtype)' `e(wexp)']"
		tempvar Y
		quietly {
			gen `Y' = `e(depvar)' if e(sample)
			sum `Y' `exp' if e(sample)
			local min = r(min)
			local max = r(max)
			reg `Y' `2' `exp' if e(sample)
			if _b[`2']>0 {
				if `max'<0 	{ global b0 = `max'/`fac' }
				else 		{ global b0 = `max'*`fac' }
				replace `Y' = log($b0-`Y')
				reg `Y' `2' `exp'
				global b1 = -exp(_b[_cons])
			}
			else {
				if `min'<0 	{ global b0 = `min'*`fac' }
				else 		{ global b0 = `min'/`fac' }
				replace `Y' = log(`Y'-$b0)
				reg `Y' `2' `exp'
				global b1 = exp(_b[_cons])
			}
		}
		global b2 = exp(_b[`2'])
		exit
	}
	replace `1'=$b0+$b1*($b2)^`2'
end
