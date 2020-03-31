*! version 1.0.3  18feb2009
program ml_footnote
	version 9
	syntax
	_check_e_rc
	if `"`e(converged)'"' == "0" {
		di as txt "Warning: convergence not achieved"
	}
end
