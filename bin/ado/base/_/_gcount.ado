*! version 3.1.3  22feb2015
program define _gcount
	version 6, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax anything(name=anythin) [if] [in] [, BY(varlist)]

	tempvar touse
	quietly {
		gen byte `touse'=1 `if' `in'
		sort `touse' `by'
		by `touse' `by': gen `type' `g' = /*
			*/ sum(!missing(`anythin')) /*
			*/ if `touse'==1
		by `touse' `by': replace `g' = `g'[_N]
	}

end

