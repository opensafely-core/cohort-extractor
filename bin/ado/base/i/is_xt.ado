*! version 1.0.0  05mar2007
program is_xt, rclass
	version 10
	args cmdname
	local props : properties `cmdname'
	local xt xt
	return scalar is_xt = `: list xt in props'
end
exit
