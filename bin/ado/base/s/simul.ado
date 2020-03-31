*! version 3.1.2  28sep2004
program simul
	version 8, missing
	local version : di "version " string(_caller()) ", missing:"
	/* version control */
	if _caller() <= 7 {
		`version' simul_7 `0'
		exit
	}
	`version' simulate `0'
end
exit
