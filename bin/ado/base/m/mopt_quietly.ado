*! version 1.0.0  10sep2007
program mopt_quietly
	version 10
	local vv : di "version " string(_caller()) ":"
	if "`1'" == "mopt_trace" {
		gettoken trace 0 : 0
		local noi noisily
	}
	local notlf = inlist("`1'", "0", "1", "2")
	capture `noi' `vv' `trace' `0'
	if !c(rc) & `notlf' {
		confirm scalar `2'			// lnf
		if `1' {
			confirm scalar `3'		// gradient
			if `1' == 2 {
				confirm scalar `4'	// Hessian
			}
		}
	}
	exit c(rc)
end
