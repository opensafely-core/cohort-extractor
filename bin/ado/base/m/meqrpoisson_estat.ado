*! version 1.0.0  29may2013
program meqrpoisson_estat
	version 13

	if "`e(cmd)'" != "meqrpoisson" {
		error 301
	}

	_xtme_estat `0'
	exit
end

exit
