*! version 2.1.2  01oct2004
program define _gstd
	version 6, missing
	syntax newvarname =/exp [if] [in] [, Mean(real 0) Std(real 1) /*
			*/ BY(string)]
	if `"`by'"' != "" {
		_egennoby std() `"`by'"'
		/* NOTREACHED */
	}


	quietly {
		gen `typlist' `varlist' = `exp' `in' `if'
		sum `varlist' `if' `in'
		replace `varlist' = /*
			 */ ((`varlist'-r(mean))/sqrt(r(Var)))*(`std') /*
			 */ + (`mean') 
		label var `varlist' "Standardized values of `exp'"
	}
end
