*! version 1.0.6  28sep2004
program define qchi_7, sort
	version 6, missing
	syntax varname [if] [in] [, /*
		*/ DF(real 1) Symbol(string) Connect(string) Grid * ]
	marksample doit

	if `df' <= 0 {
		di in red "df() must be greater than zero"
		error 499
	}
	if "`symbol'"=="" { local symbol "oi" } 
	else local symbol "`symbol'i"
	if "`connect'"=="" { local connect ".l" }
	else local connect "`connect'l"
	tempvar echi
	qui count if `doit'
	sort `varlist' 
	qui gen `echi' = 2*invgammap(`df'/2, sum(`doit')/(r(N) + 1)) /*
	*/	if `doit'
	label var `echi' "Expected Chi-Squared d.f. = `df'"
	local fmt : format `varlist'
	format `echi' `fmt'
	if "`grid'"~="" {
		qui summ `varlist' if `doit', detail
		#delimit ;
		local ylab = string(r(p5)) + ","
	 	  + string(r(p50)) + "," + string(r(p95)) ;
		local ylin = "`ylab'" + "," + string(r(p10))
		  + "," + string(r(p25)) + ","
		  + string(r(p75)) + "," + string(r(p90)) ;
		local sic "string(2*invgammap(`df'/2," ;
		local xlab = `sic'0.05)) + "," + `sic'0.5)) + ","
		  + `sic'0.95)) ;
		local xlin = "`xlab'" + "," + `sic'0.10)) + "," 
		  + `sic'0.25)) + "," + `sic'0.75)) + "," + `sic'0.90)) ;
		local grid "ylin(`ylin') rtic(`ylab') rlab(`ylab')
			    xlin(`xlin') ttic(`xlab') tlab(`xlab') t2(" ")
	t1("(Grid lines are 5, 10, 25, 50, 75, 90, and 95 percentiles)")" ;
	} ;
	gr7 `varlist' `echi' `echi' if `doit', c(`connect') s(`symbol')
		`grid' `options' ;
end ;
