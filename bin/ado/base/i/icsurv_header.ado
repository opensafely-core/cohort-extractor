*! version 1.0.1  16nov2016
program define icsurv_header

	version 15

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + ///
		bsubstr(`"`e(crittype)'"',2,.)

	di in gr "`e(title)'" _col(49) "Number of obs" ///
		_col(66) " = " in ye %10.0fc `e(N)'
	di in gr _col(56) "Uncensored = " in ye %10.0fc `e(N_unc)'
	di in gr _col(53) "Left-censored = " in ye %10.0fc `e(N_lc)'
	di in gr _col(52) "Right-censored = " in ye %10.0fc `e(N_rc)'
	di in gr _col(49) "Interval-censored = " in ye %10.0fc `e(N_int)'

	di	

	if !missing(e(chi2)) | missing(e(df_r)) {
		if missing(e(chi2)) {
			di in smcl _col(49) ///
"{help j_robustsingular##|_new:Wald chi2(`e(df_m)')}" ///
			    in gr _col(66) " = " in ye %10.2f e(F)
		}
		else {
			di _col(49) in gr ///
			    "`e(chi2type)' chi2(" in ye e(df_m) in gr ")" ///
			    _col(66) " = " in ye %10.2f e(chi2)
		}

		di in gr "`crtype'" " = " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > chi2" _col(66) " = " ///
			in ye %10.4f chiprob(e(df_m), e(chi2))
	}
	else if !missing(e(F)) {
		di _col(49) in gr ///
			"F(" in ye %4.0f e(df_m) ///
			in gr "," ///
			in ye %7.0f e(df_r) in gr ")" ///
			_col(66) " = " in ye %10.2f e(F)

		di in gr "`crtype'" " = " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > F" _col(66) " = " ///
			in ye %10.4f Ftail(e(df_m), e(df_r), e(F))
	}
	else {
		local dfm_l : di %4.0f e(df_m)
		local dfm_l2: di %7.0f e(df_r)
		di in smcl _col(49) ///
			"{help j_robustsingular##|_new:F(`dfm_l',`dfm_l2')}" ///
			in gr _col(66) " = " in ye %10.2f e(F)

		di in gr "`crtype'" " = " in ye %10.0g e(ll) ///
			_col(49) in gr "Prob > F" _col(66) " = " ///
			in ye %10.4f .
	}

end
