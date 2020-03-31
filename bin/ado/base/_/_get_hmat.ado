*! version 1.2.1  04jan2016
program _get_hmat, rclass
	syntax name(name=H) [, noWARN]

	capture matrix `H' = get(H)
	return scalar rc = c(rc)
	if c(rc) {
		capture _ms_op_info e(b)
		if _rc == 0 {
			if r(fvops) == 0 {
				exit
			}
		}
		di as txt ///
"{p 0 0 2}Warning: cannot perform check for estimable functions.{p_end}"
		exit
	}
	local mprobit = "`e(cmd)'" == "mprobit"
	if `mprobit' {
		local mprobit = e(k_eq) == e(k_out)
	}
	if inlist("`e(cmd)'", "manova", "mlogit", "mvreg") | `mprobit' {
		tempname tH
		_ms_eq_info
		local keq = r(k_eq)
		local dim = colsof(`H')
		matrix `tH' = J(`keq'*`dim',`keq'*`dim',0)
		local j 1
		forval i = 1/`keq' {
			matrix `tH'[`j',`j'] = `H'
			local j = `j' + `dim'
		}
		matrix drop `H'
		matrix rename `tH' `H'
	}
end
