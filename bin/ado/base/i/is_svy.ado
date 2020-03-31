*! version 1.1.2  24feb2005
program define is_svy, rclass
	version 8

	syntax [, Regression]
	
	// all results from the survey prefix "svy:" should evaluate inside
	// the first -if- block

	if `"`e(prefix)'"' == "svy" {
		return scalar is_svy = 1
	}
	else if "`regression'" == "" {
		return scalar is_svy = ("`e(N_psu)'" != "")
	}
	else {
		capt mat list e(b)
		local rc = _rc
		return scalar is_svy = ("`e(N_psu)'" != "") & (`rc' == 0)
	}
end
exit
