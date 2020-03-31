*! version 1.0.9  05oct2018
program _bayes_block_opt, sclass
	version 14.0

	args gtouse blocks allreffects forcereopt

	local simoptions
	local blocksline
	local blockparlist

	while `"`blocks'"' != "" {

		gettoken eqline blocks: blocks, parse("\ ()") match(paren)
		// parse data/params until the first option
		if `"`eqline'"' == "block" {
	 		local sampler
		 	gettoken eqline blocks : blocks, match(paren)
			// equations begin with (
		 	if "`paren'" != "(" {
				di as err "( is expected after block"
				exit _rc
		 	}

			_mcmc_scan_identmats `eqline'
			local eqline `s(eqline)'

			gettoken blpars blopts : eqline, parse(",") bindcurly
			local 0 `blopts'
			syntax [anything] [, REffects GIBBs *]
			local blopts `reffects' `gibbs' `options'
			
		 	_mcmc_fv_decode `"`blpars'"' `gtouse'
		 	local eqline `s(outstr)'
			
			local lablist $MCMC_eqlablist
			local ylabind 1
		 	gettoken ylabel lablist : lablist
		 	while `"`ylabel'"' != "" {
				local ltemp MCMC_betapar_`ylabind'
				while regexm(`"`eqline'"', `"{`ylabel':}"') {
		 	 	 	 local eqline = regexr(`"`eqline'"', ///
					`"{`ylabel':}"', `"$`ltemp'"')
				}
				gettoken ylabel lablist : lablist
				local `++ylabind'
		 	}

			local exblpars `eqline'
			while regexm(`"`exblpars'"', "{") {
				local exblpars = ///
					regexr(`"`exblpars'"', "{", "")
			}
			while regexm(`"`exblpars'"', "}") {
				local exblpars = ///
					regexr(`"`exblpars'"', "}", "")
			}
			// `allreffects' params not allowed in blocks
			local recommon : list exblpars & allreffects

			while regexm(`"`blpars'"', "{") {
				local blpars = ///
					regexr(`"`blpars'"', "{", "")
			}
			while regexm(`"`blpars'"', "}") {
				local blpars = ///
					regexr(`"`blpars'"', "}", "")
			}
			// strip white space
			local blpars `blpars'

			// refer {U} to {U[id]}
			local lname "MCMC_latent_`blpars'"
			tokenize `"`lname'"', parse("[].")
			if "`2'" == "" {
				local lname `1'
				capture confirm name `lname'
				if _rc == 0 & "$`lname'" != "" {
					local blpars "$`lname'"
				}
			}
			local islat 0
			// check if blpars equals one of the U[id]'s
			local latlist $MCMC_latent
			gettoken ylabel latlist : latlist
			while `"`ylabel'"' != "" {
				if `"`blpars'"' == `"`ylabel'"' | ///
				`"`blpars'"' == `"`ylabel':"' {
					local islat 1
				}
				gettoken ylabel latlist : latlist
			}

			if `"`reffects'"' == "" & `"`recommon'"' != "" {
				di as err "option {bf:block()} " ///
				`"not supported for random-effects parameters"'
				exit 198
			}

			if `"`reffects'"' != "" & !`islat' {

			if `"`forcereopt'"' != "" {
				// prevent not-RE parameters to be assigned a 
				// reffects-block
				if `"`recommon'"' == "" & `"`allreffects'"' != "" {
					di as err "option {bf:block()}'s " ///
					`"suboption {bf:reffects} not allowed"'
					exit 198
				}
			}

				tokenize `blpars', parse(":\ ")

				if `"`1'"' == "" | `"`2'"' != ":" | `"`3'"' == "" {
					di as err `"{bf:blocks()}'s "' ///
					"{bf:reffects()} option not supported"
					exit 198
				}

				local tok `3'
				local oneidot 0
				while `"`tok'"' != "" {
					gettoken 3 tok : tok, parse("#")
					if `"`3'"' == "#" {
						continue
					}
					tokenize `3', parse(".\ ")
					if `"`2'"' != "." {
		di as err "only one "					   ///
		`"{bf:{c -(}}{it:depvar}{bf::i.}{it:varname}{bf:{c )-}} "' ///
		"specification is allowed within "                         ///
		"random-effects {bf:block()} option" 
						exit 198
					}
					if `"`1'"' != "i" & `"`1'"' != "ibn" {
						continue
					}

					if `"`3'"' != "" & `"`4'"' == "" {
						capture confirm variable `3'
						if _rc {
				di as err `"{bf:`3'} must be a variable "' ///
				"in order to be used within "		   ///
				"random-effects {bf:block()} option" 
				exit 198
						}
					}

				} // while `"`tok'"' != ""

			} // if `"`reffects'"' != "" & !`islat'

			local blockparlist = `"`blockparlist' `eqline'"'

			if `"`blopts'"' != "" {	
				local eqline = `"`eqline', `blopts'"'
			}

		 	if `"`blocksline'"' == "" {
				local blocksline `"`eqline'"'
		 	}
		 	else {
				local blocksline `"`blocksline';`eqline'"'
		 	}
		}
		else {
	 		gettoken next blocks : blocks, match(paren)
			// move to options 
	 		if "`paren'" == "(" {
				local simoptions `"`simoptions'`eqline'(`next') "'
	 		}
	 		else {
				local simoptions `"`simoptions'`eqline' "'
				if `"`next'"' != "" {
	 		 	 	 local blocks `"`next' `blocks'"'
				}
	 		}
	 		continue
		}
	}
	
	sreturn local simoptions = `"`simoptions'"'
	sreturn local blocksline = `"`blocksline'"'
	sreturn local blockparlist = `"`blockparlist'"'
end
