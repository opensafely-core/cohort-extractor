*! version 1.1.0  10jan2011
program _ereturn_display
	version 11
	if "`e(b)'" == "" & "`e(V)'" == "" {
		exit
	}
	if "`e(cmd)'" == "regress" {
		local ALTOPT Beta
	}
	syntax [, eform(passthru) First neq(integer -1) PLus `ALTOPT' *]
	_get_mcompare, `options'
	if "`s(method)'" != "" {
		loca mcopt mcompare(`s(method)' `s(adjustall)')
	}
	_get_diopts diopts, `s(options)'
	if !`:length local first' {
		local first showeqns
	}
	if `neq' < 1 {
		_ms_eq_info
		local neqopt neq(`r(k_eq)')
	}
	else {
		local neqopt neq(`neq')
	}
	_coef_table,	nodiparm	///
			nocnsreport	///
			noeqcheck	///
			eformall	///
			`eform'		///
			`first'		///
			`neqopt'	///
			`plus'		///
			`beta'		///
			`mcopt'		///
			`diopts'
end
exit
