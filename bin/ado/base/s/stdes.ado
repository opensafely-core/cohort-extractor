*! version 6.1.0  24feb2007
program define stdes, rclass byable(onecall) sort
	version 10.0
	if _by() {
                local by "by `_byvars'`_byrc0':"
        }
	`by' stdescribe `0'
	return add
end
