*! version 1.1.4  16sep2004
program define bitest, rclass byable(recall)
	version 6.0, missing
	_parsewt fweight `0'
	local wt `"`s(weight)'"'
	local 0 `"`s(newcmd)'"'

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname =/exp [if] [in] [, Detail]

	tempvar touse
	mark `touse' `wt' `if' `in'
	markout `touse' `varlist'

	capture assert `varlist'==0 | `varlist'==1 if `touse'
	if _rc { 
		di in red "`varlist' is not a 0/1 variable"
		exit 450
	}

	quietly summ `varlist' `wt' if `touse'
	bitesti `r(N)' `r(sum)' `exp', xname(`varlist') `detail'
	return add
end
