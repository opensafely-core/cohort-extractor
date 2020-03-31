*! version 1.0.0  04oct2004
program define _growlast
	version 6, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0 

	syntax varlist [if] [in] [, BY(string)]
	if `"`by'"' != "" {
		_egennoby rowlast() `"`by'"'
		/* NOTREACHED */
	}



	quietly { 
		tokenize `varlist'
		gen `type' `g' = `1' `if' `in'
		mac shift
		while "`1'"!="" {
			replace `g' = cond(missing(`1'),`g',`1') `if' `in'
			mac shift 
		}
	}
end
