*! version 1.0.3  09feb2015
*! convert binomial data to Bernoulli 

program _binomial2bernoulli, rclass
	version 10
	syntax varlist(min=1 max=1 numeric), fw(varname) binomial(string)

	tokenize `varlist'
	local y `1'
	macro shift
	local n `*'

	tempvar i b01 k
	/* determine if binomial is a variable or constant	*/
	cap confirm variable `binomial'
	if _rc {
		tempname n
		/* constant					*/
		cap scalar `n' = `binomial'
		if  _rc {
			di as err "{p}binomial() must specify a " ///
			 "numeric variable or an integer scalar{p_end}"
			exit 198
		}
		cap assert float(`n') == float(trunc(`n'))
		local rc = _rc
		cap assert `n' > 0 
		local rc = `rc' + _rc
		if `rc' {
			di as err "{p}binomial() must be a positive " ///
			 "integer{p_end}"
			exit 198
		}
		tempvar binomv 
		qui gen int `binomv' = `n'
	}
	else {
		cap confirm numeric variable `binomial'
		if _rc {
			di as err "{p}binomial() must specify a " ///
			 "numeric variable or an integer scalar{p_end}"
			exit 198
		}
		cap assert(float(`binomial') == float(trunc(`binomial')))
		if _rc != 0 {
			di as error "{p}the variable specified in " ///
			 "binomial() must be integer valued{p_end}"
			exit 459 
		}
		qui count if `binomial' <= 0
		if r(N) > 0 {
			di as error "{p}all values of the variable " ///
			 "specified in binomial() must be positive{p_end}" 
			exit 459
		}
		local binomv `binomial'
	}
	cap assert(float(`y') == float(trunc(`y')))
	if _rc != 0 {
		di as error "{p}invalid `y'; number of successes must be " ///
		 "integer valued{p_end}"
		exit 459 
	}
	qui count if `y' < 0
	if r(N) > 0 {
		di as error "{p}invalid `y'; number of successes must be " ///
		 "nonnegative{p_end}" 
		exit 459
	}
	qui count if `y' > `binomv'
	if r(N) > 0 {
		di as error "{p}invalid `y'; number of successes must be " ///
		 "less than or equal to the number of trials `binomial'{p_end}"
		exit 459
	}
	cap assert `y' == `binomial'
	if _rc == 0 {
		di as err "{p}all values in `y', the number of binomial " ///
		 "successes, are equal to `binomial', the number of "     ///
		 "trials{p_end}"
		exit 459
	}
	cap assert `y' == 0
	if _rc == 0 {
		di as err "{p}all values in `y' are equal to zero{p_end}"
		exit 459
	}

	local type : type `y'
	if ("`type'"=="float" | "`type'"=="double") qui recast long `y'
	qui gen `c(obs_t)' `i' = _n
	qui expand 2
	sort `i', stable
	qui gen byte `b01' = 0
	qui by `i': replace `b01' = 1 if _n==1
	qui by `i': gen long `k' = `y' if _n==1
	qui by `i': replace `k' = `binomv'-`y' if _n==2
	qui drop if `k' == 0

	qui replace `fw' = `k'*`fw'
	qui replace `y' = `b01'
	qui recast byte `y'

	return local binom_type = cond("`binomial'"=="`binomv'","variable", ///
		"scalar")
end

exit
