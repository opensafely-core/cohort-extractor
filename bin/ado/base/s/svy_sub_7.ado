*! version 2.0.3  09feb2015
program define svy_sub_7, rclass /* processes subpop() option */
	version 8, missing
	args doit subpop wexp strata

	qui count if `doit'
	ret scalar N = r(N)
	if return(N) == 0 {
		error 2000
	}

	qui count if `subpop'!=0 & `doit'
	ret scalar N_sub_7 = r(N)

	if return(N_sub_7) == 0 {
		di as err "no observations in subpop() subpopulation"    _n /*
		*/ "subpop() = 1 indicates observation in subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in subpopulation"
		exit 461
	}
	if "`wexp'"!="" {
		qui count if `subpop'!=0 & `doit' & (`wexp')!=0
		if r(N) == 0 {
			di as err "all observations in subpop() " /*
			*/ "subpopulation have zero weights"
			exit 461
		}
	}
	if return(N_sub_7) == return(N) {
		di as txt _n "Note: subpop() subpopulation is same as full " /*
		*/ "population" _n /*
		*/ "subpop() = 1 indicates observation in subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in subpopulation"
		local same 1
	}

	qui count if `subpop'!=1 & `subpop'!=0 & `doit'
	if r(N) > 0 {
		if "`same'"=="" {
			di as txt _n "Note: subpop() takes on " /*
			*/ "values other than 0 and 1" _n /*
			*/ "subpop() != 0 indicates subpopulation"
		}
		ret local subexp "!=0"
	}
	else	ret local subexp "==1"

/* Check for strata with no subpopulation members. */

	if "`strata'"=="" | "`same'"=="1" {
		exit
	}

	sort `doit' `strata'
	tempvar strobs
	qui by `doit' $S_VYstr: gen `c(obs_t)' `strobs' = cond(_n==_N, /*
	*/ sum(`subpop'!=0), .) if `doit'

	qui count if `strobs'==0
	if r(N) == 0 {
		exit
	}

	if r(N) == 1 {
		local str "stratum"
		local itthey "it"
		local s "s"
	}
	else {
		local str "strata"
		local itthey "they"
	}

	di as txt _n "Note: `r(N)' `str' omitted because `itthey' " /*
	*/ "contain`s' no subpopulation members"

	qui by `doit' `strata': replace `doit' = 0 if `strobs'[_N]==0
end
