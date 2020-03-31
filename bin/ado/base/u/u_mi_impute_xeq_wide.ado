*! version 1.0.0  22jun2011
program u_mi_impute_xeq_wide
	version 12
	args m nopreserve colon command
	if ("`nopreserve'"=="") {
		preserve
	}
	char _dta[_mi_impute_m] `m'
	if (`m'==0) {
		cap noi `command'
		local rc = _rc
		char _dta[_mi_impute_m]
		if ("`nopreserve'"=="" & `rc'==0) {
			restore, not
		}
		exit `rc'
	}
	
	tempvar tvar
	cap noi nobreak mata: u_mi_wide_swapvars(`m', "`tvar'")
	if _rc {
		di as err "{bf:mi impute}: corrupt {bf:mi} data"
		di as err "{p 4 4 2}This error may be a result of specifying"
		di as err "the {bf:noupdate} option with {bf:mi impute}.  If"
		di as err "so, you should first run {helpb mi update}."
		di as err "{p_end}"
		char _dta[_mi_impute_m]
		exit 499
	}
	cap noi `command'
	local rc = _rc
	char _dta[_mi_impute_m]
	nobreak mata: u_mi_wide_swapvars(`m', "`tvar'")
	if ("`nopreserve'"=="" & `rc'==0) {
		restore, not
	}
	exit `rc'
end
