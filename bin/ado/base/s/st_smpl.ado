*! version 6.0.1  15sep2004
program define st_smpl /* touse [if] [in] [maybe_str_vars] [num_vars] */
	version 6, missing
	if _caller()>=6 {
		args touse if in by adj

		mark `touse' `if' `in' `_dta[st_w]'
		markout `touse' `adj'
		markout `touse' `by', strok 
		qui replace `touse' = 0 if _st==0
	
		qui count if `touse'
		if r(N) == 0 { 
			di in red `"no observations"'
			exit 2000
		}
		exit
	}
	zt_smp_5 `0'
end
