*! version 1.2.3  09feb2015
program define _gskew
	version 6.0, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]        
	quietly {
		tempvar touse group
		mark `touse' `if' `in'
		sort `touse' `by'
		by `touse' `by' : gen `c(obs_t)' `group' = _n == 1 if `touse'
		replace `group' = sum(`group')
		local max = `group'[_N]
		gen `typlist' `varlist' = .
		local i 1
		while `i' <= `max' {
			su `exp' if `group' == `i', detail
			replace `varlist' = r(skewness) if `group' == `i'
			local i = `i' + 1
		}
	}
end
