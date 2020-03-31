*! version 1.0.11  07feb2012
program define svy_est_7
/*
   Syntax:  svy_est svycmd `0'
*/
	version 6, missing
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
			tempvar doit
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

			SvyParse `svycmd' `doit' `0'

			local dopts $S_VYdopt /* save display options */

			SvyEst `svycmd' `doit'
		}

		local rc = _rc
		macro drop S_VY*

		if `rc' {
			estimates clear
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

	`quidi' di _n in gr "Computing point estimates using `wgted'" /*
	*/ in ye "$S_VYcmd" in gr ":"

	estimates clear

	`quicmd' $S_VYcmd $S_VYdepv $S_VYindv `wt' if $S_VYsub, /*
	*/ $S_VYeopt `mse1' `nocoef' `scopt'

	quietly count if e(sample) /* can't trust commands with iweights
	                              to get #obs right
				   */
	local nobs `r(N)'

	matrix `b' = e(b)
	matrix `V' = e(V)
	global S_VYb `b'
	global S_VYV `V'

/* Compute scores for commands that cannot, or do other work. */

	if "`svycmd'"=="svyivreg" { preserve }

	`svycmd' 0 scores `doit' `sclist'

/* Replace missing scores with zeros. */

	tokenize `sclist'
	local i 1
	while "``i''"!="" {
		capture replace ``i'' = 0 if ``i''>=.
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

	if "`svycmd'"=="svyivreg" { restore }

/* Get misspecified estimates if meff or meft specified. */

	Option "MEFF MEFT", $S_VYdopt /* was meff or meft specified? */

	if `r(option)' {
		`quimeff' di _n in gr "Computing misspecified " /*
		*/ in ye "$S_VYcmd" in gr " model for meff/meft computation:"

		estimates clear

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
	estimates post `b' `V', dof(`df') esample(`postit')

/* Save other results. */

	SvySave `npop' "`nsubpop'" `Vdeff' "`Vmeff'" /* save common results */

	`svycmd' 0 save         /* save special results */

	est local cmd `svycmd'
	global S_E_cmd `e(cmd)' /* double save */
end

/*----------------------------- Parse programs -------------------------------*/

program define SvyParse
	gettoken svycmd 0 : 0
	gettoken doit   0 : 0

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
	local k_dv `s(k_depvar)'
	local okopts `s(okopts)'
	local dopts `s(dopts)'

	if "`s(mlopts)'"=="yes" {
		local mlopts "LOg *"
	}
	if "`s(new0)'"!="" {
		local 0 `s(new0)'
	}

/* Parse and check for some errors. */

	syntax varlist(min=`k_dv' numeric) [pw iw/] [if] [in] [, /*
	*/ noCONstant STRata(varname) PSU(varname) FPC(varname numeric) /*
	*/ SUBpop(varname numeric) SRSsubpop noADJust /*
	*/ Level(cilevel) Prob CI DEFF DEFT MEFF MEFT EForm /*
	*/ `okopts' `dopts' `mlopts' `offset' ]


	if "`mlopts'"!="" {
		mlopts mlopts, `options'
		CkConst ,`mlopts'
		
	}
	if "`srssubp'"!="" & "`subpop'"=="" {
		di in red "srssubpop can only be specified when subpop() " /*
		*/ "is specified"
		exit 198
	}

/* Set global macros. */

	global S_VYcmd  `cmd'   /* name of underlying command */
	global S_VYsrss `srssubp'  /* srssubpop option flag */
	global S_VYadj  `adjust'   /* do unadjusted F test if !="" */
	global S_VYopt  `srssubp'  /* options for _ROBUST; more added later */

/* Display options. */

	global S_VYdopt level(`level') `prob' `ci' `deff' `deft' /*
	*/ `meff' `meft' `eform'

	local opts `dopts'
	while "`opts'"!="" { /* add special display options to S_VYdopt */
		NextOpt `opts'
		global S_VYdopt $S_VYdopt ``r(macro)''
		local opts `r(rest)'
	}

/* Options for estimation. */

	global S_VYeopt `constan' `log' `mlopts'

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
	while `i' <= `k_dv' {
		gettoken var varlist : varlist
		global S_VYdepv $S_VYdepv `var'
		local i = `i' + 1
	}
	global S_VYindv `varlist' /* RHS for command */

	if "`constan'"!="" & "$S_VYindv"=="" {
		di in red /*
		*/ "independent variables required with noconstant option"
		exit 100
	}

/* Get weights. */

	if `"`exp'"'=="" {
		svy_get pweight, optional
		local exp `s(varname)'
	}
	else if "`weight'"=="pweight" { /* try to varset pweight variable */
		capture confirm variable `exp'
		if _rc==0 {
			svy_get pweight `exp'
			local exp `s(varname)'
		}
	}
	if "`exp'"!="" {
		global S_VYexp `exp'
		if "`weight'"!="" { global S_VYwgt `weight' }
		else		    global S_VYwgt "pweight"

		local wt [$S_VYwgt=$S_VYexp]
	}

/* Get strata, psu, and fpc. */

	svy_get strata `strata', optional
	global S_VYstr `s(varname)'
	if "$S_VYstr"!="" { global S_VYopt $S_VYopt strata($S_VYstr) }

	svy_get psu `psu', optional
	global S_VYpsu `s(varname)'
	if "$S_VYpsu"!="" { global S_VYopt $S_VYopt psu($S_VYpsu) }

	svy_get fpc `fpc', optional
	global S_VYfpc `s(varname)'
	if "$S_VYfpc"!="" { global S_VYopt $S_VYopt fpc($S_VYfpc) }

/* Mark/markout. */

	mark `doit' `wt' `if' `in', zeroweight

	if "`svycmd'"=="svyintreg" {
		markout `doit' $S_VYindv $S_VYfpc `subpop' `markout'
		local y1 : word 1 of $S_VYdepv
		local y2 : word 2 of $S_VYdepv
		qui replace `doit' = 0 if `y1'>=. & `y2'>=.
	}
	else	markout `doit' $S_VYdepv $S_VYindv $S_VYfpc `subpop' `markout'

	markout `doit' $S_VYstr $S_VYpsu, strok

/* Compute total #obs. */

	qui count if `doit'
	local nobs = r(N)
	if `nobs' == 0 { error 2000 }
	if "$S_VYwgt"!="" {
		qui count if `doit' & ($S_VYexp)!=0
		if r(N) == 0 {
			di in blu "all observations have zero weights"
			exit 2000
		}
	}

/* Handle subpop.  If no subpop, S_VYsub is mark variable `doit'. */

	if "`subpop'"=="" {
		global S_VYsub `doit'
	}
	else {
		global S_VYopt $S_VYopt subpop(`subpop')
		global S_VYsub (`doit'&`subpop'!=0)
		global S_VYsubv `subpop'

		svy_sub_7 `doit' `subpop' "$S_VYexp" "$S_VYstr"
	}

/* Remove collinearity. */

/* 	if "`svycmd'"!="svyreg" & "`svycmd'"!="svyivreg" { */
		_rmcoll $S_VYindv `wt' if $S_VYsub, `constan'
		global S_VYindv `r(varlist)'
/*	} */

/* Save variables for model test; it may be reset by some commands. */

	global S_VYmodl $S_VYindv
end

program define NextOpt, rclass
	gettoken option 0 : 0, parse(" (")
	ret local option = lower("`option'")
			/* this is the option name */
	ret local macro = substr("`return(option)'",1,7)
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

	est scalar N_pop = `npop'	  /* population size   	     */

	if "`nsubpop'"!="" {
		est scalar N_sub = $S_VYosub    /* # subpop. obs     */
		est scalar N_subpop = `nsubpop' /* subpop. size      */
	}

/* Save results from S_VY* macros. */

	est scalar N        = $S_VYn	 /* number of obs	     */
	est scalar N_strata = $S_VYnstr  /* number of strata	     */
	est scalar N_psu    = $S_VYnpsu  /* number of PSUs	     */
	est scalar df_r     = e(N_psu) - e(N_strata) /* df           */

	est local depvar  $S_VYdepv    /* dependent variable(s)      */
	est local wtype	  $S_VYwgt     /* weight type                */
	if "$S_VYexp"!="" {
		est local wexp "= $S_VYexp" /* weight expression     */
	}
	est local strata  $S_VYstr     /* strata variable            */
	est local psu     $S_VYpsu     /* psu variable               */
	est local fpc     $S_VYfpc     /* fpc variable               */
	est local subpop  $S_VYsubv    /* subpop variable            */
	est local adjust  $S_VYadj     /* "noadjust" if specified    */
	est local svy_est svy_est      /* used by svy_dreg           */

	Option "OFFset(varname numeric)", $S_VYeopt
	if `r(option)' {
		est local offset `r(contents)' /* offset variable    */
	}

	Option "EXPosure(varname numeric)", $S_VYeopt
	if `r(option)' {
		est local offset ln(`r(contents)') /* offset variable */
	}

/* Double saves. */

	global S_E_nobs = e(N)            /* number of obs	     */
	global S_E_nstr = e(N_strata)     /* number of strata	     */
	global S_E_npsu = e(N_psu)        /* number of PSUs	     */
	global S_E_npop = e(N_pop)        /* pop. size   	     */

	if e(N_sub)<. {
		global S_E_osub = e(N_sub)         /* # subpop. obs  */
		global S_E_nsub = e(N_subpop)      /* subpop. size   */
	}

	global S_E_wgt  `e(wtype)'   /* weight type                  */
	global S_E_exp  `e(wexp)'    /* weight expression            */
	global S_E_str  `e(strata)'  /* strata variable              */
	global S_E_psu  `e(psu)'     /* psu variable                 */
	global S_E_fpc  `e(fpc)'     /* fpc variable                 */
	global S_E_depv `e(depvar)'  /* dependent variable(s)        */
	global S_E_adj  `e(adjust)'  /* "noadjust" if specified      */

/* Compute model F test: create e(F) and e(df_m). */

	Ftest

/* Make matrices e(deff), e(deft), and e(V_srs).
   If fpc, make matrix e(V_srswr).
   If meff or meft, make matrices e(V_msp) and e(meft).
*/
	MakeDeff `Vdeff'
	if "`Vmeff'"!="" { MakeMeff `Vmeff' }
end

program define Ftest, eclass
	if "$S_VYmodl"!="" {
		capture test $S_VYmodl, min

		if _rc==0 {
			est scalar df_m = r(df)

			if reldif(r(drop) ,0)<1e-10  | "$S_VYcnt" =="yes" {
				if "`e(adjust)'"=="" { /* adjusted (default) */
					if e(df_r)-e(df_m)+1 > 0 {
						est scalar F = /*
					*/ r(F)*(e(df_r)-e(df_m)+1)/e(df_r)
					}
				}
				else { /* unadjusted */
					est scalar F = r(F)
				}
			}
			else {
				est scalar F = .
			}	
		}
	}
	else est scalar df_m = 0
		
/* Double saves. */

	global S_E_f = e(F)
	global S_E_mdf = e(df_m)
end

program define MakeDeff, eclass
	args Vsrs

/* Compute Vsrswr if fpc() specified. */

	tempname f V deff deft

	if "`e(fpc)'"!="" { /* create V_srswr matrix */
		if "$S_VYsrss"=="" {
			scalar `f' = 1/(1-e(N)/e(N_pop))
		}
		else	scalar `f' = 1/(1-e(N_sub)/e(N_subpop))

		if `f'>=. { scalar `f' = 0 }

		tempname Vsrswr
		matrix `Vsrswr' = `f'*`Vsrs' /* unwind fpc on Vsrs */
	}
	else	local Vsrswr `Vsrs'

/* Create row vectors containing deff and deft. */

	matrix `V' = e(V)
	matrix `V' = vecdiag(`V')
	matrix `deff' = `V'
	matrix `deft' = `V'

	local dim = colsof(`V')
	local i 1
	while `i' <= `dim' {
		scalar `f' = `V'[1,`i']/`Vsrs'[`i',`i']
		matrix `deff'[1,`i'] = cond(`f'<., `f', 0)

		scalar `f' = sqrt(`V'[1,`i']/`Vsrswr'[`i',`i'])
		matrix `deft'[1,`i'] = cond(`f'<., `f', 0)

		local i = `i' + 1
	}

/* Save matrices. */

	est matrix V_srs `Vsrs'
	est matrix deff  `deff'
	est matrix deft  `deft'

	if "`e(fpc)'"!="" {
		est matrix V_srswr `Vsrswr'
	}

/* Double saves. */

	matrix S_E_Vsrs = e(V_srs)
	matrix S_E_deff = e(deff)
	matrix S_E_deft = e(deft)

	if "`e(fpc)'"!="" {
		matrix S_E_Vswr = e(V_srswr)
	}
end

program define MakeMeff, eclass
	args Vmeff

/* Create row vector containing meft. */

	tempname V f meft
	matrix `V' = e(V)
	matrix `V' = vecdiag(`V')
	matrix `meft' = `V'

	local dim = colsof(`V')
	local i 1
	while `i' <= `dim' {
		scalar `f' = sqrt(`V'[1,`i']/`Vmeff'[`i',`i'])
		matrix `meft'[1,`i'] = cond(`f'<., `f', 0)

		local i = `i' + 1
	}

/* Save matrices. */

	est matrix V_msp `Vmeff'
	est matrix meft `meft'

/* Double saves. */

	matrix S_E_Vmsp = e(V_msp)
	matrix S_E_meft = e(meft)
end


program define CkConst
		syntax [, CONSTRAINTS(string) * ]
		if "`constraints'" != "" {
			global 	S_VYcnt "yes"
		}	
end		

/******************************** end of file ********************************/
