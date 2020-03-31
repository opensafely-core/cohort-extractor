*! version 1.1.0  07mar2019
program define _svar_eqmac, rclass
	local version = string(_caller())
	version 8.0

	syntax , mat(string) name(string) neqs(integer) 

	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			local el = `mat'[`i',`j']

			if missing(`el') {
				continue
			}
			if `version' < 16 {
				local cns "[`name'_`i'_`j']_cons = `el'"
			}
			else {
				local cns "[/`name']`i'_`j' = `el'"
			}
			local cnsmac `"`cnsmac'`c'`cns'"'
			local c ":"
		}
	}
	return local cnsmac "`cnsmac'"
end
