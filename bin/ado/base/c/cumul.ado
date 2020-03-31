*! version 2.3.0  30aug2014
program define cumul, byable(onecall) sort
	version 6, missing
	syntax varname [fw aw/] [if] [in] ,	///
		Generate(str)			///
		[ Freq BY(varlist) EQual ]
	confirm new var `generat'

	marksample touse

	if _by() {
		if "`by'" != "" {
			di in red /*
			*/ "by prefix and by() option may not be combined"
			exit 198
		}
		local by "`_byvars'"
	}


	if `"`exp'"' != "" {
		tempvar wgt
		qui gen double `wgt' = `exp' if `touse'
	}
	else	local wgt "1"

	tempvar RESULT
	if ("`by'"!="") {
		if ("`in'"!="") {
			di in red "in may not be combined with by()"
			exit 190
		}
		local byf "by `by' :"
	}
	quietly {
		sort `by' `varlist'
		`byf' gen float `RESULT' = sum(`wgt'*`touse')
		if "`equal'" != "" {
			by `by' `varlist' : replace `RESULT' = `RESULT'[_N] /*
					*/ if `touse'
		}
		if ("`freq'"=="") {
			`byf' replace `RESULT' = `RESULT' / `RESULT'[_N] /*
					*/ if `touse'
		}
		replace `RESULT' = . if !`touse'
		rename `RESULT' `generat'
		label var `generat' "ECDF of `varlist'
	}
end
