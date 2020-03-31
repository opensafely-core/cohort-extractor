*! version 1.2.7  24apr2019

program _mcmc_read_simdata, sclass
	local vv = _caller()

	syntax , MCMCOBJECT(string)				/// 
		[THETAS(string) USING(string) EVERY(integer 1)	///
		 NORESTore NOBASELEVELS CHAINs(string)		///
		 PREDictiondata matpvals(string)]

	if `"`thetas'"' == "" {
		di as err `"parameter not found"'
		exit 198
	}

	if (`"`e(cmd)'"' != "bayesmh" & `"`e(cmd)'"' != "bayespredict" & ///
		`"`e(prefix)'"' != "bayes")  {
		di as err `"last estimates not found"'
		exit 301
	}
	local bayescmd `e(cmd)'

	if `"`using'"' == "" {
		local using `"`e(filename)'"'
	}

	if `"`using'"' == "" {
		di as err `"last estimates not found"'
		exit 301
	}

	cap mata: `mcmcobject'
	if _rc {
		mata: `mcmcobject' = _c_mcmc_model()
	}

	local simfileerr "{p}specified file {bf:`using'} does not contain "
	local simfileerr `simfileerr' "proper simulation results as produced "
	local simfileerr `simfileerr' "by {bf:`bayescmd', saving()}{p_end}"

	local allthetas `"`thetas'"'
	local readnames
	local checknames

	local chain_var 0
	if `vv' >= 16.0 {
		local chain_var 1
	}
	else {
		if `"`chains'"' != "" {
			di as err `"option `"chains(`chains')"' not supported"'
			exit 198
		}
	}

	local lifcond
	if `"`chains'"' != "" {
		foreach i of local chains {
			if `"`lifcond'"' != "" {
				local lifcond `lifcond' | 
			}
			local lifcond `lifcond' _chain == `i'
		}
		local lifcond if `lifcond'
	}

	if `"`e(simfile_chainvar)'"' != "" {
		local chain_var = e(simfile_chainvar)
		mata: `mcmcobject'.m_simfile_chainvar = `chain_var'==1
	}

	if "`predictiondata'" == "" {

		mata: `mcmcobject'.m_varNames  = tokens(`"`e(indepvars)'"')
		mata: `mcmcobject'.m_varLabels = tokens(`"`e(indeplabels)'"')

		mata: `mcmcobject'.m_postVarNames = tokens(`"`e(postvars)'"')
		mata: st_local("checknames", ///
			invtokens(`mcmcobject'.form_simdata_colnames()))

		mata: `mcmcobject'.m_parNames = tokens(`"`e(parnames)'"')
		mata: st_local("varlabels", `"`e(parnames)'"')

		mata: `mcmcobject'.m_parEquMap = tokens(`"`e(pareqmap)'"')

		mata: `mcmcobject'.set_par_names(	///
			tokens(`"`e(scparams)'"'),	///
			tokens(`"`e(omitscparams)'"'),	///
			tokens(`"`e(matparams)'"'),	///
			tokens(`"`e(latparams)'"'),	///
			tokens(`"`e(predictnames)'"'),	///
			tokens(`"`e(predictyvars)'"'),	///
			tokens(`"`e(predsumnames)'"'))

		mata:  st_local("readnames",	///
			`mcmcobject'.postvar_colnames(`"`allthetas'"', ///
			`chain_var',  0))
	}
	else {
		local predynames
		local predyvars
		local predsumnames

		cap _bayespredict estrestore `"`using'"' `mcmcobject'
		if !_rc {
			local predynames `s(predynames)'
			local predyvars  `s(predyvars)'
			local predfnames `s(predfnames)'

			mata: `mcmcobject'.set_par_names(	///
				J(1,0,""),			///
				J(1,0,""),			///
				J(1,0,""),			///
				J(1,0,""),			///
				tokens(`"`predynames'"'),	///
				tokens(`"`predyvars'"'),	///
				tokens(`"`predfnames'"'))
		}

		_bayespredict parse_stats `mcmcobject' `"`thetas'"'

		local predobs `s(predobs)'
		local predfunc `s(predfunc)'
		local predfunc : list predfunc - predsumnames
		local residlist `s(residlist)'
		local mulist `s(mulist)'
		local proglist `s(proglist)'
		local ignoreobs `s(ignoreobs)'

		if `"`proglist'"' != "" & "`matpvals'"' != "" {
			di as err `"ppvalues not available for program {bf:`proglist'}"'
			exit 198
		}

		if `"`ignoreobs'"' != "" {
			di as txt `"note: prediction observations {bf:`ignoreobs'} "' /// 
			`"not available"'
		}

		// s(outlist) are vars/functions/expressions to be calculated
		local allthetas `s(outlist)'
		// s(predobs) are variables currently in the prediction dataset

		// add xb tokens needed for residuals
		foreach tok of local residlist {
			local mutok `tok'
			while regexm(`"`mutok'"',"_ysim") {
				local mutok = regexr(`"`mutok'"',"_ysim","_mu")
			}
			local predobs `predobs' `mutok'
		}
		foreach tok of local mulist {
			local mutok `tok'
			while regexm(`"`mutok'"',"_ysim") {
				local mutok = regexr(`"`mutok'"',"_ysim","_mu")
			}
			local predobs `predobs' `mutok'
		}
		foreach tok of local predfnames {
			// for each requested predstat include its _obs_var
			if `:list tok in predobs' {
				local predobs `predobs' _obs_`tok'
			}
		}

		// set the varnames to be read from the prediction dataset
		// these will be later used by -form_predictdata_colnames-
		mata: `mcmcobject'.import_par_names("predobs", ///
			"predobs", 0, 1)
		mata: `mcmcobject'.setPredictSave(`"`predobs'"', 1)

		// form read names before _bayespredict_parse_stats
		mata:  st_local("readnames",	///
			`mcmcobject'.postvar_colnames(`"`predobs'"', ///
			`chain_var',  1))
	}

	local readnames = subinstr(`"`readnames'"', "  ", " ", .)
	if `"`using'"' != "" {
		capture quietly describe using `"`using'"'
		if (_rc == 0) {
			local postdata `"`using'"'
			local using
		}
		else {
			gettoken postdata using : using
		}
	}
	while `"`postdata'"' != "" {

	if `"`postdata'"' != ""  & "`norestore'" == "" {
		preserve
	}

	if `"`readnames'"' != "" {
		capture use `readnames' `lifcond' using `"`postdata'"', clear
	}
	else {
		capture use `"`postdata'"', clear
		local readnames `checknames'
		if `"`lifcond'"' != "" {
			capture keep `lifcond'
		}
	}
	if _rc {
		di as err `"file {bf:`postdata'} not found"'
		exit _rc
	}

	if "`predictiondata'" == "" {
		capture confirm numeric var ///
			_index _loglikelihood _logposterior _frequency
	}
	else {
		capture confirm numeric var _index _frequency
	}
	if _rc {
		di as err `"`simfileerr'"'
		exit 301
	}	
	qui summarize _frequency, meanonly
	if `r(N)' == 0 {
		di as err `"`simfileerr'"'
		exit 301
	}
	if `every' != floor(`every') | `every' < 1 | `every' > `r(sum)' {
		di as err "option {bf:every()} must contain an integer " ///
			"between 1 and `r(sum)'"'
		exit 198
	}

	if `every' > 1 {
		mata: resize_mcmc_index(`every')
	}

	if (`"`e(cmd)'"' == "bayesmh" | `"`e(prefix)'"' == "bayes" | ///
		`"`e(cmd)'"' == "bayespredict")  {
		capture ds
		if _rc {
			di as err `"`simfileerr'"'
			exit 301
		}
		local readnames `"`r(varlist)'"'
	}
	else {
		quietly ds
		local varlist   `r(varlist)'
		local varnames  `varlist'
		local varlabels `varlist'

		mata: `mcmcobject'.m_postVarNames = tokens(`"`varlist'"')
		mata: `mcmcobject'.m_parNames	  = tokens(`"`varlist'"')
		mata: `mcmcobject'.m_parEquMap	  = tokens(`"`varlist'"')
		mata: `mcmcobject'.set_par_names(tokens(`"`varlist'"'), ///
		J(1,0,""), J(1,0,""), J(1,0,""), J(1,0,""), J(1,0,""), J(1,0,""))
	}

	if "`predictiondata'" != "" {
		if `"`residlist'"' != "" {
			fvexpand `residlist'
			local residlist `r(varlist)'

			foreach tok of local residlist {
				//mata: st_numscalar("`ymat'", ///
				//	`mcmcobject'.predictObserved("`tok'"))
				local residtok `tok'
				local mutok `tok'
				if regexm(`"`residtok'"', "_ysim") {
					local residtok = ///
					regexr(`"`residtok'"', "_ysim", "_resid")
					local mutok = ///
					regexr(`"`mutok'"', "_ysim", "_mu")
				}
				// generate resid only if it's in allthetas and 
				// it's going to be used
				// expensive operation: new set of resid vars
				// resid = y - xb
				qui gen double `residtok' =  `tok' - `mutok'
			}
		}
		if `"`predfunc'"' != "" {
			local predobsvars
			foreach tok of local predfunc {
				capture quietly generate double `tok' = .
				capture quietly generate double _obs_`tok' = .
				local predobsvars `predobsvars' _obs_`tok'
			}
			// only needed for ppvalues
			// loads _ysim, _mu, _resid (all may be needed)
			mata: `mcmcobject'.import_simdata( ///
			invtokens(`mcmcobject'.form_predictdata_colnames()))
			// fill-in predfunc
			mata: `mcmcobject'.predict_stat(`"`predfunc'"', `"`predobsvars'"')
		}
		// expand allthetas after generating residuals
		local thetalist `allthetas'
		local allthetas
		gettoken tok thetalist : thetalist, match(lmatch) bindcurly
		while `"`tok'"' != "" {
			if "`lmatch'" == "(" {
				local allthetas `allthetas' (`tok')
			}
			else {
				cap fvexpand `tok'
				if !_rc {
					local allthetas `allthetas' `r(varlist)'
				}
				else {
					local allthetas `allthetas' `tok'
				}
			}
			gettoken tok thetalist : thetalist, match(lmatch) bindcurly
		}
	} //if "`predictiondata'" != ""
	
	local numpars 0
	local parnames
	local varnames 
	local tempnames
	local rowsep
	local exprlegend
	local parrequest

	local thetas `"`allthetas'"'
	gettoken tok thetas: thetas, match(paren) bind
	while `"`tok'"' != "" {
		tempvar v
		local `++numpars'
		// Stata expression 
		if "`paren'" == "(" {
			gettoken vname tok: tok, parse(":{") bind 
			gettoken `v': tok, parse(":") bind 
			if `"`vname'"' != "" & `"`vname'"' != "{" & ///
			`"``v''"' == ":" {
				capture confirm names `vname'
				if _rc {
					di as err "{bf:`vname'} invalid name"
					exit 7
				}
				tokenize `vname'
				if `"`1'"' != `"`vname'"' {
					di as err "{bf:`vname'} invalid name"
					exit 7
				}
				// remove : 
				gettoken `v' tok: tok, parse(":") bind 
				
			}
			else {
				local tok `vname'`tok' 
				local vname expr`numpars'
			}
			local exprlegend `"`exprlegend' (`vname'):(`tok')"'

			_mcmc_parse expand `tok'
			mata:  st_local("tok",	///
				`mcmcobject'.postvar_translate(`"`s(eqline)'"'))
			capture quietly generate double `v' = `tok'
			if _rc != 0 {
				_mcmc_diparams dieq : `"`s(eqline)'"'	
				di as err `"invalid expression {bf:`dieq'}"'
				exit _rc		
			}
			local tempnames `tempnames' `v'
			local varnames  `varnames'  `v'
			// allow multi-word names 
			if `"`parnames'"' == "" {
				local parnames `""`vname'""'
			}
			else {
				local parnames `"`parnames' "`vname'""'
			}
			if "`predictiondata'" != "" {
				mata:`mcmcobject'.addStataExpr("`vname'", `"`tok'"')
			}
		}
		else {
			local n = bstrlen(`"`tok'"')
			if bsubstr(`"`tok'"',1,1) == "{" & `n' > 2 {
				if bsubstr(`"`tok'"',`n',.) == "}" {
					local n = `n' - 2
					local tok = bsubstr(`"`tok'"',2,`n')
				}
			}

			if "`nobaselevels'" != "" {
				mata: st_local("`v'",	///
					`mcmcobject'.postvar_lookup(`"`tok'"',1))
			}
			else {
				mata: st_local("`v'",	///
					`mcmcobject'.postvar_lookup(`"`tok'"',0))
			}

			if `"``v''"' == "" {
				_mcmc_paramnotfound `"`tok'"' "" "allowpredictions"
			}
			if `"``v''"' == "omitted" {
				local `v'
			}
			if `"``v''"' != "" {
				confirm variable ``v'', exact
				local varnames `varnames' ``v''
				if `"`parnames'"' == "" {
					local parnames `""`tok'""'
				}
				else {
					local parnames `"`parnames' "`tok'""'
				}
			}
			else {
				local parrequest `"`parrequest' `tok'"'
			}
		}
		local rowsep `rowsep' 0
		gettoken tok thetas: thetas, match(paren) bind
	}

	// -import_par_names- sets m_postVarNames and m_parNames 
	// to be used by -form_predictdata_colnames- later
	local parrequest `"`parrequest' `parnames'"'

	mata: `mcmcobject'.import_par_names("parnames", ///
		"varnames", "`nobaselevels'" != "", 0)

	if `"`varnames'"' == "" && "`predictiondata'" == "" {
		local parrequest `parrequest'
		if "`nobaselevels'" != "" {
			_mcmc_paramnotfound `"`parrequest'"' baselevel
		}
		else {
			_mcmc_paramnotfound `"`parrequest'"'
		}
	}

	if "`predictiondata'" != "" {
		mata: `mcmcobject'.import_simdata( ///
		invtokens(`mcmcobject'.form_predictdata_colnames()))		
		if `"`matpvals'"' != "" {
			mata: `mcmcobject'.calculate_pvalues("`matpvals'")
		}
	}
	else {
		mata: `mcmcobject'.import_simdata( ///
		invtokens(`mcmcobject'.form_simdata_colnames()))
	}

	if `"`postdata'"' != "" & "`norestore'" == "" {
		restore
	}

	gettoken postdata using : using
	} // while `"`postdata'"' != ""

	sreturn local numpars    = `"`numpars'"'
	sreturn local varnames   = `"`varnames'"'
	sreturn local parnames   = `"`parnames'"'
	sreturn local tempnames  = `"`tempnames'"'
	sreturn local exprlegend = `"`exprlegend'"'
end
