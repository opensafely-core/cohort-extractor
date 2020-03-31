*! version 3.0.6  16feb2015  
program define intreg_7, eclass byable(recall)
	version 8, missing

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

/* Parse and check options. */

	syntax	varlist(min=2 numeric)	/*
	*/	[aw fw pw iw] [if] [in]	/*
	*/	[,			/*
	*/	Level(cilevel)		/*
	*/	noLOg			/*
	*/	OFFset(varname numeric)	/*
	*/	noCONstant		/*
	*/	Robust			/*
	*/	CLuster(varname)	/*
	*/	SCore(string)		/*
	*/	noDISPLAY		/*
	*/	CONSTraints(string)	/*
	*/	*			/*
	*/	]

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	mlopts mlopts, `options' const(`constraints')

	gettoken y1 rhs : varlist
	gettoken y2 rhs : rhs

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
	if "`cluster'"!="" {
		local clopt cluster(`cluster')
	}
	if "`cluster'" != "" | "`weight'" == "pweight" {
		local robust robust
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
	markout `doit' `rhs' `offset'
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

	if "`y1'" == "`y2'" {
		_rmdcoll `y1' `rhs' [`weight' `exp'] if `doit', `constant'
		local rhs `r(varlist)'
	}
	else {
		cap _rmdcoll `y1' `rhs' [`weight' `exp'] if `doit', `constant'
		if _rc != 0 {
		cap _rmdcoll `y2' `rhs' [`weight' `exp'] if `doit', `constant'
		}
		if _rc != 0 {
			dis as err /*
		*/ "`y1' and `y2' collinear with independent variables"
			exit 459
		}		
		local rhs `r(varlist)'
	}

/* Generate variable `z' to get starting values. */

	if "`constraints'" == "" & "`offset'"!="" {
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

	if "`constraints'" == "" & ("`constant'"=="" | "`offset'"!="") {
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
		qui reg `z' `rhs' [`wt'`exp'] if `doit', `constant'
		if "`constraints'" == "" {
			matrix `bs' = (1/e(rmse))
			matrix `b0' = `bs'*e(b)
		}
		else {
			matrix `bs' = e(rmse)
			matrix `b0' = e(b)
		}
		matrix colnames `bs' = sigma:_cons
		matrix coleq `b0' = model
		matrix `b0' = `b0' , `bs'
		local initopt init(`b0')
	}

/* Fit constant-only model. */

	if "`constant'"=="" {
		if "`log'"=="" {
			di as txt _n "Fitting constant-only model:"
		}

		ml model d2 intrg_ll		/*
		*/ (model: `z1' `z2'=)		/*
		*/ /sigma			/*
		*/ [`weight'`exp'] if `doit',	/*
		*/ init(`b00')			/*
		*/ `mlopts'			/*
		*/ `log'			/*
		*/ noout			/*
		*/ missing			/*
		*/ collinear			/*
		*/ nopreserve			/*
		*/ obs(`N')			/*
		*/ maximize			/*
		*/ search(off)			/*
		*/ `robust'			/*
		*/ 

		local contin continue
	}

/* Branch off for fitting full [constrained] model */

	if "`log'"=="" {
		di _n as txt "Fitting full model:"
	}

	if "`constraints'" == "" {

/* Fit full model. */

		ml model d2 intrg_ll			/*
		*/ (model: `z1' `z2'=`rhs', `constant') /*
		*/ /sigma				/*
		*/ [`weight'`exp'] if `doit',		/*
		*/ `initopt'				/*
		*/ `mlopts'				/*
		*/ `robust'				/*
		*/ `clopt'				/*
		*/ `scopt'				/*
		*/ `contin'				/*
		*/ `log'				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ obs(`N')				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/ 

		ereturn local cmd
		global S_E_cmd

/* MLE was done in (beta/sigma, 1/sigma) metric.
   Transform back to (beta, sigma).
*/
		UnTrans `mean' `s1' `s2'

	}
	else {

/* Fit constrained model. */

		if "`ll0'" != "" {
			_est unhold `ll0'
		}
		ml model d2 intrg2_ll			/*
		*/ (model: `y1' `y2' = `rhs', `constant' `offopt')	/*
		*/ /sigma				/*
		*/ [`weight'`exp'] if `doit',		/*
		*/ `initopt'				/*
		*/ `mlopts'				/*
		*/ `robust'				/*
		*/ `clopt'				/*
		*/ `scopt'				/*
		*/ `contin'				/*
		*/ `log'				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ obs(`N')				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/
	}

	ereturn local ml_score
	ereturn scalar N_unc = `Nunc'
	ereturn scalar N_lc  = `Nlc'
	ereturn scalar N_rc  = `Nrc'
	ereturn scalar N_int = e(N) - e(N_unc) - e(N_lc) - e(N_rc)
	ereturn scalar sigma = [sigma]_cons
	ereturn scalar se_sigma = [sigma]_se[_cons]
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
	ereturn local predict "tobit_p"

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
		label var `s1' "intreg score for x*b"
		label var `s2' "intreg score for /sigma"
		local name : word 1 of `score'
		rename `s1' `name'
		local name : word 2 of `score'
		rename `s2' `name'
		ereturn local scorevars `score'
	}

	ereturn local cmd "intreg"
	global S_E_cmd `e(cmd)'

/* Display results. */

	if "`display'" == "" {
		DiIntreg, level(`level')
		error `e(rc)'
	}
end

program define DiIntreg
	syntax [, Level(cilevel) ]
	ml display, level(`level') first plus
	_diparm sigma, level(`level') noprob   
	di in smcl as txt "{hline 13}{c BT}{hline 64}" _n

/* Note:  Wald test for sigma on boundary -- not reported.*/

	censobs_table e(N_unc) e(N_lc) e(N_rc) e(N_int)
	if e(N_lcout)>=. & e(N_rcout)>=. {
		exit
	}

/* The following messages should be VERY rare. */

	if e(N_lcout) == 1 {
		di _n as txt "note: 1 interval observation was an " /*
		*/ "extreme outlier (large negative residual)" _n /*
		*/ "      and was handled by assuming it was a " /*
		*/ "left-censored observation."
	}
	else if e(N_lcout) <. {
		di _n as txt "note: `e(N_lcout)' interval observations " /*
		*/ "were extreme outliers (all with large negative" _n /*
		*/ "      residuals) and were handled by " /*
		*/ "assuming they were left-censored observations."
	}
	if e(N_rcout) == 1 {
		di _n as txt "note: 1 interval observation was an " /*
		*/ "extreme outlier (large positive residual)" _n /*
		*/ "      and was handled by assuming it was a " /*
		*/ "right-censored observation."
	}
	else if e(N_rcout) <. {
		di _n as txt "note: `e(N_rcout)' interval observations " /*
		*/ "were extreme outliers (all with large positive" _n /*
		*/ "      residuals) and were handled by " /*
		*/ "assuming they were right-censored observations."
	}
	di as txt /*
	*/ "      This is an excellent approximation for all intervals " /*
	*/ "except for those" _n "      that are very narrow."
end


program define UnTrans, eclass
	args mean s1 s2

	tempname b V s J
	matrix `b' = e(b)
	matrix `V' = e(V)
	local dim = colsof(matrix(`b'))
	scalar `s' = `b'[1,`dim'] /* 1/sigma */

/* Untransform scores. */

	if "`s1'"!="" {
		quietly {
			tempvar xb
			_predict double `xb'
			replace `s2' = -`s'*(`xb'*`s1'+`s'*`s2')
			replace `s1' = `s'*`s1'
		}
	}

/* Compute Jacobian. */

	matrix `J' = (diag(J(1,`dim'-1,`s')),J(`dim'-1,1,0) /*
	*/ \ -`s'*`b'[1,1..`dim'-1],-`s'^2)

/* Untransform variance `V'. */

	mat `V' = `J'*syminv(`V')*`J''
	mat `V' = syminv(0.5*(`V' + `V''))

/* Untransform coefficient vector. */

	matrix `b' = (1/`s')*`b'
	matrix `b'[1,`dim'] = 1/`s'
	matrix `b'[1,`dim'-1] = `b'[1,`dim'-1] + `mean'

/* Repost. */

	ereturn repost b=`b' V=`V'

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
