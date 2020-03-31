*! version 2.0.19  13feb2015
program define svy_est, sortpreserve
/*
   Syntax:  svy_est svycmd `0'
*/
	version 8, missing
	if _caller()<8 {
		svy_est_7 `0'
		exit
	}
	gettoken svycmd 0 : 0

	if replay() {
		if `"`e(cmd)'"'!="`svycmd'" {
			error 301
		}
		svy_dreg `0'  /* display results */
		exit
	}
	nobreak {
		capture noisily break {

		/* Create some temps for `svycmd' programs.
		   Note: S_VYtmp* are NOT used in svy_est.ado.
		*/
			tempvar doit subvar
			tempname tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9
			macro drop S_VY*
			global S_VYtmp1 `tmp1'
			global S_VYtmp2 `tmp2'
			global S_VYtmp3 `tmp3'
			global S_VYtmp4 `tmp4'
			global S_VYtmp5 `tmp5'
			global S_VYtmp6 `tmp6'
			global S_VYtmp7 `tmp7'
			global S_VYtmp8 `tmp8'
			global S_VYtmp9 `tmp9'

			SvyParse `svycmd' `doit' `subvar' `0'

			local dopts $S_VYdopt /* save display options */

			SvyEst `svycmd' `doit'
		}

		local rc = _rc
		macro drop S_VY*

		if `rc' {
			ereturn clear
			exit `rc'
		}
	}
	svy_dreg, `dopts' /* display results */
end

program define SvyEst, eclass
	args svycmd doit

	tempvar postit
	tempname b V Vdeff npop

/* Create necessary tempvars for scores. */

	`svycmd' 0 how_many_scores

	if "`svycmd'"=="svymlogit" | /*
	   */ "`svycmd'"=="svyologit" | /*
	   */ "`svycmd'"=="svyoprobit" {
		if $S_VYncat > 50 {
			error 149
		}
	}

	if `"$S_VYscore"' != "" {
		local k_scores : word count $S_VYscore
		if r(k_scores) != 1 & `k_scores' == 1 & /*
		*/ bsubstr("$S_VYscore",-1,1)=="*" {
			local stub = /*
			*/ bsubstr("$S_VYscore",1,length("$S_VYscore")-1)
			global S_VYscore
			forval i = 1/`r(k_scores)' {
				global S_VYscore $S_VYscore `stub'`i'
			}
		}
		else {
			if r(k_scores) != `k_scores' {
				di as err /*
*/ `"number of variables in score() option must be equal to `r(k_scores)'"'
				exit 198
			}
		}
		confirm new var $S_VYscore
		local k_scores : word count $S_VYscore
	}

	local i 1
	while `i' <= r(k_scores) {
		tempvar s
		local sclist `sclist' `s'
		local i = `i' + 1
	}

	if `r(cmdcando)' {
		local scopt score(`sclist')
	}

/* Are any of the options -log-, -trace-, -gradient-, -hessian-,
   or -showstep- specified?
*/
	Option "LOg TRace GRADient HESSian SHOWSTEP", $S_VYeopt

	if !`r(option)' {
		if "`svycmd'"=="svylogit" | "`svycmd'"=="svyprobit" {
			local nocoef "nocoef nolog"
		}
		else local quicmd "quietly"

		local quidi   "*"        /* do not display comment */
		local quimeff "quietly"  /* do not display meff computation */
	}

/* Get D, where V = DMD. */

	if "$S_VYwgt"!="" {
		local wt [iw=$S_VYexp]
		local wgted "weighted "
	}
	if "`svycmd'"=="svyreg" | "`svycmd'"=="svyivreg" {
		local mse1 "mse1"
	}

	`quidi' di _n as txt "Computing point estimates using `wgted'" /*
	*/ as res "$S_VYcmd" as txt ":"

	ereturn clear

	if inlist(substr("`svycmd'",4,.), /*
		*/ "logit","mlogit","ologit","oprobit","probit") {
		local crtype "log pseudolikelihood"
		local cropt crittype(`"`crtype'"')
	}
	else	{
		local crtype
		local cropt
	}
	`quicmd' $S_VYcmd $S_VYdepv $S_VYindv `wt' if $S_VYsub, /*
	*/ $S_VYeopt `mse1' `nocoef' `scopt' `cropt'

	quietly count if e(sample) /* can't trust commands with iweights
				      to get #obs right
				   */
	local nobs `r(N)'

	matrix `b' = e(b)
	matrix `V' = e(V)
	global S_VYb `b'
	global S_VYV `V'

/* Compute scores for commands that cannot, or do other work. */

	if "`svycmd'"=="svyivreg" {
		preserve
	}

	`svycmd' 0 scores `doit' `sclist'

/* Replace missing scores with zeros. */

	tokenize `sclist'
	local i 1
	while "``i''"!="" {
		capture replace ``i'' = 0 if missing(``i'')
		if _rc {
			local `i' " "
		}
		local i = `i' + 1
	}

/* Compute variance estimates. */

	_ROBUST `*' `wt' if `doit', v(`V') vsrs(`Vdeff') /*
	*/ $S_VYopt zeroweight

/* Save results from _ROBUST(). */

	global S_VYn    `r(N)'	      /* number of obs    */
	global S_VYnstr `r(N_strata)' /* number of strata */
	global S_VYnpsu `r(N_clust)'  /* number of PSUs   */
	scalar `npop'  = r(sum_w)     /* population size  */

	if r(N_sub)<. {
		tempname nsubpop
		global S_VYosub   `r(N_sub)'    /* # subpop. obs */
		scalar `nsubpop' = r(sum_wsub)  /* subpop. size  */
	}

	if "`svycmd'"=="svyivreg" {
		restore
		/* svyivreg changes the data, thus regenerate the scores */
		qui _predict double `sclist' if $S_VYsub, residual
		qui replace `sclist' = 0 if missing(`sclist')
	}

/* Get misspecified estimates if meff or meft specified. */

	Option "MEFF MEFT", $S_VYdopt /* was meff or meft specified? */

	if `r(option)' {
		`quimeff' di _n as txt "Computing misspecified " /*
		*/ as res "$S_VYcmd" as txt " model for meff/meft computation:"

		ereturn clear

		`quimeff' $S_VYcmd $S_VYdepv $S_VYindv if $S_VYsub, /*
		*/ $S_VYeopt

		tempname Vmeff
		capture matrix `Vmeff' = e(V)
		if _rc {
			matrix `Vmeff' = 0*`V'
		}
		else if e(N)!=`nobs' | colsof(`Vmeff')!=colsof(`V') {
			matrix `Vmeff' = 0*`V'
		}
	}

/* Post results. */

	local df = $S_VYnpsu - $S_VYnstr

	gen byte `postit' = `doit' /* may need `doit' later */
	ereturn post `b' `V', dof(`df') esample(`postit')

/* Save other results. */

	SvySave `npop' "`nsubpop'" `Vdeff' "`Vmeff'" /* save common results */

	`svycmd' 0 save         /* save special results */

	ereturn local cmd `svycmd'
	global S_E_cmd `e(cmd)' /* double save */
	if inlist(substr("`svycmd'",4,.), /*
		*/ "logit","mlogit","ologit","oprobit","probit") {
		ereturn hidden local crittype `crtype'
	}

	if `"`e(cmd)'"' == "svyivreg" {
		local 0 , $S_VYdopt
		syntax [, FIRST * ]
		if `"`first'"' != "" {
			`e(cmd)' 0 first `doit' $S_VYcons
		}
		global S_VYdopt `options'
	}

/* save the scores */
	if `"$S_VYscore"' != "" {
		forval i = 1/`k_scores' {
			local ts : word `i' of `sclist'
			local us : word `i' of $S_VYscore
			rename `ts' `us'
		}
	}

end

/*----------------------------- Parse programs -------------------------------*/

program define SvyParse
	gettoken svycmd 0 : 0
	gettoken doit   0 : 0
	gettoken subvar 0 : 0

/* S_VY macros:

	S_VYdopt  display options
	S_VYeopt  estimation options
	S_VYopt   options for _ROBUST

	S_VYadj   "noadjust" if specified
	S_VYsrss  "srssubpop" if specified

	S_VYdepv  dependent variable(s)
	S_VYindv  independent variables
	S_VYmodl  variable for model test

	S_VYwgt   weight type
	S_VYexp   weight expression
	S_VYstr   strata variable
	S_VYpsu   psu variable
	S_VYfpc   fpc variable

	S_VYsub	  subpop. expression = "`doit'" or "`doit' & `subpop'!=0"
*/

/* Call `svycmd' with "syntax" query to get # of dependent variables
   `s(k_depvar)', allowed command options `s(okopts)', special display
   options `s(dopts)', and whether there are ml options `s(mlopts)'.
*/
	`svycmd' 0 syntax `0'
	local cmd `s(cmd)'
	local k_depvar `s(k_depvar)'
	local okopts `s(okopts)'
	local dopts `s(dopts)'
	local first `s(first)'
	if "`s(mlopts)'"=="yes" {
		local mlopts "LOg *"
	}

	if "`s(new0)'"!="" {
		local 0 `s(new0)'
	}
/* Parse and check for some errors. */

	syntax varlist(min=`k_depvar' numeric)	/*
	*/	[pw iw/]		/* see _svy_newrule.ado
	*/	[if] [in]		/*
	*/	[,			/*
	*/	noCONstant		/*
	*/	SUBpop(string asis)	/*
	*/	SRSsubpop		/*
	*/	noADJust		/*
	*/	Level(cilevel)		/*
	*/	Prob			/*
	*/	CI			/*
	*/	DEFF			/*
	*/	DEFT			/*
	*/	MEFF			/*
	*/	MEFT			/*
	*/	EForm			/*
	*/	SCore(string)		/*
	*/	`okopts'		/*
	*/	`dopts'			/*
	*/	`first'			/*
	*/	`mlopts'		/*
	*/	`offset'		/*
	*/	STRata(passthru)	/* see _svy_newrule.ado
	*/	PSU(passthru)		/* see _svy_newrule.ado
	*/	FPC(passthru)		/* see _svy_newrule.ado
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	if "`mlopts'"!="" {
		mlopts mlopts, `options'
		CkConst ,`mlopts'
	}

/* Set global macros. */

	global S_VYcmd  `cmd'   /* name of underlying command */
	global S_VYadj  `adjust'   /* do unadjusted F test if !="" */
	global S_VYcons `constant'
	global S_VYscore `score'

/* Display options. */

	global S_VYdopt level(`level') `prob' `ci' `deff' `deft' /*
	*/ `meff' `meft' `eform' `first'

	local opts `dopts'
	while "`opts'"!="" { /* add special display options to S_VYdopt */
		NextOpt `opts'
		global S_VYdopt $S_VYdopt ``r(macro)''
		local opts `r(rest)'
	}

/* Options for estimation. */

	global S_VYeopt `constant' `log' `mlopts'

	local opts `okopts'
	while "`opts'"!="" { /* add other allowed options to S_VYeopt */
		NextOpt `opts'
		if "``r(macro)''"!="" {
			if `r(varlist)' {
				local markout `markout' ``r(macro)''
				global S_VYeopt $S_VYeopt /*
				*/ `r(option)'(``r(macro)'')
			}
			else global S_VYeopt $S_VYeopt ``r(macro)''
		}
		local opts `r(rest)'
	}

	CkConst , $S_VYeopt 

/* Split off dependent and independent variables. */

	local i 1
	while `i' <= `k_depvar' {
		gettoken var varlist : varlist
		global S_VYdepv $S_VYdepv `var'
		local i = `i' + 1
	}
	global S_VYindv `varlist' /* RHS for command */

	if "`constant'"!="" & "$S_VYindv"=="" {
		di as err /*
		*/ "independent variables required with noconstant option"
		exit 100
	}

/* Get weights, strata, psu, and fpc. */
	quietly svyset
	
	global S_VYstr `r(strata)'
	global S_VYpsu `r(psu)'
	global S_VYfpc `r(fpc)'

	if "`r(wtype)'"!="" {
		global S_VYexp `r(`r(wtype)')'
		global S_VYwgt `r(wtype)'
		local wt [`r(wtype)'`r(wexp)']
	}
	if "$S_VYstr"!="" {
		global S_VYopt $S_VYopt strata($S_VYstr)
	}
	if "$S_VYpsu"!="" {
		global S_VYopt $S_VYopt psu($S_VYpsu)
	}
	if "$S_VYfpc"!="" {
		global S_VYopt $S_VYopt fpc($S_VYfpc)
	}

/* Mark/markout. */

	mark `doit' `wt' `if' `in', zeroweight

	if "`svycmd'"=="svyintreg" {
		markout `doit' $S_VYindv $S_VYfpc `markout'
		local y1 : word 1 of $S_VYdepv
		local y2 : word 2 of $S_VYdepv
		qui replace `doit' = 0 if `y1'>=. & `y2'>=.
	}
	else	markout `doit' $S_VYdepv $S_VYindv $S_VYfpc `markout'

	markout `doit' $S_VYstr $S_VYpsu, strok

/* Compute total #obs. */

	qui count if `doit'
	local nobs = r(N)
	if `nobs' == 0 {
		error 2000
	}
	if "$S_VYwgt"!="" {
		qui count if `doit' & ($S_VYexp)!=0
		if r(N) == 0 {
			di as txt "all observations have zero weights"
			exit 2000
		}
	}

/* Handle subpop.  If no subpop, S_VYsub is mark variable `doit'. */

	if "`subpop'`srssubpop'"=="" {
		global S_VYsub `doit'
	}
	else {
		// WARNING: sort order should not change prior to calling
		// svy_sub; it accepts [in range].

		svy_sub `doit'		///
			`subvar'	///
			"$S_VYexp"	///
			"$S_VYstr"	///
			"" ""		/// not byable
			"`srssubpop'"	///
			`subpop'

		global S_VYsrss `r(srssubpop)'	/* srssubpop option flag */
		global S_VYopt $S_VYopt `r(srssubpop)' subpop(`subvar')

		global S_VYsub `subvar'
		global S_VYsubv `r(subcond)'
	}

/* Remove collinearity. */

/* 	if "`svycmd'"!="svyreg" & "`svycmd'"!="svyivreg" { */
		_rmcoll $S_VYindv `wt' if $S_VYsub, `constant'
		global S_VYindv `r(varlist)'
/*	} */

/* Save variables for model test; it may be reset by some commands. */

	global S_VYmodl $S_VYindv

end

program define NextOpt, rclass
	gettoken option 0 : 0, parse(" (")
	ret local option = lower("`option'")
			/* this is the option name */
	ret local macro = substr("`return(option)'",1,31)
			/* this is the macro name */
	ret scalar varlist = 0

/* Check if it is an "xxx(...)" option. */

	gettoken next 0 : 0, match(parens)
	if "`parens'"=="(" {
		local next = substr(ltrim("`next'"),1,7)
		if "`next'"=="varname" | "`next'"=="varlist" {
			ret scalar varlist = 1
		}

		ret local rest `0'
	}
	else	ret local rest `next' `0'
end

program define Option, rclass
	gettoken opts 0 : 0, parse(" ,")
	syntax [, `opts' *]

	while "`opts'"!="" {
		NextOpt `opts'
		if "``r(macro)''"!="" {
			return scalar option = 1
			return local contents ``r(macro)''
			exit
		}
		local opts `r(rest)'
	}

	return scalar option = 0
end

/*--------------------------- Save results program ---------------------------*/

program define SvySave, eclass
	args npop nsubpop Vdeff Vmeff

	ereturn scalar N_pop = `npop'		/* population size	*/

	if "`nsubpop'"!="" {
		ereturn scalar N_sub = $S_VYosub	/* # subpop. obs*/
		ereturn scalar N_subpop = `nsubpop'	/* subpop. size	*/
	}

/* Save results from S_VY* macros. */

	ereturn scalar N        = $S_VYn	/* number of obs	*/
	ereturn scalar N_strata = $S_VYnstr	/* number of strata	*/
	ereturn scalar N_psu    = $S_VYnpsu	/* number of PSUs	*/
	ereturn scalar df_r     = e(N_psu) - e(N_strata) /* df		*/

	ereturn local depvar  $S_VYdepv		/* dependent variable(s)*/
	ereturn local wtype   $S_VYwgt		/* weight type		*/
	if "$S_VYexp"!="" {
		ereturn local wexp "= $S_VYexp"	/* weight expression	*/
	}
	ereturn local strata  $S_VYstr		/* strata variable	*/
	ereturn local psu     $S_VYpsu		/* psu variable		*/
	ereturn local fpc     $S_VYfpc		/* fpc variable		*/
	ereturn local subpop  $S_VYsubv		/* subpop variable	*/
	ereturn local adjust  $S_VYadj		/* "noadjust" if given	*/
	ereturn local svy_est  svy_est		/* used by svy_dreg	*/

	Option "OFFset(varname numeric)", $S_VYeopt
	if `r(option)' {			/* offset variables	*/
		ereturn local offset `r(contents)'
	}

	Option "EXPosure(varname numeric)", $S_VYeopt
	if `r(option)' {			/* offset variable	*/
		ereturn local offset ln(`r(contents)')
	}

	if `"$S_VYscore"' != "" {		/* score() variables	*/
		ereturn local scorevars $S_VYscore
	}
/* Double saves. */

	global S_E_nobs = e(N)			/* number of obs	*/
	global S_E_nstr = e(N_strata)		/* number of strata	*/
	global S_E_npsu = e(N_psu)		/* number of PSUs	*/
	global S_E_npop = e(N_pop)		/* pop. size		*/

	if e(N_sub)<. {
		global S_E_osub = e(N_sub)	/* # subpop. obs	*/
		global S_E_nsub = e(N_subpop)	/* subpop. size		*/
	}

	global S_E_wgt  `e(wtype)'	/* weight type			*/
	global S_E_exp  `e(wexp)'	/* weight expression		*/
	global S_E_str  `e(strata)'	/* strata variable		*/
	global S_E_psu  `e(psu)'	/* psu variable			*/
	global S_E_fpc  `e(fpc)'	/* fpc variable			*/
	global S_E_depv `e(depvar)'	/* dependent variable(s)	*/
	global S_E_adj  `e(adjust)'	/* "noadjust" if specified	*/

/* Compute model F test: create e(F) and e(df_m). */

	my_svy_ftest "$S_VYmodl" "$S_VYcnt"

/* Make matrices e(deff), e(deft), and e(V_srs).
   If fpc, make matrix e(V_srswr).
   If meff or meft, make matrices e(V_msp) and e(meft).
*/
	_svy_mkvsrs `Vdeff' "$S_VYsrss"
	_svy_mkdeff
	if "`Vmeff'"!="" {
		_svy_mkmeff `Vmeff'
	}
end

program define my_svy_ftest, eclass
	version 8
	args modl const

	if "`modl'"!="" {
		capture _test `modl', min

		if _rc==0 {
			ereturn scalar df_m = r(df)

			if reldif(r(drop) ,0)<1e-10  | `"`const'"' == "1" {
				if "`e(adjust)'"=="" {
					if e(df_r)-e(df_m)+1 > 0 {
						ereturn scalar F = /*
					*/ r(F)*(e(df_r)-e(df_m)+1)/e(df_r)
					}
				}
				else { /* unadjusted */
					ereturn scalar F = r(F)
				}
			}
			else {
				ereturn scalar F = .
			}	
		}
	}
	else ereturn scalar df_m = 0

/* Double saves. */

	global S_E_f = e(F)
	global S_E_mdf = e(df_m)
end

program define CkConst
	syntax [, CONSTRAINTS(string) * ]
	if "`constraints'" != "" {
		global S_VYcnt 1
	}
end
exit
