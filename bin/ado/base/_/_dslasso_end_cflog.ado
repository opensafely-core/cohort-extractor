*! version 1.0.1  17apr2019
					//----------------------------//
					// end cross fit log
					//----------------------------//
program _dslasso_end_cflog 
	version 16.0

	syntax , k(string) xfolds(string) [dslog ignore]

	if (`k' == `xfolds' & `"`ignore'"' != "") {
		exit
		// NotReached
	}

	if (`"`dslog'"' != "") {
		di
	}
end

