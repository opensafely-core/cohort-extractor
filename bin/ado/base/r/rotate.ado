*! version 1.1.0  01oct2018
program rotate, rclass
	version 9

	if _caller() < 9 {
		rotate_cmd8 `0'
		return add
		exit
	}

	if "`e(cmd)'" == "" {
		error 301
	}
	
	if "`e(rotate_cmd)'" == "" {
		dis as err "no rotation command found in e(rotate_cmd)"
		exit 198
	}

	syntax [, clear * ]
		
	if "`clear'" != "" & `"`options'"' != "" { 
		dis as err "option clear may not be combined with other options" 
		exit 198
	}
	else if "`clear'" != "" { 
		_rotate_clear
	}
	else { 
		`e(rotate_cmd)' `0'
		return add
	}
end
