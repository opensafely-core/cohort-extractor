*! version 1.0.1  20jun2014
program mepoisson_estat
	version 13

	if "`e(cmd2)'" != "mepoisson" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
