*! version 1.0.1  31oct2008
program mvtest_chi2test
	version 11

	args title Chi2 df p oneline cont

	tempname df_2
	scalar `df_2' = round(`df',0.1)
	local Df  `:di %15.0g `df_2''
	if "`oneline'"=="" {
		dis as txt "{ralign 22:`title' chi2({res:`Df'})} = " ///
			as res %9.2f `Chi2' _n ///
			as txt "{ralign 22:Prob > chi2} = " as res %9.4f `p' ///
			`cont'
	}
	else {
		dis as txt "{ralign 22:`title' chi2({res:`Df'})} = " ///
			as res %9.2f `Chi2' _skip(3) ///
			as txt "Prob > chi2 = " as res %7.4f `p' `cont'
	}

end
exit

