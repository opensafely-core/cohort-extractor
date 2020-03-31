*! version 1.1.5  16nov017

program _mcmc_expand_paramlist, sclass
	version 14.0

	args thetas paramlist

	if `"`thetas'"' != "" {
		local latvars $MCMC_latent
		// try to match exact parnames
		local sthetas
		local allfound 1
		foreach tok of local thetas {
			local tok = regexr(`"`tok'"', "{", "")
			local tok = regexr(`"`tok'"', "}", "")
			local ntoks : word count `tok'
			if `ntoks' != 1 {
				local allfound 0
				break
			}
			
			local found : list tok in latvars
			if "`found'" == "1" {
				local lattok `tok'
				foreach tok of local paramlist {
					tokenize `tok', parse(":")
					if "`1'" == "`lattok'" {
						local sthetas `sthetas' `tok'
					}
				}
				continue
			}

			local found : list tok in paramlist
			if "`found'" == "1" {
				local sthetas `sthetas' `tok'
			}
			else {
				local allfound 0
				break
			}
		}
		if `allfound' {
			local sthetas `sthetas'
			sreturn local thetas = `"`sthetas'"'
			exit
		}
	}
	else {
		sreturn local thetas = ""
		exit
	}

	tempname reobj
	local lreffects
	if `"`paramlist'"' != "" {
		mata: `reobj' = _c_mcmc_reffects()
		mata: `reobj'._mcmc_split_reffects("paramlist", "lfeffects", "lreffects")
		local paramlist `lfeffects'
	}

	_mcmc_parse expand `thetas'
	local thetas `s(eqline)'

	// form list of params stripped of labels 
	local plist `paramlist'
	local pnamelist 
	local lablist
	gettoken par plist: plist
	while `"`par'"' != "" {
		tokenize `par', parse(":")
		if `"`1'"' != "" & `"`2'"' == ":" & `"`3'"' != "" {
			local pnamelist `"`pnamelist' `3'"'
			local lablist `"`lablist' "`1'""'
		}
		else if `"`1'"' == ":" & `"`2'"' != "" {
			local pnamelist `"`pnamelist' `2'"'
			local lablist `"`lablist' """'
		}
		else {
			local pnamelist `"`pnamelist' `par'"'
			local lablist `"`lablist' """'
		}
		gettoken par plist: plist
	}

	// first pass 
	local sthetas
	gettoken tok thetas: thetas, match(paren) bind
	while `"`tok'"' != "" {
		if `"`paren'"' == "(" {
			// don't touch expressions
			local sthetas `"`sthetas' (`tok')"'
			gettoken tok thetas: thetas, match(paren) bind
			continue
		}

		tokenize `"`tok'"', parse("[]")
		if `"`2'"' == "[" & `"`4'"' == "]" {
			// skip RE parameters
			local sthetas `"`sthetas' `tok'"'
			gettoken tok thetas: thetas, match(paren) bind
			continue
		}
		
		_mcmc_fv_decode `"`tok'"'
		local tok `s(outstr)'

		gettoken brace tail: tok, parse("{")
		if `"`brace'"' != "{" {
		
			tokenize `"`tok'"', parse("*")
			if (`"`2'"' == "*" && `"`3'"' == "") {
				
			local head `1'
			local nstr : udstrlen local head

			local parlist `paramlist'
			gettoken par   parlist: parlist
			while `"`par'"' != "" {
				if udsubstr(`"`par'"', 1, `nstr') == `"`head'"' {
					local sthetas `"`sthetas' `par'"'
				}
					gettoken par parlist: parlist
			}
			
			}
			else {
				local sthetas `"`sthetas' `tok'"'
			}
			gettoken tok thetas: thetas, match(paren) bind
			continue
		}

		gettoken tok tail: tail, parse("}")
		if `"`tail'"' != "}" {
			// handle the "}sometail" case 
			gettoken par tail: tail, parse("}")
		}
		else {
			local tail ""
		}
		
		tokenize `"`tok'"', parse(",")
		if `"`2'"' == "," {
			_mcmc_paramnotallowed `"`1'"' `"`3'"'
		}

		// search for {:name} is equivalent to {name}
		tokenize `"`tok'"', parse(":")
		if `"`1'"' == ":" & `"`2'"' != "" {
			mac shift
		}

		local notfound 1

		local prefix
		if (`"`1'"' != "" & `"`2'"' == "") {
			if `"`2'"' != "" {
				di as err `"invalid parameter {bf:`tok'}"'
				exit 198
			}
			// search for :tok 
			local parlist `paramlist'
			local plist   `pnamelist'
			gettoken par   parlist: parlist
			gettoken parname plist: plist
			while `"`parname'"' != "" {
			// look for {eqname:`1'} with eqname != ""
			// that is `"`par'"' != `"`1'"'
				if `"`parname'"' == `"`1'"' & ///
				   `"`par'"' != `"`1'"' {
					local sthetas `"`sthetas' {`par'}"'
					local notfound 0
				}
				gettoken par   parlist: parlist
				gettoken parname plist: plist
			}
		}
		else if (`"`1'"' != "" & `"`2'"' == ":" & `"`3'"' == "") {
			// search for tok: 
			local parlist `paramlist'
			gettoken par parlist: parlist
			while `"`par'"' != "" {
				if (regexm(`"`par'"', `"^`1':"')) {
					local sthetas `"`sthetas' {`par'}"'
					local notfound 0
				}
				gettoken par parlist: parlist
			}
		}
		else if (`"`1'"' != "" & `"`2'"' == ":" & `"`3'"' != "") {
			local prefix `1'
			// search for all full names `tok' or `tok'_* 
			local parlist `paramlist'
			local plist   `pnamelist'
			local llist   `"`lablist'"'
			gettoken par   parlist: parlist
			gettoken parname plist: plist
			gettoken lab	 llist: llist
			while `"`parname'"' != "" {
				tokenize `"`parname'"', parse("_")
				if `"`1'"' == "" | `"`2'"' != "_" | ///
				  `"`3'"' == "" {
					gettoken par   parlist: parlist
					gettoken parname plist: plist
					gettoken lab	 llist: llist
					continue
				}
				local mpar `1'
				macro shift 2
				while `"`1'"' != "" & `"`2'"' == "_" & ///
				  `"`4'"' == "_" {
					local mpar `"`mpar'_`1'"'
					macro shift 2
				}
				if `"`lab'"' != "" {
					local mpar `"`lab':`mpar'"'
				}
				if `"`mpar'"' == `"`tok'"' {
					local notfound 0
					local sthetas `"`sthetas' {`par'}"'
				}
				gettoken par   parlist: parlist
				gettoken parname plist: plist
				gettoken lab	 llist: llist
			}
		}

		if `"`prefix'"' == "" {
			// search for all names `tok' or `tok'_#_# 
			local parlist `paramlist'
			local plist   `pnamelist'
			gettoken par   parlist: parlist
			gettoken parname plist: plist
			//local notfound 1
			while `"`parname'"' != "" {
				tokenize `"`par'"', parse("_")
				local mpar `par'
				local ismat 1
				if `"`1'"' != "" & `"`2'"' == "_" & ///
				  `"`3'"' != "" {
					local mpar `1'
					macro shift 2
					while `"`1'"' != "" & `"`2'"' == "_"  {
						capture confirm number `1'
						if c(rc) != 0 {
							local ismat 0
						}
						macro shift 2
					}
					capture confirm number `1'
					if c(rc) != 0 {
						local ismat 0
					}
				}
				if `"`mpar'"' == `"`tok'"' & `ismat' {
					local notfound 0
					local sthetas `"`sthetas' {`par'}"'
				}
				gettoken par   parlist: parlist
				gettoken parname plist: plist
			}
		}
		
		if `notfound' {
			// if not found pass it through 
			local sthetas `"`sthetas' {`tok'}"'
		}
		
		local sthetas `"`sthetas' `tail'"'
		gettoken tok thetas: thetas, match(paren) bind
	}

	// sthetas have no braces
	// second pass: expand fv's 
	if `"`sthetas'"' == "" {
		sreturn local thetas = ""
		exit
	}
	// `sthetas' may be :name, thus use `"`sthetas'"'
	_mcmc_parse expand `sthetas'
	local thetas `s(eqline)'

	local sthetas
	gettoken tok thetas: thetas, match(paren)
	while `"`tok'"' != "" {
		if `"`paren'"' == "(" {
			// don't touch expressions 
			local sthetas `"`sthetas' (`tok')"'
			gettoken tok thetas: thetas, match(paren)
			continue
		}
		if `"`tok'"' == "_ll" | `"`tok'"' == "_loglikelihood" {
			local sthetas `"`sthetas' (_ll:_loglikelihood)"'
			gettoken tok thetas: thetas, match(paren)
			continue
		}
		if `"`tok'"' == "_lp" | `"`tok'"' == "_logposterior" {
			local sthetas `"`sthetas' (_lp:_logposterior)"'
			gettoken tok thetas: thetas, match(paren)
			continue
		}
		local sthetas `"`sthetas' `tok'"'
		gettoken tok thetas: thetas, match(paren)
	}

	// expand reffects
	if `"`lreffects'"' != "" {
		mata: `reobj'._mcmc_expand_reffects_bypos("sthetas")
	}

	local sthetas `sthetas'
	sreturn local thetas = `"`sthetas'"'
end
