*! version 1.0.0  04apr2009
program define _dvech_falast , rclass
	version 11

	syntax varname(numeric)

	tempname first last

	mata: _DVECH_falast_u("`varlist'", "`first'", "`last'")

	return scalar first = `first'
	return scalar last  = `last'

end

