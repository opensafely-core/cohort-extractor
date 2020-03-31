*! version 1.0.1  20jun2014
program menbreg_estat
	version 13

	if "`e(cmd2)'" != "menbreg" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
