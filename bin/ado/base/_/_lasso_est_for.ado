*! version 1.0.3  07jun2019
program _lasso_est_for, rclass
	version 16.0
	cap syntax  [anything(name=st_estname)] 	///
		[, for(string)				///
		XFOLD(string)				///
		resample(string)]
	
	if (_rc) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the syntax is {it:`st_estname'}, "	///
			"{bf:for(varname)} [{bf:xfold(#)} {bf:resample(#)}]"
		di "{p_end}"
		exit 198
	}
	
	if (`"`st_estname'"' == "" | `"`st_estname'"' == ".") {
		esrf default_filename
		local fn `s(stxer_default)'
	}
	else {
		esrf get_store_name `st_estname'
		local fn `s(stxer_stname)'
	}

	cap esrf assert `"`fn'"'
	if _rc {
		di as err "estimation result `st_estname' not found"
		exit 111
	}

	esrf get cmd : e(cmd), using(`fn')

	if (`"`cmd'"' == "lasso" | 		///
		`"`cmd'"' == "sqrtlasso" | 	///
		`"`cmd'"' == "elasticnet") {
		ret local cmd `cmd'
		exit
	}

	cap esrf get lasso_infer : e(lasso_infer), using(`fn')
	if (`"`lasso_infer'"' == "") {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di "option {bf:for()} is allowed only after inferential lasso"
		di "{p_end}"
		exit 198
	}

	esrf get all_subspace : e(subspace_list), using(`fn')

	foreach sub of local all_subspace {
		local good = 0
		local target = 1

		esrf get depvar : e(depvar), subspace(`sub') using(`fn')
		if (`"`depvar'"' == `"`for'"') {
			local good = 1
		}

		cap esrf get idx1 : e(xfold_idx), subspace(`sub') using(`fn')
		if (!_rc) {
			local target = `target' + 1

			if (`"`idx1'"' == "`xfold'") {
				local good = `good' + 1
			}
		}
		else if (`"`xfold'"' != "" & `"`xfold'"' != "1") {
			di as err "no cross-fitting result is found"			
			exit 111
		}

		cap esrf get idx2 : e(resample_idx), subspace(`sub') using(`fn')
		if (!_rc) {
			local target = `target' + 1

			if (`"`resample'"' == "" & `"`idx2'"' == "1") {
				local good = `good' + 1
			}
			else if (`"`idx2'"' == "`resample'") {
				local good = `good' + 1
			}
		}
		else if (`"`resample'"' != "" & `"`resample'"' != "1") {
			di as err "no resample of cross-fitting result is found"
			exit 111
		}

		if (`good' == `target') {
			local subspace `sub'
			continue, break
		}
	}

	if (`"`subspace'"' == "") {
		if (`target' == 1) {
			di as err "can not find result for {bf:`for'}"
			exit 111
		}
		else {
			di as err "can not find result for {bf:`for'}"
			di "{p 4 4 2}"
			di as err "the syntax is {it:`st_estname'}, "	///
				"{bf:for(varname)} [{bf:xfold(#)} "	///
				"{bf:resample(#)}]"
			di "{p_end}"
			exit 111
		}
	}
	ret local name `st_estname'
	ret local subspace `subspace'
end
