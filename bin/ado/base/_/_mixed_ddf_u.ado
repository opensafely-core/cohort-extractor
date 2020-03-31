*! version 1.0.7  28aug2019
program _mixed_ddf_u
	version 14

	syntax , dftypes(string) [ debug wmat(name) derivh(real 1e-8) ///
				   EIM OIM ]

	local is_kroger : list posof "kroger" in dftypes
	local is_satter : list posof "satterthwaite" in dftypes
	local is_anova  : list posof "anova" in dftypes

// Step 1: Determine the group to represent
	local ivars `e(ivars)' 
	tempvar touse obs
	qui gen `c(obs_t)' `obs' = _n
	qui gen byte `touse' = e(sample)
	local uivars : list uniq ivars

	local uall _all
	local hasall : list uall in uivars

	if `hasall' {
		tempvar one 
		qui gen byte `one' = 1 if e(sample)
		local uivars : subinstr local uivars "_all" "`one'", all
	}

// Step 2: Sort out by variable, if it exists

	if "`e(rbyvar)'" != "" {
		tempvar byvar
		sort `e(rbyvar)'
		qui egen long `byvar' = group(`e(rbyvar)') if e(sample)
	}

// Step 3: Deal with factor variables before reducing dataset
	
	local revars `e(revars)'
	local i 1
	foreach var in `revars' {
		if strpos("`var'", "R.") {
			tempname vv`i'
			local var : subinstr local var "R." ""
			qui egen long `vv`i'' = group(`var') if e(sample)
			local var `vv`i''
			qui sum `var' if e(sample)
			local varlevs `varlevs' `r(max)'
			local ++i
		}
		else {
			local varlevs `varlevs' 0
		}
		local vlist `vlist' `var'
	}
	local rrevars `vlist'

// Step 4: Get the time variable squared away, if it exists
	
	qui keep if `touse'  		// Can stop using `touse' now

	if "`e(timevar)'" != "" {
		tempvar time gap
		ProcessTimeVar `time' `gap' `byvar' 
	}

// Step 5: Sort the data
	
	sort `uivars' `byvar' `time' `obs'

// Setp 6: Setup ddf structure

	mata: _mixed_ddf_setup()

// Step 7: Get the rank of X and (X Z)
	
	local redim `e(redim)'
	local ivars `e(ivars)'			
	local ivars : subinstr local ivars "_all" "`one'", all
	local uivars : list uniq ivars
	local varlist_0 : colnames e(b)

	local nms
	local levelvars
	foreach nm in `uivars' {
		tempvar level
		local nms `nms' `nm'
		qui egen long `level' = group(`nms')
		local levelvars `levelvars' `level'
	}
		
	local rstructure `e(rstructure)'
	local rglabels `e(rglabels)'
	local reslabels : coleq e(b)

	mata: _mixed_ddf_get_rank()

// Step 8: get estimated variance-covariance matrix of beta

	mata: _mixed_ddf_get_Phi()

// Extra calculation for kroger and satterthwaite
if (`is_kroger' | `is_satter') {

	// extra setup
	local Vid : word 1 of `uivars'
	qui levelsof `Vid'
	local Vid_levels = r(levels)
	local w: word count `Vid_levels'

	tempname noomit rowsum
	local k_r = e(k_r)
	mata: st_numscalar("`rowsum'", rowsum(st_matrix("e(noomit)")))

	forvalues i = 1/`k_r' {
		tempname P`i'
		mat `P`i'' = J(`rowsum', `rowsum',0)
		mata: _mixed_ddf_setup_Pi("`P`i''",`i')  
	}

	forvalues i = 1/`k_r' {
		forvalues j = 1/`k_r' {
			tempname Q`i'`j'
			mat `Q`i'`j'' = J(`rowsum', `rowsum',0)
			mata: _mixed_ddf_setup_Qij("`Q`i'`j''",`i',`j')  
		}
	}

	tempname W 
	mat `W' = J(`k_r', `k_r',0)

	local vid_type : type `Vid'

	if (substr("`vid_type'",1,3) == "str") {
		local isStr = 1
	}
	else {
		local isStr = 0
	}

	// get into loop
	forvalues i = 1/`w' {
		local Vid_level : word `i' of `Vid_levels'

		preserve

		if (`isStr'==1) {
			qui keep if `Vid' == "`Vid_level'"
		}
		else { 
			qui keep if `Vid' == `Vid_level'
		}

		mata: _mixed_ddf_setup_extra()

 		// Step 9: Get R matrix and dR matrix

		mata: _mixed_ddf_get_R_matrix()

		// Step 10: Get random effect design matrix Z
	
		local redim `e(redim)'
		local ivars `e(ivars)'			
		local ivars : subinstr local ivars "_all" "`one'", all
		local uivars : list uniq ivars

		mata: _mixed_ddf_get_Z_matrix()

		// Step 11: Get random-effects variance matrix G and dG 
 	
		local ivars `e(ivars)'
		local uivars : list uniq ivars
		local revars `e(revars)'
		local i 1
		foreach lev in `uivars' {
			// get G matrix for each level
			tempname rmat`i'
			qui estat recovariance, relevel(`lev') noredim 
			mat `rmat`i'' = r(cov)

			local cnames : colnames `rmat`i''
			mata: _mixed_ddf_factor_up_G("`rmat`i''")
			mata: _mixed_ddf_get_G("`rmat`i''", `i')

			// get dG matrices for each level
			_mixed_ddf_get_dev_G `lev'
			mata: _mixed_ddf_factor_up_dG()

			local ++i
		}

		// expand
		local ivars `e(ivars)'
		local ivars : subinstr local ivars "_all" "`one'", all
		local uivars : list uniq ivars	

		mata: _mixed_ddf_get_G_matrix()
		mata: _mixed_ddf_get_dev_G_matrix()

		// Step 12: get covariance matrix V
	
		mata: _mixed_ddf_get_V_matrix()

		// Step 13: get derivative of V matrix

		mata: _mixed_ddf_get_dev_V_matrix()

		// Step 14: get noomitted fixed effect design matrix X

		mata: _mixed_ddf_get_X_matrix()

		// Step 15: get Pi matrix

		mata: _mixed_ddf_get_A()
		forvalues i = 1/`k_r' {
			mata: _mixed_ddf_get_Pi("`P`i''",`i')
		}

		// Step 16: get Qij matrix

		forvalues i = 1/`k_r' { 
			forvalues j = 1/`k_r' {
				mata: _mixed_ddf_get_Qij("`Q`i'`j''",`i',`j')  
			}
		}

		// Step 17: get W matrix

		if "`wmat'" == "" {
			if "`oim'" == "" {
				mata: _mixed_ddf_get_W("`W'")
			}
		}

		restore
	} // end of loop

	forvalues i = 1/`k_r' {
		mata: _mixed_ddf_store_Pi("`P`i''", `i')
	}

	forvalues i = 1/`k_r' {
		forvalues j = 1/`k_r' {
			mata: _mixed_ddf_store_Qij("`Q`i'`j''", `i', `j')
		}
	}

	if "`wmat'" != "" {
		mata: _mixed_ddf_store_W("`W'", "`wmat'")
	}
	else mata: _mixed_ddf_store_W("`W'")

	// Step 18: get Phi_A matrix

	if (`is_kroger') {
		mata: _mixed_ddf_get_PhiA_matrix()
	}

} // end if (`is_kroger' | `is_satter')

end

program ProcessTimeVar, sort
	args time gap byvar
	
	local struct `e(rstructure)'
	local tvar `e(timevar)'

	if "`byvar'" == "" {
		tempvar byvar
		qui gen `byvar' = 1
	}
        if inlist("`struct'", "ar", "ma", "toeplitz") {
        	sort `byvar' `tvar'
      		qui by `byvar': gen long `time'=`tvar'-`tvar'[1] + 1
		qui by `byvar': gen byte `gap' = `time' != _n 
		qui by `byvar': replace `gap' = `gap'[_N]
	}
	else if inlist("`struct'", "unstructured", "banded") {
		tempname tmap
		mat `tmap' = e(tmap)
		qui gen long `time' = 0
		local levs = colsof(`tmap')
		forvalues i = 1 /`levs' {
			qui replace `time' = `i' if `tmap'[1,`i'] == `tvar'	
		}
		sort `byvar' `time'
		qui by `byvar': gen byte `gap' = (`time'!=_n) | (_N != `levs')
		qui by `byvar': replace `gap' = `gap'[_N]
	}
	else {	// exponential
		qui gen double `time' = `tvar'
		qui gen byte `gap' = 0
		exit
	}

end

program	_mixed_ddf_get_dev_G

	args level

	local ivars `e(ivars)'
	local uivars : list uniq ivars
	local eqnum : list posof "`level'" in uivars

	local revars `e(revars)'
	local w : word count `ivars'
	local subeq 0
	local sdim 0 

	forval i = 1/`w' {
		local lev : word `i' of `ivars'
		local dim : word `i' of `e(redim)'
		local type : word `i' of `e(vartypes)'

		if "`lev'"=="`level'" {
			local ++subeq
			local types `types' `type'
			local nlev `dim'

			forval j = 1/`dim' {
				gettoken var revars : revars

				// Deal with factor variable
				if (strpos("`var'","R.") & ///
				    "`type'"=="Exchangeable") {
					local nlev 2
					local Rname: subinstr local var "R." ""
					local var Ri.`Rname' Rj.`Rname'
				}
				local cnames `cnames' `var'
			}
			local dims `dims' `nlev'
			local sdim = `sdim' + `nlev'
		}
		else {
			forval j = 1/`dim' {
				gettoken var revars: revars  //consume
			}
		}		
	}

	if `sdim' {
		local start 1

		forval i = 1/`subeq' {
			gettoken type types : types
			gettoken dim dims : dims

			if (`dim'>0) {
				mata: analytic_dG("`type'", `eqnum',`i', ///
					`dim',`sdim',`start')
			}

			local start = `start' + `dim'
		}

	}

end


