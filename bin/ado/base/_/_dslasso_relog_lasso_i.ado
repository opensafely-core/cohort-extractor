*! version 1.0.0  19may2019
					//----------------------------//
					// print resample log for lasso i
					//----------------------------//
program _dslasso_relog_lasso_i
	version 16.0

	syntax [, relog relog_i(string)  ]

	if (`"`relog'"' == "") {
		exit
		// NotReached
	}
	if (`"`relog_i'"' == "") {
		local relog_i = 1
	}

	if (`relog_i' == 1) {
		di as txt "Estimating lassos: 1" _continue
	}
	else if (mod(`relog_i', 5) == 0) {
		di as txt "`relog_i'" _continue
	}
	else {
		di as txt "." _continue
	}

	local relog_i = `relog_i' + 1
	c_local relog_i = `relog_i'
end

