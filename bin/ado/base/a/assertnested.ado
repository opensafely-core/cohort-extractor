*! version 1.0.0  05may2019
program assertnested, sortpreserve byable(recall, noheader)
	version 16
	
	syntax varlist [if] [in] [, WITHIN(varlist) MISSing ]
	
	if ("`missing'" == "") {
		marksample touse, strok
		markout `touse' `within', strok
	}
	else {
		marksample touse, novarlist
	}
	
	qui count if `touse'
	
	if (r(N) == 0) {
		di as txt "(null assertion)"
		exit
	}
	
	gettoken var1 varlist : varlist

	if ("`within'" != "") {
		foreach wvar of local within {
			NestedOne `touse' `wvar' `var1' 
		}
	}
	
	foreach var of local varlist {
		NestedOne `touse' `var1' `var' 
		local var1 `var'
	}
end
		
program NestedOne
	args touse outvar invar
	
	// invar is nested inside of outvar
	// iff outvar is constant within invar. 
		
	tempvar v

	qui gen `:type `outvar'' `v' = `outvar' if `touse'

	// Lag down first touse value of var,
	// then compare to other values.

	qui bysort `invar': replace `v' = ///
		cond(missing(`v'[_n - 1]) & `touse', `v', `v'[_n - 1])

	cap by `invar': assert `outvar' == `v'[_N] if `touse', fast
	if (c(rc) == 9) {

di as error "{p}{bf:`invar'} not nested within {bf:`outvar'}{p_end}"
			
		exit 459
	}
	
	error c(rc)
end

