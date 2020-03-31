*! version 1.1.1  18jan2005
program _sumaccum, rclass
	version 8.0
	syntax [varlist(numeric)] [if] [in] [fw iw pw][, MSE(name) ]
	if "`mse'" != "" {
		confirm matrix `mse'
		if rowsof(`mse') != 1 {
			di as err "option mse() requires a row vector"
			exit 198
		}
		local ncols = colsof(`mse')
		local nvars : word count `varlist'
		if `nvars' != `ncols' {
			if `nvars' < `ncols' {
				di as err ///
				"matrix in option mse() has too many columns"
				exit 102
			}
			else {
				di as err ///
				"matrix in option mse() has too few columns"
				exit 103
			}
		}
	}

	marksample touse
	tempname b v n df k1 N
	local K : word count `varlist'
	qui count if `touse'
	if r(N)<=1 {
		di as err "insufficient observations to compute variance"
		exit 2000
	}
	quietly count if `touse'
	scalar `n' = r(N)
	if "`mse'" == "" {
		quietly ///
		matrix accum `v' = `varlist' ///
			[`weight'`exp'] if `touse', deviations
		if "`weight'" == "fweight" {
			scalar `n' = r(N)
		}
		scalar `df' = `n'-1
		scalar `k1' = `K'+1
		matrix `b' = `v'[`k1',1..`K']/`n'
		matrix `v' = `v'[1..`K',1..`K']/`df'
	}
	else {
		if "`weight'" != "" {
			local wgt [pweight`exp']
		}
		preserve
		_svy `varlist' `wgt' if `touse', novar b(`b')
		forval i = 1/`ncols' {
			local var : word `i' of `varlist'
			quietly replace `var' = `var' - `mse'[1,`i']
		}
		quietly ///
		matrix accum `v' = `varlist' ///
			[`weight'`exp'] if `touse', noconstant
		if "`weight'" == "fweight" {
			scalar `n' = r(N)
		}
		scalar `df' = `n' - 1
		matrix `v' = `v'/`df'
	}
	matrix rowname `b' = y1
	return matrix b `b'
	return matrix V `v'
	return scalar n = `n'
	return local varlist `varlist'
end
exit
