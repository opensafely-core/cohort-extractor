*! version 1.0.0  22jun2011
program u_mi_impute_xeq_mlong
	version 12
	args m colon command
	preserve
	qui keep if (_mi_m==0 & _mi_miss==0 ) | _mi_m==`m'
	if (`c(N)'!=`_dta[_mi_N]' | `c(N)'==0) {
		di as err "{bf:mi impute}: corrupt {bf:mi} data"
		di as err "{p 4 4 2}Insufficient or no observations in {it:m}=`m'."
		di as err "If you specified {bf:mi impute}'s option"
		di as err "{bf:noupdate}, you should first run"
		di as err "{helpb mi update}."
		di as err "{p_end}"
		exit 499
	}
	sort _mi_id
	char _dta[_mi_impute_m] `m'
	cap noi `command'
	char _dta[_mi_impute_m]
	local rc = _rc
	qui nobreak { 
		if (`m'>0) {
			drop if _mi_m==0
		}
		tempfile imp
		save `"`imp'"'
		restore, preserve
		drop if _mi_m==`m'
		append using `"`imp'"', nonotes
		sort _mi_m _mi_id
	}
	restore, not
	exit `rc'
end
