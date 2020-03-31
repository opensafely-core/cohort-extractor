*! version 1.0.0  29dec2014
program mestreg_estat
	version 14

	if "`e(cmd2)'" != "mestreg" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
