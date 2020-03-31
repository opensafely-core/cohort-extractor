*! version 3.0.13  13feb2015
program define svyintreg, sortpreserve
	version 8, missing
	if _caller() < 8 {
		svyintreg_7 `0'
		exit
	}
	if replay() {
		if `"`e(cmd)'"'!="svyintreg" {
			error 301
		}
		svyopts invalid diopts `0'
		if `"`invalid'"' != "" {
			di as err "`invalid' : invalid options for replay"
			exit 198
		}
		Display, `diopts'
		exit
	}
	else	Estimate `0'
end

program define Estimate, eclass

/* Parse and check options. */

	syntax	varlist(min=2 numeric)		/*
	*/	[pw iw]				/* see _svy_newrule.ado
	*/	[if] [in]			/*
	*/	[,				/*
	*/	noCONStant			/* my options
	*/	CONSTraints(string)		/*
	*/	ITERate(int -1)			/*
	*/	LOg				/*
	*/	OFFset(varname numeric)		/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	* 				/* svy/ml/display options
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	mlopts mlopts rest, `options' const(`constraints')

	svyopts svymlopts diopts , `rest'
	local subcond `s(subpop)'
 
	gettoken y1 rhs : varlist
	gettoken y2 rhs : rhs

	if `"`log'"' == "" {
		local log nolog
		local qui qui
	}

	if "`constant'"!="" & "`rhs'"=="" {
		di in red /*
		*/ "independent variables required with noconstant option"
		exit 100
	}
	if `"`score'"'!="" {
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" {
			local nam = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score
			local i 1
			while `i' <= 2 {
				local score `score' `nam'`i'
				local i = `i' + 1
			}
			local nam
		}
		confirm new variable `score'
		local nword : word count `score'
		if `nword' != 2 {
			di in red "score() must contain the names of " /*
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

	/* from -mlopts- */
	if `iterate' != -1 {
		local iterate "iterate(`iterate')"
	}
	else	local iterate


/* Mark/markout. */

	tempvar doit z

	qui svyset
	if `"`s(wexp)'"' != "" {
		local wt aw
		local wtype `r(wtype)'
		local wexp "`r(wexp)'"
	}
	local strata strata(`r(strata)')
	local psu psu(`r(psu)')
	local fpc fpc(`r(fpc)')

	mark `doit' [`wt'`wexp'] `if' `in', zeroweight
	qui replace `doit' = 0 if `y1'>=. & `y2'>=.
	markout `doit' `r(strata)' `r(psu)' `r(fpc)'

/* Check that `y1'<=`y2' and markout independent variables. */

	capture assert `y1'<=`y2' if `y1'<. & `y2'<. & `doit'
	if _rc {
		di in red `"observations with `y1' > `y2' not allowed"'
		exit 498
	}
	markout `doit' `rhs' `offset' `het'

/* Remove collinearity. */

	if "`y1'" == "`y2'" {
		qui _rmdcoll `y1' `rhs' [`wt' `wexp'] if `doit', `constant'
		local rhs `r(varlist)'
	}
	else {
		cap _rmdcoll `y1' `rhs' [`wt' `wexp'] if `doit', `constant'
		if _rc != 0 {
		cap _rmdcoll `y2' `rhs' [`wt' `wexp'] if `doit', `constant'
		}
		if _rc != 0 {
			dis in red /*
		*/ "`y1' and `y2' collinear with independent variables"
			exit 459
		}		
		local rhs `r(varlist)'
	}

	local 0 , `diopts' `svymlopts'
	syntax [, MEFF MEFT  * ]
	if "`subcond'" != "" {
		local mysubdoit (`doit' & `subcond' != 0)
	}
	else    local mysubdoit `doit'

/* Count number of observations (and issue error 2000 if necessary). */

	_nobs `doit' [`wt'`wexp'] if `mysubdoit'
	local N `r(N)'
	_nobs `doit' [`wt'`wexp'] if `mysubdoit' & `y1'==`y2', min(0)
	local Nunc `r(N)'
	_nobs `doit' [`wt'`wexp'] if `mysubdoit' & `y1'>=., min(0)
	local Nlc `r(N)'
	_nobs `doit' [`wt'`wexp'] if `mysubdoit' & `y2'>=., min(0)
	local Nrc `r(N)'

/* Generate variable `z' to get starting values. */

	if "`constraints'" == "" & "`offset'"!="" {
		local moff "-`offset'"
	}

	qui gen double `z' = cond(`y1'<.&`y2'<.,(`y1'+`y2')/2, /*
	*/		 cond(`y1'<.,`y1',`y2')) `moff' if `doit'

	qui summarize `z' [`wt'`wexp'] if `doit'

/* Branch off for constrained models */

	if "`constraints'" == "" {

/* Remove approximate mean from dependent variables if constant.  Handle
offset by removing it from dependent variables.  Since maximization is in
beta/sigma metric, -ml- cannot handle offset.  */

		if "`constant'"=="" | "`offset'"!="" {
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

		tempname bs b0
		qui reg `z' `rhs' [`wt'`wexp'] if `doit', `constant'
		matrix `bs' = (1/e(rmse))
		matrix colnames `bs' = sigma:_cons
		matrix `b0' = `bs'*e(b)
		matrix coleq `b0' = model
		matrix `b0' = `b0' , `bs'
		local initopt init(`b0')

/* Fit full model. */

		if "`log'"=="" {
			di _n as txt "Fitting full model:"
		}

		ml model d2 intrg_ll			/*
		*/ (model: `z1' `z2'=`rhs', `constant') /*
		*/ /sigma				/*
		*/ if `doit',				/*
		*/ `initopt'				/*
		*/ `mlopts'				/*
		*/ svy					/*
		*/ `svymlopts'				/*
		*/ `log'				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/ `iterate'				/*
		*/ title("Survey interval regression")	/*
		*/ crittype("log pseudolikelihood")	/*
		*/ 

		eret local cmd
		global S_E_cmd

/* MLE was done in (beta/sigma, 1/sigma) metric.  Transform back to (beta,
sigma).  */

		tempname b s ms
		mat `b' = e(b)
		local dim = colsof(matrix(`b'))
		scalar `s' = `b'[1,`dim'] /* 1/sigma */
		matrix `b' = (1/`s')*`b'
		matrix `b'[1,`dim'] = 1/`s'
		matrix `ms' = log(`b'[1,`dim'])		
		matrix colname `ms' = lnsigma:_cons
		matrix `b'[1,`dim'-1] = `b'[1,`dim'-1] + `mean'
		local dim = `dim' - 1
		matrix `b' = (`b'[1,1..`dim'], `ms')

		eret clear
		ml model d2 intrg_ll2			/*
		*/ (model: `y1' `y2' = `rhs', `constant' `offopt')	/*
		*/ /lnsigma				/*
		*/ if `doit',				/*
		*/ init(`b')				/*
		*/ `mlopts'				/*
		*/ `scopt'				/*
		*/ svy					/*
		*/ `svymlopts'				/*
		*/ nolog				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/ iterate(0)				/*
		*/ nowarning				/*
		*/ title("Survey interval regression")	/*
		*/ crittype("log pseudolikelihood")	/*
		*/
	}
	else {

/* get starting values for constrained model */

		if "`rhs'" != "" {
			tempname bs b0

			qui reg `z' `rhs' [`wtype'`wexp'] if `doit', `constant'
			matrix `bs' = log(e(rmse))
			matrix colnames `bs' = lnsigma:_cons
			matrix `b0' = e(b)
			matrix coleq `b0' = model
			local initopt init(`b0')
			mat `b0' = `bs' , `b0'
			local initopt init(`b0')
		}

/* Fit constrained model. */

		ml model d2 intrg_ll2			/*
		*/ (model: `y1' `y2' = `rhs', `constant' `offopt')	/*
		*/ /lnsigma				/*
		*/ if `doit',				/*
		*/ `initopt'				/*
		*/ `mlopts'				/*
		*/ `scopt'				/*
		*/ `log'				/*
		*/ svy					/*
		*/ `svymlopts'				/*
		*/ noout				/*
		*/ missing				/*
		*/ collinear				/*
		*/ nopreserve				/*
		*/ maximize				/*
		*/ search(off)				/*
		*/ `iterate'				/*
		*/ title("Survey interval regression")	/*
		*/ crittype("log pseudolikelihood")	/*
		*/
	}

/* Fit miss-specified model. */

	if "`meff'`meft'" != "" {
		`qui' di _n as txt "Computing misspecified "	///
			as res "intreg"				///
			as txt " model for meff/meft computation:"
		tempname svymodel
		_est hold `svymodel', restore
		eret clear
		`qui' intreg `y1' `y2' `rhs' if `mysubdoit', /*
		*/ `constant' `mlopts' offset(`offvar')
		tempname Vmeff
		mat `Vmeff' = e(V)
		_est unhold `svymodel'
	}

	eret scalar N_pop    = e(N_pop)
	if "`e(N_sub)'" != "" {
		eret scalar N_sub    = e(N_sub)
		eret scalar N_subpop = e(N_subpop)
	}
	eret scalar N        = e(N)
	eret scalar N_strata = e(N_strata)
	eret scalar N_psu    = e(N_psu)
	eret scalar df_r     = e(df_r)
	eret scalar df_m     = e(df_m)
	eret scalar F        = e(F)
	eret scalar sigma    = exp([lnsigma]_cons)
	eret scalar se_sigma = e(sigma)*[lnsigma]_se[_cons]
	eret scalar k_aux    = 1 /* # of ancillary parameters */
	eret scalar k_eq     = 2 /* # of equations */
	eret scalar N_unc    = `Nunc'
	eret scalar N_lc     = `Nlc'
	eret scalar N_rc     = `Nrc'
	eret scalar N_int    = e(N) - e(N_unc) - e(N_lc) - e(N_rc)
	if "$S_BADLC"!="" {
		eret scalar N_lcout = $S_BADLC
			/* # outlier intervals approximated as LC */
		global S_BADLC
	}
	if "$S_BADRC"!="" {
		eret scalar N_rcout = $S_BADRC
			/* # outlier intervals approximated as RC */
		global S_BADRC
	}
	eret local offset `offset'
	eret local predict "intreg_p"

	if `"`score'"'!=`""' {
		label var `s1' "svyintreg score for x*b"
		label var `s2' "svyintreg score for /lnsigma"
		local name : word 1 of `score'
		rename `s1' `name'
		local name : word 2 of `score'
		rename `s2' `name'
		eret local scorevars `score'
	}
	else	eret local scorevars
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret local cmd "svyintreg"

/* Double save in S_E_. */

	global S_E_nobs `e(N)'
	global S_E_depv `e(depvar)'
	global S_E_sig  `e(sigma)'
	global S_E_sesg `e(se_sigma)'

	global S_E_cmd `e(cmd)'

/* Display results. */

	Display, `diopts'
end

program define Footnote
	di _n in gr "Obs. summary: " /*
	*/ _col(16) in ye %9.0g e(N_unc) /*
	*/ in gr " uncensored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_lc) /*
	*/ in gr " left-censored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_rc) /*
	*/ in gr " right-censored observations" _n /*
	*/ _col(16) in ye %9.0g e(N_int) /*
	*/ in gr " interval observations" _n
end

program define Display
	syntax [, Level(cilevel) * ]
	ml display , level(`level') `options'
	Footnote
end

exit

