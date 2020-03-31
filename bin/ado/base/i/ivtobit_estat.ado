*! version 1.0.1  06mar2017
program define ivtobit_estat, rclass
	version 15

	if "`e(cmd)'" != "ivtobit" {
		error 301
	}
	gettoken subcmd rest : 0, parse(", ")
	local subcmd : list retokenize subcmd
	local k = strlen("`subcmd'")
	if (!`k') {
		di as err "subcommand required"
		exit 198
	}
	if "`subcmd'" == bsubstr("covariance",1,max(3,`k')) {
		ivestat Cov : `rest'
	}
	else if "`subcmd'" == bsubstr("correlation",1,max(3,`k')) {
		ivestat Cor : `rest'
	}
	else {
		estat_default `0'
	}
	return add 
end
exit
