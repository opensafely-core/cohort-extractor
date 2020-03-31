*! version 2.1.1  28jan2015  
program define frac_wgt, rclass
	version 8
/*
	Deal with weights.

	in: exp, touse, weight
	out:  (scalar) r(mnlnwt), (string) r(wgt)
*/
	args exp touse weight
	if `"`exp'"' != "" { 
		tempvar s
		gen `s' `exp'
		replace `touse'=0 if `s'<=0|`s'==.
		replace `s'=. if !`touse'
		if "`weight'"=="fweight" { 
			capture assert `s'==int(`s') if `touse'
			if _rc noi error 401
		}
		if bsubstr("`weight'",2,2)=="iw" {
			sum `s'
			return scalar mnlnwt=ln(r(mean)) // log mean weight = ln weight when constant
		}
		else {
			sum `s' 
			noi di "(sum of wgt is " r(sum) ")"
			replace `s'=log(`s'/r(mean))
			sum `s'
			return scalar mnlnwt=r(mean)
		}
		return local wgt `"[`weight'`exp']"'
	}
	else return scalar mnlnwt = 0
end
