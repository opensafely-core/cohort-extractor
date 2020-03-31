*! version 1.0.0  04oct2004
* 2.0.0 NJC 1 February 1999 STB-50 dm70
program define _ganyvalue
	version 6.0, missing
	gettoken type 0 : 0
	gettoken g 0 : 0
	gettoken eqs 0 : 0
	syntax varlist(max =1 min =1) [if] [in], Values(str) [BY(string)]
	if `"`by'"' != "" {
		_egennoby anyvalue() `"`by'"'
	}
	marksample touse
	numlist "`values'", int
	tokenize "`r(numlist)'"
	local nnum : word count `r(numlist)'
	quietly {
	gen `type' `g' = .
		local i = 1
		while `i' <= `nnum' {
			replace `g' = `varlist' /*
				*/ if `varlist' == ``i'' & `touse'
			local i = `i' + 1
		}
	}
	if length("`varlist' if `values'") > 80 {
		note `g' : `varlist' if `values'
		label var `g' "`varlist': see notes"
	}
	else {
		label var `g' "`varlist' if `values'"
	}
end
