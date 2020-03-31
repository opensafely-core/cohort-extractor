*! version 1.3.0  03apr2011
program _r2e, eclass
	version 12
	syntax [,			///
		XMACros(namelist)	///
		XSCAlars(namelist)	///
		XMATrices(namelist)	///
		NOCLEAR			///
	]

	// exclude special cases
	local xmacros	`xmacros' properties
	local xmatrices	`xmatrices' b V Cns

	// This routine assumes that e() is ready to have things added to it,
	// meaning that -ereturn post- has already been called.

	// merge the contents of r(properties) with e(properties)
	local props `e(properties)' `r(properties)'
	local props : list uniq props
	ereturn local properties `props'

	// save the macros
	local macros : r(macros)
	local macros : list macros - xmacros
	mata: st_return_copy_global("macros", "r", "e", 1)

	// save the scalars
	local scalars : r(scalars)
	local scalars : list scalars - xscalars
	mata: st_return_copy_numscalar("scalars", "r", "e", 1)

	// save the matrices
	local matrices : r(matrices)
	local matrices : list matrices - xmatrices
	mata: st_return_copy_matrix("matrices", "r", "e", 1)

	if "`noclear'" == "" {
		ClearR
	}
end

program ClearR, rclass
	return clear
end
exit
