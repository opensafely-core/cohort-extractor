*! version 1.0.0  11jul2017
program stintreg_estat, rclass

	version 15

	if "`e(cmd2)'" != "stintreg" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("gofplot", 1, max(7, `lkey')) {
		stintreg_gofplot `rest'
	}
	else {
		estat_default `0'
	}
	return add
end
