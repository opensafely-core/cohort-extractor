*! version 1.0.1  20jun2014
program meologit_estat
	version 13

	if "`e(cmd2)'" != "meologit" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
