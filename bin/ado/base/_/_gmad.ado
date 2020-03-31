*! Version 1.1.1  01oct2004
* based on 1.0.1 NJC 29 January 1999 STB-50 dm70
program define _gmad
	version 6.0, missing
	syntax newvarname = /exp [if] [in] [, BY(varlist)]
	tempvar med mad n x touse
	marksample touse, novarlist
	quietly {
		gen `x' = `exp'
		sort `touse' `by' `x'
		by `touse' `by': gen long `n' = sum(`x'<.)
		by `touse' `by': gen double `med' = (`x'[(`n'[_N]+1)/2]  /*
			*/ + `x'[(`n'[_N]+2)/2] ) / 2 if `touse'
		replace `x' = abs(`exp' - `med')
		sort `touse' `by' `x'
		by `touse' `by': replace `n' = sum(`x'<.)
		sort  `touse' `by' `n'
		by `touse' `by': gen double `mad' = (`x'[(`n'[_N]+1)/2]  /*
			*/ + `x'[(`n'[_N]+2)/2] ) / 2 if `touse'
		gen `typlist' `varlist' = `mad'
	}
end
