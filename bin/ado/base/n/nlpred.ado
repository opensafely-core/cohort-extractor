*! version 1.1.5  21dec1998
program define nlpred
	version 6
	if "`e(cmd)'"!="nl" { error 301 } 
	syntax newvarlist [if] [in] [, Resid]
	tempvar new touse
	mark `touse' `if' `in'

	quietly {
		local k 1
		while `k' <= e(k) { 
			local word : word `k' of `e(params)'
			global `word' = _b[`word']
			local k=`k'+1
		}
		gen double `new' = .
		nl`e(function)' `new' `e(f_args)', `e(options)'
		replace `new' = . if !`touse'
		if "`resid'"!="" {
			if e(log_t) {
				replace `new'=ln((`e(depvar)'-e(lnlsq))/ /*
				*/ (`new'-e(lnlsq)))
			}
			else replace `new'=`e(depvar)'-`new'
		}
	}
	generate `typlist' `varlist' = `new' if `touse'
end
