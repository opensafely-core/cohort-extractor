*! version 1.0.0  07jun2019
program lasso_est_expand, rclass
	version 16.0

	syntax [, lasso_list(string) ]

	if (`"`lasso_list'"' == "") {
		exit 
		// NotReached
	}

	_parse expand sub tmp : lasso_list

	forvalues i=1/`sub_n' {
		_lasso_est_for `sub_`i''	
		
		if (`"`r(cmd)'"' != "") {
			di as err "syntax {bf:({it:name}, for() "	///
				"[xfold() resample()])} not allowed after " ///
				"{bf:`r(cmd)'}"
			exit 198
		}

		local names `names' `r(name)'
		local subspace_list `subspace_list' `r(subspace)'
	}

	ret local lasso_names `names'
	ret local lasso_subspace `subspace_list'
end
