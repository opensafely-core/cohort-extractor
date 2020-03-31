*! version 1.0.0  28aug2008
program define _growpctile
	version 11
	gettoken type 0 : 0
	gettoken h    0 : 0 
	gettoken eqs  0 : 0

	syntax varlist(min=1) [if] [in] [, p(real 50) BY(string)]
	//percentile is valid
	 if `p'<=0 | `p'>=100 {
                di in red "p(`p') must be between 0 and 100"
                exit 198
        }
	//function may not be combined with by
	if `"`by'"' != "" {
		_egennoby rowpctile() `"`by'"'
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
	
	tempvar touse
	qui mark `touse' `if' `in'
	tempvar pc
	qui gen `type' `pc' = .
	mata: _pcrow("`varlist'", "`touse'", "`pc'", "`p'")
	
	qui gen `type' `h' =`pc' 
end
exit
