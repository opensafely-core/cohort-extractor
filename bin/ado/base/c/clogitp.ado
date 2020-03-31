*! version 3.0.6  19dec1998
program define clogitp
	version 6.0
	if `"`e(cmd)'"'!=`"clogit"' { error 301 } 
	syntax newvarname [if] [in] [, GRoup(string) Strata(string) ]

	tempvar touse idx denom

	if `"`group'"'==`""' & `"`strata'"'==`""' {
		di in red `"group() required"'
		exit 198
	}
	if `"`group'"'==`""' {
		local group `"`strata'"'
	}
	confirm variable `group'

/* Mark/markout. */

	mark `touse' `if' `in'
	markout `touse' `group', strok	
	capture confirm variable `e(depvar)'
	if _rc { 
		di in bl `"note: `e(depvar)' not found; not checked "' /*
		*/ `"for missing values"'
	}
	else 	markout `touse' `e(depvar)'

	quietly {
		sort `group'
		_predict double `idx' if `touse'
		by `group': gen double `denom' = sum(exp(`idx'))
		by `group': gen `typlist' `varlist' = exp(`idx')/`denom'[_N]
	}
end
