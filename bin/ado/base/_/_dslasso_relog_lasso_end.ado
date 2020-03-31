*! version 1.0.0  19may2019
					//----------------------------//
					// print resample log for lasso i
					//----------------------------//
program _dslasso_relog_lasso_end
	syntax [, relog]

	if (`"`relog'"' != "") {
		di
	}
end
