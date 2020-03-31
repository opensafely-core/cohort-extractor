*! version 1.0.2  23jun2009
program define vec_p, properties(notxb)
	version 8.0

	capture noi vec_p_w `0'
	local rc = _rc

	if "`r(keepce)'" == "" | `rc' > 0 {

		local r = e(k_ce)

		forvalues i =1/`r' {
			capture drop _ce`i'
		}

	}

	capture drop _trend
	local svlist "`r(S_DROP_sindicators)'"
	if "`svlist'" != "" {
		capture drop `svlist'
	}

	exit `rc'

end
