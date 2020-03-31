*! version  6.0.2  26nov2002
program define st_hc /* touse */, eclass sort
	version 6
	args touse

	local w  : char _dta[st_wv]
	tempvar z
	quietly {
		if "`_dta[st_id]'"=="" {
			if "`w'"=="" {
				count if `touse'
				global S_E_subj = r(N)
				est scalar N_sub = r(N)
				count if `touse' & _d
				global S_E_fail = r(N)
				est scalar N_fail = r(N)
				gen double `z' = (_t -_t0 ) if `touse'
				summ `z', meanonly 
				global S_E_risk = r(sum)
				est scalar risk = r(sum)
				exit
			}
			summ `w' if `touse', meanonly
			global S_E_subj = r(sum)
			est scalar N_sub = r(sum)
			summ `w' if `touse' & _d, meanonly
			global S_E_fail = r(sum) 
			est scalar N_fail = r(sum)
			gen double `z' = `w'*(_t -_t0 ) if `touse'
			summ `z', meanonly 
			global S_E_risk = r(sum)
			est scalar risk = r(sum)
			exit
		}
		if "`w'"=="" {
			tempvar w
			gen byte `w'=1 if `touse'
		}
		sort `touse' `_dta[st_id]' 
		by `touse' `_dta[st_id]': /*
			*/ gen double `z' = `w' if `touse' & _n==1
		summ `z', meanonly
		global S_E_subj = r(sum)
		est scalar N_sub = r(sum)
		summ `w' if `touse' & _d , meanonly 
		global S_E_fail = r(sum) 
		est scalar N_fail = r(sum)
		replace `z' = `w'*(_t -_t0 ) if `touse'
		summ `z', meanonly 
		global S_E_risk = r(sum) 
		est scalar risk = r(sum)
	}
end
