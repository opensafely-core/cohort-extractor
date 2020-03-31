*! version 3.1.6  07oct2002
program define hilite
	version 6
	syntax varlist(min=2 max=2) [if] [in], Hilite(string) /*
		*/ [ Symbol(string) T1title(string) * ]
	_crchil1 if `hilite'
	marksample touse
	local symbol = cond("`symbol'"=="", ".o", "`symbol'")
	tokenize `varlist'
	tempvar Temp
	quietly gen `Temp' = `1' if (`hilite') & `touse'
	_crcslbl `Temp' `1'
	if `"`t1title'"'=="" {
		local t1title `"`hilite' highlighted"'
	}
	gr7 `1' `Temp' `2' if `touse', s(`symbol') /*
		      */ t1(`"`t1title'"') `options'
end

program define _crchil1
	syntax if
end
