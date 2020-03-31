*! version 3.0.3  23may2006
program define _gmedian
	version 6, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]
	tempvar touse x n
	quietly {
		gen byte `touse'=1 `if' `in'
		gen double `x' = `exp'
		sort `touse' `by' `x'
		by `touse' `by': gen long `n'=sum(`x'<.)
		by `touse' `by': g `varlist' = ( /*
		*/ `x'[(`n'[_N]+1)/2] + /*
		*/ `x'[(`n'[_N]+2)/2] ) / 2 if `touse'==1
	}
end

