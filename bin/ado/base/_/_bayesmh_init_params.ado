*! version 1.1.2  24sep2019
program _bayesmh_init_params
	version 14.0

	args mcmcobject initial optional chain initall

	if `"`chain'"' == "" {
		local chain .
	}
	if `"`initall'"' == "" {
		local initall 0
	}

	mata: `mcmcobject'.set_chain_rngstream(`chain')

	_mcmc_parse expand `initial'
	local initial `s(eqline)'

	while `"`initial'"' != "" {
		gettoken param initial : initial, bind

		// check for row-vector initialization
		capture confirm matrix `param'
		if !_rc {
			local minit `param'
			local nc : colsof `minit'
			local nr : rowsof `minit'
			if `nc' >= 1 & `nr' == 1 {
				local pars : colfullnames `param'
				local j 1
				local adddinit
				foreach tok of local pars {
					if regexm(`"`tok'"', "^{.+}") {
						local adddinit `"`adddinit' `tok' `=`minit'[1, `j']'"'
					}
					else {
						local adddinit `"`adddinit' {`tok'} `=`minit'[1, `j']'"'
					}
					local j = `j' + 1
				}
				local initial `adddinit' `initial'
				continue
			}
		}

		local 1
		while regexm(`"`param'"', "^{.+}") {
			if !regexm(`"`param'"', "^{.+}$") {
				di as err "invalid initial parameter " ///
					`"{bf:`param'} in option "' ///
					"{bf:initial()}" 
				exit 198
			}
			local 1 `"`1' `param'"'
			gettoken param initial : initial, bind
		}

		if `"`1'"' == "" {
			if `initall' {
				di as err "invalid {bf:initall()} specification"
			}
			else if `optional' | `chain' == . {
				di as err "invalid {bf:initial()} specification"
			}
			else {
				di as err "invalid {bf:init`chain'()} specification"
			}
			exit 198
		}

		local 2 `param'

		tempname tmat
		tempname tsc
		local ismat 0
		local isexpr 0
		//local curstate = c(rngstate)
		capture confirm number `2'
		if _rc {
			capture scalar `tsc' = `2'
			local isexpr 1
		}
		if _rc {
			capture matrix `tmat' = `2'
			local ismat = !_rc
			local isexpr 0
		}
		//qui set rngstate `curstate'
		if _rc {
			di as err "invalid initial for {bf:`1'}"
			exit 480
		}

		if `ismat' {
			gettoken param 1 : 1
			while `"`param'"' != "" {
				local matname `2'
				capture matrix `tmat' = `2'

				mata: mcov = st_matrix("`tmat'")

				_mcmc_parse word `param'
				if `"`s(word)'"' == "" & !`optional' {
					di as err "parameter {bf:`matname'} " ///
						"not found in {bf:initial()}"
					gettoken param 1 : 1
					continue
				}
				if "`s(prefix)'" != "." {
					local param `s(prefix)':`s(word)'
				}
				else local param `s(word)'
	
				if "`s(matval)'" != "1" & !`optional' {
					di as err `"parameter `param' "' ///
					   "not found in option {bf:initial()}"
					exit 480
				}
				if !issymmetric(`tmat') {
					di as err `"matrix {bf:`matname'} "' ///
						"must be symmetric"
					exit 505
				}
				if $MCMC_debug {
					di `"init `param' -> `matname'"'
					matlist `tmat'
				}

				mata: `mcmcobject'.init_mpar(	///
					"`param'", mcov, `optional', `chain')
				mata: mata drop mcov

				gettoken param 1 : 1
			}
		}
		else {
			gettoken param 1 : 1
			while (`"`param'"' != "") {
				_mcmc_parse word `param'
				if `"`s(word)'"' == "" & !`optional' {
					di as err "parameter {bf:`param'} " ///
						"not found in {bf:initial()}"
					gettoken param 1 : 1
					continue
				}
				if "`s(prefix)'" != "." {
					local param `s(prefix)':`s(word)'
				}
				else local param `s(word)'
				if "`s(matval)'" == "1" & !`optional' {
					di as err `"parameter `param' "' ///
					   "not found in option {bf:initial()}"
					exit 480
				}
				
				if `isexpr' {
					mata: `mcmcobject'.init_upar_expr( ///
					"`param'", `"`2'"', `optional', `chain')
				}
				else {
					capture scalar `tsc' = `2'
					mata: sinit = st_numscalar("`tsc'")
					mata: `mcmcobject'.init_upar(	///
					"`param'", sinit, `optional', `chain')					
					
					if $MCMC_debug {
						di `"init `param' -> `2'"'
						di `tsc'
					}
				}

				gettoken param 1 : 1
			}
		}
	}

	mata: `mcmcobject'.restore_current_rng()
end
