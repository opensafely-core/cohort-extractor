*! version 1.0.7  04mar2019
program ivtobit_footnote
	version 9
	ivreg_footnote
	if "`e(prefix)'" == "" & missing(e(df_r)) {
		if "`e(method)'" == "ml" {
			MLfootnote
		}
		else	TSfootnote
	}
end

program TSfootnote
	local chi : di %8.2f e(chi2_exog)
	local chi = trim("`chi'")
	
	di as text "Wald test of exogeneity: " as text			///
		"chi2(" as res e(endog_ct)				///
		as text ") = " as res "`chi'" as text			///
		_col(59) "Prob > chi2 = " as res %6.4f			///
		chiprob(e(endog_ct), e(chi2_exog))
end

program MLfootnote
	local chi : di %8.2f e(chi2_exog)
	local chi = trim("`chi'")
	
	if e(endog_ct) == 1 {
		local version = cond(missing(e(version)),14.1,e(version))
		if `version' >= 15 { 
			local what corr
		}
		else {
			local what /alpha
		}
		di as text "Wald test of exogeneity (`what' = 0): chi2(" ///
			as res e(endog_ct) as text ") = " as res	 ///
			"`chi'" as text _col(59) "Prob > chi2 = "    	 ///
			as res %6.4f chiprob(e(endog_ct), e(chi2_exog))
	}
	else {
		di as text "Wald test of exogeneity: " as text   	  ///
			"chi2(" as res e(endog_ct) as text ") = " as res  ///
			"`chi'" as text _col(59)               		  ///
			"Prob > chi2 = " as res %6.4f                     ///
			chiprob(e(endog_ct), e(chi2_exog))
	}
end
