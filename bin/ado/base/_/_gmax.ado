*! version 3.1.2  20oct2004
program define _gmax
	version 6, missing
	syntax newvarname(gen) =/exp [if] [in] [, BY(varlist)]

	tempvar touse x
	quietly {
		gen byte `touse'=1 `if' `in'
		gen double `x'=`exp' 
		sort `touse' `by' `x'
		by `touse' `by': replace `varlist'=/*
			*/ cond(`x'<., `x', `varlist'[_n-1]) if `touse'==1
		by `touse' `by': replace `varlist'=`varlist'[_N]
	}
end
