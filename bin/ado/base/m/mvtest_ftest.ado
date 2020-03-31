*! version 1.0.0  21mar2008
program mvtest_ftest
	version 11

	args title F df1 df2 p oneline

	tempname df1_2 df2_2
	scalar `df1_2' = round(`df1',0.1)
	scalar `df2_2' = round(`df2',0.1)
	local Df1  `:di %15.0g `df1_2''

	local Df2 `:di %15.0g `df2_2''

	if "`oneline'" == "" {
		di as txt "{ralign 22:`title' F({res:`Df1'},{res:`Df2'})}" ///
			" = " ///
			as res %9.2f `F' _n ///
			as txt "{ralign 22:Prob > F} = " as res %9.4f `p'
	}
	else {
		dis as txt "{ralign 22:`title' F({res:`Df1'},{res:`Df2'})}" ///
			" = " ///
			as res %9.2f `F' _skip(6) ///
			as txt "Prob > F = " as res %7.4f `p'

	}
end
exit

