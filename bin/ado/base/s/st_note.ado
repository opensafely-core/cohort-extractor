*! version 6.0.0  16jul1998
program define st_note
	version 6
	args text 
	capture confirm integer number `_dta[st_n0]'
	if _rc { 
		char _dta[st_n0] 0
	}
	local n = `_dta[st_n0]' + 1
	char _dta[st_n0] `n'
	char _dta[st_n`n'] `"`text'"'
end
