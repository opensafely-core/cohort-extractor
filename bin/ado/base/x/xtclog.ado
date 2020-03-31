*! version 3.1.0  19nov2009
program define xtclog, byable(onecall)
	/* version statement intentionally omitted */
	if _caller() < 8 {
		global OLDCALL old
	}
	if _by() {
		local by "by `_byvars'`byrc0':"
	}
	`by' xtcloglog `0'
	capture mac drop OLDCALL
end
