*! version 1.0.0  27mar2009

program mi_cmd_test
	version 11

	if ("`e(mi)'"!="mi") {
		error 301
	}
	
	_xeq_esthold u_mi_tests test `"`0'"'
end
