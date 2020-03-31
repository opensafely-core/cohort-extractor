*! version 5.0.1  15sep2004
program define zt_smp_5 /* touse if in more_may_be_str_vars more_num_vars */
	version 5.0, missing
	local touse "`1'"		/* required */
	local if "`2'"			/* optional */
	local in "`3'"			/* optional */
	local by "`4'"			/* optional */
	local adj "`5'"			/* optional */

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	mark `touse' `if' `in' `w'
	markout `touse' `t' `t0' `d' `adj'
	markout `touse' `by' `id', strok 

	qui count if `touse'
	if _result(1) == 0 { 
		di in red "no observations"
		exit 2000
	}
end
