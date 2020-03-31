*! version 4.0.1  15feb2016
program define cii, rclass
	version 14
	local vv : di "version " string(_caller()) ", missing:"
	if _caller() < 14.1 {
		cii_14_0 `0'
		return add
		exit
	}

	_parse comma lhs rhs : 0
	gettoken param lhs : lhs
	_ci_check_param paramname : "`param'" "cii"

	gettoken first : lhs
	if (`"`first'"'!="") {
		cap confirm variable `first'
		if _rc==0 {
			di as err "{p}variable found where a number expected;"
			di as err "perhaps you meant to use {helpb ci}{p_end}"
			exit 198
		}
	}

	`vv' cii_`paramname' `lhs' `rhs'
	ret add

end

program cii_means, rclass
	local vv : di "version " string(_caller()) ", missing:"
	
	syntax [anything] [, Level(cilevel) Poisson NORMAL /*undoc.*/]

	opts_exclusive "`poisson' `normal'"
	
	local argnum: word count `anything'
	if "`poisson'" == "" {
		local estlab "obs"	
		if `argnum' != 3 {
			di as err "{p}you must specify 3 arguments with"
			di as err "{bf:cii means}: {it:#obs}, {it:#mean}, and"
			di as err "{it:#sd}{p_end}"
			exit 198
		}
	}
	else {
		local estlab "exposure"	
		if `argnum' != 2 {
			di as err "{p}you must specify 2 arguments with"
			di as err "{bf:cii means, poisson}: {it:#exposure}"
			di as err "and {it:#events}{p_end}"
			exit 198
		}
	}
	tokenize `"`anything'"'
	local n = `1'
	if "`poisson'" == "" {
		cap confirm integer number `n'
		if _rc | (`n'<1) {
			di as err "first argument, {it:#`estlab'}, must be a " ///
				  "positive integer"
			exit cond(`n'<1,198,_rc)
		}
	}
	else {
	if (`n'<=0) {
		di as err "first argument, {it:#`estlab'}, must be a " ///
			  "positive number"
		exit 198
	}
	}
	if "`poisson'" == "" {
		cap confirm variable `2'
		if _rc==0 {
			di as err ///
			   "second argument, {it:#mean}, must be a number"
			exit 198
		}
		cap local mean = `2'
		if _rc {
			di as err ///
			   "second argument, {it:#mean}, must be a number"
			exit _rc
		}
		cap confirm number `mean'
		if _rc {
			di as err ///
			   "second argument, {it:#mean}, must be a number"
			exit _rc
		}
		cap confirm variable `3'
		if (_rc==0) {
			di as err "third argument, {it:#sd}, must be a " ///
				  "positive number"
			exit 198
		}
		local sd = `3'
		cap confirm number `sd'
		local rc = _rc
		if `rc'==0 {
			if (`sd'<=0) {
				local rc = 198
			}
		}
		if (`rc') {
			di as err "third argument, {it:#sd}, must be a " ///
				  "positive number"
			exit `rc'
		}
	}
	else {  
		cap confirm variable `2'
		if _rc==0 {
			di as err ///
			   "second argument, {it:#events}, must be a number"
			exit 198
		}
		cap local events = `2'
		cap confirm number `events'
		if _rc {
			di as err ///
			   "second argument, {it:#events}, must be a number"
			exit _rc
		}
		if `events' >= 1 {
			cap confirm integer number `events'
			if _rc {
				di as err "second argument, {it:#events}, " ///
					  "must be a positive integer or " ///
					  "between 0 and 1"
				exit _rc
			}
		}		
		else if `events' < 0 {
			di as err "second argument, {it:#events}, must be " /// 
				"a positive integer or between 0 and 1"
			exit 198
		}
	}
	`vv' cii_14_0 `anything', `poisson' level(`level')
	ret scalar level = `level'
	ret scalar ub = r(ub)
	ret scalar lb = r(lb)
	ret scalar se = r(se)
	ret scalar mean = r(mean)	
	ret scalar N = r(N)

	local type "`poisson'`normal'"
	if "`type'" == "" local type normal

	ret local citype `type'	
end

program cii_proportions, rclass
	local vv : di "version " string(_caller()) ", missing:"
	
	local SYN_type EXAct wald wilson Agresti Jeffreys
	syntax [anything] [, Poisson Binomial `SYN_type' Level(cilevel) ]

	local citype "`exact' `wald' `wilson' `agresti' `jeffreys'"
	opts_exclusive "`citype'"

	if ("`poisson'"!="") {
		di as err "{p}option {bf:poisson} is not allowed with"
		di as err "{bf:cii proportions}{p_end}"
		exit 198
	}
	if ("`binomial'"!="") {
		di as err "{p}option {bf:binomial} is not allowed with"
		di as err "{bf:cii proportions}{p_end}"
		exit 198
	}
	
	local argnum: word count `anything'
	if `argnum' != 2 {
		di as err "{p}you must specify 2 arguments with"
		di as err "{bf:cii proportions}: {it:#obs}"
		di as err "and {it:#succ}{p_end}"
		exit 198
	}
	tokenize `"`anything'"'
	local n = `1'
	cap confirm integer number `n'
	if _rc {
		di as err "first argument, {it:#obs}, must be a " ///
			  "positive integer"
		exit _rc
	}
	if (`n'<1) {
		di as err "first argument, {it:#obs}, must be a " ///
			  "positive integer"
		exit 198
	}
	cap confirm variable `2'
	if _rc==0 {
		di as err ///
		   "second argument, {it:#succ}, must be a number"
		exit 198
	}
	cap local succ = `2'
	cap confirm number `succ'
	if _rc {
		di as err ///
		   "second argument, {it:#succ}, must be a number"
		exit _rc
	}
	if `succ' >= 1 {
		cap confirm integer number `succ'
		if _rc {
			di as err "second argument, {it:#succ}, must be " /// 
				"a nonnegative integer or between 0 and 1"
			exit _rc
		}
	}		
	else if `succ' < 0 {
		di as err "second argument, {it:#succ}, must be " /// 
			"a nonnegative integer or between 0 and 1"
		exit 198
	}
	if (`succ'<1) {
		local nsucc = int(`succ'*`n'+.5)
	}
	else {
		local nsucc = `succ'
	}
	if (`nsucc'>`n') {
		di as err "the number of successes, `nsucc', cannot exceed " ///
			  "the number of observations, `n'"
		exit 198
	}
	`vv' cii_14_0 `anything', binomial `citype' level(`level')
	ret scalar level = `level'
	ret scalar ub = r(ub)
	ret scalar lb = r(lb)
	ret scalar se = r(se)
	ret scalar proportion = r(mean)	
	ret scalar N = r(N)
	return hidden scalar mean = r(mean)

	local type "`wald'`wilson'`agresti'`exact'`jeffreys'"
	if "`type'" == "" {
		local type exact
	}
	ret local citype `type'
end

program cii_variances, rclass
	cii_sd `0'
	ret add
end

program cii_sd, rclass 
	syntax [anything] [, sd Level(cilevel) BONett]
	
	tokenize "`anything'"
	local narg: word count `anything'
	if ("`sd'"=="") {
		local estlab "variance"
	}
	else {
		local estlab "sd"
	}
	if ("`bonett'"=="") {
		if (`narg'!=2) {
			di as err "{p}you must specify 2 arguments with"
			di as err "{bf:cii variances}: {it:#obs}"
			di as err "and {it:#`estlab'}{p_end}"
			exit 198
		}
	}
	else {
		if (`narg'!=3) {
			di as err "{p}you must specify 3 arguments with"
			di as err "{bf:cii variances, bonett}: {it:#obs}, "
			di as err "{it:#`estlab'}, and {it:#kurtosis}{p_end}"
			exit 198
		}
	}
	// check number of obs.
	cap local n = `1'
	cap confirm integer number `n'
	if _rc {
		di as err "first argument, {it:#obs}, must be an " ///
			  "integer greater than 1"
		exit _rc
	}
	capture assert `n' > 1
	if _rc {
		di as err "first argument, {it:#obs}, must be an " ///
			  "integer greater than 1"
		exit 198
	}
	cap confirm variable `2'
	if _rc==0 {
		di as err ///
		   "second argument, {it:#`estlab'}, must be a number"
		exit 198
	}
	// check variance or sd
	cap local var = `2'
	cap confirm number `var'
	if _rc {
		di as err "second argument, {it:#`estlab'}, must " ///
			  "be positive"
		exit _rc
	}
	capture assert `var' > 0
	if _rc {
		di as err "second argument, {it:#`estlab'}, must be positive"
		exit 198
	}
	// check kurtosis with -bonett-
	if `narg' == 3 {
		cap confirm variable `3'
		if _rc==0 {
			di as err "third argument, {it:#kurtosis}, must " ///
				  "be positive"
			exit 198
		}
		cap local g4 = `3'
		cap confirm number `g4'
		if _rc {
			di as err "third argument, {it:#kurtosis}, must " ///
				  "be positive"
			exit _rc
		}
		capture assert `g4' > 0
		if _rc {
			di as err ///
			   "third argument, {it:#kurtosis}, must be positive"
			exit 198
		}
	}
	
	tempname alpha z 
	local ttl "Variance" /* will be Std. Dev., depending on options */  
	
	scalar `alpha' = (100 - `level')/100
	scalar `z' = invnormal(1 - `alpha'/2)

	if "`sd'" != "" {
		local var = `var'^2
		local ttl "Std. Dev."
	}
	if "`bonett'" != "" {
		di
		di in smcl in gr _col(47) /*
		      */ "{hline 6} Bonett {hline 6}"
		tempname c se 				
		scalar `c' = `n'/(`n' - `z')
		scalar `se' = `c' * sqrt((`g4'-(`n'-3)/`n')/(`n'-1))		

		ret scalar level = `level'
		ret scalar ub = exp(log(`c' * `var') + `z' * `se')
		ret scalar lb = exp(log(`c' * `var') - `z' * `se')		
		ret scalar kurtosis = `g4'
		ret scalar Var = `var'
		ret scalar N = `n'
		ret hidden scalar Var_se = `se'
		ret local citype = "bonett"
	}
	else { /* normal-based CI */
		di			
		ret scalar level = `level'
		ret scalar ub=(`n'-1)*`var'/invchi2(`n'-1,`alpha'/2)
		ret scalar lb=(`n'-1)*`var'/invchi2tail(`n'-1,`alpha'/2)
		ret scalar Var = `var'
		ret scalar N = `n'
		ret local citype = "normal"
	}	
	
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "   "
	}
	else if `cil' == 4 {
		local spaces " "
	}
	di in smcl in gr _col(5) /*
	  */  "Variable {c |}" _col(23) /* 
	  */ "Obs" /*
	  */ _col(32) "`ttl'" /*
	  */ _col(44) `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'/*
	  */ _n "{hline 13}{c +}{hline 52}"
	  		
	local efmt %10.0fc			
	local ofmt "%9.0g"
	
	if "`sd'" != "" {		
		di in smcl in gr /*
		  */ "             {c |}" _col(16) /*
		  */ in yel `efmt' return(N) /*
		  */ _col(31) `ofmt' sqrt(return(Var)) /*
		  */ _col(46) `ofmt' sqrt(return(lb)) /*
		  */ _col(58) `ofmt' sqrt(return(ub))
		ret scalar level = `level'
		ret scalar ub = sqrt(return(ub))
		ret scalar lb = sqrt(return(lb))
		if "`bonett'" != "" {
			ret scalar kurtosis = return(kurtosis)
		}
		ret scalar sd = sqrt(return(Var))
		ret scalar Var = return(Var)
		ret scalar N = return(N)		
	}
	else {
		di in smcl in gr /*
		  */ "             {c |}" _col(16) /*
		  */ in yel `efmt' return(N) /*
		  */ _col(31) `ofmt' return(Var) /*
		  */ _col(46) `ofmt' return(lb) /*
		  */ _col(58) `ofmt' return(ub)
	}
	
end

exit
/*
- Compute CI for the standard deviation (option -sd-) or variance 
  (the default). The default is the normal-based CI.
- option -bonett- will compute the bonett CI. See eq. 4 in 
  Bonett (2006) -- THERE WAS A TYPO in the expression for se (a missing 
  'minus' sign) in the original paper.
*/

