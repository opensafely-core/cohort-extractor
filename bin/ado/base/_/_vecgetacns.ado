*! version 1.0.1  10jun2011
program define _vecgetacns
	version 8.2

	_ckvec _vecgetacns

	local cnslist = e(aconstraints)

	global T_VECacnslist 
	while "`cnslist'" != "" {
		gettoken token cnslist:cnslist, parse(":")
		if "`token'" != ":" & "`token'" != "" {
			qui constraint free
			local free = r(free)
			capture noi constraint define `free' `token'
			if _rc > 0 {
				di as err "could not define a "	///
					"constraint for `token'"
				exit 498	
			}
			global T_VECacnslist $T_VECacnslist `free'	
		}	
	}

end

exit

This routine defines constraints for the constraints on alpha in 
e(aconstraints) after {cmd:vec}

The constraint numbers are returned in the global T_VECacnslist

It is the caller's job to drop T_VECacnlist and the temporary constraints
