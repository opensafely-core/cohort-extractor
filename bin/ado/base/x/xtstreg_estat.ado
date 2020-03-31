*! version 1.0.0  05jan2015
program xtstreg_estat
	version 14

	if "`e(cmd2)'" != "xtstreg" {
		error 301
	}

	meglm_estat `0'
	exit
end

exit
