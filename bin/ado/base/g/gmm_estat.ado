*! version 1.0.2  20jan2015

program gmm_estat

	version 11
	if "`e(cmd)'" != "gmm" {
		exit 301
	}
	
	gettoken sub rest : 0, parse(" ,")
	
	local lsub = length("`sub'")
	if "`sub'" == bsubstr("overid",1,max(4,`lsub')) {
		OverID `rest'
	}
	else if "`sub'" == bsubstr("summarize",1,max(2,`lsub')) {
		di in smcl as error 					///
			"{cmd:estat summarize} not available after {cmd:gmm}"
		exit 321
	}
	else {
		estat_default `0'
	}
	
end

program OverID, rclass

	if `"`0'"' != "" {
		di as err `"`0' invalid"'
		exit 198
	}
	
	if "`e(estimator)'" == "onestep" & "`e(winit)'" != "user" {
		di as error "not available after one-step estimation"
		exit 498
	}
	
	tempname overid noverid poverid
	sca `overid' = e(J)
	sca `noverid' = e(J_df)
	sca `poverid' = chi2tail(`noverid', `overid')
	
	di
	di as text _col(3) "Test of overidentifying restriction`s':"
	di
	di as text _col(3) "Hansen's J chi2("			///
		as res `noverid'				///
		as text ") ="					///
		as res %8.0g `overid'				///
		as text " (p = "				///
		as res %5.4f `poverid'				///
		as text ")"
	return scalar J = `overid'
	return scalar J_p  = `poverid'
	return scalar J_df = `noverid'

	if !(e(J_df)) {
		di
		di as text ///
		"{p 0 6 2 67}Note: test cannot be performed because" ///
		" there are no overidentifying restrictions.{p_end}"
	}
end
exit
