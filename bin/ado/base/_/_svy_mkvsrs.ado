*! version 1.0.1  23nov2004
program define _svy_mkvsrs, eclass
	version 8
	args Vsrs srssub

/* Compute Vsrswr if fpc() specified. */
	if "`e(fpc)'`e(fpc1)'"!="" { /* create V_srswr matrix */
		tempname f
		if `"`srssub'"' == "" {
			scalar `f' = 1/(1-e(N)/e(N_pop))
		}
		else    scalar `f' = 1/(1-e(N_sub)/e(N_subpop))

		if `f'==. {
			scalar `f' = 0
		}

		tempname Vsrswr
		matrix `Vsrswr' = `f'*`Vsrs' /* unwind fpc on Vsrs */
		ereturn matrix V_srswr `Vsrswr'
	}
	ereturn matrix V_srs `Vsrs'

end

