*! version 1.0.1  09feb2015
*  sorting routine for exlogistic/expoisson

program _exactreg_sort, rclass
	syntax [varlist(default=none)], [ group(varname) weight(varname) ]

	if "`varlist'" != "" {
		local N01 = 0
		foreach x of varlist `varlist' {
			if float(`x')==1 | float(`x')==0 {
				if "`weight'" != "" {
					tempvar w`x'
					qui gen long `w`x'' = `x'*`weight'
				}
				else local w`x' `x'

				summarize `w`x'', meanonly
				if r(sum) > `N01' {
					local sortvar01 -`w`x'' `sortvar01' 
					local condvars01 `x' `condvars01'
					local N01 = r(N)
				}
				else {
					local sortvar01 `sortvar01' -`w`x''
					local condvars01 `condvars01' `x'
				}
			}
			else {
				if "`weight'" != "" {
					tempvar w`x'
					qui gen float `w`x'' = `x'*`weight'
				}
				else local w`x' `x'

				cap assert `x' <= 0 
				if _rc == 0 {
					local sortvar `sortvar' + `w`x''
					local condvars `condvars' `x'
				}
				else {
					local sortvar `sortvar' - `w`x''
					local condvars `condvars' `x'
				}
			}
		}
		local sortvar `sortvar01' `sortvar'
		local condvars `condvars01' `condvars'
	}
	if ("`weight'"!="") local sortvar `sortvar' +`weight' 

	if "`group'" != "" { 
		if "`sortvar'" != "" {
			/* make it a stable sort	*/
			tempvar i 
			qui gen `c(obs_t)' `i' = _n 
			gsort + `group' `sortvar' +`i'
		}
		else sort `group', stable
	}
	else if ("`sortvar'"!="")  {
		/* make it a stable sort		*/
		tempvar i 
		qui gen `c(obs_t)' `i' = _n 
		gsort `sortvar' +`i'
	}

	return local condvars `condvars'
end

exit
