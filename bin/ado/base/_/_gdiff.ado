*! version 2.1.3  01oct2004
program define _gdiff
	version 6, missing
	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0
	syntax varlist(min=2) [if] [in] [, BY(string)]

	if `"`by'"' != "" {
		_egennoby diff() `"`by'"'
		/* NOTREACHED */
	}

	tokenize `varlist'
	local lhs "`1'"
	mac shift 
	quietly { 
		gen `type' `g' = 0 `if' `in'
		while "`1'"!="" {
			replace `g' = 1 if `g'==0 & `lhs'!=`1'
			mac shift
		}
	}
	capture label var `g' "diff `varlist'"
end
