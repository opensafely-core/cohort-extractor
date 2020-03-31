*! version 1.1.6  20mar2019

findfile _bayesmh_parse_sub_expr.mata
quietly include `"`r(fn)'"'

program _bayes_reffects, sclass

	args mcmcobject moptobject model covariances ///
		touse ylabel yvar respec offset tempvar restubs exclude ///
		parseonly nchains reasis renoprior

	if "`respec'" == "" {
		sreturn clear
		sreturn local eqexpr     = ""
		sreturn local eqnolatent = ""
		sreturn local eqlatent   = ""
		sreturn local eqlatname  = ""
		sreturn local varlist    = ""
		sreturn local exparlist  = ""
		sreturn local remodel    = ""
		exit 0
	}

	if `nchains' > 1 {
		forvalues i = 2/`nchains' { 
			local optinitial`i'
		}
	}

	local eqline `respec'
	local respec
	local respeceq
	local exparlist
	local remodel = "\n{txt}Multilevel structure\n{txt}{hline 78}"
	local optinitial
	
	// reorder terms in `eqline' so that intercepts are before coefficients
	tokenize `eqline'
	// index of intercepts
	local interind 
	local n 1
	while `"``n''"' != "" {
		if regexm(`"``n''"', "^__I") {
			local interind `interind' `n'
		}
		local n = `n' + 1
	}
	if `"`interind'"' == "" {
		local n = `n' - 1
		local interind `n'
	}
	local eqline 
	local n 1
	foreach k of local interind {
		local eqline `eqline' ``k''
		while `n' < `k' {
			local eqline `eqline' ``n''
			local n = `n' + 1
		}
		local n = `n' + 1
	}

	local oldlevel 1
	local maxlevels 12
	local levlist U V W X Y Z A B C D E F

	local latind 0
	local first 1
	local pathlist
	local varref

	local lstublist : list uniq restubs
	if `"`lstublist'"' != `"`restubs'"' {
		di as err `"repeated stubs not allowed in {bf:restubs(`restubs')}"'
		exit 198
	}

	local lnamelist `levlist'
	local lname
	local lstub
	local restubs
	local relevels
	foreach tok of local eqline {
		tokenize `"`tok'"', parse("#[]") 
		local eqvar
		local prefix
		local locvar
		if `"`1'"' == "__I" & `"`2'"' == "[" {
			// random intercept
			local latind 0
		}
		else {
			local latind = `latind' + 1
		}
		while `"`2'"' == "#" & `"`4'"' != "[" & `"`4'"' != "" {
			local eqvar `eqvar'`1'`2'
			local prefix `prefix'`1'`2'
			macro shift 2
		}
		while `"`2'"' == "#" & `"`4'"' == "[" {
			local eqvar `eqvar'`1'
			local prefix `prefix'`1'`2'
			macro shift 2
		}

		capture _ms_parse_parts `eqvar'
		if _rc == 0 {
			local eqvar = regexr(`"`eqvar'"', "c.", "")
			local locvar `eqvar'
		}
		if `"`locvar'"' == "" {
			local locvar _cons
		}

		if `"`2'"' == "[" & `"`4'"' == "]" {
			local retok `1'
			local path `3'
			tokenize `"`path'"', parse(">")
			if `"`1'"' == "_all" & `"`2'"' == ">" {
				// crossed-effect specification
				local path `3'
			}

			tokenize `"`path'"', parse("<>")
			local levels 1
			while `"`2'"' != "" {
				local `levels++'
				macro shift 2
			}

			if !`:list path in pathlist' {
				local pathlist `pathlist' `path'
				if "`lnamelist'" == "" {
					di as err `"the number of REs exceeds `maxlevels'"'
					exit 198
				}
				gettoken lstub lstublist : lstublist
				// obtain an lname as well, regardless 
				// if there is a stub or not
				if `oldlevel' < `levels' {
					local oldlevel `levels'
				}
				else {
					gettoken lname lnamelist : lnamelist
				}
				if `first' == 0 {
					local remodel = `"`remodel'\n"'
				}
				local remodel = `"`remodel'\n{res}`path'{txt}"'
			}

			tokenize `"`path'"', parse("<>")
			local level 1
			while `"``level''"' != "" {
				local level = `level' + 1
			}
			local level = `"``=`level'-1''"'

			if `"`lstub'"' != "" {
				confirm name `lstub'
				local tok = bsubstr(`"`lstub'"',1,1)
				if upper(`"`tok'"') != `"`tok'"' {
					di as err `"stub name {bf:`lstub'} must be capitalized"'
					exit 198
				}
				local leqname `lstub'
			}
			else {
				if "`lname'" == "" {
					gettoken lname lnamelist : lnamelist
				}
				local leqname `lname'
				while `"`2'"' != "" {
					local leqname `leqname'`lname'
					macro shift 2
				}
			}
			if !`:list leqname in restubs' {
				local restubs `restubs' `leqname'
				local relevels `relevels' `level'
			}

			if `"`reasis'"' != "" {
				// keep original names
				local leqname `retok'
				local latind
			}
			
			local respec `respec' `prefix'`leqname'`latind'[`path']
			local varref `varref' `locvar'
			
			if `"`respeceq'"' != "" local respeceq `respeceq'+
			
			local tprefix = regexr(`"`prefix'"', "#", "*")
			local respeceq `respeceq'`tprefix'{`leqname'`latind'[`path']}
			
//`path'
//    {`leqname'}: "random intercept", if `latind' == 0
//    {`leqname'}: "random coefficient for `eqvar'", if `latind' > 0
			local remodel = `"`remodel'\n{space 4}"'
			if `"`eqvar'"' == "" {
				local remodel = ///
	`"`remodel'{res}{`leqname'`latind'}{txt}: random intercepts"'
			}
			else {
				local remodel = ///
	`"`remodel'{res}{`leqname'`latind'}{txt}: random coefficients for "'
				local remodel = `"`remodel'{res}`eqvar'"'
			}
			local remodel = `"`remodel'"'
		}
		local first 0
	}
	local remodel = `"`remodel'\n{txt}{hline 78}"'

	tempname res
	scalar `res' = 0
	mata: _bayesmh_parse_sub_expr(1, 0, "`ylabel' `respec'",	///
		"`touse'", "noconstant", "eqexpr", "eqnolatent",	///
		"eqlatent", "eqlatname", "pathlist", "varlist", 	///
		"feparams", "", "matparams", "nreparams", "`res'")
	if `res' {
		exit `res'
	}

	local eqlatname `eqlatname'
	local lv_names `eqlatname'
	local lv_paths `pathlist'

	local latnames `eqlatname'
	foreach tok of local exclude {
		local tok = regexr(`"`tok'"', "{", "")
		local tok = regexr(`"`tok'"', "}", "")
		gettoken tok : tok, parse("[]")
		local latnames : list latnames - tok
	}
	local nreparams 0
	foreach tok of local latnames {
		if `"`nreparams_`tok''"' != "" {
			local nreparams = `nreparams' + `nreparams_`tok''
		}
	}

	// match LVs to depvar equations
	local varlist `eqnolatent'
	foreach tok of local eqlatent {
		tokenize `tok', parse("[]")
		local lname MCMC_latent_`1'
		global `lname' `tok'
		local lname MCMC_latlabel_`1'
		global `lname' `ylabel'
	}

	if `"`offset'"' != "" {
		if "`model'" == "mixed" {
			local eqline `tempvar', define((`offset'-(`respeceq')))
		}
		else {
			local eqline `tempvar', define(`offset' `eqlatent')
		}
	}
	else {
		local eqline `tempvar', define(`eqlatent')
	}
	_mcmc_parse equation `eqline', nocons

	local xinit `s(xinit)'
	local xomit `s(xomit)'

	if `"`offset'"' != "" {
		if "`model'" == "mixed" {
			local eqspec (`ylabel':`offset'-(`respeceq'))
		}
		else {
			local eqspec `ylabel' `offset' `respec', noconstant
			gettoken tok xinit : xinit
			local xinit 1 `xinit'
			gettoken tok xomit : xomit
			local xomit 1 `xomit'
		}
	}
	else {
		local eqspec `yvar' `respec', noconstant
	}

	mata: `mcmcobject'.add_factor()	
	mata: `mcmcobject'.set_factor(			///
		NULL,	 	 	 	 	///
		"`s(dist)'",	 			///
		`""`eqspec'""', "xb",			///
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
		"`xinit'",	 	 	 	///
		"`xomit'",	 	 	 	///
		"`s(nocons)'",	 	 		///
		"", "", "", "", "", "")
	mata: `mcmcobject'.drop_pdist()

	mata: `mcmcobject'.set_touse( ///
		NULL, st_data(., "`touse'"), "", J(1,0,0), "", "")

	local varreflist `varref'
	local varref
	foreach tok of local lv_names {
		local varref `"`varref' """'
	}

	local pathcovlist 
	foreach path of local pathlist {
		local pathcov
		foreach cov of local covariances {
			gettoken label cov : cov, parse(":")
			gettoken tok cov : cov, parse(":")
			if `"`path'"' == `"`label'"' {
				local pathcov `cov'
				break
			}
			else if regexm(`"`path'"', `"`label'$"') {
				local pathcov `cov'
				break
			}
		}
		local pathcovlist `"`pathcovlist' "`pathcov'""'
	}	

	// priors and blocks
	local latlist `eqlatent'
	local latnamelist `eqlatname'
	while "`latlist'" != "" {
		gettoken path pathlist : pathlist
		gettoken tok latlist : latlist
		gettoken latname latnamelist : latnamelist
		gettoken vartok varreflist : varreflist
		gettoken covariance pathcovlist : pathcovlist

		local varref `"`varref' "`vartok'"'

		local reparlist {`tok'}
		local d 1
		if "`covariance'" == "unstructured" {
			gettoken nextpath : pathlist
			while "`nextpath'" == "`path'" {
				gettoken nextpath pathlist : pathlist
				gettoken tok latlist : latlist
				gettoken latname latnamelist : latnamelist
				gettoken vartok varreflist : varreflist
				local reparlist `reparlist' {`tok'}
				local varref `"`varref' `vartok'"'
				local d = `d' + 1
				gettoken nextpath : pathlist
			}
		}
		local varref `"`varref'""'
		
		local comname `latname'
		local comname = regexr("`comname'", "[0-9]+", "")

		local lv_paths `lv_paths' `path'
		if `d' == 1 {

		if "`covariance'" == "identity" {
			local parname `comname':sigma2
			local exparlist `exparlist' `parname'
			local eqline `reparlist', normal(0, {`parname'=1})
			local lv_names `lv_names' `comname'
			// Gibbs is optional for this parameter
			mata: `mcmcobject'.add_opt_gibbs_list("`parname'")
		}
		else {
			local parname `latname':sigma2
			local exparlist `exparlist' `parname'
			local eqline `reparlist', normal(0, {`parname'=1})
			local lv_names `lv_names' `latname'
		}

		if `nchains' > 1 {
			forvalues i = 2/`nchains' { 
				local optinitial`i' = ///
					`"{`parname'} rgamma(1, 1) `optinitial`i''"'
			}
		}
		
		}
		else {
			local exparlist `exparlist' `comname':Sigma_`d'
			local eqline `reparlist', mvnormal0(`d', {`comname':Sigma, m})
			local lv_names `lv_names' `comname'
		}

		if `nchains' > 1 {
			forvalues i = 2/`nchains' { 
				local optinitial`i' = ///
					`"`reparlist' rnormal() `optinitial`i''"'
			}
		}
		
		if `"`renoprior'"' != "" {
			continue
		}

		_mcmc_parse equation `eqline', nocons

		mata: `mcmcobject'.add_factor()	
		mata: `mcmcobject'.set_factor(			///
	 		NULL,	 	 	 	 	///
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
		mata: `mcmcobject'.drop_pdist()
		
		if !`parseonly' {
			if `d' == 1 {
				mata: `mcmcobject'.add_prior_name("normal", ///
					`"`s(y)'"', `"`s(yprefix)'"')
			}
			else {
				mata: `mcmcobject'.add_prior_name("mvnormal0", ///
					`"`s(y)'"', `"`s(yprefix)'"')
			}
		}
	}

	mata: `mcmcobject'.set_LV_names("`lv_names'", "`lv_paths'", "`ylabel'", `"`varref'"')

	local exparlist : list uniq exparlist 

	sreturn clear
	sreturn local eqexpr      = `"`eqexpr'"'
	sreturn local eqnolatent  = `"`eqnolatent'"'
	sreturn local eqlatent    = `"`eqlatent'"'
	sreturn local eqlatname   = `"`eqlatname'"'
	sreturn local varlist     = `"`varlist'"'
	sreturn local exparlist   = `"`exparlist'"'
	sreturn local remodel     = `"`remodel'"'
	sreturn local restublist  = `"`restubs'"'
	sreturn local relevellist = `"`relevels'"'
	sreturn local nreparams   = `"`nreparams'"'
	if `nchains' > 1 {
		forvalues i = 2/`nchains' { 
			sreturn local optinitial`i' = `"`optinitial`i''"'
		}
	}
end
