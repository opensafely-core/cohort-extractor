*! version 1.2.2  07oct2000
program define _gfill
	version 6

	gettoken type 0 : 0
	gettoken vn   0 : 0
	gettoken eqs  0 : 0
	local 0 : subinstr local 0 "," " "
	local 0 ",fill`0'"
	syntax , fill(numlist min=2) [BY(string)]
	if `"`by'"' != "" {
		_egennoby fill() `"`by'"'
		/* NOTREACHED */
	}


	local k : word count `fill'
	local k2 = round(`k'/ 2, 1)
	local k3 = `k2' + 1

	tokenize `fill'

	local i 1
	quietly generate `type' `vn' = .
	while `i' <= `k' {
		quietly replace `vn' = `1' in `i'
		local i = `i'+1
		mac shift
	}

	tempvar diff
	quietly {
		gen `diff' = `vn'[_n+1] - `vn'[_n]
		replace `diff' = `diff'[_n-`k2'] in `k3'/l
		replace `vn' = `vn'[_n-1] + `diff'[_n-1] in /*
		*/ `k3'/l
		drop `diff'
	}
end
