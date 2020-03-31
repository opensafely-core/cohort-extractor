*! version 9.4.0  01oct2018
program define jknife, eclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"
	/* version control */
	if _caller() < 9 {
		`version' jknife_8 `0'
		exit
	}
	`version' jackknife `0'
end
exit
