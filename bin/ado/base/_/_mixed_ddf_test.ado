*! version 1.0.3  09apr2015
program _mixed_ddf_test

	version 14

	if "`e(cmd)'" != "mixed" {
		error 301
	}

	if ( "`e(dfmethod)'"== "satterthwaite" | ///
	     "`e(dfmethod)'"== "kroger" ) {
		
		// check if data has been changed
		checkestimationsample	
		
		if (`e(eim)'==1) local useinfo eim
		else local useinfo oim

		_mixed_ddf_test_approx `0' `useinfo'
	}
	else _mixed_ddf_test_exact `0'

end

program _mixed_ddf_test_exact, rclass

	syntax [,   CONStraint(name) 	/// constraint matrix
		    lmat(name)		/// L matrix
		    rmat(name) *	/// b vector
	       ]

	local dftype = "`e(dfmethod)'"
	
	tempname ddf ddf_m Ftest Phi

	qui estat vce, eq("`e(depvar)'")
	mat `Phi' = r(V)
	
	mata: _ddf_compute_exact_test("`lmat'","`rmat'","`Phi'","`constraint'")

	return scalar ddf = `r(ddf)'
	return scalar F  = `r(F)'
	
end

program _mixed_ddf_test_approx, rclass

	syntax [,   CONStraint(name) 	/// constraint matrix
		    EIM 		/// expected information matrix
		    OIM 		/// observed information matrix
		    lmat(name)		/// L matrix
		    rmat(name) 		/// b vector
		    wmat(name) 		/// undocumented, for bench
	       	    * ]	

	local dftype "`e(dfmethod)'"
	tempname V rank df_r ddf
	mat `V' = e(V)
	mat `V' = `V'[1..e(k_f),1..e(k_f)]
	mata: st_numscalar("`rank'", rank(st_matrix("`V'")))	
	scalar `df_r' = e(N)-`rank'

	// step 0: Linear regression
	
	local ivars `e(ivars)'

	if "`ivars'" == "" & `"`e(rstructure)'"'=="independent"{
		return scalar ddf = `df_r'
		exit
	}

cap noi { // begin cap noi
	preserve
	_mixed_ddf_u, dftypes(`dftype') `eim' `oim'

	tempname ddf ddf_m Ftest

	if "`dftype'" == "kroger" {
		mata: _ddf_compute_KR_test("`lmat'", "`rmat'", "`constraint'")
	}
	else if "`dftype'" == "satterthwaite" {
		mata: _ddf_compute_SAT_test("`lmat'", "`rmat'", "`constraint'")
	}
} //end capture block
	local rc = _rc
	mata: _mixed_ddf_cleanup()	
	return scalar ddf = `r(ddf)'
	return scalar F  = `r(F)'
	exit `rc'
end

exit
