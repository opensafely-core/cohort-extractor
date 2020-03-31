*! version 1.0.0  13apr2009
program xtgee_robust_prolog, eclass
	version 11
	if "`e(cmd)'" != "xtgee" {
		error 301
	}
	tempname V
	if "`e(V_modelbased)'" == "matrix" {
		matrix `V' = e(V_modelbased)/sqrt(e(phi))
		ereturn matrix V_modelbased `V'
	}
	else {
		matrix `V' = e(V)/sqrt(e(phi))
		ereturn repost V=`V'
	}
end
