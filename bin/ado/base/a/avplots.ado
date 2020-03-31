*! version 2.4.1  08jun2009
program define avplots
	version 6.0
	if _caller() < 8 {
		avplots_7 `0'
		exit
	}
	local vv : display "version " string(_caller()) ":"

	_isfit cons newanovaok
	syntax [, * ]

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

	_getrhs rhs
	tokenize `rhs'

	while "`1'"!="" { 
		tempname tname
		local base `names'
		local names `names' `tname'
		capture `vv' avplot `1', name(`tname') nodraw `options'
		if _rc { 
			if _rc!=399 {
				exit _rc
			} 
			local names `base'
		}
		mac shift 
	}

	version 8: graph combine `names' , `gcopts'
	version 8: graph drop `names'
end
