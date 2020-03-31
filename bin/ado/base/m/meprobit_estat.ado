*! version 1.0.1  20jun2014
program meprobit_estat
	version 13

	if "`e(cmd2)'" != "meprobit" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
