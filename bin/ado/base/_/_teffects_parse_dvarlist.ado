*! version 1.0.3  03jun2015

program _teffects_parse_dvarlist, sclass
	version 13
	cap noi syntax varlist(numeric fv), touse(varname) [ wtype(string) ///
		wvar(string) noCONstant linear logit probit fprobit flogit ///
		hetprobit(string) fhetprobit(string) poisson rmcoll noMARKout ]
	/* assumption: -marksample touse- by calling program		*/
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The outcome model is misspecified.{p_end}"
		exit `rc'
	}
	if "`wtype'" != "" {
		local wts [`wtype'=`wvar']
		if ("`wtype'"=="fweight") local freq `wvar'
	}
	if "`markout'" == "" {
		markout `touse' `varlist'
		_teffects_count_obs `touse', freq(`freq') ///
			why(observations with missing values)
	}

	gettoken depvar varlist : varlist, bind
	_fv_check_depvar `depvar'

	if "`varlist'"=="" & "`constant'"!="" {
		di as err "{p}The outcome model is misspecified; there " ///
		 "must be at least a constant term in the model{p_end}"
		exit 100
	}

	/* check for collinearity among variables 			*/
	if ("`rmcoll'"=="") local rmcoll _rmdcoll `depvar'
	else local rmcoll _rmcoll

	`rmcoll' `varlist' if `touse' `wts', `constant' 
	local k_omitted = r(k_omitted)
	if (`k_omitted'!=0) local varlist `r(varlist)'

	fvrevar `varlist', list
	local dvarlist `r(varlist)'
	local dvarlist : list uniq dvarlist

	fvexpand `varlist' if `touse'
	local rc = c(rc)
	if `rc' {
		di as err "{p}unable to expand factor variables in " ///
		 "outcome-model varlist{p_end}"
		exit `rc'
	}
	local fvops `r(fvops)'
	local fvdvarlist `r(varlist)'
	if ("`fvops'"=="") local fvops false

	if `"`hetprobit'"' != "" {
		local hetprobit `"hetprobit(`hetprobit')"'
	}
	if `"`fhetprobit'"' != "" {
		local fhetprobit `"fhetprobit(`fhetprobit')"'
	}

	ParseDModel, `linear' `logit' `probit' `hetprobit' `poisson' ///
		     `flogit' `fprobit' `fhetprobit'

	local omodel `s(omodel)'
	
	if ("`omodel'" == "hetprobit"|"`omodel'"=="fhetprobit") {
		local hvarlist `s(hvarlist)'

		markout `touse' `hvarlist'

		_teffects_count_obs `touse', freq(`freq') ///
			why(observations with missing values)

	        cap fvexpand `hvarlist' if `touse'
        	if c(rc) {
                	di as err "{p}unable to expand outcome model " ///
			 "{bf:`hvarlist'}{p_end}"
        	        exit 198
	        }
		local fvhvarlist "`r(varlist)'"

		fvrevar `hvarlist', list
		local hvarlist `r(varlist)'
	}
	if ("`omodel'"=="logit" | "`omodel'"=="probit"| 	///
	   "`omodel'"=="hetprobit"|"`omodel'"=="flogit"|	///
	   "`omodel'"=="fprobit"|"`omodel'"=="fhetprobit")  {
	   
		local frac       = 0
		local fractional = ("`omodel'"=="fprobit")  + /// 
				   ("`omodel'"=="flogit")   + ///
				   ("`omodel'"=="fhetprobit")
		if `fractional' > 0 {
			local frac = 1
		}
	    	_teffects_validate_catvar `depvar', ///
			argname(outcome variable) touse(`touse') binary ///
			frac(`frac')
		qui count if `depvar'==0 & `touse'
		local n0 = r(N)
		qui count if `depvar'==1 & `touse'
		local n1 = r(N)
		if `frac'== 0 {
			if !`n0' | !`n1' {
				if (!`n0') local extra "zeros"
				if !`n1' {
					if (!`n0') local extra `extra' or
					local extra `extra' ones
				}
				di as err "the outcome model is misspecified"
				di as txt "{phang}{bf:`depvar'} is not a "  ///
				   "binary variable, as is required when "  ///
				   "{bf:`omodel'} is the outcome model.{p_end}"
				exit 450
			}
		}
	}
	else if "`omodel'" == "poisson" {
		qui count if `depvar'<0 & `touse'
		if r(N) > 0 {
			di as err "{p}Poisson data must be nonnegative; " ///
			 "outcome `depvar' is not nonnegative{p_end}"
			exit 459
		}
	}
	sreturn local omodel `omodel'
	sreturn local k_omitted = `k_omitted'
	sreturn local fvdvarlist `fvdvarlist'
	sreturn local kfv : word count `fvdvarlist'
	sreturn local dvarlist `dvarlist'
	sreturn local k : word count `dvarlist'
	sreturn local depvar `depvar'
	sreturn local fvops `fvops'
	sreturn local constant `constant'
	
	if ("`omodel'" == "hetprobit"|"`omodel'" == "fhetprobit") {
		sreturn local hvarlist `hvarlist'
		sreturn local fvhvarlist `fvhvarlist'
	}
end

program define ParseDModel, sclass
	cap noi syntax, [ linear logit probit hetprobit(string) ///
		poisson flogit fprobit fhetprobit(string)]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The outcome model is misspecified.{p_end}"
		exit `rc'
	}
	local k : word count `linear' `logit' `probit' `poisson' ///
			     `flogit' `fprobit'
	if `k'>1 | ("`hetprobit'"!="" & `k'==1) | ("`fhetprobit'"!="" & `k'==1){
		di as err "{p}The outcome model is misspecified{p_end}"
		di as txt "{p}You can only specify " ///
		 "one of {bf:linear}, {bf:logit}, {bf:probit}, "             ///
		 "{bf:poisson}, {bf:flogit}, {bf:fprobit}, {bf:fhetprobit}," ///
		 " or {bf:hetprobit()}.{p_end}"
		exit 184
	}
	if "`hetprobit'"!="" {
		local omodel hetprobit

		ParseHetprob `hetprobit'
	}
	if "`fhetprobit'"!="" {
		local omodel fhetprobit

		ParseHetprob `fhetprobit'
	}
	if ("`fhetprobit'"=="" & "`hetprobit'"=="") {
		local omodel `linear'`logit'`probit'`poisson'`flogit'`fprobit'
	}
	if ("`fhetprobit'"=="" & "`hetprobit'"=="" & `k'== 0){
		local omodel linear 
	}
	sreturn local omodel `omodel'
end

program define ParseHetprob, sclass
	cap noi syntax varlist(numeric fv)
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The outcome model is misspecified; "	///
			"the option {bf:hetprobit()} is misspecified.{p_end}"
		exit `rc'
	}
	sreturn local hvarlist `varlist'
end

exit

