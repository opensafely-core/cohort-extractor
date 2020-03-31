*! version 1.2.0  11nov2006
program define xtdes, byable(onecall)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' xtdescribe `0'
end
exit
