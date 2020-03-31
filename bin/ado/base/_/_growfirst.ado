*! version 1.0.0  04oct2004
program define _growfirst
	version 6, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0 

	syntax varlist [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowfirst() `"`by'"'
		/* NOTREACHED */
	}


	quietly {
		local varn : word count `varlist'
		tokenize `varlist'
		gen `type' `g' = ``varn'' `if' `in'
		local i = `varn' - 1
		while `i'>0 {
			replace `g' = cond(missing(``i''),`g',``i'') `if' `in'
			local i = `i' - 1
		}
	}
end
