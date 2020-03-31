*! version 1.0.2  13feb2015 
program define _mat_mult_arma
	version 12
	
	args 	   a		/* 1st source and target matrix (may not exist)
		*/ b		/* 2nd source matrix (may not exist)
		*/ delta_a	/* seasonal delta for matrix a
		*/ delta_b	/* seasonal delta for matrix b 
		*/ sign		/* sign for multiplied terms, only - reqd */

	tempname a0

	if "`sign'" == "" { 
		local sign + 
	}

	LagsOfB lags_a maxlag_a : `a'
	LagsOfB lags_b maxlag_b : `b'

	if ! (`maxlag_a' | `maxlag_b') { 
		exit					/* nothing to do */
	}

	if `maxlag_a' {
		mat `a0' = `a'
	}

	mat `a' = J(1, `maxlag_a'*`delta_a' + `maxlag_b'*`delta_b', 0)

					/* add all a and b coefs directly into 
					 * new matrix */
	local c 1
	foreach l of local lags_a {
		mat `a'[1,`l'*`delta_a'] = `a0'[1, `c++']
	}

	local c 1
	foreach l of local lags_b {
		mat `a'[1,`l'*`delta_b'] = `a'[1,`l'*`delta_b'] + `b'[1, `c++']
	}

					/* add all multiplicative coefs into
					 * new matrix 			*/

	local c_a 1
	foreach l_a of local lags_a {
		local c_b 1
		foreach l_b of local lags_b {
			local delta = `l_a'*`delta_a' + `l_b'*`delta_b'
			mat `a'[1,`delta'] = `a'[1,`delta'] `sign'	/*
			    */ `a0'[1,`c_a'] * `b'[1,`c_b++']

		}
		local ++c_a
	}

end

program define LagsOfB

	args lagsmac maxlagmac colon b

	capture di `b'[1,1]
	if _rc {					/* no matrix */
		c_local `maxlagmac' 0
		c_local `lagsmac'
		exit
	}

	local names : colnames `b'
	local names : subinstr local names "L." "L1.", all

	gettoken tname : names
	local lead_char = usubstr("`tname'", 1, 1)	/* allow L or c */
	gettoken unused tname : tname, parse(.)

	if "`tname'" != "" {
		local names : subinstr local names "`tname'" "", all
	}
	local names : subinstr local names "`lead_char'" "", all

	c_local `maxlagmac' : word `:word count `names'' of `names'
	c_local `lagsmac' `names'
end

exit

_mat_mult_arma returns the result of seasonally multiplying two
AR (or MA) parameter vectors.

                same as L1.n12 L2.n24 with season = 12
		        |
		+-------+-------+
                |               |
(L1.n1 L2.n2) * (L12.n12 L24.n24) = L1.n1 L2.n2 L12.n12 L13.n1*n12
				    L14.n1*n24  L24.n24 L25.n1*n24
				    L26.n2*n24
