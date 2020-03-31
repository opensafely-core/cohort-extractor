*! version 1.0.0  02feb2015
program define _lrtest_note_me, sclass
	version 14

	syntax , msg(string)

	// We have already established that e(chi2_c) exists

	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e5)) | (e(chi2_c)==0) {
		local fmt "%8.2f"
	}
	else    local fmt "%8.2e"

	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")

	di "{txt}`msg': " _c
	if `e(df_c)' == 1 {    		// chibar2(01)
		di "{txt}{help j_chibar##|_new:chibar2(01) =}{res} `chi'" ///
			_col(55) "{txt}Prob >= chibar2 = {res}" ///
			_col(73) %6.4f e(p_c)
	}
	else {
		di "{txt}chi2({res}`e(df_c)'{txt}) ={res} `chi'" ///
			_col(59) "{txt}Prob > chi2 ={res}" ///
			_col(73) %6.4f e(p_c)
		local conserve conserve
	}

	sreturn local conserve `conserve'
end
exit

