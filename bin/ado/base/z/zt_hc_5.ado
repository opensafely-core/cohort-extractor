program define zt_hc_5 /* touse */
	version 5.0
	local touse "`1'"

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_wv]

	if "`d'"=="" {
		local d 1
	}
	if "`t0'"=="" {
		local t0 0
	}
	tempvar z

	quietly {
		if "`id'"=="" {
			if "`w'"=="" {
				count if `touse'
				global S_E_subj = _result(1)
				count if `touse' & `d'
				global S_E_fail = _result(1)
				gen double `z' = (`t'-`t0') if `touse'
				summ `z', meanonly 
				global S_E_risk = _result(18)
				exit
			}
			summ `w' if `touse', meanonly
			global S_E_subj = _result(18)
			summ `w' if `touse' & `d', meanonly
			global S_E_fail = _result(18) 
			gen double `z' = `w'*(`t'-`t0') if `touse'
			summ `z', meanonly 
			global S_E_risk = _result(18)
			exit
		}
		if "`w'"=="" {
			tempvar w
			gen byte `w'=1 if `touse'
		}
		sort `touse' `id' 
		by `touse' `id': gen double `z' = `w' if `touse' & _n==1
		summ `z', meanonly
		global S_E_subj = _result(18)
		summ `w' if `touse' & `d', meanonly 
		global S_E_fail = _result(18) 
		replace `z' = `w'*(`t'-`t0') if `touse'
		summ `z', meanonly 
		global S_E_risk = _result(18) 
	}
end
