*! version 1.0.0  04oct2004
program define _ganycount
	version 6.0, missing
	gettoken type 0 : 0
	gettoken g 0 : 0
	gettoken eqs 0 : 0
	syntax varlist(min=1 numeric) [if] [in], Values(numlist int) /*
	*/ [BY(string)]
        if `"`by'"' != "" {
                _egennoby anycount() `"`by'"'
                /* NOTREACHED */
        }

	tempvar touse 
	mark `touse' `if' `in' 
	tokenize `varlist'
	local nvars : word count `varlist'
	local nnum : word count `values'

	quietly {
		gen byte `g' = 0  /* ignore user-supplied `type' */
		forval i = 1 / `nvars' {
			forval j = 1 / `nnum' {
				local nj : word `j' of `values'
				replace `g' = `g' + 1 /*
					*/ if ``i'' == `nj' & `touse'
			}
		}
	}
        if length("`varlist'") >= 69 {
                note `g' : `varlist' == `values'
                label var `g' "see notes"
        }
	else if length("`varlist' == `values'") > 80 {
		note `g' : `varlist' == `values'
		label var `g' "`varlist': see notes"
	}
	else label var `g' "`varlist' == `values'"
end
