*! version 1.0.11  29jan2015
program svygnbreg, sortpreserve
	version 8

	if replay() {
		if "`e(cmd)'" != "svygnbreg" {
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

/* Parse. */
	syntax varlist(numeric)			/*
	*/	[pw iw]				/* see _svy_newrule.ado
	*/	[if] [in]			/*
	*/	[,				/*
	*/	noCONstant			/* my options
	*/	LOg				/*
	*/	Exposure(varname numeric)	/*
	*/	LNAlpha(varlist numeric)	/*
	*/	IRr				/*
	*/	FROM(string)			/*
	*/	OFFset(varname numeric)		/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	noDISPLAY			/*
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	*				/* svy/ml/display options
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
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" {
			local score = /*
			*/ substr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2
			local n
		}
		confirm new variable `score'
		local nword : word count `score'
		if `nword' != 2 {
			di as err "score() must contain the names of " /*
			*/ "two new variables"
			exit 198
		}
		local scname1 : word 1 of `score'
		local scname2 : word 2 of `score'
		tempvar scvar1 scvar2
		local scopt "score(`scvar1' `scvar2')"
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
	markout `touse' `lnalpha'

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

	tempname mean
	scalar `mean' = r(mean)

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

	if `"`from'"'=="" {
		qui svypoisson `y' `xvars' if `touse', /*
		*/ `offopt' `constant' iter(1)

		tempname bp
		mat `bp' = e(b)
		tempname b0
		mat `b0' = (0)
		mat colnames `b0' = lnalpha:_cons
		mat `bp' = (`bp',`b0')
		local initopt "init(`bp')"
	}
	else    local initopt `"init(`from')"'

/* Fit miss-specified model. */

	local 0 , `diopts' `svymlopts'
	syntax [, MEFF MEFT * ]
	if "`meff'`meft'" != "" {
		`quietly' di _n as txt "Computing misspecified "	///
			as res "gnbreg"					///
			as txt " model for meff/meft computation:"
		if "`subcond'" != "" {
			local mysubtouse (`touse' & `subcond' != 0)
		}
		else    local mysubtouse `touse'
		eret clear
		`quietly' gnbreg `y' `xvars' if `mysubtouse', /*
		*/ `constant' `mlopts' `offopt' lnalpha(`lnalpha')
		tempname Vmeff
		mat `Vmeff' = e(V)
	}

/* Fit full model. */

	ml model lf gnbre_lf				/*
	*/	(`y': `y'=`xvars', `constant' `offopt') /*
	*/ 	(lnalpha: `lnalpha')			/*
	*/	if `touse',				/*
	*/	collinear				/*
	*/	missing					/*
	*/	max					/*
	*/	nooutput				/*
	*/	nopreserve				/*
	*/	`mlopts'				/*
	*/	svy					/*
	*/	`svymlopts'				/*
	*/	`scopt'					/*
	*/	`log'					/*
	*/	`initopt'				/*
	*/	search(off)				/*
	*/	title(Survey generalized negative binomial regression)	/*
	*/	crittype("log pseudolikelihood")	/*
	*/

	if "`score'"!="" {
		label var `scvar1' "Score index for x*b from nbreg"
		rename `scvar1' `scname1'
		label var `scvar2' "Score index for lnalpha from gnbreg"
		rename `scvar2' `scname2'
		eret local scorevars `scname1' `scname2'
	}
	else	eret local scorevars

	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "gnbreg_p"
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret local cmd     "svygnbreg"

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

program define Display
	syntax [, Level(cilevel) * ]

	ml display , level(`level') `options'
end

exit

