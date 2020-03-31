*! version 1.0.0  18jul2013
program etreg_footnote
	version 9.1
	if "`e(prefix)'" != "" {
		exit
	}
	local testtyp `e(chi2_ct)'
	if ("`e(poutcomes)'" == "") {
	di in gr  "`testtyp' test of indep. eqns. (rho = 0):" /*
		*/ _col(38) "chi2(" in ye "1" in gr ") = "   /*
		 */ in ye %8.2f e(chi2_c)                     /*
		 */ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
	}
	else {
	di in gr  "`testtyp' test of indep. (rho0 = rho1 = 0):" /*
		*/ _col(38) " chi2(" in ye "2" in gr ") ="   /*
		 */ in ye %8.2f e(chi2_c)                     /*
		 */ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
	}
end
