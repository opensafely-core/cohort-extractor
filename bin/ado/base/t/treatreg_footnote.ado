*! version 1.1.0  07jan2011
program treatreg_footnote
	version 9.1
	if "`e(prefix)'" != "" {
		exit
	}
	capture confirm matrix e(Cns)
	if !_rc {
		local hascns 1
	}
	if "`e(vcetype)'" != "Robust" & "`hascns'" != "1" {
		local testtyp LR
	}
	else local testtyp Wald
	di in gr  "`testtyp' test of indep. eqns. (rho = 0):" /*
		*/ _col(38) "chi2(" in ye "1" in gr ") = "   /*
		 */ in ye %8.2f e(chi2_c)                     /*
		 */ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
end
