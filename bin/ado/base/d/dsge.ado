*! version 1.1.1  28feb2019
program define dsge, eclass 
	version 15

	if replay() {
		if (`"`e(cmd)'"' != "dsge") {
			error 301
		}
		Display `0'
		exit
	}
	
	Estimate `0'
	ereturn local cmdline `"dsge `0'"'
end

program Display
	syntax [, *]
	_get_diopts diopts, `options'
	_coef_table_header
	_coef_table, `diopts' notest
end

program define Estimate, eclass
	syntax anything [if] [in],                  ///
		[CONSTraints(string)                /// 
		FROM(string)                        ///
		SHOWTOLerance                       ///
		SOLVE                               ///
		noIDencheck                         ///
		noDEMean                            ///
		Level(cilevel)                      /// 
		COEFLegend                          ///
		IDTOLerance(real 1e-6)              ///
		LINTOLerance(real 1e-12)            ///
		TECHnique(string)                   ///
		ITERate(string)                     ///
		post				    ///  
		NOLOg                               ///
		LOg                                 ///
		*                                   /// optimize, diopts
	] 
	

	// parse optimize options
	if ("`technique'" !="" & "`solve'"!="") {
		local technique ""
	}
	if ("`iterate'"!="0" & "`technique'"=="" & "`solve'"=="" & "`post'"== "") {
		local technique = "bfgs 5 nr"
	}
	if ("`showtolerance'" != "") {
		local shownrtolerance "shownrtolerance"
	}

	opts_exclusive "`log' `nolog'"
	if ("`c(iterlog)'"=="off" & "`log'"=="") {
		local log nolog 
	}
	if ("`nolog'"!="") {
		local log nolog
	}

	_parse_optimize_options, technique(`technique') `shownrtolerance' ///
		iterate(`iterate') `options' `log'
	local optimize_options `s(mlopts)'
	local rest `s(rest)'
	local vce = s(vce)
	if ("`vce'" == "robust") local vcetype "Robust"
	else                     local vcetype "OIM"
	
	// parse display options
	_get_diopts diopts, `rest'

	if ("`solve'"=="solve") {
		local post "post"
	}

	// general setup: equations, parameter names
	tempname PARAM 
	_parmlist `anything'
	local  eqlist    = r(expr)
	local  NAMES     = r(parmlist)
	matrix `PARAM'   = r(initmat)
	matrix coleq `PARAM' = /structural:

	// glean the structure from the equations and place into macros 
	_split_eqn `eqlist'
	local n_eq      = r(n_eq)
	local control   = r(controls)
	local state     = r(states)
	local shock     = r(shocks)
	local obser     = r(observed)

	local allvars "`state' `control'"
	local allvars: list uniq allvars

	local nvars: word count `allvars'
	if (`nvars' != `n_eq') {
		di as err "invalid syntax"
		di as err "{p 4 4 2}"  
		di as err "Number of variables must equal"
		di as err " number of equations."
		di as err "    `nvars' `=plural(`nvars',"variable")' and "  
		di as err " `n_eq' `=plural(`n_eq',"equation")' "
		di as err "specified."
		di as err "{p_end}"
		exit 198
	}

	// build model
	forvalues j = 1/`n_eq' {
		local eqnolist = "`eqnolist' r(eq`j')"
	}
	tempname __model
	mata: `__model' = J(`n_eq',1,"")
	mata: buildmodel("`eqnolist'",`__model')

	// marksample, TS setup, and TS checks
	marksample touse
	markout `touse' `obser'  
	qui tsset
	local tsfmt = r(tsfmt)
        qui tsreport if `touse'
	if (r(N_obs)==0)  error 2000
        if (r(N_gaps)!=0) {
                di as err "{p 0 8 2} gaps not allowed{p_end}"
                exit 459
        }
	_ts tvar
	_check_ts_gaps `tvar', touse(`touse')
        tempname tmin tmax
        summarize `tvar' if `touse', meanonly
        scalar `tmax' = r(max)
        scalar `tmin' = r(min)
        local fmt : format `tvar'
        local tmins = trim(string(r(min), "`fmt'"))
        local tmaxs = trim(string(r(max), "`fmt'"))

	// initial parameter vector and constraints setup
	makeshockparam "`shock'"
	local  ANCIL        = r(names)
	matrix `PARAM'      = (`PARAM', r(values))
	_mkvec `PARAM', from(`from') update

	tempname Cc b V
	matrix `b' = `PARAM'
	matrix `V' = `b'' * `b'
	ereturn post `b' `V'
	if ("`constraints'" != "") {
		makecns `constraints'
		matrix `Cc' = e(Cns)
		tempname T a C
		matcproc `T' `a' `C'
	}
	else {
		matrix `Cc'  = 0
		local no_cns = 1
	}
	if ("`no_cns'" !="1" ) {
		mata: _get_init_helper("`PARAM'")
	}

	tempname initial
	matrix `initial'     = `PARAM'
	local ancil_names    = "`ANCIL'"
	local names_from_eqn = "`NAMES'"
	
	// more syntax checks
	_observed_check, observed(`obser') shock(`shock')
	local names_from_initial: colnames `initial'
	_check_init, initial("`initial'")
	_dsgeCheck, param_name(`names_from_initial')           ///
	            n_eq(`n_eq')                               ///
		    state(`state')                             ///
		    control(`control')                         ///
		    shock(`shock')
	
	local solve_flag  = ("`solve'"=="solve")
	local id_flag     = ("`idencheck'"=="")
	local demean_flag = ("`demean'" == "")
	local cns_flag    = ("`constraints'" != "")
	
	qui sum `obser' if `touse', meanonly
	local N_obser = r(N)
	local N_param: colsof `initial' 
	if(`N_obser' <= `N_param') error 2001

	// set up ereturn objects
	tempname hat Vhat lik converged 
	tempname eigenvalues k_stable rank Nobs
	tempname gx hx eta 
	tempname ic ilog grad_sol Vm 
	tempname gx_deriv hx_deriv et_deriv rc
	local ereturn_names `hat' `Vhat' `lik' `converged'     ///
		`eigenvalues' `k_stable' `rank' `Nobs'         ///
		`gx' `hx' `eta'                                ///
		`ic' `ilog' `grad_sol' `Vm'                    ///
		`gx_deriv' `hx_deriv' `et_deriv' `rc'


	// mata entry point
	mata: _dsge_entry("`names_from_initial'",     ///
	      "`initial'",                            ///
	      "`state'",                              ///
	      "`control'",                            ///
	      "`obser'",                              ///
	      `__model',                              ///
	      "`shock'",                              ///
	      "`vce'",                                ///
	      "`touse'",                              ///
              `solve_flag',                           ///
	      `demean_flag',                          ///
	      `id_flag',                              ///
	      `idtolerance',                          ///
              `lintolerance',                         ///
	      "`Cc'",                                 ///
	      "`ereturn_names'" ,                     ///
	      `optimize_options',                     ///
              "`post'")

	// clean up 
	mata: mata drop `__model'
	
	mata: st_local("fstate",invtokens("f." :+ tokens(st_local("state"))))
	local hatnames: colfullnames `PARAM'
	
	matrix colnames `hat'  = `hatnames'
	matrix colnames `Vhat' = `hatnames'
	matrix rownames `Vhat' = `hatnames'
	local N = `Nobs'
	_label_eigenvalues `eigenvalues' `k_stable'

	tempname Q 
	matrix colnames `gx'   = `state'
	matrix rownames `gx'   = `control'
	matrix colnames `hx'   = `state'
	matrix rownames `hx'   = `fstate'
	matrix rownames `eta'  = `fstate'
	matrix colnames `eta'  = `estripe'	
	matrix `Q'             = `eta'*`eta''

	local k_shock: word count `ancil_names'
	local k_eq           = `k_shock'+1

	if ("`idencheck'" != "" & "`ident'"=="") {
		local ident "skipped"
	}
	if ("`ident'"=="") {
		local ident "passed"
	}
	local hasmissing = matmissing(`gx') + matmissing(`hx')


	// Return block
	ereturn clear
	if (`cns_flag' != 0) {
		 ereturn post `hat' `Vhat' `Cc', obs(`N') esample(`touse')
	}
	else {
		ereturn post `hat' `Vhat',       obs(`N') esample(`touse')
	}
	if ("`vce'"=="robust" & "`solve'" == "") {
		ereturn matrix V_modelbased = `Vm'
	}

	//pclass
	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	local pos = `dim' - `k_shock' + 1
	matrix `pclass'[1,`pos'] = J(1, `k_shock', `PCAUX')
	ereturn hidden matrix b_pclass `pclass'

	ereturn matrix policy      = `gx'
	ereturn matrix transition  = `hx'
	ereturn matrix shock_coeff = `eta'
	ereturn scalar ll          = `lik'
	ereturn scalar k           = `N_param'
	ereturn scalar ic          = `ic'
	ereturn matrix ilog        = `ilog'
	ereturn matrix gradient    = `grad_sol'
	ereturn scalar rank        = `rank'
	ereturn scalar converged   = `converged'
	ereturn scalar k_state     = `:word count `state''
	ereturn scalar k_control   = `:word count `control''
	ereturn scalar k_shock     = `k_shock'
	ereturn scalar k_observed  = `:word count `obser''
	ereturn scalar k_dv        = `:word count `obser''
	ereturn scalar k_stable    = `k_stable'
	ereturn scalar k_eq        =  `k_eq'
	ereturn scalar rc          = `rc'
	ereturn matrix eigenvalues = `eigenvalues'
	ereturn local control    `control'
	ereturn local state      `state'
	ereturn local observed   `obser'
	ereturn local depvar     `obser'
	ereturn local idencheck  `ident'
	ereturn local technique  `optech'
	ereturn local vce        `vce'
	ereturn local vcetype    `vcetype'
	ereturn local opt         "optimize"
	ereturn local predict     "dsge_p"
	ereturn local estat_cmd   "dsge_estat"
	ereturn local method      "gf0"
        ereturn local marginsok 
        ereturn local marginsnotok _ALL
	ereturn local tsfmt = "`tsfmt'"
	ereturn scalar tmin = `tmin'
	ereturn scalar tmax = `tmax'
	ereturn local tvar  = "`tvar'"
	ereturn local tmins = "`tmins'"
	ereturn local tmaxs = "`tmaxs'"
	ereturn hidden local crittype  "log likelihood"
	ereturn hidden matrix po_deriv = `gx_deriv'
	ereturn hidden matrix tr_deriv = `hx_deriv'
	ereturn hidden matrix sh_deriv = `et_deriv'
	ereturn hidden matrix V_shocks = `Q'
	ereturn local title  "DSGE model"
	ereturn local cmd    "dsge"

	Display, `diopts' level(`level') `coeflegend'

	if ("`ident'"=="failed") {
		di as txt "Note: Parameters not identified at " ///
		          "reported values." 
	}
	if ("`ident'"=="skipped") {
		di as txt "Note: Skipped identification check."
	}

	if (`hasmissing' > 0) {
		di as txt "{p 0 9 2}"
		di as txt "Warning: Model cannot be solved at " ///
			  "current parameter values. Current "  ///
			  "values imply a model that is not "   ///
			  "saddle-path stable."
		di as txt "{p_end}"
	}


	if ("`optimize_options'" != "(-1,-1,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0)") {
		local max_note "; maximization options ignored."
	}
	else {
		local max_note "."
	}
	if ("`solve'" != "" & `lik'<. & "`ident'"!="failed") {
		di as txt "{p 0 6 2}"
		di as txt "Note: Model solved at specified"
		di as txt " parameters`max_note'"
		di as txt "{p_end}"
	}
end
/* END main program */

// put labels on eigenvalue vector
program define _label_eigenvalues 
	local evname   `1'
	local k_stable `2'

	local cols = colsof(`evname')

	forvalues i = 1/`cols' {
		if (`i' <= `k_stable') {
			local iname "stable"
		}
		else {
			local iname "unstable"
		}
		local names "`names' `iname'"
	}
	matrix colnames `evname' = `names'
	matrix rownames `evname' = Eigenvalues
end






/* -----------------------------------------------------------------------
	_get_init_helper
	tool to aid in processing constraints
----------------------------------------------------------------------- */
mata:
void _get_init_helper(string scalar in)
{
	real matrix    invec
	real matrix    Cc
	real matrix    C
	real vector    c
	real vector    toret
	real scalar    i, k, lookatcol, res

	invec = st_matrix(in)
	Cc = st_matrix("e(Cns)")
	k = cols(Cc)-1
	C = Cc[.,1..k]
	c = Cc[.,k+1]

	toret = J(1,k,0)
	for(i=1;i<=rows(C);i++) {
		if(cols(selectindex(C[i,.]))==1) {
			lookatcol = selectindex(C[i,.])
			res = c[i] / C[i,lookatcol]
			toret[lookatcol] = res
		}
	}
	
	for(i=1;i<=length(invec);i++) {
		if (toret[i] != 0) {
			invec[i] = toret[i]
		}
	}

	st_replacematrix(in,invec)
}
end




program define makeshockparam, rclass
	args shock 
	
	local nshock: word count `shock'
	local names = ""
	local values = ""
	local sd = 1
	matrix values = J(1,`nshock',`sd')
	
	foreach shock in `shock' {
		local names = "`names' sd(`shock')"
		local eqnames = "`eqnames' /sd(`shock')"
	}
	matrix colnames values = `eqnames'

	return local names     = "`names'"
	return matrix values   = values
end


program define _observed_check
	syntax , observed(string) shock(string)
	
	local n_variables: word count `observed'
	local n_shock:     word count `shock'
	
	if (`n_variables' > `n_shock') {
		di  as err "cannot have more variables than shocks"
		exit 198
	}
end






/* -----------------------------------------------------------------------
	_split_eqn
	Splits (eq1) (eq2) ... (eqN) into equations
	
	return 
	       scalar n_eq
	       local r(eq1) ... r(eqN)
	       local r(full) = anything
----------------------------------------------------------------------- */
program define _split_eqn, rclass
	syntax anything 

	local eqnstructure2 `anything'
	local controls = ""
	local state = ""
	local shocks = ""
	local readyeqlist = ""
	local obserlist = ""
	
	// interpret the structure of each equation, one at a time
	local n_eqtmp=0
	while ("`eqnstructure2'" != "") {
		local ++n_eqtmp
		gettoken eq`n_eqtmp' eqnstructure2: eqnstructure2, match(paren)

		EQNparse1 `eq`n_eqtmp'' 

		// interpret the structure of a single equation 
		if (r(type)=="state") local state = "`state' `r(depvar)'" 
		else local controls = "`controls' `r(depvar)'"

		if(r(isshock)==1) local shocks = "`shocks' e.`r(depvar)'" 
		local readyeqlist = "`readyeqlist' ( `r(eqn)')"

		if (r(isobser)==1) local obserlist = "`obserlist' `r(depvar)'"
	}

	// interpret the structure of all equations jointly
	local ncontrols: word count `controls'
	local nstate:    word count `state'
	local nobs:      word count `obserlist'
	
	if (`ncontrols'==0) {
		di as err "no control variables found"
		exit 198
	}
	if (`nstate'==0) {
		di as err "no state variables found"
		exit 198
	}
	if(`nobs'==0) {
		di as err "no observable variables found"
		exit 198
	}

	// error checks
	local n_eq = 0
	while ("`readyeqlist'" != "" ) {
		local ++n_eq
		gettoken eq`n_eq' readyeqlist: readyeqlist, match(paren)

		
		
		// Should never get here, but check anyway
		if("`paren'" != "(") {
			di as err "syntax error"
			di as err "{p 4 4 2}" ///
			          "Something other than" /// 
			          " (eq1) (eq2) ... (eqN) found."
		        di as err "{p_end}"
			exit 198
		}

		local count = length("`eq`n_eq''") ///
			- length(subinstr("`eq`n_eq''","=","",.))
		if( `count' >1) {
			di as err "invalid syntax"
			di as err "{p 4 4 2}" ///
			            "Too many = in equation `n_eq'." 
			di as err "{p_end}"
			exit 198
		}
	
		if(strmatch("`eq`n_eq''","*=*")) {
			local eq`n_eq' = subinstr("`eq`n_eq''","=",")+",.)
			local eq`n_eq' = "-( `eq`n_eq''"
		}		
	}

	// return block
	forvalues i = `n_eq'(-1)1 {
		cleaneqn `eq`i'', state(`state') control(`controls')
		local eq`i' = r(clean)
	}
	local state:    list uniq state
	local controls: list uniq controls
	local obserlist: list uniq obserlist

	
	return scalar n_eq = `n_eq'
	forvalues i = `n_eq'(-1)1 {
		return local eq`i' = "`eq`i''"
	}
	return local states   = "`state'"
	return local controls = "`controls'"
	return local shocks   = "`shocks'"
	return local observed = "`obserlist'"

end


capture program drop EQNparse1
program define EQNparse1, rclass
	syntax anything(equalok) [, STATE UNOBServed noSHOCK]

	if ("`state'"!="" & "`unobserved'" !="") {
		di as err "options state and unobserved " _cont
		di as err "may not both be specified"
		exit 198
	}
	if ("`shock'"!="" & "`unobserved'" !="") {
		di as err "options noshock and unobserved " _cont
		di as err "may not both be specified"
		exit 198
	}
	local eqret = "`anything'"
	gettoken first rest: anything, parse(=)
	if ("`rest'"=="") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err  "equation `anything' invalid"
		di as err "{p_end}"
		exit 198
	}

	gettoken x1 x2: first, parse(+-) bind
	if("`x2'" != "") {
		di as err "equation `anything' invalid"
		di as err "{p 4 4 2}"
		di as err "Only one term allowed on left-hand side " 
		di as err "of an equation."
		di as err "{p_end}"
		exit 198
	}
	local work: subinstr local first "*" " ", all
	local n: word count `work'
	local thevar: word `n' of `work'

	if (substr("`thevar'",1,2)=="F." | substr("`thevar'",1,2)=="f.") {
		if ("`state'" != "state") {
			di as err "state equation incorrectly specified"
			exit 198
		}
		local type = "state"
		local thevar = substr("`thevar'",3,.)
	}
	
	else local type = "control"

	if ("`type'" == "control" & "`state'"=="state") {
		di as err "equation `eqret' invalid"
		di as err "{p 4 4 2}"
		di as err "state equations must have a "
		di as err "once-forward operated state variable on "
		di as err "the left-hand side."
		di as err "{p_end}"
		exit 198
	}
	
	cap _ms_parse_parts `thevar'
	if (_rc | r(type)!="variable") {
                di as err "variable {bf:`thevar'} is invalid"
                exit 198
	}

	local rest: subinstr local rest "=" "= ", all
	if (`:word count `rest'' ==1) {
		local eqret = "`first'"
	}

	return local depvar = "`thevar'"
	return local type = "`type'"
	return local eqn = "`eqret'"
	return scalar isshock = ("`state'"=="state")   & ("`shock'"=="")
	return scalar isobser = ("`unobserved'" == ""  &  "`state'"=="")
end



program define cleaneqn, rclass
	syntax anything, state(string) control(string)
	

	local original = "`anything'"
	local targets = "`state' `control'"

	local i = strpos("`anything'","E(")
	local j = `i'+1
	local rest = substr("`anything'",`j',.)
	while (`i' != 0) {
		gettoken todo rest: rest, match(paren)
		local todo = strtrim("`todo'")
		local k: word count `todo'
		local bad = 0
		if (substr("`todo'",1,2) != "F." & ///
		    substr("`todo'",1,2) != "f.") local bad = 1
		if(`k' > 1 | `bad' ) {
			di as err "unexpected expression {bf:E(`todo')} found"
			di as err "{p 4 4 2}"                          
			di as err "Rational expectations operator "   
			di as err "requires a once forward operated " 
			di as err "variable, such as {bf:E(F.y)}."     
			di as err "{p_end}"
			exit 498
		}
		local todovar = substr("`todo'",3,.)
		local good: list todovar in targets
		if (`good'==0) {
			di as err "unexpected expression {bf:E(`todo')} found"
			di as err "{p 4 4 2}" 
			di as err "{bf:E(`todo')} specified but " 
			di as err "{bf:`todovar'} is not a state or "
			di as err "control variable." 
			di as err "{p_end}"
			exit 498
		}
		local i = strpos("`rest'","E(")
		local j = `i'+1
		local rest = substr("`rest'",`j',.)
	}

	local clean = subinstr("`original'", "E(","(",.)
	local clean = subinstr("`clean'","F.","f.",.)
	return local clean = "`clean'"
end





/* -----------------------------------------------------------------------
	_check_init
	verify that all parameters are initialized
----------------------------------------------------------------------- */
program define _check_init
	syntax , initial(string)
	
	scalar colno = colsof(`initial')
	local cols = colno
	
	forvalues i = 1/`cols' {
		if(`initial'[1,`i']==0) {
			matrix `initial'[1,`i']=0.2 + `i'/100
		}
	}
	
end



/* -----------------------------------------------------------------------
	_dsgeCheck
	Performs a suite of checks to ensure that structure is sensible

	check that number of equations equals number of variables
	check for duplicates in state
	check for duplicates in control
	check for duplicates in shock
	check for duplicates in param
----------------------------------------------------------------------- */
program define _dsgeCheck
	syntax , [param_name(string) ///
		 state(string)       ///
		 control(string)     ///
		 shock(string)       ///
		 n_eq(integer 0)]
		 
	local n_state:   word count `state'
	local n_control: word count `control'
	local n_variables = `n_state' + `n_control'
	if(`n_eq' > `n_variables')  {
		di as err "model has `n_eq' equations" _cont
		di as err " but only `n_variables' variables"
		exit 498
	}
	if(`n_eq' < `n_variables')  {
		di as err "model has `n_variables' variables" _cont
		di as err " but only `n_eq' equations"
		exit 498
	}
	
	// check for duplicates
	// should never get here, but exit gracefully if you do
	_checkdups `state',   name(state)
	_checkdups `control', name(control)
	_checkdups `shock',   name(shock)
	_checkdups `state' `control' `shock', ///
		name("state, control, and shock")

	_checkShocks, state("`state'") shock("`shock'")
	_checkdups `param_name', name(parameters)
end


/* -----------------------------------------------------------------------
	checkdups: checks for duplicates in a macro list	
	useful for: param names, state names, control names, shock names
----------------------------------------------------------------------- */
program define _checkdups
	syntax anything, name(string)
	local dups: list dups  local(anything)
	local 1: word count `dups'
	if("`1'"!="0") {
		di as err "duplicate names found in `name'"
		exit 198
	}
end


/* -----------------------------------------------------------------------
	_checkShocks checks for problems in the shock/state setup
	
	if e.z is a shock, then z must exist in the state vector
----------------------------------------------------------------------- */
prog define _checkShocks
	syntax , state(string) shock(string)
	
	local tmp ""
	foreach sh in `shock' {
		local tmp = "`tmp' " + substr("`sh'",strpos("`sh'",".")+1,.)
	}
	
	local test: list tmp in state
	if (`test'==0) {
		local not: list tmp - state
		gettoken not rest: not
		di as err "{bf:e.`not'} found in shock but " _cont
		di as err "{bf:`not'} is not a state variable"
		exit 198
	}
end



mata:
void buildmodel(string scalar eqs, string matrix A) {
	string vector eqs_token
	real scalar i
	eqs_token = tokens(eqs)
	for(i=1;i<=length(eqs_token);i++) {
		A[i] = st_global(eqs_token[i])
	}
}
end

