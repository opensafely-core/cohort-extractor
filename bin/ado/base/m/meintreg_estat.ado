*! version 1.0.0  08apr2015
program meintreg_estat
	version 13

	if "`e(cmd2)'" != "meintreg" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
