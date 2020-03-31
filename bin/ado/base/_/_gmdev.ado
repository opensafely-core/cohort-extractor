*! Version 1.2.1  01oct2004
* Based on 1.0.1 NJC 29 January 1999 STB-50 dm70
program define _gmdev
	version 6.0, missing
	syntax newvarname = /exp [if] [in] [, BY(varlist)]
	tempvar mean mdev
	marksample touse, novarlist
	quietly {
		sort `touse' `by'
		by `touse' `by': gen double `mean' = /*
			*/ sum(`exp')/sum((`exp')<.) if `touse'
		by `touse' `by': replace `mean' = `mean'[_N]
		gen double `mdev' = abs(`exp' - `mean') if `touse'
		by `touse' `by': replace `mdev' = /*
			*/ sum(`mdev')/sum((`mdev')<.) if `touse'
		by `touse' `by': replace `mdev' = `mdev'[_N]
		gen `typlist' `varlist'= `mdev'
	}
end
