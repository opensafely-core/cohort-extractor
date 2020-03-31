*! version 1.0.1  01feb2013
program xtmelogit_estat
	version 10

	if !inlist("`e(cmd)'","xtmelogit","meqrlogit") {
		error 301
	}

	_xtme_estat `0'
	exit
end

exit
