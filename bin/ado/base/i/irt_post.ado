*! version 1.0.0  23oct2014
program irt_post, eclass
	version 14
	local title `"`e(title)'"'
	tempname b
	matrix `b' = r(b)
	if "`r(V)'" == "matrix" {
		tempname V
		matrix `V' = r(V)
	}
	ereturn post `b' `V'
	if "`r(eq_models)'" != "" {
		tempname eqmat
		matrix `eqmat' = r(eq_models)
		ereturn matrix eq_models `eqmat'
	}
	ereturn hidden local title `"`title'"'
	ereturn hidden local cmd2 irt
	ereturn hidden local cmd estat
end
exit
