*! version 1.2.0  10apr2013
program ivregress_epilog, eclass
	version 10
        local version : di "version " string(_caller()) ":"

	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)

	local vars `e(instd)' `e(exogr)'
	if `"`e(constant)'"' != "noconstant" {
		local vars `vars' _cons
	}

	`version' mat coleq `b' = _:		// Clear out equation names
	`version' mat coleq `V' = _:
	`version' mat roweq `V' = _:

	`version' mat colnames `b' = `vars'
	`version' mat colnames `V' = `vars'
	`version' mat rownames `V' = `vars'
	
	local wgt "[`e(wtype)'`e(wexp)']"
	ereturn repost b=`b' V=`V' `wgt', rename

	global epilog_called "Yes"
	
end

