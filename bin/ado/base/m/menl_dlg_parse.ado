*! version 1.0.5  21jan2019

program define menl_dlg_parse, sclass
	syntax,  eq(string) [ hint(string) defines(string) covs(string) ///
		rescov(string) tsinit(string) tsorder(passthru) tsmissing ]

	sreturn clear

	tempname EXPR
	tempvar touse
	local defines : list retokenize defines
	capture mata: _menl_remove_instance(`EXPR',"`EXPR'")
	mata: _menl_create_instance("`EXPR'")
	qui gen byte `touse' = 1
	local rc = 0
	mata: _menl_set_touse(`EXPR',"`touse'")
	if `rc' {
		sreturn local errmsg `"`errmsg'"'
		exit
	}
	cap noi MENL_dlgParse `EXPR' `hint': `eq', `defines' `covs' `rescov' ///
			`tsinit' `tsorder' `tsmissing'
	/* clean up sreturn						*/
	sreturn local before
	sreturn local after
	sreturn local options
	if "`s(kcov)'" != "" {
		local kcov = `s(kcov)'
		forvalues i=1/`kcov' {
			sreturn local renames`i'
			sreturn local vartype`i'
		}
		sreturn local kcov
	}	
	mata: _menl_remove_instance(`EXPR',"`EXPR'")
end

program define ExtractNLExpr, sclass
	args expr

	sreturn clear
	local expr : list retokenize expr

	gettoken nlexpr rest : expr, parse(",") bindcurly bind
	local rest : list retokenize rest
	if "`rest'" != "" {
		gettoken comma args: rest, parse(",") bind
		local rest 
		while "`args'" != "" {
			gettoken tok args: args, parse(",") bind
			if "`tok'" == "" {
				local rest `"`rest' `args'"'
				break
			}
			local rest `"`rest' `tok'"'
			gettoken comma args: args, parse(",") bind
		}
		local rest : list retokenize rest
	}
	local nlexpr : list retokenize nlexpr

	sreturn local options `"`rest'"'
	sreturn local nlexpr `nlexpr'
end

program define MENL_dlgParse, sclass
	_on_colon_parse `0'

	local EXPR `s(before)'
	gettoken EXPR hint : EXPR
	local 0 `s(after)'

	local hint : list retokenize hint

	ExtractNLExpr `"`0'"'

	local nlexpr `"`s(nlexpr)'"'
	local eoptions `"`s(options)'"'
	local 0 `",`eoptions'"'

	local noi // noi debug
	local rc = 0
	
	sreturn clear
	cap `noi' syntax, [ tsorder(varname) tsmissing * ]
	if c(rc) {
		CheckForMatchingParenth `"`eoptions'"'
		local options `"`eoptions'"'	// find the problem below
	}
	local khier = 0
	mata: _menl_parse_equation(`EXPR',"`nlexpr'")
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	mata: st_local("touse",`EXPR'.touse())
	tempvar tspanels sorder tsvname
	if "`options'" == "" {
		MENL_TS_setup, obj(`EXPR') tspanels(`tspanels') ///
			sorder(`sorder') touse(`touse') tsvname(`tsvname') ///
			tsvar(`tsorder')

		sreturn clear
		if "`hint'"=="cov_create" | "`hint'"=="cov_edit" {
			mata: _menl_resolve_expressions(`EXPR')
			MENL_TS_query, obj(`EXPR')
		}
		else if "`hint'" == "initial" {
			mata: _menl_resolve_expressions(`EXPR')
			if `rc' {
				sreturn clear
				MENL_Error `"`errmsg'"' `"`message'"'
				MENL_TS_query, obj(`EXPR')
				mata: `EXPR'.expression_sreturn()
				exit
			}
			mata: _menl_resolve_covariances(`EXPR')
			if `rc' {
				sreturn clear
				MENL_Error `"`errmsg'"' `"`message'"'
				MENL_TS_query, obj(`EXPR')
				mata: `EXPR'.expression_sreturn()
				exit
			}
			/* khier posted by _menl_resolve_covariances()*/
			local khier = r(khier)
			mata: _menl_set_resid_covariance(`EXPR',"identity", ///
				"","","","identity","","","")
		}
		if `rc' {
			MENL_Error `"`errmsg'"' `"`message'"'
		}
		mata: `EXPR'.expression_sreturn()
		if "`s(kpath)'"!="" {
			sreturn local kpath = `s(kpath)'
		}
		else {
			sreturn local kpath = 0
		}
		MENL_TS_query, obj(`EXPR')
			
		exit
	}
	cap `noi' MENL_ParseExpressions `EXPR' : `options'
	local rc = c(rc)
	local options `"`s(options)'"'
	if !`rc' & `"`options'"'!="" {
		cap `noi' MENL_ParseTSInit `EXPR' : `options'
		local rc = c(rc)
	}
	MENL_TS_setup, obj(`EXPR') tspanels(`tspanels') sorder(`sorder') ///
		touse(`touse') tsvname(`tsvname') tsvar(`tsorder')

	mata: `EXPR'.expression_sreturn()

	MENL_TS_query, obj(`EXPR')
	if `rc' | "`hint'"=="param_create" | "`hint'"=="tsinit_create" {
		exit
	}
	local options `"`s(options)'"'
	mata: _menl_resolve_expressions(`EXPR')
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"' `EXPR'
		exit
	}
	local khier = r(khier)
	tempname b
	/* fixed effects 						*/
	mata: _menl_get_parameters(`EXPR',"`b'")
	if `=colsof(`b')' > 0 {
		local paramnames : colfullnames `b'
		sreturn local paramnames `"`paramnames'"'
	}
	if "`hint'"=="param_create" | "`hint'"=="param_edit" {
		MENL_TS_query, obj(`EXPR')
		exit
	}
	if "`options'" != "" {
		sreturn clear
		cap `noi' MENL_ParseCovariances `EXPR' : `options'

		mata: `EXPR'.expression_sreturn()

		MENL_TS_query, obj(`EXPR')
		if c(rc) {
			exit
		}
	}
	else {
		mata: `EXPR'.LV_sreturn()
	}
	MENL_TS_query, obj(`EXPR')
	if "`hint'"=="cov_create" | "`hint'"=="cov_edit" {
		exit
	}
	/* rescovariance() or resvariance() rescorrelation()		*/
	local options `s(options)'

	mata: _menl_resolve_covariances(`EXPR')

	/* fixed effects and covariance parameters			*/
	sreturn clear

	MENL_TS_query, obj(`EXPR')
	mata: `EXPR'.expression_sreturn()
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
	}
	if "`options'"=="" & "`hint'"!="initial" {
		sreturn local message
		local tsrecur `s(tsrecur)'
		if "`hint'"!="run" | "`tsrecur'"=="" | "`tsmissing'"!="" {
			exit
		}
		mata: st_local("depvar",invtokens(`EXPR'.depvars()))
		if "`depvar'" == "" {
			exit
		}
		local depvar : word 1 of `depvar'
		local tsrecur : list tsrecur & depvar

		if "`tsrecur'" != "`depvar'" {
			exit
		}
		local msg `"You included the lagged predicted mean "'
		local msg `"`msg'function for '`depvar'' in your nonlinear "'
		local msg `"`msg'expression and did not check 'Keep "'
		local msg `"`msg'observations with missing dependent "'
		local msg `"`msg'variable in computation' on the "'
		local msg `"`msg''Time series' tab. Continue?"'

		sreturn local message `"`msg'"'
		exit
	}
	if "`options'" != "" {
		cap `noi' MENL_ParseResCovariance `EXPR' : `options'
		local rc = c(rc)
		if `rc' {
			exit `rc'
		}
	}
	else if "`hint'" == "initial" {
		local rc = 0
		mata: _menl_set_resid_covariance(`EXPR',"identity","","","", ///
			"identity","","","")
	}
	/* fixed effects, RE covariance, and residual parameters	*/
	sreturn clear
	MENL_TS_query, obj(`EXPR')
	sreturn local khier = `khier'
	mata: `EXPR'.expression_sreturn()
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
	}
end

program define MENL_ParseExpressions, sclass
	_on_colon_parse `0'

	local EXPR `s(before)'
	local 0, `s(after)'

	cap noi syntax, [ define(string) * ]
	if `"`define'"' == "" {
		sreturn local options `"`options'"'
		exit
	}
	local rc = 0
	mata: _menl_parse_expression(`EXPR',`"`define'"')
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	cap noi MENL_ParseExpressions `EXPR' : `options'
	local rc = c(rc)
	if `rc' {
		exit `rc'
	}
end

program define MENL_ParseTSInit, sclass
	_on_colon_parse `0'

	local EXPR `s(before)'
	local 0, `s(after)'

	cap noi syntax, [ tsinit(string) * ]
	if `"`tsinit'"' == "" {
		sreturn local options `"`options'"'
		exit
	}
	local rc = 0
	mata: _menl_parse_tsinit(`EXPR',`"`tsinit'"')
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	MENL_ParseTSInit `EXPR' : `options'
	local rc = c(rc)
	if `rc' {
		exit `rc'
	}
end

program define MENL_ParseCovariances, sclass
	_on_colon_parse `0'

	local EXPR `s(before)'
	local 0 `s(after)'

	cap noi menl_parse_covariances 0 : `0'
	local rc = c(rc)
	if `rc' {
		sreturn local errmsg "invalid {bf:covariance()} specification"
		exit `rc'
	}
	local kcov = `s(kcov)'
	forvalues i=1/`kcov' {
		local renames`i' "`s(renames`i')'"
		local vartype`i' "`s(vartype`i')'"
		mata: _menl_add_re_covariance(`EXPR',"`renames`i''", ///
				"`vartype`i''","`fixpat`i''")
		if `rc' {
			MENL_Error `"`errmsg'"' `"`message'"'
			exit `rc'
		}
	}

end
	
program define MENL_ParseResCovariance, sclass
	_on_colon_parse `0'
	local EXPR `s(before)'
	local 0 ,`s(after)'
	syntax, [ rescovariance(string) resvariance(string) ///
		rescorrelation(string) ]
	if "`rescovariance'"=="" & "`resvariance'"=="" & ///
		"`rescorrelation'"=="" {
		return
	}
	menl_parse_rescovariance, rescorrelation(`rescorrelation') ///
		resvariance(`resvariance') rescovariance(`rescovariance')
	local rescor `s(rescor)'	// residual correlation structure
	local cbyvar `s(cbyvar)'	// corr by variable
	local ctvar `s(ctvar)'		// time variable
	local order `s(order)'		// AR, MA order

	local resvar `s(resvar)'	// residual variance structure
	local vbyvar `s(vbyvar)'	// var by variable
	local vivar `s(vivar)'		// unequal var index variable
	local vpvar `s(vpvar)'		// linear, power, expo variable
	local varopt `s(varopt)'	// residual variance options
	local varopt0 `varopt'

	local rescov `s(rescov)'	// residual covariance structure
	local rescoropt `s(rescoropt)'
	local resvaropt `s(resvaropt)'
	local rescovopt `s(rescovopt)'

	if "`rescor'"=="ar" | "`rescor'"=="ma" | "`rescor'"=="ctar1" {
		local coropt `order'
	}
	local rc = 0
	mata: _menl_set_resid_covariance(`EXPR',"`resvar'","`vbyvar'", ///
		"`vivar'","`varopt'","`rescor'","`cbyvar'","`ctvar'",  ///
		"`coropt'")
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
end

program define MENL_TS_setup, sclass
	syntax, obj(name) sorder(name) tspanels(name) tsvname(name) ///
			touse(varname) [ tsvar(varname) grvar(varname) ]

	local rc = 0
	cap tsset
	local tsset = (c(rc)==0)
	
	if "`tsvar'"!="" & `tsset' {
		local errmsg "Time-series order variable is not "
		local errmsg "`errmsg'allowed when the data is tsset."
		MENL_Error "`errmsg'"
		exit 184
	}
	if `tsset' {
		local timevar `r(timevar)'
		local panelvar `r(panelvar)'
		mata: `obj'.set_stata_tsvar("`timevar'")
		if "`panelvar'" != "" {
			mata: `obj'.set_stata_panelvar("`tspanelvar'")
		}
		exit
	}
	if "`tsvar'" == "" {
		exit
	}
	mata:_menl_resolve_hierarchy(`obj',"`tsvar'","`grvar'")
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	local khier = r(khier)

	mata: _menl_hierarchy_sort_order(`obj',`khier',"`sorder'")
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	/* estimation sort order, includes time variable	*/
	sort `sorder' 
	/* generate the panel index vector after data is sorted	*/
	mata: _menl_hierarchy_gen_panel_info(`obj',"`tspanels'")
	if `rc' {
		MENL_Error `"`errmsg'"' `"`message'"'
		exit `rc'
	}
	local path `r(path)'
	local kpath : list sizeof path
	summarize `tspanels' if `touse', meanonly
	if r(min)==r(max)  & "`path'"=="" {
		/* only one panel				*/
		qui drop `tspanels'
		local tspanels
	}
	if `kpath' == 1 {
		qui drop `tspanels'
		local tspanels `path'
	}
	/* tsset the data					*/
	cap menl_tsset `sorder' `tspanels', touse(`touse') ///
		tsvar(`tsvar') timevar(`tsvname') quietly
	local rc = c(rc)
	if `rc' {
		MENL_Error `"`s(errmsg)'"'
		exit `rc'
	}
	/* set -menl- tsset time and panel variable with 
	 * __sub_expr						*/
	mata: `obj'.set_stata_tsvar("`tsvname'")
	if "`tspanels'" != "" {
		mata: `obj'.set_stata_panelvar("`tspanels'")
	}
end

program define MENL_TS_query, sclass
	syntax, obj(string)

	tempname order
	mata: _menl_TS_query(`obj')
	sreturn local tsrecur `"`r(TS_recurexpr)'"'
	local hasts = 0
	mat `order' = r(TS_order)
	local tsvars `"`r(TS_varlist)'"'
	local tsexpr `"`r(TS_exprlist)'"'
	forvalues i=1/3 {
		local hasts = `hasts' | `order'[1,`i']>0
	}
	sreturn local hasts = `hasts'
	sreturn local tsvars `"`tsvars'"'
	sreturn local tsexpr `"`tsexpr'"'
end

program define CheckForMatchingParenth
	args opts

	/* try to isolate a syntax error				*/
	while `"`opts'"' != "" {
		gettoken tok opts: opts, bind match(par)
		local 0,`tok'
		cap syntax, [ * ]
		local rc = c(rc)
		if `rc' {
			MENL_Error `"matching parenthesis not found: `tok'"'
			exit `c(rc)
		}
	}
end

program define MENL_Error, sclass
	args errmsg message obj

	
	/* translate -menl- errors to dialog compatible message		*/
	MENL_translate_message `"`errmsg'"' `obj'

	if `"`s(errmsg)'"' == "" {
		/* strip out smcl {bf: stuff}, hope there is no named
		 *  expression named bf:				*/ 
		MENL_smcl2txt `"`errmsg'"'

		/* smcl2txt below cannot handle named expressions in
		 *  braces						*/
		// local errmsg = smcl2txt("`errmsg'")
		sreturn local errmsg `"`s(message)'"'
	}
	if "`message'" != "" {
		MENL_smcl2txt `"`message'"'
		sreturn local message `"`s(message)'"'
	}
end

program define MENL_smcl2txt, sclass
	args message0

	local lc = 0
	local adorn = 0
	local message `"`message0'"'
	/* look for {bf: <stuff>} and change to <stuff>			*/
	while `"`message'"' != "" {
		gettoken token message: message, parse(`" :;.,'"') ///
			bind bindcurly
		local k = ustrlen(`"`token'"')

		if `k' > 4 {
			local pre = usubstr(`"`token'"',1,4)
			local lst = usubstr(`"`token'"',`k',1)
			local k1 = cond("`lst'"=="}",1,0)
			if "`pre'" == "{bf:" {
				local k = `k'-4-`k1'
				local token = usubstr(`"`token'"',5,`k')
				if `k1' {
					local adorn = 1
				}
			}
			else if "`pre'" == "{it:" {
				local k = `k'-4-`k1'
				local token = usubstr(`"`token'"',5,`k')
				if `k1' {
					local adorn = 2
				}
			}
			if `k' > 7 {
				local pre = usubstr(`"`token'"',1,6)
				if "`pre'" == "{helpb" {
					local k = `k'-7-`k1'
					local token = usubstr(`"`token'"',8,`k')
					if `k1' {
						local adorn = 1
					}
				}
			}
		}
		local c = substr(`"`token'"',1,1)
		if "`c'" == ":" {
			local msg `"`msg'`token'"'
		}
		else if "`c'" == ";" {
			local msg `"`msg'`token'"'
		}
		else if "`c'" == "," {
			local msg `"`msg'`token'"'
		}
		else if "`c'" == "." {
			local msg `"`msg'`token'"'
		}
		else if `"`c'"' == `"'"' {
			if `lc' {
				local msg `"`msg'`token'"'
				local lc = 0
			}
			else { //  `lc' == 0 
				local msg `"`msg'`sp'`token'"'
				local `++lc'
			}
		}
		else if `adorn' == 1 {	// {bf:<stuff>}
			local msg `"`msg'`sp''`token''"'
		}
		else if `adorn' == 2 {	// {it:<stuff>}
			local msg `"`msg'`sp'<`token'>"'
		}
		else {
			local msg `"`msg'`sp'`token'"'
		}
		local adorn = 0
		local sp " "
	}
	sreturn local message `"`msg'"'
end

program define MENL_translate_message, sclass
	args errmsg obj

	sreturn local errmsg

	local msgfrom1 `"option {bf:tsinit()} required with lagged named "'
	local msgfrom1 `"`msgfrom1'expressions"'
	local msgto1 `"You included the lagged predicted mean function in "'
	local msgto1 `"`msgto1'your nonlinear expression. You must specify an "'
	local msgto1 `"`msgto1'initial condition for it on the 'Time series' "'
	local msgto1 `"`msgto1'tab."'
	local k = 1

	if "`obj'" != "" {
	mata: st_local("depvar",`obj'.depvars()[1])

	local msgfrom2 `"equation {bf:`depvar'} has time-series operators, "'
	local msgfrom2 `"`msgfrom2'but the data is not {helpb tsset}"'
	local msgto2 `"Time-series operators are used but panel and time "'
	local msgto2 `"`msgto2'variables are not set.  You can specify a "'
	local msgto2 `"`msgto2'time variable on the 'Time series' tab; "'
	local msgto2 `"`msgto2'panel variable will be created automatically "'
	local msgto2 `"`msgto2'by menl. Or, you can use tsset to specify "'
	local msgto2 `"`msgto2'panel and time variables manually."'
	local `++k'
	}	// endif "`obj'"!=""

	forvalues i=1/`k' {
		if `"`errmsg'"' == `"`msgfrom`i''"' {
			sreturn local errmsg `"`msgto`i''"'
		}
	}
end

exit
