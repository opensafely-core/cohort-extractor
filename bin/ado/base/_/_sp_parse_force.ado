*! version 1.0.0  22feb2017
program _sp_parse_force, sclass
	version 15.0

	syntax , n_esample(string)	/// 
		id(string)		///
		touse(string)		///
		[ force 		///
		lag_list(string)	///
		n_spmat(string) ] 

	if (`"`force'"' == "" | `"`lag_list'"'=="") {
		sret local new_lag_list
		exit
		//NOT reached
	}

	if (`n_spmat' <= `n_esample') {
		sret local new_lag_list
		exit
		// NOT reached
	}

	di as txt _col(3) "(you specified -{bf:force}-)"

	_spmatrix_subset, 		///
		lag_list(`lag_list') 	///
		id(`id') 		///
		touse(`touse')
	local new_lag_list `s(new_lag_list)'	
	sret local new_lag_list `new_lag_list'
end
