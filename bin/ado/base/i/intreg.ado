*! version 3.8.0  22mar2018
program define intreg, eclass byable(onecall) ///
			prop(svyb svyj svyr ml_score swml bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun intreg, numdepvars(2) alldepsmissing	///
		mark(Het OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"intreg `0'"'
		exit
	}

	version 8.1, missing
	if _caller() < 8 {
		intreg_7 `0'
		exit
	}
	if replay() {
		if `"`e(cmd)'"'!="intreg" {
			error 301
		}
		if _by() {
			error 190
		}
		DiIntreg `0' /* display results */
		error `e(rc)'
		exit
	}
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"intreg `0'"'
end

program Estimate, eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}
	version 8.1, missing
/* Parse and check options. */

	syntax	varlist(min=2 numeric fv ts)	/*
	*/	[aw fw pw iw] [if] [in]		/*
	*/	[,				/*
	*/	Level(cilevel)			/*
	*/	NOLOg LOg			/*
	*/	OFFset(varname numeric)		/*
	*/	noCONstant			/*
	*/	Robust			/*
	*/	CLuster(passthru)	/*
	*/	VCE(passthru)		/*
	*/	SCore(string)		/*
	*/	noDISPLAY		/*
	*/	CONSTraints(string)	/*
	*/	FROM(string)		/*
	*/	Het(string)		/*
	*/	CRITTYPE(passthru)	/*
	*/	noTRANSform		/* NOT DOCUMENTED
	*/	moptobj(passthru)	/* NOT DOCUMENTED
	*/	*			/*
	*/	]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11: "
		}
		local mm e2
		local negh negh pupdated
	}
	else {
		local mm d2
	}

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	_vce_parse, argopt(CLuster) opt(OIM OPG Robust) old	///
		: [`weight'`exp'], `vce' `robust' `cluster'
	local robust `r(robust)'
	local cluster `r(cluster)'
	local vce `"`r(vceopt)'"'

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' const(`constraints') `log' `nolog'
	local coll `s(collinear)'
	local mlopts `mlopts' `crittype'

	gettoken y1 rhs : varlist
	_fv_check_depvar `y1', depname(depvar1)
	tsunab y1 : `y1'
	gettoken y2 rhs : rhs
	_fv_check_depvar `y2', depname(depvar2)
	tsunab y2 : `y2'

	if "`constant'"!="" & "`rhs'"=="" {
		di as err /*
		*/ "independent variables required with noconstant option"
		exit 100
	}
	if "`weight'"!="" {
		if "`weight'"!="fweight" {
			local wt "aweight"
		}
		else	local wt "fweight"
	}
	if `"`score'"'!="" {
		local nword : word count `score'
		if `nword'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local nword 2
		}
		confirm new variable `score'
		if `nword' != 2 {
			di as err "score() must contain the names of " /*
			*/ "two new variables"
			exit 198
		}
		tempvar s1 s2
		local scopt score(`s1' `s2')
	}
	if "`offset'"!="" {
		tempvar offvar
		qui gen double `offvar' = `offset'
		local offopt offset(`offvar')
	}
	global S_ML_off `offset'
	global S_ML_ofv `offvar'

	if "`het'" != "" {
		ParseHet `het'
		local hetvar "`r(varlist)'"
		local hetnocns "`r(constant)'"
		if !`fvops' {
			local fvops = "`s(fvops)'" == "true"
		}
	}


/* Mark/markout. */

	tempvar doit z

	mark `doit' [`weight'`exp'] `if' `in'
	qui replace `doit' = 0 if `y1'>=. & `y2'>=.

/* Check that `y1'<=`y2' and markout independent variables. */

	capture assert `y1'<=`y2' if `y1'<. & `y2'<. & `doit'
	if _rc {
		di as err `"observations with `y1' > `y2' not allowed"'
		exit 498
	}
	markout `doit' `rhs' `offset' `hetvar'
	if "`cluster'"!="" {
		markout `doit' `cluster', strok
	}

/* Count number of observations (and issue error 2000 if necessary). */

	_nobs `doit' [`weight'`exp']
	local N `r(N)'
	_nobs `doit' [`weight'`exp'] if `y1'==`y2', min(0)
	local Nunc `r(N)'
	_nobs `doit' [`weight'`exp'] if `y1'>=., min(0)
	local Nlc `r(N)'
	_nobs `doit' [`weight'`exp'] if `y2'>=., min(0)
	local Nrc `r(N)'

/* Remove collinearity. */
	
	fvexpand `rhs'
	local rhsorig `r(varlist)'	
	if "`y1'" == "`y2'" {
		`vv' ///
		_rmdcoll `y1' `rhs' [`weight' `exp'] if `doit',	///
			`constant' `coll'
		local rhs `r(varlist)'
	}
	else {
		`vv' ///
		cap _rmdcoll `y1' `rhs' [`weight' `exp'] if `doit',	///
			`constant' `coll'
		if _rc == 459 {
		`vv' ///
		cap _rmdcoll `y2' `rhs' [`weight' `exp'] if `doit',	///
			`constant' `coll'
		}
		if _rc != 0 {
			if _rc == 459 {
				dis as err /*
		*/ "`y1' and `y2' collinear with independent variables"
				exit 459
			}
			error _rc
		}		
		local rhs `r(varlist)'
	}
	// collinearity report
	local i 1
	foreach var of local rhs {
		local xname : word `i' of `rhsorig'
		_ms_parse_parts `var'
		if `r(omit)' {
			_ms_parse_parts `xname'
			if !`r(omit)' {
				noi di as txt "note: `xname' omitted" /*
					*/ " because of collinearity"
			}
		}
		local ++i
	}
	
	if "`het'" != "" {
		`vv' ///
		_rmcoll `hetvar' [`weight' `exp'] if `doit' /*
			*/ , `hetnocns' `coll'
		local hetvar `r(varlist)'
	}
	else {
		local diparm diparm(lnsigma, exp label("sigma"))
	}

/* Set up estimator */

	if "`constraints'`from'`het'`transform'" != "" {
		local prog "intrg_ll2"
		local star "*"
		local modeleq `"(model: `y1' `y2'=`rhs', `constant' `offopt')"'
		local sigmaeq `"(lnsigma: `hetvar', `hetnocns')"'
	}
	else {
		local prog "intrg_ll"
		local sigmaeq `"(lnsigma:)"'
	}

/* Starting values */
	
	if "`from'" != "" {
		local initopt "init(`from')"
	}

	else if "`het'" == "" {

/* Generate variable `z' to get starting values. */

		if "`constraints'`from'`transform'" == "" & "`offset'"!="" {
			local moff "-`offset'"
		}

		qui gen double `z' = cond(`y1'<.&`y2'<.,(`y1'+`y2')/2, /*
		*/		 cond(`y1'<.,`y1',`y2')) `moff' if `doit'

		qui summarize `z' [`wt'`exp'] if `doit'

/* Set up initial values for the constant-only model. */

		if "`constant'"=="" {
			tempname b00
			matrix `b00' = (0, 1/sqrt(r(Var)))
			matrix colnames `b00' = model:_cons sigma:_cons
		}

/* Remove approximate mean from dependent variables if constant.  Handle
offset by removing it from dependent variables.  Since maximization is in
beta/sigma metric, -ml- cannot handle offset.  */

		if "`constraints'`from'`transform'" == "" & ("`constant'"=="" /*
			*/ | "`offset'"!="") {
			if "`constant'"=="" {
				tempname mean
				scalar `mean' = r(mean)
				qui replace `z' = `z' - `mean' if `doit'
			}
			else	local mean 0
			tempvar  z1 z2
			qui gen double `z1' = `y1'-`mean'`moff' if `doit'
			qui gen double `z2' = `y2'-`mean'`moff' if `doit'
		}
		else {
			local z1 `y1'
			local z2 `y2'
			local mean 0
		}

/* Get initial values for the full model. */

		if "`constraints'" != "" | "`rhs'" != "" {
			tempname bs b0
			`vv' ///
			qui _regress `z' `rhs' [`wt'`exp'] if `doit', `constant'
			if "`constraints'" == "" {
				matrix `bs' = (1/e(rmse))
				matrix `b0' = `bs'*e(b)
				matrix colnames `bs' = lnsigma:_cons
			}
			else {			/* will call -intrg_ll2- */
				matrix `bs' = ln(e(rmse))
				matrix `b0' = e(b)
				matrix colnames `bs' = lnsigma:_cons
			}
			matrix coleq `b0' = model
			matrix `b0' = `b0' , `bs'
			local initopt init(`b0', copy)
		}

		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
/* Fit constant-only model. */

		if "`constant'"=="" {
			if "`log'"=="" {
				di as txt _n "Fitting constant-only model:"
			}

			`vv' ///
			ml model `mm' `prog'		/*
			*/ (model: `z1' `z2'=)		/*
			*/ `sigmaeq'			/*
			*/ [`weight'`exp'] if `doit',	/*
			*/ init(`b00', copy)		/*
			*/ `mlopts'			/*
			*/ noout			/*
			*/ missing			/*
			*/ collinear			/*
			*/ nopreserve			/*
			*/ obs(`N')			/*
			*/ maximize			/*
			*/ search(off)			/*
			*/ `robust'			/*
			*/ nocnsnotes			/*
			*/ `negh'

			local contin continue
		}
		local modeleq `"(model: `z1' `z2'=`rhs', `constant')"'
	}

	else {

/* Heteroskedasticity */

		qui intreg `y1' `y2' `rhs' [`weight'`exp'] if `doit', /*
			*/ `constant' `coll' const(`constraints')
		tempname b0 b00 b_start
		tempvar sigma_con
		mat `b0'=e(b)
		local matlen=colsof(`b0')-1
		mat `b00'=`b0'[1,1..`matlen']
/* Changed to accommodate case where sigma < 1 */
		if `b0'[1,colsof(`b0')] > 0 {
			qui gen `sigma_con'=ln(`b0'[1,colsof(`b0')])
		}
		else {
			qui gen `sigma_con'=0
		}
		`vv' ///
		qui _regress `sigma_con' `hetvar' [`wt'`exp'] if `doit', ///
			`hetnocns'
		mat `b_start'=(`b00', e(b))
		local initopt "init(`b_start', copy)"
	}


/* Branch off for fitting full [constrained] model */
	if "`log'"=="" {
		di _n as txt "Fitting full model:"
	}

/* Fit full model. */

	`vv' ///
	ml model `mm' `prog'				/*
		*/ `modeleq'				/*
		*/ `sigmaeq'				/*
		*/ [`weight'`exp'] if `doit',		/*
		*/ `initopt'				/*
		*/ `mlopts'				/*
		*/ `vce'				/*
		*/ `scopt'				/*
		*/ `contin'				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ obs(`N')				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/ `diparm'				/*
		*/ `negh'				/*
		*/ `moptobj'

	ereturn local cmd
	global S_E_cmd

/* MLE was done in (beta/sigma, 1/sigma) metric.
   Transform back to (beta, sigma).
*/
	`star' UnTrans `mean' `s1' `s2'

	ereturn scalar N_unc = `Nunc'
	ereturn scalar N_lc  = `Nlc'
	ereturn scalar N_rc  = `Nrc'
	ereturn scalar N_int = e(N) - e(N_unc) - e(N_lc) - e(N_rc)

	if "`het'" == "" {
		ereturn scalar sigma = exp([lnsigma]_cons)
		ereturn scalar se_sigma = exp([lnsigma]_cons) /*
			*/ *[lnsigma]_se[_cons]
		ereturn scalar k_aux = 1
	}
	ereturn local predict "intreg_p"
	ereturn local marginsok	default			///
				XB			///
				Pr(passthru)		///
				E(passthru)		///
				YStar(passthru)

	if "`het'" != "" {
		ereturn local het "heteroskedasticity"
	}

	if "$S_BADLC"!="" {
		ereturn scalar N_lcout = $S_BADLC
			/* # outlier intervals approximated as LC */
		global S_BADLC
	}
	if "$S_BADRC"!="" {
		ereturn scalar N_rcout = $S_BADRC
			/* # outlier intervals approximated as RC */
		global S_BADRC
	}
	ereturn local title  "Interval regression"
	ereturn local depvar `y1' `y2'
	ereturn local offset `offset'

/* Double save in S_E_. */

	global S_E_nobs `e(N)'
	global S_E_depv `e(depvar)'
	global S_E_ll   `e(ll)'
	global S_E_sig  `e(sigma)'
	global S_E_sesg `e(se_sigma)'

	global S_E_ll0  `e(ll_0)'
	global S_E_chi2 `e(chi2)'
	global S_E_mdf  `e(df_m)'

	if `"`score'"'!=`""' {
		label var `s1' `"intreg score for x*b"'
		label var `s2' `"intreg score for lnsigma"'
		local name : word 1 of `score'
		rename `s1' `name'
		local name : word 2 of `score'
		rename `s2' `name'
		ereturn local scorevars `score'
	}

	ereturn local ml_score intrg_ll2
	ereturn local cmd "intreg"
	global S_E_cmd `e(cmd)'

/* Display results. */

	if "`display'" == "" {
		DiIntreg, level(`level') `diopts'
		error `e(rc)'
	}
end

program ParseHet, rclass
	syntax varlist(fv ts numeric) [, noCONStant]
	return local varlist "`varlist'"
	return local constant `constant'
end

program define DiIntreg
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	version 9: ml display, level(`level') nofootnote `diopts'
	_prefix_footnote

/* Note:  Wald test for sigma on boundary -- not reported.*/

if !missing(e(N_lcout)) | !missing(e(N_rcout)) {

/* The following messages should be VERY rare. */

	if e(N_lcout) == 1 {
		di _n as txt "Note: 1 interval observation was an " /*
		*/ "extreme outlier (large negative residual)" _n /*
		*/ "      and was handled by assuming it was a " /*
		*/ "left-censored observation."
	}
	else if e(N_lcout) <. {
		di _n as txt "Note: `e(N_lcout)' interval observations " /*
		*/ "were extreme outliers (all with large negative" _n /*
		*/ "      residuals) and were handled by " /*
		*/ "assuming they were left-censored observations."
	}
	if e(N_rcout) == 1 {
		di _n as txt "Note: 1 interval observation was an " /*
		*/ "extreme outlier (large positive residual)" _n /*
		*/ "      and was handled by assuming it was a " /*
		*/ "right-censored observation."
	}
	else if e(N_rcout) <. {
		di _n as txt "Note: `e(N_rcout)' interval observations " /*
		*/ "were extreme outliers (all with large positive" _n /*
		*/ "      residuals) and were handled by " /*
		*/ "assuming they were right-censored observations."
	}
	di as txt /*
	*/ "      This is an excellent approximation for all intervals " /*
	*/ "except for those" _n "      that are very narrow."

}  // if

end


program define UnTrans, eclass
	args mean s1 s2

	tempname b V s J
	matrix `b' = e(b)
	local dim = colsof(matrix(`b'))
	scalar `s' = `b'[1,`dim'] /* 1/sigma */

/* Untransform scores. */

	if "`s1'"!="" {
		quietly {
			tempvar xb
			_predict double `xb'
			replace `s2' = -1*(`xb'*`s1'+`s'*`s2')
			replace `s1' = `s'*`s1'
		}
	}

/* Compute Jacobian. */

	matrix `J' = (diag(J(1,`dim'-1,`s')),J(`dim'-1,1,0) /*
	*/ \ -`b'[1,1..`dim'-1],-`s')

/* Untransform variance `V'. */

	if "`e(V_modelbased)'" == "matrix" {
		matrix `V' = e(V_modelbased)
		mat `V' = `J'*syminv(`V')*`J''
		mat `V' = syminv(0.5*(`V' + `V''))
		ereturn matrix V_modelbased `V'
	}

	matrix `V' = e(V)
	mat `V' = `J'*syminv(`V')*`J''
	mat `V' = syminv(0.5*(`V' + `V''))

/* Untransform coefficient vector. */

	matrix `b' = (1/`s')*`b'
	matrix `b'[1,`dim'] = -ln(`s')
	matrix `b'[1,`dim'-1] = `b'[1,`dim'-1] + `mean'

/* Repost. */

	ereturn repost b=`b' V=`V', buildfvinfo

/* Redo Wald test. */

	if "`e(chi2type)'"=="Wald" {
		ereturn scalar chi2 = .
		ereturn scalar p = .

		_evlist

		if "`s(varlist)'"!="" {
			capture _test `s(varlist)', min
			ereturn scalar df_m = r(df)
			ereturn scalar chi2 = r(chi2)
			ereturn scalar p = r(p)
		}
	}
end
