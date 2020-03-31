*! version 7.6.0  18may2015
program define ml_max, eclass
	local vv : display "version " string(_caller()) ":"
	version 6 
	#delimit ;
	syntax [, Bounds(string) noCLEAR GRADient noHEADer HESSian
	          ITERate(string) GTOLerance(real -1)
		  Level(cilevel) NOLOg LOg noOUTput noWARNing
		  LTOLerance(real 1e-7)
		  NONRTOLerance NRTOLerance(real 1e-5) SHOWNRtolerance
		  Repeat(integer 0) SEArch(string) SCore(string) SHOWSTEP 
		  TOLerance(real 1e-6) TRace noVCE MAXFEAS(passthru) 
		  ITERONLY1 STEPALWAYS depsilon(string) DOTS SHOWH 
		  NOCNSReport * ] ;
	#delimit cr
	_get_eformopts , eformopts(`options') soptions allowed(__all__)
	local options `s(options)'
	local eform `s(eform)'
				/* MAXFEAS (undocumented) is maximum number
				   of random attempts for infeasible starting
				   values in ml_searc, search(on)
				*/
	if "`score'"!="" {
		if `"$ML_score"'=="" {
			di in red /*
			*/ "method $ML_meth does not allow score() option"
			exit 198
		}
		if "$ML_pres"!="" {		/* we are preserved */
			#delimit ;
			di in red
"May not specify score() option unless" _n
"     a)  estimation subsample is the entire data in memory, or" _n
"     b)  you specify nopreserve option on -ml model- statement (meaning" _n
"         your evaluation program explicitly restricts itself to obs." _n
"         for which $" "ML_samp==1." ;
			#delimit cr
			exit 198
		}
		if "$ML_nosc" != "" {
			opts_exclusive "score() noscore"
		}
		if "$ML_vscr" == "" {
			local numscr $ML_n
		}
		else	local numscr $ML_k
		local n : word count `score'
		if `n'==1 {
			if bsubstr("`score'",-1,1)=="*" {
				local nam = /*
				*/ bsubstr("`score'",1,length("`score'")-1)
				local score
				local i 1
				while `i' <= `numscr' {
					local score `score' `nam'`i'
					local i = `i' + 1
				}
				local nam
				local n : word count `score'
			}
		}
		if !(`n' == $ML_n | ("$ML_vscr" == "1" & `n' == $ML_k)) {
			di in red /*
*/ "score() requires you specify `numscr' new variable names in this case"
			exit 198
		}
		confirm new var `score'
		local n
	}

	global ML_svsc
	if "`score'"=="" & ("$ML_vce"=="robust" | "$ML_vce2"=="OPG") {
		global ML_svsc *
		local i 1
		if "$ML_vscr" == "" {
			local numscr $ML_n
		}
		else	local numscr $ML_k
		while `i' <= `numscr' {
			tempvar new
			local score `score' `new'
			local i = `i' + 1
		}
		local i
		local new
	}

/* assure adequate storage for scores */

	if "`score'" != "" & "$ML_mksc" == "" {
		local scr_ct : word count `score'
		local i 1
		while `i' <= `scr_ct' + 8 {
			capture {
				tempname scv`i'
				local sctvs `sctvs' `scv`i''
				gen double `scv`i''  = . in 1
				local scv`i'
			}
			if _rc {
				di in red "insufficient memory for score "  /*
					*/ "variables"
				exit 950
			}
			local i = `i' + 1
		}
		drop `sctvs'
		local sctvs
		local scr_ct
	}


/*
	Standard options are:
		$ML_trace	0 (nolog), 1 (log), 2 (trace), 3 (showstep),
		                4 (trace showstep)
		$ML_dider	0 (neither), 1 (gradient only),
				2 (hessian only), 3 (gradient and hessian)
		$ML_tol		coefficient tolerance
		$ML_ltol	log-likelihood (criterion) tolerance
		$ML_gtol	relative gradient_k/(1+Beta_k)  tolerance
		$ML_iter	max number of iterations
*/

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	SetTrace, `log' `trace' `gradien' `hessian' `showste'
	if `toleran'<0 {
		di in red "tolerance(`toleran') must be >= 0"
		exit 198
	}
	if `ltolera'<0 {
		di in red "ltolerance(`ltolera') must be >= 0"
		exit 198
	}
	if `gtolera'==-1 {
		local gtolera
	}
	else if `gtolera'<0 {
		di in red "gtolerance(`gtolera') must be >= 0"
		exit 198
	}
	if "`nonrtolerance'" != "" {
		opts_exclusive "`nonrtolerance' `shownrtolerance'"
		local nrtoler
	}
	else if `nrtolerance'<0 {
		di in red "nrtolerance(`nrtolerance') must be >= 0"
		exit 198
	}
	if "`iterate'"!="" {
		confirm integer number `iterate'
		if `iterate'<0 {
			di in red "iterate(`iterate') must be >= 0"
			exit 198
		}
		global ML_rc 0
	}
	else {
		local iterate `c(maxiter)'
		global ML_rc 430
	}
	
	global ML_conv 0
	global ML_iton1  = "`iteronly1'"  != ""
	global ML_stpal  = "`stepalways'" != ""
	local ndep : list sizeof depsilo
	if `ndep' {
		if !inlist(`ndep',3,6) {
			di as err "option depsilon() misspecified"
			exit 198
		}
		gettoken epmin	depsilo : depsilo
		gettoken ep0	depsilo : depsilo
		gettoken ep1	depsilo : depsilo
		if `epmin' >= `ep0' | `ep0' >= `ep1' {
			di as err "option depsilon() misspecified"
			exit 198
		}
		global ML_ep0m	`epmin'
		global ML_ep00	`ep0'
		global ML_ep01	`ep1'
		if `ndep' == 6 {
			gettoken epmin	depsilo : depsilo
			gettoken ep0	depsilo : depsilo
			gettoken ep1	depsilo : depsilo
			if `epmin' >= `ep0' | `ep0' >= `ep1' {
				di as err "option depsilon() misspecified"
				exit 198
			}
			global ML_ep1m	`epmin'
			global ML_ep10	`ep0'
			global ML_ep11	`ep1'
		}
	}

	if `"`dots'"' != "" {
		global ML_dots ml_dots
	}
	else	global ML_dots "*"

	global ML_tol `toleran'
	global ML_ltol `ltolera'
	global ML_gtol `gtolera'
	global ML_nrtol `nrtolerance'
	global ML_nrsho `shownrtolerance'
	global ML_showh `showh'
	global ML_iter `iterate'
	global ML_ic 0
	mat ML_log = J(1,20,0)

	global ML_swa
	if "$ML_svy2" != "" {
		// Adjust weights for calibration
		_svyset get calmethod
		if "`r(calmethod)'" != "" {
			local calmeth	`"`r(calmethod)'"'
			local calmode	`"`r(calmodel)'"'
			local calopts	`"`r(calopts)'"'
			tempvar wgt wgt2
			if "$ML_sw" != "" {
				local wt [iw=$ML_sw]
			}
			quietly ///
			svycal `calmeth' `calmode' `wt' if $ML_samp, ///
				generate(`wgt2')`calopts'
			sum `wgt2', mean
			global ML_pop `r(sum)'
			quietly gen double `wgt' = `wgt2'
			quietly replace `wgt' = 0 if $ML_wo == 0
			global ML_swa `wgt2'
			global ML_w `wgt'
		}
		// Adjust weights for poststratification
		_svyset get poststrata
		if "`r(poststrata)'" != "" {
			local posts posts(`r(poststrata)')
			local postw postw(`r(postweight)')
			tempvar wgt wgt2
			if "$ML_sw" != "" {
				local wt [iw=$ML_sw]
			}
			svygen post double `wgt2' `wt' if $ML_samp, ///
				`posts' `postw'
			sum `wgt2', mean
			global ML_pop `r(sum)'
			quietly gen double `wgt' = `wgt2'
			quietly replace `wgt' = 0 if $ML_wo == 0
			global ML_swa `wgt2'
			global ML_w `wgt'
		}
	}

/* Check if sufficient space for final evaluation program */

	if "$ML_evalf"!="" {
		$ML_evalf -1
	}

/* Do optimization. */

	if `iterate' {
		if $ML_trace {
			di
		}
		if "`search'"=="on" | "`search'"=="quietly" ///
		 | "`search'"=="" | "`search'" == "norescale" {
			if "`search'"=="quietly" | $ML_trace == 0 {
				local sopts "nolog"
			}
			else if $ML_trace > 1 {
				local sopts "trace"
			}
			if "`search'" == "norescale" {
				local sopts "`sopts' norescale"
			}

			ml_searc `bounds', repeat(`repeat') `sopts' `maxfeas'
		}
		else if "`search'"!="off" {
			di in red "search(`search') invalid"
			exit 198
		}
		$ML_opt, `options' `warning' /* call optimizer */
	}
	else Iter0, `warning' `vce'

/* Call optional final evaluation program. */


	if "$ML_evalf"!="" {
		$ML_evalf 2
		if $ML_C {
			mat $ML_V = $ML_CT'*$ML_V*$ML_CT
		}
		if "$ML_noinf" == "" {
			capture mat $ML_V = syminv($ML_V)
			if _rc {
				di in red "Hessian has become unstable or " /*
					*/ "asymmetric (M1)"
				exit _rc
			}
		}
		if $ML_C {
			mat $ML_V = $ML_CT*$ML_V*$ML_CT'
		}
	}
/* Compute scores. */

	if "`score'"!="" {
		$ML_score `score'
	}

	if "$ML_vce2" == "OPG" & "$ML_meth" != "rdu0" {
		qui count if $ML_samp
		mat $ML_V = I($ML_k)
		version 11:_cpmatnm $ML_b, square($ML_V)
		if "$ML_wtyp" == "" {
			local wtype fw
		}
		else	local wtype $ML_wtyp
		if "$ML_grp" != "" {
			local cluster cluster($ML_grp)
		}
		qui _robust2 `score' [`wtype'=$ML_w] if $ML_samp,	///
			variance($ML_V) minus(0) `cluster'
		if $ML_C {
			mat $ML_V = $ML_CT'*$ML_V*$ML_CT
		}
		if "$ML_noinf" == "" {
			capture mat $ML_V = syminv($ML_V)
			if _rc {
				di in red "Hessian has become unstable or " /*
					*/ "asymmetric (M1)"
				exit _rc
			}
		}
		if $ML_C {
			mat $ML_V = $ML_CT*$ML_V*$ML_CT'
		}
	}
	else	version 11:_cpmatnm $ML_b, square($ML_V)

	if $ML_yn==1 {
		local depname depname($ML_y)
	}

	tempvar esvar
	qui gen byte `esvar' = $ML_samp
	est post $ML_b $ML_V $ML_CC, `depname' obs($ML_N) esample(`esvar')
	est scalar rc = max($ML_rc,0)
	est scalar ll = scalar($ML_f)
	if `iterate' | "`warning'" == "" {
		est scalar converged = $ML_conv
	}
	else	est scalar converged = 1

	est local wtype `"$ML_wtyp"'
	est local wexp  `"$ML_wexp"'

	if "$ML_tnqk" != "" {
		version 8: ereturn local tech_steps `"$ML_tnqk"'
	}
	version 8: ereturn local technique `"$ML_tnql"'
	est hidden local crittype `"$ML_crtyp"'

	tempname v1	iv1		/* vce of the model */
	mat `v1' = e(V)
	mat `iv1' = syminv(`v1')
	global ML_rank = colsof(`v1') - diag0cnt(`iv1')
	est scalar rank = $ML_rank 		/* return rank(V) */	

	if "$ML_ll_0"!="" {
		if "$ML_rank0" != "" {			/* continue option */
			est scalar rank0 = $ML_rank0
			est scalar df_m = $ML_rank - $ML_rank0
		} 
		else	est scalar df_m = $ML_rank - $ML_k0
		est scalar ll_0 = $ML_ll_0
		est scalar chi2 = 2*(e(ll)-e(ll_0))
		est scalar p = chiprob(e(df_m), e(chi2))
	}
	est local chi2type "LR"
	est scalar k    = $ML_k
	est scalar k_eq = $ML_n
	est scalar k_dv = $ML_yn


	est local user		`"$ML_ouser"'
	est local ml_method	`"$ML_meth"'
	if `"$ML_meth"' == "lf" {
		tempname ml_tn ml_hn
		matrix `ml_tn' = J(1,$ML_n,0)
		matrix `ml_hn' = J(1,$ML_n,0)
		forval i = 1/$ML_n {
			matrix `ml_tn'[1,`i'] = ${ML_tn`i'}
			matrix `ml_hn'[1,`i'] = ${ML_hn`i'}
		}
		est matrix ml_tn `ml_tn'
		est matrix ml_hn `ml_hn'
	}
	else if inlist(`"$ML_meth"',"d0","d1debug","d2debug") {
		est matrix ml_d0_s = ML_d0_S
	}
	est local cnt0 $ML_cnt0
	est local cnt1 $ML_cnt1
	est local cnt2 $ML_cnt2
	est local cnt_ $ML_cnt_
	${ML_svsc}est local scorevars `score'

	est local depvar $ML_y
	est matrix ilog ML_log
	est matrix gradient $ML_g
	est scalar ic = $ML_ic-1 /* starts at 1 */
	est scalar N = $ML_N
	est local title `"$ML_title"'
	est local opt "ml"
	local i 1
	while `i' <= $ML_n {
		if "${ML_xo`i'}" != "" {
			est local offset`i' `"${ML_xo`i'}"'
		}
		else if "${ML_xe`i'}" != "" {
			est local offset`i' `"ln(${ML_xe`i'})"'
		}
		local i = `i'+1
	}


	if "`clear'"!="" {
		mat $ML_b = get(_b)
		mat $ML_V = get(VCE)
	}

	if "$ML_vce"=="robust" {
		CheckSco `score'
		if r(okay) {
			if "$ML_svy" != "" {
				tempname Vsrs ev
				matrix `ev' = e(V)
				local svyopt zeroweight vsrs(`Vsrs') v(`ev')
				if "$ML_str" != "" {
					local svyopt `svyopt' strata($ML_str)
				}
				if "$ML_fpc" != "" {
					local svyopt `svyopt' fpc($ML_fpc)
				}
				if "$ML_subv" != "" {
					local svyopt `svyopt' subpop($ML_subv)
					local svyopt `svyopt' $ML_srsp
				}
				/* Replace missing scores with zeros. */
				foreach sc of local score {
					capture replace `sc' = 0 if `sc' >= .
					if !_rc {
						local sclist `sclist' `sc'
					}
				}
			}
			if "$ML_clust" != "" {
				local cluster cluster($ML_clust)
				if "$ML_svy" == "" {
					local vce cluster
				}
			}
			else if "$ML_grp" != "" {
				local cluster clust($ML_grp)
			}
			if "${ML_wtyp}" != "" {
				if "$ML_svy" != "" {
					local w [iw=$ML_sw]
				}
				else {
					local w [$ML_wtyp=$ML_w]
				}
			}
			if "$ML_vscr" != "" {
				// trick 4 rdu0: scores are complete, _robust2
				// doesn't have to expand using chain rule
				tempname b
				mat `b' = e(b)
				local fullnms : colfullnames `b'
				local i 1
				while `i' <= $ML_k {
					local newnams `newnams' eq`i':_cons
					local i = `i' + 1
				}
				version 11: mat colnames `b' = `newnams'
				est repost _b=`b', rename
			}

			if "$ML_svy2" == "" {
				`vv' _robust2 `score' `w' if $ML_samp,	///
					`cluster' `svyopt'
				if "`cluster'" != "" {
					global ML_vce2 
				}
			}
			else {
				_robust2 `score' if $ML_samp, svy `svyopt'
				_r2e
				est scalar N_psu = e(N_clust)
				if !missing(e(sum_wsub)) {
					est scalar N_subpop = e(sum_wsub)
				}
				est local prefix svy
				est local brrweight
				est local jkrweight
				est local sum_wsub
				est local sum_w
				local vce linearized
				est local vcetype Linearized
			}

			if "$ML_svy" != "" {
				est repost V = `ev'
				/* clear non-svy results */
				est local clustvar
				est local N_clust 
				est local rc
				est local ll
				est local rank
				est local chi2type
				est local k
				est local k_dv
				est local user
				est local cnt0
				est local cnt1
				est local cnt2
				est local cnt_
				est local ilog
				/* (re)post svy results */
				est local depvar $ML_y
				if "$ML_sw" != "" {
					est local wtype $ML_swty
					est local wexp "= $ML_sw"
				}
				if "$ML_svy2" == "" {
					est local vcetype
					est local strata $ML_str
					est local psu $ML_clust
					est local fpc $ML_fpc
				}
				else {
					est local estat_cmd svy_estat
				}
				est local subpop $ML_subp
				est local adjust $ML_sadj
				est local svyml svyml

				/* population size */
				if "$ML_pop" == "" {
					est scalar N_pop = r(sum_w)
				}
				else	est scalar N_pop = $ML_pop
				/* subpopulation size */
				if "`r(N_sub)'" != "" & "`r(N_sub)'" != "." {
					/* # subpop. obs */
					est scalar N_sub = r(N_sub)
					/* subpop. size  */
					est scalar N_subpop = r(sum_wsub)
				}
				if "$ML_svy2" == "" {
					est scalar N = $ML_N
					/* number of strata */
					est scalar N_strata = r(N_strata)
					/* number of PSUs */
					est scalar N_psu = r(N_clust)
					est scalar df_r = e(N_psu)-e(N_strata)
				}

				if "`e(poststrata)'" == "" {
					/* needs e(V) posted and e(fpc) */
					_svy_mkvsrs `Vsrs' $ML_srsp

					/* needs e(V), e(V_srs) [e(V_srswr)] */
					_svy_mkdeff
				}

				version 9.1: ///
				ereturn scalar k_eq_model = $ML_wald
				_prefix_model_test, svy $ML_sadj
				/* _prefix_model did the wald test already */
				global ML_wald
			}

			// trick 4 rdu0: restore colfullnames
			if "$ML_vscr" != "" {
				mat `b' = e(b)
				version 11: mat colnames `b' = `fullnms'
				est repost _b=`b', rename
			}
		}
		else {
			tempname badV
			mat `badV' = J($ML_k,$ML_k,0)
			est repost VCE=`badV'
			est scalar rc = 504
		}
		if "$ML_svy" == "" {
			est scalar df_m = .
			est scalar chi2 = .
			est scalar p = .
			est local vcetype2 $ML_vce2
		}
		if "`vce'" == "" {
			est local vce robust
		}
		else	est local vce `vce'

		if "$ML_svy" == "" {
			// robust and/or clustering could reduce the rank of
			// e(V), so recompute it
			mat `v1' = e(V)
			mat `iv1' = syminv(`v1')
			global ML_rank = colsof(`v1') - diag0cnt(`iv1')
			est scalar rank = $ML_rank	/* return rank(V) */	
		}
	}
	else {
		if "$ML_vce" != "" {
			est local vce $ML_vce
		}
		else if "$ML_vce2" != "" {
			est local vce = lower("$ML_vce2")
		}
		else	est local vce oim
		est local vcetype $ML_vce2
	}
	if "$ML_wald" != "" {
		local i 1
		local temp 0
		version 9.1: ereturn scalar k_eq_model = $ML_wald
		_prefix_model_test, min
		est local chi2type "Wald"
	}
	if "$ML_waldt" != "" {
		version 9.1: ereturn scalar k_eq_model = abs($ML_waldt)
	}

	PostDiparms

	est local predict "ml_p"
	est local cmd "ml"

	if "`clear'"=="" & "$ML_pres" == "" {
		ml clear
	}
	global ML_setes "yes"

	if "`output'"=="" {
		`vv' ml_mlout, `header' `eform' level(`level') `nocnsre'
		exit `e(rc)'
	}
end

program PostDiparms, eclass
	version 9
	if ("$ML_diparms" == "") exit

	forval k = 1/$ML_diparms {
		ereturn hidden local diparm`k' `"${ML_diparm`k'}"'
	}
end

program define Iter0
	syntax [, noWARNing noVCE ]

	if $ML_trace > 1 | ("`vce'"=="" & $ML_dider) {
		di _n in smcl in gr "{hline 78}" _n "Iteration 0:"
	}
	if $ML_trace == 2 | $ML_trace == 4 {
		di in gr "Coefficient vector:"
		mat list $ML_b, noheader noblank format(%9.0g)
		di /* blank line */
	}
	if "`vce'"=="" {
		capture noisily $ML_eval 2
		if _rc == 1 {
			exit 1
		}
		if _rc {
			di in red "method $ML_meth may not " /*
			*/ "support iterate(0)"
			exit 198
		}
	}
	else $ML_eval 0

	global ML_ic 1 /* this is how ml_log counts */

	if scalar($ML_f)>=. {
		di in red "initial values infeasible"
		exit 1400
	}
	if $ML_trace > 1 | ("`vce'"=="" & $ML_dider) {
		local col = 66-length("$ML_crtyp")
		di in gr _col(`col') "$ML_crtyp = " in ye %10.0g /*
		*/ scalar($ML_f)
	}
	else if $ML_trace == 1 {
		di in gr "Iteration 0:" _col(16) "$ML_crtyp = " /*
		*/ in ye %10.0g scalar($ML_f)
	}
	if "`vce'"=="" & ($ML_trace>2 | $ML_dider==1 | $ML_dider==3) {
		tempname lengrad
		mat `lengrad' = $ML_g * $ML_g'

		if $ML_dider==1 | $ML_dider==3 {
			version 11:_cpmatnm $ML_b, vec($ML_g)
			di in gr "Gradient vector (length =" /*
			*/ in ye %9.0g sqrt(`lengrad'[1,1])  /*
			*/ in gr "):"
			mat list $ML_g, noheader noblank format(%9.0g)
		}
		else di in gr "Length of gradient vector =" /*
		*/ in ye %9.0g sqrt(`lengrad'[1,1])

		local newline "_n"
	}
	if "`vce'"=="" & $ML_dider > 1 {
		version 11:_cpmatnm $ML_b, square($ML_V)
		di `newline' in gr "Negative Hessian:"
		mat list $ML_V, noheader noblank format(%9.0g)
	}
	if $ML_trace > 1 | ("`vce'"=="" & $ML_dider) {
		di in smcl in gr "{hline 78}"
	}
	if "`warning'"=="" {
		di in blu "convergence not achieved"
	}
	if "`vce'"=="" {
		capture mat $ML_V = syminv($ML_V)
		if _rc {
			di in red "Hessian has become unstable or "	/*
				*/ "asymmetric (M2)"
			exit _rc
		}
	}
	else	mat $ML_V = J($ML_k,$ML_k,0)
end

program define SetTrace
	syntax [, noLOg TRace GRADient HESSian SHOWSTEP ]

	if "`showste'"!="" {
		if "`trace'"!="" {
			global ML_trace 4  /* = showstep trace */
		}
		else    global ML_trace 3  /* = showstep */
	}
	else if "`trace'"!="" {
		global ML_trace 2
	}
	else if "`log'"!="" {
		global ML_trace 0  /* = -nolog-	*/
	}
	else	global ML_trace 1  /* = -log-	*/

	if $ML_trace {
		global ML_dider = ("`gradien'"!="") + 2*("`hessian'"!="")
					/*
					   ML_dider == 0 => <nothing>
					   ML_dider == 1 => gradient
					   ML_dider == 2 => hessian
					   ML_dider == 3 => gradient and hessian
					*/
		if $ML_trace == 4 { /* display gradient */
			if $ML_dider == 0 {
				global ML_dider 1
			}
			if $ML_dider == 2 {
				global ML_dider 3
			}
		}
	}
	else	global ML_dider 0	/* -nolog- overrides -gradient- and
					   -hessian-
					*/
end

program define CheckSco /* scorevars */, rclass
	local i 1
	if "$ML_vscr" == "" {
		local numscr $ML_n
	}
	else	local numscr $ML_k
	while `i' <= `numscr' {
		capture assert ``i''<. if $ML_samp
		if _rc {
			return scalar okay = 0
			exit
		}
		local i = `i' + 1
	}
	return scalar okay = 1
end

exit
