*! version 1.11.1  11oct2018
program _xtme_estimate, sortpreserve eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local iterprolog1 iterprolog(glmixed_b0r)
		local iterprolog2 iterprolog(glmixed_b0)
		local ndami ndami
	}
	else {
		local iterprolog1 preiterpgm(glmixed_b0r)
		local iterprolog2 preiterpgm(glmixed_b0)
		local ndami stepalways
	}
	
	version 10
	
// Estimation engine for xtmelogit/xtmepoisson
	gettoken model 0 : 0
	
	local globopts `"Level(cilevel) PPARSEPOST"'
	local globopts `"`globopts' BINomial(string) MLe"'
	local globopts `"`globopts' INTPoints(string)"'
	local globopts `"`globopts' RETOLerance(real 1e-8) "'
	local globopts `"`globopts' REITERate(integer 50)"'
	local globopts `"`globopts' RESHUFFLE(integer 3)"'
	local globopts `"`globopts' noGRoup noHEADer ESTMetric"'
	local globopts `"`globopts' noLRtest NOLOg LOg"'
	local globopts `"`globopts' noFETable noRETable"'
	local globopts `"`globopts' MATAONLY LLONLY"'
	local globopts `"`globopts' OFFset(varname numeric)"'
	local globopts `"`globopts' EXPosure(varname numeric)"'
	local globopts `"`globopts' LAPlace FROM(string) or IRr"'
	local globopts `"`globopts' REFINEopts(string) matsqrt matlog"'
	local globopts `"`globopts' VARiance STDDEViations"'
	
// undocumented, for use by predict and estat

	local globopts `"`globopts' grouponly getblups(string) reseok"'
	local globopts `"`globopts' getblupses(string) getscores(string)"'

// mlopts

	local mlopts `"NONRTOLerance NRTOLerance(string)"'
	local mlopts `"`mlopts' TRace GRADient HESSian showstep"'
	local mlopts `"`mlopts' TECHnique(string) SHOWNRtolerance"'
	local mlopts `"`mlopts' ITERate(string) TOLerance(string)"'
	local mlopts `"`mlopts' LTOLerance(string) GTOLerance(string)"'
	local mlopts `"`mlopts' DIFficult dots depsilon(passthru) showh"'

	// diopts
	local diopts	vsquish			///
			ALLBASElevels		///
			NOBASElevels		/// [sic]
			BASElevels		///
			noCNSReport		///
			FULLCNSReport		///
			noOMITted		///
			noEMPTYcells		///
			NOFVLABEL		///
			fvwrap(passthru)	///
			fvwrapon(passthru)	///
			cformat(passthru)	///
			pformat(passthru)	///
			sformat(passthru)	///
			NOLSTRETCH		///
			COEFLegend		///
			SELEGEND

	local globallow `"`globopts' `mlopts' `diopts'"'

// Grab command name

	if "`model'" == "logistic" {
		local cmdname xtmelogit
	}
	else {
		local cmdname xtmepoisson
	}

// parse

	_parse expand cmd glob : 0 , common(`globallow')

	forvalues k = 1/`cmd_n' {			// Parse global if/in
	                local cmds `"`cmds' `"`cmd_`k''"'"'
        }
	_mixed_parseifin `cmdname' `=`cmd_n'+1' `cmds' `"`glob_if' `glob_in'"'

	forvalues k=0/`=`cmd_n'-1' {			// Parse subcmds
		_mixed_parsecmd `cmdname' `k' `cmd_`=`k'+1''
		`s(msg)'
		local allnms `allnms' `levnm_`k'' `varnames_`k''
	}
	if "`depname'" == "" {
		di as err "dependent variable not specified"
		exit 198
	}
	local allnms `allnms' `depname'

	if `=strpos(`"`depname'"', ".")' {
		di as err "{p 0 6 2}time-series operators not allowed "
		di as err "within the dependent variable{p_end}"
		exit 101
	}

	local 0 `"`glob_if' `glob_in'"'			// set estimation sample
	syntax [if] [in]
	marksample touse
	local allnms : subinstr local allnms "_all" "" , word all
	markout `touse' `allnms' , strok
							
	local 0 `", `glob_op'"'				// Get model
	syntax [ , BINomial(string) *]
	local glob_op `"`options'"'

	SetModel `"`model'"' `"`binomial'"'
	if "`dist'" == "logistic" & "`bindem'" != "" & "`bincon'" == "" {
		markout `touse' `bindem'
	}

// Handle offset/exposure

	local 0 `", `glob_op'"'
	syntax [, EXPosure(varname numeric) OFFset(varname numeric) *]
	local glob_op `"`options'"'

	tempvar off
	if "`offset'" != "" | "`exposure'" != "" {
		if "`offset'" != "" & "`exposure'" != "" {
			di as err "offset() and exposure() may not be combined"
			exit 198
		}
		if "`offset'" != "" {
			markout `touse' `offset'
		 	qui gen double `off' = `offset' if `touse'
		}
		if "`exposure'" != "" {
			if "`dist'" == "logistic" {
				di as err "exposure() not allowed with " _c
				di as err "logistic model"
				exit 198
			}
			cap assert `exposure' > 0 if `touse'
			if _rc {
				di as err "exposure() must be positive-valued"
				exit 198
			}
			markout `touse' `exposure'
			qui gen double `off' = ln(`exposure') if `touse'
		}
		local myoff `offset'	// Otherwise, get wiped out later
		local myexp `exposure'
	}
	else {
		qui gen byte `off' = 0 if `touse'
	}

// Check Response

	CheckResponse "`touse'" "`dist'" "`depname'" "`bindem'" "`bincon'"
	local zeron `s(zeron)'
	if "`zeron'" != "" {		// logistic response not 0/1
		tempvar ynonzero
		qui gen byte `ynonzero' = (`depname' != 0) if `touse'
	}

	if "`bincon'" != "" {
		tempvar denom
		qui gen long `denom' = `bindem' if `touse'
		local bindem `denom'
	}

	tempvar one					// processing macs
	qui gen byte `one' = 1 if `touse'
	local lev_beg 0
	local last_levnm "______"
	tempname lev_nvars sublevels
	if (`cmd_n' > 1)  matrix `sublevels' = J(1,`=`cmd_n'-1', 0)

	forvalues k=0/`=`cmd_n'-1' {			// reconcile levels
		local k1 = `k' - 1			// and sublevels

		if "`levnm_`k''" != "`last_levnm'" {

			if `k' > 0 {			// level var repeated
				if 0`:list levnm_`k' in levnms' {	
					if `"`levnm_`k''"' != `""' {
						RepeatedLevelError `levnm_`k''
						exit 198
					}
				}
				if `=`:list sizeof levnm_`k''' > 1 {
					di as err "level {bf:`levnm_`k''} " /*
						*/ "incorrectly specified"
					exit 198
				}
				local levnms `levnms' `levnm_`k''

				_mixed_fixupconstant `lev_beg' `k1' `last_const'
				_mixed_setsublevels  `lev_beg' `k1' `sublevels'
				`vv' ///
				_mixed_rmcollevel `lev_beg' `k1' `depname'  ///
					   "`lev_constant'" "`lev_isfctrs'" ///
					   "`collin_`k1''" `touse'	    ///
					   `lev_varnames'
			}

			local lev_varnames `""`varnames_`k''""'
			if "`constant_`k''" != "" {
				local lev_constant 0
			}
			else {
				local lev_constant 1
			}
			local last_const   = cond("`constant_`k''"=="", `k', -1)
			local lev_isfctrs  `isfctr_`k''
			local lev_beg      `k'
		}
		else {
			local lev_varnames `"`lev_varnames' "`varnames_`k''""'
			local lev_isfctrs `lev_isfctrs' `isfctr_`k''

			if "`constant_`k''" != "" {
				local lev_constant `lev_constant' 0
			}
			else {
				local lev_constant `lev_constant' 1
			}
			if "`constant_`k''" == "" {
				local last_const = `k'
			}
		}

		local last_levnm `levnm_`k''
		local kh `k'
	}

	_mixed_fixupconstant `lev_beg' `kh' `last_const'
	_mixed_setsublevels  `lev_beg' `kh' `sublevels'
	`vv' ///
	_mixed_rmcollevel `lev_beg' `kh' `depname' "`lev_constant'"	///
		   "`lev_isfctrs'" "`collin_`kh''" `touse' `lev_varnames'

	tempname fctrlevs noomit

	forvalues k=0/`=`cmd_n'-1' {
		if `isfctr_`k'' {			// create factors
			tempvar ifctr
			qui egen long `ifctr' = group(`varnames_`k'') if `touse'
			label variable `ifctr'				///
			      `"R.`:subinstr local varlist_`k' " " " R."'"'
			local varlist_`k' `ifctr'

			sum `ifctr' , meanonly
			matrix `fctrlevs' = (nullmat(`fctrlevs'), r(max))
			local bnames_`k' `varnames_`k''
		}
		else if `k' != 0 {			// handle ts ops
			fvrevar `varnames_`k'' if `touse', tsonly
			local varlist_`k' `r(varlist)'
			fvrevar `varnames_`k'', list
			local bnames_`k' `r(varlist)'
		}

		if `k' == 0 {
			if "`varnames_0'" != "" {
				NoOmit `varnames_0'
				local omitted `r(omitted)'
				matrix `noomit' = r(noomit)
				fvrevar `varnames_0' if `touse'
				local full_list `r(varlist)'	
				local cols = colsof(`noomit')
				forvalues i = 1/`cols' {
					if `noomit'[1,`i'] {
					  local var : word `i' of `full_list'
					  local red_list `red_list' `var'
					}
				}		
				local varlist_0 `red_list'
				local emptylist 0
			}
			else {
				local varlist_0 `varnames_0'
				local emptylist 1
			}
			local varll_0 `varlist_0'
			fvrevar `varnames_0' if `touse', list
			local bnames_0 `r(varlist)'
		}
		if "`constant_`k''" == "" {		// handle constants
			local varlist_`k' `varlist_`k'' `one'
			local varnames_`k' `varnames_`k'' _cons
		}

		if `k' > 0 & !`isfctr_`k'' {
			foreach var of local varlist_`k' {
				matrix `fctrlevs' = (nullmat(`fctrlevs'), 1)
			}
							// Fixup covariance
			if (`:list sizeof varlist_`k'' + 		///
			    ("`constant_`k''"=="")) == 1 {
				local cov_`k' = "identity"
			}
		}
	}

	local depvar `depname'

	foreach nm of local levnms {			// encode levels
		tempvar level 
		if ("`nm'" == "_all")  local nm `one'
		local nms `nms' `nm'
		qui egen long `level' = group(`nms') if `touse'
		local levelvars `levelvars' `level'
	}

	forvalues k=1/`=`cmd_n'-1' {		// check for empty levels
		if "`varlist_`k''" == "" {
			if !`k' { 
				local lab fixed effects
			}
			else {
				local lab group `levnm_`k'':
			}
			di as error "`lab' equation empty"
			exit 102
		}
	}

	// global options are in glob_op  -- your parsing goes here
	local 0 `", `glob_op'"'
	syntax [ , `globopts' *]
	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local 0 `", `mlopts'"'
	syntax [, technique(string) COLlinear *]
	if `:list posof "bhhh" in technique' {
		di as err "option technique(bhhh) not allowed"
		exit 198
	}
	local mlopts `"technique(`technique') `options'"'

// error checking options goes here
	
	if "`variance'"!="" & "`stddeviations'"!="" {
	    di as err "variance and stddeviations may not be specified together"
	    exit 198
	}
	local var_opt `variance' `stddeviations'
	if "`var_opt'" != "" & "`estmetric'" != "" {
		di as err "`var_opt' and estmetric may not be specified together"
		exit 198
	}

	if "`or'" != "" & "`irr'" != "" {
		di as err "only one of or or irr are allowed"
		exit 198
	}

	if "`or'" != "" {
		if "`model'" != "logistic" {
			di as err "or not allowed"
			exit 198
		}
	}

	if "`irr'" != "" {
		if "`model'" != "poisson" {
			di as err "irr not allowed"
			exit 198
		}
	}

	if "`matlog'" != "" & "`matsqrt'" != "" {
		di as err "{p 0 6 2}at most one of matlog and matsqrt may "
		di as err "be specified{p_end}"
		exit 198
	}

	if "`pparsepost'" != "" {
		ereturn clear
		foreach mac in depvar depname cmd_n {
			ereturn local `mac' ``mac''
		}
		forvalues l = 0/`=`cmd_n'-1' {
			foreach mac in levnm isfctr cov	k sublevels	///
				       constant varlist varnames {
				ereturn local `mac'_`l' ``mac'_`l''
			}
		}
		exit
	}
							// set up 

// Check for no random effects

	if `cmd_n' == 1 {
		di as err "no random-effects structure specified"
		exit 198
	}

	if `"`varll_0'"' == "" & "`constant_0'" != "" {
		di as err "fixed-effects specification is empty"
		exit 102
	}

	tempvar nn
	qui gen `c(obs_t)' `nn' = _n if `touse'
	gsort -`touse' `levelvars' `nn'

	tempname obs re_n beps bmaxiter bshuffle
	qui count if `touse'
	scalar `obs' = r(N)
	scalar `re_n' = `cmd_n' - 1
	scalar `beps' = `retolerance'
	scalar `bmaxiter' = `reiterate'
	scalar `bshuffle' = `reshuffle'

	cap assert scalar(`beps') > 0 
	if _rc {
		di as err "retolerance() must be positive"
		exit 411
	}
	cap assert scalar(`bmaxiter') > 0 
	if _rc {
		di as err "reiterate() must be positive"
		exit 411
	}
	cap assert scalar(`bshuffle') >= 0 
	if _rc {
		di as err "reshuffle() must be nonnegative"
		exit 411
	}

	local views noviews

// Check for factor variables. 

	local fvars 0 
	local cf = colsof(`fctrlevs')  
	forvalues i = 1/`cf' {
		if `fctrlevs'[1,`i'] > 1 {
			local fvars 1 
		}
	}
	if `fvars' & "`laplace'" == "" & `"`intpoints'"' == "" {
		local laplace laplace
		di as txt _n "{p 0 6 2}note: factor variables specified; "
		di as txt `"option {help `cmdname'##laplace:laplace} "'
		di as txt "assumed{p_end}"
	}

// Get base quadrature points

	local levels : word count `levelvars'

	forvalues i = 1/`levels' {
		tempname qmat`i'
		local qnames `qnames' `qmat`i''
	}
	IntPoints `"`intpoints'"' `"`qnames'"' `levels' `laplace'
	local intpoints `s(intpoints)'
	local laplace `s(laplace)'

// Set up mata structure 

	mata: _xtgm_setup_st()

// obtain re estimates if specified and exit

	if `"`getscores'"' != "" {
		GetScores `"`getscores'"' `touse'
		exit
	}

	if "`reseok'" == "" & `"`getblups'"' != "" & `"`getblupses'"' != "" {
		di as err "getblups() and getblupses() may not " _c
		di as err "be specified together"
		exit 198
	}

	if `"`getblups'"' != "" | `"`getblupses'"' != "" {
		if `"`getblups'"' != "" {
			CheckBlups `getblups'
			SetBlupMats
			GetBlups "" `getblups'
		}
		if `"`getblupses'"' != "" {
			CheckBlups `getblupses'
			SetBlupMats se
			GetBlups "se" `getblupses'
		}
		exit
	}

	tempname theta err binit init h gamma init0

// Get starting values

	if("`dist'" == "logistic") {
		if("`bindem'" != "") {
			`vv' ///
			cap glm `depname' `varll_0' if `touse', ///
				`constant_0' fam(bin `bindem') offset(`off')
			local rc = _rc

		}
		else {
			`vv' ///
			cap logit `depname' `varll_0' if `touse', /// 
				`constant_0' offset(`off')
			local rc = _rc
		}
	}
	else {
		`vv' ///
		cap poisson `depname' `varll_0' if `touse', `constant_0' ///
			offset(`off')
		local rc = _rc
	}
	if `rc' {
		di as err "{p 0 4 2}error obtaining starting values; try "
		di as err "fitting a marginal model in order to diagnose "
		di as err "the problem{p_end}"
		exit 459
	}	
	local ll_0 = e(ll)
	mat `binit' = e(b)
	local fdim = colsof(`binit')
	if !`emptylist' {
		local fdim_noomit = colsof(`noomit') + ///
		cond("`constant_0'"=="",1,0)
	}
	else {
		local fdim_noomit = `fdim'
	}

// Starting values for theta

	// Zero matrix becomes the identity when exponentiated

	mata: _xtgm_ml_eqlist_st("eqlist")
	local rdim : word count `eqlist'
	local tdim = `fdim' + `rdim'

	mat coleq `binit' = eq1
	local eqnames : colfullnames `binit'
	forvalues i = 1/`rdim' {
		local w : word `i' of `eqlist'
		local w : subinstr local w "/" ""
		if substr(`"`w'"',1,1) == "(" {
			gettoken par w : w, parse("()") bind
			gettoken w colon : w, parse(":")
		}
		local eqnames `eqnames' `w':_cons
	}

// Start -ml-

	if `"`from'"' != "" {
		tempname myfrom gamma0
if $XTM_ver < 10.1 {
		confirm matrix `from'
		mat `myfrom' = `from'
		local cf = colsof(`from')
		if rowsof(`from') > 1 {
			di as err "from() matrix must be a row vector"
			exit 503
		}
		if `cf' > `tdim' {
			di as err "from() matrix is too large"
			exit 503
		}
		if `cf' < `tdim' { 		// fill out the rest with 0's
			mat `myfrom' = 	`myfrom', J(1,`tdim'-`cf',0)
		}	
}
else {
		_mkvec `myfrom', from(`from') colnames(`eqnames') first
}
		// Grab fixed effects estimates
		mat `binit' = `myfrom'[1, 1..`fdim']
		// Grab random effects estimates
		mat `gamma0' = `myfrom'[1, `=`fdim'+1'...]
		mata: _xtgm_gamma_to_theta_st("`theta'", "`gamma0'", "`err'") 
		if scalar(`err') {
			di as err "initial values in from() matrix " _c
			di as err "not feasible"
			exit 430
		}
		mat `init' = (`binit', `theta')
	}
	else {
		mata: _xtgm_start_st("`theta'")
		mat `init' = (`binit', `theta')
	}
	mat `init0' = `init'

	mat `h' = J(1, `=colsof(`init')', 1)

	mata: _xtgm_estimate_re_st("`binit'", "`theta'")

	if "`llonly'" != "" {
		mata: _xtgm_glmixed_ll_st("`binit'", "`theta'")
		di _n as txt /// 
		   "Log-likelihood evaluated at starting values is " /// 
		   as res r(ll)
		ereturn scalar ll=`r(ll)'
		exit
	}

// Handle some two-stage log/nologging.

	local tlog `log' `nolog'
	local 0 `", `refineopts'"'
	syntax [, NOLOg LOg *]
	local refineopts `options'
	local refmllog `log' `nolog'
	_parse_iterlog, `refmllog'
	local reflog "`s(nolog)'"
	
	local mllog `tlog'
	_parse_iterlog, `tlog'
	local log "`s(nolog)'"
	
	if "`reflog'" != "" {
		local q1 *
	}
	if "`log'" != "" {
		local q1 *
		local q2 *
		local reflog nolog
		local refmllog nolog
	}


// Hold quadrature points fixed during steps, but change the scale

	mlopts refops, `refineopts'
	local 0 `", `refops'"'
	syntax [, technique(string) COLlinear ITERate(int 2) *]
	if `:list posof "bhhh" in technique' {
		di as err "option technique(bhhh) not allowed"
		exit 198
	}
	local refops `"technique(`technique') iter(`iterate') `options'"'
	if `iterate' > 0 {
		`q1'di as txt _n "Refining starting values: "

		`vv' ///
		ml model d0 glmixed_llr					///
			(`depname' = `varll_0', `constant_0')		///
			`eqlist',					///
			max `iterprolog1' `ndami'			///
			collinear missing nopreserve			///
			init(`init', skip copy) search(off) nowarn	///
			`refops' `refmllog'
	}

	`q2'di as txt _n "Performing gradient-based optimization: "

	tempname h
	if (`iterate' < 1) {		// no quad iterations
		mat `init' = `init0'
	}
	else {
		mat `init' = e(b)
		if ("`ndami'" == "ndami") {
			mat `h' = e(ml_scale)
			local dscale derivscale(`h')
		}
		else {
			mat `h' = e(ml_d0_s)
			local dscale dzeros(`h')
		}
	}

	tempname sinit
	mat `sinit' = `init'

// Begin -ml- iterations 

	`vv' ///
	ml model d0 glmixed_ll (`depname' = `varll_0', `constant_0')	///
		`eqlist', `iterprolog2'					///
		collinear missing nopreserve `mlopts' max		///
		init(`init', copy) search(off) `dscale' `mllog'

	local opt `e(opt)'
	local ml_method `e(ml_method)'
	local technique `e(technique)'
	local crittype `e(crittype)'
	local converged `e(converged)'
	local iter `e(ic)'

	local ll = e(ll)

// Reparameterize

	tempname newB newV 
	mata: _xtgm_reparm_est_st("`newB'", "`newV'", `fdim', "`err'")

// Post parameters

	local rc = e(rc)
	mat `gamma' = e(b)			// Old estimates
	local names: colfullnames `gamma'

	if !`emptylist' {
		mat `noomit' = (`noomit'[1,1...],J(1,`rdim',1))
		mata: _add_omitted("`newB'","`newV'","`noomit'",`omitted')
	}
	
	local k 0
	foreach v of local varnames_0 {
		local rnames `rnames' eq1:`v'
		_ms_parse_parts `v'
		if !`r(omit)' {
			local ++k
		}
	}
	local w = colsof(`gamma') 
	forvalues i = `=`k'+1'/`w' {
		local nn : word `i' of `names'
		local rnames `rnames' `nn'
	}

	`vv' ///
	mat colnames `newB' = `rnames'
	`vv' ///
	mat rownames `newV' = `rnames'
	`vv' ///
	mat colnames `newV' = `rnames'
	tempname Cns
	GetCns `Cns' k_autoCns
	_ms_op_info `newB'
	if r(tsops) {
		quietly tsset, noquery
	}
	ereturn post `newB' `newV' `Cns', depname(`depvar') ///
		esample(`touse') buildfvinfo
	_post_vce_rank
	if `:length local Cns' {
		ereturn hidden scalar k_autoCns = `k_autoCns'
	}
	ereturn scalar rc = `rc'
	if scalar(`err') {
		ereturn scalar reparm_rc = 1
	}
	else {
		ereturn scalar reparm_rc = 0
	}
	ereturn scalar k = colsof(`gamma')

// Count how many fixed effects and how many random effects

	ereturn scalar k_f = `fdim_noomit'
	ereturn scalar k_r = colsof(`gamma') - `fdim'

// Out of r.e. estimates, count how many sigmas and rhos

	local eqs : coleq `gamma'
	local k_rs 0 
	forval i = `=`fdim'+1'/`e(k)' {
		local eq : word `i' of `eqs'
		if bsubstr("`eq'",1,3) == "lns" {
			local ++k_rs
		}
	}
	ereturn scalar k_rs = `k_rs'
	ereturn scalar k_rc = e(k_r) - e(k_rs)

// Other e() results
	
	ereturn local depvar `depname'
	ereturn scalar ll = `ll'
	ereturn local method ML		// important to -lrtest-
	ereturn hidden scalar noconstant = cond("`constant_0'" == "",0,1)
	ereturn hidden scalar consonly = cond("`varll_0'"!="",0,1)
// Comparison test

	if `cmd_n' > 1 & "`lrtest'" == "" {
		ereturn scalar ll_c = `ll_0'
		ereturn scalar df_c = e(k_r)
		ereturn scalar chi2_c = 2*(e(ll) - e(ll_c))
		if e(chi2_c) < 0 {
			ereturn scalar chi2_c = 0
		}
		ereturn scalar p_c = chi2tail(e(df_c),e(chi2_c))
		if e(df_c) == 1 & e(chi2_c) > 1e-5 {
			ereturn scalar p_c = 0.5*e(p_c)
		}
	}

// Data resorted in what follows

	SaveGroupInfo `"`levelvars'"'

	ereturn hidden local crittype `crittype'
	ereturn local marginsnotok	stdp		///
					Pearson		///
					Deviance	///
					Anscombe	///
					REFfects	///
					RESEs
	ereturn local marginsdefault	predict(xb)
	if ("`dist'" == "logistic") {
		if $ME_QR {
			ereturn local cmd meqrlogit
			ereturn local predict meqrlogit_p
			ereturn local estat_cmd meqrlogit_estat
		}
		else {
			ereturn local cmd xtmelogit
			ereturn local predict xtmelogit_p
			ereturn local estat_cmd xtmelogit_estat
		}
		ereturn local model logistic
		ereturn hidden local iccok "ok"
	}
	else {
		if $ME_QR {
			ereturn local cmd meqrpoisson
			ereturn local predict meqrpoisson_p
			ereturn local estat_cmd meqrpoisson_estat
		}
		else {
			ereturn local cmd xtmepoisson
			ereturn local predict xtmepoisson_p
			ereturn local estat_cmd xtmepoisson_estat
		}
		ereturn local model Poisson
	}
	ereturn local opt `opt'
	ereturn local ml_method `ml_method'
	ereturn local technique `technique'
	ereturn local title Mixed-effects `e(model)' regression
	ereturn local fbnames `bnames_0'
	
	if $ME_QR ereturn hidden scalar mecmd = 0
	else ereturn hidden scalar mecmd = 0

	forvalues k=1/`=`cmd_n'-1' {
		if `isfctr_`k'' {
			local varnames_`k'				///
			      `"R.`:subinstr local varnames_`k' " " " R."'"'
		}
		local zvars     `"`zvars' `varnames_`k''"'
		local vartypes  `"`vartypes' `=proper("`cov_`k''")'"'
		local lvnms     `"`lvnms' `levnm_`k''"'
		local dimz	`"`dimz' `:list sizeof varnames_`k''"'
		local rbnames	`"`rbnames' `bnames_`k''"'
	}
	local rbnames : list uniq rbnames
	ereturn local revars `zvars'
	ereturn local vartypes `vartypes'
	ereturn local ivars `lvnms'
	ereturn local redim `dimz'
	ereturn local rbnames `rbnames'
	ereturn local n_quad `intpoints'
	ereturn local laplace `laplace'

	if "`varnames_0'" == "_cons" {
		ereturn scalar chi2 = . 
		ereturn scalar p = . 
		ereturn scalar df_m = 0
	}
	else {
		if "`model'" == "logistic" {
			local cmdname xtmelogit
		}
		else {
			local cmdname xtmepoisson
		}
		_prefix_model_test `cmdname'
	}
	if "`myoff'" != "" {
		ereturn local offset `myoff'
	}
	if "`myexp'" != "" {
		ereturn local offset ln(`myexp')
		ereturn local exposurevar `myexp'
	}
	ereturn local chi2type Wald
	ereturn local binomial = cond("`bincon'"!="", "`bincon'", "`bindem'")
	ereturn scalar rc = cond(`converged',0,430)
	ereturn scalar converged = `converged'
	ereturn scalar ic = `iter'

	SignEstSample
	
	// return e(b_sd), e(V_sd), and e(b_pclass)
	_xtme_estatsd
	
	_xtme_display, level(`level') `lrtest' ///
		`var_opt' `group' `header' `estmetric' ///
		`grouponly' `fetable' `retable' `or' `irr' `diopts'
	exit
end

program GetCns
	version 11
	args Cns autoCns
	if "`e(Cns)'" == "matrix" {
		version 11: matrix `Cns' = e(Cns)
		c_local `autoCns' = e(k_autoCns)
	}
	else	c_local Cns
end

program SignEstSample, eclass
	// Construct varlist with which to sign the sample
	local colnames `e(fbnames)'
	local fevars : subinstr local colnames "_cons" "", all
	local idvars `e(ivars)'
	local idvars : subinstr local idvars "_all" "", all
	local revars `e(rbnames)'
	local revars : subinstr local revars "R." "", all
	local revars : subinstr local revars "_cons" "", all
	if "`e(binomial)'" != "" {
		cap confirm number `e(binomial)'
		if _rc {
			local binvar `e(binomial)'
		}
	}
	if "`e(offset)'" != "" {
		_get_offopt `e(offset)'
		local offvar `s(offvar)'
	}
	signestimationsample `e(depvar)' `fevars' `idvars' `revars' ///
			     `binvar' `offvar'
	ereturn local fbnames 
	ereturn local rbnames 
end

program RepeatedLevelError
    	di as error 							///
    "{p 0 4}`0' level variable, specified at more than one level{p_end}"
end

program SetModel
	args mod bin

	local k: word count `mod'
	if `k' == 0 {
		di as err "model() required" 
		exit 198
	}
	if `k' > 1 {
		di as err `"model(`mod') invalid"'
		exit 198
	}
	local f = lower(trim(`"`mod'"'))
	local l = length(`"`f'"')
	if `"`f'"'==bsubstr("logistic",1,max(`l',1)) {
		c_local dist logistic
		if `"`bin'"' != "" {
			local m : word count `bin'
			if `m' > 1 {
				di as err `"binomial(`bin') invalid"'
				exit 198
			}
			cap confirm number `bin'
			if _rc {
				unab bin: `bin'
				confirm numeric variable `bin'
			}
			else {
				confirm integer number `bin'
				if `bin' >= . | `bin' < 1 {
di as err `"binomial denominator out of range"'
					exit 459
				}
				c_local bincon `bin'
			}
			c_local bindem `bin'
		}
	}
	else if `"`f'"'==bsubstr("poisson",1,max(`l',1)) {
		c_local dist poisson
		if `k'==2 {
			di as err `"model(`mod') invalid"'
			exit 198
		}
		if `"`bin'"' != "" {
di as err `"binomial() not allowed with Poisson model"'
			exit 198
		}
	}
	else {
		di as err `"model(`mod') invalid"'
		exit 198
	}
end

program CheckResponse, sclass
	args touse dist depname bindem bincon

	qui count if `touse'
	if !`r(N)' {
		di as err "no observations"
		exit 2000
	}

	cap assert `depname' == 0 if `touse'
	if !_rc {
		di as err `"`depname' is zero for all observations"'
		exit 498 
	}

	if "`dist'" == "logistic" {
	    if "`bindem'" != "" { 			
		cap assert `depname' >= 0 & `depname' <= `bindem' if `touse'
		if _rc {
		    di as err `"`depname' must be >= 0 and <= `bindem'"'
		    exit 459
		}
		cap assert `depname' == int(`depname') if `touse'
		if _rc {
			di as err `"`depname' must be integer-valued"'
			exit 459
		}
		if "`bincon'" == "" {
		    cap assert `bindem' == int(`bindem') if `touse'
		    if _rc {
di as err `"binomial denominator must be integer-valued"'
			exit 459
		    }
		}
	    }
	    else {				// Bernoulli data
		cap assert `depname' == 0 | `depname' == 1 if `touse'
		if _rc {
di as txt _n "{p 0 6 2}note: `depname' not 0/1 valued; any nonzero, "
di as txt    "nonmissing value is treated as a positive outcome{p_end}"
			sreturn local zeron zeron
		}
	    }
	}
	else {					// Poisson Data
	    cap assert `depname' >= 0 if `touse'
	    if _rc {
		di as err `"`depname' must be positive-valued"'
		exit 459
	    }
	    cap assert `depname' == int(`depname') if `touse'
	    if _rc {
	    	di as txt _n `"note: `depname' has noninteger counts"'
	    }
	}
end

program IntPoints, sclass
	args intpoints qnames levels laplace

	if `"`intpoints'"' != "" & "`laplace'" != "" {
		di as err "intpoints() and laplace may not be specified "_c
		di as err "together"
		exit 198
	}
		
	local w : word count `intpoints'
	if `w' == 0 | `w' == 1 {
		if `w' == 1 {
			confirm integer number `intpoints'
			local ninp `intpoints'
		}
		else {
			local ninp = cond("`laplace'" != "", 1, 7)
		}
		local intpoints
		forvalues i = 1/`levels' {
			local intpoints `intpoints' `ninp'
		}
	}
	local w : word count `intpoints'
	if `w' != `levels' {
		di as err "{p 0 4 4}wrong number of "
		di as err "intpoints() specifications{p_end}"
		exit 198
	}		
	forvalues i = 1/`levels' {
		local k : word `i' of `intpoints'
		confirm integer number `k'
	}
	tempvar avar wvar
	qui count
	local obs = r(N)
	local islaplace 1 
	forvalues i = 1/`levels' {
		local qname : word `i' of `qnames'
		cap drop `avar' `wvar'
		local k : word `i' of `intpoints'
		if `k' > `obs' {
			di as err "{p 0 4 4}number of quadrature points "
			di as err "is greater than the number of "
			di as err "observations{p_end}"
			exit 459
		}
		if `k' < 1 {
			di as err "{p 0 4 4}number of quadrature points "
			di as err "must be at least one{p_end}"
			exit 198
		}
		if `k' > 1 {
			local islaplace 0
		}
		qui gen double `avar' = . in 1/`k'
		qui gen double `wvar' = . in 1/`k'
		_GetQuad, avar(`avar') wvar(`wvar') quad(`k') 

		qui sum `wvar' in 1/`k'
		qui replace `wvar' = `wvar'/sqrt(_pi) in 1/`k'
		qui replace `avar' = `avar'*sqrt(2) in 1/`k'
	
		mkmat `avar' `wvar' in 1/`k', mat(`qname')
	}
	sreturn local intpoints `intpoints'
	if `islaplace' {
		sreturn local laplace laplace
	}
end

program SaveGroupInfo, eclass
	args levnames

	qui count if e(sample)
	ereturn scalar N = `r(N)'
	local levels : list uniq levnames
	local k : word count `levels'
	if `k' == 0 {
		exit
	}
		
	tempname gmin gmax gavg Ng
	mat `Ng' = J(1,`k',0)
	mat `gmin' = J(1,`k',0)
	mat `gavg' = J(1,`k',0)
	mat `gmax' = J(1,`k',0)

	forvalues i = 1/`k' {
		GroupStats `:word `i' of `levels'' if e(sample)	
		mat `Ng'[1,`i'] = r(ng)
		mat `gmin'[1,`i'] = r(min)
		mat `gavg'[1,`i'] = r(avg)
		mat `gmax'[1,`i'] = r(max)
		local ++i
	}
	ereturn matrix N_g `Ng'
	ereturn matrix g_min `gmin'
	ereturn matrix g_avg `gavg'
	ereturn matrix g_max `gmax'
end

program GroupStats, rclass
	syntax name [if]
	marksample touse

	if "`namelist'" == "_all" {
		tempvar one
		qui gen byte `one' = 1 if `touse'
		local namelist `one'
	}
	tempname T
	qui {
		bysort `touse' `namelist': /// 
			gen `c(obs_t)' `T' = cond(_n==_N,_N,.) if `touse'
		sum `T' if `touse'
	}
	return scalar ng = r(N)
	return scalar min = r(min)
	return scalar max = r(max)
	return scalar avg = r(mean)
end

program SetBlupMats 
	args se
	tempname gamma theta b err beta

	local is_xtme = inlist("`e(cmd`sfx')'","xtmelogit","xtmepoisson", ///
		"meqrlogit","meqrpoisson")
	if (!`is_xtme') {
di as err "{p 0 4 2}r.e. calculations require a previously fitted " 
di as err "mixed-effects model{p_end}"
		exit 301
	}

	// Blups are with respect to final parameter values.  

	checkestimationsample

	mat `b' = e(b)
	mat `beta' = `b'[1,1..`e(k_f)']
	mat `gamma' = `b'[1,`=e(k_f)+1'...]

	mata: _xtgm_gamma_to_theta_st("`theta'","`gamma'","`err'")
	if scalar(`err') {
		di as err "r.e. estimation failed"
		exit 498
	}
	_ms_omit_info `beta'
	tempname noomit
	local cols = colsof(`beta')
	mat `noomit' = J(1,`cols',1) -r(omit)
	mata: newbeta = ///
	select(st_matrix(st_local("beta")), (st_matrix(st_local("noomit"))))
	mata: st_matrix(st_local("beta"),newbeta)
	mata: _xtgm_estimate_re_st("`beta'", "`theta'")
	if "`se'" != "" {
		mata: _xtgm_set_smat_st()
	}
end

program CheckBlups
	local k : word count `0'
	if mod(`k',2) {
		di as err "getblups() incorrectly specified"
		exit 198
	}
	forvalues i = 1/`=`k'/2' {
		gettoken level 0 : 0
		gettoken stub 0 : 0
		if `:list stub in stublist' {
			di as err "stubs must be unique"
			exit 198
		}
		local stublist `stublist' `stub'
		if `"`level'"' != "_all" {
			unab level : `level'
		}
		local ivars `e(ivars)'
		local p : list posof "`level'" in ivars
		if !`p' {
			di as err `"`level' is not a group variable"'
			exit 198
		}
		local m 0
		forvalues j = `p'/`:word count `ivars'' {
			if `"`:word `j' of `ivars''"' != "`level'" {
				continue, break
			}
			local np : word `j' of `e(redim)'	
			forvalues k = 1/`np' {
				confirm new variable `stub'`=`m'+`k''
			}
			local m = `m' + `np'
		}
	}
end

program GetBlups
	// At this point _xtgm_model.Bmat()'s are filled.  I just need to 
	// get their values back into Stata.
	gettoken se 0 : 0

	local k : word count `0'
	forvalues i = 1/`=`k'/2' {
		gettoken level 0 : 0
		gettoken stub 0 : 0
		if `"`level'"' != "_all" {
			unab level : `level'
		}
		GetBlupsLevel `level' `stub' `se'
	}
end

program GetBlupsLevel
	args lvar stub se

	local ivars `e(ivars)'
	local zvars `e(revars)'

	// get z variables
	local w : word count `ivars'
	forvalues i = 1/`w' {
		local lev : word `i' of `ivars'
		local dim : word `i' of `e(redim)'
		if "`lev'" != "`lvar'" {
			local dont *
		}
		forvalues j = 1/`dim' {
			gettoken z zvars : zvars 
			`dont'local zs `zs' `z'
		}
		local dont
	}
	local ise = ("`se'" != "")

	local uivars : list uniq ivars
	local p : list posof "`lvar'" in uivars 	// p is the true level
	local nz : word count `zs'

	if `ise' {
		local ll r.e. std. errors
	}
	else {
		local ll random effects
	}
	forvalues i = 1/`nz' {
		qui gen double `stub'`i' = . 
label var `stub'`i' `"`ll' for `lvar': `:word `i' of `zs''"'
	}
	mata: _xtgm_blup_save_st("`stub'",`p',`ise')
end

program GetScores
	args stub touse

	local w : word count `stub'

	if `w' != 1 {
		di as err "getscores() incorrectly specified"
		exit 198
	}

	tempname err eb

	local is_xtme = inlist("`e(cmd`sfx')'","xtmelogit","xtmepoisson", ///
		"meqrlogit","meqrpoisson")
	if (!`is_xtme') {
di as err "{p 0 4 2}score calculations require a previously fitted " 
di as err "mixed-effects model{p_end}"
		exit 301
	}

	checkestimationsample

	mat `eb' = e(b)		// Scores at final parameter estimates

	local cnames : colnames `eb'
	local ceq: coleq `eb'

	local w = colsof(`eb')
	forvalues i = 1/`w' {
		if `i' <= `e(k_f)' { 		// fixed-effect
			local ll : word `i' of `cnames'
		}
		else {
			local ll : word `i' of `ceq'
			local ll [`ll']
		}
		confirm new variable `stub'`i'
		qui gen double `stub'`i' = . if `touse'
		label var `stub'`i' /// 
			`"parameter-level score for `ll' from `e(cmd)'"'
		local scvars `scvars' `stub'`i'
	}

	mata: _xtgm_get_scores_st("`eb'", "`scvars'", "`err'")
	if scalar(`err') {
		di as err "Scores calculation failed"
		exit 430
	}
end

program NoOmit, rclass
	syntax varlist(fv ts)
	fvexpand `varlist'
	local full_list `r(varlist)'
	local rows : word count `full_list'
	tempname noomit
	mat `noomit' = J(1,`rows',1)
	local i 1
	local omitted 0
	foreach var of local full_list {
		_ms_parse_parts `var'
		if `r(omit)' {
			mat `noomit'[1,`i'] = 0
			local ++omitted	
		}
		local ++i
	}
	return local omitted = "`omitted'"
	return matrix noomit = `noomit'
end

version 11
local SS        string scalar
local RS        real scalar
local RRVEC     real rowvector
local RMAT      real matrix
mata:

void _add_omitted(`SS' bname, `SS' vname, `SS' noomitname, `RS' k)
{
        `RS'            ncols, p
        `RRVEC'         noomitcols, b
        `RMAT'          V


        p = cols(st_matrix(noomitname))
        ncols = cols(st_matrix(bname))+k

        noomitcols = range(1,ncols,1)'
        noomitcols = select(noomitcols,(st_matrix(noomitname),J(1,ncols-p,1)))

        b = J(1,ncols,0)
        V = J(ncols,ncols,0)
        b[noomitcols] = st_matrix(bname)
        V[noomitcols', noomitcols] = st_matrix(vname)

        st_matrix(bname, b)
        st_matrix(vname, V)
}

end

exit
