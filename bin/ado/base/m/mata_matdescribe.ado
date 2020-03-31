*! version 1.0.0  05jan2005
program mata_matdescribe
	version 9

	// : mata matdescribe <filename>

	gettoken fn 0 : 0, parse(" ,")
	if `"`fn'"'=="" {
		di as err "nothing found where filename expected"
		exit 198
	}
	syntax 
	mata: mmat_describe(`"`fn'"')
end
exit

// see -viewsource mmat_.mata- for mmat_describe()
