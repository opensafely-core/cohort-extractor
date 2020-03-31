*! version 1.0.0  14dec2018

program _ic_header
	args diconly
	if "`diconly'" == "" { 
		di
		di as txt "Bayesian information criteria"
		
	}
	else {
		di
		di as txt "Deviance information criterion"
	}
end

program _bayesstats_ic, rclass
	syntax [anything], [			///
		BASEModel(string)		///
		BAYESFactor			///
		MARGLMethod(string)		///
		diconly				///
		CHAINs(string) SEPCHAINs	///
		]

	if `"`chains'"' == "_all" {
		local chains
		cap confirm e(nchains)
		if !_rc {
			local chains `e(allchains)'
		}
	}

	local nchains: word count `e(allchains)'
	if "`chains'" != "" {
		local nchains: word count `chains'
	}

	// get names of estimation results
	est_expand `"`anything'"', default(.) starok
	local names `r(names)'
	local norig : list sizeof names
	local names : list uniq names
	local nest  : list sizeof names
	if (`nest'==0) {
		di as txt "no stored estimation results"
		exit
	}
	if (`nest'<`norig') {
		di as txt "note: duplicate estimation results are omitted"
	}
	
	// check option basemodel()
	if (`:list sizeof basemodel'>1) {
		di as err "{bf:basemodel()}: only one estimation name allowed"
		exit 198
	}
	if (`"`basemodel'"'=="") {
		gettoken basemodel : names
		local bmpos 1
	}
	else {
		local bmpos : list posof "`basemodel'" in names
		if (`bmpos'==0) {
			di as err "{p}{bf:basemodel()}: estimation name"
			di as err `"{bf:`basemodel'} is not one of specified"'
			di as err "estimation names{p_end}"
			exit 198
		}
	}
	
	// check option marglmethod()
	_bayesmh_chk_marglmethod marglmethod mllname mlleresult : ///
							`"`marglmethod'"'

	// loop over estimation results and store ln(ML) and DIC
	tempname lmlvec dicvec bfvec baselml numchains
	
	// display results
	tempname mcmcsum
	
	// return results
	return clear 
	
	if "`sepchains'" == "" {
		
		mat `lmlvec' = J(`nest',1,.)
		mat `dicvec' = J(`nest',1,.)
		mat `numchains' = J(`nest',1,.)
		_bayes_estloop rownames : `"`names'"' ///
`"_bayesstatsic_compute `mlleresult' `dicvec' `lmlvec' `numchains' "`chains'""'
	
		// compute Bayes factors
		scalar `baselml' = `lmlvec'[`bmpos',1]
		mat `bfvec' = `lmlvec' - `baselml'*J(`nest',1,1)
		if `"`bayesfactor'"' == "" {
			local bflab "log(BF)"
		}
		else {
			mata: st_matrix("`bfvec'", exp(st_matrix("`bfvec'")))
			local bflab "BF"
		}
		mat `bfvec'[`bmpos',1] = .

		_ic_header `diconly' 

		local nmaxchains 0
		forvalues i = 1/`nest' {
			local ichains = `=`numchains'[`i',1]'
			if `nmaxchains' < `ichains' {
				local nmaxchains `ichains'
			}
		}

		local fmts
		if `nmaxchains' < 2 {
			if "`diconly'" == "" { 
				matrix `mcmcsum' = (`dicvec',`lmlvec',`bfvec')
				matrix colnames `mcmcsum' = "DIC" "log(ML)" "`bflab'"
				matrix rownames `mcmcsum' = `rownames'	
			}
			else {
				matrix `mcmcsum' = (`dicvec')
				matrix colnames `mcmcsum' = "DIC"
				matrix rownames `mcmcsum' = `rownames'	
			}
		}
		else {
			if "`diconly'" == "" { 
				matrix `mcmcsum' = (`numchains',`dicvec',`lmlvec',`bfvec')
				matrix colnames `mcmcsum' = "Chains" "Avg DIC" "Avg log(ML)" "`bflab'"
				matrix rownames `mcmcsum' = `rownames'	
				local fmts ,formats(%7.0g %9.4f %9.4f %9.4f)
			}
			else {
				matrix `mcmcsum' = (`numchains',`dicvec')
				matrix colnames `mcmcsum' = "Chains" "Avg DIC"
				matrix rownames `mcmcsum' = `rownames'	
				local fmts ,formats(%7.0g %9.4f)
			}
		}

		if "`chains'" != "" {
			if `nchains' == 1 {
				di as txt "Chain `chains'"
			}
			else {
				di as txt "Chains: `chains'"
			}
		}

		di
		qui _matrix_table `mcmcsum' `fmts'
		local tablen  = `s(width)'
		_matrix_table `mcmcsum' `fmts'

		return matrix ic = `mcmcsum'
	}
	else {

	if `"`chains'"' == "" {
		local chains `e(allchains)'
	}

	_ic_header `diconly'

	foreach chain of local chains {
	
		mat `lmlvec' = J(`nest',1,.)
		mat `dicvec' = J(`nest',1,.)
		mat `numchains' = J(`nest',1,.)
		_bayes_estloop rownames : `"`names'"' ///
`"_bayesstatsic_compute `mlleresult' `dicvec' `lmlvec' `numchains' "`chain'""'
	
		// compute Bayes factors
		scalar `baselml' = `lmlvec'[`bmpos',1]
		mat `bfvec' = `lmlvec' - `baselml'*J(`nest',1,1)
		if `"`bayesfactor'"' == "" {
			local bflab "log(BF)"
		}
		else {
			mata: st_matrix("`bfvec'", exp(st_matrix("`bfvec'")))
			local bflab "BF"
		}
		mat `bfvec'[`bmpos',1] = .

		if "`diconly'" == "" { 
			matrix `mcmcsum' = (`dicvec',`lmlvec',`bfvec')
			matrix colnames `mcmcsum' = "DIC" "log(ML)" "`bflab'"
			matrix rownames `mcmcsum' = `rownames'	
		}
		else {
			matrix `mcmcsum' = (`dicvec')
			matrix colnames `mcmcsum' = "DIC"
			matrix rownames `mcmcsum' = `rownames'	
		}
	
		di
		di as txt "Chain `chain'"
		qui _matrix_table `mcmcsum'
		local tablen  = `s(width)'
		_matrix_table `mcmcsum'

		return matrix ic_chain`chain' = `mcmcsum'
		
	}
	
	}
	
	if "`diconly'" == "" { 
		di as txt "{p 0 6 0 `tablen'}Note: Marginal likelihood (ML) " ///
			"is computed using `mllname' approximation.{p_end}"
		return scalar bayesfactor	= ("`bayesfactor'"!="")
		return local  marglmethod	= "`marglmethod'"
		return local  basemodel		= "`basemodel'"
	}

	return local  names	= "`names'"
	return local  chains	= `"`chains'"'
	return scalar nchains   = `nchains'
end
