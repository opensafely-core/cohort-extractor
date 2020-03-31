*! version 1.1.0  31mar2011
program _e2r
	version 12
	syntax [,			///
		XMACros(namelist)	///
		XSCAlars(namelist)	///
		XMATrices(namelist)	///
		ADD			///
	]

	if "`add'" == "" {
		ClearR
	}

	// save the macros
	local macros : e(macros)
	local macros : list macros - xmacros
	mata: st_return_copy_global("macros", "e", "r")

	// save the scalars
	local scalars : e(scalars)
	local scalars : list scalars - xscalars
	mata: st_return_copy_numscalar("scalars", "e", "r")

	// save the matrices
	local matrices : e(matrices)
	local matrices : list matrices - xmatrices
	mata: st_return_copy_matrix("matrices", "e", "r")

end

program ClearR, rclass
	return clear // [sic]
end
exit
