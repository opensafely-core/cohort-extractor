*! version 1.0.0  19mar2007
program mds_dataheader
	version 10

	if "`e(cmd)'" == "mds" {
		local nvar : word count `e(varlist)'
		dis _col(5) as txt `"{ralign 13:`e(dtype)'}: "' ///
		    `"{res:`e(dname)'}, computed on {res:`nvar'} variables"'

		if "`e(s2d)'" != "" {
			String_s2d `e(s2d)'
			dis _col(5) as txt `"dissimilarity: `r(s2d_str)'"'
		}
	}

	if "`e(cmd)'" == "mdslong" {
		dis _col(5) as txt `"`e(dtype)' variable: "' ///
		    `"{res:`e(depvar)'} in long format"'

		if "`e(s2d)'" != "" {
			String_s2d `e(s2d)'
			dis _col(11) as txt `"dissimilarity: `r(s2d_str)'"'
		}
	}

	if "`e(cmd)'" == "mdsmat" {
		dis _col(5) as txt `"`e(dtype)' matrix: "' ///
		   `"{res:`e(dmatrix)'}"'

		if "`e(s2d)'" != "" {
			String_s2d `e(s2d)'
			dis _col(9) as txt `"dissimilarity: `r(s2d_str)'"'
		}
	}

	dis
end


program String_s2d, rclass
	args s2d

	if "`s2d'" == "oneminus" {
		local str `"1-similarity"'
	}
	else if "`s2d'" == "standard" {
		local str `"sqrt(2(1-similarity))"'
	}
	else { // shouldn't get here
		local str `"`s2d'"'
	}
	return local s2d_str `str'
end
exit

