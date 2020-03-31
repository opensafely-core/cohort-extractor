*! version 1.0.1  03oct2017

program hetoprobit_footnote

	if "`e(prefix)'" == "svy" exit

	local chi : di %8.2f e(chi2_c)
	local chi = trim("`chi'")

	if "`e(chi2_ct)'" == "Wald" {
		di as txt "Wald test of lnsigma=0: " ///
		"chi2(" as res "`e(df_m_c)'" as txt ") = " as res "`chi'" ///
		as txt _col(59) "Prob > chi2 = " as res %6.4f ///
		chi2tail(e(df_m_c),e(chi2_c))
	}
	else if "`e(chi2_ct)'" == "LR" {	
		di as txt "LR test of lnsigma=0: " ///
		"chi2(" as res "`e(df_m_c)'" as txt ") = " as res "`chi'" ///
		as txt _col(59) "Prob > chi2 = " as res %6.4f ///
		chi2tail(e(df_m_c),e(chi2_c))
	}

end
