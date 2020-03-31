*! version 1.3.6  24feb2020

program define menl, eclass
	local vv : di "version " string(_caller()) ":"
	version 15.0

	if replay() {
		if "`e(cmd)'" != "menl" {
			error 301
		}
		Display `0'
		exit
	}
	`vv' Estimate `0'

	local cmdline `"menl `0'"'
	local cmdline : list retokenize cmdline
	ereturn local cmdline `"`cmdline'"'
end

program define Estimate, sortpreserve
	local vv : di "version " string(_caller()) ":"
	version 15.0

	tempname EXPR ENULL
	mata: _menl_create_instance("`EXPR'")
	mata: _menl_create_instance("`ENULL'")

	cap tsset
	local tsset = !c(rc)

	if !`tsset' {
		tempvar panels tsvar
	}

	cap noi `vv' Estimate1 `EXPR' `ENULL' `tsvar' `panels': `0'
	local rc = c(rc)

	mata: _menl_remove_instance(`EXPR',"`EXPR'")
	mata: _menl_remove_instance(`ENULL',"`ENULL'")

	if !`tsset' {
		tempname retable fetable

		cap mat `retable' = r(retable)
		cap mat `fetable' = r(table)
		local hastable = (c(rc)==0)

		/* -menl- tsset the data with tempvars			*/
		cap tsset
		if !c(rc) {
			tsset, clear
		}
		capture	// clear c(rc)
		if `hastable' {
			RePostReTable, retable(`retable') fetable(`fetable')
		}
		
	}
	if (`rc') exit `rc'
end

program define Estimate1, eclass
	version 15.0
	local vv : di "version " string(_caller()) ":"
	local ME_SUBEXPR_LINK "{mansection ME menlRemarksandexamplesRandom-effectssubstitutableexpressions:{it:Random-effects substitutable expressions}}"

	qui describe
	if !(r(k) & r(N)) {
		di as err "no variables defined"
		exit 111
	}
	
	_on_colon_parse `0'
	local EXPR `s(before)'
	local 0 `"`s(after)'"'

	gettoken EXPR ENULL: EXPR
	gettoken ENULL tstimevar: ENULL

	local EXPR : list retokenize EXPR
	local ENULL : list retokenize ENULL

	if "`tstimevar'" != "" {
		gettoken tstimevar tspanelvar: tstimevar

		local tstimevar : list retokenize tstimevar
		local tspanelvar : list retokenize tspanelvar
	}

	ExtractNLExpr `"`0'"'

	local nlexpr `"`s(nlexpr)'"'
	local 0 `"`s(ifin)',`s(options)'"'
	syntax [if][in],			///
		[	METHod(string)		///
			RESCOVariance(string)	///
			RESCORRelation(string) 	///
			RESVARiance(string)	///
			INITial(string)		///
			lmeopts(string)		///
			pnlsopts(string)	///
			NOCONStant		/// /* eq linear form	*/
			xb			/// /* eq linear form	*/
			EMITERate(passthru)	///
			EMTOLerance(passthru)	///
			emlog			///
			TSMISSing		///
			tsorder(varname numeric)	///
			NOTSSHOW		///
			subexprtrace		///
			debug(integer 0)	/// /* undocumented	*/
			*			///
		]
	/* undocumented:	debug	-- programmer debugging		*/
	set fvtrack term

	ParseDisplayOpts, `options'
	local options `"`s(options)'"'
	local diopts `"`s(diopts)' `s(diopts1)'"'
	local lrtest `s(lrtest)'
	local lrnullshow `s(lrnullshow)'

	sreturn clear
	ParseDefines 0 : `options'
	local kdef = `s(kdefine)'
	forvalues i=1/`kdef' {
		local define`i' `"`s(define`i')'"'
	}
	local options `"`s(options)'"'

	sreturn clear
	ParseCovariances `options'
	local kcov = `s(kcov)'
	forvalues i=1/`kcov' {
		local renames`i' "`s(renames`i')'"
		local vartype`i' "`s(vartype`i')'"
		if "`vartype`i''" == "fixed" {
			local fixpat`i' "`s(fixed`i')'"
		}
		else if "`vartype`i''" == "pattern" {
			local fixpat`i' "`s(pattern`i')'"
		}
	}
	local options `"`s(options)'"'

	if "`rescorrelation'"!="" & "`rescovariances'"!="" {
		di as err "options {bf:rescorrelation()} and " ///
		 "{bf:rescovariances()} cannot both be specified"
		exit 184
	}
	if "`rescorrelation'"!="" & "`rescovariance'"!="" {
		di as err "options {bf:rescorrelation()} and " ///
		 "{bf:rescovariance()} cannot both be specified"
		exit 184
	}
	if "`rescovariance'"!="" & "`rescovariances'"!="" {
		di as err "options {bf:rescovariance()} and " ///
		 "{bf:rescovariances()} cannot both be specified"
		exit 184
	}
	if "`resvariance'"!="" & "`rescovariances'"!="" {
		di as err "options {bf:resvariance()} and " ///
		 "{bf:rescovariances()} cannot both be specified"
		exit 184
	}
	if "`resvariance'"!="" & "`rescovariance'"!="" {
		di as err "options {bf:resvariance()} and " ///
		 "{bf:rescovariance()} cannot both be specified"
		exit 184
	}
	menl_parse_rescovariance, rescorrelation(`rescorrelation') ///
		resvariance(`resvariance') rescovariance(`rescovariance')
	local rescor `s(rescor)'	// residual correlation structure
	local cbyvar `s(cbyvar)'	// corr by variable
	local ctvar `s(ctvar)'		// time variable
	local civar `s(civar)'		// unstructured/banded corr index var
	local corder `s(order)'		// AR, MA order
	local cgrvar `s(cgrvar)'	// correlation group variable

	local resvar `s(resvar)'	// residual variance structure
	local vbyvar `s(vbyvar)'	// var by variable
	local vivar `s(vivar)'		// unequal var index variable
	local vpvar `s(vpvar)'		// linear, power, expo variable
	local varopt `s(varopt)'	// residual variance options
	local varopt0 `varopt'
	local vgrvar `s(vgrvar)'	// variance group variable

	local grvar `s(grvar)'		// covariance group variable

	local rescov `s(rescov)'	// residual covariance structure
	local rescoropt `s(rescoropt)'
	local resvaropt `s(resvaropt)'
	local rescovopt `s(rescovopt)'

	if "`rescov'" == "" {
		if "`cgrvar'" != "" {
			local grvar `cgrvar'
		}
		else {
			local grvar `vgrvar'
		}
	}

	if "`rescor'"=="ar" | "`rescor'"=="ma" | "`rescor'"=="ctar1" | ///
		"`rescor'"=="banded" | "`rescor'"=="toeplitz" {
		local coropt `corder'
	}
	ParseMethod, `method'
	local method `s(method)'

	ParseOptimizeOptions `method' : `options'
	local mopts `"`s(mopts)' debug `debug'"'
	local options `"`s(options)'"'
	local vce "`s(vce)'"
	local ltype  `s(ltype)'	// mle reml
	local nolog `s(nolog)'
	local nostderr `s(nostderr)'

	`vv' ParseLMEopts, `lmeopts'
	local lmeopts0 `"`s(mopts)' `ltype' debug `debug'"'
	local vstderr `s(vstderr)'	
	local tmp : subinstr local varopt "variances" "variances", word ///
		count(local repvar)
	if `repvar' > 0 {
		/* report by() variances, not ratios			*/
		local lmeopts0 `"`lmeopts0' metric variances"'
	}

	ParsePNLSopts, `pnlsopts'
	local pnlsopts0 `"`s(mopts)' debug `debug'"'

	ParseEMopts, `emiterate' `emtolerance' `emlog'
	local init_opts "`s(mopts)'"

	local tsvar `tsorder'	// old name
	marksample touse
	local rc = 0
	mata: _menl_set_touse(`EXPR',"`touse'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	/* parse the model						*/
	forvalues i=1/`kdef' {
		mata: _menl_parse_expression(`EXPR',`"`define`i''"')
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			if "`message'" != "" {
				di as err "{p 4 4 2}`message' See " /// 
				 "{help menl##syntax:Syntax} or " ///
				 "`ME_SUBEXPR_LINK'.{p_end}"
			}			
			exit `rc'
		}
	}
	/* noconstant option used for a linear form expression		*/
	mata: _menl_parse_equation(`EXPR',`"`nlexpr'"',("`noconstant'"!=""), ///
			("`xb'"!=""))
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		if "`message'" != "" {
			di as err "{p 4 4 2}`message' See " /// 
			 "{help menl##syntax:Syntax} or " ///
			 "`ME_SUBEXPR_LINK'.{p_end}"
		}
		exit `rc'
	}
	tempname TS_order
	/* do not markout depvar: depvar has missings and use only 
	 *  nonmissing depvar values to evaluate the likelihood, 
	 *  function evaluation uses the full estimation sample		*/
	local mark_depvar = ("`tsmissing'"=="")

	/* obtain model information: set flag in __sub_expr whether
	 *  to markout dependent variable				*/
	mata: _menl_get_varlists(`EXPR',`mark_depvar')
	local varlist `"`r(varlist)'"'
	local depvar "`r(depvar)'"
	local idvars `"`r(idvars)'"'	// hierarchy index variables
	/* expressions containing lagged prediction of itself; can only
	 *  detect direct recursion at this point.
	 *  need to resolve expressions to detect indirect recursion	*/
	local TS_recursive = r(TS_recursive)
	local TS_recurexpr `"`r(TS_recurexpr)'"'

	mat `TS_order' =  r(TS_order)
	local TS_varlist `"`r(TS_varlist)'"'
	local TS_lorder = `TS_order'[1,1]	// lag order
	local TS_forder = `TS_order'[1,2]	// forward order
	local TS_expr_lorder = `TS_order'[1,3]	// lagged expected expr order
	local kRV  = r(kRV)	// # random variables

	if !`mark_depvar' {
		local varlist : list varlist - depvar
	}
	 /* estimation sample for data checking and hierarchy
	 *   construction, no varlist					*/
	markout `touse' `idvars' `ctvar' `vivar' `civar' `vbyvar' `cbyvar' ///
		`grvar' `tsvar'
	if "`vpvar'"!="" & "`vpvar'"!="_yhat" {
		markout `touse' `vpvar'
		local vlist `vlist' `vpvar'
	}
	qui count if `touse'
	if r(N) == 0 {
		di as err "{p}no estimation sample remains after excluding " ///
		 "missing observations{p_end}"
		exit 2000
	}

	/* only need tsinit() expressions if  `TS_recursive'		*/
	ParseTSInit 0 : `options'

	local ktsinit = `s(ktsinit)'
	local options `"`s(options)'"'
	forvalues i=1/`ktsinit' {
		local tsinit`i' `"`s(tsinit`i')'"'
		mata: _menl_parse_tsinit(`EXPR',`"`tsinit`i''"')
		if `rc' {
			di as err `"{p}`errmsg'{p_end}"'
			exit `rc'
		}
	}
	if `"`options'"' != "" {
		/* left over options
		 *  throw error with first bad option			*/
		gettoken opt options: options, bind
		di as err "{p}option {bf:`opt'} not allowed{p_end}"
		exit 198
	}

	local tsset = 0
	cap tsset
	local tsrc = c(rc)
	if !`tsrc' {
		if "`tsvar'" != "" {
			di as err "{p}option {bf:tsorder()} cannot be " ///
			 "specified when the data are {helpb tsset}{p_end}"
			exit 198
		}
		local tsset = 1
		local tspanelvar `r(panelvar)'
		local tstimevar `r(timevar)'
	}
	if `TS_lorder' | `TS_forder' | `TS_expr_lorder' | `TS_recursive' {
		/* model has time-series operators			*/
		if `tsrc' & "`tsvar'"=="" {
			di as err "{p}time variable not set; use option " ///
			 "{bf:tsorder()} or {helpb tsset} the data{p_end}" 
			exit `tsrc'
		}
	}
	if `tsset' {
		if "`rescovopt'" != "" {
			local what rescovariance
		}
		else {
			local what rescorrelation
		}
		local rc = 0
		if "`ctvar'"!="" & "`ctvar'"!="`tstimevar'" {
			di as txt "{p 0 6 2}note: The " ///
			"{helpb tsset} variable " ///
			 "{bf:`tstimevar'} does not match the " ///
			 "{bf:`what'} time variable {bf:`ctvar'}." ///
			 "{p_end}"
		}
		if "`grvar'"!="" & "`tspanelvar'"!="" & ///
			"`grvar'"!="`tspanelvar'" {
			di as err "{p}the {helpb tsset} panel " ///
			 "variable {bf:`tspanelvar'} does not " ///
			 "match the {bf:`what'} group variable " ///
			 "{bf:`grvar'}; this is not allowed{p_end}"
			exit(498)
		}
		if "`grvar'" == "" {
			local idvars0: list idvars - tspanelvar
			if "`idvars0'" == "`idvars'" {
				/* set the TS panel variable as
				 *  the group variable			*/
				local grvar `tspanelvar'
			}
		}
		markout `touse' `tstimevar' `tspanelvar'
	}
	else if "`tsvar'" != "" { 
		if "`rescovopt'" != "" {
			local what rescovariance
		}
		else {
			local what rescorrelation
		}
		if "`ctvar'"!="" & "`ctvar'"!="`tsvar'" {
			di as txt "{p 0 6 2}note: {bf:tsorder} variable " ///
			 "{bf:`tsvar'} does not match the {bf:`what'} time " ///
			 "variable {bf:`ctvar'}{p_end}"
		}
	}
	if "`vivar'" != "" {
		local opt = cond(`"`rescovariance'"'=="", ///
		  "resvariance(`resvaropt')", "rescovariance(`rescovopt')")
		ValidateIntegerValued `opt' : `vivar', touse(`touse')
	}
	else if "`civar'" != "" {
		local opt = cond(`"`rescovariance'"'=="", ///
		  "rescorrelation(`rescoropt')", "rescovariance(`rescovopt')")
		ValidateIntegerValued `opt' : `civar', touse(`touse')
	}
	if "`rescor'"=="ar" | "`rescor'"=="ma" | "`rescor'"=="toeplitz" {
		local opt = cond(`"`rescovariance'"'=="", ///
		  "rescorrelation(`rescoropt')", "rescovariance(`rescovopt')")
		ValidateIntegerValued `opt' : `ctvar', touse(`touse')
	}
	local ttvar_temp = 0
	if "`rescov'"=="independent" | "`resvar'"=="distinct" {
		/* if rescov is independent then resvar is distinct	*/
		tempvar ttvar
		local ttvar_temp = 1

		qui egen long `ttvar' = group(`vivar') if `touse'
        }
	if "`rescor'"=="unstructured" | "`rescor'"=="banded" {
		if "`resvar'" != "distinct" {
			tempvar ttvar
			local ttvar_temp = 1

			/* civar == vivar already checked at parse	*/
			qui egen long `ttvar' = group(`civar') if `touse'
		}
	}
	else if "`ttvar'" == "" {
		local ttvar `ctvar'
	}
	if "`grvar'" != "" {
		ValidateIntegerValued group : `grvar', touse(`touse')
	}
	else if `kRV'==0 & ("`cbyvar'"!="" | "`vbyvar'"!="") {
		/* declare by variable vary as the group variable to
		 *  sort by-indices together				*/
		if "`cbyvar'" != "" {
			local grvar `cbyvar'
		}
		else {
			local grvar `vbyvar'
		}
		ValidateIntegerValued by : `grvar', touse(`touse')
	}
	/* set hierarchical time variable				*/
	if "`tsvar'" != "" {
		local htvar `tsvar'
	}
	else if `tsset' {
		local htvar `tstimevar'
	}
	else if "`ttvar'" != "" {
		local htvar `ttvar'
	}
	tempvar sorder
	if `tsset' {
		/* set tsset time and panel variable in __sub_expr before
 		 *   resolving; markout will use the panel		*/
		mata: `EXPR'.set_stata_tsvar("`tstimevar'")
		if "`tspanelvar'" != "" {
			mata: `EXPR'.set_stata_panelvar("`tspanelvar'")
		}
	}
	else if "`tsvar'" != "" {
		mata:_menl_resolve_hierarchy(`EXPR',"`htvar'","`grvar'")
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
		mata: _menl_hierarchy_sort_order(`EXPR',`khier',"`sorder'")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
		/* estimation sort order, includes time variable	*/
		sort `sorder' 
		/* generate the panel index vector after data is sorted	*/
		mata: _menl_hierarchy_gen_panel_info(`EXPR',"`tspanelvar'")
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
			local path: list path - group
			local path `path' `group'
		}
		local kpath : list sizeof path
		summarize `tspanelvar' if `touse', meanonly
		if r(min)==r(max)  & "`path'"=="" {
			/* only one panel				*/
			qui drop `tspanelvar'
			local tspanelvar
		}
		if `kpath' == 1 {
			qui drop `tspanelvar'
			local tspanelvar `path'
		}
		/* tsset the data					*/
		menl_tsset `sorder' `tspanelvar', touse(`touse') ///
			tsvar(`tsvar') timevar(`tstimevar')

		/* set -menl- tsset time and panel variable with 
		 * __sub_expr						*/
		mata: `EXPR'.set_stata_tsvar("`tstimevar'")
		if "`tspanelvar'" != "" {
			mata: `EXPR'.set_stata_panelvar("`tspanelvar'")
		}
	}
	/* htvar used to compose hierarchical sort order		*/
	/* resolve generates estimation sample for equation and
	 *  each named expression					*/
	mata: _menl_resolve_expressions(`EXPR',"`htvar'","`grvar'")
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
	/* resolve sniffs out indirect recursions; likely will not
	 *  evaluate successively though				*/
	local TS_recursive = r(TS_recursive)
	local TS_recurexpr `"`r(TS_recurexpr)'"'
	if r(kwarn) {
		forvalues i=1/`=r(kwarn)' {
			di as txt "{p 0 6 2}note: `r(warn`i')'{p_end}"
		}
	}
	if `debug' > 1 {
		mata: _menl_debug_display(`EXPR',`debug')
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
	if "`tsmissing'"!="" & !`TS_recursive' {
		di as err "{p}option {bf:tsmissing} not allowed unless a " ///
		 "named expression contains a lag of itself, either " ///
		 "directly or indirectly{p_end}"
		exit 184
	}
	/* resolve_expressions generates a RV hierarchy, even if one
	 *  generated above						*/
	mata: _menl_hierarchy_sort_order(`EXPR',`khier',"`sorder'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	if !`tsset' & "`tsvar'"=="" {
		/* estimation sort order, includes time variable	*/
		sort `sorder' 
	}
	tempvar panels
	/* generate the panel index vector after data is sorted
	 *  if -tsvar- specified we need to regenerate panels		*/
	 mata: _menl_hierarchy_gen_panel_info(`EXPR',"`panels'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		exit `rc'
	}
	local path0 `r(path)'
	local group `r(group)'	// same as grvar
	local path `path0'
	if "`group'" != "" {
		/* group could be in a RV path; hierarchy object
		 *  ensures group is on the bottom of path	*/
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
	NestedGroupMsg, grvar(`grvar') path(`path0')
	summarize `panels' if `touse1', meanonly
	if r(min) == r(max) {
		/* single panel						*/
		qui drop `panels'
		local panels
	}
	if `tsset' {
		/* ensure hierarchy panels agree with tsset panels	*/
		menl_validate_tspanelvar `sorder' `panels', touse(`touse1') ///
			path(`path')
	}
	if "`tsmissing'" != "" {
		/* markout depvar: depvar has missings and use 
		 * only nonmissing depvar values to evaluate the
		 * likelihood.  Function evaluation uses the full 
		 * estimation sample.  Likely a PK TS_recursive model:
		 * depvar = f(L.depvar,...)				*/
		tempname touse2

		qui gen byte `touse2' = `touse1'
		markout `touse2' `depvar'
		qui count if `touse2'
		if r(N) == 0 {
			di as err "{p}no likelihood-function estimation " ///
			 "sample remains after excluding missing " ///
			 "dependent-variable observations{p_end}"
			exit 2000
		}
	}
	if `tsset' | "`tsvar'"!= "" {
		if `N'<`N0' & "`panels'"!="" & "`path'"!="`grvar'" {
			local tvar `tstimevar'
			if "`tsvar'" != "" {
				if `kpath' == 1 {
					local pvar `path'
				}
				else {
					local pvar `tspanelvar'
				}
			}
			else {
				local pvar `tspanelvar'
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
	forvalues i=1/`kcov' {
		mata: _menl_add_re_covariance(`EXPR',"`renames`i''", ///
				"`vartype`i''","`fixpat`i''")
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			if "`message'" != "" {
				di as err "{p 4 4 2}`message' See " /// 
				 "{help menl##syntax:Syntax} or " ///
				 "`ME_SUBEXPR_LINK'.{p_end}"
			}
			exit `rc'
		}
	}
	if "`rescov'"=="independent" | "`resvar'"=="distinct" {
		/* if rescov is independent then resvar is distinct	
		 *  recompute indices on equation estimation sample	*/
		if `ttvar_temp' {
			qui drop `ttvar'
		}
		tempvar ttvar

		qui egen long `ttvar' = group(`vivar') if `touse1'
		char define `ttvar'[name] "`vivar'"
                 /* max size of residual correlation matrix     	*/
                summarize `ttvar' if `touse1', meanonly
                local varopt = r(max)
		local vorder = r(max)
		if "`rescor'" == "unstructured" {
			local corder = r(max)
			local coropt = `corder'
		}
        }
	if "`rescor'"=="unstructured" | "`rescor'"=="banded" {
		if "`resvar'" != "distinct" {
			if `ttvar_temp' {
				qui drop `ttvar'
			}
			tempvar ttvar

			/* civar == vivar already checked at parse	
		 	 *  recompute indices on equation estimation 
		 	 *  sample					*/
			qui egen long `ttvar' = group(`civar') if `touse1'
			char define `ttvar'[name] "`civar'"
	                /* max size of residual correlation matrix     	*/
        	        summarize `ttvar' if `touse1', meanonly
		}
		/* resvar==distinct summary return still exists		*/
		if "`rescor'" == "unstructured" {
			local corder = r(max)
			local coropt = `corder'
		}
		else {
			local k = r(max)
			if (missing(`corder')) {
				/* default				*/
				local corder = `k'-1
			}
			local omax = `k'-1
			if `corder' > `omax' {
				di as err "{p}invalid {bf:banded} residual " ///
				 "correlation: order = `corder' exceeds "    ///
				 "the maximum of `omax'{p_end}"
				exit 198
			}
			local coropt `k' `corder'
		}
	}
	else if "`rescor'" == "toeplitz" {
		/* toeplitz has a real time variable			*/
		local ttvar `ctvar'

                 /* max size of residual correlation matrix  using 
		  *  equation estimation sample		   	 	*/
       	        summarize `ttvar' if `touse1', meanonly

		if "`vivar'"!="" & "`ctvar'"!="`vivar'" {
			/* variance index var must be the same as the 
			 *  correlation (integer) time var		*/
			di as err "{p}options " ///
			 "{bf:resvariance(distinct, index(`vivar'))} and "   ///
			 "{bf:rescorrelation(toeplitz, t(`ctvar'))} must "   ///
			 "specify the same variable for indexing variances " ///
			 "and correlations when used together{p_end}"
			exit 198
		}
		local k = r(max)
		if (missing(`corder')) {
			/* default					*/
			local corder = `k'-1
		}
		local omax = `k'-1
		if `corder' > `omax' {
			di as err "{p}invalid toeplitz residual "    ///
			 "correlation: order = `corder' exceeds the " ///
			 "maximum `omax'{p_end}"
			exit 198
		}
		local coropt `k' `corder'
	}
	if "`resvar'" == "linear" {
		/* could have -variance- option as second argument	*/
		gettoken varopt tmp : varopt
		cap assert `varopt' > 0 if `touse1'
		local rc = c(rc)
		if c(rc) {
			di as err "{p}invalid "                       ///
			 "{bf:resvariance(linear `varopt')} "         ///
			 "specification: {bf:`varopt'} must contain " ///
			 "positive values{p_end}"
			exit 198
		}
	}
	/* one slot for either correlation index or time variable	*/
	if "`civar'" != "" {
		local ctivar `civar'
	}
	else {
		local ctivar `ctvar'
	}

	mata: _menl_set_resid_covariance(`EXPR',"`resvar'","`vbyvar'", ///
		"`vivar'","`varopt'","`rescor'","`cbyvar'","`ctivar'", ///
		"`coropt'")
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		if "`message'" != "" {
			di as err "{p 4 4 2}`message' See " /// 
			 "{help menl##syntax:Syntax} or " ///
			 "`ME_SUBEXPR_LINK'.{p_end}"
		}
		exit `rc'
	}
	mata: _menl_resolve_covariances(`EXPR')
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		if "`message'" != "" {
			di as err "{p 4 4 2}`message' See " /// 
			 "{help menl##syntax:Syntax} or " ///
			 "`ME_SUBEXPR_LINK'.{p_end}"
		}
		exit `rc'
	}
	if `khier' {
		if "`method'" == "gnls" {
			di as err "{p}invalid method {bf:`method'}: random " ///
			 "effects not allowed{p_end}"
			exit 198
		}
		if "`method'" == "default" {
			local method lbates
			/* check optimization options: generate error if
			 *  gradient, showstep, hessian, nrtolerance,
			 *  nonrtolerance specified			*/
			CheckLBatesOptOptions `"`mopts'"'
		}
	}
	else {
		if "`method'"=="lbates" | "`method'"=="quadrature" {
			di as err "{p}invalid method {bf:`method'}: random " ///
			 "effects are required{p_end}"
			exit 198
		}
		if "`method'" == "default" {
			local method gnls
		}
		local what
		if "`rescov'" == "identity" {
			if "`pnlsopts'"!="" | "`lmeopts'"!="" {
				local MAXOPTLINK ///
				{help menl##menlmaxopts:maximization options}

				di as err "{p}options {bf:pnlsopts()} and " ///
				 "{bf:lmeopts()} not allowed with the NLS " ///
				 "algorithm{p_end}"
				di as err "{p 4 4 2}Options "                ///
				 "{bf:pnlsopts()} and {bf:lmeopts()} "       ///
				 "control maximization settings of the "     ///
				 "Lindstrom-Bates and GNLS alternating "     ///
				 "algorithms. In the absence of random "     ///
				 "effects and with independent errors, "     ///
				 "the alternating algorithm is not "         ///
				 "necessary and the standard NLS algorithm " ///
				 "is used instead.  Use `MAXOPTLINK' "       ///
				 "such as {bf:tolerance()} or "              ///
				 "{bf:ltolerance()} to control "             ///
				 "maximization settings of the NLS "         ///
				 "algorithm.{p_end}"
				exit(198)
			}
		}
		else {
			/* forbid nrtolerance, etc			*/
			CheckLBatesOptOptions `"`pnlsopts'"'
		}
		if "`rescov'" == "unstructured" {
			if "`grvar'" == "" {
				local what rescovariance(`rescov')
			}
		}
		else if "`rescov'" == "banded" {
			if "`grvar'" == "" {
				local what rescovariance(`rescov')
			}
		}
		else {
			if "`rescor'"=="unstructured" & "`rescov'"=="" {
				if "`cgrvar'"=="" & "`grvar'"!="" {
					di as txt "{p 0 6 2}note: " ////
					 "suboption {bf:group(`grvar')} is " ///
					 "implied in option " ///
					 "{bf:rescorrelation()}{p_end}"
				     local rescoropt `rescoropt' group(`grvar')
				}
				else if "`grvar'" == "" {
					local what rescorrelation(`rescor')
				}
			}
			if "`rescor'"=="banded" & "`rescov'"=="" {
				if "`cgrvar'"=="" & "`grvar'"!="" {
					di as txt "{p 0 6 2}note: " ////
					 "suboption {bf:group(`grvar')} is " ///
					 "implied in option " ///
					 "{bf:rescorrelation()}{p_end}"
				     local rescoropt `rescoropt' group(`grvar')
				}
				else if "`grvar'" == "" {
					local what rescorrelation(`rescor')
				}
			}
			if "`resvar'"=="distinct" & "`rescov'"=="" {
				if "`vgrvar'"=="" & "`grvar'"!="" {
					di as txt "{p 0 6 2}note: " ////
					 "suboption {bf:group(`grvar')} is " ///
					 "implied in option " ///
					 "{bf:resvariance()}{p_end}"
				     local resvaropt `resvaropt' group(`grvar')
				}
				else if "`grvar'" == "" {
					local what resvariance(`resvar')
				}
			}
		}
		if "`what'" != "" {
			di as err "{p}invalid {bf:`what'} specification; " ///
			 "suboption {bf:group()} is required when there "  ///
			 "are no random effects{p_end}"
			exit 198
		}
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
		path(`path') `tsop'

	if `tsset' {
		local tspanels `tspanelvar'
	}
	else {	
		local tspanels `panels'
	}
	menl_validate_byvars `sorder' `tspanels', touse(`touse1')  ///
		cbyvar(`cbyvar') vbyvar(`vbyvar') rescov(`rescov') ///
		rescor(`rescor') resvar(`resvar') touse2(`touse2')

	if "`notsshow'" == "" {
		if `tsset' {
			di
			tsset
		}
		else if "`tsvar'" != "" {
			di
			if `kpath' <= 1 {
				tsset, tsvarlabel("<`tsvar'>")
			}
			else {
				tsset, tsvarlabel("<`tsvar'>") ///
					panellabel("<`path'>")
			}
		}
	}

	tempname b V ll
	mata: _menl_get_parameters(`EXPR',"`b'")
	_make_constraints, b(`b')
	if (e(ncns)) {
		tempname Cm T a
		mat `Cm' = e(Cm)
		mat `T' = e(T)
		mat `a' = e(a)
	}
	/* save the original stripe without any system generated 
	 * operators such as the omit, o.; used in postestimation	*/
	local bstripe : colfullnames `b'
	if `debug' {
		mat li `b'
	}
	local k = colsof(`b')
	if `N' <= `k' {
		di as err "{p}insufficient data: you have `N' observations " ///
		 "to estimate `k' parameters{p_end}"
		exit 2001
	}
	if "`from'" != "" {
		local initial `"`from'"'
	}
	ParseInitial `b' : `initial'
	local init_opts `"`s(opts)' `init_opts' `ltype' debug `debug'"'
	local init_fixed `s(fixed)'
	local est_initial = `s(est_initial)'

	if `s(set_parameters)' {
		mata: _menl_set_parameters(`EXPR',"`b'")
		if `rc' {
			di as err "{p}invalid {bf:initial()} " ///
			 "specification: `errmsg'{p_end}"
			exit `rc'
		}
	}
	/* test equation						*/
	local trace = ("`subexprtrace'" != "")
	mata: _menl_test_evaluate(`EXPR')
	if `rc' {
		di as err "{p}`errmsg'{p_end}"
		if "`message'" != "" {
			di as err "{p 4 4 2}`message'{p_end}" 
			di as err "{p 4 4 2}See " /// 
			 "{help menl##syntax:Syntax} or " ///
			 "`ME_SUBEXPR_LINK'.{p_end}"
		}
		else if !`trace' {
			di as err "{p 4 4 2}Try specifying the " ///
			 "{bf:subexprtrace} option to see the " ///
			 "substitutable expression execution trace{p_end}"
		}
	}
	if `trace' {
		local trace = 1
		mata: _menl_test_evaluate(`EXPR',`trace')
	}
	if `rc' {
		exit `rc'
	}
	local hasnull = 0
	if "`lrtest'" != "" {
		tempvar tu_null 
		local tu1_null
		if "`tsmissing'" != "" {
			tempvar tu2_null
		}
		if "`nolog'"=="" & "`lrnullshow'"!="" {
			di as txt _n "Composing null model:"
		}
		mata: _menl_full2null_model(`EXPR',`ENULL',("`tu_null'", ///
			"tu1_null"))
		if `rc' {
			di as err "{p}`errmsg'{p_end}"
			exit `rc'
		}
		local hasnull = r(hasnull)
		if !`hasnull' {
			di as txt _n "note: null model does not exist; " ///
			 "likelihood ratio test will not be computed"
		}
	}
	if `est_initial' {
		if "`nolog'" == "" {
			di
		}
		mata: _menl_initial_est(`EXPR',"`Cm' `T' `a'", ///
			("`init_fixed'"!=""),`"`init_opts'"',  ///
			("`nolog'"==""),"`touse2'")
	}
	tempname ll0 rank0
	scalar `ll0' = .
	scalar `rank0' = .

	if `hasnull' {
		/* has random variables or residual structure		*/
		if "`nolog'"=="" & "`lrnullshow'"!="" {
			di as txt _n "Computing null model:"
			if r(dispnull) {
				/* display only if there are random
				 *  variables				*/
				mata: _menl_display_model(`ENULL')
			}
		}
		if "`tu1_null'" != "" {
			local tu0_null `tu1_null'
		}
		else {
			local tu0_null `tu_null'
		}
		mata: _menl_null_model_setup(`EXPR',`ENULL',	///
			("`tu0_null'","`tu2_null'"))

		local gopts `pnlsopts0' iterate 100 nolog
		local mopts0 `mopts' nostderr nolog 
		cap mata: _menl_gnls(`ENULL',"`Cm' `T' `a'",`"`mopts0'"', ///
			`"`lmeopts0'"',`"`gopts'"',"`tu2_null'")
		if c(rc) == 1400 {
			di as txt _n "note: null-model initial " ///
			 "values not feasible; likelihood ratio " ///
			 "test will not be computed"
		}
		else if c(rc) {
			di as txt _n "note: null model failed; " ///
			 "likelihood ratio test will not be computed"
		}
		else if r(converged) {
			scalar `ll0' = r(ll)
			/* add one for sigma^2: rank is only for fixed
			 *  effects because of -nostderr- option	*/
			scalar `rank0' = r(rank) + 1
		}
		else {
			di as txt _n "note: null model did not " ///
			 "converge; likelihood ratio test will not " ///
			 "be computed"
		}
	}
	if "`nolog'" == "" {
		di
	}
	if "`method'" == "lbates" {
		mata: _menl_lbates(`EXPR',"`Cm' `T' `a'",`"`mopts'"', ///
			`"`lmeopts0'"',`"`pnlsopts0'"',"`touse2'")

		tempname rdif_cov rdif_b

		scalar `rdif_cov' = r(reldif_cov)
		scalar `rdif_b' = r(reldif_FE)
	}
	else if "`method'" == "gnls" {
		mata: _menl_gnls(`EXPR',"`Cm' `T' `a'",`"`mopts'"', ///
			`"`lmeopts0'"',`"`pnlsopts0'"',"`touse2'")
	}
	else {
		/* unreachable 						*/
		di as err "method {bf:`method'} not implemented"
		exit 198
	}

	tempname b_var V_var b_sd V_sd trans_var trans_sd V_model
	mat `b' = r(b)
	local stripe: colfullnames `b'
	mat `V' = r(V)
	mat `V_model' = r(V)
	scalar `ll' = r(ll)
	local converged = r(converged)
	local rank = r(rank)
	mat `b_var' = r(b_var)
	mat `V_var' = r(V_var)
	mat `trans_var' = r(trans_var)
	mat `b_sd' = r(b_sd)
	mat `V_sd' = r(V_sd)
	mat `trans_sd' = r(trans_sd)
	/* # missings generated in the function evaluation		*/
	local fmissing = r(missing)

	if "`tsmissing'" != "" {
		qui count if `touse2'
		local N_nonmiss = r(N)
		local N_ic = r(N)	// for BIC AIC
	}
	else {
		local N_ic = `N'
	}
	/* full estimation sample ignoring TS operators			*/
	markout `touse' `varlist'
	tempvar touse0
	qui gen byte `touse0' = `touse'
	local k = colsof(`b')

	if "`nostderr'" == "" {
		local findomitted findomitted
	}
	/* sum(touse) >= N						*/
	ereturn post `b' `V' `Cm', esample(`touse0') obs(`N') buildfvinfo ///
		`findomitted'

	/* allow missing in the observed depvar; second estimation 
	 *  sample; used in PK models with sporadic measurements	*/
	if "`tsmissing'" != "" {
		ereturn local tsmissing tsmissing
		ereturn scalar N_nonmiss = `N_nonmiss'
		ereturn scalar N_miss = `N'-`N_nonmiss'
		/*                      123456789012345678901235	*/
		ereturn local key_N_ic "nonmissing obs"
	}
	ereturn scalar N_ic = `N_ic'

	/* save the original column stripe generated from the parser
	 * 	the -findomitted- option in -return post- will decorate
	 * 	e(b) with the o. operator; used in postestimation	*/
	ereturn hidden local bstripe `"`bstripe'"'

	/* post model information					*/
	mata: _menl_post(`EXPR')

	ereturn mat V_modelbased = `V_model'

	if "`tsmissing'" != "" {
		if `tsset' {
			UpdateHierstats `depvar', touse(`touse2') ///
				panels(`tspanelvar') order(`tstimevar')
		}
		else if "`tsvar'" != "" {
			UpdateHierstats `depvar', touse(`touse2') ///
				panels(`panels') order(`tstimevar')
		}
		else {
			UpdateHierstats `depvar', touse(`touse2') ///
				panels(`panels') order(`corder')
		}
	}
	WaldTest
	if (r(df)) {
		ereturn scalar chi2 = r(chi2)
		ereturn scalar p = r(p)
		ereturn local chi2type Wald
	}
	ereturn scalar df_m = r(df)
	ereturn scalar k = `k'
	ereturn scalar rc = 0		// return code, must be zero or
					//  we would not be here
	ereturn hidden scalar fmissing = `fmissing'
	if "`rescor'" != "identity" {
		local rstructure `resvar' `rescor'
	}
	else {
		local rstructure `resvar'
	}
	ereturn hidden local resvar `resvar'
	ereturn hidden local rescorr `rescor'

	if "`rescov'" != "" {
		if "`rescov'"=="ar" | "`rescov'"=="ma" {
			local rstructlab = strupper("`rescov'")
			local rstructlab "`rstructlab'(`corder')"
		}
		else if "`rescov'" == "ctar1" {
			local rstructlab = strupper("`rescov'")
		}
		else if "`rescov'"=="banded" | "`rescov'"=="toeplitz" {
			local rstructlab = proper("`rescov'")
			local rstructlab "`rstructlab'(`corder')"
		}
		else { // if "`rescov'" != "identity" {
			local rstructlab = proper("`rescov'")
		}
	}
	else {
		if "`resvar'" != "identity" {
			local rstructlab = proper("`resvar'")
			local dash -
			ereturn hidden local varlab `rstructlab'
			if "`resvar'"==="power" | ///
				"`resvar'"=="exponential" | ///
				"`resvar'"=="linear" {
				local varvar : word 1 of `varopt'
				ereturn hidden local resvarvar `varvar'
			}
		}
		if "`rescor'"=="ar" | "`rescor'"=="ma" {
			local op = strupper("`rescor'")
			local rstructlab "`rstructlab'`dash'`op'(`corder')"
			ereturn hidden local corlab `op'(`corder')
		}
		else if "`rescor'" == "ctar1" {
			local op = strupper("`rescor'")
			local rstructlab "`rstructlab'`dash'`op'"
			ereturn hidden local corlab `op'
		}
		else if "`rescor'"=="banded" | "`rescor'"=="toeplitz" {
			local op = proper("`rescor'")
			local rstructlab "`rstructlab'`dash'`op'(`corder')"
			ereturn hidden local corlab `op'(`corder')
		}
		else if "`rescor'" != "identity" {
			local op = proper("`rescor'")
			local rstructlab `"`rstructlab'`dash'`op'"'
			ereturn hidden local corlab `op'
		}
	}
	if "`ctvar'" != "" {
		ereturn local timevar `ctvar'
		if "`corder'" != "" {
			ereturn hidden scalar corder = `corder'
		}
	}
	if "`tsvar'" != "" { 
		ereturn local tsorder `tsvar'
	}
	if `tsset' {
		ereturn hidden local tstimevar `tstimevar'
		if "`tspanelvar'" != "" {
			ereturn hidden local tspanelvar `tspanelvar'
		}
	}
	if "`vivar'" != "" {
		ereturn local indexvar `vivar'
		ereturn hidden scalar vorder = `vorder'
	}
	if "`civar'" != "" {
		ereturn local indexvar `civar'		// same as vivar
		ereturn hidden scalar corder = `corder'
	}
	if "`cbyvar'" != "" {
		ereturn local corrbyvar `cbyvar'
	}
	if "`vbyvar'" != "" {
		if "`resvar'"=="power" | "`resvar'"=="exponential" {
			ereturn local stratavar `vbyvar'
		}
		else {
			ereturn local covbyvar `vbyvar'
		}
	}
	if "`grvar'" != "" {
		ereturn local groupvar `grvar'
	}
	ereturn hidden local vstderr `vstderr'
	ereturn local rstructlab `rstructlab'
	ereturn hidden local rstructure `rstructure'
	if "`rescovopt'" != "" {
		ereturn local rescovopt "`rescovopt'"
		if "`e(stratavals)'" != "" {
			tempname byvals

			mat `byvals' = e(stratavals)
			mat colnames `byvals' = by count

			ereturn hidden matrix byvals = `byvals'
		}
		/* remove hidden e(stratavals) since it equals e(byvals)
		 * and strata is not in rescovarance() syntax		*/
		ereturn local stratavals
	}
	else {
		ereturn local resvaropt "`resvaropt'"
		ereturn local rescorropt "`rescoropt'"
	}
	if "`method'" == "lbates" {
		if "`ltype'" == "reml" {
			local crittype "linear. log restricted-likelihood"
		}
		else {
			local crittype "linearization log likelihood"
		}
		ereturn local crittype "`crittype'"
		ereturn hidden scalar reldif_cov = `rdif_cov'
		ereturn hidden scalar reldif_FE = `rdif_b'
	}
	else if "`method'" == "gnls" {
		if "`ltype'" == "reml" {
			ereturn local crittype "log restricted-likelihood"
		}
		else {
			ereturn local crittype "log likelihood"
		}
	}
	ereturn local method = strupper("`ltype'")
	ereturn local vce conventional
	ereturn matrix b_var = `b_var'
	ereturn matrix V_var = `V_var'
	/* CI transformations						*/
	ereturn hidden matrix trans_var = `trans_var'
	ereturn matrix b_sd = `b_sd'
	ereturn matrix V_sd = `V_sd'
	ereturn hidden matrix trans_sd = `trans_sd'

	ereturn local marginsok "default yhat param parameter parameters"
	ereturn local marginsnotok "reffects residuals resid residual rstandard"
	ereturn local marginsdefault "predict(yhat fixedonly)"
	/* noeb instructs -margins- not to rely on e(b) for covariate names
	 * minus instructs -margins- to exclude omitted covariates	*/
	ereturn hidden local marginsprop noeb minus

	qui fvset report, design(asbalanced)
	local vlist `r(varlist)'
	if "`vlist'" != "" {
		local vlist : list vlist & varlist
		ereturn local asbalanced "`vlist'"
	}
	qui fvset report, design(asobserved)
	local vlist `r(varlist)'
	if "`vlist'" != "" {
		local vlist : list vlist & varlist
		ereturn local asobserved "`vlist'"
	}
	ereturn hidden local hvarlist `path'
	ereturn scalar rank = `rank'
	ereturn scalar converged = `converged'
	ereturn local opt "`method'"
	ereturn scalar ll = `ll'
	if !missing(`ll0') {
		ereturn scalar ll_c = `ll0'
		if "`nostderr'" != "" {
			/* rank only includes fixed effects from PNLS
			 *  assume RE and resid structure is full rank	*/
			ereturn scalar df_c = `rank'+e(k_r)+e(k_res)- ///
						`rank0'-1
		}
		else {
			ereturn scalar df_c = `rank'-`rank0'
		}
		ereturn scalar chi2_c = 2*(`ll'-`ll0')
		ereturn scalar p_c = chi2tail(e(df_c),e(chi2_c))
		if e(df_c)==1 & e(chi2_c)>1e-5 {
			/* copied from _xtmixed_estimate		*/
			ereturn scalar p_c = 0.5*e(p_c)
		}
	}
	ereturn local predict menl_p
	ereturn local estat_cmd menl_estat
	if "`ltype'" == "reml" {
		ereturn local title "Mixed-effects REML nonlinear regression"
	}
	else {
		ereturn local title "Mixed-effects ML nonlinear regression"
	}
	ereturn local cmd "menl"
	ereturn hidden scalar mecmd = 0

	Display, `diopts'
end

program define Display, rclass
	syntax, [ * ]

	ParseDisplayOpts, `options'
	local options `"`s(options)'"'
	if `"`options'"' != "" {
		/* throw error with first bad option			*/
		gettoken opt options: options, bind
		di as err "{p}option {bf:`opt'} not allowed{p_end}"
		exit 198
	}
	local diopts `"`s(diopts)'"'
	local nogroup `s(nogroup)'
	local grouponly `s(grouponly)'
	local level "`s(level)'"
	local vars `s(variance)'
	local stddev `s(stddeviations)'
	local estmetric `s(estmetric)'
	local noheader `s(noheader)'
	local nofetable `s(nofetable)'
	local noretable `s(noretable)'
	local noci `s(noci)'
	local cformat `s(cformat)'
	local coeflegend `s(coeflegend)'
	local nolegend `s(nolegend)'
	local lrtest `s(lrtest)'

	local crtype `e(crittype)'
	if "`e(opt)'" == "lbates" {
		gettoken linear crtype : crtype 
		local linear = proper("`linear'")
		local linear : list retokenize linear
		local crtype : list retokenize crtype
		local crtype "{help j_menl_linearll:`linear'} `crtype'"
	}
	else {
		local first : word 1 of `crtype'
		local crtype : list crtype - first
		local first = proper("`first'")
		local crtype "`first' `crtype'"
	}
	if "`estmetric'" != "" {
		if "`nofetable'"!="" & "`stddev'"!="" {
			di as err "{p}option {bf:estmetric} is not allowed" ///
			" with options {bf:nofetable} and "                 ///
			"{bf:stddeviations}{p_end}"
			exit(198)
		}
	}

	if "`noheader'" == "" {
		if "`grouponly'" != "" {
			DiGroupTable, table
			exit
		}
		/* hand rolled	_coef_table_header, `diopts'		*/
		di as txt _n "`e(title)'" _c
		if "`e(tsmissing)'" == "tsmissing" {
			/* two estimation sample model			*/
			di _col(53) as txt "Number of obs" _col(67) "=" ///
			 _col(69) as res %10.0fc e(N)
			di _col(56) as txt "Nonmissing" _col(67) "=" ///
			 _col(69) as res %10.0fc e(N_nonmiss)
			di _col(59) as txt "Missing" _col(67) "=" ///
			 _col(69) as res %10.0fc e(N_miss)
		}
		else {
			di _col(49) as txt "Number of obs" _col(67) "=" ///
			 _col(69) as res %10.0fc e(N)
		}

		if "`nogroup'" == "" {
			DiGroupTable
		}
		if "`e(chi2type)'" != "" {
        		di _n _col(49) as txt "`e(chi2type)' chi2(" 	 ///
			 as res e(df_m) as txt ")" _col(67) "=" _col(70) ///
			 as res %9.2f e(chi2)

			local cc _c
		}
		else {
			di
		}
		di as txt "`crtype'" " = " as res %10.0g e(ll) `cc'
		if "`e(chi2type)'" != "" {
			di _col(49) as txt _col(49) "Prob > chi2" _col(67) ///
			 "=" _col(73) as res %6.4f chiprob(e(df_m), e(chi2))
		}
		if "`nolegend'" == "" {
			DisplayExprs
        	}
	}
	else {
		di
	}
	local kfeq = e(k_feq)
	if "`estmetric'" == "" {
		local neqopt neq(`kfeq')
	}
	if `kfeq' & "`nofetable'" == "" {
		local k1 : list posof "cnsreport" in diopts
		local k2 : list posof "fullcnsreport" in diopts
		if !`k1' & !`k2' {
			local dio nocnsreport
			local diopts : list diopts - dio
			_coef_table, `diopts' `neqopt' cmdextras nocnsreport
		}
		else {
			_coef_table, `diopts' `neqopt' cmdextras
		}
		return add
	}
	if "`noretable'" == "" {
		if "`nofetable'" == "" {
			di
		}
		DiVarComp, `level' `stddev' `noci' cformat(`cformat') ///
			   `coeflegend'
		return add
		if !missing(e(ll_c)) {
			if (e(chi2_c)>0.005 & e(chi2_c)<1e5) | e(chi2_c)==0 {
				local chi2 : di %8.2f e(chi2_c)
			}
			else {
				local chi2 : di %8.2e e(chi2_c)
			}
			local chi2 = trim("`chi2'")
			di as txt "LR test vs. nonlinear model: " _c
			if `e(df_c)' == 1 { 
				di "{help j_chibar##|_new:chibar2(01) =} " _c
				local lchi2 ">= chibar2"
			}
			else {
				di "chi2("as res e(df_c) ") = " _c
				local lchi2 "> chi2"
			}
			di as res "`chi2'" _col(55) as txt "Prob `lchi2' " ///
			 "= " _col(73) as res %6.4f e(p_c)
			if "`e(revars)'" == "" {
				local help "{help j_mixedlr##|_new:"
				local help "`help'conservative}"
				di as txt _n "{p 0 6 2}Note: The reported " ///
				 "degrees of freedom assumes the null " ///
				 "hypothesis is not on the boundary of the " ///
				 "parameter space.  If this is not true, " ///
				 "then the reported test is `help'.{p_end}"
			}
			else if `e(k_rs)' > 1 {
				local help "{help j_mixedlr##|_new:LR test "
				local help "`help'is conservative}"
				di as txt _n "{p 0 6 4}Note: `help' and " ///
 				 "provided only for reference.{p_end}"
			}
		}
	}
	ml_footnote
	local tsexpr `e(ts_expr)'
	local depvar `e(depvar)'
	local expr : list tsexpr & depvar
	if "`expr'" != "" {
		local expr "{bf:L.{c 123}`depvar':{c 125}}"
		di as txt "{p 0 7 2}Note: Lagged predicted mean function " ///
		 "`expr' is used in the model.{p_end}"
	}
	local tsexpr : list tsexpr - depvar
	local k : word count `tsexpr'
	if `k' {
		forvalues i = 1/`k' {
			local expi : word `i' of `tsexpr'
			local exprs "`exprs'`c'{bf:L.{c 123}`expi':{c 125}}"
			if `i' == `=`k'-1' {
				local c " and "
			}
			else {
				local c ", "
			}
		}
		local expr = plural(`k',"expression")
		local is = plural(`k',"is","are")
		di as txt "{p 0 7 2}Note: Lagged named `expr' `exprs' " ///
		 "`is' used in the model.{p_end}"
	}
	if e(fmissing) {
		local values = plural(e(fmissing),"value")
		di as txt "{p 0 9 2}Warning: Function evaluation resulted " ///
		 "in " as res `e(fmissing)' as txt " missing `values' " ///
		 "at the last iteration.{p_end}"
	}
end

program define DiTable1
	syntax, paths(string) group(name) hstats(name)

	/* statistic columns						*/
	local Ng = 1
	local avg = 2
	local min = 3
	local max = 4
//         1         2         3         4         5         6         7
//1234567890123456789012345678901234567890123456789012345678901234567890
//                     |     No. of       Observations per Group
//                Path |     Groups    Minimum    Average    Maximum
//           variable2 |   ########  #########  #########  #########
// variable2>variable1 |   ########  #########  #########  #########
	
	di as txt "{hline 21}{c TT}{hline 44}
	di as txt _col(22) "{c |}" _col(28) "No. of" ///
          _col(42) "Observations per Group"
	di as txt _col(17) "Path" _col(22) "{c |}" ///
	  _col(28) "Groups" _col(38) "Minimum" ///
	  _col(49) "Average" _col(60) "Maximum" 
	di as txt "{hline 21}{c +}{hline 44}"
	local i = 0
	while "`paths'" != "" {
		gettoken path paths : paths, bind
		local rnames `rnames' `path'
		local path = abbrev("`path'",20)
		local p = 21 - length("`path'")
		di as res _col(`p') "`path'" /// 
		  as txt _col(22) "{c |}" ///
		  as res _col(26) %8.0fc `hstats'[`++i',`Ng'] ///
                         _col(36) %9.0fc `hstats'[`i',`min'] ///
                         _col(47) %9.1fc `hstats'[`i',`avg'] ///
                         _col(58) %9.0fc `hstats'[`i',`max'] 
		mat `group'[`i',1] = `hstats'[`i',`Ng']
		mat `group'[`i',2] = `hstats'[`i',`min']
		mat `group'[`i',3] = `hstats'[`i',`avg']
		mat `group'[`i',4] = `hstats'[`i',`max']
	}
	di as txt "{hline 21}{c BT}{hline 44}" _n 
end

program define DiTable2
	syntax, paths(string) group(name) hstats(name)

	/* statistic columns						*/
	local Ng = 1
	local avg = 2
	local min = 3
	local max = 4
//         1         2         3         4         5         6         7
//1234567890123456789012345678901234567890123456789012345678901234567890123456789
//                                 |     No. of       Observations per Group
//                            Path |     Groups    Minimum    Average    Maximum
//                       variable2 |   ########  #########  #########  #########
//             variable2>variable1 |   ########  #########  #########  #########
	
	di as txt "{hline 33}{c TT}{hline 44}
	di as txt _col(34) "{c |}" _col(40) "No. of" ///
          _col(53) "Observations per Group"
	di as txt _col(29) "Path" _col(34) "{c |}" ///
	  _col(40) "Groups" _col(50) "Minimum" ///
	  _col(61) "Average" _col(72) "Maximum" 
	di as txt "{hline 33}{c +}{hline 44}"
	local i = 0
	while "`paths'" != "" {
		gettoken path paths : paths, bind
		local path = abbrev("`path'",32)
		local p = 33 - length("`path'")
		di as res _col(`p') "`path'" /// 
		  as txt _col(34) "{c |}" ///
		  as res _col(38) %8.0fc `hstats'[`++i',`Ng'] ///
                         _col(48) %9.0fc `hstats'[`i',`min'] ///
                         _col(59) %9.1fc `hstats'[`i',`avg'] ///
                         _col(70) %9.0fc `hstats'[`i',`max'] 
		mat `group'[`i',1] = `hstats'[`i',`Ng']
		mat `group'[`i',2] = `hstats'[`i',`min']
		mat `group'[`i',3] = `hstats'[`i',`avg']
		mat `group'[`i',4] = `hstats'[`i',`max']
	}
	di as txt "{hline 33}{c BT}{hline 44}" _n 
end

/* copied from _xtmixed_display.ado					*/
program DiGroupTable, rclass
	syntax [, table ]

	tempname hstats

	cap confirm matrix e(hierstats)
	if c(rc) {
		/* no hierarchy						*/
		exit
	}
	mat `hstats' = e(hierstats)
	local klev = rowsof(`hstats')
	local paths : rownames(`hstats')
	/* statistic columns						*/
	local Ng = 1
	local avg = 2
	local min = 3
	local max = 4

	if `klev' == 1 & "`table'" == "" {
		di as txt "Group variable: " as res abbrev("`paths'",14) ///
		  _col(49) as txt "Number of groups" _col(67) "=" ///
		  _col(69) as res %10.0fc `hstats'[1,`Ng'] _n
		di as txt _col(49) "Obs per group:"
		di as txt _col(63) "min" _col(67) "=" ///
		  _col(69) as res %10.0fc `hstats'[1,`min']
		di as txt _col(63) "avg" _col(67) "=" ///
		  _col(69) as res %10.1fc `hstats'[1,`avg']
		di as txt _col(63) "max" _col(67) "=" ///
		  _col(69) as res %10.0fc `hstats'[1,`max']
	}
	else {
		local paths0 `paths'
		local mxpath = 0
		local paths
		while "`paths0'" != "" {
			gettoken path paths0 : paths0, bind
			if "`e(tsmissing)'" != "" {
				if "`table'"!="" & "`path'"=="`e(depvar)'" {
					continue
				}
			}
			local k = ustrlen("`path'")
			if `k' > `mxpath' {
				local mxpath = `k'
			}
			local paths `"`paths'`c'`path'"'
			local c " "
		}
		tempname group
		mat `group' = J(`klev',4,0)
		di
		if `mxpath' <= 20 {
			DiTable1, paths(`paths') group(`group') hstats(`hstats')
		}
		else {
			DiTable2, paths(`paths') group(`group') hstats(`hstats')
		}
		mat colnames `group' = "# Groups" Minimum Average Maximum
		mat rownames `group' = `paths'

		return hidden matrix group `group'
	}
end

program define DisplayExprs

	local expr `e(expressions)'
	if "`expr'" == "" {
		exit
	}
        local p : word count `expr'
	tokenize `expr'
	di
	forvalues i=1/`p' {
        	local exp `e(expr_``i'')'
		if "`exp'" == "" {
			/* not worth display				*/
			continue
		}
		local name = abbrev("``i''", 12)
		local k = udstrlen("`name'")
		local pos  = 12 - `k'
		local pos1 = 15
		local k1 = udstrlen(`"`exp'"')
		local n = c(linesize)
		local m = `n' - `pos1' - 2
		local m1 = `m'+1
		local par "{p `pos' `pos1' 2}"
        	di "`par'" as txt "`name':  " _c
		local par
		while `k1' {
			local expi = usubstr(`"`exp'"',1,`m')
	              	di as res `"`par'`expi'{p_end}"'
			if `m1' > `k1' {
				local k1 = 0
				continue, break
			}
			local exp = usubstr(`"`exp'"',`m1',`k1')
			local k1 = udstrlen(`"`exp'"')
			local par "{p `pos1' `pos1' 2}"
		}
	}
	di
end

/* copied from _xtmixed_display.ado					*/
program DiVarComp, rclass
	syntax [, level(cilevel) stddeviations cformat(string) NOCI COEFLegend]

	local kreq = e(k_req)
	/* header							*/
	if "`cformat'" != "" {
		local cf `cformat'
	}
	else {
		local cf "%9.0g"
	}
	if "`noci'" == "" {
		local ll 48
	}
	else {
		local ll 25
	}
	di as txt "{hline 29}{c TT}{hline `ll'}

	local vcetype `e(vcetype)'
	if "`vcetype'" == "Robust" {
		di as txt _col(30) "{c |}" _col(46) "`vcetype'"
	}
	local k = length("`level'")
	if ("`coeflegend'"=="") {
		di as txt _col(3) "Random-effects Parameters" _col(30) ///
		 "{c |}" _col(34) "Estimate" _col(45) "Std. Err." _c
		if "`noci'" == "" {
			di _col(`=61-`k'') ///
			 `"[`=strsubdp("`level'")'% Conf. Interval]"'
		}
		else {
			di
		}
	}
	else {
		di as txt _col(3) "Random-effects Parameters" _col(30) ///
		 "{c |}" _col(34) "Estimate" _col(45) "Legend"
	}
	di as txt "{hline 29}{c +}{hline `ll'}

	tempname b V bi Vi z table trans transi
	scalar `z' = invnormal(1-(1-`level'/100)/2)

	if "`stddeviations'" != "" {
		mat `b' = e(b_sd)
		mat `V' = e(V_sd)
		mat `trans' = e(trans_sd)
	}
	else {
		mat `b' = e(b_var)
		mat `V' = e(V_var)
		mat `trans' = e(trans_var)
	}
	local kb = colsof(`b')
	local veqlist : coleq `b'
	local veqs : list uniq veqlist
	local kveq : list sizeof veqs

	menl_parse_ehierarchy, covstructures
	local kvstruct = `s(kcovstruct)'
	forvalues i=1/`kvstruct' {
		local path`i' `s(path`i')'
		local lvs`i' `s(lvs`i')'
		local klv`i' = `s(klv`i')'
		local vstruct`i' `s(covstruct`i')'
	}
	
	local i2 = 0
	local rt = 0	// table row
	local ires = 0
	forvalues i=1/`kvstruct' {
		local l = strlen("`vstruct`i''")-1
		local vartype = strupper(substr("`vstruct`i''",1,1)) + ///
				substr("`vstruct`i''",2,`l')
		di as res abbrev("`path`i''",12) as txt ": `vartype'" ///
				_col(30) "{c |}"

		if ("`coeflegend'"!="") {
			local leglabel /`path`i'':
		}

		CovIndexRange, path(`path`i'') lvs(`lvs`i'') adjust
		local i1 = `s(i1)'
		local i2 = `s(i2)'

		mat `bi' = `b'[1,`i1'..`i2']
		mat `Vi' = `V'[`i1'..`i2',`i1'..`i2']
		mat `transi' = `trans'[1,`i1'..`i2']

		Di`vartype'Var, lvars(`lvs`i'') b(`bi') v(`Vi') z(`z') ///
			table(`table') stripe(`stripe') rt(`rt')       ///
			`stddeviations' cf(`cf') trans(`transi') `noci' ///
			coeflegend(`leglabel')
		local stripe `"`r(stripe)'"'
		local rt = `r(rt)'

		local l = ustrlen("`veq'")-1
		local veq = usubstr("`veq'",2,`l')
		di as txt "{hline 29}{c +}{hline `ll'}
	}
	CovIndexRange, path(Residual) lvs(_all) adjust
	local i1 = `s(i1)'
	local i2 = `s(i2)'
	mat `bi' = `b'[1,`i1'..`i2']
	mat `Vi' = `V'[`i1'..`i2',`i1'..`i2']
	mat `transi' = `trans'[1,`i1'..`i2']
	if "`e(rescovopt)'" != "" {
		DiResidualCov, b(`bi') v(`Vi') z(`z') table(`table') ///
			stripe(`stripe') rt(`rt') cf(`cf') `stddeviations' ///
			trans(`transi') `noci' `coeflegend'
	}
	else {
		DiResidualVarCorr, b(`bi') v(`Vi') z(`z') table(`table') ///
			stripe(`stripe') rt(`rt') cf(`cf') `stddeviations' ///
			trans(`transi') `noci' `coeflegend'
	}
	local stripe `"`r(stripe)'"'
	local rt = `r(rt)'

	di as txt "{hline 29}{c BT}{hline `ll'}

	mat rownames `table' = `stripe'
	mat colnames `table' = Estimate Std.Err. LB`level' UB`level'

	return mat retable = `table'
	return scalar level = `level'
end

program define CovIndexRange, sclass
	syntax, lvs(string) [ path(string) adjust ]

	tempname ix ii jj

	mat `ix' = e(bindex)
	cap mat `ii' = `ix'["`path':`lvs'",1...]
	local rc = c(rc)
	if `rc' {
		sreturn local i1 = 0
		sreturn local i2 = 0
		exit
	}
	if "`adjust'" != "" {
		local j = `ix'[1,2]	// end of fixed effects
	}
	else {
		local j = 0
	}
	local i1 = `ii'[1,1] - `j'
	local i2 = `ii'[1,2] - `j'

	sreturn local i1 = `i1'
	sreturn local i2 = `i2'
end

program define DiUnstructuredVar, rclass
	syntax, lvars(string) b(name) v(name) z(name) table(name)          ///
			rt(integer) trans(name) cf(string) [ stddeviations ///
			stripe(string) NOCI COEFLegend(string)]

	tempname bi si lb ub 
	local kvar : list sizeof lvars

	local k = 0
	forvalues j=1/`kvar' {
		local lj : word `j' of `lvars'
		scalar `bi' = `b'[1,`++k']
		scalar `si' = `v'[`k',`k']
		scalar `si' = sqrt(`si')
		if "`stddeviations'" != "" {
			local label sd(`lj')
		}
		else {
			local label var(`lj')
		}
		if ("`coeflegend'"!="") {
			local leglabel `coeflegend'`label'
		}
		local tr = `trans'[1,`k']
		ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
		local `++rt'
		mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))
		local stripe `"`stripe' `label'"'

		DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
			label(`label') cf(`cf') `noci' coeflegend(`leglabel')
	}
	forvalues j=1/`kvar' {
		local lj : word `j' of `lvars'
		local j1 = `j' + 1
		forvalues i=`j1'/`kvar' {
			local li : word `i' of `lvars'
			scalar `bi' = `b'[1,`++k']
			scalar `si' = `v'[`k',`k']
			scalar `si' = sqrt(`si')
			if "`stddeviations'" != "" {
				local label corr(`lj',`li')
			}
			else {
				local label cov(`lj',`li')
			}
			if ("`coeflegend'"!="") {
				local leglabel `coeflegend'`label'
			}
			local tr = `trans'[1,`k']
			ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') ///
				trans(`tr')
			local `++rt'
			mat `table' = (`table'\(`bi',`si',`lb',`ub'))
			local stripe `"`stripe' `label'"'

			DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
				label(`label') cf(`cf') `noci'           ///
				coeflegend(`leglabel')
		}
	}
	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiExchangeableVar, rclass
	syntax, lvars(string) b(name) v(name) z(name) table(name)          ///
			rt(integer) trans(name) cf(string) [ stddeviations ///
			stripe(string) NOCI COEFLegend(string)]

	tempname bi si lb ub 

	/* single variance and covariance				*/
	local kvar : list sizeof lvars
	scalar `bi' = `b'[1,1]
	scalar `si' = `v'[1,1]
	scalar `si' = sqrt(`si')
	if "`stddeviations'" != "" {
		local label sd(`lvars')
	}
	else {
		local label var(`lvars')
	}
	if ("`coeflegend'"!="") {
		local leglabel `coeflegend'`label'
	}
	local tr = `trans'[1,1]
	ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
	local `++rt'
	mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))

	DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') label(`label') ///
		cf(`cf') `noci' coeflegend(`leglabel')

	if `kvar' > 1 {
		/* matrix stripe grammar: cannot have more than 2 comma
		 * delimited names					*/
		local label : subinstr local label " " "_", all
	}
	local stripe `"`stripe' `label'"'

	scalar `bi' = `b'[1,2]
	scalar `si' = `v'[2,2]
	scalar `si' = sqrt(`si')
	if `kvar' == 2 {
		local lvars : subinstr local lvars " " ",",all
	}
	if "`stddeviations'" != "" {
		local label corr(`lvars')
	}
	else {
		local label cov(`lvars')
	}
	if ("`coeflegend'"!="") {
		local leglabel `coeflegend'`label'
	}
	local tr = `trans'[1,2]
	ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
	local `++rt'
	mat `table' = (`table'\(`bi',`si',`lb',`ub'))

	DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') label(`label') ///
		cf(`cf') `noci' coeflegend(`leglabel')

	if `kvar' > 2 {
		/* matrix stripe grammar: cannot have more than 2 comma
		 * delimited names					*/
		local label : subinstr local label " " "_", all
	}
	local stripe `"`stripe' `label'"'

	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiIdentityVar, rclass
	syntax, lvars(string) b(name) v(name) z(name) table(name)          ///
			rt(integer) trans(name) cf(string) [ stddeviations ///
			stripe(string) NOCI COEFLegend(string) ]

	tempname bi si lb ub 
	local kvar : list sizeof lvars

	/* single variance and covariance				*/
	local kvar : list sizeof lvars
	scalar `bi' = `b'[1,1]
	scalar `si' = `v'[1,1]
	scalar `si' = sqrt(`si')
	if "`stddeviations'" != "" {
		local label sd(`lvars')
	}
	else {
		local label var(`lvars')
	}
	if ("`coeflegend'"!="") {
		local leglabel `coeflegend'`label'
	}
	local tr = `trans'[1,1]
	ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
	local `++rt'
	mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))

	DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') label(`label') ///
		cf(`cf') `noci' coeflegend(`leglabel')

	if `kvar' > 1 {
		/* matrix stripe grammar: cannot have more than 2 comma
		 * delimited names					*/
		local label : subinstr local label " " "_", all
	}
	local stripe `"`stripe' `label'"'

	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiIndependentVar, rclass
	syntax, lvars(string) b(name) v(name) z(name) table(name)          ///
			rt(integer) trans(name) cf(string) [ stddeviations ///
			stripe(string) NOCI COEFLegend(string)]

	tempname bi si lb ub 
	local kvar : list sizeof lvars

	/* single variance and covariance				*/
	local k = 0
	forvalues j=1/`kvar' {
		local lj : word `j' of `lvars'
		scalar `bi' = `b'[1,`++k']
		scalar `si' = `v'[`k',`k']
		scalar `si' = sqrt(`si')
		if "`stddeviations'" != "" {
			local label sd(`lj')
		}
		else {
			local label var(`lj')
		}
		if ("`coeflegend'"!="") {
			local leglabel `coeflegend'`label'
		}
		local tr = `trans'[1,`k']
		ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
		local `++rt'
		mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))
		local stripe `"`stripe' `label'"'

		DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
			label(`label') cf(`cf') `noci' coeflegend(`leglabel')
	}
	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiResidualCov, rclass 
	syntax, b(name) v(name) z(name) table(name) rt(integer) ///
			trans(name) cf(string) [ stddeviations  ///
			stripe(string) NOCI COEFLegend]

	tempname bv trv vv bc trc vc bi vi si lb ub byvals bym

	local bstr : colnames `b'
	local k = colsof(`b')
	local klev = 1
	local vstruct : word 1 of `e(rstructure)'
	if "`e(covbyvar)'"!="" | "`e(corrbyvar)'"!="" {
		if "`e(covbyvar)'" != "" {
			local byvar `e(covbyvar)'
		}
		else {
			local byvar `e(corrbyvar)'
		}
		mat `byvals' = e(byvals)	// hidden
		local klev = rowsof(`byvals')
		if "`e(rstructlab)'" != "" {
			di as txt "Residual: `e(rstructlab)'," _col(30) "{c |}"
			if "`e(timevar)'" != "" {
				di as txt _col(5) "time " as res abbrev( ///
				 "`e(timevar)'", 19) as txt _col(30) "{c |}"
			}
			di as txt _col(5) "by " as res abbrev( ///
			 "`e(covbyvar)'", 21) as txt _col(30) "{c |}"
		}
		else {
			di as txt "Residual: by " as res abbrev( ///
			 "`e(covbyvar)'", 16) as txt _col(30) "{c |}"
		}
	}
	else if "`e(rstructure)'" != "identity" {
		if "`e(timevar)'"!="" | "`e(indexvar)'"!="" {
			local comma ,
		}
		di as txt "Residual: `e(rstructlab)'`comma'" _col(30) "{c |}"
		if "`e(timevar)'" != "" {
			di as txt _col(5) "time " as res abbrev( ///
			 "`e(timevar)'", 19) as txt _col(30) "{c |}"
		}
		else if "`e(indexvar)'" != "" {
			di as txt _col(5) "index " as res abbrev( ///
			 "`e(indexvar)'", 18) as txt _col(30) "{c |}"
		}
	}
	CovIndexRange, path(Residual) lvs(_scale)
	local i0 = `s(i1)'	// base index
	CovIndexRange, path(Residual) lvs(_sd)
	local i1 = `s(i1)'
	local i2 = `s(i2)'
	local kv = 0
	CovIndexRange, path(Residual) lvs(_cor)
	local j1 = `s(i1)'
	local j2 = `s(i2)'
	local kc = 0
	if `i1' {
		local i1 = `i1'-`i0'+1
		if "`vstruct'"=="identity" & "`byvar'"!="" {
			/* variance for each by level			*/
			local `--i1'
		}
		else if "`vstruct'" == "distinct" {
			/* variance for each by level			*/
			/* includes unstructured covariance		*/
			local `--i1'
		}
		local i2 = `i2'-`i0'+1
		local kv = (`i2'-`i1'+1)/`klev'
		mat `bv' = `b'[1,`i1'..`i2']
		mat `vv' = `v'[`i1'..`i2',`i1'..`i2']
		mat `trv' = `trans'[1,`i1'..`i2']
		local bvstr : colnames `bv'
	}
	if `j1' {
		local j1 = `j1'-`i0'+1
		local j2 = `j2'-`i0'+1
		local kc = (`j2'-`j1'+1)/`klev'
		mat `bc' = `b'[1,`j1'..`j2']
		mat `vc' = `v'[`j1'..`j2',`j1'..`j2']
		mat `trc' = `trans'[1,`j1'..`j2']
		local bcstr : colnames `bc'
	}
	if !("`vstruct'"=="identity" & "`byvar'"!="") &	///
		"`vstruct'"!="distinct" {
		/* scale parameter					*/
		gettoken st bstr : bstr
		if `k' == 1 & "`e(rstructure)'" != "linear" {
			if ("`coeflegend'"!="") {
				if "`stddeviations'" != "" {
					local leglabel /Residual:sd
				}
				else {
					local leglabel /Residual:var
				}
			}
			else if "`stddeviations'" != "" {
				local st sd(Residual)
			}
			else {
				local st var(Residual)
			}
		}
		else {	
			if ("`coeflegend'"!="") {
				local leglabel /Residual:`st'
			}
		}
		scalar `bi' = `b'[1,1]
		scalar `vi' = `v'[1,1]
		scalar `vi' = sqrt(`vi')
		local tr = `trans'[1,1]
		ComputeCI, b(`bi') s(`vi') z(`z') lb(`lb') ub(`ub') trans(`tr')
		local `++rt'
		mat `table' = (nullmat(`table')\(`bi',`vi',`lb',`ub'))
		local stripe `"`stripe' `st'"'

		DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') label(`st') ///
			cf(`cf') `noci' coeflegend(`leglabel')
	}

	local i1 = 0
	local j1 = 0
	forvalues i=1/`klev' {
		forvalues j=1/`kv' {
			gettoken st bvstr : bvstr
			if ("`coeflegend'"!="") {
				local leglabel /Residual:`st'
			}
			scalar `bi' = `bv'[1,`++i1']
			scalar `si' = `vv'[`i1',`i1']
			scalar `si' = sqrt(`si')
			local tr = `trv'[1,`i1']
			ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') ///
				trans(`tr')
			local `++rt'
			mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))
			local stripe `"`stripe' `st'"'

			local dlab = ((`j'==1) & (`klev'>1))
			DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci' cby(`byvar') ///
				coeflegend(`leglabel') displab(`dlab')
		}
		forvalues j=1/`kc' {
			gettoken st bcstr : bcstr
			if ("`coeflegend'"!="") {
				local leglabel /Residual:`st'
			}
			scalar `bi' = `bc'[1,`++j1']
			scalar `si' = `vc'[`j1',`j1']
			scalar `si' = sqrt(`si')
			local tr = `trc'[1,`j1']
			ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') ///
				trans(`tr')
			local `++rt'
			mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))
			local stripe `"`stripe' `st'"'

			local dlab = ((`j'==1) & (`klev'>1) & !`kv')
			DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci' cby(`byvar') ///
				coeflegend(`leglabel') displab(`dlab')
		}
		if `=`kc'+`kv''>1 & `klev'>1 & `i'<`klev' {
			di as txt _col(30) "{c |}"
		}
	}
	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiResidualVarCorr, rclass
	syntax, b(name) v(name) z(name) table(name) rt(integer) ///
			trans(name) cf(string) [ stddeviations  ///
			stripe(string) NOCI COEFLegend]

	tempname bi vi tri lb ub bv bc vv vc

	local bstr : colnames `b'
	local k = colsof(`b')
	gettoken st bstr : bstr
	if `k' == 1 & "`e(rstructure)'" != "linear" {
		if "`stddeviations'" != "" {
			local st sd(Residual)
		}
		else {
			local st var(Residual)
		}
		if ("`coeflegend'"!="") {
			local leglabel /`st'
		}
	}
	else {
		if ("`coeflegend'"!="") {
			local leglabel /Residual:`st'
		}
	}

	CovIndexRange, path(Residual) lvs(_scale)
	local i0 = `s(i1)'	// base index
	scalar `bi' = `b'[1,1]
	scalar `vi' = `v'[1,1]
	scalar `vi' = sqrt(`vi')
	local tr = `trans'[1,1]
	ComputeCI, b(`bi') s(`vi') z(`z') lb(`lb') ub(`ub') trans(`tr')
	local `++rt'
	mat `table' = (nullmat(`table')\(`bi',`vi',`lb',`ub'))
	local stripe `"`stripe' `st'"'

	if "`e(varlab)'" != "" {
		if "`e(stratavar)'" != "" {
			local comma,
		}
		di as txt "Residual variance:" _col(30) "{c |}"
		if "`e(resvarvar)'" != "" {
			local l = 25-strlen("`e(varlab)'")
			di as txt _col(3) "`e(varlab)' " as res       ///
			 abbrev("`e(resvarvar)'",`l') as txt "`comma'" ///
			 _col(30) "{c |}"
		}
		else {
			di as txt _col(3) "`e(varlab)'`comma'" _col(30) "{c |}"
		}
		if "`e(resvar)'" == "distinct" {
			di as txt _col(5) "index " as res ///
			 abbrev("`e(indexvar)'",19) _col(30) "{c |}"
		}
		if "`e(stratavar)'" != "" {
			DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci'              ///
				coeflegend(`leglabel')

			di as txt _col(5) "strata " as res ///
			 abbrev("`e(stratavar)'",17) _col(30) "{c |}"
			local by stratavals
		}
		else if "`e(resvar)'" == "linear" {
			/* sigma only					*/
			DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci'              ///
				coeflegend(`leglabel')
		}
	}
	CovIndexRange, path(Residual) lvs(_sd)
	local i1 = `s(i1)'
	if `i1' {
		if "`e(stratavar)'" == "" {
			DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci' ///
				coeflegend(`leglabel')
		}
		if "`e(stratavar)'" != "" {
			local by stratavals
		}
		local i1 = `i1'-`i0'+1
		local i2 = `s(i2)'-`i0'+1
		mat `bi' = `b'[1,`i1'..`i2']
		mat `vi' = `v'[`i1'..`i2',`i1'..`i2']
		mat `tri' = `trans'[1,`i1'..`i2']
		DiResidualVar, b(`bi') v(`vi') z(`z') table(`table')  ///
			rt(`rt') trans(`tri') `stddeviations'         ///
			stripe(`stripe') cf(`cf') `noci' `coeflegend' ///
			byvals(`by') byvar(`e(stratavar)')

		local stripe `r(stripe)'
	}
	CovIndexRange, path(Residual) lvs(_cor)
	local j1 = `s(i1)'
	if `j1' {  
		if "`e(timevar)'"!="" | "`e(corrbyvar)'"!="" {
			local comma ,
		}
		if "`e(corlab)'" != "" {
			if `i1' {
				di _col(30) "{c |}"
				di as txt ///
				   "Residual correlation:" _col(30) "{c |}"
				di as txt _col(3) "`e(corlab)'`comma'" ///
				 _col(30) "{c |}"
			}
			else {
				di as txt "Residual: `e(corlab)'`comma'" ///
				  _col(30) "{c |}"
			}
		}	
		if "`e(timevar)'" != "" {
			di as txt _col(5) "time " as res ///
			 abbrev("`e(timevar)'",19) _col(30) "{c |}"
			local by byvals
		}
		else if "`e(rescorr)'"=="banded" | ///
			"`e(rescorr)'"=="unstructured" {
			di as txt _col(5) "index " as res ///
			 abbrev("`e(indexvar)'",19) _col(30) "{c |}"
		}
		if !`i1' & "`e(resvar)'"!="linear" {
			DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') ///
				label(`st') cf(`cf') `noci'              ///
				coeflegend(`leglabel')
		}
		if "`e(corrbyvar)'" != "" {
			di as txt _col(5) "by "as res ///
			 abbrev("`e(corrbyvar)'",21) _col(30) "{c |}"
			local by byvals
		}
		local j1 = `j1'-`i0'+1
		local j2 = `s(i2)'-`i0'+1
		mat `bi' = `b'[1,`j1'..`j2']
		mat `vi' = `v'[`j1'..`j2',`j1'..`j2']
		mat `tri' = `trans'[1,`j1'..`j2']
		DiResidualVar, b(`bi') v(`vi') z(`z') table(`table')  ///
			rt(`rt') trans(`tri') `stddeviations'         ///
			stripe(`stripe') cf(`cf') `noci' `coeflegend' ///
			byvals(`by') byvar(`e(corrbyvar)')

		local stripe `r(stripe)'
	}
	if !`i1' & !`j1' & "`e(resvar)'"!="linear" {
		DiVarCompEst, b(`bi') sb(`vi') lb(`lb') ub(`ub') ///
			label(`st') cf(`cf') `noci' coeflegend(`leglabel')
	}
	return local stripe `stripe'
	return local rt `rt'
end

program define DiResidualVar, rclass
	syntax, b(name) v(name) z(name) table(name) rt(integer) ///
			trans(name) cf(string) [ stddeviations  ///
			stripe(string) NOCI COEFLegend byvals(string) ///
			byvar(string)]

	tempname bi si lb ub bv bc vv vc idx bym

	local bstr : colnames `b'
	local k = colsof(`b')
	mat `idx' = J(`k',1,0)
	local Nlv = 0
	local npar = `k'
	if "`byvals'" != "" {
		mat `bym' = e(`byvals')	
		local Nlv = rowsof(`bym')
		local npar = `k'/`Nlv'		//# of param
		if `npar' > 1 {
			mat `idx' = vec((J(1,`Nlv',1)\J(`npar'-1,`Nlv',0)))
			
		}
		else {
			mat `idx' = J(`Nlv',1,1) 
		}
	}
	forvalues i=1/`k' {
		gettoken st bstr : bstr
		if ("`coeflegend'"!="") {
			local leglabel /Residual:`st'
		}

		scalar `bi' = `b'[1,`i']
		scalar `si' = `v'[`i',`i']
		scalar `si' = sqrt(`si')
		local tr = `trans'[1,`i']
		ComputeCI, b(`bi') s(`si') z(`z') lb(`lb') ub(`ub') trans(`tr')
		local `++rt'
		mat `table' = (nullmat(`table')\(`bi',`si',`lb',`ub'))
		
		local dlab = `idx'[`i',1]
		DiVarCompEst, b(`bi') sb(`si') lb(`lb') ub(`ub') ///
			label(`st') cf(`cf') `noci' coeflegend(`leglabel') ///
			cby(`byvar') displab("`dlab'")

		local stripe `"`stripe' `st'"'
		if `Nlv' & `npar'>1 & `i'<`k' {
			if !mod(`i',`npar') { 
				di as txt _col(30) "{c |}"
			}
		}
	}
	return local stripe `"`stripe'"'
	return local rt = `rt'
end

program define DiVarCompEst
	syntax, b(name) sb(name) lb(name) ub(name) label(string) cf(string) ///
			[cby(varname) displab(string) NOCI COEFLegend(string)]
	// Need to extract label values, find max length and use it
	// pass additional info on when to display label	
	local dilab ""
	local q 1
	if "`cby'" != "" {
		gettoken label val: label, parse("_")
		if "`label'" == "_" {
			/* _cons_#					*/
			gettoken label0 val : val, parse("_")
			local label `label'`label0'
		}
		local val : subinstr local val "_" ""	
		if "`val'" != "" {
			cap confirm number `val'
			if (c(rc)) {
				gettoken label0 val : val, parse("_")
				if "`label'"=="var" & "`label0'"=="ratio" {
					local label var(e)
				}
				else {
					local label `label'_`label0'
				}
				local val : subinstr local val "_" ""	
			}
			local lab : label (`cby') `val'
			local lab "`lab':"
			if "`displab'" == "1" {
				local dilab = abbrev("`lab'",13)
				/* 6 = max length of parameter: gamma,
				 *  corr, rho, delta, _cons, theta, var(e)
				 * local q = 30-length("`dilab'")-8	*/
				local l = length("`dilab'")
				local q = 22-`l'
			}
		}
	}
	
	local k = length("`label'")
	local p = 29 - `k'

	local est :  display `cf' `b'
	if `sb' == 0 {
		/* VCE not positive-definite				*/
		local se :  display `cf' .
	}
	else {
		local se :  display `cf' `sb'
	}
	local lse = length("`se'")
	local lest = length("`est'")

	if "`coeflegend'" != "" {
		di as txt _col(`p') "`label'" _col(30) "{c |}" ///
   			as res _col(`=33+9-`lest'') `cf' `est' ///
   			as txt _col(`=44+9-`lse'')  "_b[`coeflegend']"
	}
	else if "`noci'" == "" {
		local cil : display `cf' cond(missing(`se'),.,`lb')
		local ciu : display `cf' cond(missing(`se'),.,`ub')
		local lcil = length("`cil'")
		local lciu = length("`ciu'")
		di as txt _col(`q') "`dilab'" _col(`p') "`label'" _col(30) ///
			"{c |}" ///
   			as res _col(`=33+9-`lest'') "`est'" ///
   			as res _col(`=44+9-`lse'')  "`se'"  ///
	   		as res _col(`=58+9-`lcil'') "`cil'"  /// 
   			as res _col(`=70+9-`lciu'') "`ciu'"
	}
	else {
		di as txt _col(`p') "`label'" _col(30) "{c |}" ///
   			as res _col(`=33+9-`lest'') "`est'" ///
   			as res _col(`=44+9-`lse'')  "`se'"  
	}
end

program define ComputeCI
	syntax, b(name) s(name) z(name) lb(name) ub(name) trans(integer)

	qui findfile __sub_expr_global.matah
	qui include `"`r(fn)'"'

	tempname tb ts

	if `s'==0 | missing(`s') {
		scalar `lb' = .
		scalar `ub' = .
		scalar `s' = .
	}
	else if `trans' == `TRANSFORM_LOG' {
		scalar `tb' = log(`b')
		scalar `ts' = `s'/`b'
		scalar `lb' = exp(`tb'-`z'*`ts')
		scalar `ub' = exp(`tb'+`z'*`ts')
	}
	else if `trans' == `TRANSFORM_ATANH' {
		scalar `tb' = atanh(`b')
		scalar `ts' = `s'/(1-`b'^2)
		scalar `lb' = tanh(`tb'-`z'*`ts')
		scalar `ub' = tanh(`tb'+`z'*`ts')
	}
	else {
		scalar `lb' = `b' - `z'*`s'
		scalar `ub' = `b' + `z'*`s'
	}
end

program define ParseDisplayOpts, sclass
	syntax, [	VARiance		///
			STDDEViations		///
			NORETable		///
			NOFETable		///
			ESTMetric		///
			NOHEADer		///
			NOGRoup			///
			NOCI			///
			level(cilevel)		///
			COEFLegend		///
			NOLEGend		///
			ESTATSDPOST		///
			LRtest			///
			NOLRtest		///
			grouponly		///	/* undocumented */
			*			///
		]

	local k : word count `variance' `stddeviations'
	if `k' > 1 {
		di as err "{p}options {bf:variance} and {bf:stddeviations} " ///
		 "cannot be specified together{p_end}"
		exit 184
	}
	sreturn clear
	if !`k' {
		local variance variance		// default
	}
	_get_diopts diopts options, `options' `noci' level(`level')

	if "`coeflegend'" != "" {
		if ("`estatsdpost'"=="") {
			local estmetric estmetric
		}
		local diopts `"`diopts' coeflegend"'
	}
	if "`lrtest'" == "" {
		ParseLRTest, `options'

		local lrtest `s(lrtest)'
		local lrnullshow `s(lrnullshow)'
		local options `"`s(options)'"'
	}
	if ("`estmetric'"!="") {
		local noretable noretable
	}
	local diopts1 `"`variance' `stddeviations' `noretable'"'
	local diopts1 `"`diopts1' `nofetable' `estmetric' `noheader'"'
	local diopts1 `"`diopts1' `nogroup' `lrtest' `estatsdpost'"'
	local diopts1 `"`diopts1' `nolegend'"'

	local diopts1: list retokenize diopts1

	sreturn local options `"`options'"'
	sreturn local diopts `"`diopts'"'
	sreturn local diopts1 `"`diopts1'"'
	sreturn local nogroup "`nogroup'"
	sreturn local grouponly "`grouponly'"
	sreturn local level level(`level')
	sreturn local variance `variance'
	sreturn local stddeviations `stddeviations'
	sreturn local noretable `noretable'
	sreturn local nofetable `nofetable'
	sreturn local estmetric `estmetric'
	sreturn local noheader `noheader'
	sreturn local noci `noci'
	sreturn local coeflegend `coeflegend'
	sreturn local nolegend `nolegend'
	sreturn local lrtest `lrtest'
	sreturn local lrnullshow `lrnullshow'
end

program define ParseLRTest, sclass
	syntax, [ lrtest(string) * ]

	if "`lrtest'" != "" {
		if "`lrtest'" != "nullshow" {
			di as err "{p}option {bf:lrtest(`lrtest')} not " ///
			 "allowed{p_end}"
			exit 198
		}
		sreturn local lrnullshow lrnullshow
		sreturn local lrtest lrtest
	}
	sreturn local options `"`options'"'
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

	sreturn local options `"`rest'"'

	ExtractIfIn `nlexpr'
end

program define ExtractIfIn, sclass
	syntax anything(name=nlexpr id="nonlinear expression" equalok) ///
                [if][in], [ * ]

	local nlexpr `"`s(nlexpr)'`nlexpr'"'
	if "`options'"' != "" {
		local nlexpr `"`nlexpr',"'
		sreturn local nlexpr `"`nlexpr'"'
		ExtractIfIn `options'
	}
	else {
		sreturn local nlexpr `"`nlexpr'"'
		if "`if'" != "" {
			local ifin `"`if'"'
		}
		if "`in'" != "" {
			local ifin `"`ifin' `in'"'
		}
		sreturn local ifin `"`ifin'"'
	}
end

program define ParseDefines, sclass
	_on_colon_parse `0'
	local kdef = `s(before)'
	local 0, `s(after)'

	syntax, [ DEFine(string) * ]

	if `"`define'"' == "" {
		sreturn local kdefine = `kdef'
		sreturn local options `"`options'"'
		exit
	}
	sreturn local define`++kdef' `"`define'"'
	ParseDefines `kdef' : `options'
end

program define ParseMethod, sclass
	syntax, [ QUADrature LBAtes gnls ]

	local k : word count `quadrature' `lbates' `gnls'

	if `k' > 1 {
		di as err "{p}only one of {bf:lbates}, {bf:quadrature}, or " ///
		 "{bf:gnls} can be specified{p_end}"
		exit 184
	}
	sreturn clear
	if (!`k') {
		local default default
	}
	if "`quadrature'" != "" {
		di as err "{p}option {bf:quadrature} is not implemented{p_end}"
		exit 119
	}
	sreturn local method `lbates'`quadrature'`gnls'`default'
end

program define ParseCovariances, sclass
	menl_parse_covariances 0 : `0'
end

program define ParseInitial, sclass
	_on_colon_parse `0'
	local b `s(before)'
	local 0 `s(after)'

	cap noi syntax [ anything(name=initial id="initial" equalok) ], ///
			[ copy skip fixed ITERate(string)               ///
			LTOLerance(real 1e-10) LOg debug(integer 0) ]
	local rc = c(rc)
	if `rc' {
		di as err "(in option {bf:initial()})"
		exit `rc'
	}
	local est_initial = 1
	local set_parameters = 0
	if "`initial'" != "" {
		local est_initial = ("`fixed'"!="")
		Mkvec `b', initial(`initial') `copy' `skip'
		local set_parameters = 1
	}
	if !`est_initial' & "`iterate'"!="" {
		di as err "{p}invalid {bf:initial()} specification: " ///
		 "suboption {bf:iterate({it:#})} not allowed{p_end}"
		di as txt "{p 5 8 2}Initial estimates are computed if " ///
		 "the specification before the comma is blank or you "  ///
		 "specify the {bf:fixed} suboption.{p_end}"
		exit 198
	}

	if "`iterate'" != "" {
		cap ParseInteger ITERate : iterate(`iterate')
		local rc = c(rc)
		if !`rc' {
			local iterate = `s(iterate)'
		}
		if `rc' | `iterate'<0 {
			di as err "{p}invalid {bf:initial()} suboption " ///
			 "{bf:iterate(`iterate')}; positive integer "    ///
			 "expected{p_end}"
			exit 198
		}
	}
	else {
		local iterate = 25
	}
	local opts iterate `iterate'
	if `ltolerance' < 0 {
		di as err "{p}invalid {bf:initial()} suboption "         ///
		 "{bf:ltolerance(`tolerance')}; nonnegative real number " ///
		 "expected{p_end}"
		exit 198
	}
	local opts `opts' ltolerance `ltolerance' `log' debug `debug'

	sreturn local opts `"`opts'"'
	sreturn local fixed `fixed'
	sreturn local est_initial = `est_initial'
	sreturn local set_parameters = `set_parameters'
end

program define Mkvec
	syntax name, [ initial(string) copy skip ]

	if "`initial'" == "" {
		exit
	}
	if "`copy'"!="" & "`skip'"!="" {
		di as err "{p}invalid {bf:initial()} specification: only " ///
		 "one of {bf:copy} or {bf:skip} can be specified{p_end}"
		exit 198
	}
	local b `namelist'
	local stripe : colfullnames `b'
	local ncol : colsof `b'
	
	cap mat list `initial'
	if !c(rc) {
		mata: _menl_mkvec_from_vec("`b'","`initial'","`copy'`skip'")
		if `rc' {
			di as err "`errmsg'"
			exit `rc'
		}
		exit
	}
	cap numlist "`initial'"
	if !c(rc) {
		if "`copy'" == "" {
			di as err "{p}invalid {bf:initial()} " ///
			 "specification: option {bf:copy} required when a "  ///
			 "list of numbers is specified{p_end}"
			exit 198
		}
		local initial `r(numlist)'
		mata: _menl_mkvec_from_numlist("`b'","`initial'")
		if `rc' {
			di as err "`errmsg'"
			exit `rc'
		}
		exit
	}
	if "`copy'" != "" {
		cap numlist "`initial'"
		local rc1 `c(rc)'
 		cap mat list `initial'
		local rc2 `c(rc)'
		if `rc1' | `rc2' {
			di as err "{p}option {bf:initial()}: invalid " ///
				"specification{p_end}"
			di as err "{p 4 4 2}When you specify option " ///
			  	"{bf:copy} within {bf:initial()}, you " ///
				"must provide `ncol' initial values or a " ///
				" column/row Stata matrix of dimension " ///
				"`ncol' containing initial values.{p_end}"
			exit 198
		}
	}
	mata: _menl_mkvec_from_spec("`b'","`initial'","`skip'")
	if `rc' {
		di as err "`errmsg'"
		exit `rc'
	}
	/* set omitted (base) values to zero				*/
	local stripe : colfullnames `b'
	local j = 0
	while "`stripe'" != "" {
		gettoken stri stripe : stripe, bind
		_ms_parse_parts `stri'
		local `++j'
		if r(omit) {
			mat `b'[1,`j'] = 0
		}
	}
end

program define CheckLBatesOptOptions
	args options

	local rc = 0
	while `"`options'"' != "" {
		gettoken opt options : options
		if "`opt'" == "gradient" {
			local rc = 198
		}
		if "`opt'" == "hessian" {
			local rc = 198
		}
		if "`opt'" == "nrtolerance" {
			gettoken val options : options
			local opt "`opt'(`val')"
			local rc = 198
		}
		if "`opt'" == "nonrtolerance" {
			local rc = 198
		}
		if `rc' {
			di as err "option {bf:`opt'} not allowed"
			exit `rc'
		}
	}
end

program define ParseTSInit, sclass
	_on_colon_parse `0'
	local i = `s(before)'
	local 0, `s(after)'

	syntax, [ tsinit(string) * ]

	if "`tsinit'" != "" {
		sreturn local tsinit`++i' `"`tsinit'"'

		ParseTSInit `i': `options'
	}
	else {
		sreturn local ktsinit = `i'
		sreturn local options `"`options'"'
	}
end

program define ParseTSVar, sclass
	cap noi syntax varname(numeric), [ * ]

	local rc = c(rc)
	if `rc' {
		di as err `"in {bf:tsorder(}{it:varname} [, ...]{bf:)}"'
		exit `rc'
	}
	sreturn local tsvar `varlist'
	sreturn local tssetopts `options'
end

program define ParseOptimizeOptions, sclass
	_on_colon_parse `0'
	local method `s(before)'
	local 0, `s(after)'

	local options `"ITERate(string) TOLerance(real 1e-6)"'
	local options `"`options' LTOLerance(real 1e-7) vce(passthru) MLe"'
	local options `"`options' reml NOLOg LOg NOSTDerr SHOWTOLerance trace"'

	if "`method'" != "lbates" {	// method could be -default-
		local options `"`options' GRADient showstep HESSian"'
 		local options `"`options' NRTOLerance(passthru)"'
		local options `"`options' NONRTOLerance"'
	}
	syntax, [ `options' * ]

	sreturn clear
	sreturn local options `options'

	local k : word count `mle' `reml'
	if `k' == 2 {
		di as err "{p}only one of {bf:mle} and {bf:reml} can be " ///
		 "specified{p_end}"
		exit 184
	}
	if `k' != 1 {
		local mle mle
	}

	local rc = 0
	if "`iterate'" != "" {
		ParseInteger ITERate : iterate(`iterate')
		local iterate = `s(iterate)'
		if `iterate' < 0 {
			di as err "{p}invalid option "                   ///
			 "{bf:iterate(`iterate')}; nonnegative integer " ///
			 "expected{p_end}"
			exit 198
		}
		local mopts iterate `iterate'
	}
	if `ltolerance' < 0 {
		di as err "{p}invalid {bf:ltolerance(`ltolerance')} " ///
		 "specification: likelihood tolerance must be nonnegative" ///
		 "{p_end}"
		exit 198
	}
	if `tolerance' < 0 {
		di as err "{p}invalid {bf:tolerance(`tolerance')} " ///
		 "specification: parameter tolerance must be nonnegative{p_end}"
		exit 198
	}
	if "`nrtolerance'" != "" {
 		local 0, `nrtolerance'
		syntax, nrtolerance(real)
		if `tolerance' < 0 {
			di as err "{p}invalid " 			   ///
			 "{bf:nrtolerance(`nrtolerance')} specification: " ///
			 "nrtolerance must be nonnegative{p_end}"
			exit 198
		}
	}
	if "`log'"!="" & "`nolog'"!="" {
		di as err "{p}options {bf:log} and {bf:nolog} cannot both " ///
		 "be specified{p_end}"
		exit 184
	}
	if "`c(iterlog)'" == "off" {
		if "`log'" == "" {
			local nolog nolog
		}
	}
	cap noi _vce_parse, optlist(CONVentional):, `vce'
	local rc = c(rc)
	if `rc' {
		di as err "(error in option {bf:vce()})"
		exit `rc'
	}
	local vce `r(vce)'

	sreturn local trace = ("`trace'"!="")
	local mopts `"`mopts' tolerance `tolerance' ltolerance `ltolerance'"'
	local mopts `"`mopts' `vce' `trace' `mle'`reml' `nolog' `nostderr'"'
	local mopts `"`mopts' `showtolerance' `trace' `gradient' `showstep'"'
	local mopts `"`mopts' `hessian' `nonrtolerance'"'
	if "`nrtolerance'" != "" {
		local mopts `"`mopts' nrtolerance `nrtolerance'"'
	}
	sreturn local mopts `"`mopts'"'
	sreturn local vce `vce'
	sreturn local trac `trace'
	sreturn local ltype `mle'`reml'
	sreturn local nolog `nolog'
	sreturn local nostderr `nostderr'
end

program define ParseInteger, sclass
	_on_colon_parse `0'
	local option `s(before)'
	local 0 ,`s(after)'

	syntax, `option'(integer)

	local option = strlower("`option'")

	sreturn local `option' = ``option''
end

program define ParseCommonMopts, sclass
	_on_colon_parse `0'
	local which `s(before)'
	local 0 `s(after)'

	/* alternating algorithm allows 5 iterations for PNLS & LME
	 *  for each cycle						*/
	cap noi syntax, [ ITERate(passthru) 	///
			TOLerance(passthru)	///
			LTOLerance(passthru) 	///
			NRTOLerance(passthru) 	///
			SHOWTOLerance		///
			NONRTOLerance		///
			TRace			///
			log			///
			NOLOG			///
			* ]
	local rc = c(rc)
	if `rc' {
		di as err "(in option {bf:`which'()})"
		exit `rc'
	}
	if "`iterate'" != "" {
		cap ParseInteger iterate : `iterate'
		local rc = c(rc)
		if !`rc' {
			local iterate = `s(iterate)'
			/* iterate(0) not allowed for PNLS & LME	*/
			local rc = (`iterate' <= 0)
		}
		if `rc' {
			di as err "{p}invalid {bf:`which'()} "            ///
			 "specification: {bf:iterate({it:#})} must be a " ///
			 "positive integer{p_end}"
			exit 198
		}
		local mopts `"`mopts' iterate `iterate'"'
	}
	if "`log'"!="" & "`nolog'"!="" {
		di as err "{p}invalid {bf:`which'()} specification: "   ///
		 "options {bf:log} and {bf:nolog} cannot be specified " ///
		 "together{p_end}"
		exit 184
	}
	if "`tolerance'" != "" {
		local 0, `tolerance'
		cap noi syntax, [ TOLerance(real 1e-6) ]
		local rc = c(rc)
		if `rc' {
			di as err "(in option {bf:`which'()})"
			exit `rc'
		}
		if `tolerance' < 0 {
			di as err "{p}invalid {bf:`which'()} "              ///
			 "specification: {bf:tolerance({it:#})} must be a " ///
			 "positive number{p_end}"
			exit 198
		}
		local mopts `"`mopts' tolerance `tolerance'"'
	}
	if "`ltolerance'" != "" {
		local 0, `ltolerance'
		cap noi syntax, [ LTOLerance(real 1e-7) ]
		local rc = c(rc)
		if `rc' {
			di as err "(in option {bf:`which'()})"
			exit `rc'
		}
		if `ltolerance' < 0 {
			di as err "{p}invalid {bf:`which'()} "             ///
			 "specification: {bf:ltolerance({it:#})} must be " ///
			 "a nonnegative number{p_end}"
			exit 198
		}
		local mopts `"`mopts' ltolerance `ltolerance'"'
	}
	if "`nrtolerance'" != "" {
		local 0, `nrtolerance'
		cap noi syntax, [ NRTOLerance(real 1e-5) ]
		local rc = c(rc)
		if `rc' {
			di as err "(in option {bf:`which'()})"
			exit `rc'
		}
		if `nrtolerance' < 0 {
			di as err "{p}invalid {bf:`which'()} "               ///
			 "specification: {bf:nrtolerance({it:#})} must be " ///
			 "a nonnegative number{p_end}"
			exit 198
		}
		local mopts `"`mopts' nrtolerance `nrtolerance'"'
	}	
	local mopts `"`mopts' `nolog' `log'"'
	local mopts `"`mopts' `nonrtolerance'"'
	local mopts `"`mopts' `showtolerance'"'
	local mopts `"`mopts' `trace'"'
	local mopts : list retokenize mopts

	sreturn local mopts `"`mopts'"'
	sreturn local options `"`options'"'
end

program define ParseLMEopts, sclass

	sreturn clear
	ParseCommonMopts lmeopts : `0'

	local 0 `", `s(options)'"'
	cap noi syntax, [ showstep GRADient HESSian VSTDErr(string) * ]
	local rc = c(rc)
	if `rc' {
		di as err "(in option {bf:lmeopts()})"
		exit `rc'
	}
	ParseVSTDErr, `vstderr'

	local mopts `"`s(mopts)' `showstep'"'
	local mopts `"`mopts' `gradient'"'
	local mopts `"`mopts' `hessian'"'
	local mopts `"`mopts' `s(vstderr)'"'
	sreturn local mopts `"`mopts'"'
	sreturn local options `"`options'"'
end

program define ParsePNLSopts, sclass

	sreturn clear
	ParseCommonMopts pnlsopts : `0'

	local 0 `", `s(options)'"'
	cap noi syntax, [ showstep GRADient HESSian * ]
	local rc = c(rc)
	if `rc' {
		di as err "(in option {bf:lmeopts()})"
		exit `rc'
	}
	foreach opt in showstep gradient hessian {
		if "``opt''" != "" {
			di as err "{p}invalid option {bf:pnlsopts()}; " ///
			 "suboption {bf:`opt'} not allowed{p_end}"
			exit 198
		}
	}
	sreturn local options `"`options'"'
end

program define ParseEMopts, sclass
	syntax, [ emiterate(passthru) emtolerance(real 1e-10) emlog ]

	sreturn clear
	if "`emiterate'" != "" {
		ParseInteger EMITERate : `emiterate'
			
		local iterate = `s(emiterate)'
		if `iterate' < 0 {
			di as err "{p}invalid option "               ///
			 "{bf:emiterate(`emiterate')}: nonnegative " ///
			 "integer expected{p_end}"
			exit 198
		}
		local mopts iterate `iterate'
	}
	if "`emlog'" != "" {
		local mopts `mopts' log
	}
	if `emtolerance' < 0 {
		di as err "{p}invalid {bf:emtolerance(`emtolerance')} " ///
		 "specification: nonnegative real number expected{p_end}"
		exit 198
	}
	local mopts `mopts' ltolerance `emtolerance'

	sreturn local mopts `mopts'
end

program ParseVSTDErr, sclass
	syntax, [ hier rcov ]

	local k : word count `hier' `rcov'
	if `k' > 1 {
		di as err "{p}invalid {bf:vstderr()} option: suboptions " ///
		 "{bf:hier} and {bf:rcov} cannot both be specified{p_end}"
	}
	if _caller() >= 16 {
		if "`rcov'" != "" {
			sreturn local vstderr vsercov
		}
		else {
			sreturn local vstderr vsehier
		}
	}
	else if "`hier'" != "" {
		sreturn local vstderr vsehier
	}
	else {
		sreturn local vstderr vsercov
	}
end

program define ValidateIntegerValued
	_on_colon_parse `0'
	local resopt `s(before)'
	local 0 `s(after)'

	cap noi syntax varname(numeric), touse(varname)

	local ty : type `varlist'
	if "`ty'"=="float" | "`ty'"=="double" {
		tempvar v neq

		qui gen `ty' `v' = floor(`varlist') if `touse'
		qui gen byte `neq' = `v' != `varlist' if `touse'
		qui count if (`neq' | `varlist'<0) & `touse'
	}
	else {
		qui count if `varlist'<0 & `touse'
	}
	if r(N) {
		di as err "{p}invalid {bf:`resopt'} specification: " ///
		 "variable {bf:`varlist'} must contain nonnegative " ///
		 "integers{p_end}"
		exit 109
	}
end

program define WaldTest, rclass

	tempname b

	local kfe = e(k_f)
	mat `b' = e(b)
	local stripe : colfullnames `b'
	forvalues i=1/`kfe' {
		gettoken c stripe : stripe, bind
		if usubstr("`c'",1,1) == "/" {
			/* do not include free parameters		*/
			continue
		}
		_ms_parse_parts `c'

		if (r(omit)) {
			continue
		}
		gettoken e c : c, bind parse(":")
		if "`c'" == "" {
			local c `e'
			local e
		}
		else {
			gettoken colon c : c, bind parse(":")
		}
		if "`c'" == "_cons" {
			continue
		}
		if "`e'" != "" {
			if "`e'" != "`e1'" {
				local tlist `tlist' [`e']
				local e1 `e'
			}
		}
		else {
			local `++keq'
			local tlist `tlist' `c'
		}
	}
	local keq = 0
	while "`tlist'" != "" {
		gettoken c tlist: tlist
		local `++keq'
		qui test `c', `accum'
		local accum accumulate
	}
	return add

	if (!`keq') {
		return scalar df = 0
	}
end

program define UpdateHierstats, sortpreserve eclass
	syntax varname, touse(varname) [ panels(varname) ///
			order(varname) ]

	tempname hstats hstats1

	mat `hstats' = e(hierstats)


	if "`panels'" == "" {
		qui count if `touse'
		mat `hstats1' = (1,r(N),r(N),r(N))
	}
	else {
		tempvar pcount tu

		sort `touse' `panels' `order'

		qui gen long `pcount' = 1 if `touse'
		qui by `touse' `panels' (`order'): replace `pcount' = ///
			sum(`pcount') if `touse'
		gen byte `tu' = 0
		qui by `touse' `panels' (`order'): replace `tu' = 1 ///
			if _n==_N & `touse'

		summarize `pcount' if `tu' & `touse', meanonly

		mat `hstats1' = (r(N),r(mean),r(min),r(max))
	}
	local rnames : rownames `hstats'
	local rnames "`rnames' `varlist'"

	mat `hstats' = (`hstats' \ `hstats1')
	mat rownames `hstats' = `rnames'

	ereturn mat hierstats = `hstats'
end

program define RePostReTable, rclass
	syntax, retable(string) fetable(string)

	return mat retable = `retable'
	return mat table = `fetable'
end

program define CheckForDroppedPanel, sortpreserve
	syntax varname, tvar(varname) touse1(varname) touse(varname) ///
		[ recursive ]

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
		if "`recursive'" != "" {
			di as err "{p 4 4 2}Your model includes the lagged " ///
			 "predicted mean function.  Perhaps the " 	     ///
			 "{helpb menl##menl:tsmissing} option would be "     ///
			 "appropriate for your model.{p_end}"
		}
		exit 2001
	}
end

program define NestedGroupMsg
	syntax, [ grvar(string) path(string) ]

	local kpath : list sizeof path
	if "`grvar'"=="" | !`kpath' {
		exit
	}
	/* if group var is in path it is at the bottom of the
	 *  hierarchy; ensured by hierarchical object			*/
	local path0 : list path - grvar
	if "`path0'" != "`path'" {
		/* group variable is in the RV path			*/
		exit
	}
	local path : subinstr local path " " ">", all
	di as txt "{p 0 6 2}note: group variable {bf:`grvar'} nested in " ///
	 "{bf:`path'} assumed{p_end}"
end

exit
