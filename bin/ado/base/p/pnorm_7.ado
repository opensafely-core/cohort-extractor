*! version 2.1.7  24sep2004
program define pnorm_7, sort
	version 6, missing
	syntax varname [if] [in] [, /*
		*/ Symbol(string) noBorder Connect(string) /*
		*/ YLAbel(string) XLAbel(string) Grid * ]
	if "`symbol'"=="" { local symbol "oi" } 
	else { local symbol "`symbol'i" }
	if "`connect'"=="" { local connect ".l" }
	else { local connect "`connect'l" }
	if "`ylabel'"=="" { local ylabel "0,.25,.5,.75,1" }
	if "`xlabel'"=="" { local xlabel "0,.25,.5,.75,1" }
	if "`grid'"!="" {
		local options "`options' yline(.25,.5,.75) xline(.25,.5,.75)"
	}
	tempvar touse F Psubi
	quietly { 
		gen byte `touse' = cond(`varlist'>=.,.,1) `if' `in'
		sort `varlist' 
		sum `varlist' if `touse'==1
		gen float `F' = normprob((`varlist'-r(mean)) /* 
			*/ /sqrt(r(Var))) if `touse'==1
		gen float `Psubi' = sum(`touse')
		replace `Psubi' = cond(`F'>=.,.,`Psubi'/(`Psubi'[_N]+1))
	}
	label var `F' "Normal F[(`varlist'-m)/s]"
	label var `Psubi' "Empirical P[i] = i/(N+1)"
	format `F' `Psubi' %9.2f
	if "`border'"=="" { local b "border" }
	gr7 `F' `Psubi' `Psubi', c(`connect') s(`symbol') /*
		*/ ylab(`ylabel') xlab(`xlabel') `b' `options'
end
