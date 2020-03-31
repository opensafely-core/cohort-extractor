*! version 1.0.0  04oct2004
program define _growmax
	version 6, missing
	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowmax() `"`by'"'
		/* NOTREACHED */
	}


	tempvar touse
	mark `touse' `if' `in'
	quietly {
		tokenize `varlist'
		gen `type' `g' = `1' if `touse'
		mac shift
		while "`1'"!="" {
			replace `g' = cond(`g'>=.|(`1'>`g'&`1'<.),`1',`g') /*
								*/ if `touse'
			mac shift
		}
	}
end
