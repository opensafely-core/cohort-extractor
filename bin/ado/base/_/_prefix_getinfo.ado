*! version 1.0.0  30may2017
program _prefix_getinfo
	args H I

	capture matrix `H' = get(H)
	if _rc {
		c_local H
		c_local I
		exit
	}
	if "`I'" != "" {
		mata: st_matrix("`I'", st_matrixcolstripe_fvinfo("e(b)"))
	}
end
