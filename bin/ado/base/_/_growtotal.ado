*! version 1.0.2  22jul2008
program define _growtotal
	version 6, missing

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist [if] [in] [, BY(string) Missing]
	version 7.0, missing
	local si $EGEN_SVarname
	version 6.0, missing
	local varlist : list varlist - si
	if `"`by'"' != "" {
		_egennoby rowtotal() `"`by'"'
		/* NOTREACHED */
	}
	quietly { 
		tokenize `varlist'
		if "`missing'" == "" {
			gen `type' `g' = cond(`1'>=.,0,`1') `if' `in'
			mac shift 
			while "`1'"!="" {
				replace `g'=`g'+cond(`1'>=.,0,`1') `if' `in'
				mac shift 
			}
		}
		else {
			gen `type' `g' = cond(`1'>=.,.,`1') `if' `in'
                	mac shift 
                	while "`1'"!="" {
                        	replace `g' = cond(`g'==., ///
				  cond(`1'>=.,.,`1'), cond(`1'>=., ///
				  `g', `g' + `1')) `if' `in'
				mac shift 
                	}
		}
	}
end
