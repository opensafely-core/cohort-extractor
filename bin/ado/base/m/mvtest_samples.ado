*! version 1.1.0  16jan2015
program mvtest_samples
	version 11
	args Obs

	tempname nObs
	scalar `nObs' = 0

	dis as txt _col(5) " sample {c |}       Obs   " 
	dis as txt _col(5) "{hline 8}{c +}{hline 15}"
	forvalues i = 1/`=rowsof(`Obs')' {
		scalar `nObs' = `nObs' + `Obs'[`i',1]
		dis as txt _col(5) %5.0f `i' "   {c |}" as res	///
			 %10.0fc `Obs'[`i',1]
	}
	dis as txt _col(5) "{hline 8}{c +}{hline 15}"
	dis as txt _col(5) "  total {c |}" as res %10.0fc `nObs' _n
end
exit
