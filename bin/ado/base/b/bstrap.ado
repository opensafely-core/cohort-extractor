*! version 3.1.2  30sep2004
program bstrap
	version 8, missing
	local version : di "version " string(_caller()) ", missing:"
	/* version control */
	if _caller() <= 7 {
		`version' bstrap_7 `0'
		exit
	}
	`version' bootstrap `0'
end
exit
