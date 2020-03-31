*! version 1.0.0  01dec2014
/* special handling of teffects and stteffects ATE & ATT contrast style	*/
/*  equation								*/

program define _teffects_estat_summarize, eclass
	version 14.0
	syntax [ varlist(numeric fv default=none) ] , [ * ]

	tempname b b0 V V0

	mat `b' = e(b)
	mat `V' = e(V)
	local names : colnames `b'

	local tlevels `e(tlevels)'
	local control = e(control)
	local tlevnoc : list tlevels - control

	forvalues i=1/`=e(k_levels)-1' {
		local nm : word `i' of `names'
		local lev : word `i' of `tlevnoc'
		gettoken r var: nm, parse(".")

		local names : subinstr local names "`r'" "`lev'" 
	}
	local names : subinstr local names "r`control'" "`control'" 
	mat `b0' = `b'
	mat `V0' = `V'

	mat colnames `b' = `names'
	mat colnames `V' = `names'
	mat rownames `V' = `names'
	nobreak {
		ereturn repost b=`b' V=`V', rename

		estat_default summarize `varlist', `options'

		ereturn repost b=`b0' V=`V0', rename
	}
end

exit
