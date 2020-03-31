*! version 1.0.2  13oct2015

program define _make_constraints, eclass
	syntax, b(name) [ constraints(string) ]

	tempname b0 V
	local k = colsof(`b')
	local names : colfullnames `b'
	mat `b0' = `b'
	mat colnames `b0' = `names'

	ereturn post `b0' 

	makecns `constraints', r
	local k_autoCns = r(k_autoCns)
	local k = r(k)
	local ncns = 0
	if `k' | `k_autoCns' {
		tempname T a Cm
		cap matcproc `T' `a' `Cm'
		/* all constraints were dropped in makecns		*/
		if !c(rc) {
			local ncns = rowsof(`Cm')
		}
	}
	ereturn scalar ncns = `ncns'
	if `ncns' {
		ereturn mat Cm = `Cm'
		ereturn mat T = `T'
		ereturn mat a = `a'
		ereturn local scalar k_autoCns = `k_autoCns'
	}
end

exit
