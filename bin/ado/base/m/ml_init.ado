*! version 3.2.0  23dec1998
/* ml init this:that=# that=# /this=# matname # [, skip copy] */
program define ml_init
	version 6
	ml_defd
	if `"`0'"'=="" {
		scalar $ML_f = .
		mat $ML_b[1,1] = J(1,$ML_k,0)
		exit
	}

	if "$ML_fvops" == "true" {
		local vv "version 11:"
	}

	`vv' _mkvec $ML_b, from(`0') update first error("initial vector")
	scalar $ML_f = .
end
