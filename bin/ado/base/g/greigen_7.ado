*! version 2.2.2  09jan1999
program define greigen_7
	version 6
	syntax [, Connect(string) YLAbel(string) XLAbel(string) * ]
	local num = min(_N,13)
	tempvar eigen number
	quietly gen byte `number' = _n in 1/`num'
	quietly gen float `eigen' = .
	quietly factor
	local i 1
	while `i' <= `num' {
		local lamx = "lambda`i'"
		quietly replace `eigen' = r(`lamx') in `i'
		local i = `i' + 1
	}
	label var `number' "Number"
	label var `eigen' "Eigenvalues"
	if "`connect'"=="" { local connect "connect(l)" }
	else local connect "connect(`connect')" 
	if "`ylabel'"=="" { local ylabel "ylabel" }
	else local ylabel "ylabel(`ylabel')"
	if "`xlabel'"=="" { local xlabel "xlabel" }
	else local xlabel "xlabel(`xlabel')"
	gr7 `eigen' `number', `ylabel' `xlabel' `connect' `options'
end
