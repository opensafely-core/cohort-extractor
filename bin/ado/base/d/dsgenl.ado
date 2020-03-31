*! version 1.0.0  01may2019
program define dsgenl
	if replay() {
		Playback `0'
	}
	else {
		Estimate `0'
	}

end

program define Playback
	syntax [, *]
	
	if (`"`e(cmd)'"' != "dsgenl") {
		di as err "results for {bf:dsgenl} not found"
		exit 301
	}
	
	else {
		Display `0'
	}
end

program define Display
	syntax [, *]
	
	_get_diopts diopts, `options'
	_coef_table_header
	_coef_table, `diopts' notest
end



program Estimate, eclass

	version 16

	syntax anything [if] [in],                    ///
		EXOSTATE(string)                      ///
		OBSERved(varlist)                     ///
		[                                     ///
			UNOBSERved(string)            ///
			ENDOSTATE(string)             ///
			FROM(string)                  ///
			steadyinit(string)            ///
			CONStraints(string)           ///
			TECHnique(passthru)           ///
			SOLVE                         ///
			noDEMean                      ///
			LINEARapprox                  ///
			noIDencheck                   ///
			STEADYTOLerance(real 1e-17)   ///
			IDTOLerance(real 1e-6)        ///
			POST                          ///
			NOLOg                         ///
			LOg                           ///
		* ]

	/* defaults for optional inputs */
	if ("`linearapprox'" == "linearapprox") {
		local lineartype = "linear"
	}
	else {
		local lineartype = "loglinear"
	}
	
	if ("`solve'" == "solve") {
		local technique = "technique(nr)"
	}
	
	if ("`solve'"=="" & "`technique'"=="") {
		local technique = "technique(bfgs 10 nr)"
	}

	// iterlog 
	opts_exclusive "`log' `nolog'"
	if ("`c(iterlog)'"=="off" & "`log'"=="") {
		local log nolog 
	}
	if ("`nolog'"!="") {
		local log nolog
	}

	if (`steadytolerance' <= 0 | `steadytolerance' >= 1) {
		di as err "{bf:steadytolerance(`steadytolerance')}" _cont
		di as err " must be in (0,1)"
		exit 198
	}
	
	if (`idtolerance' <= 0 | `idtolerance' >= 1) {
		di as err "{bf:idtolerance(`idtolerance')}" _cont
		di as err " must be in (0,1)"
		exit 198
	}

	local estimate = "`observed'"
	local latent   = "`unobserved'"
	local state    = "`endostate' `exostate'"

	if ( `:word count `exostate'' != `:word count `observed'') {
		di as err "invalid syntax"
		di as err "{p 4 2 2}"
		di as err "Number of exogenous state variables "   _cont
		di as err "must equal number of observed control " _cont
		di as err "variables."
		di as err "{p_end}"
		exit 198
	}

	// display options
	_get_diopts diopts rest, `options' `technique'

	// optimize options
	_parse_optimize_options, `rest' `log' 
	local mlopts  = s(mlopts)
	local vcetype = s(vce)
	if ("`s(rest)'" != "") {
		di as err "option {bf:`s(rest)'} not allowed"
		exit 198
	}
	_parseTechnique, `technique'
	local optech = r(technique)
	
	// TS issues
	local obser = "`estimate'"
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
        qui sum `obser' if `touse', meanonly
        local N = r(N)
	
	// Names in options must be valid names
	confirm names `state' `control'
	

	/* equation list */
	tempname INITMAT
	local eqn_full = "`anything'"
	_parmlist `eqn_full'
	local kparam = r(k)
	local parmlist_0 = r(parmlist)
	local EQN = r(expr)
	local EQN = stritrim("`EQN'")
	matrix `INITMAT' = r(initmat)
	
	
	/* check validity of equations */
	_checkValid `EQN'
	local varlist_from_eqns = r(varlist)
	local neq = r(neq)

	/* prepare equations */
	_MinCleanup, eqn("`EQN'")
	local EQN = r(eqn)

	/* check user variable input against equation list */
	local control = "`latent' `estimate'"
	local varlist = "`state' `control'"

	local neq_opts: word count `varlist'
	if (`neq' != `neq_opts') {
		di as err "syntax error" 
		di as err "{p 4 4 2}"
		di as err "    Number of equations does not match" _cont
		di as err " number of variables. `neq' equations"  _cont
		di as err " specified but `neq_opts' variables specified."
		di as err "{p_end}"
		exit 198
	}

	local eqlist_orphans: list varlist_from_eqns - varlist
	local varlist_orphans: list varlist - varlist_from_eqns

	if ("`eqlist_orphans'" != "") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err " Variable `eqlist_orphans' found in" _cont
		di as err " equations but not specified in options."
		di as err "{p_end}"
		exit 198
	}

	if ("`varlist_orphans'" != "") {
		di as err "syntax error"
		di as err "{p 4 4 2}"
		di as err "    Variable `varlist_orphans' found in" _cont
		di as err " options but not specified in equations."
		di as err "{p_end}"
		exit 198
	}

	

	/* parameters: default initial values and -from- values */
	tempname param
	matrix `param' = `INITMAT' 
	_paraminit `param'          
	matrix `param' = r(param)
	if ("`from'" != "") {
		_mkvec `param', from(`from', skip) update 
	}
	matrix coleq `param' = "/structural: "
	local parmorder: colnames `param'
	
	/* prepare steady-state vector with -mkvec- */
	tempname steady
	if ("`steadyinit'" == "") {
		matrix `steady' = J(`neq', 1, 1)
	}
	else {
		_mkvec `steady', from(`steadyinit')
		matrix `steady' = `steady''
		if (`:rowsof `steady'' != `neq' ) {
			di as err "syntax error"
			di as err "{p 4 4 2}"
			di as err "    Length of {bf:steadyinit()}"
			di as err " vector must be the same as " 
			di as err "the number of variables in the model."
			di as err "The model contains `neq' "
			di as err "variables, but the "
			di as err "vector has length "
			di as err  `:rowsof `steady'' "."
			di as err "{p_end}"
			exit 198
		}
	}
	
	/* set up shock */
	local shock: list exostate - endostate  
	local shocklist ""
	foreach s of local shock {
		local shocklist "`shocklist' sd(e.`s') "
	}
	
	/* append parameter vector with sd parameters and stripe */
	tempname aux allparm1 allparm2 
	local kaux : word count `shock'
	matrix `aux' = J(1,`kaux',1)
	matrix colnames `aux' = `shocklist'
	matrix coleq `aux' = /
	matrix `allparm1' = (`param', `aux')

	
	/* update sd params with starting values in -from- */
	matrix `allparm2' = `allparm1'	
	_mkvec `allparm2', from(`from') update
	local allparnames: colnames `allparm2'

	/* finally, build constraints; this block destroys allparm1 */
	if ("`constraints'" != "") {
		tempname Vtemp T a C 
		matrix `Vtemp' = `allparm1''*`allparm1'
		ereturn post `allparm1' `Vtemp'
		makecns `constraints'
		matcproc `T' `a' `C'
	}
	
	/* simple constraints of the form {param}=val override -from-  */
	if ("`constraints'" != "") {
		_ParamFromCns, param("`allparm2'") cns("`C'")
		matrix `allparm2' = r(init)
	}

	/* flags */
	local solveflag = 0
	if ("`solve'" == "solve") {
		local solveflag=1
	}
	
	local loglinflag = 0
	if ("`lineartype'" == "loglinear") {
		local loglinflag = 1
	}
	
	local debugflag = 0
	if ("`debug'" == "debug") {
		local debugflag = 1
	}
	
	local idflag = 1
	if ("`idencheck'" == "noidencheck")  {
		local idflag = 0
	}

	local demeanflag = 1
	if("`demean'" == "nodemean")  {
		local demeanflag = 0
	}
	local postflag=0
	if ("`post'"=="post") {
		local postflag=1
	}

	/* build Mata functions holding the model */
	_PrepforMata `EQN', vl(`varlist') pl(`parmlist_0') type(static)
	local eqlist_static = r(expr)
	_PrepforMata `EQN', vl(`varlist') pl(`parmlist_0') type(dynamic)
	local eqlist_dynamic = r(expr)

	local neq: word count `varlist'
	local nk:  word count `state'
	tempfile stafile dynfile
	_BuildMataFn `eqlist_static',  base("`stafile'") type(sta) neq(`neq')
	_BuildMataFn `eqlist_dynamic', base("`dynfile'") type(dyn) neq(`neq')
	qui do `"`stafile'"'.
	qui do `"`dynfile'"'.
	
	
	/* debug */
	if ("`debug'"  != "") {
		disp "stafile is `stafile'"
		cat `stafile'
		disp _n
		disp "dynfile is `dynfile'"
		cat `dynfile'
		mata: mata desc
	}

	/* confirm the model can be complex-evaluated           */
	/* set derivtype based on the outcome                   */
	/* if model cannot be real-evaluated, clean up and exit */
	capture mata: _check_complex(&__dsgefn_sta(), "`allparm2'", `neq')
	if (_rc) {
		local derivtype "real"
		local stencil 7
		capture mata: _check_real(&__dsgefn_sta(), "`allparm2'", `neq')
		if (_rc) {
			di as err "equation invalid"
			di as err "{p 4 4 2}"
			di as err "Unable to evaluate model equations."
			di as err "{p_end}"
			mata: mata drop __dsgefn_sta()
			mata: mata drop __dsgefn_dyn()
			exit 498
		}
	}
	else {
		local derivtype "complex"
		local stencil "."
	}

	tempname b V 
	matrix `b' = `allparm2'
	matrix `V' = `allparm2''*`allparm2'

	tempname gx hx eta ll grad gx_deriv hx_deriv sh_deriv ///
		 converged V_rank ic ilog st_deriv eig        ///
		 k_stable Vm ident_optim rc

	local ereturn_names `gx' `hx' `eta'  `ll' `grad'      ///
			    `gx_deriv' `hx_deriv' `sh_deriv'  ///
			    `converged' `V_rank' `ic' `ilog'  ///
			    `st_deriv' `eig' `k_stable' `Vm'  ///
			    `ident_optim' `rc'

	// Mata entry point
	cap nois mata: dsge_fo_entry(&__dsgefn_sta(),    ///
		&__dsgefn_dyn(),                         ///
		"`touse'",                               ///
		"`steady'",                              ///
		"`allparm2'",                            ///
		"`allparnames'",                         ///
		"`state'",                               ///
		"`control'",                             ///
		"`estimate'",                            ///
		"`shock'",                               ///
		`stencil',                               ///
		`idtolerance',                           ///
		`loglinflag',                            ///
		`solveflag',                             ///
		`idflag',                                ///
		`demeanflag',                            ///
		`steadytolerance',                       ///
		"`C'",                                   ///
		`mlopts',                                ///
		"`vcetype'",                             ///
		"`derivtype'",                           ///
		`debugflag',                             ///
		`postflag',                              ///
		"`b'",                                   ///
		"`V'",                                   ///
		"`ereturn_names'")

	// clean up
	mata: mata drop __dsgefn_sta()
	mata: mata drop __dsgefn_dyn()
	if (_rc!=0) {
		error _rc
	}

	// stripes
	foreach v of local state {
		local ffstate = "`ffstate' F.`v'"
	}
	matrix colnames `gx' = `state'
	matrix rownames `gx' = `control'
	matrix colnames `hx' = `state'
	matrix rownames `hx' = `ffstate'
	matrix rownames `steady' = `state' `control'
	matrix colnames `steady' = steady
	matrix colnames `eta' = `shock'
	matrix rownames `eta' = `state'
	
	local stripe: colfullnames `allparm2'
	matrix colnames `b' = `stripe'
	matrix rownames `V' = `stripe'
	matrix colnames `V' = `stripe'

	_label_eigenvalues `eig' `k_stable'
	
	// a few more return objects
	local k_state:    word count `state'
	local k_observed: word count `estimate'
	tempname k_eq k_b
	scalar `k_eq' = `:word count `shock'' + 1
	scalar `k_b'  = `:colsof `b''
	local hasmissing = matmissing(`gx') + matmissing(`hx')

	if (`ident_optim'==1) {
		local eident = "failed"
	}
	else if (`ident_optim'==0) {
		local eident = "passed"
	}
	else {
		local eident = "skipped"
	}

	// gather up returned results and process them
	ereturn clear
	
	if ("`solve'" == "solve") {
		ereturn post `b' `V', obs(`N') esample(`touse')
	}
	else {
		ereturn post `b' `V' `C', obs(`N') esample(`touse')
	}
	if ("`vcetype'"=="robust" & "`solve'"=="") {
		ereturn matrix V_modelbased = `Vm'
	}

	tempname V_shocks
	matrix `V_shocks' = `eta'*`eta''

	// pclass
	local k_shock: word count `shock'
        _b_pclass PCDEF : default
        _b_pclass PCAUX : aux
        tempname pclass
        matrix `pclass' = e(b)
        local dim = colsof(`pclass')
        matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
        local pos = `dim' - `k_shock' + 1
        matrix `pclass'[1,`pos'] = J(1, `k_shock', `PCAUX')
        ereturn hidden matrix b_pclass `pclass'
	
	if      ("`vcetype'"=="oim")      local vcetype OIM
	else if ("`vcetype'" == "robust") local vcetype Robust

	ereturn scalar ll          = `ll'
	ereturn scalar N           = `N'
	ereturn scalar rc          = `rc'
	ereturn matrix gradient    = `grad'
	ereturn matrix policy      = `gx'
	ereturn matrix transition  = `hx'
	ereturn matrix shock_coeff = `eta'
	ereturn matrix steady      = `steady'
        ereturn local method      "gf0"
	ereturn local opt         "optimize"
        ereturn local marginsok 
        ereturn local marginsnotok _ALL
	ereturn scalar k_eq       = `k_eq'
        ereturn scalar tmin       = `tmin'
        ereturn scalar tmax       = `tmax'
        ereturn local tvar        = "`tvar'"
        ereturn local tmins       = "`tmins'"
        ereturn local tmaxs       = "`tmaxs'"
	ereturn local tsfmt       = "`tsfmt'"
	ereturn local control     = "`latent' `estimate' " 
	ereturn local state       = "`state'"
	ereturn local shock       = "`shock'"
	ereturn local observed    = "`estimate'"
	ereturn local depvar      = "`estimate'"
	ereturn local vcetype     = "`vcetype'"
	ereturn local vce         = lower("`vcetype'")
	ereturn local technique   = "`optech'"
	ereturn scalar k_state    = `k_state'
	ereturn scalar k_control  = `:word count `control''
	ereturn scalar k_shock    = `:word count `exostate''
	ereturn scalar k_observed = `k_observed'
	ereturn scalar k_dv       = `k_observed'
	ereturn scalar k          = `k_b'
	ereturn scalar ic         = `ic'
	ereturn scalar k_stable   = `k_stable'
	ereturn scalar converged  = `converged'
	ereturn scalar rank       = `V_rank'
	ereturn matrix ilog       = `ilog'
	ereturn matrix eigenvalues = `eig'
	ereturn local  idencheck   = "`eident'"
	if ("`vcetype'"=="Robust") {
		ereturn hidden local crittype = "log pseudolikelihood"
	}
	else {
		ereturn hidden local crittype = "log likelihood"
	}
	ereturn local estat_cmd "dsgenl_estat"
	ereturn local predict   "dsgenl_p"
	ereturn hidden matrix po_deriv = `gx_deriv'
	ereturn hidden matrix tr_deriv = `hx_deriv'
	ereturn hidden matrix sh_deriv = `sh_deriv'
	ereturn hidden matrix st_deriv = `st_deriv'
	ereturn hidden matrix V_shocks = `V_shocks'
	ereturn local title            = "First-order DSGE model"
	ereturn local cmdline          = "`anything'"
	ereturn hidden local approxtype = "`lineartype'"
	ereturn hidden local solvetype = "firstorder"
	ereturn local cmd              = "dsgenl"

	Display, `diopts'

	if ("`idencheck'"=="noidencheck") {
		di as txt "Note: Skipped identification check."
	}

	if ("`mlopts'" != "(-1,-1,0,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0)") {
		local max_note "; maximization options ignored."
	}
	else {
		local max_note "."
	}
	if ("`solve'" == "solve") {
		di as txt "{p 0 6 2}"
		di as txt "Note: Model solved at specified"
		di as txt " parameters`max_note'"
		di as txt "{p_end}"
	}

	if (`hasmissing' > 0) {
		di as txt "{p 0 9 2}"
		di as txt "Warning: Model cannot be solved at " ///
			  "current parameter values. Current "  ///
			  "values imply a model that is not "   ///
			  "saddle-path stable."
		di as txt "{p_end}"
	}

	if ("`eident'"=="failed") {
		di as txt "{p 0 6 2}"
		di as txt "Note: Parameters not identified at reported values"
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

/* Clean up user-supplied expressions */
program define _MinCleanup, rclass
	syntax , eqn(string)
	
	local result = "`eqn'"
	local result = subinstr("`result'", "=", " = ", .)
	local result = subinstr("`result'", "*", " * ", .)
	local result = subinstr("`result'", "+", " + ", .)
	local result = subinstr("`result'", "-", " - ", .)
	local result = subinstr("`result'", "/", " / ", .)
	local result = subinstr("`result'", "(", "( ", .)
	local result = subinstr("`result'", ")", " )", .)
	local result = subinstr("`result'", "^", " ^ ", .)
	local result = subinstr("`result'", "F.", "f.", .)
	local result = stritrim("`result'")
	
	return local eqn = "`result'"	
end


program define _PrepforMata, rclass
	syntax anything, type(string) vl(string) pl(string)

	/* replace parameters */
	local i = 1
	foreach param in `pl' {
		local pi = "{" + "`param'" + "}"
		local anything = subinstr("`anything'", "`pi'", "p[`i']", .)
		local i = `i'+1
	}

	/* replace future variables */
	local i = 1
	foreach v in `vl' {
		local vi = "f." + "`v'"
		local anything =  ///
			subinword("`anything'", "`vi'", "v[`i']", .)
		local i = `i'+1
	}

	/* replace current variables  */
	if ("`type'"=="static") {
		local i = 1
	}
	else if ("`type'" == "dynamic") {
		local vcount: word count `vl'
		local i = `vcount' + 1
	}

	foreach v in `vl' {
		local anything = ///
			subinword("`anything'", "`v'", "v[`i']", .)
		local i = `i'+1
	}

	return local expr = "`anything'"
end

program define _BuildMataFn
	syntax anything, base(string) type(string) [neq(integer 0)]

	local i = 1

	qui file open myfile using `"`base'"', write replace
	file write myfile "mata:" _n
	file write myfile "numeric colvector __dsgefn_`type'" 
	file write myfile "(numeric colvector v, numeric colvector p) {" _n
	file write myfile "    numeric vector res" _n
	file write myfile "    if (eltype(v)==	"
	file write myfile `""real""'
	file write myfile "')"
	file write myfile " res    = J(`neq',1,.)" _n
	file write myfile "    else res    = J(`neq',1,0+0i)" _n

	while ("`anything'" != "") {
		gettoken eq anything: anything, match(paren) bind
		local eq = subinstr("`eq'", "=", "- (",.)
		file write myfile "    res[`i'] = `eq' )" _n
		local i = `i'+1
	}

	file write myfile "    return(res)" _n
	file write myfile "}" _n
	file write myfile "end" _n
	file write myfile "exit"
	file close myfile
end





program define _checkValid, rclass

	syntax anything
	
	local rest = "`anything'"
	local varlist = ""
	local count = 0
	while ("`rest'" != "") {
		gettoken first rest: rest, match(paren) bind
		
		local tocheck = subinstr("`first'", "=", "- (", 1)
		local tocheck = "r: " + "`tocheck'" + " )"
		
		tempname rc
		scalar `rc' = 0
		mata: _nldsge_check_eqparse("`tocheck'", "`rc'")
		local eqvlist = "`eqvlist'"
		
		if (`rc' > 0) {
			di as err "equation invalid"
			di as err "    error in equation (`first')"
			exit 198
		}
		else if (`rc' < 0) {
			di as err "equation invalid"
			di as err "{p 4 4 2} "
			di as err "    Time-series operators other" 
			di as err " than F. not allowed in equation" 
			di as err "{p_end}"
			di as err "{p 4 4 2} "
			di as err " (`first')"
			di as err "{p_end}"
			exit 198  

		}
		local varlist = "`varlist' `eqvlist'"
		local count = `count' + 1
	}
	local varlist: list uniq varlist
	return local varlist "`varlist'"
	return scalar neq = `count'
end


/* minimal complex check */
mata:
void _check_complex(pointer(function) f, 
	string scalar parmloc, 
	real scalar nvar)
{
	real vector param
	complex vector x0
	param = st_matrix(parmloc)'
	x0 = J(nvar, 1, 1) :+ 1i
	
	(*f)(x0, param)
}
end



/* Parameter initialization */
program define _paraminit, rclass
	syntax anything

	local k: colsof `anything'
	
	local start 0.2
	forvalues i = 1/`k' {
		if (`anything'[1,`i'] == 0) {
			matrix `anything'[1,`i'] = `start'+`i'/100
		}
	}
	return matrix param = `anything'
	
	
end

program define _ParamFromCns, rclass
	syntax [, param(string) cns(string)]
	
	mata: _mf_ParamFromCns("`param'", "`cns'")
	return matrix init = `param'
end

program define _parseTechnique, rclass
	syntax [, technique(string)]

	return local technique = "`technique'"
end

mata:
void _mf_ParamFromCns(string scalar param_loc, string scalar cns_loc)
{
	real matrix cns, C
	real vector param, c
	real scalar i, nzloc

	param = st_matrix(param_loc)
	cns   = st_matrix(cns_loc)
	
	C = cns[.,1..cols(cns)-1]
	c = cns[., cols(cns)]

	for (i=1; i <= rows(C); i++) {
		if (_zeroCount(C,1) == cols(C)-1) {
			nzloc = _nzloc(C, i)
			param[1, nzloc] = c[i] / C[i,nzloc] 
		}
	}
	
	st_replacematrix(param_loc, param)
}

real scalar _zeroCount(real matrix A, real scalar i)
{
	real scalar nc, j, count
	if (i > rows(A)) exit(error(498))
	
	nc = cols(A)
	count = 0
	for(j=1; j <= nc; j++) {
		if (A[i, j]==0) count++
	}
	return(count)
}

real scalar _nzloc(real matrix A, real scalar i)
{
	real scalar j
	
	j=1
	while (A[i,j]==0) j++ 
	return(j)
}

end





