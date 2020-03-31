*! version 3.1.1  01oct2004
program define _gmean
	version 6, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]

	tempvar touse 
	quietly {
		gen byte `touse'=1 `if' `in'
		sort `touse' `by'
		by `touse' `by': gen `typlist' `varlist' = /*
			*/ sum(`exp')/sum((`exp')<.) if `touse'==1
		by `touse' `by': replace `varlist' = `varlist'[_N]
	}
end
