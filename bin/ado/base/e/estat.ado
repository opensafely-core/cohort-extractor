*! version 1.0.1  20mar2009
program estat, rclass
	version 9

	local ver : di "version " string(_caller()) ", missing :"

	if `"`e(cmd)'"' == "" {
		error 301
	}
	if `"`e(estat_cmd)'"' != "" {
		`ver' `e(estat_cmd)' `0'
		return add
		exit
	}
	else {
		estat_default `0'
		return add
	}
end
