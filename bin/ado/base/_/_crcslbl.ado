*! version 1.1.0  19dec1998
program define _crcslbl	/* varname varname */
	version 6
	args dst src
	local w : variable label `src'
	if `"`w'"' == "" {
		local w "`src'"
	}
	label variable `dst' `"`w'"'
end
