*! version 1.0.1  25feb2004
program _m2scalar
	version 8

	gettoken sname exp : 0 , parse(" =")

	confirm name `sname'

	tempname m
	// note that -exp- should start with "="
	matrix `m' `exp'

	if colsof(`m') > 1 | rowsof(`m') > 1 {
		dis as err "matrix expression does not return scalar (1x1 matrix)"
		exit 503
	}

	scalar `sname' = el(`m',1,1)
end
exit
