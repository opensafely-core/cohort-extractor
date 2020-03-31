*! version 4.1.0  19nov2009
program define xtpois, byable(onecall)
	/* version statement intentionally omitted */
	if _by() {
		local by "by `_byvars'`byrc0':"
	}
	`by' xtpoisson `0'
end
