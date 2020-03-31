*! version 2.0.3  18nov2015
program define ivprobit_estat, rclass
	local vcaller = string(_caller())
	version 9
	if "`e(cmd)'" != "ivprobit" {
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
		version `vcaller': probit_estat `0'
	}
	return add 
end
exit
