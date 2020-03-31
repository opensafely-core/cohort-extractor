*! version 1.0.0  03jan2005
program mata_matsave
	version 9

	// : mata matsave filename namelist [, replace]

	gettoken fn 0 : 0, parse(" ,")
	if `"`fn'"'=="" {
		di as err "nothing found where filename expected"
		exit 198
	}
	syntax anything(id="matrix name") [, REPLACE]
	mata: mmat_save(`"`fn'"', "`anything'", "`replace'")
end
exit

// see -viewsource mmat_.mata- for mmat_save().
