*! version 5.4.4  03jan2005
program define sw, byable(onecall)
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	/* version control */
	if _caller() < 9 {
		`version' `BY' sw_8 `0'
		exit
	}
	`version' `BY' stepwise `0'
end
exit
