*! version 7.0.1  01oct2004
program define _gtag
	version 6, missing
	gettoken type 0 : 0 /* type will be ignored: byte more efficient */
	gettoken g 0 : 0
	gettoken eqs 0 : 0

	syntax varlist [if] [in] [, Missing BY(string)]
        if `"`by'"' != "" {
                _egennoby tag() `"`by'"'
        }
	marksample touse, novarlist
	quietly {
		if "`missing'" == "" {
			tokenize `varlist'
			while "`1'" != "" {
				replace `touse' = . if missing(`1')
				mac shift
			}
		}
		tempvar n
		gen `n' = _n
		sort `touse' `varlist' `n'
		by `touse' `varlist': gen byte `g' = _n == 1 & `touse' == 1
	}

	if length("tag(`varlist')") > 80 { 
		note `g' : tag(`varlist') 
		label var `g' "tag: see notes"
	} 	
	else {
		label var `g' "tag(`varlist')"
	}

	label var `g' "tag(`varlist')"
end

/*

note: to permit idioms such as -if tag- it is important that the result be 1 or 0,
and never missing

*/
