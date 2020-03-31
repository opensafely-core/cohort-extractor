*! version 1.0.1  16mar2017
program _sp_check_lag_list, sclass

	version 15.0
	syntax [, lag_list(string)]

	if (`"`lag_list'"'=="") {
		sret local n_spmat = 0
		exit 	
		//NOT reached
	}

	mata : _SPMATRIX_check_lag_list(`"`lag_list'"')
	sret local n_spmat = `n_spmat'
end
