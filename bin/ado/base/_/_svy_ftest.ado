*! version 1.0.0  22feb2002
program _svy_ftest, eclass
	version 8.2
	args spec C

	if "`e(adjust)'" == "nosvyadjust" {
		local adjust nosvyadjust
	}
	capture test `spec', `adjust'
	if !c(rc) {
		ereturn scalar df_m = r(df)
		if reldif(r(drop),0) < 1e-10 | `"`C'"' != "" {
			ereturn scalar F = r(F)
		}
		else	ereturn scalar F = .
	}
	else	ereturn scalar df_m = 0
end
exit
