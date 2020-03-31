*! version 1.0.1  14aug2009
program _robust
	version 11
	syntax anything(id="varlist") [if] [in] [pw aw fw iw] ///
		[, Variance(name) *]

	if "`variance'" != "" {
		confirm matrix `variance'
		local V : copy local variance
		local vopt v(`variance')
	}
	else {
		if "`e(V)'" != "matrix" {
			error 301
		}
		local V "e(V)"
	}
	local cmd _ROBUST
	if _caller() < 11 {
		_ms_op_info `V'
		if r(fvops) {
			local cmd _robust2
		}
	}
	else {
		local cmd _robust2
	}
	`cmd' `anything' `if' `in' [`weight'`exp'], `vopt' `options'
end
exit
