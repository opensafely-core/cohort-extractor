*! version 3.1.1  01oct2004
program define _giqr
	version 6, missing
	syntax newvarname =/exp [if] [in] [, *]
	tempvar p75 p25 touse
	mark `touse' `if' `in'
	quietly { 
		egen double `p25'=pctile(`exp') if `touse', `options' p(25)
		egen double `p75'=pctile(`exp') if `touse', `options' p(75)
		gen `typlist' `varlist' = `p75'-`p25' if `touse'
	}
end
