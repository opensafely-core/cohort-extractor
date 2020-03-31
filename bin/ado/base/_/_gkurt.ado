*! version 1.2.3  09feb2015
program define _gkurt
	version 6.0, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist)]        
	quietly {
		tempvar touse group
		mark `touse' `if' `in'
		sort `touse' `by'
		by `touse' `by' : gen `c(obs_t)' `group' = _n == 1 if `touse'
		replace `group' = sum(`group')
		local max = `group'[_N]
		local i 1
		gen `typlist' `varlist' = .
		while `i' <= `max' {
			su `exp' if `group' == `i', detail
			replace `varlist' = r(kurtosis) if `group' == `i'
			local i = `i' + 1
		}
	}
end
