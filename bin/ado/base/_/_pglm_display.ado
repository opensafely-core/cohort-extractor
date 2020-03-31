*! version 1.0.3  07may2019
/*
	pglm display
*/
					//----------------------------//
					// Display the result
					//----------------------------//
program _pglm_display
	version 16.0

	syntax [, nodebug] 

	if (`"`debug'"' == "nodebug") {
		exit e(err_cv)
		// NotReached
	}
	
	mata : _st_lasso_table()
end
