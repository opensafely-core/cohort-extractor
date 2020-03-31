*! version 1.2.0  10apr2013
program ivregress_prolog, eclass
	version 10
        local version : di "version " string(_caller()) ":"

	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)
	mat `V' = `V' / (e(rmse)^2)
	
	local endog `e(instd)'
	local n_endog : list sizeof endog

	local exog `e(exogr)'
	if `"`e(constant)'"' != "noconstant" {
		local exog `exog' _cons
	}

	local namestripe
	forvalues i = 1/`n_endog' {
		local namestripe `namestripe' eq`i':_cons
	}
	local j = `=`n_endog' + 1'
	foreach var of local exog {
		local namestripe `namestripe' eq`j':`var'
	}

	`version' mat coleq `b' = `namestripe'
	`version' mat coleq `V' = `namestripe'
	`version' mat roweq `V' = `namestripe'

	local wgt "[`e(wtype)'`e(wexp)']"
	ereturn repost b=`b' V=`V' `wgt', rename
	
end

