*! version 1.0.2  03jul2011
program sem_estat_summ, rclass sortpreserve
	version 12

	if "`e(cmd)'" != "sem" {
		error 301
	}

	quietly ssd query
	if (r(isSSD)) {
		dis as err ///
"estat summarize not possible with summary statistics data"
		exit 498
	}
	
	capture assert e(sample)==0
	if !_rc {
		dis as err "e(sample) information not available"
		exit 498
	}

	syntax  [anything(name=eqlist)] [, 	/// ignored
		EQuation			/// ignored
		GROup				///
		GROup2(passthru)		///
		*				///
		]	
		
	if "`equation'"!="" {
		dis as txt "after sem, option equation ignored"
		local equation
	}
	if `:length local group2' {
		dis as err "group() option not allowed; specify group"
		exit 198
	}

	local vlist `e(oyvars)' `e(oxvars)' 
	if `:length local eqlist' {
		local vlist `eqlist'
	}
	confirm numeric variable `vlist' 
	local ng `e(N_groups)'
	tempname stats GrpVal
	if "`e(method)'" == "mlmv" {
		local options `options' misswarning
	}
	if `:length local group' {
		if "`e(groupvar)'"!="" {
			capture confirm variable `e(groupvar)'
			if _rc {
			  di as err "group() variable `e(groupvar)' not found"
			  exit 111
			}
		}
		else {
			di as err "no group() variable found"
			exit 498
		}
		matrix `GrpVal' = e(groupvalue)
		forvalues g = 1/`ng' {
			sem_groupheader `g', noafter nohline
			local grpval = `GrpVal'[1,`g'] 
			estat_summ `vlist', `options' ///
				group(`e(groupvar)'==`grpval')
			matrix `stats' = r(stats)
			return matrix stats_`g' = `stats'
		}	
		return scalar N_groups = `ng'
	}
	else {
		estat_summ `vlist' , `options'
		matrix `stats' = r(stats)
		return matrix stats = `stats'
	}
end

exit
