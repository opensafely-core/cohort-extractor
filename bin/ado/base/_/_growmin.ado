*! version 1.0.0  04oct2004
program define _growmin
	version 6, missing
	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowmin() `"`by'"'
		/* NOTREACHED */
	}

	tempvar touse
	mark `touse' `if' `in'
	quietly {
		gen `type' `g' = . if `touse'
		tokenize `varlist'
		while "`1'"!="" {
			replace `g' = cond(`1' < `g',`1',`g') if `touse'
			mac shift
		}
	}
end
