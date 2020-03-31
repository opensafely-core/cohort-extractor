*! version 1.0.0  18feb2009
program _check_e_rc
	version 11
	syntax [, ignorerc]
	if e(rc) == 504 & inlist("`e(opt)'", "ml", "moptimize") {
		di as err ///
"{p 0 0 2}variance matrix missing because `e(user)' failed" ///
"to compute scores or computed scores with missing values{p_end}"
		exit 504
	}
	if (`"`ignorerc'"'=="" & !missing(e(rc)) & e(rc) != 0) error e(rc)
end
