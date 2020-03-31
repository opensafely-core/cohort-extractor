*! version 1.0.0  26dec2018
program _lasso_repost
	version 16.0

	syntax [, reestimate		///
		laout_name(string)	///
		laout_subspace(string) ]
	
	if (`"`reestimate'"' == "") {
		exit 
		// NotReached
	}

	esrf post `laout_name', subspace(`laout_subspace')
end
