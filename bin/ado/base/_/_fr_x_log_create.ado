*! version 1.0.1  09feb2012
program _fr_x_log_create

	syntax , LOG(name) X(string) [ POINTS(integer 2) 		///
		 MIN(real 1e300) MAX(real -1e300) ]

	if `min' >= 1e300 | `max' < -1e300 {
		summarize `x' , meanonly
		if `min' >= 1e300  {
			local min = r(min)
		}
		if `max' <= -1e300 {
			local max = r(max)
		}
	}

	if c(N) < `points' {
		.`log'.Arrpush __NOLOG__ local realN `c(N)'
		.`log'.Arrpush __NOLOG__ set obs `points'
	}

	local label : variable label `x'

	.`log'.Arrpush __NOLOG__ tempvar holdx
	.`log'.Arrpush __NOLOG__ capture rename `x' \`holdx'
	.`log'.Arrpush __NOLOG__ 					  ///
		qui gen `x' = `min' + (_n-1)*(`max'-`min') / (`points'-1) ///
		in 1/`points'
	.`log'.Arrpush __NOLOG__ label variable `x' `"`label'"'

	// Note, _fr_x_log_cleanup must be called to clean up the tempvars and
	// possible observation change.
end
