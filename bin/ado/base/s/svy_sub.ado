*! version 2.1.5  09feb2015
program define svy_sub, sortpreserve rclass /* processes subpop() option */
	version 8.2

	// internal (secret) arguments
	gettoken doit	0 : 0	// may NOT be empty
	gettoken genvar	0 : 0	// may NOT be empty
	gettoken wexp	0 : 0	// may be empty
	gettoken strata	0 : 0	// may be empty
	gettoken byable	0 : 0	// may be empty
	gettoken byvar	0 : 0	// may be empty
	gettoken srs1	0 : 0	// may be empty

	// syntax for user supplied -subpop()- option
	syntax [varlist(default=none max=1 numeric)] [if/] [in] [, SRSsubpop ]

	markout `doit' `varlist'

	if "`srssubpop'`srs1'" != "" {
		if `"`varlist'`if'`in'"' == "" {
			if "`byable'" != "" & `"`byvar'"' == "" {
				di as err ///
"{p 0 0 2}option srssubpop requires that the by() option"		///
" contains at least one variable name or that the subpop() option"	///
" contains a variable name, an if expression, or an in range" 
				exit 198
			}
			else if "`byable'" == "" {
				di as err ///
"{p 0 0 2}option subpop() requires a variable name," ///
" an if expression, or an in range when the srssubpop" ///
" option is specified"
				exit 198
			}
		}
		return local srssubpop srssubpop
	}

	// generate the subpop variable from -subpop()-
	tempvar subpop
	qui gen `subpop' = 0
	if `"`if'"' != "" {
		local ifif `"if `doit' & (`if')"'
	}
	else	local ifif if `doit'
	if "`varlist'" != "" {
		local ifif `"`ifif' & (`varlist' != 0)"'
		return local subpop `varlist'
	}
	qui replace `subpop' = 1 `ifif' `in'

	if `"`varlist'`if'`in'"' == "" {
		rename `subpop' `genvar'
		exit
	}

	qui count if `doit'
	return scalar N = r(N)
	if return(N) == 0 {
		error 2000
	}

	qui count if `subpop'!=0
	return scalar N_sub = r(N)

	if return(N_sub) == 0 {
		di as err "no observations in subpop() subpopulation"    _n /*
		*/ "subpop() = 1 indicates observation in subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in subpopulation"
		exit 461
	}
	if "`wexp'"!="" {
		qui count if `subpop'!=0 & (`wexp')!=0
		if r(N) == 0 {
			di as err "all observations in subpop() " /*
			*/ "subpopulation have zero weights"
			exit 461
		}
	}
	if return(N_sub) == return(N) {
		di as txt _n "Note: subpop() subpopulation is same as full " /*
		*/ "population" _n /*
		*/ "subpop() = 1 indicates observation in subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in subpopulation"
		local same 1
	}

	if "`if'`in'" != "" {
		if ("`if'" != "") local ifin if `if'
		local ifin `ifin' `in'
	}
	if "`varlist'" != "" {
		qui count if `varlist'!=1 & `varlist'!=0 & `doit'
		if r(N) > 0 {
			if "`same'"=="" {
				di as txt _n "Note: subpop() takes on " /*
				*/ "values other than 0 and 1" _n /*
				*/ "subpop() != 0 indicates subpopulation"
			}
		}
	}
	return local subexp `varlist' `ifin'

/* Check for strata with no subpopulation members. */

	if "`genvar'" != "" {
		rename `subpop' `genvar'
		local subpop `genvar'
	}

	if "`if'" != "" {
		if (`"`varlist'"' != "") {
			local lpar "( "
			local rpar " )"
			local ifand " & "
		}
		local ifcond (`if')
	}
	if "`in'" != "" {
		if (`"`varlist'`if'"' != "") {
			local lpar "( "
			local rpar " )"
			local inand " & "
		}
		gettoken x rest : in
		gettoken n1 rest : rest , parse("\/")
		gettoken x n2 : rest, parse("\/")
		local incond (`n1'<=_n & _n<=`n2')
	}
	return local subcond ///
	`"`lpar'`varlist'`ifand'`ifcond'`inand'`incond'`rpar'"'

	if "`strata'"=="" | "`same'"=="1" {
		exit
	}

	sort `doit' `strata', stable
	tempvar strobs
	qui by `doit' `strata': gen `c(obs_t)' `strobs' = cond(_n==_N, /*
	*/ sum(`subpop'!=0), .) if `doit'

	qui count if `strobs'==0
	return scalar omit = r(N)
	if return(omit) == 0 {
		exit
	}

	if return(omit) == 1 {
		local str "stratum"
		local itthey "it"
		local s "s"
	}
	else {
		local str "strata"
		local itthey "they"
	}

	di as txt _n "Note: `return(omit)' `str' omitted because `itthey' " /*
	*/ "contain`s' no subpopulation members"

	qui by `doit' `strata': replace `doit' = 0 if `strobs'[_N]==0

end

exit
