*! version 1.0.0  19may2019
program _dslasso_relog_newline
	version 16.0

	syntax [, resample_idx(string)	///
		resample_num(string)	///
		relog]

	if (`resample_num' == 1 | `"`relog'"' == "") {
		exit
		// NotReached
	}

	if (`resample_idx' > 1) {
		di
	}
end
