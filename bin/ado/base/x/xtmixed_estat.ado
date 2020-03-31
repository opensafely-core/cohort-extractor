*! version 1.2.1  11feb2013
program xtmixed_estat
	version 9

	if !inlist("`e(cmd)'","xtmixed","mixed") {
		error 301
	}

	_xtme_estat `0'
	exit
end

exit
