*! version 1.0.0  28aug2008
program define _growmedian
	version 11
	gettoken type 0 : 0
	gettoken h    0 : 0 
	gettoken eqs  0 : 0

	syntax varlist(min=1) [if] [in] [, BY(string)]

	//function may not be combined with by
	if `"`by'"' != "" {
		_egennoby rowmedian() `"`by'"'
		/* NOTREACHED */
	}
	//string variables not allowed
	foreach var of local varlist {
		capture confirm numeric variable `var'
		if (_rc) {
			di as err ///
			"string variable `var' not allowed"
			exit 109
		}
	}
//rowmedian() is the special case of rowpctile() with p = 50
	local p = 50
	tempvar touse
	qui mark `touse' `if' `in'
	tempvar med
	qui gen `type' `med' = .
	mata: _pcrow("`varlist'", "`touse'", "`med'","`p'")
	
	qui gen `type' `h' =`med' 
end
exit

