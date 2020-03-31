*! version 1.0.0  07jun2019
program _dslasso_chi2, eclass
	version 16.0

	local vars : colvarlist e(b)
	qui test `vars'

	local chi2 = r(chi2)
	local p  = r(p)
	local df = r(df)
	
	eret scalar chi2 = `chi2'
	eret scalar p = `p'
	eret scalar df = `df'
	eret local chi2type "Wald"

	mata : st_numscalar("e(rank)", rank(st_matrix("e(V)")))
end

