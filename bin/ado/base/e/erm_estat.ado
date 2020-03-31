*! version 1.0.0  23jan2017
program erm_estat
	version 15
	gettoken sub rest: 0, parse(" ,")
	local lsub = length(`"`sub'"')

	if `"`sub'"' == "teffects" {
		_erm_teffects `rest'
		exit
	}
	else {
		estat_default `0'
		exit
	}
end
