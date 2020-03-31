*! version 1.0.0  16may2013
program define _teffects_getstat1, sclass
	version 13

	syntax , [ ate atet pomeans ]

	local k : word count `ate' `atet' `pomeans'
	if `k' > 1 {
		if `k' == 2 {
			local tmp "`ate' `atet' `pomeans'"
			local tmp : list sort tmp
			local tmp : list retokenize tmp
			gettoken a1 a2: tmp
			di as err "{p}{bf:`a1'} and {bf:`a2'} "		///
				"cannot both be specified{p_end}"
		}
		else {
			di as err "{p}{bf:ate}, {bf:atet}, and "	///
				"{bf:pomeans} cannot all be specified{p_end}"
		}
		exit 184
	}
	if (!`k') local stat1 ate
	else local stat1 `ate'`atet'`pomeans'

	sreturn local stat1 "`stat1'"
end
