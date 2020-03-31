*! version 1.0.0  05dec2006
program is_st, rclass
	version 9
	args cmdname
	local props : properties `cmdname'
	local st st
	return scalar is_st = `: list st in props'
end
exit
