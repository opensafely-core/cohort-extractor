*! version 3.0.9  20dec2004
program define svypoisson, sortpreserve
	version 8, missing
	if _caller() < 8 {
		svypois_7 `0'
		exit
	}
	if replay() {
		if "`e(cmd)'" != "svypoisson" {
			error 301
		}
		syntax [, IRr * ]
		svyopts invalid diopts , `options'
		local diopts `diopts' `irr'
		if "`invalid'" != "" {
			di as err "`invalid' : invalid options for replay"
			exit 198
		}
		Display, `diopts'
		exit
	}
	else	Estimate `0'
end

program define Estimate, eclass

/* Parse */
	syntax	varlist(numeric)		/*
	*/	[pw iw]				/* see _svy_newrule.ado
	*/	[if] [in]			/*
	*/	[,				/*
	*/	noCONStant			/* my options
	*/	LOg				/*
	*/	Exposure(varname numeric)	/*
	*/	IRr				/*
	*/	First				/* ignored
	*/	FROM(string)			/*
	*/	OFFset(varname numeric)		/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	* 				/* svy/ml/display options
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	mlopts mlopts rest, `options' `eform'

	svyopts svymlopts diopts , `rest'
	local diopts `diopts' `irr'
	local subcond `s(subpop)'
 
/* Check estimation syntax. */

	if `"`log'"' == "" {
		local log nolog
		local quietly quietly
	}

 	if `"`score'"'!="" {
		confirm new variable `score'
		local nword : word count `score'
		if `nword' > 1 {
			di as err "score() must contain the name of only " /*
			*/ "one new variable"
			exit 198
		}
		tempvar scvar
		local scopt score(`scvar')
	}
	if "`offset'"!="" & "`exposure'"!="" {
		di as err "only one of offset() or exposure() can be specified"
		exit 198
	}
	if "`constant'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			di as err "independent variables required with " /*
			*/ "noconstant option"
			exit 102
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse, zeroweight

/* Process offset/exposure. */

	if "`exposure'"!="" {
		capture assert `exposure' > 0 if `touse'
		if _rc {
			di as err "exposure() must be greater than zero"
			exit 459
		}
		tempvar offset
		qui gen double `offset' = ln(`exposure')
		local offvar "ln(`exposure')"
	}

	if "`offset'"!="" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
		if "`offvar'"=="" {
			local offvar "`offset'"
		}
	}

/* Count obs and check for negative values of `y'. */

	gettoken y xvars : varlist

	summarize `y' if `touse', meanonly

	if r(N) == 0 {
		error 2000
	}
	if r(N) == 1 {
		error 2001
	}

	if r(min) < 0 {
		di as err "`y' must be greater than or equal to zero"
		exit 459
	}
	if r(min) == r(max) & r(min) == 0 {
		di as err "`y' is zero for all observations"
		exit 498
	}

	tempname mean nobs
	scalar `mean' = r(mean)
	scalar `nobs' = r(N) /* #obs for checking #missings in calculations */

/* Check whether `y' is integer-valued. */

	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc {
			di as txt "note: you are responsible for " /*
			*/ "interpretation of non-count dep. variable"
		}
	}

/* Remove collinearity. */

	quietly svyset
	local wtype `r(wtype)'
	local wexp "`r(wexp)'"
	_rmcoll `xvars' [`wtype'`wexp'] if `touse', `constant'
	local xvars `r(varlist)'

/* Get initial values. */

	if "`from'"=="" {
		Ipois `y' `xvars' [`wtype'`wexp'] if `touse', /*
		*/ n(`nobs') mean(`mean') `constant' `offopt'

		if "`r(b0)'"!="" {
			tempname from
			mat `from' = r(b0)
		}
	}
	if "`from'"!="" {
		local initopt `"init(`from') search(off)"'
	}
	else	local initopt "search(on) maxfeas(50)"

/* Fit miss-specified model. */

	local 0 , `diopts' `svymlopts'
	syntax [, MEFF MEFT * ]
	if "`meff'`meft'" != "" {
		`quietly' di _n as txt "Computing misspecified "	///
			as res "poisson"				///
			as txt " model for meff/meft computation:"
		if "`subcond'" != "" {
			local mysubtouse (`touse' & `subcond' != 0)
		}
		else    local mysubtouse `touse'
		eret clear
		`quietly' poisson `y' `xvars' if `mysubtouse', /*
		*/ `constant' `mlopts' `offopt'
		tempname Vmeff
		mat `Vmeff' = e(V)
	}

/* Fit full model. */

	ml model d2 poiss_lf				/*
	*/ (`y': `y' = `xvars', `constant' `offopt')	/*
	*/ if `touse',					/*
	*/ collinear					/*
	*/ missing					/*
	*/ max						/*
	*/ nooutput					/*
	*/ nopreserve					/*
	*/ `mlopts'					/*
	*/ svy						/*
	*/ `svymlopts'					/*
	*/ `scopt'					/*
	*/ `log'					/*
	*/ `initopt'					/*
	*/ title("Survey Poisson regression")		/*
	*/ crittype("log pseudolikelihood")		/*
	*/

	if "`score'" != "" {
		label var `scvar' "Score index from poisson"
		rename `scvar' `score'
		eret local scorevars `score'
	}
	else	eret local scorevars

	eret local k_eq
	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "poisso_p"
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret local cmd     "svypoisson"

/* Double save. */

	global S_E_nobs = e(N)
	global S_E_nstr = e(N_strata)
	global S_E_npsu = e(N_psu)
	global S_E_npop = e(N_pop)
	global S_E_wgt   `e(wtype)'
	global S_E_exp  "`e(wexp)'"
	global S_E_str   `e(strata)'
	global S_E_psu   `e(psu)'
	global S_E_depv  `e(depvar)'
	global S_E_f    = e(F)
	global S_E_mdf  = e(df_m)
	global S_E_cmd   `e(cmd)'

	Display, `diopts'
end

program LikePois, rclass
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string)
	if "`wtype'"!="" {
		if "`wtype'"=="fweight" {
			local wt `"[fw`wexp']"'
		}
		else	local wt `"[aw`wexp']"'
	}
	tempvar lnf
	qui gen double `lnf' = `y'*(`xb')-exp(`xb')-lngamma(`y'+1) `if'
	summarize `lnf' `wt' `if', meanonly
	if r(N) != `nobs' {
		exit
	}
	if "`wtype'"=="aweight" {
		ret scalar lnf = r(N)*r(mean)
				/* weights not normalized in r(sum) */
	}
	else	ret scalar lnf = r(sum)
end

program SolveC, rclass /* note: similar code is found in nbreg.ado */
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) Mean(string)
	if "`weight'"=="pweight" | "`weight'"=="iweight" {
		local weight "aweight"
	}
	capture confirm variable `xb'
	if _rc {
		tempvar xbnew
		qui gen double `xbnew' = (`xb') `if'
		local xb `xbnew'
	}
	summarize `xb' [`weight'`exp'] `if', meanonly
	if r(N) != `nobs' {
		exit
	}
	if r(max) - r(min) > 2*709 { /* unavoidable exp() over/underflow */
		exit /* r(_cons) is missing */
	}
	if r(max) > 709 | r(min) < -709  {
		tempname shift
		if r(max) > 709 {
			scalar `shift' =  709 - r(max)
		}
		else	scalar `shift' = -709 - r(min)
		local shift "+`shift'"
	}
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly
	if r(N) != `nobs' { /* should not happen */
		exit
	}
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program Ipois, rclass
	syntax varlist [fw aw pw iw/] [if] , Nobs(string) Mean(string) /*
	*/ [ noCONstant OFFset(string) ]
	gettoken y xvars : varlist

	tempvar xb z
	tempname b1 b2 lnf1

	if "`weight'"!="" {
		local awt `"[aw=`exp']"'
		local wt  `"(`exp')*"'
		local exp `"=`exp'"'
	}

	quietly {

	/* Initial values: b1 = b/mean, where b are coefficients
	   from reg `y' `xvars' and mean is mean of `y'.
	*/
		if "`offset'"!="" {
			tempvar ynew
			gen double `ynew' = `y' - `offset'*`mean' `if'
			local poff "+`offset'"
		}
		else	local ynew `y'

		reg `ynew' `xvars' `awt' `if', `constant'
		mat `b1' = (1/`mean')*e(b)
		mat score double `xb' = `b1' `if'

		LikePois `y' `xb'`poff' [`weight'`exp'] `if', n(`nobs')
		scalar `lnf1' = r(lnf)
	}

	/* Solve for _cons (change) for poisson likelihood given b1. */

	if "`constant'"=="" {
		SolveC `y' `xb'`poff' [`weight'`exp'] `if', /*
		*/ n(`nobs') mean(`mean')
		tempname c
		scalar `c' = r(_cons)
		if `c'<. {
			local c "+`c'"
		}
		else	local c /* erase macro */

		LikePois `y' `xb'`poff'`c' [`weight'`exp'] `if', n(`nobs')
		tempname lnf1c
		scalar `lnf1c' = r(lnf)
	}
	else	local lnf1c .

	/* Take iteratively reweighted least-squares step to get b2. */

	capture {
		gen double `z' = `y'*exp(-(`xb'`poff'`c'))-1 /*
		*/ +`xb'`c' `if'

		reg `z' `xvars' [aw=`wt'exp(`xb'`poff'`c')] `if', /*
		*/ `constant'
		mat `b2' = e(b)
		drop `xb'
		_predict double `xb' `if'

		LikePois `y' `xb'`poff' [`weight'`exp'] `if', n(`nobs')
		tempname lnf2
		scalar `lnf2' = r(lnf)
	}
	if _rc {
		local lnf2 .
	}

	if `lnf1'>=. & `lnf1c'>=. & `lnf2'>=. {
		exit
	}

	if `lnf2'<.&(`lnf2'>`lnf1'|`lnf1'>=.)&(`lnf2'>`lnf1c'|`lnf1c'>=.) {
		ret matrix b0 `b2' /* `lnf2' best */
		exit
	}
	if `lnf1'<.&(`lnf1'>`lnf1c'|`lnf1c'>=.)&(`lnf1'>`lnf2'|`lnf2'>=.) {
		ret matrix b0 `b1' /* `lnf1' best */
		exit
	}

	local dim = colsof(`b1')
	mat `b1'[1,`dim'] = `b1'[1,`dim']`c'
	ret matrix b0 `b1' /* `lnf1c' best */
end

program define Display
	syntax [, Level(cilevel) * ]
	ml display , level(`level') `options'
end

exit

