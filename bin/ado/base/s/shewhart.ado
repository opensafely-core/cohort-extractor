*! version 2.3.2  25dec2007
program define shewhart, rclass  
	version 6, missing
	if _caller() < 8 {
		shewhart_7 `0'
		exit
	}
	local vv : display "version " string(_caller()) ", missing:"

	// the legacy option -batch- is undocumented
	syntax varlist(min=2) [if] [in] [, BATCH noGRaph * ]

	_get_gropts , graphopts(`options') getcombine getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local gcopts `"`s(combineopts)'"'
	if `"`s(plot)'"' != "" {
		di in red "option plot() not allowed"
		exit 198
	}
	if `"`s(addplot)'"' != "" {
		di in red "option addplot() not allowed"
		exit 198
	}	

	tempname shew1 shew2

	`vv' xchart `varlist' `if' `in',	///
		name(`"`shew1'"') nodraw `options'
	return add
	`vv' rchart `varlist' `if' `in',	///
		name(`"`shew2'"') nodraw `options'
	return scalar lcl_r = r(lcl_r)
	return scalar ucl_r = r(ucl_r)
	return scalar out_r = r(out_r)
	return scalar below_r = r(below_r)
	return scalar above_r = r(above_r)
	return scalar central_line = r(central_line)
	// xchart goes above the rchart
	if "`graph'" == "" {
		version 8: graph combine `shew1' `shew2', cols(1) `gcopts'
		version 8: graph drop `shew1' `shew2'
	}
end

