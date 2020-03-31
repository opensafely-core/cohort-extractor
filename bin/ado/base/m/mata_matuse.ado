*! version 1.0.0  03jan2005
program mata_matuse
	version 9

	// : mata matuse filename [, replace]

	gettoken fn 0 : 0, parse(" ,")
	if `"`fn'"'=="" {
		di as err "nothing found where filename expected"
		exit 198
	}
	syntax [, REPLACE]
	mata: mmat_use(`"`fn'"', "`replace'")
end
exit

// see -viewsource mmat_.mata- for mmat_use()
