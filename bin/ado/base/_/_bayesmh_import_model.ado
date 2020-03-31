*! version 1.7.0  26aug2019

findfile _bayesmh_parse_sub_expr.mata
quietly include `"`r(fn)'"'

program _bayesmh_import_model , sclass
	local vv : di "version " string(_caller()) ", missing:"

	local alleqn ""
	local stop 0
	// retrieve parentheses-bounded equations
	while !`stop' { 
		gettoken eqn 0 : 0, parse("\ ,[") match(paren) bind
		if "`paren'" == "(" {
	 		local alleqn "`alleqn' (`eqn')"
	 		continue
		}
		local 0 `"`eqn' `0'"'
		local stop 1
	}

	local zero `"`0'"'
	capture syntax [anything] [if/] [in] [fw], [    	///
		MCMCOBJECT(string)				///
	 	LIKELihood(string)				///
	 	EVALuator(string) LLEVALuator(string)		///
	 	NOXBOK	/* omitting regressors is OK */ 	///
	 	NOCONStant					///
		REffects(string)				///
		SHOWREffects					///
		SHOWREffects1(string)				///
	 	INITial(string)					///
	 	NOMLEINITial					///
	 	EXCLude(string)					///
		NOSHOW(string) SHOW(string)			///
	 	ADAPTation(string)				///
	 	RSEED(string)		 	 	 	///
	 	PREDICT	 	 	 	 	 	///
	 	PARSEONLY	 	 	 	 	///
	 	DRYRUN	 	 	 	 	 	///
	 	NOEXPRession 	 	 	 	 	///
		NOMODELSUMMary					///
	 	DEBUG	 	 	 	 	 	///
		REMULTieqok	 	 	 		///
		INITRANDom					///
		NCHAINs(string)					///
		* ]

	if _rc {
		local eqline `0'
		gettoken anything eqline : eqline, parse("=") bind
		gettoken next     eqline : eqline, parse("=") bind
		if `"`anything'"' != "" & `"`next'"' == "=" {
			// non-linear equation
			local anything `"`anything'`next'"'
			gettoken next : eqline, parse("\ ,") bind
			if `"`next'"' != ","  & ///
			   `"`next'"' != "in" & `"`next'"' != "if" {
				gettoken next eqline : eqline, parse(",") bind
				if _caller() < 15 {
					// sanity check for expression
					_mcmc_parmlist `next' noxberror
				}
				local anything `"`anything'`next'"'
			}
			local 0 `eqline'
			syntax  [if/] [in] [fw] , [  		///
			MCMCOBJECT(string)			///
			LIKELihood(string)			///
			EVALuator(string) LLEVALuator(string)	///
			NOXBOK	/* omitting regressors is OK*/	///
			NOCONStant				///
			REffects(string)			///
			SHOWREffects				///
			SHOWREffects1(string)			///
			INITial(string)				///
			NOMLEINITial				///
			EXCLude(string)				///
			NOSHOW(string) SHOW(string)		///
			ADAPTation(string)			///
			RSEED(string)				///
			PREDICT	 	 	 	 	///
			PARSEONLY	 	 	 	///
			DRYRUN	 	 	 	 	///
	 		NOEXPRession 	 	 	 	///
			NOMODELSUMMary				///
			DEBUG	 	 	 	 	///
			REMULTieqok	 	 	 	///
			INITRANDom				///
			NCHAINs(string)				///
			* ]
		}
		else {
			// reproduce the error
			local 0 `zero'
			syntax  [anything] [if] [in] [fw], [*]
		}
	}

	_bayes_chains opt `"`nchains'"'
	local nchains  `r(nchains)'
	local options `"`options' `r(options)'"'

	if "`rseed'" != "" {
		local options `"`options' rseed(`rseed')"'
	}

	if "`initrandom'" != "" & "`nomleinitial'" != "" {
		di as err "options {bf:`initrandom'} and {bf:`nomleinitial'} " ///
			"cannot be combined"
		exit 198
	}

	if "`noshow'" != "" & "`show'" != "" {
		di as err "options {bf:noshow(`noshow')} and {bf:show(`show')} " ///
			"cannot be combined"
		exit 198
	}

	// capture the yvar in a single equation specification
	local yvar
	gettoken next : anything, parse("=") bind
	capture confirm variable `next' 
	if _rc == 0 {
		local yvar `next'
	}

	if `"`mcmcobject'"' == "" {
		di as err "invalid specification" 
		exit 198
	}
	capture mata: `mcmcobject'
	if _rc != 0 {
		di as err `"{bf:`mcmcobject'} not found"'
		exit _rc
	}

	global MCMC_exprcount = 0
	mata: getfree_mata_object_name("exprobject", "_mcmc_exprobj")
	global MCMC_mexprobj `exprobject'
	
	// Bayesian model
	local lbayesianmethod

	global MCMC_debug  0
	if "`debug'" != "" {
		global MCMC_debug  1
		mata: `mcmcobject'.m_debug = 1
	}

	if `"`evaluator'"' != "" & `"`llevaluator'"' != "" {
		opts_exclusive "evaluator() llevaluator()"
	}
	local gevaluator `evaluator'
	
	if `"`likelihood'"' != "" {
		local alleqn `alleqn'
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `"`alleqn', likelihood(`likelihood') `noconstant' re(`reffects')"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else if `"`evaluator'"' != "" {
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
		local alleqn `"`alleqn', evaluator(`evaluator') `noconstant'"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else if `"`llevaluator'"' != "" {
		if `"`anything'"' != "" local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
		local alleqn `"`alleqn', llevaluator(`llevaluator') `noconstant'"'
		local alleqn `alleqn'
		local alleqn `"(`alleqn')"'
	}
	else {
		local alleqn `"`alleqn' `anything'"'
		local alleqn `alleqn'
	}

	if `"`alleqn'"' == "" {
		di as err "invalid specification" 
		exit 198
	}

	_bayesmh_eqlablist init

	// list of fv shortcuts
	local fveqlist
	// list of random-effects parameters
	local relablist
	local reparamlist
	local redefparams

	// xbdefines
	global MCMC_xbdeflabs
	global MCMC_xbdefvars
	global MCMC_deflabs
	global MCMC_defvars

	// global touse
	local eqif `if'
	if `"`eqif'"' == "" {
		local eqif 1
	}
	local eqin `in'
	local eqwt `weight'
	local weqexp "`exp'"

	marksample common_touse
	mata: `mcmcobject'.set_global_touse(`"if `eqif' `in'"')
	
	// global `gtouse' as union of all equation-specific `touse'
	tempvar gtouse
	quietly gen `gtouse' = 0

	// set nchains before calling set_rngstate()
	mata: `mcmcobject'.set_mcmc_chains(`nchains')

	_mcmc_set_seed "`mcmcobject'" "`rseed'"
	mata: `mcmcobject'.set_rngstate()
	if "`rseed'" != "" {
		local bayesopt `bayesopt' rseed(`rseed')
	}

	// list of equations
	local list_eq_names	
	// list of model parameters
	local list_par_names
	local list_par_prefix
	local list_par_isvar
	local list_depvar_names
	local list_indepvar_names
	local list_expr

	// global noconstant
	local gnoconstant `noconstant'
	local greffects `reffects'
	local allreffects
	local allreffectspar
	
	local gpredict `predict'

	// blocks from redefine's
	local reblocks
	
	// list of temporary vars used for definitions
	local list_defvar_names
	if "`eqin'" != "" {
		tempvar din
		qui gen `din' = 0
		qui replace `din' = 1 `eqin'
		if `"`eqif'"' == "" {
			local eqif 1
		}
		local eqifin `eqif' & `din'
	}
	else {
		local eqifin `eqif'
	}

	// parse defines
	local defines `"`options'"'
	local options ""

	while `"`defines'"' != "" {
		gettoken eqline defines: defines, parse("\ ()") match(paren)

		local l = bstrlen(`"`eqline'"')
		if `l' >= 5 & bsubstr(`"`eqline'"',1,max(5,`l')) ==	///
				bsubstr("xbdefine",1,max(5,`l')) {
			local eqline xbdefine
		}
		else if `l' >= 5 & bsubstr(`"`eqline'"',1,max(5,`l')) ==	///
				bsubstr("redefine",1,max(5,`l')) {
			local eqline redefine
		}
		else if `l' >= 3 & bsubstr(`"`eqline'"',1,max(3,`l')) ==	///
				bsubstr("define",1,max(3,`l')) {
			local eqline define
		}

		local defopt
		// parse data/params until the first option
		if `"`eqline'"' == "xbdefine" | `"`eqline'"' == "redefine" | ///
			 `"`eqline'"' == "define" {
			local defopt `eqline'
			gettoken eqline defines : defines, match(paren)
			// equations begin with ( 
			if "`paren'" != "(" {
				di as err "{bf:(} is expected after {bf:`defopt'}"
				exit _rc
			}
		}
		else {
			gettoken next defines : defines, match(paren)
			// move to options
			if "`paren'" == "(" {
				local options `"`options'`eqline'(`next') "'
			}
			else {
				local options `"`options'`eqline' "'
				if `"`next'"' != "" {
					local defines `"`next' `defines'"'
				}
			}
			continue
		}

		// equations begin with (
		if "`paren'" != "(" {
			local option `eqline'
			continue
		}

		gettoken ylabel next : eqline, parse(":") bind bindcurly
		gettoken next xlist  : next, parse(":") bind bindcurly

		if `"`next'"' != ":" {
			di as err "{bf:`defopt'(`eqline')} is misspecified:"
di as err `"{p 4 4 2}you should use column to separate definition name.{p_end}"'
			exit 198
		}

		if "`defopt'" == "redefine" {
			tokenize `"`xlist'"', parse(".")
			capture confirm numeric variable `3'
			if "`2'" != "." | _rc {
di as err "{bf:redefine(`eqline')} is misspecified:"
di as err `"{p 4 4 2}you should specify a single factor variable.{p_end}"'
				exit 198
			}
			local reblocks `reblocks' ///
				block({`ylabel':`xlist'}, reffects)
		}

		if "`defopt'" == "xbdefine" | "`defopt'" == "redefine" {
			// markout missing observations from xlist
			markout `common_touse' `xlist'

			_mcmc_fv_decode `"`xlist'"'
			local xlist `s(outstr)'
			local eqline `ylabel':`xlist'

			// make shortcuts to all fv-parameters
			local fvvarlist `s(fvlablist)'
			gettoken tok fvvarlist : fvvarlist
			while `"`tok'"' != "" {
				local fveqlist = `"`fveqlist' {`ylabel':`tok'}"'
				gettoken tok fvvarlist : fvvarlist
			}
		}

		if $MCMC_debug {
	 		di " "
		 	di _asis `"	 	define: `eqline'"'
		}

		_mcmc_definename `ylabel'
		local xbvar `s(define)'

		global MCMC_genvars $MCMC_genvars `xbvar'
		quietly generate double `xbvar' = 0

		if "`defopt'" == "redefine" {
			tokenize `xlist'
			local xlist
			while "`*'" != "" {
				if bsubstr("`1'",1,2) == "r." {
					local xlist "`xlist' `1'"
				}
				else {
					local xlist "`xlist' r.`1'"
				}
				local redefparams ///
					"`redefparams' {`ylabel':`1'}"
				mac shift
			}
		}
		if "`defopt'" == "xbdefine" | "`defopt'" == "redefine" {
			if `"`xlist'"' == "" | `"`xlist'"' == "()" {
				di as err "{bf:`defopt'`xlist'} is misspecified:"
				di as err `"{p 4 4 2}expression {bf:`xlist'} "' ///
				" must include at least one model parameter.{p_end}"
				exit 198
			}
			local varlist `xlist'
			local xlist
			gettoken next varlist : varlist
			while `"`next'"' != "" {
				local xlist = `"`xlist'`ylabel':`next' "'
				gettoken next varlist : varlist
			}
			global MCMC_xbdeflabs $MCMC_xbdeflabs `ylabel'
			global MCMC_xbdefvars $MCMC_xbdefvars `xbvar'
		}
		else {
			// this is a substitutable expression
			if `"`ylabel'"' != "" {
				local xlist (`ylabel':`xlist')
			}
			else {
				local xlist (`xlist')
			}
			global MCMC_deflabs $MCMC_deflabs `ylabel'
			global MCMC_defvars $MCMC_defvars `xbvar'
		}

		local eqline `xbvar', define(`xlist')

		mata: `mcmcobject'.add_predict_factor(`"`xbvar'"', `"`eqline', nocons"', "", "")
		// _mcmc_scan_identmats after add_predict_factor

		_mcmc_parse equation `eqline', nocons

		if `"`defopt'"' != "define" & `"`s(x)'"' == "" {
			di as err "{bf:`defopt'`xlist'} is misspecified:"
			di as err `"{p 4 4 2}expression {bf:`xlist'} "' ///
			" must include at least one model parameter.{p_end}"
			exit 198
		}
		
		if `"`s(y)'"' == "" {
			di `"{txt}note:{bf:define(`eqline')} is dropped"'
			continue
		}

		// update beta_label lists
		local varlist0 `s(xprefix)'
		local varlist  `s(x)'
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
		while `"`next'"' != "" { 
			if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
				_bayesmh_eqlablist ind `lyvar'
				_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
			}
			gettoken lyvar varlist0 : varlist0
			gettoken next  varlist  : varlist
		}

		if "`defopt'" == "define" {
			local list_expr `"`list_expr' `s(eval)'"'
		}

		// extravars may contain temp-vars from other defines()
		local extravars `s(exvarlist)'

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
		 	`"`llevaluator'"', `"`extravars'"', "", "", "")

		// needs better solution!
		mata: `mcmcobject'.drop_pdist()

		if `"`extravars'`yvar'"' != "" {
			markout `common_touse' `extravars' `yvar'
			quietly replace `xbvar' = . if `common_touse' == 0
		}
		mata: `mcmcobject'.set_touse( ///
			NULL, st_data(., "`common_touse'"), "", J(1,0,0), "", "")

	} // end of while

	// save for later
	local priors `options'
	local optinitial ""

	if $MCMC_debug {
		di " "
		di _asis `"	likelihood: `alleqn'"'
		di " "
		di _asis `"	    priors: `priors'"'
	}

	local ismultieq 0
	local n_nl 0
	local n_eq 0
	while `"`alleqn'"' != "" { // begin while

		local ++n_eq

		// use permanent touse variables
		//_mcmc_definename touse
		//local touse `s(define)'
		//global MCMC_genvars $MCMC_genvars `touse'
		
		local if `lgs_if'
		local in `lgs_in'
		local weight `lgs_wt'
		
		gettoken 0 alleqn : alleqn, match(paren) bind
		if `"`paren'"' != "(" {
			di as err `"invalid likelihood specification {bf:`0'}"' 
			exit 198 
		}
		if `"`alleqn'"' != "" {
			local ismultieq 1
		}

		_mcmc_parse ifincomma `0'
		local lhs `s(lhs)'
		local rhs `s(rhs)'
		local 0 `rhs'

		syntax  [if/] [in] [fw] [,			///
	 		LIKELihood(string)			///
		 	EVALuator(string) LLEVALuator(string)	///
			NOCONStant      			///
			REffects(string)			///
			predict					///
		 	* ]

		if `"`levaluator'"' != "" & `"`llevaluator'"' != "" {
			opts_exclusive "evaluator() llevaluator()"
		}
		if `"`evaluator'"' == "" {
			local evaluator `llevaluator'
		}

		if `"`if'"' != "" {
			local if `eqifin' & `if'
		}
		else {
			local if `eqifin'
		}
		
		if `"`in'"' != "" {
			tempvar deqin
			quietly gen `deqin' = 0
			quietly replace `deqin' = 1 `in'
			local if `deqin' & `if'
		}
		if `"`weight'"' == "" {
			local weight `eqwt'
			local exp "`weqexp'"
		}

		local ifinopt if `if' 
		local weightopt ""
		local weightexp `"`exp'"'
		if `"`weight'"' != "" {
			local weightopt = `"[`weight'`exp']"'
		}
		local if `ifinopt'
		// mark the sample before the next call of syntax
		//mark `touse' `ifinopt' `weightopt'
		marksample touse

		// common_touse marks sample from -define()- options
		// comment the next out if you want touse to absorb common_touse
		//qui replace `touse' = 0 if `common_touse' == 0

		if `"`reffects'"' != "" {
			cap markout `touse' `lhs'
		}

		local exp1    "`exp'"
		local weight1 "`weight'"

		if `"`reffects'"' == "" {
			local reffects `greffects'
		}
		local fvreffects
		if `"`reffects'"' != "" {
		
			if (`n_eq' > 1 & `"`remultieqok'"' == "") {
				di as err "{bf:reffects} option not allowed with " ///
					"multiple likelihood equations"
				exit 198
			}

			local 0 `reffects'
			capture syntax [anything] [,FVVARLISTok]
			if `"`fvvarlistok'"' == "" {
				capture syntax [varname] [,]
				if _rc {
					di as err "invalid {bf:reffects} specification"
					capture noi syntax [varname] [,]
					exit 198
				}
			}
			else {
				capture syntax [varlist(fv)] [,FVVARLISTok]
				if _rc {
					di as err "invalid {bf:reffects} specification"
					capture noi syntax [varlist(fv)] [,FVVARLISTok]
					exit 198
				}
				local reffects `varlist'
			}
			tokenize `"`reffects'"'
			local reffects
			local revars
			while "`*'" != "" {
				if bsubstr("`1'",1,4) == "ibn." {
					local reffects "`reffects' `1'"
				}
				else {
					local reffects "`reffects' ibn.`1'"
				}
				local revars "`revars' `1'"
				mac shift
			}

			_mcmc_fv_decode `"`reffects'"' `touse'
			local fvreffects `s(outstr)'

			if regexm(`"`fvreffects'"', "ibn.") {
				di as err "{bf:reffects} option not allowed for " ///
					`"variable {bf:`revars'}"'
				exit 198
			}
		}

		local 0 `lhs'
		local ct 1
		while `ct' > 0 {
			local 0 : subinstr local 0 ": " ":", count(local ct)
		}
		local ct 1
		while `ct' > 0 {
			local 0 : subinstr local 0 " :" ":", count(local ct)
		}

		// check for [multiple y`s = common x's] equation
		// tolerate parents: (y1 y2 = x1 x2 .. xp)
		gettoken anything : 0, parse("=,") bind match(paren)
		if `"(`anything')"' == `"`0'"' {
			local 0 `anything'
		}
		gettoken anything 0 : 0, parse("=,") bind
		gettoken next	  0 : 0, parse("=,") bind
		
		tokenize `anything'
		if `"`1'"' != "" & `"`next'"' == "=" {
		 	local anything `"`0'"'
		 	local 0 ""
		 	while "`*'" != "" {
				local 0 "`0'(`1' `anything') " 
				mac shift
		 	}
		}
		else local 0 `"`anything' `next' `0'"'

		// check for multiple univariate (y x) equations
		gettoken next : likelihood, parse("\ (") bind
		local l = length(`"`next'"')
		local isuni 1

		_mcmc_distr expand `"`next'"'
		
		if `"`s(distribution)'"' == "mvnormal"  |		///
		`"`s(distribution)'"' == "mvnormal0" | `"`evaluator'"' != "" {
			local isuni 0
		}

		if `"`reffects'"' != "" & `"`s(llf)'"'== "llf" {
			di as err "{bf:reffects} option not allowed with " ///
				"generic likelihood"
			exit 198
		}

		if `"`reffects'"' != "" & `isuni' == 0 {
			di `"{txt}note:random effects {bf:`reffects'} are shared "' ///
				"between dependent variables"
		}

		_parse expand lcs lgs: 0

		if `isuni' & `lcs_n' > 1 {
			local eqn ""
			while `lcs_n' > 0 {
				local next `"`lcs_`lcs_n''"'
				local next `"`next', likelihood(`likelihood') "'
				local next `"`next' evaluator(`evaluator') "'
				local next `"`next' `noconstant'"'
				local eqn  `"`eqn'(`next') "'
				local `--lcs_n'
			}

			local alleqn `"`eqn'`alleqn'"'
			local alleqn `alleqn'

			// load the first equation
			gettoken 0 alleqn : alleqn, match(paren)
			
			_parse comma lhs rhs : 0

			local 0 `rhs'
			capture syntax [,				///
				LIKELihood(string)	 	 	///
				EVALuator(string) LLEVALuator(string)	///
				NOCONStant      	 	 	///
				* ]

			if `"`evaluator'"' != "" & `"`llevaluator'"' != "" {
				opts_exclusive "evaluator() llevaluator()"
			}
			if `"`evaluator'"' == "" {
				local evaluator `llevaluator'
			}
			local 0 `lhs'
			
		} // if `isuni' & `lcs_n' > 1

		if `"`likelihood'"' == "" & `"`evaluator'"' == "" {
			di as err "invalid likelihood specification" 
			exit 198 
		}

		if `"`likelihood'"' != "" {
			gettoken  dist : likelihood, parse("\ (,")
			_mcmc_distr expand `dist'
			if `"`s(distribution)'"' == "" {
				mata: getfree_mata_object_name("moptobject", "_mcmc_moptobj")
			}
		}

		if `"`moptobject'"' != "" {
			local distrparams
			gettoken  dist distopts : likelihood, parse(",")
			if bsubstr(`"`distopts'"', 1, 1) == "," {
				gettoken next distopts : distopts, parse(",")
			}
		}
		else {		
			gettoken  dist distrparams : likelihood, parse("\ (,")
			gettoken  distrparams distopts : distrparams,	///
				parse("\ (,")  match(paren)
			if "`paren'" != "(" local distrparams ""
			_mcmc_distr expand `dist'
			local dist `s(distribution)'
			if bsubstr(`"`distopts'"', 1, 1) == "," {
				gettoken next distopts : distopts, parse(",")
			}
		}

		if `"`dist'"' == "ologit" | `"`dist'"' == "oprobit" {
			if "`noconstant'" != "" {
				di as err "likelihood {bf:`dist'} does not " ///
					"allow option {bf:noconstant}"
				exit 198
			}
		}

		if "`noconstant'" == "" {
			local noconstant `gnoconstant'
		}

		_mcmc_getmleopts mleopts : "`dist'" "`distopts'"

		_parse expand lcs lgs : 0, gweight

		local eqline ""
		local xlist  ""	
		local ylist  ""
		local ylabel ""
		local d `lcs_n'

		scalar min_rmse = 0
		local mvequ ""
		local allnonlinear 1

		local list_sub_exprs
		local sub_exprs_vars

		if `lcs_n' > 1 {
			local ismultieq 1
		}

		forvalues i=1/`lcs_n' { // begin forvalues
			local eqn `lcs_`i''

		 	gettoken ylabel eqn : eqn, parse(":") bind bindcurly
		 	if bsubstr(`"`eqn'"',1,1) == ":" {
				gettoken next eqn : eqn, parse(":") bind bindcurly
				// next == :
				// save it for later
				local lcs_`i' `eqn' 
		 	}
		 	else {
				local eqn `ylabel' 
				local ylabel ""
		 	}
		 	if `"`ylabel'"' != "" {
				capture confirm name `ylabel'
				if c(rc) {
					di as err "invalid label {bf:`ylabel'}"
					exit c(rc)
				}
			}

		 	gettoken anything eqn : eqn, parse("\ =,") ///
		 		match(paren) bind
			unab anything : `anything'
			// in case anything is a depvar, update touse
			cap confirm variable `anything'
			if _rc == 0 {
				markout `touse' `anything'
			}

			gettoken tok next : eqn, parse("\ =,") match(paren)
		 	if `"`tok'"' == "=" {
				gettoken next : next, parse("\ =,") match(paren)
				local eqn (`next')	 	
		 	}

		 	gettoken tok next : eqn, parse("\ =,") match(paren)
			local isnl 0

			local eqlatent

			if `"`anything'"' != "" & `"`tok'"' != "" & ///
		 	  `"`paren'"' == "(" {
				if `"`next'"' != "" {
		 	 	 	 di as err `"{bf:`eqn'} is "' ///
		 	 	 	 	"invalid nonlinear expression"
		 	 	 	 exit 198
				}
				local isnl 1
				local ++n_nl
				local anything `"`anything' = (`tok')"'
				local mvequ    `"`mvequ' (`anything')"'
				local eqn      `"`anything'"'

				if _caller() < 16.0 {
					// sanity check for expression
					_mcmc_parmlist (`tok')
				}
		 	}
		 	else {
				// should be a varlist
				local 0 `lcs_`i''

				// check for U[var] terms
				gettoken lcs lgs : 0, parse("[]")
				tempname res
				scalar `res' = 0
				if bsubstr(`"`lgs'"', 1, 1) == "[" {

// stop-check for latent variable specifications
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2} Equation {bf:(`lcs_`i'')} is misspecified.{p_end}" 
capture noi syntax [varlist(fv)] [,]
exit 198

			mata: _bayesmh_parse_sub_expr(1, `ismultieq', ///
				"`0'", "`touse'", "`noconstant'",     ///
				"eqexpr", "eqnolatent", "eqlatent",   ///
				"eqlatname", "pathlist", "varlist",   ///
				"feparams", "feinit", "matparams",    ///
				"totalre", "`res'")
			if `res' == 0 {
				local list_sub_exprs = ///
					`"`list_sub_exprs' "`eqexpr'""'
				local sub_exprs_vars `sub_exprs_vars' `varlist'
				local varlist `eqnolatent'
				// save latent vars in relablist
				local eqlatent `eqlatent'
				foreach lat of local eqlatent {
					local relablist `relablist' {`lat'}
				}
				local eqlatentstubs
				foreach tok of local eqlatent {
					tokenize `tok', parse("[]")
					local lname MCMC_latent_`1'
					global `lname' `tok'
					local eqlatentstubs `eqlatentstubs' `1'
				}

				while `"`feinit'"' != "" {
					gettoken tok feinit : feinit
					gettoken parname parinit : tok
					local parinit `parinit'
					if `"`parinit'"' != "." {
						local optinitial `optinitial' ///
							{`parname'} `parinit'
					}
				}

				local cons _cons
				local cons : list cons in eqnolatent
				if `cons' {
					local eqlatentstubs `eqlatentstubs' _cons
				}
			}

				}
				else {
					// `no variables defined' error if no data
					// var, {var},(var) and ({var}) equivalent
					capture syntax [varlist(fv)] [,]
					scalar `res' = _rc
					local list_sub_exprs = ///
						`"`list_sub_exprs' xb"'
				}

				if `res' {
di as err "invalid {bf:bayesmh} specification"
di as err "{p 4 4 2} Equation {bf:(`lcs_`i'')} is misspecified.{p_end}" 
capture noi syntax [varlist(fv)] [,]
exit 198
				}
				local mvequ `"`mvequ' (`varlist')"'
				local eqn   `"`varlist'"'
				local allnonlinear 0
		 	}
if (_caller() < 16.0) {
			if (`n_eq'>1 & `n_nl'>0 & "`debug'" == "") {
				di as err "nonlinear specifications are " ///
				   "not supported for multiple-equation models"
				exit 198
			}
}
			if (`"`reffects'"' != "" & `n_nl' > 0) {
				di as err "{bf:reffects} option not allowed with " ///
					"nonlinear models"
				exit 198
			}
			
		 	if `i' > 1 {
				if `"`xlist'"' != "" {
					local xlist = `"`xlist', "'
				}
			}

			local expr 0

			gettoken yvar eqn : eqn, parse("\ (=") bind
			if `"`yvar'"' == "" {
				di as err "no dependent variable specified"
				exit 198 
			}
			
			// ylabel:beta set
			local lyvar `yvar'
		 	if `"`ylabel'"' == "" local ylabel `yvar'
		 	else local lyvar `"`ylabel':`yvar'"'

		 	capture confirm variable `yvar'
		 	if _rc == 0 {
				capture confirm numeric variable `yvar'
				if _rc {
					error 2000
				}
				local expr 1			
			}
		 	tokenize `"`yvar'"', parse("{}")
		 	if `"`1'"' == "{" & `"`3'"' == "}" & `"`2'"' != "" {
				local expr 2
			}
		 	if `expr' == 0 {
				di as err "no variables defined"
				exit 111
		 	}
		 	else {
				local ylist = `"`ylist'`lyvar' "'
		 	}

			if `expr' == 1 {
				local ldups   $MCMC_eqlablist
				local lxbdefs $MCMC_xbdeflabs
				if `"$MCMC_xbdeflabs"' != "" {
					local ldups: list ldups - lxbdefs
				}
				local ldups `ldups' `yvar'
				local ldups : list dups ldups
				if `"`ldups'"' != "" {
					di as err "duplicate dependent " ///
						`"variable {bf:`ldups'}"'
if _caller() < 16.0 {
					exit 198
}
				}
			}

		 	gettoken next : eqn, parse("=") bind
		 	if `"`next'"' == "=" {
				gettoken next eqn: eqn, parse("=") bind
				gettoken next : eqn, parse("") match(paren)
				if "`paren'" == "(" {
					local eqn `"`next'"'
				}
				local xlist `"`xlist'(`eqn')"'
				continue
		 	}

		 	local eqnocons `noconstant'
		 	local xwasempty = `"`xlist'"' == ""
		 	local xempty 1

		 	local xvarlist `eqn'

			//for multi-equation RE models
			//todo: remove latent stubs from factor expansion
			//local neweqn : list eqn - eqlatentstubs
			//remember what you have removed
			//local eqlatentstubs : list eqn - neweqn
			//local eqn `neweqn'

			// decode factors and interactions
		 	_mcmc_fv_decode `"`eqn'"' `touse'

			// make shortcuts to all fv-parameters
			local fvvarlist `s(fvlablist)'
			gettoken tok fvvarlist : fvvarlist
			while `"`tok'"' != "" {
				local fveqlist = `"`fveqlist' {`ylabel':`tok'}"'
				gettoken tok fvvarlist : fvvarlist
			}
			local varlist0 `s(outstr)'

			//todo: restore removed
			//local varlist0 `eqlatentstubs' `varlist0'

			local ldups : list dups varlist0
			if `"`ldups'"' != "" {
				di as err `"duplicate variable {bf:`ldups'}"'
				exit 198
			}

			local ldups `varlist0' `yvar'
			local ldups : list dups ldups
			if `"`ldups'"' != "" {
				di as err `"duplicate variable {bf:`ldups'}"'
				exit 198
			}

			// update $MCMC_eqlablist and `beta_ylabel'
			_bayesmh_eqlablist ind `ylabel'
			local ylabind `s(ylabind)'
			local varlist `varlist0'
		 	gettoken next varlist : varlist
		 	while `"`next'"' != "" {
				_bayesmh_eqlablist up `ylabel' `next' `ylabind'

				local xempty 0
				local xlist = `"`xlist'`ylabel':`next' "'
				if `"`next'"' == "_cons" {
					local eqnocons "noconstant"
					if `"`moptobject'"' != "" {
						local cons _cons
						local xvarlist : list xvarlist - cons
						local eqnocons
					}
				}
				gettoken next varlist : varlist
		 	}

			if `"`dist'"' == "ologit" | `"`dist'"' == "oprobit" {
				local eqnocons "noconstant"
			}

			if `"`dist'"' == "dexponential" | ///
			   `"`dist'"' == "dbernoulli"   | ///
			   `"`dist'"' == "dbinomial"    | ///
			   `"`dist'"' == "dpoisson" {
				if `"`reffects'"' != "" {
				di as err "{bf:reffects} option not allowed with " ///
					"{bf:`dist'()} likelihood model"
					exit 198
				}
				if "`noconstant'" != "" {
				di as err "{bf:`noconstant'} not allowed with " ///
					"{bf:`dist'()} likelihood model"
					exit 198
				}
				if "`xlist'" != "" {
				di as err "variable {bf:`varlist0'} " ///
					"not allowed with {bf:`dist'()} likelihood model"
					exit 198
				}
				local eqnocons "noconstant"
			}

		 	if `"`eqnocons'"' == "" & `expr' == 1 {
				local xempty 0
				local xlist = `"`xlist'`ylabel':_cons "'

				_bayesmh_eqlablist up `ylabel' _cons `ylabind'
		 	}

			if `"`reffects'"' != "" {
				// setup reffects blocks
				tokenize `reffects'
				while "`*'" != "" {
					local priors `priors' ///
						block({`ylabel':`1'}, reffects)
					// make random-effects shortcut
					local tok = regexr(`"`1'"',"ibn.","i.")
					local relablist = ///
						`"`relablist' {`ylabel':`tok'}"'
					mac shift
				}

				tokenize `fvreffects'
				while "`*'" != "" {
					if bsubstr("`1'",1,2) == "r." {
					local xlist "`xlist' `ylabel':`1'"
					}
					else {
					local xlist "`xlist' `ylabel':r.`1'"
					}
					local xempty 0
					local allreffects ///
						"`allreffects' `ylabel':`1'"
					local reparamlist ///
						"`reparamlist' {`ylabel':`1'}"
					mac shift
				}
			}

			if `i' > 1 {
				if !`xwasempty' & `xempty' {
					// add 0 suffix to xlist
					local xlist = `"`xlist'0"'
				}
				if `xwasempty' & !`xempty' {
					// multivariate case
					// add (d-1) zero prefixes to xlist
					local j `i'
					while `j' > 1 {
						local `--j'
						local xlist = `"0,`xlist'"'
					}
				}
		 	}

	if `"`eqlatent'"' != "" {

		if `"`moptobject'"' == "" {
			// update $MCMC_latent with the list of latent variables
			foreach next of local eqlatent {
				global MCMC_latent `"$MCMC_latent`next' "'
				local xempty 0
				local xlist = `"`xlist'`next' "'
			}
		}
		else {
			local 0 , `distopts'
			syntax [anything][, OFFset(varname numeric ts)	///
				Exposure(varname numeric ts) *]
			local distopts `options'
			
			local restubs
			local exclude
			local covariances

			local respec `list_sub_exprs'
			local respec : list respec - yvar
			local respec : list respec - xvarlist

			local xvarlist : list xvarlist - eqlatentstubs

			//todo: must add coefficients to U's
			_bayes_define_offset `"`ylabel'"' `"`offset'"' `"`exposure'"' ///
				`"`respec'"' `"`touse'"'
			local offset `s(offset)'
			local tmpvar `s(tmpvar)'
			local consnoshow `consnoshow' `s(noshow)'

			_bayes_reffects `mcmcobject' `moptobject' `"`dist'"'	 ///
				`"`covariances'"' `"`touse'"' 			 ///
				`"`ylabel'"' `"`yvar'"' `"`respec'"' `"`offset'"' ///
				`"`tmpvar'"' `"`restubs'"' `"`exclude'"'	 /// 
				0 `nchains' reasis renoprior

			local distopts `distopts' offset(`tmpvar') useviews
		}
	}
			// fit some models to get initials 
		 	if `"`moptobject'"' != "" {
				_set_moptobject `"`dist'"'	  ///
					`"`yvar'"'		  ///
					`"`ylabel'"'		  ///
					`"`xvarlist'"'            ///
					`"`eqnocons'"'		  ///
					`"`distopts'"'		  ///
					`"`touse'"'		  ///
					`"`weightopt'"'		  ///
					`"`moptobject'"'
				local ylist `s(depvar)'
				local xlist  `s(moptparams)'
				local optinitial "`optinitial' `s(optinitial)'"
			}
			else if `"`parseonly'"' == "" & `"`nomleinitial'"' == "" {
				`vv' _mle_initials `"`dist'"'	  ///
					`"`yvar'"'		  ///
					`"`ylabel'"'		  ///
					`"`xvarlist'"'            ///
					`"`eqnocons'"'		  ///
					`"`distrparams'"'	  ///
					`"`mleopts'"'		  ///
					`"`touse'"'		  ///
					`"`weightopt'"'		  ///
					`"`reffects'"'
				local optinitial "`optinitial' `s(optinitial)'"
			}

		} // end of forvalues

		if `allnonlinear' & "`noconstant'" != "" {
			di as err "{bf:`noconstant'} not allowed with " ///
				"nonlinear models"
			exit 198
		}

		local extravars	""
		local passthruopts ""
		local progparams   ""

		if `"`gpredict'"' != "" {
			local predict `gpredict'
		}

		if `"`evaluator'"' == "" { // likelihood
		 	gettoken likelihood distrparams : likelihood, ///
		 		parse("\ (,")
		 	gettoken distrparams next: distrparams, ///
				parse("\ ,") match(paren)
		 	gettoken item : next, parse("\ ,")
		 	if `"`paren'"' != "(" {
				local distrparams ""
		 	}

		 	_mcmc_distr expand `likelihood'
			local llf `s(llf)'
			// additional response variables
		 	if `"`item'"' == "," {
				gettoken item next : next, parse("\ ,")
		 	}
		 	local distopts `next'

			if `"`likelihood'"' == "" {
				di as err "likelihood must be specified"
				exit 198 
		 	}

			if `"`moptobject'"' == "" {
				_mcmc_distr likelihood		///
					`"`likelihood'"' 	///
					`"`ylist'"'		///
					`"`xlist'"'		///
					`"`distrparams'"'	///
					`"`distopts'"'		///
					`"`noxbok'"'		///
					`"`touse'"'		///
					`"`isnl'"'		///
					`"`llf'"'		///
					`"`predict'"'

				local likelihood  `s(dist)'
				local distrparams `s(distparams)'
				local xlist	  `s(xlist)'
				local ylist	  `s(ylist)'
				local lbayesianmethod `s(likmodel)'
				// last-in first-out order
				local optinitial "`optinitial' `s(optinitial)'"
	 		}

		 	local eqline ""

			// in multivariate case add the dimension `d'
			if (`"`likelihood'"' == "mvnormal" | ///
			    `"`likelihood'"' == "mvnormal0") & `d' >= 1 { 
				local eqline = `"`eqline'`d'"'
				local list_sub_exprs = `"NULL `list_sub_exprs'"'	
			}

			if `"`xlist'"' != "" { 
				if `"`eqline'"' != "" {
					local eqline = `"`eqline',`xlist'"'
				}
				else {
					local eqline = `"`xlist'"'
				}
		 	}
		 	if `"`distrparams'"' != "" {
				if `"`eqline'"' != "" {
					local eqline = "`eqline', `distrparams'"
				}
				else {
					local eqline = `"`distrparams'"'
				}
		 	}
		 	local eqline = "`ylist', `likelihood'(`eqline') nocons"
		}
		else { // evaluator ->
			local zero `0'
			local 0 `evaluator'
			syntax [anything] [,		///
				PARAMeters(string)	///
				EXTRAVARS(string)	///
				PASSTHRUopts(string) *]

		 	local evaluator `anything'
		 	local 0 `zero'
		 	if `"`evaluator'"' == "" {
				di as err "evaluator must be specified"
				exit 198 
		 	}

			if `"`extravars'"' != "" {
				capture confirm variable `extravars'
				if _rc {
					local tok: word count `extravars'
					if `tok' > 1 {
di as err "invalid option {bf:extravars()}:"
di as err `"{bf:`extravars'} must be variables"'
					}
					else {
di as err "invalid option {bf:extravars()}:"
di as err `"{bf:`extravars'} must be a variable"'
					}
					exit 198
				}
		 	}

		 	if `"`parameters'"' != "" { 
				gettoken tok parameters: parameters, ///
					parse("\ ") bind bindcurly
				while `"`tok'"' != "" {
					capture confirm number `tok'
					if _rc { 
						tokenize `"`tok'"', parse("{}")
						if `"`1'"' != "{" | ///
						   `"`3'"' != "}" {
di as err "invalid option {bf:parameters()}:"				
di as err `"{bf:`tok'} must be a model parameter"'
exit 198
						}
					}
					if `"`progparams'"' != "" {
						local progparams ///
							`progparams',`tok'
					}
					else {
						local progparams `tok'
					}
					gettoken tok parameters : ///
					parameters, parse("\ ") bind bindcurly
				}
				local ct 1
				while `ct' > 0 {
					local progparams : subinstr local ///
						progparams ",," "," , ///
						count(local ct)
				}
				if `"`xlist'"' != "" { 	 	 	 
					local eqline = ///
				`"`ylist', `evaluator'(`xlist',`progparams') nocons"'
				}
				else {
					local eqline = ///
				`"`ylist', `evaluator'(`progparams') nocons"'	
				}
			}
		 	else {
				local eqline = ///
				`"`ylist', `evaluator'(`xlist') nocons"'
	 		}
		}

		// replace xbdefines and redefines
		_mcmc_definereplace `"`eqline'"'
		mata: `mcmcobject'.add_predict_factor(`"`ylist'"', `"`s(expr)'"', `"`list_sub_exprs'"', `"`sub_exprs_vars'"')

		if $MCMC_debug {
			di " "
			di _asis `"	 	parse: `eqline'"'
		}

		_mcmc_parse equation `eqline'

		local list_distr `list_distr' `s(dist)'
		local list_wtype `list_wtype' `exp1'
		local list_wexp  `list_wexp'  `weight1'

		if `"`evaluator'"' == "" {
			mata: `mcmcobject'.add_distr_name(	///
				`"`s(dist)'"',			///
				`"`weight1'"',			///
				`"`exp1'"',			///
				0, "", "", "")
		}
		else {
			mata: `mcmcobject'.add_distr_name(	///
				`"`s(dist)'"',			///
				`"`weight1'"',			///
				`"`exp1'"',			///
				1,				///
				`"`progparams'"', 		///
				`"`extravars'"', 		///
				`"`passthruopts'"')
		}

		// update beta_label lists
		local varlist0 `s(xprefix)'
		local varlist  `s(x)'
		gettoken lyvar varlist0 : varlist0
		gettoken next  varlist  : varlist
		while `"`next'"' != "" { 
			if `"`lyvar'"' != "." & `"`lyvar'"' != "" {
				_bayesmh_eqlablist ind `lyvar'
				_bayesmh_eqlablist up  `lyvar' `next' `s(ylabind)'
			}
			gettoken lyvar varlist0 : varlist0
			gettoken next  varlist  : varlist
		}

		local list_depvar_names `list_depvar_names' `s(y)'
		local list_eq_names	`list_eq_names' `s(yprefix)'

		local list_par_names	`list_par_names' `s(x)'
		local list_par_prefix   `list_par_prefix' `s(xprefix)'
		local list_par_isvar	`list_par_isvar' `s(xisvar)'

		local list_expr `"`list_expr' `s(eval)'"'
		if `"`s(y)'"' == "" && `"`s(eval)'"' == "" {
			di as err `"{bf:`eqline'} not allowed"'
			exit 198 
		}	

		// extra dependent params from definitions
		local extravars `extravars' `s(exvarlist)'
		local exparams
		local varlist `s(exvarlist)'
		gettoken next varlist : varlist
		while "`next'" != "" {
			if regexm(`"$MCMC_genvars"', "`next'") {
				tokenize $MCMC_eqlablist
				local ylabind 1
				while `"`1'"' != "" & `"`next'"' != `"`1'"' {
					local ylabind = `ylabind'+1
					mac shift
				}
				local ltemp MCMC_betapar_`ylabind'
				local exparams = `"`exparams' $`ltemp'"'
			}
			gettoken next varlist : varlist
		}
		while regexm(`"`exparams'"', "{") {
			local exparams = regexr(`"`exparams'"', "{", "")
		}
		while regexm(`"`exparams'"', "}") {
			local exparams = regexr(`"`exparams'"', "}", "")
		}

		// replace the likelihood evaluators with list_sub_exprs
		local evallist = `"`s(eval)'"'
		local eval
		gettoken next evallist : evallist
		gettoken sexpr list_sub_exprs : list_sub_exprs
		while `"`next'"' != "" & `"`sexpr'"' != "" & `"`sexpr'"' != "xb" {
			local eval `"`eval' "`sexpr'""'
			gettoken next evallist : evallist
			gettoken sexpr list_sub_exprs : list_sub_exprs
		}
		while `"`next'"' != "" {
			local eval `"`eval' "`next'""'
			gettoken next evallist : evallist
		}

		local xisvar   `s(xisvar)'
		local eval     `"`eval'"'
		local evallist `s(evallist)'
		if "`moptobject'" != "" {
			while regexm(`"`xisvar'"', "1") {
				local xisvar = regexr(`"`xisvar'"', "1", "0")
			}
			while regexm(`"`eval'"', "xb") {
				local eval = regexr(`"`eval'"', "xb", "NULL")
			}
			while regexm(`"`evallist'"', "xb") {
				local evallist = regexr(`"`evallist'"', "xb", "NULL")
			}
		}

		mata: `mcmcobject'.add_factor()
		mata: `mcmcobject'.set_factor(			///
		 	NULL,	 	 	 	 	///
		 	"`s(dist)'",	 			///
		 	`"`eval'"', "`evallist'",		///
		 	"`s(exprhasvar)'",	 	 	///
		 	"`s(argcount)'",	 	 	///
		 	"`s(y)'",	 	 	 	///
		 	"`s(yisvar)'",	 	 	 	///
		 	"`s(yislat)'",	 	 	 	///
		 	"`s(yismat)'",	 	 	 	///
		 	"`s(yprefix)'",	 	 		///
		 	"`s(yinit)'",	 	 	 	///
		 	"`s(yomit)'",	 	 	 	///
		 	"`s(x)'",				///
		 	"`xisvar'",	 	 	 	///
		 	"`s(xislat)'",	 	 	 	///
		 	"`s(xismat)'",	 	 	 	///
			"`s(xisfact)'",		 	 	///
		 	"`s(xprefix)'",	 	 		///
		 	"`s(xargnum)'",	 	 		///
		 	"`s(xinit)'",				///
		 	"`s(xomit)'",				///
		 	"`s(nocons)'",				///
			"`exparams'",                           ///
		 	`"`llevaluator'"',			///
		 	`"`extravars'"',			///
			`"`passthruopts'"',                     ///
			"`moptobject'",				///
			"`predict'")

		// markout missing observations from varlist
		markout `touse' `s(varlist)' `sub_exprs_vars'
		// touse marks the current equation, update the global touse
		quietly replace `gtouse' = `gtouse' | `touse'

		if `"`weightexp'"' != "" {
	 		gettoken next weightexp : weightexp, ///
	 			parse("\ =") match(paren)
		 	if "`weightexp'" == "" local weightexp "`next'"

			capture confirm variable `weightexp'
			if _rc {
				tempvar wexptemp
				qui generate double `wexptemp' = `weightexp'
				mata: `mcmcobject'.set_touse(		///
					NULL, 				///
					st_data(., "`touse'"),		///
					`"`ifinopt'"',			///
					st_data(., "`wexptemp'"),	///
					`"`weight1'"',			///
					`"`weightopt'"')
			}
			else {
				mata: `mcmcobject'.set_touse(		///
					NULL, 				///
					st_data(., "`touse'"),		///
					`"`ifinopt'"',			///
					st_data(., "`weightexp'"),	///
					`"`weight1'"',			///
					`"`weightopt'"')
			}
		}
		else {
		 	mata: `mcmcobject'.set_touse(		///
				NULL,				///
				st_data(., "`touse'"),		///
				`"`ifinopt'"',			///
				J(1,0,0),			///
				`"`weight1'"',			///
				`"`weightopt'"')
		}
	} // end of while

	_bayes_initials parse `"`initial'"' `"`priors'"' `"`gtouse'"' `nchains'
	local initial `"`r(initial)'"'
	local priors `"`r(options)'"'

	// form the title
	if `"`lbayesianmethod'"' == "" {
		local lbayesianmethod "Bayesian regression"
	}
	mata: `mcmcobject'.m_title = `"`lbayesianmethod'"'

	_bayesmh_check_parameters `""`list_par_names'""'	///
		`""`list_par_prefix'""'			///
		`""`list_par_isvar'""'			///
		`""`list_depvar_names'""'		///
		`""`list_eq_names'""'

	mata: `mcmcobject'.set_depvar_names(`"`s(depvar_names)'"')
	mata: `mcmcobject'.set_var_names(`"`s(var_names)'"')
	mata: `mcmcobject'.set_eq_names(`"`s(eq_names)'"')

	local singley ""
	tokenize $MCMC_eqlablist
	if `"`1'"' != "" & `"`2'"' == "" {
		local singley `1'
	}

	_bayes_prior_opt "`mcmcobject'" "`gtouse'" "`singley'" `"`priors'"'

	local options		= `"`s(options)'"'
	local optinitial	= `"`optinitial' `s(optinitial)'"'
	local list_par_names	= `"`list_par_names' `s(list_par_names)'"'
	local list_par_prefix	= `"`list_par_prefix' `s(list_par_prefix)'"'
	local list_par_isvar	= `"`list_par_isvar' `s(list_par_isvar)'"'
	local list_expr		= `"`list_expr' `s(list_expr)'"'
	local extravars		= `"`extravars' `s(extravars)'"'

	_bayesmh_check_parameters		///
		`""`list_par_names'""'	///
		`""`list_par_prefix'""'	///
		`""`list_par_isvar'""'

	mata: `mcmcobject'.set_var_names(`"`s(var_names)'"')
	mata: `mcmcobject'.add_list_expr(`"`list_expr'"'   )

	if `"`parseonly'"' != "" {
		if $MCMC_debug != 0 {
			di as text `"{bf:`parseonly'} exit"'
		}
		/// sreturn
		sreturn clear
		sreturn local mcmcobject   = `"`mcmcobject'"'
		sreturn local tempidentmat = `"`tempidentmat'"'

		// clean up the label list
		local lablist $MCMC_eqlablist
		local eqlablist
		// populate eqlablist only if there are eq-labeled parameters
		if `"$MCMC_beta_1"' != "" {
			gettoken ylabel lablist : lablist
			while `"`ylabel'"' != "" {
				local eqlablist `eqlablist' {`ylabel':}
				gettoken ylabel lablist : lablist
			}
		}

		// list of shortcuts {ylab:}
		sreturn local eqnames	= `"`eqlablist'"'
		sreturn local fveqlist	= `"`fveqlist'"'
		sreturn local relablist	= `"`relablist'"'
		sreturn local reparams	= `"`reparamlist' `redefparams'"'
		sreturn local nchains		= `nchains'
		exit 0
	}

	local blocks `reblocks' `options'

	_bayes_block_opt "`gtouse'" `"`blocks'"' `"`allreffects'"'

	local simoptions = `"`s(simoptions)'"'
	local blocksline = `"`s(blocksline)'"'

	_mcmc_parse blocks `blocksline'
	mata: `mcmcobject'.set_blocks(				///
	`"`s(params)'"',  `"`s(parids)'"', `"`s(prefix)'"',	///
	`"`s(matrix)'"',  `"`s(latent)'"',	 		///
	`"`s(sampler)'"', `"`s(split)'"',	 		///
	`"`s(scale)'"',   `"`s(cov)'"',	 	 		///
	`"`s(arate)'"',   `"`s(atol)'"')

	if `"$MCMC_latent"' != "" {
		local haslvparams haslvparams
	}

	_bayesmh_check_opts ,`simoptions' adaptation(`adaptation') `haslvparams'
	local simoptions `"`s(simoptions)'"'
	local adaptation `"`s(adaptation)'"'

	if "`exclude'" != "" {
		_mcmc_fv_decode	`"`exclude'"' `gtouse'
		_mcmc_parse expand `s(outstr)'
		local exclude `s(eqline)'
	}

	// expand shortcuts in `exclude', `noshow', `show', and `initial'
	local lablist $MCMC_eqlablist
	gettoken ylabel lablist : lablist
	local ylabind 1
	while `"`ylabel'"' != "" {
		local ltemp MCMC_betapar_`ylabind'
		while regexm(`"`exclude'"', `"{`ylabel':}"') {
			local exclude = regexr(`"`exclude'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`showreffects1'"', `"{`ylabel':}"') {
			local showreffects1 = regexr(`"`showreffects1'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		while regexm(`"`initial'"', `"{`ylabel':}"') {
			local initial = regexr(`"`initial'"', ///
				`"{`ylabel':}"', `"$`ltemp'"')
		}
		gettoken ylabel lablist : lablist
		local `++ylabind'
	}

	if $MCMC_debug {
		di " "
		di _asis `"exclude: `exclude'"'
		di " "
		di _asis `"show: `show'"'
		di " "
		di _asis `"noshow: `noshow'"'
		di " "
		di _asis `"initial: `initial'"'
	}

	local allreffectspar `reparamlist' `redefparams'
	if `"`allreffectspar'"' != "" & `"`showreffects1'"' != "" {
		capture _mcmc_fv_decode	`"`showreffects1'"' `gtouse'
		if _rc {
			di as err "invalid random-effects parameter " ///
				`"{bf:`showreffects1'} in option "'   ///
				"{bf:showreffects()}" 
			exit 198
		}
		_mcmc_parse expand `s(outstr)'
		local showpars `s(eqline)'

		_mcmc_expand_paramlist `"`showpars'"' `"`allreffectspar'"'

		local commonstr : list showpars - allreffectspar
		if `"`commonstr'"' != "" {
			di as err "invalid random-effects parameters " ///
				`"{bf:`showreffects1'} in option "'    ///
				"{bf:showreffects()}" 
				exit 198
		}
		local allreffectspar : list allreffectspar - showpars
	}
	if `"`showreffects'"' == "" {
		local noshow `noshow' `allreffectspar'
	}

	local simoptions `simoptions' `showreffects'
	if `"`showreffects1'"' != "" {
		local simoptions `simoptions' showreffects(`showreffects1')
	}
	if `"`noshow'"' != "" {
		local simoptions `simoptions' noshow(`noshow')
	}
	if `"`show'"' != "" {
		local simoptions `simoptions' show(`show')
	}

	// sreturn
	sreturn clear
	sreturn local mcmcobject	= `"`mcmcobject'"'
	sreturn local simoptions	= `"`simoptions' `adaptation' `extraopts'"'
	sreturn local initial	  	= `"`initial'"'
	sreturn local optinitial	= `"`optinitial'"'
	sreturn local initrandom	= `"`initrandom'"'
	sreturn local exclude		= `"`exclude'"'
	sreturn local noshow		= `"`noshow'"'
	sreturn local show		= `"`show'"'
	sreturn local rseed		= `"`rseed'"'
	sreturn local dryrun		= `"`dryrun'"'
	sreturn local noexpression	= `"`noexpression'"'
	sreturn local nomodelsummary	= `"`nomodelsummary'"'
	sreturn local reparams		= `"`reparamlist' `redefparams'"'
	sreturn local nchains		= `nchains'
end

program _set_moptobject, sclass

	args dist yvar ylabel xvarlist eqnocons distopts ///
		touse weightopt moptobject
	
	if `"`moptobject'"' == "" {
		exit 0
	}

	tempname mb tmodel

	tokenize `"`dist'"', parse(`"""')
	local dist `1'
	tokenize `"`yvar'"', parse(`"""')
	local yvar `1'
	tokenize `"`ylabel'"', parse(`"""')
	local ylabel `1'
	tokenize `"`xvarlist'"', parse(`"""')
	local xvarlist `1'
	tokenize `"`eqnocons'"', parse(`"""')
	local eqnocons `1'
	tokenize `"`distopts'"', parse(`"""')
	local distopts `1'

	if `"`touse'"' != "" {
		local touse if `touse'
	}

	local moptopt moptobj(`moptobject')

	capture _estimates hold `tmodel'

	local eqvarlist `yvar' `xvarlist'
	if `"`dist'"' == "gsem" {
		local eqvarlist (`yvar' <- `varlist')
	}
di `"_set_moptobject: `dist' `eqvarlist' `touse' `weightopt', `eqnocons' `distopts' `moptopt'"'
	capture `dist' `eqvarlist' ///
		`touse' `weightopt', `eqnocons' `distopts' `moptopt'
	if _rc {
		capture `dist' `eqvarlist' ///
			`touse' `weightopt', `distopts' `moptopt'
	}
	if _rc {
		_mcmc_distr invalid_lik_err `dist'
		exit 198
	}

	local depvar `e(depvar)'
	mat `mb' = e(b) 
	local paramlist: colfullnames `mb'

	local ylabexcl
	if ("`dist'"=="mlogit") {
		local yvars `e(eqnames)'
		local toks `e(eqnames)'
		local ylabexcl `e(baseout)'
		if `"`ylabexcl'"' == "" {
			local ylabexcl `e(k_eq_base)'
		}
		local ylabexcl: word `ylabexcl' of `toks'
	}
	else if ("`dist'"=="mprobit") {
		local yvars `e(outeqs)'
		local ylabexcl `e(out`e(k_eq_model_skip)')'
	}
	else if ("`dist'"=="mvreg") {
		local yvars `e(depvar)'
	}

	local varlist: colnames `mb'
	if `"`varlist'"' == `"`paramlist'"' {
		local paramlist
		gettoken next varlist : varlist
		while `"`next'"' != "" {
			local paramlist `"`paramlist'`yvar':`next' "'
			gettoken next varlist : varlist
		}
	}
	
	if "`ylabexcl'" != "" {
		local varlist `paramlist'
		local paramlist
		gettoken next varlist : varlist
		while `"`next'"' != "" {
			gettoken lab par : next, parse(":")
			local n : list lab in ylabexcl
			if `n' == 0 {
				local paramlist `"`paramlist'`next' "'
			}
			gettoken next varlist : varlist
		}
		local yvars : list yvars - ylabexcl
	}

	local optinitial ""
	local varlist `paramlist'
	local paramlist
	gettoken next varlist : varlist
	local j 0
	while `"`next'"' != "" {
		local ++j
		tokenize `next', parse(":")

		// free parameter starting with slash
		gettoken tok lab : next, parse("/")
		if `"`tok'"' == "/" {
			local paramlist `"`paramlist'{`lab'} "'
			gettoken next varlist : varlist
			continue
		}
		if regexm(`"`3'"', "o\.") {
			// Skip parameters #:o.*, -mlogit- and -mprobit-
			gettoken next varlist : varlist
			continue
		}
		local paramlist `"`paramlist'{`next'} "'
		local optinitial = ///
			`"{`next'} `=(`mb'[1,`j'])' `optinitial'"'
		gettoken next varlist : varlist
	}

	capture mata: `moptobject'
	if _rc == 0 {
		global MCMC_moptobjs $MCMC_moptobjs `moptobject'
	}
	else {
		di as err "Cannot initialize moptobj"
		exit _rc
	}

	capture _estimates unhold `tmodel'

	sreturn clear
	sreturn local depvar     = `"`depvar'"'
	sreturn local moptparams = `"`paramlist'"'
	sreturn local optinitial = `"`optinitial'"'
end

program _mle_initials, sclass

	args dist yvar ylabel xvarlist eqnocons distrparams distopts ///
		touse weightopt reffects

	tempname mb tmodel

	tokenize `"`dist'"', parse(`"""')
	local dist `1'
	tokenize `"`yvar'"', parse(`"""')
	local yvar `1'
	tokenize `"`ylabel'"', parse(`"""')
	local ylabel `1'
	tokenize `"`xvarlist'"', parse(`"""')
	local xvarlist `1'
	tokenize `"`eqnocons'"', parse(`"""')
	local eqnocons `1'
	tokenize `"`distrparams'"', parse(`"""')
	local distrparams `1'
	tokenize `"`distopts'"', parse(`"""')
	local distopts `1'

	local optinitial ""

	if `"`touse'"' != "" {
		local touse if `touse'
	}

	if "`xvarlist'" == "" & "`eqnocons'" != "" {
	
		if "`dist'" == "dpoisson" | "`dist'" == "dexponential" {
			_mcmc_parse args `distrparams'
			if `"`distrparams'"' == `"`s(param1)'"' {
				capture summ `yvar', meanonly
				if _rc == 0 {
					local optinitial = ///
					`"`distrparams' `=r(mean)' `optinitial'"'
				}
			}
		}

		sreturn local optinitial = `"`optinitial'"'
		exit 0
	}

	local consin _cons
	local consin : list consin in xvarlist
	if `consin' {
		local consin _cons
		local xvarlist : list xvarlist - consin
		local eqnocons
	}

	capture _estimates hold `tmodel'

	if "`dist'" == "normal" | "`dist'" == "mvnormal" | ///
	   "`dist'" == "mvnormal0" {
		capture regress `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' 
		if _rc & `"`reffects'"' != "" {
			capture regress `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' 
		}
		if _rc == 0 {
		 	scalar min_rmse = `e(rmse)'
			if min_rmse <= 0 {
				scalar min_rmse = 1
			}
		 	mat `mb' = e(b)
		 	local varlist: colnames `mb'
		 	gettoken next varlist : varlist
		 	local j 0
		 	while `"`next'"' != "" { 
				local ++j
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}

			tokenize `"`distrparams'"', parse("{}=,")
			if `"`1'"' == "{" & `"`2'"' != "" & `"`3'"' == "}" {
				local optinitial = /// 
					`"{`2'} `=(min_rmse^2)' `optinitial'"'
			}
		}
	}

	if "`dist'" == "probit" | "`dist'" == "logit"  | "`dist'" == "mlogit" {
		capture `dist' `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' `distopts'
		if _rc & `"`reffects'"' != "" {
			capture `dist' `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' `distopts'
		}
		if _rc == 0 {
		 	mat `mb' = e(b)
		 	local varlist: colnames `mb'
		 	gettoken next varlist : varlist
		 	local j 0
		 	while `"`next'"' != "" {
				local ++j
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}
	
	if "`dist'" == "poissonreg" | "`dist'" == "poisson" { 
		capture poisson `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `eqnocons' `distopts'
		if _rc & `"`reffects'"' != "" {
			capture poisson `yvar' `xvarlist' ///
				`touse' `weightopt', `eqnocons' `distopts'
		}
		if _rc == 0 { 
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "expreg" | "`dist'" == "exponential" { 
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(exponential)
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
				`eqnocons' `distopts' family(exponential)
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "binlogit" | "`dist'" == "binomial" {
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(binomial `distrparams')
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
			`eqnocons' `distopts' family(binomial `distrparams')
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" {
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
			`"{`ylabel':`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}

	if "`dist'" == "lognormal" {
		capture gsem `yvar' <-`xvarlist' `reffects' `touse' `weightopt', ///
			`eqnocons' `distopts' family(lognormal)
		if _rc & `"`reffects'"' != "" {
			capture gsem `yvar' <-`xvarlist' `touse' `weightopt', ///
				`eqnocons' `distopts' family(lognormal)
		}
		if _rc == 0 {
			mat `mb' = e(b)
			local varlist: colfullnames `mb'
			gettoken next varlist : varlist
			local j 0
			while `"`next'"' != "" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
				`"{`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
			}
		}
	}
	
	if "`dist'" == "ologit" | "`dist'" == "oprobit" {
		capture `dist' `yvar' `xvarlist' `reffects' ///
			`touse' `weightopt', `distopts'
		if _rc & `"`reffects'"' != "" {
			capture `dist' `yvar' `xvarlist' ///
				`touse' `weightopt', `distopts'
		}
		if _rc == 0 { 
			mat `mb' = e(b)
			local varlist: colfullnames `mb'
			gettoken next varlist : varlist
			gettoken tok next : next, parse(":")
			local j 0
			while `"`next'"' != "" & `"`tok'"' == "`ylabel'" { 
				local `++j'
				if regexm(`"`next'"', "o\.") {
					gettoken next varlist : varlist
					continue
				}
				local optinitial = ///
`"{`tok'`next'} `=(`mb'[1,`j'])' `optinitial'"'
				gettoken next varlist : varlist
				gettoken tok next : next, parse(":")
			}
			local next `tok'`next'
			local k 0
			while `"`next'"' != "" { 
				local `++k'
				local `++j'
				gettoken tok next : next, parse("/")
				if `"`next'"' == "" local next `tok'
				gettoken tok : next, parse(":")
				if `"`tok'"' == "cut`k'" {
				local optinitial = ///
`"{`ylabel':_cut`k'} `=(`mb'[1,`j'])' `optinitial'"'
				local varlist0 = `"`varlist0' `ylabel':_cut`k'"'
				}
				gettoken next varlist : varlist
		 	}
		}
	}

	capture _estimates unhold `tmodel'

	sreturn local optinitial = `"`optinitial'"'
end

program _mcmc_getmleopts
	args mleopts colon dist distopts	
	local 0 ,`distopts'
	syntax [, OFFset(passthru) EXPosure(passthru) ///
		  BASEoutcome(passthru) * ]		  
	c_local `mleopts' "`offset' `exposure' `baseoutcome'"
end
