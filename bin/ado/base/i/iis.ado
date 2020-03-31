*! version 1.2.0  06mar2007
program define iis /* varname */
	version 6
	syntax [varname(default=none numeric)] [, CLEAR]
	if "`varlist'" == "" {
		if "`clear'" != "" { 
			char _dta[iis]
			char _dta[_TSpanel]
			exit
		}
		local ivar : char _dta[iis]
		if `"`ivar'"'!="" {
			di in gr `"i() is `ivar'"'
		}
		else	di in gr "(i() has not been defined)"
		exit
	}
	if "`_dta[iis]'" == "`varlist'" { 
		exit 
	}
	char _dta[_TStvar]
	char _dta[_TSpanel]
	char _dta[_TSdelta]
	char _dta[_TSitrvl]
	char _dta[iis] `varlist'
end
