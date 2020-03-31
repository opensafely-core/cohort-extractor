*! version 6.2.2  23mar2015
program define st_hcd
	version 6

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + ///
		bsubstr(`"`e(crittype)'"',2,.)
	local crlen = max(15,length(`"`crtype'"'))

	di _n in gr %-`crlen's "No. of subjects" " = " ///
		in ye %12.0fc e(N_sub) ///
		_col(49) in gr "Number of obs    =  " in ye %10.0fc e(N)

	di in gr %-`crlen's "No. of failures" " = " in ye %12.0fc `e(N_fail)'
	di in gr %-`crlen's "Time at risk" " = " in ye %12.0g e(risk)

	if !missing(e(chi2)) | missing(e(df_r)) {
		if missing(e(chi2)) {
			di in smcl _col(49) ///
"{help j_robustsingular##|_new:Wald chi2(`e(df_m)')}" ///
			    in gr _col(66) "=  " in ye %10.2f e(F)
		}
		else {
			di _col(49) in gr ///
			    "`e(chi2type)' chi2(" in ye e(df_m) in gr ")" ///
			    _col(66) "=  " in ye %10.2f e(chi2)
		}

		di in gr %-`crlen's "`crtype'" " =   " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > chi2" _col(66) "=  " ///
			in ye %10.4f chiprob(e(df_m), e(chi2))
	}
	else if !missing(e(F)) {
		di _col(49) in gr ///
			"F(" in ye %4.0f e(df_m) ///
			in gr "," ///
			in ye %7.0f e(df_r) in gr ")" ///
			_col(66) "=  " in ye %10.2f e(F)

		di in gr %-`crlen's "`crtype'" " =   " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > F" _col(66) "=  " ///
			in ye %10.4f Ftail(e(df_m), e(df_r), e(F))
	}
	else {
		local dfm_l : di %4.0f e(df_m)
		local dfm_l2: di %7.0f e(df_r)
		di in smcl _col(49) ///
			"{help j_robustsingular##|_new:F(`dfm_l',`dfm_l2')}" ///
			in gr _col(66) "=  " in ye %10.2f e(F)

		di in gr %-`crlen's "`crtype'" " =   " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > F" _col(66) "=  " ///
			in ye %10.4f .
	}
end
exit






	di in gr "Time at risk   = " in ye %10.0g e(risk) /*
	*/ in gr _col(48) "No. of observations =" in ye %10.0g e(N)

	di in gr "No. of failures= " in ye %10.0g `e(N_fail)' /*
	*/ in gr _col(48)  "No. of subjects     =" in ye %10.0g e(N_sub) 

/*
	di in gr "Time at risk   = " in ye %10.0g e(risk) /*
	*/ in gr _col(48) "No. of failures     =" in ye %10.0g `e(N_fail)' 
*/

	local l = 49-length("`e(df_m)'")
	di in gr _col(`l') "`e(chi2type)' chi2(" in ye e(df_m) in gr ")" /*
	*/ _col(68) "=" /* 
	*/ in ye %10.2f e(chi2)

	di in gr "Log likelihood = " in ye %10.0g e(ll) /* 
	*/ in gr _col(48) "Prob > chi2         =" /* 
	*/ in ye %10.4f chiprob(e(df_m), e(chi2))
end
exit
/*
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
No. of subjects = 123456789012                    Log likelihood = 12345678911
No. of failures =           23                    chi2(1)        =        2.85
Time at risk    =        15737                    Prob > chi2    =      0.0916
*/
