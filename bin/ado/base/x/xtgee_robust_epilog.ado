*! version 1.0.0  13apr2009
program xtgee_robust_epilog, eclass
	version 11
	if "`e(cmd)'" != "xtgee" {
		error 301
	}
	tempname V
	if "`e(V_modelbased)'" == "matrix" {
		matrix `V' = e(V_modelbased)*sqrt(e(phi))
		ereturn matrix V_modelbased `V'
	}
end

