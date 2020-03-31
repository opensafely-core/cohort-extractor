*! version 1.0.2  24feb2005
program _no_predict
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

	di as error "predict is not allowed after `cmd'"
	exit 301
end
exit
