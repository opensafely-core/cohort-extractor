*! version 1.1.4  28oct2004
program define nlgom4_7
	version 6
	if "`1'"=="?" {
		global S_2 /*
*/ "4-parameter Gompertz function, `e(depvar)'=b0+b1*exp(-exp(-b2*(`2'-b3)))"
		global S_1 "b0 b1 b2 b3"
/*
	Approximate initial values by estimating upper and lower asymptotes.
*/
		local fac 1.1	/* fudge factor for asymptotes */
		local exp "[`e(wtype)' `e(wexp)']"
		tempvar Y
		quietly {
			gen `Y' = `e(depvar)' if e(sample)
			sum `Y' `exp' if e(sample)
			local min = r(min)
			local max = r(max)
			if `max'<0 	{ local b = `max'/`fac' }
			else 		{ local b = `max'*`fac' }
			if `min'<0 	{ local a = `min'*`fac' }
			else 		{ local a = `min'/`fac' }
		}
		replace `Y' = -ln(-ln((`Y'-`a')/`b')) if e(sample)
		reg `Y' `2' `exp' if e(sample)
		global b2 = _b[`2']
		global b3 = -_b[_cons]/$b2
		global b0 `a'
		global b1 = `b'-`a'
		exit
	}
	replace `1'=$b0+$b1*exp(-exp(-$b2*(`2'-$b3)))
end
