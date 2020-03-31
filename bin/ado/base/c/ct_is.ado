*! version 5.0.1  14aug1998
program define ct_is
	version 6.0
	local set : char _dta[_dta]
	if `"`set'"' != `"ct"' {
		di in red `"data not ct "' _c
		if `"`set'"'!=`""' {
			di in red `"(the data is marked as being `set' data)"'
		}
		else	di
		exit 119
	}
end
