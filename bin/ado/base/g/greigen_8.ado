*! version 2.4.0  28jan2004
program define greigen_8
	version 6
	if _caller() < 8 {
		greigen_7 `0'
		exit
	}

	syntax [, * ] //

	_get_gropts , graphopts(`options') getallowed(plot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'

	local num = min(_N,13)
	tempvar eigen number
	quietly gen float `eigen' = .
	quietly factor
	local i 1
	while `i' <= `num' {
		local lamx = "lambda`i'"
		quietly replace `eigen' = r(`lamx') in `i'
		local i = `i' + 1
	}
	quietly gen byte `number' = _n if !missing(`eigen')
	label var `number' "Number"
	local xttl : var label `number'
	label var `eigen' "Eigenvalues"
	local yttl : var label `eigen'
	version 8: graph twoway			///
	(connected `eigen' `number',		///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`options'			///
	)					///
	|| `plot'				///
	// blank
end
