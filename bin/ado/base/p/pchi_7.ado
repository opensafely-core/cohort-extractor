*! version 1.0.5  23sep2004
program define pchi_7
	version 6, missing
	syntax varname [if] [in] [, /*
		*/ DF(real 1) Symbol(string) Connect(string) /*
		*/ YLAbel(string) XLAbel(string) Grid noBORder * ]
	marksample doit

	if "`symbol'"=="" { local symbol "oi" } 
	else local symbol "`symbol'i"

	if "`connect'"=="" { local connect ".l" }
	else local connect "`connect'l"

	if "`ylabel'"=="" { local ylabel "0,.25,.5,.75,1" }
	if "`xlabel'"=="" { local xlabel "0,.25,.5,.75,1" }

	if "`grid'"~="" { local grid "yline(.25,.5,.75) xline(.25,.5,.75)" }
	if "`border'"=="" { local b "border" }

        tempvar chip p
        sort `varlist'
	qui gen `chip' = 1 - chiprob(`df', `varlist') if `doit'
	qui count if `doit'
	qui gen `p' = sum(`doit')/(r(N) + 1) if `doit'
	label var `chip' "Chi-Squared(`varlist') d.f. = `df'"
	label var `p' "Empirical P[i] = i/(N+1)"
	format `chip' `p' %9.2f
	gr7 `chip' `p' `p' if `doit', c(`connect') s(`symbol') /*
	*/	ylab(`ylabel') xlab(`xlabel') `grid' `b' `options'
end
