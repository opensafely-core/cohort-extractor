*! version 1.0.1  26apr2019
					//----------------------------//
					// add new subspace name
					//----------------------------//
program _lasso_add_subspace, sclass
	version 16.0

	syntax , [opt(string)			///
		laout_name(string)		///
		laout_replace(string)		///
		subspace_list(string)		///
		resample_idx(passthru)		///
		xfold_idx(passthru)		///
		reestimate]

	local k_sub : list sizeof subspace_list
	local i = `k_sub' + 1

	local laout_opt laout(`laout_name', `laout_replace')
	local sub_name `i'
	local sub_opt esrf_subspace(`sub_name')
						//  append if subspace_list > 1
	if (`i' > 1) {
		local sub_opt `sub_opt' esrf_append
	}

	local opt `opt' `laout_opt' `sub_opt' `resample_idx' `xfold_idx'
	local subspace_list `subspace_list' `sub_name'

	if (`"`reestimate'"' != ""){
		local opt `opt' reestimate(reestimate	///
			laout_name(`laout_name')	///
			laout_subspace(`sub_name'))
	}


	sret local opt `opt'
	sret local subspace_list `subspace_list'
end
