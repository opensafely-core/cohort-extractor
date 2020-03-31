*! version 1.0.0  21feb2019
program _ms_varnames, sclass
	syntax [anything]

	foreach x of local anything {

		_ms_parse_parts `x'
		
		if (`r(omit)') {
			continue
		} 
		
		if (inlist("`r(type)'", "factor", "interaction")) {
			
			if ("`r(k_names)'" == "") {
				local fvars `fvars' `r(name)'
			}
			else {
				forvalues i = 1/`r(k_names)' {
					if ("`r(op`i')'" != "c") {
						local fvars `fvars' `r(name`i')'
					}
					else {
						local cvars `cvars' `r(name`i')'
					}
				}
			}
		}
		else {
			local cvars `cvars' `x'
		}
	}
	
	local fvars : list uniq fvars
	local cvars : list uniq cvars
	
	sreturn local fvars `fvars'
	sreturn local cvars `cvars'
end

