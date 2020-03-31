*! version 1.0.4  01may2019
program poisson_estat, rclass
	version 9

	local ver : di "version " string(_caller()) ", missing :"
		
	if "`e(cmd)'" != "poisson" {
		error 301
	}
	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("gof",1,max(3,`lkey')) {
		`ver' poisgof `rest'
	}
	else {
		estat_default `0'
	}
	return add
end
