*! version 6.4.2  09feb2015
program define ml
	if _caller()>=11 {
		mopt `0'
		exit
	}
	version 8.2, missing
	version 6, missing
	if _caller()<6 {
		ml_5 `0'
		exit
	}
	local caller : display string(_caller())
	gettoken cmd 0: 0, parse(" ,")
	local l = length(`"`cmd'"')
	if `"`cmd'"' == "technique" {
		ml_technique `0'
		exit
	}
	if `"`cmd'"' == "clear" {				/* CLEAR */
		ml_clear `0'
		exit
	}
	if `"`cmd'"' == "hold" {				/* HOLD */
		ml_hold `0'
		exit
	}
	if `"`cmd'"' == "unhold" {				/* UNHOLD */
		ml_unhold `0'
		exit
	}
	if `"`cmd'"' == "score" {				/* SCORE */
		if "`e(opt)'" == "moptimize" {
			mopt score `0'
			exit
		}
		ml_score `0'
		exit
	}
	if `"`cmd'"'=="count" {					/* COUNT */
		ml_c_d count `0'
		exit
	}
	if `"`cmd'"' == "trace" { 				/* TRACE */
		ml_c_d trace `0'
		exit
	}
	if `"`cmd'"'==bsubstr("graph",1,max(2,`l')) { 		/* GRaph */
		ml_graph `0'
		exit
	}
	if `"`cmd'"' == "init" { 				/* INIT	*/
		ml_init `0'
		exit
	}
	if `"`cmd'"' == bsubstr("maximize",1,max(3,`l')) {	/* MAXimize */
		version `caller', missing: AllowEv ml_max `0'
		exit
	}
	if `"`cmd'"' == bsubstr("display",1,max(2,`l')) | /* 	/* DIsplay */
	*/ `"`cmd'"' == bsubstr("mlout",  1,max(3,`l')) { 	/* MLOut   */
		if "`e(opt)'" == "moptimize" {
			mopt display `0'
			exit
		}
		version `caller', missing: ml_mlout `0'
		exit
	}
	if `"`cmd'"' == bsubstr("footnote",1,max(4,`l')) {	/* FOOTnote */
		ml_footnote `0'
		exit
	}
	if `"`cmd'"' == bsubstr("model",1,max(3,`l')) {		/* MODel */
		version `caller', missing: MLmodel `0'
		exit
	}
	if `"`cmd'"' == "" | `"`cmd'"'==bsubstr("query",1,`l')  { /* Query */
		ml_query `0'
		exit
	}
	if `"`cmd'"' == bsubstr("report",1,max(3,`l')) {		/* REPort */
		AllowEv ml_repor `0'
		exit
	}
	if `"`cmd'"' == bsubstr("search",1,max(3,`l')) { 	/* SEArch */
		AllowEv ml_searc `0'
		exit
	}
	if `"`cmd'"' == bsubstr("plot",1,max(2,`l')) {		/* PLot */
		AllowEv ml_plot `0'
		exit
	}
	if `"`cmd'"' == "check" {				/* CHECK */
		AllowEv ml_check `0'
		exit
	}
	if `"`cmd'"' == bsubstr("begin",1,max(1,`l')) {
		#delimit ;
		di in red
`"ml has all new syntax in Stata 6.  "ml begin" is old syntax."' _n
`"If you want to use the old ml, type "version 5" before issuing any ml"' _n
`"commands.  To learn more about the new ml, type "help ml"."' ;
		#delimit cr
		exit 198
	}
	di as smcl in red `"subcommand {bf:ml} {bf:`cmd'} is unrecognized"'
	exit 199
end

program define AllowEv, eclass /* calls evaluation program */
	version 6
	local vv : display "version " string(_caller()) ":"
	ml_defd
	local i 1
	while `i' <= $ML_n {
		global ML_tn`i' : tempvar
		local i = `i' + 1
	}
	if "$ML_meth" == "lf" {
		forval i = 1/$ML_n {
			global ML_hn`i' : tempvar
		}
	}

	global ML_sclst
	if "$ML_mksc"!="" {
		local i 1
		while `i' <= $ML_n {
			global ML_sc`i': tempvar
			qui gen double ${ML_sc`i'} = .
			global ML_sclst $ML_sclst ${ML_sc`i'}
			local i = `i' + 1
		}
	}

	local pres
	global ML_pres
	if "$ML_save"!="" & "$ML_tsops"=="" {
		if "$ML_save"=="true" {
			capture assert 1==2		/* set _rc!=0 */
		}
		else	capture assert $ML_samp
		if _rc {
			tempvar recnum
			qui gen `c(obs_t)' `recnum' = _n
			qui compress `recnum'
			local sort : sortedby
			preserve
			qui keep if $ML_samp
			local pres 1
			global ML_pres 1
		}
	}

	global ML_trace 0 /* initialize log, trace, showstep options to nolog */
	global ML_dider 0 /* initialize derivative display options to nothing */

	if "$ML_evali"!="" {	/* call initialization program */
		$ML_evali init
	}

	capture noisily `vv' `0' /* call evaluation program */
	if _rc {
		local rc = _rc
		if _rc==199 {
			capture program list $ML_user
			if _rc==111 {
				di in red "program $ML_user not found"
				exit 111
			}
		}
		exit `rc'
	}

	if "$ML_evali"!="" {
		$ML_evali close
	}
		/* call initialization program for clean-up */

	if "$ML_setes"!="" & "`pres'"!="" {
		global ML_setes
		quietly {
			keep `sort' `recnum'
			tempvar esvar mervar
			gen byte `esvar' = e(sample)
			sort `sort' `recnum'
			tempfile xtra
			save `"`xtra'"'
			restore
			preserve, changed
			sort `sort' `recnum'
			merge `sort' `recnum' using `"`xtra'"', _merge(`mervar')
			replace `esvar' = 0 if `mervar'==1
			sort `sort' `recnum'
			est repost, esample(`esvar')
		}
		ml_clear
	}
end

program define MLmodel
	if `"`0'"' == "" {
		error 198
	}
	ml_clear
	local caller : display string(_caller())
	tempvar a b i
	tempname c d e f g h
	capture noisily {
		ml_model `"`caller' `a' `b' `c' `d' `e' `f' `g' `h' `i'"' `0'
		if `"`s(maxcmd)'"' != "" {
			version 6, missing: AllowEv `s(maxcmd)'
		}
	}
	if _rc {
		local rc = _rc
		ml_clear
		exit `rc'
	}
end
exit

/*
The ml commands are

	Begin			(old style)
	CHECK
	CLEAR
	COUNT
	GRaph
	INIt
	MAXimize
	MLOut
	MODel
	PLot
	Query
	REPort
	SEArch
	TRACE
*/
