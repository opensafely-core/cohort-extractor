*! version 1.1.9  05oct2018
program _bayes_prior_opt, sclass

	args mcmcobject gtouse singley priors
	
	local defparamlist
	local options
	local optinitial
	local list_par_names
	local list_par_prefix
	local list_par_isvar
	local list_expr
	local extravars
	
	while `"`priors'"' != "" {
		gettoken eqline priors: priors, parse("\ ()") match(paren)

		// parse data/params until the first option
		if `"`eqline'"' == "prior" {
			gettoken eqline priors : priors, match(paren)
			// equations begin with ( 
			if "`paren'" != "(" {
				di as err "( is expected after prior"
				exit _rc
			}
		}
		else {
			gettoken next priors : priors, match(paren)
			// move to options
			if "`paren'" == "(" {
				local options `"`options'`eqline'(`next') "'
			}
			else {
				local options `"`options'`eqline' "'
				if `"`next'"' != "" {
					local priors `"`next' `priors'"'
				}
			}
			continue
		}
		// equations begin with (
		if "`paren'" != "(" {
			local option `eqline'
			continue
		}

		_mcmc_fv_decode `"`eqline'"' `gtouse'
		local eqline `s(outstr)'

		_mcmc_scan_identmats `eqline'
	 	local eqline `s(eqline)'

		_mcmc_parse_comma `eqline'
		local ylist `s(lhs)'
		local xlist `s(rhs)'
	 	
		local lablist $MCMC_eqlablist
		local ylabind 1
		gettoken ylabel lablist : lablist
		while `"`ylabel'"' != "" {
			local ltemp MCMC_betapar_`ylabind'
			while regexm(`"`ylist'"', `"{`ylabel':}"') {
				local ylist = regexr(`"`ylist'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
			}
			gettoken ylabel lablist : lablist
			local `++ylabind'
		}

		if `"`singley'"' != "" {

			// expand {par1 par2 ...}
		 	_mcmc_parse expand `ylist'
		 	local ylist `"`s(eqline)'"'
			// in single equations, coefficient parameters 
		 	// can be referred to without label; 
		 	// e.g. {_cons} instead of {mpg:_cons}
		
			tokenize $MCMC_eqlablist
			local ylabind 1
			while "`1'" != "" & `"`singley'"' != `"`1'"' {
				local ylabind = `ylabind'+1
				mac shift
			}

			local lablist MCMC_betapar_`ylabind'
		 	local lablist $`lablist'
		 	gettoken next lablist : lablist
		 	while `"`next'"' != "" {
				tokenize `"`next'"', parse("{:}")
				local ylabel `2'
				if `"`1'"' == "{" & `"`3'"' == ":" & ///
				  `"`5'"' == "}" {
					while regexm(`"`ylist'"', `"{`4'}"') {
						local ylist = ///
							regexr(`"`ylist'"', ///
							`"{`4'}"', `"`next'"')
					}
				}
				gettoken next lablist : lablist
			}
		}

		local eqline `ylist',`xlist'

		_zellners_expand `eqline'
		local eqline `s(eqline)'

		if $MCMC_debug {
	 		di " "
		 	di _asis `"	 	parse: `eqline'"'
		}

		_mcmc_parse_comma `eqline'
		local ylist `s(lhs)'
		local dist `s(rhs)'
		gettoken dist  xlist : dist, parse("(") match(paren)
		gettoken xlist : xlist, match(paren)

		local defparamlist `"`defparamlist'`ylist' "'

		local parlist `"`ylist'"'
		gettoken next parlist : parlist, bindcurly
		while `"`next'"' != "" {
			if substr(`"`next'"',1,1) != "{" {
				di as err "{bf:prior(`eqline')} is misspecified:"
di as err `"{p 4 4 2}{bf:`next'} should be a parameter enclosed in curly braces.{p_end}"'
				exit 198
			}
			gettoken next parlist : parlist, bindcurly
		}

		// verify correct number of parameters
		_mcmc_distr prior `"`dist'"' `"`ylist'"' `"`xlist'"'
		
		// last-in first-out order
		local optinitial `"`optinitial' `s(optinitial)'"'
		
		local eqline `s(ylist)',`s(distribution)'(`s(distrparams)')

		_mcmc_parse equation `eqline'

		if `"`s(y)'"' == "" {
			di `"{txt}note:{bf:prior(`eqline')} is dropped"'
			continue
		}

		mata: `mcmcobject'.add_prior_name( ///
			`"`s(dist)'"', `"`s(y)'"', `"`s(yprefix)'"')

		local list_par_names  `list_par_names' `s(y)'
		local list_par_prefix `list_par_prefix' `s(yprefix)'
		local list_par_isvar  `list_par_isvar' `s(yisvar)'

		local list_par_names  `list_par_names' `s(x)'
		local list_par_prefix `list_par_prefix' `s(xprefix)'
		local list_par_isvar  `list_par_isvar' `s(xisvar)'

		local list_expr `"`list_expr' `s(eval)'"'

		if "`s(dist)'" == "" &  `"`s(eval)'"' == "" {
			if `"`s(yprefix)'"' != "" {
				di as err "invalid prior specification " ///
					"for {bf:{`s(yprefix)':`s(y)'}}"
		 	}
		 	else {
				di as err "invalid prior specification " ///
					"for {bf:{`s(y)'}}"
		 	}
		 	exit 198
		}

		// update beta_label lists
		local varlist0 `s(xprefix)'
		local varlist  `s(x)'
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
		while `"`next'"' != "" { 
			if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
				_bayesmh_eqlablist ind `lyvar'
				_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
			}
			gettoken lyvar varlist0 : varlist0
			gettoken next  varlist  : varlist
		}

		// clean white space
		local extravars `s(exvarlist)'
		tempname pdescr
		mata: `pdescr' = NULL

		local tok `s(yislat)'
		gettoken tok : tok
		// remove the `0 &' if you want to able to overwrite priors for REs
		if 0 & "`tok'" == "1" {
		mata: `pdescr' = `mcmcobject'.find_factor(	///
			"`s(y)'",	 	 		///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'")
		}
		else {
			mata: `mcmcobject'.add_factor()
		}
		mata: `mcmcobject'.set_factor(			///
	 		`pdescr',	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`s(eval)'"', "`s(evallist)'", 	///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 		///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",				///
		 	"`s(yomit)'",				///
		 	"`s(x)'",	 	 	 	///
		 	"`s(xisvar)'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",	 	 	 	///
		 	"`s(xomit)'",	 	 	 	///
		 	"`s(nocons)'",	 	 		///
			"",                                     ///
		 	`"`llevaluator'"', 			///
			`"`extravars'"', "", "", "")

		// needs better solution!
		mata: `mcmcobject'.drop_pdist()
		mata: mata drop `pdescr'

	} // end of while
	
	sreturn local defparamlist	= `"`defparamlist'"'
	sreturn local options		= `"`options'"'
	sreturn local optinitial	= `"`optinitial'"'
	sreturn local list_par_names	= `"`list_par_names'"'
	sreturn local list_par_prefix	= `"`list_par_prefix'"'
	sreturn local list_par_isvar	= `"`list_par_isvar'"'
	sreturn local list_expr		= `"`list_expr'"'
	sreturn local extravars		= `"`extravars'"'
end

program _zellners_expand, sclass

	if !regexm(`"`0'"', "zellnersg") {
		sreturn local eqline  = `"`0'"'
		sreturn local tempmat = ""
		exit 0
	}

	local eqline `0'

	_mcmc_parse equation `eqline'

	local lab `s(yprefix)'
	gettoken lab : lab

	local tmat _`lab'_xTx
	capture matrix list `tmat'
	if c(rc) == 0 {
		di as err "{bf:`s(dist)'} prior already specified " ///
			"for {bf:`lab'}"
		exit 198
	}
	
	global MCMC_tempmats `MCMC_tempmats' `tmat'
	
	local vars `s(y)'
	if !regexm(`"`vars'"', "_cons") {
		di as err "{bf:`s(dist)'} prior expects a constant term " ///
			"in {bf:`vars'}"
		exit 198
	}
	local vars = regexr(`"`vars'"', "_cons", "")
	local lvars `vars'
	local vars
	gettoken tok lvars: lvars
	while `"`tok'"' != "" {
		_ms_parse_parts `"`tok'"'
		if `"`r(omit)'"' == "0" {
			local vars `vars' `tok'
		}
		gettoken tok lvars: lvars
	}
	if !regexm(`"`vars'"', "_cons") {
		local vars = regexr(`"`vars'"', "_cons", "")
	}
	
	local dim : word count `vars'
	local dim = `dim' + 1	
	
	capture matrix accum `tmat' = `vars'
	if _rc != 0 {
		di as err "{bf:`s(dist)'} prior cannot be applied to " ///
			"{bf:`vars'}"
		exit 198
	}
	scalar detx = det(`tmat')
	if detx == 0 {
		di as err "{bf:`s(dist)'} prior cannot be applied to " ///
			"{bf:`vars'}"
		di as err "Fisher information matrix is singular"
		exit 198
	}
	matrix `tmat' = syminv(`tmat')

	gettoken lhs rhs : eqline, parse(",") bind
	gettoken tok rhs : rhs,	parse(",") bind
	if `"`tok'"' != "," {
		di as err "{bf:`s(dist)'} prior cannot be applied to " ///
			"{bf:`vars'}"
		exit 198
	}
	gettoken tok rhs : rhs, parse("()") bind
	if `"`tok'"' != `"`s(dist)'"' {
		di as err "{bf:`s(dist)'} prior cannot be applied to " ///
			"{bf:`vars'}"
		exit 198
	}
	gettoken xvars: rhs, match(paren)

	local sdim 0
	local varparam
	local lambda
	tokenize `"`xvars'"', parse(",")

	if `"`1'"' != "" {
		capture confirm number `1'
		if c(rc) {
			di as err "dimension of {bf:`s(dist)'} must be " ///
				"a positive integer"
			exit 198
		}
		local sdim `1'
		mac shift 2
	}

	if `"`1'"' != "" {
		local lambda `1'
		mac shift 2
	}

	local xvars
	while `"`1'"' != "" {
		if `"`3'"' != "" {
			if `"`xvars'"' != "" local xvars `"`xvars',"'
			local xvars `"`xvars'`1'"'
		}
		else {
			local varparam `1'
		}
		mac shift 2
	}
	if `sdim' != `dim' {
		di as err `"{bf:`s(dist)'} should be of dimension `dim'"'
		exit 198
	}
	
	local xnum 0
	if `"`xvars'"' != "" {
		tokenize `"`xvars'"', parse(",")
		while `"`1'"' != "" {
			local xnum = `xnum' + 1
			mac shift 2
		}
	}
	
	tokenize `varparam', parse("{}")
	if `"`1'"' != "{" | `"`3'"' != "}" {
		di as err "{bf:`s(dist)'} prior incorrectly specified"
		exit 198
	}
	if `"`s(dist)'"' == "zellnersg0" {
		if `xnum' != 0 | `"`varparam'"' == "" {
			di as err "{bf:`s(dist)'} prior incorrectly specified"
			exit 198
		}
		local rhs zellnersg0(`dim',`lambda',`varparam',`tmat')
	}
	
	if `"`s(dist)'"' == "zellnersg" {
		if (`xnum' != 1 & `xnum' != `dim') | `"`varparam'"' == "" {
			di as err "{bf:`s(dist)'} prior incorrectly specified"
			exit 198
		}
		local rhs zellnersg(`dim',`lambda',`xvars',`varparam',`tmat')
	}
	local eqline `lhs',`rhs'

	sreturn local eqline  = `"`eqline'"'
	sreturn local tempmat = `"`tmat'"'
end
