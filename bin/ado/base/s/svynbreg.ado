*! version 1.0.15  13feb2015
program define svynbreg, sortpreserve
	version 8

	if replay() {
		if "`e(cmd)'" != "svynbreg" {
			error 301
		}
		syntax [, IRr * ]
		svyopts invalid diopts, `options'
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
	*/	IRr				/*
	*/	FROM(string)			/*
	*/	OFFset(varname numeric)		/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	noDISPLAY			/*
	*/	Dispersion(string)		/*
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	*				/* svy/ml/display options
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	mlopts mlopts rest, `options'

	svyopts svymlopts diopts , `rest'
	local diopts `diopts' `irr'
	local subcond `s(subpop)'

/* dispersion settings */

	Dispers , `dispersion'
	local dispersion `s(dispers)'
	if "`dispersion'"=="mean" {
		local prog   "nbreg_lf"
		local parm   "alpha"
		local title  "Survey negative binomial regression"
	}
	else {
		local prog   "nbreg_al"
		local parm   "delta"
		local title  /*
		*/ "Survey negative binomial regression (constant dispersion)"
	}

/* Check estimation syntax. */

	if `"`log'"' == "" {
		local log nolog
		local quietly quietly
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
			di as err "score() must contain the name of " /*
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

	quietly svyset
	local weight `r(wtype)'
	local exp "`r(wexp)'"

	if "`weight'"!="" {
		local wt `"[aw`exp']"'
	}

	summarize `y' `wt' if `touse', meanonly

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

	_rmcoll `xvars' [`weight'`exp'] if `touse', `constant'
	local xvars `r(varlist)'

/* Get initial values. */

	if `"`from'"'=="" {
		qui svypoisson `y' `xvars' if `touse', /*
		*/ `offopt' `constant' iter(1)

		tempname bp
		mat `bp' = e(b)
		if "`offset'" != "" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ mean(`mean')
			local c = r(_cons)
		}
		else	local c = ln(`mean')

		tempname b0
		if `c' < . {
			mat `b0' = (`c', 0)
		}
		else	mat `b0' = (0, 0)

		mat colnames `b0' = `y':_cons ln`parm':_cons

		local dim = colsof(`bp')
		if `dim' > 1 {

			/* Adjust so that mean(x*b) = c0 from constant-only. */
			
			tempvar xb
			qui mat score `xb' = `bp' if `touse'
			if "`weight'"!="" {
				local wt `"[aw`exp']"'
			}

			summarize `xb' `wt' if `touse', meanonly

			if "`offset'"!="" {
				qui replace `xb' = `xb' + `b0'[1,1] /*
				*/ - r(mean) + `offset'
			}
			else {
				qui replace `xb' = `xb' + `b0'[1,1] /*
				*/ - r(mean)
			}

			mat `bp'[1,`dim'] = `bp'[1,`dim'] + `b0'[1,1] /*
			*/ - r(mean)

			mat `bp' = (`bp', `b0'[1,2..2])
		}
		else	mat `bp' = (`bp',`b0'[1,2..2])
		local initopt "init(`bp')"
	}
	else    local initopt `"init(`from')"'

/* Fit miss-specified model. */

	local 0 , `diopts' `svymlopts'
	syntax [, MEFF MEFT * ]
	if "`meff'`meft'" != "" {
		`quietly' di _n as txt "Computing misspecified "	///
			as res "nbreg"					///
			as txt " model for meff/meft computation:"
		if "`subcond'" != "" {
			local mysubtouse (`touse' & `subcond' != 0)
		}
		else    local mysubtouse `touse'
		eret clear
		`quietly' nbreg `y' `xvars' if `mysubtouse', /*
		*/ `constant' `mlopts' `offopt' disp(`dispersion')
		tempname Vmeff
		mat `Vmeff' = e(V)
	}

/* Fit full model. */

	ml model d2 `prog'				/*
	*/	(`y': `y'=`xvars', `constant' `offopt') /*
	*/ 	/ln`parm'				/*
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
	*/	title(`title')				/*
	*/	crittype("log pseudolikelihood")	/*
	*/

        if "`score'"!="" {
		label var `scvar1' "Score index for x*b from svynbreg"
		rename `scvar1' `scname1'
		label var `scvar2' "Score index for /ln`parm' from svynbreg"
		rename `scvar2' `scname2'
		eret local scorevars `scname1' `scname2'
	}
	else	eret local scorevars

	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "poisso_p"
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret scalar `parm' = exp(_b[/ln`parm'])
	eret local dispers "`dispersion'"
	eret scalar k_aux    = 1 /* # of ancillary parameters */
        eret local cmd     "svynbreg"

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

program SolveC, rclass /* modified from poisson.ado */
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Mean(string)
	if "`weight'"=="pweight" | "`weight'"=="iweight" {
		local weight "aweight"
	}
	summarize `xb' `if', meanonly
	if r(max) - r(min) > 2*709 { /* unavoidable exp() over/underflow */
		exit /* r(_cons) >= . */
	}
	if r(max) > 709 | r(min) < -709  {
		tempname shift
		if r(max) > 709 {
			scalar `shift' =  709 - r(max)
		}
		else		  scalar `shift' = -709 - r(min)
		local shift "+`shift'"
	}
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program Dispers, sclass
	sret clear
	syntax [, Mean Constant ]
	if "`constant'"==""  {
		sret local dispers "mean"
		exit
	}
	if "`mean'"!="" {
		di as err "must choose either mean or constant for dispersion()"
		exit 198
	}
	sret local dispers "constant"
end

program define Display
	syntax [, Level(cilevel) * ]
	local opts svy level(`level') dof(`e(df_r)')

	if `"`e(alpha)'"' != "" {
		local parm alpha
	}
	else	local parm delta
	ml display , level(`level') `options'			/*
	*/ diparm(ln`parm', `opts' exp label("`parm'"))		/*
	*/
end

exit

