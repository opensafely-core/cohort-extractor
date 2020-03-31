*! version 1.0.0  01apr2002
program define _getnewlabelname
	version 8
	args ret nothing
	if "`ret'"=="" | "`nothing'"!="" {
		error 198
	}

	local i 1
	while (1) {
		local name "_`i++'"
		capture label define `name' 1 "erase"
		if _rc==0 {
			label drop `name'
			c_local `ret' `name'
			exit
		}
	}
end
