*! version 1.4.6  24sep2019

program _bayes_utils
	version 15.0

	gettoken cmd 0 : 0
	_bayes_utils_`cmd' `0'
end

program _bayes_utils_init
	global MCMC_genvars
	global MCMC_tempmats
	global MCMC_eqlablist
	// matsize error counter
	global MCMC_matsizeerr	0
	global MCMC_matsizemin	0
	global MCMC_postdata
	// moptimize mata objects
	global MCMC_moptobjs
	global MCMC_TSSUB_L 0
	global MCMC_TSSUB_L_words
	global MCMC_TSSUB_F 0
	global MCMC_TSSUB_F_words
	global MCMC_TSSUB_D 0
	global MCMC_TSSUB_D_words
	global MCMC_TSSUB_S 0
	global MCMC_TSSUB_S_words
end

program _bayes_utils_defaultinitial, sclass
	args paramlist
		
	local optinitial
	local j 0
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local ++j
		if regexm(`"`next'"', "o\.") {
			gettoken next varlist : varlist
			continue
		}
		gettoken tok lab : next, parse("/")
		if `"`lab'"' == "" local lab `next'

		if `"`tok'"' == "/" {
			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			gettoken pre : lab, parse(".")
			if `"`tok'"' == "var" {
				// in regress add {sigma2}
				if `"`lab'"' == "" | `"`pre'"' == "e" {
					local optinitial = ///
					`"{sigma2} `=`mb'[1,`j']' `optinitial'"'
				}
				else {
					local optinitial = ///
					`"{`lab':sigma2} 1 `optinitial'"'
				}
				// in mvregress add {Sigma}
				local d = `d' + 1
				local optinitial = ///
				`"{Sigma_`d'_`d'} `=`mb'[1,`j']' `optinitial'"'
			}
		}
		
		if `"`next'"' == "/sigma" | `"`next'"' == "/sigma2" {
			local optinitial = ///
				`"{sigma2} 1 `optinitial'"'
		}

		gettoken lab par : next, parse(":")
		gettoken tok par : par, parse(":")
		if `"`par'"' == "sigma2" {
			// default initial variance is 1
			local optinitial = `"{`lab':`par'} 1 `optinitial'"'
		}
		gettoken next paramlist : paramlist
	}

	sreturn local optinitial = `"`optinitial'"'
end


program _bayes_utils_optinitial, sclass
	args mb nchains tsigfact

	tempname tinitval tsig rinitval

	local varlist: colfullnames `mb'
		
	local chains
	if `nchains' > 1 {
		if "`tsigfact'" == "" {
			local tsigfact 3
		}
		forvalues i = 2/`nchains' { 
			local chains = `"`chains' `i'"'
			local optinitial`i'
			local tcutfact`i' = 0.5*(1+abs(1 + rnormal()))
		}
	}

	local optinitial
	local d 0
	local di 2
	local dj 0
	local j 0

	gettoken next varlist : varlist
	while `"`next'"' != "" {
		local ++j

		scalar `tinitval' = `=`mb'[1,`j']'
		scalar `tsig' = `tsigfact'*sqrt(1e-8 + abs(`tinitval'))
		if `tinitval' == 0 {
			scalar `tsig' = 0
		}

		if regexm(`"`next'"', "o\.") {
			gettoken next varlist : varlist
			continue
		}
		gettoken tok lab : next, parse("/")
		if `"`lab'"' == "" local lab `next'

		local notset 1

		if `"`tok'"' == "/" {

			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			gettoken pre : lab, parse(".")
			if `"`tok'"' == "var" {
			
				local notset 0
				// in regress add {sigma2}
				if `"`lab'"' == "" | `"`pre'"' == "e" {
					local optinitial = ///
					`"{sigma2} `=`tinitval'' `optinitial'"'
					local optinitial = ///
					`"{`lab':sigma2} `=`tinitval'' `optinitial'"'

				if `nchains' > 1 {
					forvalues i = 2/`nchains' { 

				scalar `rinitval' = abs(`tinitval' + `tsig'*rnormal())
				local optinitial`i' = ///
				`"{sigma2} `=`rinitval'' `optinitial`i''"'
				local optinitial`i' = ///
				`"{`lab':sigma2} `=`rinitval'' `optinitial`i''"'

					}
				}
				
				}
				else {
					local optinitial = ///
					`"{`lab':sigma2} `=`tinitval'' `optinitial'"'
	
				if `nchains' > 1 {
					forvalues i = 2/`nchains' { 
			
				scalar `rinitval' = abs(`tinitval' + `tsig'*rnormal())
				local optinitial`i' = ///
				`"{`lab':sigma2} `=`rinitval'' `optinitial`i''"'
		
					}
				}
				
				}
				
				// in mvregress add {Sigma}
				local d = `d' + 1
				local optinitial = ///
				`"{Sigma_`d'_`d'} `=`tinitval'' `optinitial'"'
			}
			else if `"`tok'"' == "cov" {
			
				local notset 0
				local dj = `dj' + 1
				if `dj' >= `di' {
					local di = `di' + 1
					local dj 1
				}
				local optinitial = ///
				`"{Sigma_`di'_`dj'} `=`tinitval'' `optinitial'"'
	
				if `nchains' > 1 {
					forvalues i = 2/`nchains' {
			
				scalar `rinitval' = `tinitval'+`tsig'*rnormal()
				local optinitial`i' = ///
				`"{Sigma_`d'i_`dj'} `=`rinitval'' `optinitial`i''"'

					}
				}
			}
			else if substr(`"`tok'"',1,3) == "cut" {
				
				local notset 0
				local optinitial = ///
					`"{`tok'} `=`tinitval'' `optinitial'"'
	
				if `nchains' > 1 {
					forvalues i = 2/`nchains' {

				scalar `rinitval' = `tcutfact`i''*`tinitval'
				local optinitial`i' = ///
					`"{`tok'} `=`rinitval'' `optinitial`i''"'

					}
				}
			}
		}

		if `"`next'"' == "/lnalpha" {
			local notset 0
			local optinitial = ///
				`"{lnalpha} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{alpha} `=exp(`tinitval')' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lnalpha} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{alpha} `=exp(`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/lngamma" {
			local notset 0
			local optinitial = ///
				`"{lngamma} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{gamma} `=exp(`tinitval')' `optinitial'"'
	
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lngamma} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{gamma} `=exp(`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/lnsigma" {
			local notset 0
			local optinitial = ///
				`"{lnsigma} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{sigma2} `=exp(2*`tinitval')' `optinitial'"'
	
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lnsigma} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{sigma2} `=exp(2*`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/lnsigma2" {
			local notset 0
			local optinitial = ///
				`"{sigma2} `=exp(`tinitval')' `optinitial'"'
	
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{sigma2} `=exp(`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/sigma" {
			local notset 0
			local optinitial = ///
				`"{sigma2} `=`tinitval'^2' `optinitial'"'
			local optinitial = ///
				`"{lnsigma} `=ln(`tinitval')' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = abs(`tinitval' + `tsig'*rnormal())
			local optinitial`i' = ///
				`"{sigma2} `=`rinitval'^2' `optinitial`i''"'
			local optinitial`i' = ///
				`"{lnsigma} `=ln(`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "lnsigma:_cons" {
			local notset 0
			local optinitial = ///
				`"{lnsigma:_cons} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{lnsigma} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{sigma2} `=exp(2*`tinitval')' `optinitial'"'
	
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lnsigma:_cons} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{lnsigma} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{sigma2} `=exp(2*`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/lntheta" {
			local notset 0
			local optinitial = ///
				`"{lntheta} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{theta} `=exp(`tinitval')' `optinitial'"'
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lntheta} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{theta} `=exp(`rinitval')' `optinitial`i''"'

				}
			}
		}
		else if `"`next'"' == "/ln_p" {
			local notset 0
			local optinitial = ///
				`"{ln_p} `=`tinitval'' `optinitial'"'
			local optinitial = ///
				`"{_p} `=exp(`tinitval')' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{ln_p} `=`rinitval'' `optinitial`i''"'
			local optinitial`i' = ///
				`"{_p} `=exp(`rinitval')' `optinitial`i''"'

				}
			}
		}

		gettoken lab par : next, parse(":")
		gettoken tok par : par, parse(":")
		if `"`par'"' == "ln_p" {
			local notset 0
			local optinitial = ///
				`"{ln_p} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
			
			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{ln_p} `=`rinitval'' `optinitial`i''"'

				}
			}
		}
		else if `"`par'"' == "lnsigma" {
			local notset 0
			local optinitial = ///
				`"{lnsigma} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lnsigma} `=`rinitval'' `optinitial`i''"'

				}
			}
		}
		else if `"`par'"' == "lngamma" {
			local notset 0
			local optinitial = ///
				`"{lngamma} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial = ///
				`"{lngamma} `=`rinitval'' `optinitial'"'

				}
			}
		}
		else if `"`par'"' == "lnscale" {
			local notset 0
			local optinitial = ///
				`"{lnscale} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{lnscale} `=`rinitval'' `optinitial`i''"'

				}
			}
		}
		else if `"`par'"' == "logs" {
			local notset 0
			local optinitial = ///
				`"{logs} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tinitval'+`tsig'*rnormal()
			local optinitial`i' = ///
				`"{logs} `=`rinitval'' `optinitial`i''"'

				}
			}
		}
		else if substr(`"`par'"',1,3) == "cut" {
				
			local notset 0
			local optinitial = ///
				`"{`par'} `=`tinitval'' `optinitial'"'

			if `nchains' > 1 {
				forvalues i = 2/`nchains' {

			scalar `rinitval' = `tcutfact`i''*`tinitval'
			local optinitial`i' = ///
				`"{`par'} `=`rinitval'' `optinitial`i''"'

				}
			}
		}

		if `notset' {
			gettoken tok lab : next, parse("/")
			if `"`lab'"' == "" local lab `next'
			local optinitial = ///
				`"{`lab'} `=(`mb'[1,`j'])' `optinitial'"'
			if `nchains' > 1 {
				forvalues i = 2/`nchains' {
				scalar `rinitval' = `tinitval'+`tsig'*rnormal()
				local optinitial`i' = ///
				`"{`lab'} `=`rinitval'' `optinitial`i''"'
				}
			}
		}

		gettoken next varlist : varlist
	}

	sreturn local optinitial = `"`optinitial'"'
	if `nchains' > 1 {
		forvalues i = 2/`nchains' {
			sreturn local optinitial`i' = `"`optinitial`i''"'
		}
	}
end

program _bayes_utils_parse_paramlist, sclass

	args paramlist isvarlist
	
	local eval	 ""
	local evallist	 ""
	local evalhasvar ""

	local x	 	""
	local xprefix	""
	local xinit	""
	local xomit	""
	local xisvar	""
	local xismat	""
	local xislat	""
	local xisfact	""
	local xargnum	""
	local xparams	""
	local xtsvar	""

	local narg 0
	local pref ""

	gettoken next paramlist: paramlist
	while "`next'" != "" {

		capture confirm number `next'
		if _rc == 0 {
			local xparams = "`xparams' `next'"
		}
		else {
			local xparams = "`xparams' {`next'}"
		}

		gettoken tok lab : next, parse("/")
		if `"`lab'"' == "" local lab `next'

		gettoken next tok : lab, parse(":")
		if `"`tok'"' != "" {
			gettoken tok lab : tok, parse(":")
		}
		else {
			local next
		}
		if substr(`"`lab'"', 1, 5) == "Sigma" {
			local lab `lab',matrix
		}
		if `"`next'"' != "" {
			local lab {`next':`lab'}
		}
		else {
			local lab `lab'
		}

		_mcmc_parse word `lab'

		local isvar 0
		local isxb 0
		capture confirm variable `s(word)'
		if _rc != 111 | `"`s(word)'"' == "_cons" {
			local isvar 1
			local isxb 1
		}
		capture confirm number `s(word)'
		if _rc == 0 {
			local isvar 0
			local isxb 0
		}
		if !`isvarlist' {
			local isvar 0
		}

		if "`s(prefix)'" != "`pref'" {
			if "`s(prefix)'" != "." & `isxb' {
			// prefixed-names are assumed part of linear forms xb
				local eval       = "`eval' xb"
				local evallist   = "`evallist' xb"
			}
			else {
				local eval       = "`eval' NULL"
				local evallist   = "`evallist' NULL"
			}
			local evalhasvar = "`evalhasvar' 0"
			local narg = `narg' + 1
		}
		local pref "`s(prefix)'"
		
		local x		= "`x' `s(word)'"
		local xprefix	= "`xprefix' `s(prefix)'"
		local xinit	= "`xinit' `s(initval)'"
		local xomit	= "`xomit' `s(omitval)'"
		local xisvar	= "`xisvar' `isvar'"
		local xismat	= "`xismat' `s(matval)'"
		local xislat	= "`xislat' `s(latval)'"
		local xisfact	= "`xisfact' `s(factval)'"
		local xargnum	= "`xargnum' `narg'"
		local xtsvar	= "`xtsvar' `s(tsval)'"

		gettoken next paramlist: paramlist
	}
	
	sreturn clear
	
	local eval		`eval'
	local evallist		`evallist'
	local evalhasvar	`evalhasvar'
	local x		`x'
	local xprefix	`xprefix'
	local xisvar	`xisvar'
	local xismat	`xismat'
	local xislat	`xislat'
	local xisfact	`xisfact'
	local xinit	`xinit'
	local xomit	`xomit'
	local xargnum	`xargnum'
	local xparams	`xparams'
	local xtsvar	`xtsvar'
	
	sreturn local eval	= "`eval'"
	sreturn local evallist	= "`evallist'"
	sreturn local evalhasvar= "`evalhasvar'"
	sreturn local x		= "`x'"
	sreturn local xprefix	= "`xprefix'"
	sreturn local xisvar	= "`xisvar'"
	sreturn local xismat	= "`xismat'"
	sreturn local xislat	= "`xislat'"
	sreturn local xisfact   = "`xisfact'"
	sreturn local xinit	= "`xinit'"
	sreturn local xomit	= "`xomit'"
	sreturn local xargnum	= "`xargnum'"
	sreturn local xparams	= "`xparams'"
	sreturn local xtsvar	= "`xtsvar'"
	sreturn local narg	= `narg'
	
end

program _bayes_utils_setup_model, sclass

	args mcmcobject moptobject model yvars yoffsetvar paramlist exparlist	///
	reparlist relevellist restublist normalsig igamshape igamscale		///
	iwishartopts blsize reblocksok parseonly options 

	local 0 , `options'
	syntax [, GIBBS 		///
		  TOUSE(string)		///
		  WTYPE(string)		///
		  WEXP(string) *]
	local bayesoptions `options'

	local ismixed = "`model'" == "mixed"
	
	local isgibbs 0
	if `"`gibbs'"' == "gibbs" & ///
(`"`model'"' == "mixed" | `"`model'"' == "regress" | `"`model'"' == "mvreg") {
		local isgibbs = 1
	}
	local isvarlist `isgibbs'
	if `"`model'"' == "mvreg" {
		local isvarlist 1
	}

	cap _bayes_`model' `"`paramlist'"'
	if _rc == 199 {
		_bayes_generic `"`paramlist'"'
	}
	local paramprior  `s(paramprior)'
	local paramlist   `s(paramlist)'
	local paramlogfm  `s(paramlogfm)'
	local paramnoshow `s(paramnoshow)'
	local paramdispl  `s(paramdispl)'
	local paramblock  `s(paramblock)'

	if `isgibbs' & (`"`model'"' == "mixed" | `"`model'"' == "regress") {
		local model normal
		local moptobject
	}
	if `"`model'"' == "mvreg" {
		local model mvnormal
		local moptobject
		local d : word count `yvars'
		local paramlist `paramlist'
		_bayes_utils parse_paramlist `"`d' `paramlist'"' `isvarlist'
	}
	else {
		_bayes_utils parse_paramlist `"`paramlist'"' `isvarlist'
		local modelparams `s(xparams)'
		local x		`s(x)'
		local xprefix	`s(xprefix)'
		local xisvar	`s(xisvar)'
		local xislat	`s(xislat)'
		local xismat	`s(xismat)'
		local xinit	`s(xinit)'
		local xomit	`s(xomit)'
	}

	local iwishartdf 0
	local iwishartsc I
	while "`iwishartopts'" != "" {

		local iwisherr "option {bf:iwishartprior()} must contain positive degree of freedom and scale matrix or dots ({bf:.})"

		local 0 ,`iwishartopts'
		syntax [, IWISHARTPRior(string) *]
		local iwishartopts `options'

		if "`iwishartprior'" != "" {
			local 0 `iwishartprior'
			syntax [anything][, RELEVels(string) RESTUBs(string)/*undoc*/]
			tokenize "`iwishartprior'", parse(" ,")
			if "`1'" != "" & "`1'" != "." {
				local iwishartdf = `1'
				capture confirm number `iwishartdf'
				if _rc != 0 | `iwishartdf' <= 0 {
					di as err `"`iwisherr'"'
					exit 198
				}
			}
			if "`2'" != "" & "`2'" != "." & "`2'" != "," {
				capture confirm matrix `2'
				if _rc != 0 {
					di as err `"invalid matrix {bf:`2'}"'
					di as err `"`iwisherr'"'
					exit 198
				}
				local iwishartsc  = "`2'"
			}
			foreach stub of local restubs {
				if !`:list stub in restublist' {
					di as err `"{bf:`stub'} must be of one of the stubs {bf:`restublist'}"'
					exit 198
				}
				local iwishartdf_`stub' `iwishartdf'
				local iwishartsc_`stub' `iwishartsc'
			}

			foreach level of local relevels {
				if !`:list level in relevellist' {
					di as err `"{bf:`level'} must be of one of the levels {bf:`relevellist'}"'
					exit 198
				}
				local i : list posof `"`level'"' in relevellist
				local stub: word `i' of `restublist'
				local iwishartdf_`stub' `iwishartdf'
				local iwishartsc_`stub' `iwishartsc'
			}
		}
	}

	///////////////////////////////////////////////////
	// likelihood model
	
	mata: `mcmcobject'.add_distr_name(		///
		`"`model'"', "", "", 0, "", "", "")

	mata: `mcmcobject'.add_factor()

	local ys `yvars'
	if "`model'" == "normal" & "`yoffsetvar'" != "" {
		// likelihood equation for the difference: yvar-RE_spec
		local ny 1
		local ys `yoffsetvar'
		local yisvar  1
		local yislat  0
		local yismat  0
		local yprefix .
		local yinit   .
		local yomit   0
	}
	else {
		local ny : word count `yvars'
		local yisvar
		local yislat
		local yismat
		local yprefix
		local yinit
		local yomit
		while `ny' > 0 {
			local yisvar  `yisvar' 1
			local yislat  `yislat' 0
			local yismat  `yismat' 0
			local yprefix `yprefix' .
			local yinit   `yinit' .
			local yomit   `yomit' 0
			local ny = `ny' - 1
		}
	}

	mata: `mcmcobject'.set_factor(			///
		NULL,	 	 	 	 	///
		/*dist*/`"`model'"',	 		///
		"`s(eval)'", 				///
		"`s(evallist)'",			///
		"`s(evalhasvar)'",	 	 	///
		/*argcount*/"`s(narg)'",		///
		"`ys'",			 	 	///
		"`yisvar'",	 	 	 	///
		"`yislat'",	 	 	 	///
		"`yismat'",	 	 	 	///
		"`yprefix'",	 	 		///
		"`yinit'",	 	 	 	///
		"`yomit'",	 	 	 	///
		"`s(x)'",				///
		"`s(xisvar)'",	 	 	 	///
		"`s(xislat)'",	 	 	 	///
		"`s(xismat)'",	 	 	 	///
		"`s(xisfact)'",		 	 	///
		"`s(xprefix)'",	 	 		///
		"`s(xargnum)'",	 	 		///
		"`s(xinit)'",				///
		"`s(xomit)'",				///
		/*nocons*/"1",	 	 		///
		/*exparams*/"`reparlist'",              ///
		/*llevaluator*/"",			///
		/*extravars*/"",			///
		/*passthruopts*/"",                     ///
		"`moptobject'",				///
		/*predict*/"")

	if `"`model'"' == "mvnormal" {
		_bayes_utils parse_paramlist `"`paramlist'"' `isvarlist'
		local modelparams `s(xparams)'
		local x		`s(x)'
		local xprefix	`s(xprefix)'
		local xisvar	`s(xisvar)'
		local xislat	`s(xislat)'
		local xismat	`s(xismat)'
		local xinit	`s(xinit)'
		local xomit	`s(xomit)'
	}

	if `"`wexp'"' != "" {
		tempvar wexptemp
		qui generate double `wexptemp' = `wexp' if `touse'

		mata: `mcmcobject'.set_touse(		///
			NULL, 				///
			st_data(., "`touse'"),		///
			"",				///
			st_data(., "`wexptemp'"),	///
			"fweight", `"[`wtype'`wexp']"')
	}
	else {
		mata: `mcmcobject'.set_touse(		///
			NULL,				///
			st_data(., "`touse'"),		///
			"", J(1,0,0), "", "")
	}

	if `"`exparlist'"' != "" {
		cap _bayes_`model' `"`exparlist'"'
		if _rc == 199 {
			_bayes_generic `"`exparlist'"'
		}
		local paramprior  `paramprior' `s(paramprior)'
		local paramlist   `paramlist' `s(paramlist)'
		local paramlogfm  `paramlogfm' `s(paramlogfm)'
		local paramnoshow `paramnoshow' `s(paramnoshow)'
		local paramdispl  `paramdispl' `s(paramdispl)'
		local paramblock  `paramblock' `s(paramblock)'
		
		_bayes_utils parse_paramlist `"`exparlist'"' `isvarlist'

		local modelparams `modelparams' `s(xparams)'
		local x		`x' `s(x)'
		local xprefix	`xprefix' `s(xprefix)'
		local xisvar	`xisvar' `s(xisvar)'
		local xislat	`xislat' `s(xislat)'
		local xismat	`xismat' `s(xismat)'
		local xinit	`xinit' `s(xinit)'
		local xomit	`xomit' `s(xomit)'
	}

	// update beta_label lists
	local varlist0 `xprefix'
	local varlist  `x'
	gettoken lyvar varlist0 : varlist0
	gettoken next  varlist  : varlist
	local xisvar
	while `"`next'"' != "" { 
		if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
			_bayesmh_eqlablist ind `lyvar'
			_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
		}
		local xisvar `xisvar' 0
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
	}

	local list_eq_names	`yvars'
	local list_depvar_names `yvars'
	local list_par_names	`s(x)'
	local list_par_prefix   `s(xprefix)'
	local list_par_isvar	`s(xisvar)'
	local list_expr
	local extravars

	_bayesmh_check_parameters `""`list_par_names'""'	///
		`""`list_par_prefix'""'			///
		`""`list_par_isvar'""'			///
		`""`list_depvar_names'""'		///
		`""`list_eq_names'""'

	mata: `mcmcobject'.set_depvar_names(`"`s(depvar_names)'"')
	mata: `mcmcobject'.set_var_names   (`"`s(var_names)'"')
	mata: `mcmcobject'.set_eq_names    (`"`s(eq_names)'"')

	sreturn clear

	///////////////////////////////////////////////////
	// priors 

	local pardefined
	local optgibbslist
	if `"`bayesoptions'"' != "" {
	
		local singley ""
		tokenize $MCMC_eqlablist
		if `"`1'"' != "" & `"`2'"' == "" {
			local singley `1'
		}

	_bayes_prior_opt "`mcmcobject'" "`gtouse'" "`singley'" `"`bayesoptions'"'

	local bayesoptions	= `"`s(options)'"'
	local optinitial	= `"`s(optinitial)'"'
	local list_par_names	= `"`list_par_names' `s(list_par_names)'"'
	local list_par_prefix	= `"`list_par_prefix' `s(list_par_prefix)'"'
	local list_par_isvar	= `"`list_par_isvar' `s(list_par_isvar)'"'
	local list_expr		= `"`list_expr' `s(list_expr)'"'
	local extravars		= `"`extravars' `s(extravars)'"'
	// for these parameters Gibbs is optional
	 _mcmc_parse expand `s(defparamlist)'
	local optgibbslist = `"`s(eqline)'"'

		_bayesmh_check_parameters	///
			`""`list_par_names'""'	///
			`""`list_par_prefix'""'	///
			`""`list_par_isvar'""'

		mata: `mcmcobject'.set_var_names(`"`s(var_names)'"')
		mata: `mcmcobject'.add_list_expr(`"`list_expr'"'   )

		sreturn clear
		mata: `mcmcobject'.parse_equations_sreport()
		// it will fail if defnobraces has REs
		local pardefined `s(defnobraces)'

	} // if `"`bayesoptions'"' != ""

	// block options
	if "`reblocksok'" == "" {
		local allreffects `reparlist'
		foreach re of local reparlist {
			tokenize `"`re'"', parse("[]")
			local allreffects `allreffects' `1'
		}
		// preclude reffects option to be applied to REs
		_bayes_block_opt "`gtouse'" `"`bayesoptions'"' "`allreffects'" "forcereopt"
	}
	else {
		_bayes_block_opt "`gtouse'" `"`bayesoptions'"' "" "forcereopt"
	}
	local bayesoptions  = `"`s(simoptions)'"'
	local blockparlist = `"`s(blockparlist)'"'
	if `ismixed' {
		local optgibbslist: list optgibbslist - blockparlist
		mata: `mcmcobject'.add_opt_gibbs_list(`"`optgibbslist'"')
	}

	local blockind 0
	local gibbsappl 0

	if `"`s(blocksline)'"'' != "" {
		_mcmc_parse blocks `s(blocksline)'
		local blparams `s(fullparams)'
		mata: `mcmcobject'.set_blocks(				///
		`"`s(params)'"',  `"`s(parids)'"', `"`s(prefix)'"',	///
		`"`s(matrix)'"',  `"`s(latent)'"',	 		///
		`"`s(sampler)'"', `"`s(split)'"',	 		///
		`"`s(scale)'"',   `"`s(cov)'"',	 	 		///
		`"`s(arate)'"',   `"`s(atol)'"')
		local blockind : word count `s(parids)'
		local blockind : word `blockind' of `s(parids)'
	}

	local undefined1 : list paramlist - pardefined
	// remove A:Sigma_d from paramlist if A:Sigma is in pardefined
	local undefined
	foreach par of local undefined1 {
		local tok = regexr("`par'", "Sigma_[1-9]+", "Sigma")
		local tok : list tok in pardefined
		if "`tok'" == "0" {
			local undefined `undefined' `par'
		}
	}

	if `"`undefined'"' != "" {
		local paramprior1  `paramprior'
		local paramnoshow1 `paramnoshow'
		local paramdispl1  `paramdispl'
		local paramblock1  `paramblock'
		local paramprior  
		local paramnoshow 
		local paramdispl  
		local paramblock 
		foreach param of local paramlist {
			gettoken tok1 paramprior1  : paramprior1
			gettoken tok2 paramnoshow1 : paramnoshow1
			gettoken tok3 paramdispl1  : paramdispl1
			gettoken tok4 paramblock1  : paramblock1
			local noskip : list param in undefined
			if `noskip' {
				local paramprior `paramprior' `tok1'
				local paramnoshow `paramnoshow' `tok2' 
				local paramdispl `paramdispl' `tok3'  
				local paramblock `paramblock' `tok4'
			}
		}

		_bayes_utils parse_paramlist `"`undefined'"' `isvarlist'

		local x		`s(x)'
		local xprefix	`s(xprefix)'
		local xisvar	`s(xisvar)'
		local xislat	`s(xislat)'
		local xismat	`s(xismat)'
		local xinit	`s(xinit)'
		local xomit	`s(xomit)'
		local xparams   `s(xparams)'

		if `"`model'"' == "mvnormal" || `"`model'"' == "normal" {
			// reset xisvar to 0
			local varlist  `x'
			gettoken next varlist:varlist
			local xisvar
			while `"`next'"' != "" { 
				local xisvar `xisvar' 0
				gettoken next varlist:varlist
			}
		}

		mata: _bayes_utils_set_priors(			///
			`mcmcobject',	 			///
			"`x'",	 		 		///
			"`xprefix'",	 	 		///
			"`xisvar'",	 	 	 	///
			"`xislat'",	 	 	 	///
			"`xismat'",	 	 	 	///
			"`xinit'",				///
			"`xomit'",				///
			"`paramprior'",				///
			"`paramblock'",				///
			"blockind", 				///
			`normalsig', `igamshape', `igamscale',	///
			`iwishartdf', "`iwishartsc'", `blsize',	///
			`isgibbs', `parseonly', "defpriors", 	///
			"gibbsappl", `ismixed')

		if `normalsig' != $BAYES_NORMALSIG | ///
		`igamshape' != $BAYES_GAMSHAPE | `igamscale' != $BAYES_GAMSCALE {
			// if default prior parameters change, 
			// then assume to be user supplied priors and don't show 
			// 'default priors used' note
			//local undefined
		}
	}

	if `"`pardefined'"' != "" {

		_bayes_utils parse_paramlist `"`pardefined'"' `isvarlist'

		local x		`s(x)'
		local xprefix	`s(xprefix)'
		local xisvar	`s(xisvar)'
		local xislat	`s(xislat)'
		local xismat	`s(xismat)'
		local xinit	`s(xinit)'
		local xomit	`s(xomit)'

		if `"`model'"' == "mvnormal" || `"`model'"' == "normal" {
			// reset xisvar to 0
			local varlist  `x'
			gettoken next varlist:varlist
			local xisvar
			while `"`next'"' != "" { 
				local xisvar `xisvar' 0
				gettoken next varlist:varlist
			}
		}

		mata: _bayes_utils_set_blocks(			///
			`mcmcobject',	 			///
			"`x'",	 		 		///
			"`xprefix'",	 	 		///
			"`xisvar'",	 	 	 	///
			"`xislat'",	 	 	 	///
			"`xismat'",	 	 	 	///
			"`xinit'",				///
			"`xomit'",				///
			"blockind", 				///
			`blsize', `isgibbs', "gibbsappl")
			
	}

	local blparams : list paramlist - blparams
	if `"`blparams'"' == "" {
		local gibbsappl 0
	}

	sreturn clear
	sreturn local pardefined  = `"`pardefined'"'
	sreturn local paramlist   = `"`paramlist'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local optinitial  = `"`optinitial'"'
	sreturn local options     = `"`bayesoptions'"'
	sreturn local defpriors   = `"`defpriors'"'
	sreturn local defparlist  = `"`undefined'"'
	sreturn local gibbsappl   = `"`gibbsappl'"'
end

mata:

function _bayes_utils_set_priors(
	class _c_mcmc_model scalar mcmcobject, 
	string scalar sx, 
	string scalar sxprefix,
	string scalar sxisvar,
	string scalar sxislat,
	string scalar sxismat,
	string scalar sxinit,
	string scalar sxomit,
	string scalar sxprior,
	string scalar sxblock,
	string scalar sblockind,
	real   scalar normalsig,
	real   scalar igamshape,
	real   scalar igamscale,
	real   scalar iwishartdf,
	string scalar iwishartsc,
	real   scalar maxblsize,
	real   scalar isgibbs, 
	real   scalar parseonly, 
	string scalar ldefpriors, 
	string scalar sgibbsappl,
	real scalar ismixed)
{
	real scalar nx, i, j, dim, bnew, blockind, gibbsappl, df, addblock
	real rowvector ind, subind, ind2, xblock, bind
	string rowvector x, xprefix, xisvar, xislat, xismat, xinit, xomit, toks
	string rowvector xprior, bparams, bparids, bprefix, bmatrix, blatent
	string rowvector bsampler, bsplit, bscale, bcov, barate, batol
	string scalar sdistparams, sindpref, lab, sdefpriors
	real matrix stubcov

	pragma unused ismixed
	
	if (normalsig <= 0) {
		error(198)
	}
	if (igamshape <= 0 || igamscale <= 0) {
		error(198)
	}
	if (maxblsize < 1) {
		error(198)
	}
	maxblsize = floor(maxblsize)

	blockind = strtoreal(st_local(sblockind))
	if (blockind >= . | blockind < 0) blockind = 0

	x       = tokens(sx)
	nx      = length(x)

	xprefix = tokens(sxprefix)
	if (length(xprefix) != nx) {
		error(503)
	}
	xisvar  = tokens(sxisvar)
	if (length(xisvar) != nx) {
		error(503)
	}
	xislat  = tokens(sxislat)
	if (length(xislat) != nx) {
		error(503)
	}
	xismat  = tokens(sxismat)
	if (length(xismat) != nx) {
		error(503)
	}
	xinit   = tokens(sxinit)
	if (length(xinit) != nx) {
		error(503)
	}
	xomit   = tokens(sxomit)
	if (length(xomit) != nx) {
		error(503)
	}
	xprior  = tokens(sxprior)
	if (length(xprior) != nx) {
		error(503)
	}

	xblock  = strtoreal(tokens(sxblock))
	if (length(xblock) != nx) {
		error(503)
	}

	// block index
	bind     = blockind
	bparams  = J(1, 0, "")
	bparids  = J(1, 0, "")
	bprefix  = J(1, 0, "")
	bmatrix  = J(1, 0, "")
	blatent  = J(1, 0, "")
	bsampler = J(1, 0, "")
	bsplit   = J(1, 0, "")
	bscale   = J(1, 0, "")
	bcov     = J(1, 0, "")
	barate   = J(1, 0, "")
	batol    = J(1, 0, "")

	sdefpriors = ""
	gibbsappl = 0

	// normal prior
	ind = J(1,0,0)
	for (i = 1; i <= nx; i++) {
		if(xprior[i] == "normal") {
			ind = (ind, i)
		}
	}
	while (length(ind) > 0) {

		bind = bind + 1

		ind2     = J(1,0,0)
		subind   = J(1,0,0)
		// block by parameter labels
		sindpref = xprefix[ind[1]]
		bnew     = 0
		addblock = 0
		for(j = 1; j <= length(ind); j++) {
			
	if (xprefix[ind[j]] == sindpref & length(subind) < maxblsize & !bnew) {

		subind = (subind, ind[j])
		bparams  = (bparams,  x[ind[j]])
		if (xblock[ind[j]] == 1 & bind > 1) {
			bparids  = (bparids,  sprintf("%g", bind-1))
		}
		else {
			addblock = 1
			bparids  = (bparids,  sprintf("%g", bind))
		}
		bprefix  = (bprefix,  xprefix[ind[j]])
		bmatrix  = (bmatrix,  "0")
		blatent  = (blatent,  "0")
		if (xblock[ind[j]] == 2) bnew = 1
	}
	else {
		ind2 = (ind2, ind[j])
	}

		}
		if (addblock) {
			if (isgibbs) {
				bsampler = (bsampler, "gibbs")
				gibbsappl = 1
			}
			else {
				bsampler = (bsampler, "grw")
			}
			bsplit   = (bsplit,   "0")
			bscale   = (bscale,   "0")
			bcov     = (bcov,     ".")
			barate   = (barate,   "0")
			batol    = (batol,    "0.01")
		}
		ind = ind2

		if (sum(xomit[subind] :== "0") == 0) {
			continue
		}

		if (!parseonly) {
			mcmcobject.add_prior_name("normal", 
			invtokens(x[subind]), invtokens(xprefix[subind]))
		}

		sdistparams = sprintf("0 %16.0g", normalsig^2)

		mcmcobject.add_factor()	
		mcmcobject.set_factor(	NULL,
					"normal",
			/*eval*/	"NULL NULL",
			/*evallist*/	"NULL NULL",
			/*exprhasvar*/	"0 0",
					"2",
					invtokens(x[subind]),
					invtokens(xisvar[subind]),
					invtokens(xislat[subind]),
					invtokens(xismat[subind]),
					invtokens(xprefix[subind]),
					invtokens(xinit[subind]),
					invtokens(xomit[subind]),
			/*x*/		sdistparams,
			/*xisvar*/	"0 0",
			/*xislat*/	"0 0",
			/*xismat*/	"0 0",
			/*xisfact*/	"0 0",
			/*xprefix*/	". .",
			/*xargnum*/	"1 2",
			/*xinit*/	". .",
			/*xomit*/	"0 0",
			/*nocons*/	"1",
			/*exparams*/	"",
			/*llevaluator*/	"",
			/*extravars*/	"",
			/*passthruopts*/"",
			/*moptobject*/	"",
			/*predict*/"")

		sdistparams = invtokens(tokens(sdistparams), ", ")
		if (sindpref != ".") {
			sdefpriors = sprintf("%s prior({%s:%s}, normal(%s))", 
			sdefpriors, sindpref, invtokens(x[subind]), sdistparams)
		}
		else {
			sdefpriors = sprintf("%s prior({%s}, normal(%s))", 
			sdefpriors, invtokens(x[subind]), sdistparams)
		}
		
		mcmcobject.drop_pdist()
	} // normal prior

	// igamma prior
	ind = J(1,0,0)
	for (i = 1; i <= nx; i++) {
		if(xprior[i] == "igamma") {
			ind = (ind, i)
		}
	}
	while (length(ind) > 0) {
	
		bind = bind + 1
		
		ind2     = J(1,0,0)
		subind   = J(1,0,0)
		sindpref = xprefix[ind[1]]
		bnew     = 0
		addblock = 0
		for(j = 1; j <= length(ind); j++) {
		
	if (xprefix[ind[j]] == sindpref & length(subind) < maxblsize & !bnew) {

		subind = (subind, ind[j])
		bparams  = (bparams,  x[ind[j]])
		if (xblock[ind[j]] == 1 & bind > 1) {
			bparids  = (bparids,  sprintf("%g", bind-1))
		}
		else {
			addblock = 1
			bparids  = (bparids,  sprintf("%g", bind))
		}
		bprefix  = (bprefix,  xprefix[ind[j]])
		bmatrix  = (bmatrix,  "0")
		blatent  = (blatent,  "0")
		if (xblock[ind[j]] == 2) bnew = 1
	}
	else {
		ind2 = (ind2, ind[j])
	}

		}
		if (addblock) {
			if (isgibbs) {
				bsampler = (bsampler, "gibbs")
				gibbsappl = 1
			}
			else {
				bsampler = (bsampler, "grw")
			}
			if (length(ind) > 0) {
				bsplit   = (bsplit,   "0")
				bscale   = (bscale,   "0")
				bcov     = (bcov,     ".")
				barate   = (barate,   "0")
				batol    = (batol,    "0.01")
			}
		}
		ind = ind2
		
		if (sum(xomit[subind] :== "0") == 0) {
			continue
		}

		if (!parseonly) {
			mcmcobject.add_prior_name("igamma", 
			invtokens(x[subind]), invtokens(xprefix[subind]))
		}

		sdistparams = sprintf("%16.0g %16.0g", igamshape, igamscale)

		mcmcobject.add_factor()	
		mcmcobject.set_factor(	NULL,
					"igamma",
			/*eval*/	"NULL NULL",
			/*evallist*/	"NULL NULL",
			/*exprhasvar*/	"0 0",
					"2",
					invtokens(x[subind]),
					invtokens(xisvar[subind]),
					invtokens(xislat[subind]),
					invtokens(xismat[subind]),
					invtokens(xprefix[subind]),
					invtokens(xinit[subind]),
					invtokens(xomit[subind]),
			/*x*/		sdistparams,
			/*xisvar*/	"0 0",
			/*xislat*/	"0 0",
			/*xismat*/	"0 0",
			/*xisfact*/	"0 0",
			/*xprefix*/	". .",
			/*xargnum*/	"1 2",
			/*xinit*/	". .",
			/*xomit*/	"0 0",
			/*nocons*/	"1",
			/*exparams*/	"",
			/*llevaluator*/	"",
			/*extravars*/	"",
			/*passthruopts*/"",
			/*moptobject*/	"",
			/*predict*/"")

		sdistparams = invtokens(tokens(sdistparams), ", ")
		if (sindpref != ".") {
			sdefpriors = sprintf("%s prior({%s:%s}, igamma(%s))", 
			sdefpriors, sindpref, invtokens(x[subind]), sdistparams)
		}
		else {
			sdefpriors = sprintf("%s prior({%s}, igamma(%s))", 
			sdefpriors, invtokens(x[subind]), sdistparams)
		}
		
		mcmcobject.drop_pdist()
	} // igamma prior

	// jeffreys prior
	ind = J(1,0,0)
	lab = ""
	dim = 0
	for (i = 1; i <= nx; i++) {
		if (length(ind) == 0 & substr(xprior[i], 1, 8) == "jeffreys") {
			lab = xprior[i]
			dim = strtoreal(substr(xprior[i], 10, length(xprior[i])))
		}
		if (xprior[i] == lab) {
			ind = (ind, i)
		}
	}
	while (length(ind) > 0) {
	
		bind = bind + 1
		
		subind = (subind, ind)

		bparams  = (bparams,  "Sigma")
		bparids  = (bparids,  sprintf("%g", bind))
		bprefix  = (bprefix,  ".")
		bmatrix  = (bmatrix,  "1")
		blatent  = (blatent,  "0")
		if (isgibbs) {
			bsampler = (bsampler, "gibbs")
			gibbsappl = 1
		}
		else {
			bsampler = (bsampler, "grw")
		}
		bsplit   = (bsplit,   "0")
		bscale   = (bscale,   "0")
		bcov     = (bcov,     ".")
		barate   = (barate,   "0")
		batol    = (batol,    "0.01")

		if (!parseonly) {
			mcmcobject.add_prior_name("jeffreys", "Sigma", ".")
		}
		
		sdistparams = sprintf("%g", dim)

		mcmcobject.add_factor()	
		mcmcobject.set_factor(	NULL,
					"jeffreys",
			/*eval*/	"NULL",
			/*evallist*/	"NULL",
			/*exprhasvar*/	"0",
					"1",
					"Sigma",
			/*yisvar*/	"0",
			/*yislat*/	"0",
			/*yismat*/	"1",
			/*yprefix*/ 	".",
			/*yinit*/	".",
			/*yomit*/	"0",
			/*x*/		sdistparams,
			/*xisvar*/	"0",
			/*xislat*/	"0",
			/*xismat*/	"0",
			/*xisfact*/	"0",
			/*xprefix*/	".",
			/*xargnum*/	"1",
			/*xinit*/	".",
			/*xomit*/	"0",
			/*nocons*/	"1",
			/*exparams*/	"",
			/*llevaluator*/	"",
			/*extravars*/	"",
			/*passthruopts*/"",
			/*moptobject*/	"",
			/*predict*/"")

		sdistparams = invtokens(tokens(sdistparams), ", ")
		if (sindpref != ".") {
			sdefpriors = sprintf("%s prior({%s:%s}, jeffreys(%s))", 
			sdefpriors, sindpref, invtokens(x[subind]), sdistparams)
		}
		else {
			sdefpriors = sprintf("%s prior({%s}, jeffreys(%s))", 
			sdefpriors, invtokens(x[subind]), sdistparams)
		}
			
		mcmcobject.drop_pdist()
		
		ind = J(1, 0, 0)
	} // jeffreys prior

	// flat prior
	ind = J(1,0,0)
	for (i = 1; i <= nx; i++) {
		if(xprior[i] == "flat") {
			ind = (ind, i)
		}
	}
	while (length(ind) > 0) {
	
		bind = bind + 1

		ind2     = J(1,0,0)
		subind   = J(1,0,0)
		sindpref = xprefix[ind[1]]
		bnew     = 0
		addblock = 0
		for(j = 1; j <= length(ind); j++) {
			
	if (xprefix[ind[j]] == sindpref & length(subind) < maxblsize & !bnew) {

		subind = (subind, ind[j])
		bparams  = (bparams,  x[ind[j]])
		if (xblock[ind[j]] == 1 & bind > 1) {
			bparids  = (bparids,  sprintf("%g", bind-1))
		}
		else {
			addblock = 1
			bparids  = (bparids,  sprintf("%g", bind))
		}
		bprefix  = (bprefix,  xprefix[ind[j]])
		bmatrix  = (bmatrix,  "0")
		blatent  = (blatent,  "0")
		if (xblock[ind[j]] == 2) bnew = 1
	}
	else {
		ind2 = (ind2, ind[j])
	}

		}
		if (addblock) {
			bsampler = (bsampler, "grw")
			bsplit   = (bsplit,   "0")
			bscale   = (bscale,   "0")
			bcov     = (bcov,     ".")
			barate   = (barate,   "0")
			batol    = (batol,    "0.01")
		}
		ind = ind2

		if (sum(xomit[subind] :== "0") == 0) {
			continue
		}

		if (!parseonly) {
			mcmcobject.add_prior_name("flat", 
			invtokens(x[subind]), invtokens(xprefix[subind]))
		}

		mcmcobject.add_factor()	
		mcmcobject.set_factor(	NULL,
					"logdensity",
			/*eval*/	"NULL",
			/*evallist*/	"NULL",
			/*exprhasvar*/	"0",
					"1",
					invtokens(x[subind]),
					invtokens(xisvar[subind]),
					invtokens(xislat[subind]),
					invtokens(xismat[subind]),
					invtokens(xprefix[subind]),
					invtokens(xinit[subind]),
					invtokens(xomit[subind]),
			/*x*/		"0",
			/*xisvar*/	"0",
			/*xislat*/	"0",
			/*xismat*/	"0",
			/*xisfact*/	"0",
			/*xprefix*/	".",
			/*xargnum*/	"1",
			/*xinit*/	".",
			/*xomit*/	"0",
			/*nocons*/	"1",
			/*exparams*/	"",
			/*llevaluator*/	"",
			/*extravars*/	"",
			/*passthruopts*/"",
			/*moptobject*/	"",
			/*predict*/"")

		sdistparams = invtokens(tokens(sdistparams), ", ")
		if (sindpref != ".") {
			sdefpriors = sprintf("%s prior({%s:%s}, flat)", 
				sdefpriors, sindpref, invtokens(x[subind]))
		}
		else {
			sdefpriors = sprintf("%s prior({%s}, flat)", 
				sdefpriors, invtokens(x[subind]))
		}
		mcmcobject.drop_pdist()
	} // flat prior

	// iwishart prior
	for (i = 1; i <= length(xprior); i++) {
	
		if(xprior[i] != "iwishart") {
			continue
		}

		sindpref = xprefix[i]
		toks = tokens(x[i], "_")
		x[i] = toks[1]
		dim = 0
		if (length(toks) >= 3) {
			dim = strtoreal(toks[length(toks)])
		}
		if (dim <= 0 | dim >= .) {
			dim = 1
		}

		bind = bind + 1
		bparams  = (bparams,  x[i])
		bparids  = (bparids,  sprintf("%g", bind))
		bprefix  = (bprefix,  xprefix[i])
		bmatrix  = (bmatrix,  "1")
		blatent  = (blatent,  "0")
		if (isgibbs) {
			bsampler = (bsampler, "gibbs")
			gibbsappl = 1
		}
		else {
			bsampler = (bsampler, "grw")
		}
		bsplit   = (bsplit,   "0")
		bscale   = (bscale,   "0")
		bcov     = (bcov,     ".")
		barate   = (barate,   "0")
		batol    = (batol,    "0.01")

		if (!parseonly) {
			mcmcobject.add_prior_name("iwishart", 
			invtokens(x[i]), invtokens(xprefix[i]))
		}

		df = iwishartdf
		if (df == 0) {
			df = dim + 1
		}
		lab = st_local(sprintf("iwishartdf_%s", xprefix[i]))
		if (strtoreal(lab) != .) {
			df = strtoreal(lab)
		}
		if (df <= dim-1) {
			errprintf(sprintf(
"option {bf:iwishartprior()} must contain degree of freedom greater than %g\n", dim-1)) 
			exit(198)
		}
		lab = st_local(sprintf("iwishartsc_%s", xprefix[i]))
		if (lab != "") {
			if (lab == "I") {
				stubcov = diag(J(dim,1,1))
			}
			else {
				stubcov = st_matrix(lab)
			}
			if (rows(stubcov) != dim | cols(stubcov) != dim) {
				errprintf(sprintf(
"matrix {bf:%s} should be square matrix of dimension %g\n", lab, dim)) 
			exit(198)
			}
			
			if (!issymmetric(stubcov) | det(stubcov) <= 0) {
				errprintf(sprintf(
"matrix {bf:%s} should be symmetric and positive definite\n", lab)) 
			exit(198)
			}
			iwishartsc = lab
		}
		if (iwishartsc != "" & iwishartsc != "I") {
			sdistparams = sprintf("%g %g %s", dim, df, iwishartsc)
		}
		else {
			sdistparams = sprintf("%g %g I(%g)", dim, df, dim)
		}

		mcmcobject.add_factor()	
		mcmcobject.set_factor(	NULL,
					"iwishart",
			/*eval*/	"NULL NULL NULL",
			/*evallist*/	"NULL NULL NULL",
			/*exprhasvar*/	"0 0 0",
					"3",
					invtokens(x[i]),
					invtokens(xisvar[i]),
					invtokens(xislat[i]),
					invtokens(xismat[i]),
					invtokens(xprefix[i]),
					invtokens(xinit[i]),
					invtokens(xomit[i]),
			/*x*/		sdistparams,
			/*xisvar*/	"0 0 1",
			/*xislat*/	"0 0 0",
			/*xismat*/	"0 0 1",
			/*xisfact*/	"0 0 0",
			/*xprefix*/	". . .",
			/*xargnum*/	"1 2 3",
			/*xinit*/	". . .",
			/*xomit*/	"0 0 0",
			/*nocons*/	"1",
			/*exparams*/	"",
			/*llevaluator*/	"",
			/*extravars*/	"",
			/*passthruopts*/"",
			/*moptobject*/	"",
			/*predict*/"")

		sdistparams = invtokens(tokens(sdistparams), ", ")
		if (sindpref != ".") {
			sdefpriors = sprintf("%s prior({%s:%s}, iwishart(%s))", 
			sdefpriors, sindpref, invtokens(x[subind]), sdistparams)
		}
		else {
			sdefpriors = sprintf("%s prior({%s}, iwishart(%s))", 
			sdefpriors, invtokens(x[subind]), sdistparams)
		}
		
		mcmcobject.drop_pdist()
	} // iwishart prior
	
	st_local(ldefpriors, sdefpriors)
	st_local(sgibbsappl, sprintf("%g", gibbsappl))
	st_local(sblockind, sprintf("%g", bind))

	mcmcobject.set_blocks(
		invtokens(bparams), invtokens(bparids), 
		invtokens(bprefix), invtokens(bmatrix), 
		invtokens(blatent), invtokens(bsampler), 
		invtokens(bsplit),  invtokens(bscale), 
		invtokens(bcov), invtokens(barate), invtokens(batol))
}

function _bayes_utils_set_blocks(
	class _c_mcmc_model scalar mcmcobject, 
	string scalar sx, 
	string scalar sxprefix,
	string scalar sxisvar,
	string scalar sxislat,
	string scalar sxismat,
	string scalar sxinit,
	string scalar sxomit,
	string scalar sblockind,
	real   scalar maxblsize,
	real   scalar isgibbs,  
	string scalar sgibbsappl)
{
	real scalar nx, j, gibbsappl
	real rowvector ind, subind, ind2, bind, blockind
	string rowvector x, xprefix, xisvar, xislat, xismat, xinit, xomit
	string rowvector bparams, bparids, bprefix, bmatrix, blatent
	string rowvector bsampler, bsplit, bscale, bcov, barate, batol
	string scalar sindpref

	maxblsize = floor(maxblsize)

	blockind = strtoreal(st_local(sblockind))
	if (blockind >= . | blockind < 0) blockind = 0

	x       = tokens(sx)
	nx      = length(x)

	xprefix = tokens(sxprefix)
	if (length(xprefix) != nx) {
		error(503)
	}
	xisvar  = tokens(sxisvar)
	if (length(xisvar) != nx) {
		error(503)
	}
	xislat  = tokens(sxislat)
	if (length(xislat) != nx) {
		error(503)
	}
	xismat  = tokens(sxismat)
	if (length(xismat) != nx) {
		error(503)
	}
	xinit   = tokens(sxinit)
	if (length(xinit) != nx) {
		error(503)
	}
	xomit   = tokens(sxomit)
	if (length(xomit) != nx) {
		error(503)
	}

	// block index
	bind     = blockind
	bparams  = J(1, 0, "")
	bparids  = J(1, 0, "")
	bprefix  = J(1, 0, "")
	bmatrix  = J(1, 0, "")
	blatent  = J(1, 0, "")
	bsampler = J(1, 0, "")
	bsplit   = J(1, 0, "")
	bscale   = J(1, 0, "")
	bcov     = J(1, 0, "")
	barate   = J(1, 0, "")
	batol    = J(1, 0, "")

	gibbsappl = 0

	// normal prior
	ind = 1..length(x)
	while (length(ind) > 0) {

		bind = bind + 1

		ind2     = J(1,0,0)
		subind   = J(1,0,0)
		// block by parameter labels
		sindpref = xprefix[ind[1]]

		for(j = 1; j <= length(ind); j++) {
			if (xprefix[ind[j]] == sindpref & 
			length(subind) < maxblsize) {
				subind = (subind, ind[j])
				bparams  = (bparams,  x[ind[j]])
				bparids  = (bparids,  sprintf("%g", bind))
				bprefix  = (bprefix,  xprefix[ind[j]])
				bmatrix  = (bmatrix,  "0")
				blatent  = (blatent,  "0")
			}
			else {
				ind2 = (ind2, ind[j])
			}
		}

		if (isgibbs) {
			bsampler = (bsampler, "gibbs")
			gibbsappl = 1
		}
		else {
			bsampler = (bsampler, "grw")
		}
		bsplit   = (bsplit,   "0")
		bscale   = (bscale,   "0")
		bcov     = (bcov,     ".")
		barate   = (barate,   "0")
		batol    = (batol,    "0")
		ind = ind2
	}

	st_local(sblockind, sprintf("%g", bind))
	st_local(sgibbsappl, sprintf("%g", gibbsappl))

	mcmcobject.set_blocks(
		invtokens(bparams), invtokens(bparids), 
		invtokens(bprefix), invtokens(bmatrix), 
		invtokens(blatent), invtokens(bsampler), 
		invtokens(bsplit),  invtokens(bscale), 
		invtokens(bcov), invtokens(barate), invtokens(batol))
}

end

/* default flat priors for an unknown command */
program _bayes_generic, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_regress, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /var or /cov
			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			gettoken pre : lab, parse(".")
			if `"`tok'"' == "var" {
				local paramprior `paramprior' igamma
				if `"`lab'"' == "" | `"`pre'"' == "e" {
					local newparams `newparams' sigma2
				}
				else {
					local newparams `newparams' `lab':sigma2
				}
				local paramlogfm `paramlogfm' 0
				local paramblock `paramblock' 0
			}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_mixed, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /var or /cov
			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			gettoken pre : lab, parse(".")
			if `"`tok'"' == "var" {
				local paramprior `paramprior' igamma
				if `"`lab'"' != "" | `"`pre'"' == "e" {
					local newparams `newparams' `lab':sigma2
				}
				else if `"`lab'"' == "" | `"`pre'"' == "e" {
					local newparams `newparams' sigma2
				}
				else {
					local newparams `newparams' `lab':sigma2
				}
				local paramlogfm `paramlogfm' 0
				local paramblock `paramblock' 0
			}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_tobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /var or /cov
			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			gettoken pre : lab, parse(".")
			if `"`tok'"' == "var" {
				local paramprior `paramprior' igamma
				if `"`lab'"' == "" | `"`pre'"' == "e" {
					local newparams `newparams' sigma2
				}
				else {
					local newparams `newparams' `lab':sigma2
				}
				local paramlogfm `paramlogfm' 0
				local paramblock `paramblock' 0
			}	
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_mvreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	// find the dimension d
	local d 0
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" {
			gettoken tok lab : lab, parse("()")
			if `"`tok'"' == "var" {
				local d = `d' + 1
			}
		}
		gettoken next paramlist : paramlist
	}

	local sigma ""
	local paramlist `0'

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /var or /cov
			gettoken tok lab : lab, parse("()")
			gettoken lab : lab, parse("()") match(paren)
			if `"`tok'"' == "var" | `"`tok'"' == "cov" {
				if (`"`sigma'"' == "") {
			local sigma Sigma
			local paramprior `paramprior' jeffreys(`d')
			local newparams `newparams' `sigma'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {Sigma}
			local paramblock `paramblock' 0
				}
			}	
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_poisson, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_cpoisson, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_tpoisson, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_tnbreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
			local paramdispl `paramdispl' (alpha:exp({lnalpha}))
		}
		else if `"`lab'"' == "lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha`par'
			local paramdispl `paramdispl' {lnalpha`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_truncreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/sigma" {
			local paramprior `paramprior' igamma
			local newparams `newparams' sigma2
			local paramlogfm `paramlogfm' 5
			//local paramprior `paramprior' normal
			//local newparams `newparams' lnsigma
			//local paramlogfm `paramlogfm' 4
			local paramdispl `paramdispl' (sigma:sqrt({sigma2}))
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
		}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_fracreg_probit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_fracreg_logit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_intreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		if `"`next'"' == "lnsigma:_cons" {
			// igamma prior for sigma2
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {lnsigma}
			local paramdispl `paramdispl' (sigma:exp({lnsigma}))
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
		}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_glm, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			gettoken tok next : next, parse("/")
			gettoken par lab : next, parse("(") bind match(paren)
			if `"`par'"' == "var" {
				gettoken par : lab, parse("()") bind match(paren)
				local next `par':sigma2
				local par sigma2
			}
		}
		gettoken lab par : next, parse(":")
		if `"`lab'"' != "" & `"`par'"' != "" {
			gettoken tok par : par, parse(":")
		}
		if `"`par'"' == "sigma2" {
			local paramprior `paramprior' igamma
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		else if `"`par'"' == "logs" {
			local paramprior `paramprior' normal
			local newparams `newparams' logs
			local paramdispl `paramdispl' {logs}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_probit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_oprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			local paramprior `paramprior' flat
			local newparams `newparams' `lab'
			local paramlogfm `paramlogfm' 0
			local paramblock `paramblock' 1
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 1
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_hetoprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			local paramprior `paramprior' flat
			local newparams `newparams' `lab'
			local paramlogfm `paramlogfm' 0
			local paramblock `paramblock' 1
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 1
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_mprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_ivprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	// athrho2  = 0.5*ln((1+rho)/(1-rho)) is in (-inf,+inf)
	// lnsigma1 = ln(Sigma_1_1) is fixed to 0
	// lnsigma2 = ln(Sigma_2_2)
	gettoken next paramlist : paramlist
	gettoken eqlab : next, parse(":")
	// `eqlab' is the response variable
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`lab'"' == "lnsigma2" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma2`par'
			local paramdispl `paramdispl' {lnsigma2`par'}
		}
		else if `"`lab'"' == "athrho2_1" {
		// flat prior for athrho2
			local paramprior `paramprior' normal
			local newparams `newparams' athrho`par'
			local paramdispl `paramdispl' {athrho`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		// do not show instrument's coefficients
		gettoken lnext : next, parse(":")
		capture confirm variable `lnext'
		if _rc == 0 & `"`lnext'"' != `"`eqlab'"' {
			local paramnoshow `paramnoshow' `next'
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_biprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		if `"`next'"' == "/athrho" {
			local paramprior `paramprior' normal
			local newparams `newparams' athrho
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {athrho}
			local paramdispl `paramdispl' (rho:tanh({athrho}))
			local paramblock `paramblock' 0
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_hetprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`lab'"' == "lnsigma2" {
			local paramprior `paramprior' normal
			if c(userversion) >= 16 {
				local newparams `newparams' lnsigma`par'
			}
			else {
				local newparams `newparams' lnsigma2`par'
			}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_heckman, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	// /athrho  = 0.5*ln((1+rho)/(1-rho)) is in (-inf,+inf)
	gettoken next paramlist : paramlist
	gettoken eqlab : next, parse(":")
	// `eqlab' is the response variable
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {lnsigma}
			local paramdispl `paramdispl' (sigma:exp({lnsigma2}))
			local paramblock `paramblock' 2
		}
		else if `"`next'"' == "/athrho" {
			local paramprior `paramprior' normal
			local newparams `newparams' athrho
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {athrho}
			local paramdispl `paramdispl' (rho:tanh({athrho}))
			local paramblock `paramblock' 2
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_heckprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	// /athrho  = 0.5*ln((1+rho)/(1-rho)) is in (-inf,+inf)
	gettoken next paramlist : paramlist
	gettoken eqlab : next, parse(":")
	// `eqlab' is the response variable
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/athrho" {
			local paramprior `paramprior' normal
			local newparams `newparams' athrho
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {athrho}
			local paramdispl `paramdispl' (rho:tanh({athrho}))
			local paramblock `paramblock' 2
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_heckoprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`next'"' == "/athrho" {
			local paramprior `paramprior' normal
			local newparams `newparams' athrho
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {athrho}
			local paramdispl `paramdispl' (rho:tanh({athrho}))
			local paramblock `paramblock' 2
		}
		else if `"`tok'"' == "/" { // must be /cut#
			local paramprior `paramprior' flat
			local newparams `newparams' `lab'
			local paramlogfm `paramlogfm' 0
			// add cut points to the 1st, y-block
			local paramblock `paramblock' 1
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_heckpoisson, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	// /athrho  = 0.5*ln((1+rho)/(1-rho)) is in (-inf,+inf)
	gettoken next paramlist : paramlist
	gettoken eqlab : next, parse(":")
	// `eqlab' is the response variable
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {lnsigma}
			local paramdispl `paramdispl' (sigma:exp({lnsigma2}))
			local paramblock `paramblock' 2
		}
		else if `"`next'"' == "/athrho" {
			local paramprior `paramprior' normal
			local newparams `newparams' athrho
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {athrho}
			local paramdispl `paramdispl' (rho:tanh({athrho}))
			local paramblock `paramblock' 2
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_logit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_logistic, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_clogit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_cloglog, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_ologit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			local paramprior `paramprior' flat
			local newparams `newparams' `lab'
			local paramlogfm `paramlogfm' 0
			local paramblock `paramblock' 1
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramlogfm `paramlogfm' 0
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 1
		}
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_mlogit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_betareg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_binreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_streg_lognormal, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramdispl `paramdispl' {lnsigma}
		}
		else if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
		}
		else if `"`lab'"' == "lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma`par'
			local paramdispl `paramdispl' {lnsigma`par'}
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_streg_ggamma, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramdispl `paramdispl' {lnsigma}
		}
		else if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
		}
		else if `"`next'"' == "/kappa" {
			local paramprior `paramprior' normal
			local newparams `newparams' kappa
			local paramdispl `paramdispl' {kappa}
		}
		else if `"`lab'"' == "lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma`par'
			local paramdispl `paramdispl' {lnsigma`par'}
		}
		else if `"`lab'"' == "kappa" {
			local paramprior `paramprior' normal
			local newparams `newparams' kappa`par'
			local paramdispl `paramdispl' {kappa`par'}
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_streg_gompertz, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lngamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lngamma
			local paramdispl `paramdispl' {lngamma}
			local paramdispl `paramdispl' (gamma:exp({lngamma}))
		}
		else if `"`next'"' == "/gamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' gamma
			local paramdispl `paramdispl' {gamma}
		}
		else if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
			local paramdispl `paramdispl' (theta:exp({lntheta}))
		}
		else if `"`lab'"' == "gamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' gamma`par'
			local paramdispl `paramdispl' {gamma`par'}
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_streg_llogistic, sclass
	_bayes_streg_loglogistic `0'
end

program _bayes_streg_loglogistic, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lngamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lngamma
			local paramdispl `paramdispl' {lngamma}
		}
		else if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
		}
		else if `"`lab'"' == "lngamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lngamma`par'
			local paramdispl `paramdispl' {lngamma`par'}
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_streg_weibull, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/ln_p" {
			local paramprior `paramprior' normal
			local newparams `newparams' ln_p
			local paramdispl `paramdispl' {ln_p}
			local paramdispl `paramdispl' (p:exp({ln_p}))
		}
		else if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
			local paramdispl `paramdispl' (theta:exp({lntheta}))
		}
		else if `"`lab'"' == "ln_p" {
			local paramprior `paramprior' normal
			local newparams `newparams' ln_p`par'
			local paramdispl `paramdispl' {ln_p`par'}
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end


program _bayes_streg_exponential, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta
			local paramdispl `paramdispl' {lntheta}
			local paramdispl `paramdispl' (theta:exp({lntheta}))
		}
		else if `"`lab'"' == "lntheta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lntheta`par'
			local paramdispl `paramdispl' {lntheta`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_nbreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`lab'"' == "lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha`par'
			local paramdispl `paramdispl' {lnalpha`par'}
		}
		else if `"`next'"' == "/lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
			local paramdispl `paramdispl' (alpha:exp({lnalpha}))
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_gnbreg, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`lab'"' == "lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha`par'
			local paramdispl `paramdispl' {lnalpha`par'}
		}
		else if `"`next'"' == "/lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
			local paramdispl `paramdispl' (alpha:exp({lnalpha}))
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_zinb, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		if `"`next'"' == "/lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
			local paramdispl `paramdispl' (alpha:exp({lnalpha}))
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_zip, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		local paramprior `paramprior' normal
		local newparams `newparams' `next'
		local paramlogfm `paramlogfm' 0
		local paramdispl `paramdispl' {`next'}
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}
	
	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_hetregress, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken lab par : next, parse(":")
		if `"`next'"' == "/lnsigma2" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma2
			local paramdispl `paramdispl' {lnsigma2}
		}
		else if `"`lab'"' == "lnsigma2" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma2`par'
			local paramdispl `paramdispl' {lnsigma2`par'}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramlogfm `paramlogfm' 0
		local paramblock `paramblock' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_zioprobit, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock
	
	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			local paramprior `paramprior' flat
			local newparams `newparams' `lab'
			local paramlogfm `paramlogfm' 0
			local paramblock `paramblock' 1
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
			local paramblock `paramblock' 0
		}
		local paramlogfm `paramlogfm' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

////////////////////////////////////////////////////////////////////////////////
// me-commands

program _bayes_melogit, sclass
	_bayes_gsem `0'
end

program _bayes_meprobit, sclass
	_bayes_gsem `0'
end

program _bayes_mecloglog, sclass
	_bayes_gsem `0'
end

program _bayes_meologit, sclass
	_bayes_gsem `0'
end

program _bayes_meoprobit, sclass
	_bayes_gsem `0'
end

program _bayes_mepoisson, sclass
	_bayes_gsem `0'
end

program _bayes_normal, sclass
	_bayes_gsem `0'
end

program _bayes_menbreg, sclass
	_bayes_gsem `0'
end

program _bayes_meintreg, sclass
	_bayes_gsem `0'
end

program _bayes_metobit, sclass
	_bayes_gsem `0'
end

program _bayes_mestreg, sclass
	_bayes_gsem `0'
end

program _bayes_meglm, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			gettoken tok next : next, parse("/")
			gettoken par lab : next, parse("(") bind match(paren)
			if `"`par'"' == "var" {
				gettoken par : lab, parse("()") bind match(paren)
				local next `par':sigma2
				local par sigma2
			}
		}
		gettoken lab par : next, parse(":")
		if `"`lab'"' != "" & `"`par'"' != "" {
			gettoken tok par : par, parse(":")
		}
		if substr(`"`par'"',1,3) == "cut" {
			local paramprior `paramprior' flat
			local newparams `newparams' `par'
		}
		else if `"`par'"' == "sigma2" {
			local paramprior `paramprior' igamma
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		else if regexm("`par'", "Sigma_") {
			local paramprior `paramprior' iwishart
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next', m}
		}
		else if `"`par'"' == "lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
		}
		else if `"`par'"' == "lndelta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lndelta
			local paramdispl `paramdispl' {lndelta}
		}
		else if `"`par'"' == "ln_p" {
			local paramprior `paramprior' normal
			local newparams `newparams' ln_p
			local paramdispl `paramdispl' {ln_p}
		}
		else if `"`par'"' == "logs" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnscale
			local paramdispl `paramdispl' {lnscale}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramblock `paramblock' 0
		local paramlogfm `paramlogfm' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end

program _bayes_gsem, sclass

	args paramlist

	local newparams
	local paramprior
	local paramlogfm
	local paramnoshow
	local paramdispl
	local paramblock

	gettoken next paramlist : paramlist
	while `"`next'"' != "" {
		gettoken tok : next, parse("/")
		if `"`tok'"' == "/" { // must be /cut#
			gettoken tok next : next, parse("/")
			gettoken par lab : next, parse("(") bind match(paren)
			if `"`par'"' == "var" {
				gettoken par : lab, parse("()") bind match(paren)
				local next `par':sigma2
				local par sigma2
			}
		}
		gettoken lab par : next, parse(":")
		if `"`lab'"' != "" & `"`par'"' != "" {
			gettoken tok par : par, parse(":")
		}
		if substr(`"`par'"',1,3) == "cut" {
			local paramprior `paramprior' flat
			local newparams `newparams' `par'
		}
		else if `"`par'"' == "sigma2" {
			local paramprior `paramprior' igamma
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		else if regexm("`par'", "Sigma_") {
			local paramprior `paramprior' iwishart
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next', m}
		}
		else if `"`par'"' == "lnalpha" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnalpha
			local paramdispl `paramdispl' {lnalpha}
		}
		else if `"`par'"' == "lndelta" {
			local paramprior `paramprior' normal
			local newparams `newparams' lndelta
			local paramdispl `paramdispl' {lndelta}
		}
		else if `"`par'"' == "ln_p" {
			local paramprior `paramprior' normal
			local newparams `newparams' ln_p
			local paramdispl `paramdispl' {ln_p}
		}
		else if `"`par'"' == "lnsigma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnsigma
			local paramdispl `paramdispl' {lnsigma}
		}
		else if `"`par'"' == "lngamma" {
			local paramprior `paramprior' normal
			local newparams `newparams' lngamma
			local paramdispl `paramdispl' {lngamma}
		}
		else if `"`par'"' == "lnscale" {
			local paramprior `paramprior' normal
			local newparams `newparams' lnscale
			local paramdispl `paramdispl' {lnscale}
		}
		else if `"`par'"' == "logs" {
			local paramprior `paramprior' normal
			local newparams `newparams' logs
			local paramdispl `paramdispl' {logs}
		}
		else {
			local paramprior `paramprior' normal
			local newparams `newparams' `next'
			local paramdispl `paramdispl' {`next'}
		}
		local paramblock `paramblock' 0
		local paramlogfm `paramlogfm' 0
		gettoken next paramlist : paramlist
	}

	sreturn local paramlist   = `"`newparams'"'
	sreturn local paramprior  = `"`paramprior'"'
	sreturn local paramlogfm  = `"`paramlogfm'"'
	sreturn local paramnoshow = `"`paramnoshow'"'
	sreturn local paramdispl  = `"`paramdispl'"'
	sreturn local paramblock  = `"`paramblock'"'
end
