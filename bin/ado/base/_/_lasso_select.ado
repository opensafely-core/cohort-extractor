*! version 1.0.1  24jan2019
program _lasso_select
	version 16.0

	if (`"`e(cmd)'"' != "lasso" &		///
		`"`e(cmd)'"' != "sqrtlasso" &	///
		`"`e(cmd)'"' != "elasticnet" ) {
		error 301
	}

	Select `0'
end

					//----------------------------//
					// Select
					//----------------------------//
program Select, eclass
	
	syntax [anything(equalok name=expr)]	///
		[, cv				///
		adaptive			///
		laout(string)			///
		subspace(string)		///
		nopostsel]
	
	local rule `cv' `adaptive'
	local n_rule : list sizeof `rule'

	if (`n_rule' > 1) {
		di as err "only one of {bf:cv} or {bf:adaptive} "	///
			"can be specified"
		exit 198
	}

	mata : lasso_select(	///
		`"`expr'"', 	///
		"`rule'", 	///
		"`laout'", 	///
		"`subspace'",	///
		"`postsel'")
end
