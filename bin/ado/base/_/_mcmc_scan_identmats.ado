*! version 1.0.0  26jan2016
program _mcmc_scan_identmats, sclass
	version 14.0

	local eqline `"`0'"'
	// scan for I(#) matrices
	while regexm(`"`eqline'"', `" I\([1-9][0-9]*\)"') {
		local lmat = regexs(0)
		tokenize `lmat', parse("()")
		capture confirm number `3'
		if _rc {
		 	di as err `"invalid matrix I(`3')"'
		 	exit 198
		}

		local tmat _matrix_I`3'
		global MCMC_tempmats `MCMC_tempmats' `tmat'

		matrix `tmat' = I(`3')
		local eqline = regexr(`"`eqline'"', ///
			`" I\([1-9][0-9]*\)"', "`tmat'")
		local tempidentmat `tempidentmat' `tmat'(`3')
	}
	while regexm(`"`eqline'"', `",I\([1-9][0-9]*\)"') {
		local lmat = regexs(0)
		gettoken next lmat : lmat, parse(",")
		tokenize `lmat', parse("()")
		capture confirm number `3'
		if _rc {
	 		di as err `"invalid matrix I(`3')"'
	 		exit 198
		}
		
		local tmat _matrix_I`3'
		global MCMC_tempmats `MCMC_tempmats' `tmat'
		
		matrix `tmat' = I(`3')
		local eqline = regexr(`"`eqline'"', ///
			`",I\([1-9][0-9]*\)"', ",`tmat'")
		local tempidentmat `tempidentmat' `tmat'(`3')
	}
	while regexm(`"`eqline'"', `"\(I\([1-9][0-9]*\)"') {
		local lmat = regexs(0)
		tokenize `lmat', parse("()")
		mac shift
		capture confirm number `3'
		if _rc {
		 	di as err `"invalid matrix I(`3')"'
		 	exit 198
		}

		local tmat _matrix_I`3'
		global MCMC_tempmats `MCMC_tempmats' `tmat'

		matrix `tmat' = I(`3')
		local eqline = regexr(`"`eqline'"', ///
			`"\(I\([1-9][0-9]*\)"', "(`tmat'")
		local tempidentmat `tempidentmat' `tmat'(`3')
	}
	sreturn local eqline = `"`eqline'"'
end
