*! version 1.0.0  29may2014

program mswitch_p, properties(notxb)
	version 14.0

	if ("`e(cmd)'" != "mswitch") {
		di as err "{p 0 8 2}{help mswitch##|_new:mswitch} estimation"
		di as err "results not found{p_end}"
		exit 301
	}
	_mswitch_p `0'

end
