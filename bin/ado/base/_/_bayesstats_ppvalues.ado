*! version 1.0.7  08apr2019

program _bayesstats_ppvalues, rclass
	version 16.0

	syntax [anything] [using], MCMCOBJECT(string) ///
		[CHAINs(string) SEPCHAINs NOLEGend]

	if `"`using'"' != "" {
		gettoken tok using : using
		_bayespredict estrestore `"`using'"'
		local using `s(predfile)'
		if `"`anything'"' == "" {
			local anything `s(predynames)' `s(predfnames)'
		}
		if `"`chains'"' == "" {
			local chains `"`s(chains)'"'
		}
		global BAYESPR_using `using'
	}
	else {
		di as err "you must specify {bf:using {it:predfile}}"
		exit 198
	}

	if "`sepchains'" != "" && `"`chains'"' == "" {
		local chains _all
	}
	local nchains = e(nchains)
	if `"`chains'"' != "" {
		_bayes_chains parse `"`chains'"'
		local chains `r(chains)'
		local nchains : list sizeof chains 
	}

	tempname msum matpvals

if "`sepchains'" != "" {

	di
	di as txt "Posterior predictive summary"

	local firstchain 0
	foreach ch of local chains {

		cap _bayesstats summary `anything' using `using', `options' ///
			mcmcobject(`mcmcobject') chains(`ch') matpvals(`matpvals')
		local rc = _rc
		if `rc' {
			cap nois _bayesstats summary `anything' using `using',	///
				mcmcobject(`mcmcobject') `options'		///
				chains(`ch') matpvals(`matpvals')
			exit `rc'
		}
		if `firstchain' == 0 {
			local firstchain 1
			local mcmcsize = `r(mcmcsize)'
			local rownames `"`r(names)'"'
			local exprlegend
			local exprtoks `"`r(exprnames)'"'
			local i 0
			foreach tok of local exprtoks {
				local i = `i' + 1
				local exprlegend `exprlegend' ///
					(`tok'):(`r(expr_`i')')
			}
			if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
				di 
				_mcmc_expr legend `"`exprlegend'"'
			}
		}

		matrix `msum' = r(summary)
		matrix `msum' = (`msum'[.,1..2])

		matrix `msum' = (`msum', `matpvals')
		matrix colnames `msum' = "Mean" "Std. Dev." "E(T_obs)"  "P(T>=T_obs)"

		// display results
		local col1len  = 13
		quietly _matrix_table `msum', formats(%9.0g %9.0g %9.0g %9.0g) `diopts'
		local linesize = `s(width)'
		local col1len  = `s(width_col1)'
		local labpos = `linesize'-27
		local eqpos  = `linesize'-10
		local numpos = `linesize'-9

		di
		di as txt "Chain `ch'" _col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="  _col(`numpos') as res %10.0fc `mcmcsize'
		
		/* extra separation line */
		di

		local col1sep = `col1len' + 1
		local nlab    = `col1len' - 1
		local hpadlength = `linesize' - `col1len' - 1
		
		di as txt "{hline `col1len'}"	///
			   _col(`col1sep') "{c TT}" "{hline `hpadlength'}" 
		di  _col(`nlab') as txt `"T"' _col(`col1sep') as txt "{c |}" _c

		local meanpos = `col1sep' + 7
		local sdpos   = `col1sep' + 14
		local tpos    = `col1sep' + 25
		local pppos   = `col1sep' + 35
		di  _col(`meanpos') as txt "Mean"	 	 ///
			_col(`sdpos') as txt "Std. Dev."	///
			_col(`tpos') as txt "E(T_obs)"		///
			_col(`pppos') as txt "P(T>=T_obs)"
			
		_matrix_table `msum', notitles `diopts'
		
		mat `msum'`ch' = `msum'

	} // foreach ch of local chains

	local tablen  = `s(width)'
	di as txt "{p 0 6 0 `tablen'}Note: P(T>=T_obs) close to 0 or 1 indicate lack of fit{p_end}"
	
	return clear

	foreach ch of local chains {
		return matrix summary_chain`ch' = `msum'`ch'
	}

	return local chains	= `"`chains'"'
	_mcmc_expr return `"`exprlegend'"'
	return add
	return local  names	= `"`rownames'"'
	return scalar nchains   = `nchains'
	return scalar mcmcsize  = `mcmcsize'

	exit
}

	if `"`chains'"' != "" {
		local options `options' chains(`chains')
	}

	cap _bayesstats summary `anything' using `using', ///
		mcmcobject(`mcmcobject') `options' matpvals(`matpvals')
	local rc = _rc
	if `rc' {
		cap nois _bayesstats summary `anything' using `using', ///
			mcmcobject(`mcmcobject') `options' matpvals(`matpvals')
		exit `rc'
	}

	local mcmcsize = `r(mcmcsize)'
	local rownames `"`r(names)'"'

	local exprlegend
	local exprtoks `"`r(exprnames)'"'
	local i 0
	foreach tok of local exprtoks {
		local i = `i' + 1
		local exprlegend `exprlegend' (`tok'):(`r(expr_`i')')
	}

	if `"`nolegend'"' == "" & `"`exprlegend'"' != "" {
		di 
		_mcmc_expr legend `"`exprlegend'"'
	}
	
	local labchains
	if "`chains'" != "" {
		local labchains "Chains: `chains'"
		if `nchains' == 1 {
			local labchains "Chain `chains'"
		}
		local labchains = abbrev("`labchains'", 23)
	}
	
	matrix `msum' = r(summary)
	matrix `msum' = (`msum'[.,1..2])

	matrix `msum' = (`msum', `matpvals')
	matrix colnames `msum' = "Mean" "Std. Dev." "E(T_obs)"  "P(T>=T_obs)"
	//matrix rownames `msum' = `rownames'

	// display results
	local col1len  = 13
	quietly _matrix_table `msum', formats(%9.0g %9.0g %9.0g %9.0g) `diopts'
	local linesize = `s(width)'
	local col1len  = `s(width_col1)'
	local labpos = `linesize'-27
	local eqpos  = `linesize'-10
	local numpos = `linesize'-9

	di
	if `nchains' > 1 | "`chains'" != "" {
		di as txt "Posterior predictive summary"	///
			_col(`labpos') _col(`labpos') 		///
			as txt "Number of chains"		///
			_col(`eqpos') "=" as res %10.0fc `nchains'

		di as txt "`labchains'"					///
			_col(`labpos') as txt "MCMC sample size"	///
			_col(`eqpos') "=" as res %10.0fc `mcmcsize'
	}
	else {
		di as txt "Posterior predictive summary"	///
		_col(`labpos') as txt "MCMC sample size"	///
		_col(`eqpos') "="				///
		as res %10.0fc `mcmcsize'
	}
	/* extra separation line */
	di

	local col1sep = `col1len' + 1
	local nlab    = `col1len' - 1
	local hpadlength = `linesize' - `col1len' - 1
	
	di as txt "{hline `col1len'}"	///
		   _col(`col1sep') "{c TT}" "{hline `hpadlength'}" 
	di  _col(`nlab') as txt `"T"' _col(`col1sep') as txt "{c |}" _c

	local meanpos = `col1sep' + 7
	local sdpos   = `col1sep' + 14
	local tpos    = `col1sep' + 25
	local pppos   = `col1sep' + 35
	di  _col(`meanpos') as txt "Mean"	 	 ///
		_col(`sdpos') as txt "Std. Dev."	///
		_col(`tpos') as txt "E(T_obs)"		///
		_col(`pppos') as txt "P(T>=T_obs)"
		
	_matrix_table `msum', notitles `diopts'

	local tablen  = `s(width)'
	di as txt "{p 0 6 0 `tablen'}Note: P(T>=T_obs) close to 0 or 1 indicates lack of fit.{p_end}"
	
	return clear
	
	return matrix summary   = `msum'

	return local chains	= `"`chains'"'
	_mcmc_expr return `"`exprlegend'"'
	return add
	return local  names	= `"`rownames'"'
	return scalar nchains   = `nchains'
	return scalar mcmcsize  = `mcmcsize'

	exit `rc'
end
