*! version 1.1.4  28oct2004
program define nlexp2_7
	version 6
	if "`1'"=="?" {
		global S_2 "2-param. exp. growth curve, $S_E_depv=b1*b2^`2'"
		global S_1 "b1 b2"
/*
	Approximate initial values by regression of log Y on X.
*/
		local exp "[`e(wtype)' `e(wexp)']"
		tempvar Y
		quietly {
			gen `Y' = log(`e(depvar)') if e(sample)
			reg `Y' `2' `exp' if e(sample)
		}
		global b1 = exp(_b[_cons])
		global b2 = exp(_b[`2'])
		exit
	}
	replace `1'=$b1*($b2)^`2'
end
