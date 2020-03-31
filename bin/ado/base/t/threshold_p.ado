*! version 1.0.0  18may2016

program threshold_p, properties(notxb)
	version 14.0

	if ("`e(cmd)'" != "threshold") {
		di as err "{p 0 8 2}{help threshold##|_new:threshold} "
		di as err "estimation results not found{p_end}"
		exit 301
	}
	_threshold_p `0'

end
