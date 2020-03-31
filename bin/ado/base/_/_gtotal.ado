*! version 1.0.2  18sep2008
program define _gtotal
	version 6, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist) Missing]
	tempvar touse miss
	quietly {
		gen byte `touse'=1 `if' `in'
		gen byte `miss' = `touse'
		if "`missing'" != "" {
			replace `miss'=0 if `exp' >= . 
		}
		sort `touse' `by' `miss'
		by `touse' `by': gen `typlist' `varlist' = sum(`exp') /*
					*/ if `miss'==1
		by `touse' `by': replace `varlist' = `varlist'[_N]
	}
end
