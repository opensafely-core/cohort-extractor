*! version 4.0.10 23sep2004
program hmeans, byable(onecall)
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`version' `BY' means `0'
end
exit
