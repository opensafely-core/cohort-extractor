*! version 1.1.1  26mar2019
program define _svar_cnsmac, rclass
	local version = string(_caller())
	version 8.0

	syntax , mat(string) name(string) neqs(integer) 

	tempname el
	local k 0
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			scalar `el' = `mat'[`i',`j']
			if `el' != int(`el') {
				di as err "non-integer element in "/* 
					*/ "matrix defining constraints /*
					*/ "on `name'"
				exit 198	
			}	

			if missing(`el') {
				continue
			}
			if `el' == 0 {
				if `version' < 16 {
					local cns "[`name'_`i'_`j']_cons = 0"
				}
				else {
					local cns "[/`name']`i'_`j' = 0"
				}
				local cnsmac `"`cnsmac'`c'`cns'"'
				local c ":"
			}
			else {
				local already 0				
				forvalues m = 1/`k' {
					if ``m'' != `el' {
						continue
					}
					local already 1
					if `version' < 16 {
						local nm "`name'_`i'_`j'"
					}
					else {
						local nm "[/`name']`i'_`j'"
					}
					local `m'c `"``m'c' `nm'"'
				}
				if `already' == 0 {
					local ++k
					local `k' = `el'
					if `version' < 16 {
						local `k'c "`name'_`i'_`j'"
					}
					else {
						local `k'c "[/`name']`i'_`j'"
					}
				}
			}
		}
	}

	forvalue m = 1/`k' {
		local cns : word count ``m'c'
		if `cns' < 1 {
			di as err "_svar_cnsmac is broken"
			exit 498
		}	
		if `cns' == 1 {
			di as err "`mc'c' is not constrained to be " /*
				*/ "equal to another element"
			exit 498
		}	
		local left "``m'c'"
		gettoken cur left:left
		local first "`cur'"
		forvalues n = 2/`cns' {
			gettoken cur left:left
			if `version' < 16 {
				local contr "[`first']_cons = [`cur']_cons"
			}
			else {
				local contr "`first' = `cur'"
			}
			local cnsmac `"`cnsmac'`c'`contr'"'
		}	
	}
	return local cnsmac `"`cnsmac'"'
end
