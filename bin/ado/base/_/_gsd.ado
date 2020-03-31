*! version 3.1.1  01oct2004
program define _gsd
	version 6, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]
	tempvar touse mean
	quietly {
		gen byte `touse'=1 `if' `in'
		sort `touse' `by'
		by `touse' `by': gen double `mean' = /*
			*/ sum(`exp')/sum((`exp')<.) if `touse'==1
		by `touse' `by': gen `typlist' `varlist' = /*
		*/ sqrt(sum(((`exp')-`mean'[_N])^2)/(sum((`exp')<.)-1)) /*
		*/ if `touse'==1 & sum(`exp'<.)
		by `touse' `by': replace `varlist' = `varlist'[_N]
	}
end
