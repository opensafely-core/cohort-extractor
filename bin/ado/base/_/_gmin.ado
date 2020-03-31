*! version 3.1.1  01oct2004
program define _gmin
	version 6, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]
	tempvar touse x
	quietly {
		gen byte `touse'=1 `if' `in'
		gen double `x' = `exp' 
		sort `touse' `by' `x'
		by `touse' `by': gen `typlist' `varlist' = `x'[1] if `touse'==1
	}
end
