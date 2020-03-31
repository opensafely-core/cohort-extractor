*! version 7.0.2  01oct2004
program define _gpc
version 6.0, missing
	syntax newvarname =/exp [if] [in] [, prop BY(varlist)]
	marksample touse, novarlist
     	quietly {
		local x = 100
		if "`prop'" != "" { 
			local x = 1
		} 
		sort `touse' `by'
		by `touse' `by': gen `typelist' `varlist' =sum(`exp') if `touse'
		by `touse' `by': replace `varlist' = `x' * `exp'/`varlist'[_N]
	}
end
