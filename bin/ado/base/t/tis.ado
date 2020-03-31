*! version 1.2.0  06mar2007
program define tis
	version 6
	syntax [varname(default=none numeric)] [, CLEAR]
	if "`varlist'" == "" {
		if "`clear'" != "" { 
			char _dta[tis]
			char _dta[_TSpanel]
			char _dta[_TSdelta]
			exit
		}
		local tvar : char _dta[tis]
		if `"`tvar'"'!="" {
			di in gr `"t() is `tvar'"'
		}
		else	di in gr "(t() has not been defined)"
		exit
	}
	if "`_dta[tis]'" == "`varlist'" { 
		exit 
	}

	char _dta[_TStvar]
	char _dta[_TSpanel]
	char _dta[_TSdelta]
	char _dta[_TSitrvl]
	char _dta[tis] `varlist'
end
