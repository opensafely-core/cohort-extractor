*! version 1.0.0  06oct2015
program define _multirecordcheck, sortpreserve 
	version 14

	local id : char _dta[st_id]
	if (`"`id'"' == "") exit
	
	local check 0
	cap confirm matrix e(at)
	if !c(rc) { 
		tempname at
		matrix `at' = e(at)
		if matmissing(`at') local check 1
	}
	
	if (`"`at'"' == "" | `check'==1) {
		tempvar count
		bysort `touse' `id':generate `count' = _n
		summarize `count' if e(sample), meanonly
		if (r(mean) > 1) {
di in smcl "{p 0 9}{help j_multipredictwarn##|_new:Warning: Multiple }" ///
"{help j_multipredictwarn##|_new:observations per subject are detected.  }" ///
"{help j_multipredictwarn##|_new:Predictions that require averaging over }" ///
"{help j_multipredictwarn##|_new:the dataset may not be appropriate.  }" ///
"{help j_multipredictwarn##|_new:Use the {bf:at()} option to compute }" ///
"{help j_multipredictwarn##|_new:predictions at fixed values of the }" ///
"{help j_multipredictwarn##|_new:covariates.}{p_end}"
		}
		
	}
end
