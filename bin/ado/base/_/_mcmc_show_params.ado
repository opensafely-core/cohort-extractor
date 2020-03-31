*! version 1.0.6  31mar2017

program _mcmc_show_params, eclass
	version 15.0

	capture syntax [, mcmcobject(string) NOSHOW(string) SHOW(string) ///
		SHOWREffects SHOWREffects1(string) * ]

	if "`noshow'" != "" & "`show'" != "" {
		di as err "options {bf:noshow(`noshow')} and {bf:show(`show')} " ///
			"cannot be combined"
		exit 198
	}

	if "`options'" != "" {
		di as err "option(s) {bf:`options'} not supported"
		exit 198
	}

	if "`mcmcobject'" == "" {
		exit 0
	}

	// latparams are not shown by default
	mata: st_local("latparams", `mcmcobject'.latparams())

	if `"`noshow'`show'`latparams'"' == "" {
		exit 0
	}

	// process showreffects() before show() and noshow()
	local noshowparams `latparams'
	if "`showreffects'" != "" {
		local noshowparams
		local showreffects1
	}
	else if "`showreffects1'" != "" {
		_mcmc_expand_paramlist `"`showreffects1'"' `"`latparams'"'
		local showreffects `s(thetas)'
		local showreffects1 : list showreffects - noshowparams
		local noshowparams : list noshowparams - showreffects
	}
	if "`noshowparams'" != "" {
		mata: `mcmcobject'.show_params("`noshowparams'", 0)
	}
	if "`showreffects1'" != "" {
		mata: st_local("params", `mcmcobject'.parnames())
		_mcmc_expand_paramlist `"`showreffects1'"' `"`params'"'
		mata: `mcmcobject'.show_params("`s(thetas)'", 1)
	}

	if "`noshow'" != "" {
		_mcmc_fv_decode	`"`noshow'"'
		_mcmc_parse expand `s(outstr)'
		local noshow `s(eqline)'
	}
	
	if "`show'" != "" {
		_mcmc_fv_decode	`"`show'"'
		_mcmc_parse expand `s(outstr)'
		local show `s(eqline)'
	}

	// expand shortcuts in `show' and `noshow'
	local lablist $MCMC_eqlablist
	gettoken ylabel lablist : lablist
	local ylabind 1
	while `"`ylabel'"' != "" {
		local ltemp MCMC_betapar_`ylabind'
		while regexm(`"`noshow'"', `"{`ylabel':}"') {
			local noshow = regexr(`"`noshow'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`show'"', `"{`ylabel':}"') {
			local show = regexr(`"`show'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		gettoken ylabel lablist : lablist
		local `++ylabind'
	}

	local params

	if "`noshow'" != "" {
		mata: `mcmcobject'.show_all()
		// verify all noshow parameters
		local toklist `noshow'
		gettoken next toklist : toklist, bindcurly
		while "`next'" != "" {
			tokenize `"`next'"', parse("{:}")
			if `"`1'"' == "{" && `"`3'"' == ":" && `"`4'"' == "}" {
				mata: `mcmcobject'.show_params("`2':", 0)
			}
			else {
				capture _mcmc_parse word `next'
				if _rc == 0 {
				
				if "`s(prefix)'" != "." {
					mata: `mcmcobject'.show_params(	///
						"`s(prefix)':`s(word)'", 0)
				}
				else {
					mata: `mcmcobject'.show_params( ///
						"`s(word)'", 0)
				}
				}
				else {

			if `"`params'"' == "" {
				mata: st_local("params", `mcmcobject'.parnames())
			}
			_mcmc_expand_paramlist `"`next'"' `"`params'"'
			if "`s(thetas)'" != "" {
				// request RE params, so set showreffects in other 
				// to show them
				local showreffects showreffects
				mata: `mcmcobject'.show_params("`s(thetas)'", 0)
			}
				}
			}
			gettoken next toklist : toklist, bindcurly
		}
	}

	if "`show'" != "" {
		mata: `mcmcobject'.noshow_all()
		// verify all show parameters
		local toklist `show'
		gettoken next toklist : toklist, bindcurly
		while "`next'" != "" {
			tokenize `"`next'"', parse("{:}")
			if `"`1'"' == "{" && `"`3'"' == ":" && `"`4'"' == "}" {
				mata: `mcmcobject'.show_params("`2':", 1)
			}
			else {
				capture _mcmc_parse word `next'
				if _rc == 0 {
				
				if "`s(prefix)'" != "." {
					mata: `mcmcobject'.show_params(	///
						"`s(prefix)':`s(word)'", 1)
				}
				else {
					mata: `mcmcobject'.show_params( ///
						"`s(word)'", 1)
				}
				}
				else {

			if `"`params'"' == "" {
				mata: st_local("params", `mcmcobject'.parnames())
			}
			_mcmc_expand_paramlist `"`next'"' `"`params'"'
			if "`s(thetas)'" != "" {
				// request RE params, so set showreffects in other 
				// to show them
				local showreffects showreffects
				mata: `mcmcobject'.show_params("`s(thetas)'", 1)
			}
				}
				
			}
			gettoken next toklist : toklist, bindcurly
		}
	}
end
	
exit
