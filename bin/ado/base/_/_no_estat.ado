*! version 1.0.1  24feb2005
program _no_estat
	version 9
	if "`e(cmd)'" == "" {
		error 301
	}
	if `"`e(prefix)'"' == "" {
		local cmd = "`e(cmd)'"
	}
	else {
		local cmd = "`e(prefix)':`e(cmdname)'"
	}

	di as error "estat is not allowed after `cmd'"
	exit 301
end
exit
