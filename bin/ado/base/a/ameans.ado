*! version 4.1.0  01oct2018
program ameans, rclass byable(onecall)
	version 9, missing
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`version' `BY' means `0'
	return add
end
exit
