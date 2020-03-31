*! version 1.0.0  23jan2015
program define _stteffects_check_overlap
	version 14.0
	syntax varname, what(string) touse(varname) pstol(real) ///
		[ osample(name) failure(varname) ]

	local pw `varlist'
	tempvar os
	if "`failure'" != "" {
		qui gen byte `os' = cond(`failure',(`pw'<`pstol'),0) if `touse'
	}
	else {
		qui gen byte `os' = (`pw'<`pstol') if `touse'
	}
	qui count if `os' & `touse'
	local ml = r(N)
	if `ml' == 0 {
		exit
	}
	di as err "{p}overlap violation; there are `ml' observations with " ///
	 "a `what' less than " %8.1e `pstol' "{p_end}"
	if "`osample'" != "" {
		qui gen byte `osample' = `os' if `touse'
		label variable `osample' "overlap violation indicator"

		di as txt "{phang}The variable `osample' contains a 1 " ///
		 "for each observation that violates overlap, a 0 for " ///
		 "those that do not, and a missing value ({bf:.}) if " ///
		 "the observation is excluded from the sample.{p_end}"
	}
	exit 498
end

exit
