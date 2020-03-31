*! version 1.0.0  27mar2009

program mi_cmd_testtransform
	version 11

	if ("`e(mi)'"!="mi") {
		error 301
	}
	if (e(k_exp_mi)==0) {
		di as err "last estimates of transformations not found"
		exit 301
	}

	_xeq_esthold u_mi_tests testtransform `"`0'"'
end
