*! version 1.0.1  27mar2019
program _dslasso_di_wald
	version 16.0

	syntax , col(string)

						// wald
	local wald _col(`col') as txt "Wald chi2({res:`e(df)'})"	///
		 _col(67) "="  _col(69) as res %10.2f e(chi2)

						// prob
	local prob _col(`col') as txt "Prob > chi2" _col(67) "="	///
		_col(69) as res %10.4f e(p)	

	di `wald'
	di `prob'
end
