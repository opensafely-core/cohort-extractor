*! version 1.0.0  04oct2004
program define _grownonmiss
	version 6, missing

	gettoken type 0 : 0 
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist [if] [in] [, Strok BY(string) ]
	if `"`by'"' != "" {
		_egennoby rownonmiss() `"`by'"'
		/* NOTREACHED */
	}

	quietly { 
		tokenize `varlist'
		if "`strok'"=="" {
			gen `type' `g' = (`1'<.) `if' `in'
			mac shift
			while "`1'"!="" {
				replace `g' = `g' + (`1'<.) `if' `in'
				mac shift 
			}
		}
		else {
			gen `type' `g' = !missing(`1') `if' `in'
			mac shift
			while "`1'"!="" {
				replace `g' = `g' + !missing(`1') `if' `in'
				mac shift 
			}
		}
	}
end
