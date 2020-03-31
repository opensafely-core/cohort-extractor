*! version 1.1.0  19apr2007
program define _vec_dreduced 
	version 8.2

	local reduced "`e(reduce_lags)'"

	foreach p of local reduced {
		di as txt "maximum lag reduced to "	///
			"`p' because of collinearity"
	}
end		
