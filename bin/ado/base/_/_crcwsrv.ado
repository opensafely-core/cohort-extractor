*! _crcwsrv -- version of _crcsrvc that allows weights
*! version 1.0.2  26nov1997             (STB-19: ssa3)
program define _crcwsrv
* touched by kth
	version 3.0
	local varlist "req ex"
	local if "opt"
	local in "opt"
	local weight "iweight aweight fweight"
	parse "`*'"
	parse "`varlist'", parse(" ")
	if "`3'"!="" {
		local byc "by `3':"
	}
	cap drop _surv
	cap drop _stds
	cap drop _vlogs
	tempvar xi xii surv stds vlogs dead
	quietly {
		gen float `dead' = cond(`2'==.,.,`2'!=0)
		gen `stds' = - `dead'
		sort `3' `1' `stds' /* deaths first */
		if ("`exp'"=="") { local exp "=1" }
		else { replace `dead' `exp'*`dead' }
		gen float `xii' = 0
		`byc' replace `xii' `exp' `if' `in'
		if ("`weight'"=="aweight") {
			qui summ `xii'
			qui replace `xii' = `xii' / r(mean)
			local wtopt "iweight"
		}
		`byc' replace `xii' = 0 if `1'==. | `dead'==.
		`byc' gen float `xi' = sum(`xii')
		`byc' replace `xi' = `xi'[_N] + `xii' - `xi'
		gen `surv' = 1
		replace `surv' = (`xi' - `dead') / `xi' `if' `in'
		replace `surv' = 1 if `1'==. | `dead'==.
		`byc' replace `surv' = `surv' * `surv'[_n-1] if _n>1
		by `3' `1': replace `surv' = `surv'[_N]
		label var `surv' "Survival Probability"
		replace `stds' = `dead' / `xi' / (`xi' - `xii')
		replace `xi'=-1 `if' `in' /* -1 ==> in the sample */
		replace `xi'=0 if `1'==. | `dead'==.
		replace `stds'=0 if `xi'!=-1
		`byc' gen `vlogs' = sum(`stds')
		by `3' `1': replace `vlogs' = `vlogs'[_N]
		replace `surv'=. if `xi'!=-1
		replace `vlogs'=. if `xi'!=-1
		replace `stds' = `surv'*sqrt(`vlogs')
		label var `stds' "Greenwood Survival S.D."
		label var `vlogs' "Var(log(_surv))"
	}
	rename `surv' _surv
	rename `stds' _stds
	rename `vlogs' _vlogs
end
