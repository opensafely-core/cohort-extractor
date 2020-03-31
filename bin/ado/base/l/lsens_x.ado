*! version 1.0.2  24nov1997
program define lsens_x
* touched by kth
/* 
    This is a driver program for lsens and lroc.

    Note: This program may "set obs".
*/
	version 6.0
	local touse `"`1'"'
	local p     `"`2'"'
	local w     `"`3'"'
	local y     `"`4'"'
	local sens  `"`5'"'
	local spec  `"`6'"'
	local one   `"`7'"' /* if nonempty, return 1 - specificity; */
			    /* otherwise    return specificity      */
	tempvar sumy
        quietly {
		sort `touse' `p'

		/* Compute 1 - specificity. */
		gen double `sumy' = sum((`y'==0)*`w') if `touse'
		local total = `sumy'[_N]
		by `touse' `p': gen `spec' = 1 - `sumy'/`total' /*
		*/			     if _n==_N & `touse'

		/* Compute sensitivity. */
		replace `sumy' = sum((`y'!=0)*`w') if `touse'
		local total = `sumy'[_N]
		gen `sens' = 1 - `sumy'/`total' if `spec'!=.
		
		/* Get corresponding probability. */
		count if `touse' == 0
		local p1 = `p'[r(N) + 1]
		replace `p' = cond(`spec'==.,.,cond(_n<_N,`p'[_n+1],1))
		
		sort `spec' `sens'

		/* Must add two observations at end of dataset:
		   `spec' = 1, `sens' = 1, `p' = `p1' 
		   `spec' = 1, `sens' = 1, `p' = 0
		*/ 
		count if `spec' != .
		local nl  = r(N) + 2
		local n2l = `nl' - 1

		if `nl' > _N { set obs `nl' }

		replace `spec' = 1 in `n2l'/`nl'
		replace `sens' = 1 in `n2l'/`nl'
		replace `p' = cond(_n==`nl',0,`p1') in `n2l'/`nl' 

		if `"`one'"' == "" { /* we want specificity */
			replace `spec' = 1 - `spec'
			label var `spec' "Specificity"
		}
		else label var `spec' "1 - Specificity"
		
		label var `sens' "Sensitivity"
		label var `p'    "Probability cutoff"
	}
end
