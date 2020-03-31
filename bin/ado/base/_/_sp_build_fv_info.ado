*! version 1.0.0  30mar2017
program _sp_build_fv_info, sclass
	syntax , xvars(string)		///
		fv_info(string)

	_fv_term_info `xvars'
	local k = r(k_terms)
	local xvars `r(varlist)'
	
	forvalues i=1/`k' {
		if (`"`r(type`i')'"' == "variable") {
			matrix `fv_info' = (nullmat(`fv_info') \ 0, 0, 0, 0)
		}
		else if (`"`r(type`i')'"' == "factor") {
			matrix level = r(level`i')
			local base_index = r(base`i')	
			local rr : rowsof(level)
			forvalues j=1/`rr' { 
				local level_j = level[`j',1]	
				local base = level[`base_index', 1]
	
				if (`level_j' == `base') {
					local isbase = 1
				}
				else {
					local isbase = 0
				}
	
				matrix `fv_info' = 		///
					(nullmat(`fv_info') 	///
					\ 1, `isbase', `level_j', `base') 
			}
		}
	}
	matrix colnames `fv_info' = fv isbase level base
	matrix rownames `fv_info' = `xvars'
	sret local xvars `xvars'
end
