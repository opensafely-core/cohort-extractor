*! version 1.0.3  21may2015
program scobit_footnote
	version 9.1
	syntax [, NOwarn]

	if "`e(prefix)'" == "svy" {
		exit
	}
	if "`e(chi2_ct)'"=="LR" {
		if e(chi2_c) < 1e5 {
			local fmt "%9.2f"
		}
		else 	local fmt "%9.2e"

		local chi : di `fmt' e(chi2_c)
		local chi = trim("`chi'")
		
		di in gr "LR test of alpha=1: " ///
			in gr "chi2(" in ye "1" in gr ") = " in ye "`chi'" ///
			in gr _col(59) "Prob > chi2 = " in ye %6.4f ///
			chiprob(1, e(chi2_c))
	}

	if `"`nowarn'"'=="" {
		di _n in gr /*
		*/ "Note: Likelihood-ratio tests are recommended for " /*
		*/ "inference with scobit models."
	}
end
