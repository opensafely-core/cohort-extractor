*! version 1.0.0  27aug2019
program _prefix_remove, sclass
	version 16

	// Syntax:
	//
	// 	_prefix_remove mslist : rmlist
	//
	// The elements in mslist and rmlist are matrix stripes.
	//
	// Remove each element of mslist that is present in rmlist.

	_on_colon_parse `0'
	local mslist `s(before)'
	local rmlist `s(after)'

	tempname m
	local dim : list sizeof rmlist
	if `dim' == 0 {
		sreturn local speclist `"`mslist'"'
		exit
	}
	matrix `m' = J(1,`dim',0)
	matrix colna `m' = `rmlist'

	foreach ms of local mslist {
		_msparse `ms', noomit
		local MS "`r(stripe)'"
		local pos = colnumb(`m', "`ms'")
		if missing(`pos') {
			local pos = colnumb(`m', "`MS'")
		}
		if missing(`pos') {
			local MSLIST `"`MSLIST' `ms'"'
		}
	}

	sreturn local speclist `"`MSLIST'"'
end

exit
