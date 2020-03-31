*! version 1.0.0  30jul2002
/*  
    Returns in the specified local macro name a list of the contents of the
    specified class-system array.  Places double quotes around any items that
    have embedded spaces or items that are blank or not in the array.

    Usage:  _namelist macname : `.a.b.arrname.objkey'
    				or
            _namelist macname : .a.b.arrname

    could be made a builtin for arrays 
*/

program define _clsarr2list
	version 7

	args macname colon clsarray

	forvalues i = 1/0`.`clsarray'.arrnels' {
		local name `.`clsarray'[`i']'
		local unused : subinstr local name " " " ", all count(local ct)
		if `ct' > 0  | "`name'" == "" {
			local namelist `namelist' "`name'"
		}
		else	local namelist `namelist' `name'
	}

	c_local `macname' `namelist'
end
