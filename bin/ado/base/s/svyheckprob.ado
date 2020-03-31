*! version 1.0.14  13feb2015
program define svyheckprob, sortpreserve
	version 8

	if replay() {
		if "`e(cmd)'" != "svyheckprob" {
			error 301
		}
		svyopts invalid diopts `0'
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

/* Allow = after depvar */
	gettoken depvar 0 : 0 , parse(" =,[")
	unab depvar : `depvar'
	confirm variable `depvar'
	gettoken equals rest : 0 , parse(" =")
	if "`equals'" == "=" {
		local 0 `"`rest'"'
	}

/* Parse. */	
	syntax [varlist(numeric default=none)]	/*
	*/	[pw iw]				/* see _svy_newrule.ado
	*/	[if] [in]			/*
	*/	,				/*
	*/	SELect(string)			/* required
	*/	[				/*
	*/	noCONstant			/* my options
	*/	FROM(string)			/*
	*/	OFFset(varname numeric)		/*
	*/	LOg				/*
	*/	SCore(string)			/*
	*/	svy				/* ignored
	*/	STRata(passthru)		/* see _svy_newrule.ado
	*/	PSU(passthru)			/* see _svy_newrule.ado
	*/	FPC(passthru)			/* see _svy_newrule.ado
	*/	*				/* svy/ml/display options
	*/ ]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	mlopts mlopts rest, `options'

	svyopts svymlopts diopts , `rest'
 
	SelectEq seldep selind selnc seloff : `"`select'"'

	if "`seloff'"  != "" {
		local soffopt "offset(`seloff')"
	}

	if `"`log'"' == "" {
		local log nolog
		local qui quietly
	}


/* Check syntax errors */

	if "`constant'" != "" & "`varlist'" == "" {
		noi di as err "must specify independent variables or "	/*
			*/ "allow constant for primary equation"
		exit 102
	}

/* Process scores */
	if `"`score'"' != "" {
		local ct : word count `score'	/* stub -- score(stub*) */
		if `ct' == 1 & bsubstr("`score'",-1,1) == "*" {
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 
			local ct : word count `score'
		}
		if `ct' != 3 {
			di as err /*
*/ "score() requires you specify three new variable names"
			exit 198
		}
		confirm new variable `score'
		local scopt "score(`score')" 
	}


	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

/* Find estimation sample */

	qui svyset
	local wtype `r(wtype)'
	local wtexp "`r(wexp)'"
	if "`wtype'" != "" {
		local wgt `"[`wtype'`wtexp']"'
	}

/* Set observed/selected variable. */

	if "`seldep'" == "" {
		tempname seldep
		gen byte `seldep' = `depvar' != .
		local selname "select"
	}
	else	local selname `seldep'

	marksample touse, novarlist zeroweight
	markout `touse' `seldep' `selind' `seloff' `cluster', strok
	marksample touse2
	markout `touse2' `depvar' `varlist' `offset'
	qui replace `touse' = 0 if `seldep' & !`touse2'


/* Remove collinearity */

	_rmcoll `selind' `wgt' if `touse', `selnc'
	local selind "`r(varlist)'"
	_rmcoll `varlist' `wgt' if `touse' & `seldep', `constant'
	local varlist "`r(varlist)'"

/* Only way to check for perfect pred */

	capture probit `seldep' `selind' `wgt' if `touse', `selnc' `soffopt' 
	if _rc == 2000 {
	    di as txt "selection equation:" _c
	    probit `seldep' `selind' `wgt' if `touse', `selnc' `soffopt' 
	}
	else if _rc {
		error _rc 
	}

/* Check selection condition */

	qui sum `seldep' if `touse'
	if `r(N)' == `r(sum)' {
		di as err "Dependent variable never censored due to selection: "
		di as err "model simplifies to probit regression"
		exit 498
	}


/* Get starting values, etc. */

	tempname llc b0 b0sel b00
	tempvar  nshaz 

					/* just for part of comparison LL */
					/* and to check for perfect pred */
	`qui' di as txt _n "Fitting probit model:"
	`qui' probit `depvar' `varlist' `wgt' if `touse' & `seldep', /*
		*/ `constant' `offopt' nocoef robust
	scalar `llc' = e(ll)

	if "`robust'"=="" | "`from'"=="" | ("`skip'"!="" & "`from0'"=="") {
		`qui' di as txt _n "Fitting selection model:"
		`qui' probit `seldep' `selind' `wgt' if `touse',  /*
			*/ `selnc' `soffopt' `show1st' asis robust
		mat `b0sel' = e(b)
		if "`robust'" == "" {
			scalar `llc' = `llc' + e(ll)
		}

		qui predict double `nshaz', xb
		qui replace `nshaz' = normd(`nshaz') / normprob(`nshaz')
	}

	if "`constant'" == "" {
		tempname one
		gen byte `one' = 1 
	}

	if "`from'" == "" {
		`qui' di as txt _n "Fitting starting values:"
		`qui' probit `depvar' `varlist' `one' `nshaz' `wgt'	/*
			*/ if `touse' & `seldep', 			/*
			*/ noconstant `offopt' nocoef asis robust
		MkB0 `b0' : `b0sel' `nshaz'
		local from "`b0', copy"
	}

	qui regress `seldep' `wgt' if !`seldep' & `touse'
	local N_cens = e(N)

/* Fit miss-specified model. */

	`qui' FitMiss `depvar' `varlist' if `touse',	/*
	*/ sel(`seldep' = `selind', `selnc' `soffopt')	/*
	*/ `offopt'					/*
	*/ `diopts'					/*
	*/ mlopts(`mlopts')				/*
	*/ `svymlopts'
	if "`r(results)'" != "" {
		tempname Vmeff
		mat `Vmeff' = e(V)
	}

/* Fit full model */

	cap noi ml model lf heckp_lf					/*
	*/ (`depvar': `depvar' = `varlist', `offopt' `constant')	/*
	*/ (`selname': `seldep' = `selind', `selnc' `soffopt')		/*
	*/ /athrho							/*
	*/ if `touse',							/*
	*/ collinear							/*
	*/ missing							/*
	*/ max								/*
	*/ nooutput							/*
	*/ nopreserve							/*
	*/ `mlopts'							/*
	*/ svy								/*
	*/ `svymlopts'							/*
	*/ `scopt'							/*
	*/ `log'							/*
	*/ init(`from')							/*
	*/ search(off)							/*
	*/ title(Survey probit model with sample selection)		/*
	*/ crittype("log pseudolikelihood")				/*
	*/

	if _rc == 1400 & "`from'" == "`b0', copy" {
		di as txt "note:  default initial values "	/*
		*/ "infeasible; starting from B=0"

		cap noi ml model lf heckp_lf				/*
		*/ (`depvar': `depvar' = `varlist', `offopt' `constant')/*
		*/ (`selname': `seldep' = `selind', `selnc' `soffopt')	/*
		*/ /athrho						/*
		*/ if `touse',						/*
		*/ collinear						/*
		*/ missing						/*
		*/ max							/*
		*/ nooutput						/*
		*/ nopreserve						/*
		*/ `mlopts'						/*
		*/ svy							/*
		*/ `svymlopts'						/*
		*/ `scopt'						/*
		*/ `log'						/*
		*/ init(/athrho=0)					/*
		*/ search(off)						/*
		*/ title(Survey probit model with sample selection)	/*
		*/
	} 
	else if _rc {
		error _rc 
	}


/* Saved results */

	if "`score'" != "" {
		eret local scorevars `score'
	}
	else	eret local scorevars

	qui _diparm athrho, tanh
	eret scalar rho = r(est)

	tokenize `e(depvar)'
	if bsubstr("`2'", 1, 2) == "__" {
		eret local depvar `1'
	}
	eret scalar N_cens = `N_cens'
	eret local predict "heckpr_p"
	if "`Vmeff'" != "" {
		_svy_mkmeff `Vmeff'
	}
	eret scalar k_aux    = 1 /* # of ancillary parameters */
	eret local cmd "svyheckprob"

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

	Display , `diopts'
end


/* process the selection equation
	[depvar =] indvars [, noconstant offset ]
*/

program define SelectEq
	args seldep selind selnc seloff colon sel_eqn

	gettoken dep rest : sel_eqn, parse(" =")
	gettoken equal rest : rest, parse(" =")

	if "`equal'" == "=" {
		unab dep : `dep'
		c_local `seldep' `dep' 
	}
	else	local rest `"`sel_eqn'"'
	
	local 0 `"`rest'"'
	syntax [varlist(numeric default=none)] 	/*
		*/ [, noCONstant OFFset(varname numeric) ]

	if "`varlist'" == "" {
		di as err "no variables specified for selection equation"
		exit 198
	}

	c_local `selind' `varlist'
	c_local `selnc' `constant'
	c_local `seloff' `offset'
end


/* make a Beta_0 matrix of initial values */

program define MkB0
	args b0 colon b0sel hazvar

	tempname athrho

	mat `b0' = e(b)
	local k = colsof(`b0')

	scalar `athrho' = _b[`hazvar']
	scalar `athrho' = max(min(`athrho',.85), -.85)
	scalar `athrho' = 0.5 * log((1+`athrho') / (1-`athrho'))

	mat `b0' = `b0'[1,1..`k'-1] , `b0sel' , `athrho'
end

program define Display
	syntax [, Level(cilevel) * ]
	local opts svy level(`level') dof(`e(df_r)')

	ml display , level(`level') `options'				/*
	*/ diparm(athrho,  `opts' tanh label("rho"))			/*
	*/
end


program define oldDisplay
	syntax [, Level(cilevel) ]

	_crcshdr
	estimates display , level(`level') neq(2) plus

	_diparm athrho, level(`level')
	di in smcl as txt "{hline 13}{c +}{hline 64}"

	_diparm athrho, level(`level') tanh label("rho")
	di in smcl as txt "{hline 13}{c BT}{hline 64}"

	if "`e(vcetype)'" != "Robust" {
		local testtyp LR
	}
	else    local testtyp Wald
	di as txt  "`testtyp' test of indep. eqns. (rho = 0):" /*
		*/ _col(38) "chi2(" as res "1" as txt ") = "   /*
		*/ as res %8.2f e(chi2_c) 		     /*
		*/ _col(59) as txt "Prob > chi2 = " as res %6.4f e(p_c)
	di in smcl as txt "{hline 78}"

	exit e(rc)
end

/* Fit miss-specified model. */
program define FitMiss, rclass
	syntax varlist if [,		/*
	*/ constant			/*
	*/ mlopts(string)		/*
	*/ offset(passthru)		/*
	*/ sel(passthru)		/*
	*/ MEFF				/*
	*/ MEFT				/*
	*/ *				/*
	*/ ]

	svyopts junk junk2 junk3, `options'
	local subcond `s(subpop)'

	tempname touse
	mark `touse' `if'
	eret clear
	if "`meff'`meft'" != "" {
		di _n as txt "Computing misspecified "		///
			as res "heckprob"			///
			as txt " model for meff/meft computation:"
		if "`subcond'" != "" {
			local mysubtouse (`touse' & `subcond' != 0)
		}
		else    local mysubtouse `touse'
		heckprob `varlist'	/*
		*/ if `mysubtouse',	/*
		*/ `constant'		/*
		*/ `mlopts'		/*
		*/ `offset'		/*
		*/ `sel'		/*
		*/
	}
	return local results `meff'`meft'
end

exit

