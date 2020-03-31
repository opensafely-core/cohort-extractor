*! version 1.1.8  30sep2004
program define xttrans, rclass byable(recall) sort
	version 6, missing
	syntax varname [if] [in] [, Freq I(varname) T(varname) ]
	xt_iis `i'
	local ivar "`s(ivar)'"

	xt_tis `t'
	local tvar "`s(timevar)'"

	if "`freq'"!="" {
		local opts "row freq"
	}
	else	local opts "row nofreq"

	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `varlist' `ivar' `tvar'

	tempvar was is
	quietly { 
		sort `ivar' `tvar' 
		by `ivar': gen float `was' = `varlist' if _n<_N
		by `ivar': gen float `is'  = `varlist'[_n+1] if _n<_N
		local lbl : var label `varlist'
		if "`lbl'"=="" { 
			local lbl "`varlist'"
		}
		label var `was' "`lbl'"  
		label var `is' "`lbl'"
		by `ivar': replace `touse'=0 if `touse'[_n+1]==0 & _n<_N
	}
	tabulate `was' `is' if `touse', `opts' nokey
	ret add
end
exit
