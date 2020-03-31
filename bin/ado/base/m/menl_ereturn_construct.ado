*! version 1.1.4  24feb2020

program define menl_ereturn_construct, sclass
	syntax, obj(name) touse(varname) tivar(name) [ touse2(name)  ///
		b(name) skip tsvname(name) panels(name) NODEPMARKOUT ///
		quietly ]

	/* reconstruct Mata __menl_expr object from ereturn		*/
	local rc = 0
	local depvar `e(depvar)'
	loca eq `"`e(eq_`depvar')'"'

	local varlist `"`e(varlist)'"'
	local mark_depvar = ("`e(tsmissing)'"=="" & "`nodepmarkout'"=="")
	if !`mark_depvar' {
		/* second estimation sample that includes the 
		 *  depvar; e.g. multiple dose PH models		*/
		local varlist : list varlist - depvar
	}
	local idvars `e(hvarlist)'
	local grvar "`e(groupvar)'"
	local varlist : list varlist - idvars

	markout `touse' `idvars' `grvar'

	local rescovopt `e(rescovopt)'
	local resvaropt `e(resvaropt)'
	local rescoropt `e(rescorropt)'
	menl_parse_rescovariance, rescorrelation(`rescoropt') ///
		resvariance(`resvaropt') rescovariance(`rescovopt')

	local rescor `s(rescor)'	// residual corr structure
	local cbyvar `s(cbyvar)'	// corr by variable
	local ctvar `s(tvar)'		// time variable
	local civar `s(civar)'		// unstructured corr index var
	local ctivar `ctvar'`civar'	// can only be one
	if "`ctivar'" != "" {
		local ctivar1 ("`ctivar'")
	}
	local order `s(order)'		// AR, MA, banded, toeplitz order

	local resvar `s(resvar)'	// residual variance structure
	local vbyvar `s(vbyvar)'	// var by variable
	local vivar `s(ivar)'		// unequal var index variable
	local vpvar `s(varname)'	// linear, power, expo variable
	local varopt `s(varopt)'	// residual variance options
	local varopt0 `varopt'

	local rescov `s(rescov)'

	local rescoropt `s(rescoropt)'
	local resvaropt `s(resvaropt)'
	local rescovopt `s(rescovopt)'

	if "`rescor'"=="ar" | "`rescor'"=="ma" | "`rescor'"=="ctar1" | ///
		"`rescor'"=="banded" | "`rescor'"=="toeplitz" {
		local coropt `order'
	}
	else if "`rescor'" == "unstructured" {
		local coropt = `e(corder)'
	}

	if "`ctvar'" != "" {
		markout `touse' `ctvar'
	}
	if "`vpvar'"!="" & "`vpvar'"!="_yhat" {
		markout `touse' `vpvar'
	}

	if "`cbyvar'" != "" {
		tempname cbytable
		ValidateByVar `cbyvar', table(by) touse(`touse')
		mat `cbytable' = r(table)

		local cbyvar1 ("`cbyvar'","`cbytable'")
	}
	else {
		local cbyvar1 J(1,0,"")
	}
	if "`vbyvar'" != "" {
		tempname vbytable
		if "`resvaropt'" != "" {
			local what strata
		}
		else { 	// rescov
			local what by
		}
		ValidateByVar `vbyvar', table(`what') touse(`touse')
		mat `vbytable' = r(table)

		local vbyvar1 `"("`vbyvar'","`vbytable'")"'
	}
	else {
		local vbyvar1 J(1,0,"") 
	}
	if "`resvar'"=="independent" | "`resvar'"=="distinct" {
		tempname ivals

		local ttvar `tivar'
		/* use e(indexvals) to compose variance index vector	*/
		EgenFromTable `vivar', ivar(`ttvar') touse(`touse')
		mat `ivals' = r(itable)

		local varopt = rowsof(`ivals')
		local vivar1 ("`ttvar'","`ivals'")
        }
	if "`rescor'"=="banded" | "`rescor'"=="unstructured" {
		if "`resvar'" != "distinct" {
			tempname ivals

			if "`rescor'" == "unstructured" {
				local var `civar'
			}
			else { // "`resvar'"=="banded"
				local var `ctvar'
			}
			local ttvar `tivar'
			/* use e(indexvals) to compose correlation index
			 *  vector					*/
			EgenFromTable `var', ivar(`ttvar') touse(`touse')
			mat `ivals' = r(itable)
		}

		local k = rowsof(`ivals')
		if "`rescor'" == "unstructured" {
			local coropt = `k'
		}
		else {
			local coropt `k' `order'
		}
		local ctivar1 ("`ttvar'","`ivals'")
	}
	else if "`rescor'" == "toeplitz" {
		if "`resvar'" == "distinct" {
			local sz = rowsof(`ivals')
		}
		else {
			local ttvar `ctvar'
			summarize `ttvar' if `touse', meanonly

			local sz = r(max)

			if `sz' <= `order' {
				if `sz' == `order' {
					local msg "equal to the"
				}
				else {
					local msg "less than the"
				}
				di as txt "{p 0 6 2}note: toeplitz time " ///
				 "variable {bf:`ctvar'} maximum index, "  ///
				 "`sz', is `msg' order `order'{p_end}"

				local sz = `order'+1
			}
		}
		local coropt `sz' `order'
	}
	if "`ttvar'" == "" {
		local ttvar `ctvar'
	}
	local rc = 0
	mata: _menl_set_touse(`obj',"`touse'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}

	/* parse the model						*/
	local TS_recursive = 0
	local exprs `e(expressions)'
	local kexpr : list sizeof exprs
	forvalues i=1/`kexpr' {
		local exname : word `i' of `exprs'
		local expr `"`e(ex_`exname')'"'
		mata: _menl_parse_expression(`obj',`"`expr'"')
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
		local expr `"`e(tsinit_`exname')'"'
		if `"`expr'"' == "" {
			continue
		}
		/* has a time-series initialization expressions		*/
		mata: _menl_parse_tsinit(`obj',`"{`exname':}=`expr'"')
		if `rc' {
			di as err `"{p}`errmsg'{p_end}"'
			exit `rc'
		}
		local TS_recursive = 1
	}
	ExtractNLExpr `"`eq'"'
	local nlexpr `"`s(nlexpr)'"'
	local opts `"`s(options)'"'
	local nc noconstant
	local xb xb
	local nocons : list opts & nc
	local xb : list opts & xb
	if "`xb'"!="" |"`nocons'"!="" {
		/* linear combination					*/
		local nlexpr `"`depvar' `nlexpr'"'
	}
	else {
		local nlexpr `"`depvar'=`nlexpr'"'
	}

	mata: _menl_parse_equation(`obj',`"`nlexpr'"',("`nocons'"!=""))
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	local expr `"`e(tsinit_`depvar')'"'
	if `"`expr'"' != "" {
		/* has a time-series initialization expressions		*/
		mata: _menl_parse_tsinit(`obj',`"{`depvar':}=`expr'"')
		if `rc' {
			di as err `"{p}`errmsg'{p_end}"'
			exit `rc'
		}
		local TS_recursive = 1
	}

	mata: _menl_get_varlists(`obj',`mark_depvar')	 // for TS order

	tempname TS_order
	mat `TS_order' =  r(TS_order)
	local TS_varlist `"`r(TS_varlist)'"'	// not used
	local TS_lorder = `TS_order'[1,1]
	local TS_forder = `TS_order'[1,2]
	local TS_expr_lorder = `TS_order'[1,3]

	markout `touse' `ctvar' `vivar' `civar' `vbyvar' `cbyvar'
	if !`mark_depvar' {
		/* do not include depvar in estimation sample markout 
		 *  a second estimation sample is created 		*/
		local vlist : list vlist - depvar

		mata: `obj'.set_markout_depvar(0)
	}
	tempvar sorder
	local tsset = 0
	if "`e(tstimevar)'" != "" {
		/* validate tsset					*/
		ValidateTSSet
		local tsset = 1

		local tstimevar `e(tstimevar)'
		local htvar `e(tstimevar)'
		if "`e(tspanelvar)'" != "" {
			local tspanelvar `e(tspanelvar)'
			if "`grvar'" == "" {
				local grvar `e(tspanelvar)'
			}
		}
		/* set tsset time and panel variable in __sub_expr before
 		 *   resolving; markout will use the panel		*/
		mata: `obj'.set_stata_tsvar("`tstimevar'")
		if "`tspanelvar'" != "" {
			mata: `obj'.set_stata_panelvar("`tspanelvar'")
		}
	}
	else if "`e(tsorder)'" != "" {
		if "`tsvname'" == "" {
			/* tsvname created because data is tsset, but
			 *  data was not tsset at estimation time	*/
			qui tsset
			di as err "{p}the {bf:tsset} time variable is "    ///
			 "currently {bf:`r(timevar)'}, but the data was "  ///
			 "not {bf:tsset} at estimation time; this is not " ///
			 "allowed{p_end}"
			di as err "{p 4 4 2}At estimation time you "    ///
			 "specified option {bf:tsorder(`e(tsorder)')}. "    ///
			 "{bf:predict} will {bf:tsset} the data based " ///
			 "on this variable.{p_end}"
			exit(498)
		}
		local tsvar `e(tsorder)'	// option -tsvar()-
		markout `touse' `tsvar'
		local htvar `tsvar'
		mata:_menl_resolve_hierarchy(`obj',"`htvar'","`grvar'")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			if "`message'" != "" {
				di as err "{p 4 4 2}`message' See " /// 
				 "{help menl##syntax:Syntax} or " ///
				 "`ME_SUBEXPR_LINK'.{p_end}"
			}
			exit `rc'
		}
		local khier = r(khier)
		mata: _menl_hierarchy_sort_order(`obj',`khier',"`sorder'")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
		/* estimation sort order, includes time variable	*/
		sort `sorder' 
		/* generate the panel index vector after data is sorted	*/
		tempvar tspanels
		mata: _menl_hierarchy_gen_panel_info(`obj',"`tspanels'")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
		local path0 `r(path)'
		local group `r(group)'
		local path `path0'
		if "`group'" != "" {
			/* group could be in a RV path; hierarchy object
			 *  ensures group is on the bottom of path	*/
			local path: list path0 - group
			local path `path' `group'
		}
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
		menl_tsset `sorder' `tspanels', touse(`touse') ///
			tsvar(`tsvar') timevar(`tsvname')

		/* set -menl- tsset time and panel variable with 
		 * __sub_expr						*/
		mata: `obj'.set_stata_tsvar("`tsvname'")
		if "`tspanels'" != "" {
			mata: `obj'.set_stata_panelvar("`tspanels'")
		}
	}
	else {
		local htvar `ttvar'
	}
	markout `touse' `idvars' `ctvar' `vivar' `civar' `vbyvar' `cbyvar' ///
		`grvar' `tsvar'
	if "`vpvar'"!="" & "`vpvar'"!="_yhat" {
		markout `touse' `vpvar'
	}
	mata: _menl_resolve_expressions(`obj',"`htvar'","`grvar'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	qui count if `touse'
	local N0 = r(N)
	if `N0' == 0 {
		if `TS_lorder' | `TS_forder' {
			local msg " and time-series operators"
		}
		di as err "{p}no estimation sample remains after excluding " ///
		 "missing observations`msg'{p_end}"
		exit 2000
	}
	/* get RE covstructures						*/
	menl_parse_ehierarchy, covstructures
	/* kcov >= klev; could have multiple cov structures per level	*/
	local kcov = `s(kcovstruct)'
	forvalues i=1/`kcov' {
		local lvsi `s(lvs`i')'
		local covi `s(covstruct`i')'
		mata: _menl_add_re_covariance(`obj',"`lvsi'","`covi'","")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
	}
	if "`vivar1'" == "" {
		local vivar1 J(1,0,"")
	}
	if "`ctivar1'" == "" {
		local ctivar1 J(1,0,"")
	}
	mata: _menl_set_resid_covariance(`obj',"`resvar'",`vbyvar1', ///
		`vivar1',"`varopt'","`rescor'",`cbyvar1',`ctivar1',  ///
		"`coropt'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	mata: _menl_resolve_covariances(`obj')
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	tempname sorder
	local ih = e(k_hierarchy)
	mata: _menl_hierarchy_sort_order(`obj',`ih',"`sorder'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	if !`tsset' & "`tsvar'"=="" {
		/* estimation sort order, includes time variable	*/
		sort `sorder'
	}
	/* generate the panel index vector after data is sorted		*/
	local noegen = 1
	mata: _menl_hierarchy_gen_panel_info(`obj',"`panels'",`noegen')
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	local path0 `r(path)'
	local group `r(group)'	// same as grvar
	local path `path0'
	if "`group'" != "" {
		/* group could be in a RV path; hierarchy object
		 *  ensures group is on the bottom of path		*/
		local path: list path0 - group
		local path `path' `group'
	}
	local kpath : list sizeof path
	local kpath : list sizeof path
	local touse1 `r(touse)'	// panel/equation estimation sample
	qui count if `touse1'
	local N = r(N)
	if `N' == 0 {
		if `TS_lorder' | `TS_forder' {
			local msg " and time-series operators"
		}
		di as err "{p}no estimation sample remains after excluding " ///
		 "missing observations`msg'{p_end}"
		exit 2000
	}

	qui summarize `panels' if `touse1', meanonly
	if r(min)==r(max)  & "`path'"=="" & "`tspanelvar'"=="" {
		/* only one panel					*/
		qui drop `panels'
		local panels
	}
	if "`trace'" != "" {
		mata: `obj'.display_equations()
		mata: `obj'.dump_components()
	}
	if `tsset'  {
		menl_validate_tspanelvar `sorder' `panels', touse(`touse1') ///
			`quietly'
	}
	if !`mark_depvar' {
		/* second estimation sample for likelihood evaluation	*/
		qui gen byte `touse2' = `touse'
		markout `touse2' `depvar'
	}
	if `tsset' | "`tsvar'"!= "" {
		if `N'<`N0' & "`panels'"!="" & "`path'"!="`grvar'" {
			if "`tsvar'" != "" {
				local tvar `tsvname'
				if `kpath' == 1 {
					local pvar `path'
				}
				else {
					local pvar `panels'
				}
			}
			else {
				local pvar `tspanelvar'
				local tvar `tstimevar'
			}
			if `TS_recursive' & "`tsmissing'"=="" {
				local recurdep `TS_recurexpr'
				local recurdep : list TS_recurexpr & depvar
				if "`recurdep'" != "" {
					local recuropt recursive
				}
			}
			CheckForDroppedPanel `pvar', tvar(`tvar') ///
				touse1(`touse1') touse(`touse') `recuropt'
		}
	}
	/* extract table generated index variables 			*/
	mata: st_local("vivar1",(length(`vivar1')?`vivar1'[1]:""))
	if "`vivar1'" != "" {
		char define `vivar1'[name] "`vivar'"
	}
	mata: st_local("ctivar1",(length(`ctivar1')?`ctivar1'[1]:""))
	if "`ctivar1'" != "" {
		char define `ctivar1'[name] "`ctivar'"
	}
	mata: st_local("cbyvar1",(length(`cbyvar1')?`cbyvar1'[1]:""))
	if "`cbyvar1'" != "" {
		char define `cbyvar1'[name] "`cbyvar'"
	}
	mata: st_local("vbyvar1",(length(`vbyvar1')?`vbyvar1'[1]:""))
	if "`vbyvar1'" != "" {
		char define `vbyvar1'[name] "`vbyvar'"
	}
	if `tsset' {
		local tsop tsvar(`tstimevar') tsset
	}
	else {
		local tsop tsvar(`tsvar')
	}
	menl_validate_restvar `sorder' `panels', touse(`touse1')   ///
		restvar(`ttvar' `ctvar' `civar') vivar(`vivar')    ///
		rescor(`rescor') resvar(`resvar') rescov(`rescov') ///
		path(`path') `tsop' `quietly'

	if `tsset' {
		local tspanels `tspanelvar'
	}
	else {	
		local tspanels `panels'
	}
	menl_validate_byvars `sorder' `panels', touse(`touse1')    ///
		cbyvar(`cbyvar') vbyvar(`vbyvar') rescov(`rescov') ///
		rescor(`rescor') resvar(`resvar') touse2(`touse2')

	tempname b0
	if "`b'" == "" {
		tempname b
	}
	mat `b0' = e(b)
	/* restripe coefficient vector with the names generated by the
  	 *	parser that exclude the o., omit, operator		*/
	mat colnames `b0' = `e(bstripe)'
	mata: _menl_get_parameters(`obj',"`b'")
	/* copy by name, small chance the parameters are in a different
	 * 	order							*/
	/* skip unrecognized coefficients in e(b); if -margins- is doing
	 * 	a discrete change in factor variables the obj parameter
	 *  	vector will not be identical to e(b)			*/
	mata: _menl_mkvec_from_vec("`b'","`b0'","`skip'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		if `rc' != 507 {
			exit `rc'
		}
		local stripe : colfullnames `b'
		di as err "{p 4 4 2}If your dataset has changed perhaps " ///
		 "a factor level that existed at estimation time no "     ///
		 "longer exists.{p_end}"
		di as err _n "{p 4 4 2}The coefficient names at " ///
		 "estimation time are:{p_end}"
		di as err "{p 4 4 2}{bf:`e(bstripe)'}{p_end}"
		di as err _n "{p 4 4 2}The coefficient names at " ///
		 "postestimation time are:{p_end}"
		di as err "{p 4 4 2}{bf:`stripe'}{p_end}"
		exit `rc'
	}
	mata: _menl_set_parameters(`obj',"`b'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	sreturn local touse `touse1'
end

program define EgenFromTable, rclass
	syntax varname, ivar(name) touse(varname)

	tempname itable tab
	tempvar mark

	local indvar `varlist'	// should be e(indexvar)
	markout `touse' `indvar'
	cap mat `itable' = e(indexvals)
	if c(rc) {
		di as err "{p}{bf:rescovariance()} {bf:index(`indvar')} "    ///
		 "table not found in {bf:ereturn}; you must reestimate the " ///
		 "model{p_end}" 
		di as txt _n "{p 6 6 2}Your {helpb menl} estimates are "   ///
		 "from a version that did not save the matrix that maps "  ///
		 "values from variable {bf:`indvar'} to the 1 based "      ///
		 "residual variance indices.{p_end}"

		exit 322
	}
	qui gen long `ivar' = .
	local k = rowsof(`itable')
	forvalues i=1/`k' {
		local val = `itable'[`i',1]
		qui replace `ivar' = `i' if `indvar'==`val'
	}
	qui gen byte `mark' = missing(`ivar')
	qui count if `mark' & `touse'
	if !r(N) {
		return matrix itable = `itable'
		exit
	}
	local labels : value label `indvar'
	qui tabulate `indvar' if `mark' & `touse', matrow(`tab')
	local k = rowsof(`tab')
	forvalues i=1/`k' {
		local x = `tab'[`i',1]
		local lx
		if "`labels'" != "" {
			local lx : label `labels' `x'
		}
		if "`lx'" != "" {
			local bad `bad'`c' {bf:`lx'}
		}
		else {
			local bad `bad'`c' {bf:`x'}
		}
		local c ,
	}
	if `k' == 1 {
		local levels "a level"
	}
	else {
		local levels "levels"
	}
	di as txt "{p 0 6 2}note: index variable {bf:`indvar'} contains " ///
	 "`levels' not used during estimation (`bad'); the associated "   ///
	 "observations will be ignored{p_end}"
	qui replace `touse' = 0 if `mark' & `touse'

	return matrix itable = `itable'
end

program define ValidateByVar, rclass
	syntax varname, table(string) touse(varname)

	tempname btable tab
	tempvar mark

	local var `varlist'
	mat `btable' = e(`table'vals)
	local k = rowsof(`btable')

	gen byte `mark' = 0
	forvalues i=1/`k' {
		qui replace `mark' = 1 if `var'==`btable'[`i',1]
	}
	qui replace `mark' = !`mark'
	qui count if `mark' & `touse'
	if !r(N) {
		return matrix table = `btable'
		exit
	}
	local labels : value label `var'
	qui tabulate `var' if `mark' & `touse', matrow(`tab')
	local k = rowsof(`tab')
	forvalues i=1/`k' {
		local x = `tab'[`i',1]
		local lx
		if "`labels'" != "" {
			local lx : label `labels' `x'
		}
		if "`lx'" != "" {
			local bad `bad'`c' {bf:`lx'}
		}
		else {
			local bad `bad'`c' {bf:`x'}
		}
		local c ,
	}
	if `k' == 1 {
		local levels "a level"
	}
	else {
		local levels "levels"
	}
	di as txt "{p 0 6 2}note: `table' variable {bf:`indvar'} contains " ///
	 "`levels' not used during estimation (`bad'); the associated "     ///
	 "observations will be ignored{p_end}"
	qui replace `touse' = 0 if `mark' & `touse'

	return matrix table = `btable'
end

program define ValidateTSSet

	local tsset = 0
	cap tsset
	local rc = c(rc)
	if !`rc' {
		local tsset = 1
		if "`e(tstimevar)'" == "" {
			di as err "{p}the {helpb tsset} time variable is " ///
			 "currently {bf:`r(timevar)'}, but the data was " ///
			 "not {bf:tsset} at estimation time; this is not " ///
			 "allowed{p_end}"
			if "`e(tsorder)'" != "" {
				di as err "{p 4 4 2}At estimation time you " ///
				 "specified option " ///
				 "{bf:timevar(`e(tsorder)')}. " ///
				 "{bf:predict} will {bf:tsset} the data " ///
				 "based on this variable.{p_end}"
			}
			exit 498
		}
		else if "`e(tstimevar)'" != "`r(timevar)'" {
			/* if called by margins allow this condition
			 *  through 					*/
			if "`c(marginscmd)'" != "on" {
				di as err "{p}the {helpb tsset} time " ///
				 "variable was {bf:`e(tstimevar)'} at " ///
				 "estimation time, but is now " ///
				 "{bf:`r(timevar)'}; this is not allowed{p_end}"
				exit 498
			}
		}	
		
		if "`e(tspanelvar)'"!="" & "`e(tspanelvar)'"!="`r(panelvar)'" {
			di as err "{p}the {helpb tsset} panel variable was " ///
			 "{bf:`e(tspanelvar)'} at estimation time, but " _c
			if "`r(panelvar)'" == "" {
				di as err "is not currently {bf:tsset}; " _c
			}
			else {
				di as err "is currently {bf:`r(panelvar)'}; " _c
			}
			di as err "this is not allowed{p_end}"
			exit 498
		}
		if "`r(tspanelvar)'"!="" & "`e(tspanelvar)'"=="" {
			di as err "{p}the {helpb tsset} panel variable is " ///
			 "currently {bf:`r(panelvar)'}, but was not set at " ///
			 "estimation time; this is not allowed{p_end}"
			exit 498
		}
	}
	else if "`e(tstimevar)'" != "" {
		di as err "{p}the {helpb tsset} time variable was " ///
		 "{bf:`e(tstimevar)'} at estimation time, but the " ///
		 "data is not currently {bf:tsset}; this is not " ///
		 "allowed{p_end}"
		exit 498
	}
	else if "`e(tspanelvar)'" != "" {
		di as err "{p}the {helpb tsset} panel variable was " ///
		 "{bf:`e(tspanelvar)'} at estimation time, but " ///
		 "the panel variable is not currently {bf:tsset}; this " ///
		 "is not allowed{p_end}"
		exit 498
	}
	local rc = 0
end


program define ExtractNLExpr, sclass
	args expr

	sreturn clear
	local expr : list retokenize expr

	// gettoken expr1 expr2 : rest, parse("{") bindcurly
	gettoken nlexpr rest : expr, parse(",") bindcurly
	local rest : list retokenize rest
	if "`rest'" != "" {
		gettoken comma rest: rest, parse(",")
		local rest : list retokenize rest
	}
	local nlexpr : list retokenize nlexpr
	sreturn local nlexpr `"`nlexpr'"'
	sreturn local options `"`rest'"'
end

program define CheckForDroppedPanel, sortpreserve
	syntax varname, tvar(varname) touse1(varname) touse(varname)

	local panel `varlist'
	tempvar check block

	qui gen byte `block' = 1-`touse'
	sort `block' `panel' `tvar'
	qui gen long `check' = 0 
	qui replace  `check' = `touse1' if `touse'

	/* assumption: sorted by panel					*/
	qui by `block' `panel' : replace `check' = sum(`check') 
	cap by `block' `panel' : assert `check'[_N] != 0 if `touse'
	if (c(rc)) {
		di as err "{p}panel dropped due to time-series operators; " ///
		 "check your data and ensure each panel has enough "        ///
		 "observations to handle all time-series operators{p_end}"
		exit 2001
	}
end

exit
