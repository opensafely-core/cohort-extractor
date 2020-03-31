*! version 1.0.0  13jan2004
program define _ckvec
	version 8.2 

	args cmdname

	if "`cmdname'" == "" {
		di as err "no command name specified in call to "	///
			"{cmd:_ckvec}"
		exit 498
	}
	
	if "`e(cmd)'" != "vec" {
		di as err "{cmd:`cmdname'} only works after {cmd:vec}"
		exit 498
	}


end

exit

This program checks that the current e-results exist and come from {cmd:vec}

documented in _vec_undoc
