*! version 3.0.3  13feb2015
program define serrbar_7
	version 6, missing
	syntax varlist(min=3 max=3) [if] [in] [, /*
		*/ SCale(real 1) Symbol(str) Connect(str) *]
	tempvar top bot
	tokenize `varlist'
	quietly {
		gen `top' = `1' + `scale' * `2' `if' `in'
		gen `bot' = `1' - `scale' * `2' `if' `in'
	}
	local len = length(`"`connect'"')
	local connect = `"`connect'"' + bsubstr(".II",1 + `len',3 - `len')
	if `"`symbol'"' == "" { local symbol "Oii" }
	gr7 `1' `top' `bot' `3' `if' `in', c(`connect') s(`symbol') `options'
end
