*! version 1.0.2  19may2019
					//----------------------------//
					// begin cross fit log
					//----------------------------//
program _dslasso_begin_cflog
	version 16.0

	syntax [, dslog k(string) xfolds(string) 	///	
		resample_num(string)			///
		resample_idx(string)			///
		relog]

	if (`"`dslog'"' == "") {
		exit 
		// NotReached
	}

	if (`resample_num' > 1 & "`relog'" != "") {
		di as txt "Resample `resample_idx' of `resample_num' ..."
	}

	di as txt "Cross-fit fold `k' of `xfolds' ..."
end
