*! version 2.0.3  30sep2004
program define bs
	version 8, missing
	local version : di "version " string(_caller()) ", missing:"
	/* version control */
	if _caller() <= 7 {
		`version' bs_7 `0'
		exit
	}
	`version' bootstrap `0'
end
exit
