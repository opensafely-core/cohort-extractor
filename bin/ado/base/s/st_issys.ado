*!  version 6.0.0  16jul1998
program define st_issys, rclass
	version 6
	if _caller()>=6 {
		args v
		local sysvars _t _t0 _st _d _origin /*
			*/ `_dta[st_id]' `_dta[st_bt]' /*
			*/ `_dta[st_bt0]' `_dta[st_bd]' `_dta[st_w]'

		tokenize `sysvars'

		while `"`1'"'!="" {
			if `"`1'"'==`"`v'"' {
				ret scalar boolean = 1
				global S_1 1	/* double saves */
				exit
			}
			mac shift
		}
		ret scalar boolean = 0
		global S_1 0	/* double saves */
		exit
	}
	zt_iss_5
end
