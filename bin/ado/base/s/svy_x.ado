*! version 2.1.0  16feb2015
program define svy_x, sortpreserve
	version 8, missing
	if _caller()<8 {
		svy_x_7 `0'
		exit
	}
	gettoken cmd 0 : 0
	if replay() {
		if "`e(cmd)'"!="svy`cmd'" {
			error 301
		}
		svy_disp `0'  /* display results */
		exit
	}
	nobreak {
		capture noisily break {
			tempvar doit subvar

			SvyParse `cmd' `doit' `subvar' `0'

			local dopt "$S_VYdopt" /* display options */

			if "$S_VYcomp"!="" { /* complete cases */

				Complete `doit'
			}
			else { /* available; do one variable at a time */

				Avail `doit' `subvar'
			}
		}
		local rc = _rc
		macro drop S_VY*

		if `rc' {
			ereturn clear
			exit `rc'
		}
	}

	svy_disp, `dopt'  /* display results */
end

program define Complete
	args doit

	tempname b V Vdeff Vmeff nsub osub error

	global S_VYdeff "`Vdeff'"
	global S_VYmeff "`Vmeff'"
	global S_VYerr  "`error'"
	global S_VYosub "`osub'"
	global S_VYnsub "`nsub'"

	if "$S_VYfpc"!="" {
		tempname Vdeft
		global S_VYdeft "`Vdeft'"
	}
	if "$S_VYwgt"!="" {
		local wt "[$S_VYwgt=$S_VYexp]"
	}
	if "$S_VYnby"!="" {
		local srssub "srssub"

		if $S_VYnby > 1 {
			local onopt "obs($S_VYosub) npop($S_VYnsub)"
		}
	}

/* Main call to _svy. */

	_svy $S_VYvl `wt' if `doit', type($S_VYcmd) $S_VYopt /*
	*/	b(`b') v(`V') vsrs($S_VYdeff) `onopt'

	global S_VYnobs = r(N)
	global S_VYnstr = r(N_strata)
	global S_VYnpsu = r(N_psu)
	global S_VYnpop = r(N_pop)

	if "`onopt'"=="" {
		MakeN $S_VYnvl `osub' `nsub'
	}

	local dim = colsof(`b')
	matrix `error' = J(1,`dim',0)

	if r(errcode)==3 | r(errcode)==4 {
		CompErr `b' $S_VYerr
	}

/* Call for meff. */

	if "$S_VYcmd"=="total" {
		local cmd "mean"
	}
	else	local cmd "$S_VYcmd"

	_svy $S_VYvl if `doit', type(`cmd') $S_VYsopt /*
	*/	vsrs($S_VYmeff) `srssub'

	if "$S_VYcmd"=="total" {
		CompMeff
	}

/* Create Vdeft if fpc. */

	if "$S_VYfpc"!="" {
		CompDeft
	}

/* Label matrices. */

	Labelmat `b' `V' $S_VYosub $S_VYnsub /*
	*/	 $S_VYdeff $S_VYdeft $S_VYmeff $S_VYerr

/* Post. */

	local cmd = upper(substr("$S_VYcmd",1,1)) + substr("$S_VYcmd",2,.)

	local dof = $S_VYnpsu - $S_VYnstr

	ereturn post `b' `V', dof(`dof') obs($S_VYnobs) depn(`cmd') /*
	*/ esample(`doit')

	SvySave  /* set macros, etc. */
end

program define Avail
	args doit subvar

	tempname b b1 V V1 Vdeff Vdeff1 Vmeff Vmeff1 /*
	*/ nsub nsub1 osub osub1 error error1 /*
	*/ mstr mstr1 mpsu mpsu1 zero sqzero

	global S_VYb    "`b'"
	global S_VYv    "`V'"
	global S_VYdeff "`Vdeff'"
	global S_VYmeff "`Vmeff'"
	global S_VYerr  "`error'"
	global S_VYosub "`osub'"
	global S_VYnsub "`nsub'"
	global S_VYmstr "`mstr'"
	global S_VYmpsu "`mpsu'"

	if "$S_VYfpc"!="" {
		tempname Vdeft
		global S_VYdeft "`Vdeft'"
	}
	if "$S_VYwgt"!="" {
		local wt "[$S_VYwgt=$S_VYexp]"
	}
	if "$S_VYnby"!="" {
		local srssub "srssub"
		local dim    "$S_VYnby"
		if $S_VYnby > 1 {
			local onopt "obs(`osub1') npop(`nsub1')"
		}
	}
	else local dim 1

	matrix `zero'   = J(1,`dim',0)
	matrix `sqzero' = J(`dim',`dim',0)

	if "$S_VYfpc"!="" {
		matrix $S_VYdeft = J(1,$S_VYnvl,0)
	}

	if "$S_VYcmd"=="total" {
		local meffcmd "mean"
	}
	else	local meffcmd "$S_VYcmd"

/* Sort. */

	if "${S_VYstr}${S_VYpsu}"!="" {
		sort $S_VYstr $S_VYpsu
	}

/* Get $S_VYnpop, etc., for dataset assuming no missing values. */

	_svy `doit' `wt' if `doit', type(total) $S_VYopt vsrs(*)

	global S_VYnobs = r(N)
	global S_VYnstr = r(N_strata)
	global S_VYnpsu = r(N_psu)
	global S_VYnpop = r(N_pop)

/* Step through varlist. */

	tokenize $S_VYvl
	local first 1
	local i 1
	while `i' <= $S_VYnvl {
		if "$S_VYcmd"=="ratio" {
			local i2 = 2*`i'
			local i1 = `i2' - 1
			local vl "``i1'' ``i2''"
		}
		else	local vl "``i''"

		local setzero 0

	/* Main call to _svy. */

		cap _svy `vl' `wt' if `doit', type($S_VYcmd) $S_VYopt /*
		*/	b(`b1') v(`V1') vsrs(`Vdeff1') `onopt'
		if _rc {
			local rc = _rc
			if `rc' == 460 {
				matrix `error1' = J(1,`dim',2)
				local nobs 0
				local setzero 1
			}
			else error `rc'
		}
		else if r(N)==0 {
			matrix `error1' = J(1,`dim',1)
			local setzero 1
		}
		else	matrix `error1' = `zero'

	/* Build vectors. */

		if `setzero' {
			matrix `b1'     = `zero'
			matrix `V1'     = `sqzero'
			matrix `Vdeff1' = `sqzero'
			matrix `osub1'  = `zero'
			matrix `nsub1'  = `zero'
			matrix `mstr1'  = `zero'
			matrix `mpsu1'  = `zero'
		}
		if `first' {
			matrix `b'     = `b1'
			matrix `V'     = vecdiag(`V1')
			matrix `Vdeff' = vecdiag(`Vdeff1')
			if "`onopt'"=="" {
				MakeN `dim' `osub' `nsub' `mstr' `mpsu'
			}
			else {
				matrix `osub' = `osub1'
				matrix `nsub' = `nsub1'
				MakeN `dim' "" "" `mstr' `mpsu'
			}
			if r(errcode)==3 | r(errcode)==4 /*
			*/ | ("$S_VYcmd"=="total" & !`setzero')  {
				AvErr `b1' `error' `osub'
			}
			else 	matrix `error' = `error1'
		}
		else {
			matrix `b'      = `b'     , `b1'
			matrix `V1'     = vecdiag(`V1')
			matrix `Vdeff1' = vecdiag(`Vdeff1')
			matrix `V'      = `V'     , `V1'
			matrix `Vdeff'  = `Vdeff' , `Vdeff1'
			if "`onopt'"=="" {
				MakeN `dim' `osub1' `nsub1' `mstr1' `mpsu1'
			}
			else {
				MakeN `dim' "" "" `mstr1' `mpsu1'
			}
			matrix `osub' = `osub' , `osub1'
			matrix `nsub' = `nsub' , `nsub1'
			matrix `mstr' = `mstr' , `mstr1'
			matrix `mpsu' = `mpsu' , `mpsu1'
			if r(errcode)==3 | r(errcode)==4 /*
			*/ | ("$S_VYcmd"=="total" & !`setzero')  {
				AvErr `b1' `error1' `osub1'
			}
			matrix `error' = `error' , `error1'
		}

	/* Check obs. */

		if r(N)!=$S_VYnobs {
			global S_VYmiss "missing"
		}

	/* Set deft if fpc. */

		if "$S_VYfpc"!="" {
			matrix $S_VYdeft[1,`i'] /*
			*/ = cond(1/(1-r(N)/r(N_pop))<., /*
			*/        1/(1-r(N)/r(N_pop)), 0)
		}

	/* Call for meff. */

		cap _svy `vl' if `doit', type(`meffcmd') vsrs(`Vmeff1') /*
		*/	$S_VYsopt `srssub'

		if _rc | r(N)==0 {
			matrix `Vmeff1' = `sqzero'
		}
		if `first' {
			matrix `Vmeff' = vecdiag(`Vmeff1')
			local first 0
		}
		else {
			matrix `Vmeff1' = vecdiag(`Vmeff1')
			matrix `Vmeff'  = `Vmeff' , `Vmeff1'
		}

		local i = `i' + 1
	}

	if "$S_VYcmd"=="total" {
		AvMeff
	}

/* Create Vdeft if fpc. */

	if "$S_VYfpc"!="" {
		AvDeft
	}

/* Label matrices. */

	Labelmat $S_VYb $S_VYv $S_VYosub $S_VYnsub /*
	*/	 $S_VYdeff $S_VYdeft $S_VYmeff     /*
	*/	 $S_VYerr $S_VYmstr $S_VYmpsu

/* Do fake post to set e(sample). */

	matrix `b1' = 0
	matrix `V1' = 0
	matrix colnames `b1' = dummy
	matrix colnames `V1' = dummy
	matrix rownames `V1' = dummy
	ereturn post `b1' `V1', esample(`doit')

	SvySave  /* set macros, etc. */
end

program define CompErr
	args b error
	local dim = colsof(`b')
	local i 1
	while `i' <= `dim' {
		if reldif(`b'[1,`i'],1e99) < 1e-14 {
			matrix `b'[1,`i'] = 0
			matrix `error'[1,`i'] = r(errcode) /* from _svy call */
		}
		local i = `i' + 1
	}
end

program define AvErr
	args b error osub

	local dim = colsof(`b')
	matrix `error' = J(1,`dim',0)

	if "$S_VYcmd"=="total" {
		local i 1
		while `i' <= `dim' {
			if `osub'[1,`i']==0 {
				matrix `error'[1,`i'] = 1
			}
			local i = `i' + 1
		}
		exit
	}

/* Here only if mean or ratio with error. */

	local i 1
	while `i' <= `dim' {
		if reldif(`b'[1,`i'],1e99) < 1e-14 {
			matrix `b'[1,`i'] = 0
			if `osub'[1,`i']==0 {
				matrix `error'[1,`i'] = 1
			}
			else if "$S_VYcmd"!="ratio" {
				matrix `error'[1,`i'] = 3
			}
			else	matrix `error'[1,`i'] = 4
		}
		local i = `i' + 1
	}
end

program define CompDeft  /* version for complete case */
	tempname c

	if "$S_VYsrss"=="" {
		scalar `c' = cond(1/(1-$S_VYnobs/$S_VYnpop)<., /*
		*/ 1/(1-$S_VYnobs/$S_VYnpop), 0)

		matrix $S_VYdeft = `c'*$S_VYdeff
		exit
	}

/* Here only if srssubpop. */

	matrix $S_VYdeft = J(1,$S_VYnby,0)

	local i 1
	while `i' <= $S_VYnby {
		matrix $S_VYdeft[1,`i'] /*
	 	*/ = cond(1/(1-$S_VYosub[1,`i']/$S_VYnsub[1,`i'])<., /*
		*/        1/(1-$S_VYosub[1,`i']/$S_VYnsub[1,`i']), 0)
		local i = `i' + 1
	}

	matrix `c' = J(1,$S_VYnvl,1)
	matrix $S_VYdeft = `c' # $S_VYdeft
	matrix $S_VYdeft = diag($S_VYdeft)
	matrix $S_VYdeft = $S_VYdeft*$S_VYdeff
end

program define CompMeff  /* version for complete case */
	tempname c

	if "$S_VYnby"=="" | "$S_VYnby"=="1" {
		scalar `c' = $S_VYnsub[1,1]^2
		matrix $S_VYmeff = `c'*$S_VYmeff
		exit
	}

	matrix `c' = J(1,$S_VYnby,0)

	local i 1
	while `i' <= $S_VYnby {
		matrix `c'[1,`i'] = $S_VYnsub[1,`i']^2
		local i = `i' + 1
	}

	tempname a
	matrix `a' = J(1,$S_VYnvl,1)
	matrix `c' = `a' # `c'
	matrix `c' = diag(`c')
	matrix $S_VYmeff = `c'*$S_VYmeff
end

program define AvDeft  /* version for available case */

	if "$S_VYsrss"=="" {
		if "$S_VYnby"!="" {
			local dim = $S_VYnby*$S_VYnvl
			if $S_VYnby > 1 {
				tempname c
				matrix `c' = J(1,$S_VYnby,1)
				matrix $S_VYdeft = $S_VYdeft # `c'
			}
		}
		else 	local dim "$S_VYnvl"

		local i 1
		while `i' <= `dim' {
			matrix $S_VYdeft[1,`i'] = $S_VYdeft[1,`i'] /*
			*/			 *$S_VYdeff[1,`i']
			local i = `i' + 1
		}
		exit
	}

/* Here only if srssubpop. */

	local dim = $S_VYnby*$S_VYnvl

	matrix $S_VYdeft = $S_VYdeff

	local i 1
	while `i' <= `dim' {
		matrix $S_VYdeft[1,`i'] /*
 		*/= cond(1/(1-$S_VYosub[1,`i']/$S_VYnsub[1,`i'])<.,/*
		*/       1/(1-$S_VYosub[1,`i']/$S_VYnsub[1,`i']), 0)/*
		*/  *$S_VYdeff[1,`i']

		local i = `i' + 1
	}
end

program define AvMeff  /* version for available case */
	local dim = colsof($S_VYnsub)

	local i 1
	while `i' <= `dim' {
		matrix $S_VYmeff[1,`i'] = $S_VYnsub[1,`i']^2*$S_VYmeff[1,`i']
		local i = `i' + 1
	}
end

program define MakeN
	args dim osub nsub nstr npsu

/* Note: r() refer to an _svy call before MakeN is called. */

	tempname one s

	if "$S_VYnby"=="" {
		local obs  "r(N)"
		local npop "r(N_pop)"
	}
	else {
		local obs  "r(N_sub)"
		local npop "r(N_subpop)"
	}
	matrix `one' = J(1,`dim',1)

	if "`osub'"!="" {
		scalar `s'    = cond(`obs'<.,`obs',0)
		matrix `osub' = `s'*`one'
		scalar `s'    = cond(`npop'<.,`npop',0)
		matrix `nsub' = `s'*`one'
	}
	if "`nstr'"!="" {
		scalar `s'    = cond(r(N_strata)<.,r(N_strata),0)
		matrix `nstr' = `s'*`one'
		scalar `s'    = cond(r(N_psu)<.,r(N_psu),0)
		matrix `npsu' = `s'*`one'
	}
end

program define Labelmat /* list of matrices */
	GetNames  /* get equation and column names */
	local M 1
	while "``M''"!="" {
		matrix coleq   ``M'' = $S_VYceq
		matrix colname ``M'' = $S_VYcnam
		if rowsof(``M'')==colsof(``M'') {
			matrix roweq   ``M'' = $S_VYceq
			matrix rowname ``M'' = $S_VYcnam
		}
		local M = `M' + 1
	}
end

program define GetNames
	if "$S_VYby"=="" {
		if "$S_VYcmd"!="ratio" {
			global S_VYceq  "_"
			global S_VYcnam "$S_VYvl"
			exit
		}

	/* Do ratio with no by() subpops. */

		tokenize $S_VYvl
		local y 1
		while "``y''"!="" {
			local x = `y' + 1
			global S_VYceq "$S_VYceq ``y''"
			global S_VYcnam "$S_VYcnam ``x''"
			local y = `y' + 2
		}
		exit
	}

/* If here, there are by() subpops. */

	local nvar : word count $S_VYby
	if `nvar'==1 { /* there is one subpop label */
		local twoby "*"
		local cnam "$S_VYcnam"
		global S_VYcnam
	}
	else { /* use numbers (isub) for subpop labels */
		local isub 1
		while `isub' <= $S_VYnby {
			local cnam "`cnam' `isub'"
			local isub = `isub' + 1
		}
	}

	if "$S_VYcmd"!="ratio" {
		parse "$S_VYvl", parse(" ")
		local ro "*"  /* do for ratio only */
	}
	else local mo "*"  /* do for mean and total only */
	local y 1
	while `y' <= $S_VYnvl {
		global S_VYcnam "$S_VYcnam `cnam'"
		local isub 1
		while `isub' <= $S_VYnby {
			`mo' global S_VYceq "$S_VYceq ``y''"
			`ro' global S_VYceq "$S_VYceq `y'"
			local isub = `isub' + 1
		}
		local y = `y' + 1
	}
end

program define SvySave, eclass

	MakeDeff  /* make matrices e(deff), e(deft), and e(meft) */

/* Matrices. */

	ereturn matrix V_srs   $S_VYdeff
	ereturn matrix V_msp   $S_VYmeff
	ereturn matrix _N_subp $S_VYnsub
	ereturn matrix _N      $S_VYosub
	ereturn matrix error   $S_VYerr

	if "$S_VYfpc"!="" {
		ereturn matrix V_srswr $S_VYdeft
	}
	if "$S_VYcomp"=="" {
		ereturn matrix est    $S_VYb
		ereturn matrix V_db   $S_VYv
		ereturn matrix _N_str $S_VYmstr
		ereturn matrix _N_psu $S_VYmpsu
	}
	else {
		tempname b V
		matrix `b' = e(b)
		matrix `V' = e(V)
		ereturn matrix est `b'
		ereturn matrix V_db `V'
	}

/* Scalars. */

	ereturn scalar N         = $S_VYnobs
	ereturn scalar N_strata  = $S_VYnstr
	ereturn scalar N_psu     = $S_VYnpsu
	ereturn scalar N_pop     = $S_VYnpop
	if "$S_VYnby"!="" {
		ereturn scalar n_by = $S_VYnby
	}

/* Macros. */

	ereturn local wtype    $S_VYwgt
	if "$S_VYexp"!="" {
		ereturn local wexp "= $S_VYexp"
	}
	ereturn local strata   $S_VYstr
	ereturn local psu      $S_VYpsu
	ereturn local subpop   $S_VYsub
	ereturn local subexp   "$S_VYsexp"
	ereturn local fpc      $S_VYfpc
	ereturn local by       $S_VYby
	ereturn local label    $S_VYlab

	ereturn local depvar   = upper(bsubstr("$S_VYcmd",1,1)) + /*
			   */ bsubstr("$S_VYcmd",2,.)

/* Undocumented information for display. */

	if "$S_VYcomp"=="" {
		ereturn local complete "available"
	}
	else	ereturn local complete "complete"

	ereturn local missing  $S_VYmiss
	ereturn local varlist     $S_VYvl

	ereturn local predict  svy_x_p
	ereturn local cmd      svy$S_VYcmd

/* Double saves. */

	global S_E_nobs `e(N)'
	global S_E_nstr `e(N_strata)'
	global S_E_npsu `e(N_psu)'
	global S_E_npop `e(N_pop)'
	global S_E_nby  `e(n_by)'
	global S_E_by   `e(by)'
	global S_E_lab  `e(label)'
	global S_E_miss `e(missing)'
	global S_E_wgt  `e(wtype)'
	global S_E_exp  `e(wexp)'
	global S_E_str  `e(strata)'
	global S_E_psu  `e(psu)'
	global S_E_fpc  `e(fpc)'
	global S_E_sub  "`e(subexp)'"
	global S_E_vl   `e(varlist)'
	global S_E_depv `e(depvar)'
	global S_E_cmd  `e(cmd)'

	matrix S_E_deff = e(deff)
	matrix S_E_deft = e(deft)
	matrix S_E_meft = e(meft)
	matrix S_E_Vsrs = e(V_srs)
	matrix S_E_Vmsp = e(V_msp)
	matrix S_E_npop = e(_N_subp)
	matrix S_E_nobs = e(_N)
	matrix S_E_err  = e(error)

	if "$S_VYfpc"!="" {
		matrix S_E_Vswr = e(V_srswr)
	}
	if "$S_VYcomp"=="" { /* this is what was set here in 5.0 */
		matrix S_E_b    = e(est)
		matrix S_E_V    = e(V_db)
		matrix S_E_nstr = e(_N_str)
		matrix S_E_npsu = e(_N_psu)
	}
end

program define SvyParse
	gettoken name   0 : 0
	gettoken doit   0 : 0
	gettoken subvar 0 : 0

/* Parse. */

	if "`name'"=="ratio" {
		ParseRat `0'
		local 0 `s(new0)'
	}

	syntax varlist(numeric) 	/*
	*/	[pw iw/]		/* see _svy_newrule.ado
	*/	[if] [in] [,		/*
	*/	COMplete		/*
	*/	AVailable		/*
	*/	BY(varlist numeric)	/*
	*/	SUBpop(string asis)	/*
	*/	SRSsubpop		/*
	*/	noLABel			/*
	*/	Level(cilevel)		/*
	*/	CI			/*
	*/	DEFF			/*
	*/	DEFT			/*
	*/	MEFF			/*
	*/	MEFT			/*
	*/	OBS			/*
	*/	SIZE			/*
	*/	STRata(passthru)	/* see _svy_newrule.ado
	*/	PSU(passthru)		/* see _svy_newrule.ado
	*/	FPC(passthru)		/* see _svy_newrule.ado
	*/	]

	_svy_newrule , `weight' `strata' `psu' `fpc'

	if "`complete'"!="" & "`available'"!="" {
		di as err "only one of complete and available can be " /*
		*/ "specified"
		exit 198
	}
	if "`srssubpop'"!="" & "`by'`subpop'"=="" {
		di as err "srssubpop can only be specified when by() or " /*
		*/ "subpop() is specified"
		exit 198
	}
	if "`label'"!="" & "`by'"=="" {
		di as err "nolabel can only be specified when by() " /*
		*/ "is specified"
		exit 198
	}

/* Set global macros. */

	macro drop S_VY*

	global S_VYcmd `name'
	global S_VYvl  `varlist'

	global S_VYnvl : word count `varlist'
	if "`name'"=="ratio" {
		global S_VYnvl = $S_VYnvl/2
	}

	global S_VYdopt  /*
	*/ level(`level') `ci' `deff' `deft' `meff' `meft' `obs' `size'

	global S_VYsrss `srssubpop'
	global S_VYopt

/* Get weights, strata, psu, and fpc. */
	quietly svyset
	if "`r(wtype)'" != "" {
		global S_VYexp `r(`r(wtype)')'
		global S_VYwgt `r(wtype)'
		local wt [`r(wtype)'`r(wexp)']
	}
	if "`r(strata)'"!="" {
		global S_VYstr `r(strata)'
		global S_VYopt $S_VYopt str($S_VYstr)
	}
	if "`r(psu)'"!="" {
		global S_VYpsu `r(psu)'
		global S_VYopt $S_VYopt psu($S_VYpsu)
	}
	if "`r(fpc)'"!="" {
		global S_VYfpc `r(fpc)'
		global S_VYopt $S_VYopt fpc($S_VYfpc)
	}

/* Process by() option. */

	if "`by'"!="" {
		if "`label'"=="" { /* use labels if possible */
			global S_VYlab "label"
		}
		global S_VYby `by'
	}

/* Mark/markout. */

	mark `doit' `wt' `if' `in', zeroweight

	if $S_VYnvl==1 & "`available'"=="" {
		local complete "complete"
	}

	markout `doit' $S_VYfpc $S_VYby
	markout `doit' $S_VYstr $S_VYpsu, strok

	if "`complete'"!="" {
		markout `doit' $S_VYvl
	}
	else if "`available'"=="" { /* give it a chance to be complete */
		tempvar doit2
		mark `doit2' if `doit'
		markout `doit2' $S_VYvl
		capture assert `doit'==`doit2'
		if _rc==0 {
			local complete "complete"
		}
	}

	global S_VYcomp "`complete'"

/* Compute total #obs. */

	qui count if `doit'
	if r(N) == 0 {
		error 2000
	}
	global S_VYnobs = r(N)

	if "`subpop'"=="" & "$S_VYby"=="" {
		exit
	}

/* Only here if subpopulations. */

	if "`subpop'"!="" {
		// WARNING: sort order should not change prior to calling
		// svy_sub; it accepts [in range].

		svy_sub `doit'			///
			`subvar' 		///
			"$S_VYexp"		///
			"$S_VYstr"		///
			"byable"		///
			`"${S_VYby}"'		///
			"${S_VYsrss}"		///
			`subpop'

		global S_VYsrss `r(srssubpop)'

                global S_VYsub  `r(subpop)'
		global S_VYsexp "`r(subexp)'"

		global S_VYnby 1
	}
	else	qui gen byte `subvar' = 1 if `doit'

	global S_VYopt $S_VYopt $S_VYsrss

/* Modify `subvar' variable and get labels if by() specified. */

	if "$S_VYby"!="" {
		GenSub `doit' `subvar' $S_VYby
	}

	global S_VYsopt "by(`subvar') nby($S_VYnby)"
	global S_VYopt  "$S_VYopt by(`subvar') nby($S_VYnby)"
end

program define ParseRat, sclass
	gettoken token 0 : 0, parse(" /[,(")
	local last 0
	local nvar 0
	while "`token'"!="," & "`token'"!="[" & "`token'"!="if" /*
	*/ & "`token'"!="in" & "`token'"!="" {
		if "`token'"=="/" {
			if `last' | mod(`nvar',2)==0 {
				error 198
			}
			local last 1
		}
		else {
			local list `list' `token'
			local last 0
			local nvar = `nvar' + 1
		}
		gettoken token 0 : 0, parse(" /[,(")
	}
	if mod(`nvar',2)!=0 {
		di as err "must have an even number of variables"
		error 198
	}
	sret local new0 `list' `token' `0'
end

program define GenSub
/*
   If there is one variable in by(), labels are put in S_VYcnam;
   if variable is labeled, these labels are used; otherwise, the
   variable's values are used.

   If there are two variables in by() and they are both labeled,
   the labels are put in S_VYlab.
*/
	gettoken doit   0 : 0
	gettoken subvar 0 : 0
	tempvar sub

	if "$S_VYlab"=="" { /* user specified nolabel */
		local nolabel "nolabel"
	}

	quietly {
		sort `doit' `subvar' `0'
		by `doit' `subvar' `0': gen byte `sub' = (_n==1) /*
		*/ if `subvar' & `doit'
		replace `subvar' = sum(`sub') if `subvar' & `doit'
		global S_VYnby = `subvar'[_N]
	}

	local nvar : word count `0'
	if `nvar' == 1 {
		GenLab1 `subvar' `0'
		exit
	}
	else if `nvar'==2 & "$S_VYlab"!="" {
		GenLab2 `subvar' `0'
		if "$S_VYlab"!="" {
			exit
		}
	}

	char `subvar'[varname] "Subpop."
	list `subvar' `0' if `subvar' != `subvar'[_n-1], /*
		*/ noobs `nolabel' subvar
end

program define GenLab1
/*
   Puts labels in global macro S_VYcnam.
*/
	args subvar x
	tempvar sub strx
	local type : type `subvar'
	qui gen `type' `sub' = `subvar' /*
	*/ if `subvar'!=`subvar'[_n-1] & `subvar' > 0

	if "$S_VYlab"!="" {
		local label : value label `x'
		capture label list `label'
		if (_rc) local label
		if "`label'"!="" {
			Decode `sub' `x' `strx'
		}
		else global S_VYlab
	}

	sort `sub'
	local i 1
	while `i' <= $S_VYnby {
		if "`label'"!="" {
			local tag = `strx'[`i']
		}
		else local tag
		if `"`tag'"'=="" {
			local value = `x'[`i']
			local tag = substr("`value'",1,8)
		}
		global S_VYcnam `"$S_VYcnam `tag'"'
		local i = `i' + 1
	}
end

program define GenLab2
/*
   Puts labels in global macro S_VYlab.
*/
	args subvar x1 x2
	tempvar sub strx1 strx2
	local type : type `subvar'
	global S_VYlab
	local lab1 : value label `x1'
	capture label list `lab1'
	if (_rc) local lab1
	local lab2 : value label `x2'
	capture label list `lab2'
	if (_rc) local lab2
	if "`lab1'"=="" | "`lab2'"=="" {
		exit
	}

	qui gen `type' `sub' = `subvar' /*
	*/ if `subvar'!=`subvar'[_n-1] & `subvar' > 0

	Decode `sub' `x1' `strx1'
	Decode `sub' `x2' `strx2'

	sort `sub'
	local i 1
	while `i' <= $S_VYnby {
		local tag1 = `strx1'[`i']
		if "`tag1'"=="" {
			local value = `x1'[`i']
			local tag1 = substr("`value'",1,8)
		}
		local tag2 = `strx2'[`i']
		if "`tag2'"=="" {
			local value = `x2'[`i']
			local tag2 = substr("`value'",1,8)
		}
		global S_VYlab $S_VYlab `tag1' `tag2'
		local i = `i' + 1
	}
end

program define Decode
	args flag x str
	tempvar sp period colon
	quietly {
		decode `x' if `flag'<., gen(`str')
		replace `str' = substr(trim(`str'),1,8) if `flag'<.

		/* Replace spaces with underscore, periods with comma, colons
		   with semicolons so names can safely be matrix names */
		local i 1
		while `i' <= 8 {
			gen byte `sp' = index(`str'," ") if `flag'<.
			summarize `sp'
			local spmax = r(max)
			gen byte `period' = index(`str',".") if `flag'<.
			summarize `period'
			local permax = r(max)
			gen byte `colon' = index(`str',":") if `flag'<.
			summarize `colon'
			local colmax = r(max)
			if `permax'==0 & `spmax'==0 & `colmax'==0 {
				exit
			}
			if `spmax' != 0 {
				replace `str' = substr(`str',1,`sp'-1) + "_" /*
				*/ + substr(`str',`sp'+1,.) if `sp'>0 & `sp'<.
			}
			if `permax' != 0 {
				replace `str' = substr(`str',1,`period'-1) + /*
					*/ "," + substr(`str',`period'+1,.) /*
					*/ if `period'>0 & `period'<.
			}
			if `colmax' != 0 {
				replace `str' = substr(`str',1,`colon'-1) + /*
					*/ ";" + substr(`str',`colon'+1,.) /*
					*/ if `colon'>0 & `colon'<.
			}
			drop `sp' `period' `colon'
			local i = `i' + 1
		}
	}
end

program define MakeDeff, eclass
	tempname f deff deft meft

	if "$S_VYcomp"!="" {
		tempname V
		matrix `V' = e(V)
		matrix `V' = vecdiag(`V')
		local ii "\$_i"
	}
	else {
		local V "$S_VYv"
		local ii 1
	}
	if "$S_VYfpc"!="" {
		local Vdeft "$S_VYdeft"
	}
	else	local Vdeft "$S_VYdeff"

	local dim = colsof(`V')
	matrix `deff' = `V'
	matrix `deft' = `V'
	matrix `meft' = `V'

	local i 1
	while `i' <= `dim' {
		scalar `f' = `V'[1,`i']/$S_VYdeff[`ii',`i']
		matrix `deff'[1,`i'] = cond(`f'<., `f', 0)

		scalar `f' = sqrt(`V'[1,`i']/`Vdeft'[`ii',`i'])
		matrix `deft'[1,`i'] = cond(`f'<., `f', 0)

		scalar `f' = sqrt(`V'[1,`i']/$S_VYmeff[`ii',`i'])
		matrix `meft'[1,`i'] = cond(`f'<., `f', 0)

		local i = `i' + 1
	}

	ereturn matrix deff `deff'
	ereturn matrix deft `deft'
	ereturn matrix meft `meft'
end
exit

error codes for e(error) vector:

	 1 = no obs (only possible with available)
	 2 = nh is 1 (only possible with available; complete aborts earlier)
	 3 = sum of weights is 0
	 4 = denominator is 0 for ratio

S_VY macros:

	global S_VYnobs     number of obs
	global S_VYnstr     number of strata
	global S_VYnpsu     number of PSUs
	global S_VYnpop     scalarname = sum of weights = pop. size
	global S_VYwgt      user's weight type
	global S_VYexp      user's weight variable or expression
	global S_VYstr      user's strata variable
	global S_VYpsu      user's psu variable
	global S_VYfpc      user's fpc variable
	global S_VYsub      user's subpop variable
	global S_VYsexp     subpop expression "varname!=0" or "varname==1"
				with [if] and [in] appended
	global S_VYcmd      svy* command
	global S_VYvl       user's varlist
	global S_VYnvl      # terms in varlist (ratio counts as 1)
	global S_VYopt      options for _svy
	global S_VYopt      by() nby() options for _svy meff call
	global S_VYdopt     user's display options
	global S_VYby       user's by() varlist
	global S_VYnby      # subpops formed with by()/subpop()
	global S_VYsrss     = "srssubpop" if srssubpop specified
	global S_VYlab      = "label" if labels for by() vars
	global S_VYmiss     = "missing" if . found using available
	global S_VYb        tempname for beta vector
	global S_VYv        tempname for covariance matrix
	global S_VYdeff     tempname for covariance matrix deff
	global S_VYdeft     tempname for covariance matrix deft
	global S_VYmeff     tempname for covariance matrix meff
	global S_VYnsub     tempname for vector of subpop size
	global S_VYosub     tempname for vector of subpop #obs
	global S_VYerr      tempname for vector of error flags
	global S_VYmstr     tempname for vector of #strata (available)
	global S_VYmpsu     tempname for vector of #psu (available)
	global S_VYceq      column equation names for matrices
	global S_VYcnam     column names for matrices
	global S_VYcomp     = "complete" if using complete cases

end of file
