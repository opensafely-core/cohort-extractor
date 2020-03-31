*! version 7.5.0  30jul2018
program define weibull_s, eclass byable(recall)
	version 6
	if replay() {
		if _by() { error 190 }
		Di_Weib `0'
		error `e(rc)'
		exit
	}

/* Parse. */

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	if _caller() < 6 { local aweight "aweight" }

	syntax varlist(fv numeric) [if] [in]                   /*
	*/ [fweight pweight `aweight' iweight]                 /*
	*/ [, noCOEF CLuster(varname) Dead(varname numeric)    /*
	*/ FROM(string) HAzard noHEADer HR ITERate(integer -1) /*
	*/ Level(cilevel) NOLOg LOg Robust SCore(string)  /*
	*/ T0(varname numeric) TR moptobj(passthru) * ]
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

					/* Cannot have offset() in
					   accelerated-time metric,
					   so we do not have it at all.
					*/
	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'	
	
	if `iterate' == -1 { local iterate /* erase macro */ }
	else local iterate "iterate(`iterate')"

/* Check syntax, etc. */

	if "`hazard'"!="" {
		if "`tr'"!="" {
			di in red "tr invalid with hazard option"
			exit 198
		}
	}
	else if "`hr'"!="" {
		local hazard "hazard"
	}
	if "`score'"!="" {
		local nsc : word count `score'
		if `nsc'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local nsc 2
		}
		if `nsc' != 2 {
			di in red "must specify two variables for score()"
			exit 198
		}
		confirm new var `score'
		tempvar score1 score2
		local scopt "score(`score1' `score2')"
	}
	if "`cluster'"!="" {
		local clopt "cluster(`cluster')"
	}
	if `"`weight'"' == "pweight" | "`robust'`cluster'" != "" {
		local robust robust
	}

/* Mark sample. */

	marksample touse
	markout `touse' `t0' `dead'
	markout `touse' `cluster', strok

/* Check number of observations. */

	qui count if `touse'
	local nobs = r(N)
	if `nobs' < 2 {
		if r(N) == 0 { error 2000 }
		error 2001
	}
	if "`weight'"=="fweight" {
		qui summarize `touse' [fweight`exp'] if `touse', meanonly
		local nobs = r(sum_w)
	}

	else if "`weight'"=="fweight" {
		capture assert 0 <`exp' if `touse'
		if _rc {
			error 402
		}
	}
	
/* Process t, t0, and dead. */

	tempvar lnt
	tempname lntmean nfail b0

	tokenize "`varlist'"
	local t "`1'"
	mac shift
	local rhs "`*'"

	capture assert `t' > 0 if `touse'
	if _rc {
		di in red "`t' <= 0 in some observations"
		exit 498
	}
	
	/* check if constraint on constant and/or p */	
	local chascns 0
	local phascns 0
	if "`cns'" != "" {
		tempname bc bp bcns
		local rhstmp `rhs'
		if `fvops' {
			fvexpand `rhstmp'
			local rhstmp = r(varlist)
		}
		local k : word count `rhstmp'
		local k = `k' + 2
		mat `bc' = J(1,`k',0)
		forval i = 1/`=`k'-1' {
			local eq `eq' `t'
		}	
		if _caller() < 15 {
			mat coleq `bc' = `eq' ln_p
			mat colna `bc' = `rhstmp' _cons _cons
		}
		else {
			mat coleq `bc' = `eq' /
			mat colna `bc' = `rhstmp' _cons ln_p
		}
		est post `bc' 
		
		// get valid constraints
		foreach c of local cns {
			cap makecns `c'
			local rc = _rc
			if !_rc { local cnsvld `cnsvld' `c' }
		}
		local cns `cnsvld'
		local ncns : word count `cns'
		
		// check if cns on _cons
		makecns `cns', r
		if r(k) > 0 & !_rc {
			mat `bcns' = get(Cns)
			local rows = rowsof(`bcns')
			mat `bc' = diag(`bcns'[1..`rows',`k'-1])
			local chascns = trace(`bc')
			mat `bp' = diag(`bcns'[1..`rows',`k'])
			local phascns = trace(`bp')
		}
		else {
			local chascns 0
			local phascns 0
		}
	}
	
	quietly {
		gen double `lnt' = ln(`t') if `touse'
		if "`weight'"!="" { local wexp "[aw`exp']" }
		if `chascns' < 1 { 
			summarize `lnt' `wexp', meanonly
			scalar `lntmean' = r(mean)
			replace `lnt' = `lnt' - `lntmean' 
		}
		label var `lnt' "`t'"
	}

	if "`t0'"!="" {
		capture assert `t0' == 0 if `touse'
		if _rc {		/* This is important since WeibCons
					   cannot handle`lnt0' all missing.
					*/
			capture assert `t0' >= 0 if `touse'
			if _rc {
				di in red "`t0' < 0 in some observations"
				exit 498
			}
			capture assert `t0' < `t' if `touse'
			if _rc {
				di in red "`t0' >= `t' in some observations"
				exit 498
			}
			tempvar lnt0
			qui gen double `lnt0' = ln(`t0') if `touse'
			if `chascns' < 1 {
				qui replace `lnt0' = `lnt0' - `lntmean' if `touse'
			}		  
		}
	}
	else local t0 0 /* just for e(t0) */

	if "`lnt0'"=="" {
		local proglf "weib_lf0" /* entry times all 0 */
	}
	else	local proglf "weib_lf"

	if "`dead'"!="" {
		local sdead "`dead'"
		capture assert `dead'==0 | `dead'==1 if `touse'
		if _rc {
			tempvar mydead
			qui gen byte `mydead' = (`dead'!=0) if `touse'
			local dead "`mydead'"
		}
	}
	else {
		local sdead 1
		local dead "`touse'"
	}

/* Check that the weighted sum of failures is positive. */

	qui summarize `dead' `wexp' if `touse', meanonly
	scalar `nfail' = r(sum)
	if `nfail' <= 0 {
		if `nfail' == 0 {
			di in red "no failures"
			exit 498
		}
		di in red "weighted sum of failures is negative"
		exit 498
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
	}
	else	local rmcoll _rmcoll
	`rmcoll' `rhs' [`weight'`exp'] if `touse', `coll'
	local rhs "`r(varlist)'"

/* Set macros for passing to `proglf' likelihood routine. */

	global S_ML_lnt "`lnt'"
	global S_ML_d   "`dead'"
	global S_ML_lt0 "`lnt0'"

/* Estimate constant-only model. */

	local nocomod 0
	if "`cns'" != "" {
		if 	(`chascns' >= 1 & `phascns' >= 1 & `ncns' == 2) {
			local nocomod 1
		}
	}

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if ("`from'"=="" & `nocomod' < 1) {
		if (`chascns' < 1 & `phascns' < 1) {
			capture noisily {
				WeibCons `lnt' `dead' `lnt0' [`weight'`exp'] /*
				*/ if `touse', `log' `mlopts' nfail(`nfail') /*
				*/ `robust'

				mat `b0' = (r(_cons), r(lnp))
				if _caller() < 15 {
					mat colnames `b0' = `t':_cons ln_p:_cons
				}
				else {
					mat colnames `b0' = `t':_cons /ln_p
				}
				local initopt "init(`b0')"
				local lf0 "lf0(2 `r(ll)')"
			}
			local rc = _rc
		}
		else { local rc 0 }
		if `rc' == 0 { local convcnt 1 }
		if (`chascns' >= 1 | `phascns' >= 1 | `rc' > 0) {
			if "`log'"=="" {
				if `rc' > 0 {
di _n in gr "Attempting constant-only model again:"
				}
				else {
					local searchq search(quietly)
di _n in gr "Fitting constant-only model:"		
				}
			}
			#delimit ;
			`vv' 
			ml model `mm' `proglf' (`t': `t'=) /ln_p
				[`weight'`exp'] if `touse',
				`mlopts' `iterate' `mllog' noout missing
				collinear nopreserve obs(`nobs') maximize 
				`robust' nocnsnotes `negh' `searchq' ;
			#delimit cr
			local convcnt = e(converged) 
			if `convcnt' > 0 { local contin "continue" }
		}
		if `convcnt' == 0 {
			mat `b0' = e(b)
			if "`from'" == "" {
				local initopt "init(`b0', skip)"
			}
		}
		if "`rhs'"=="" & `convcnt' == 1 {
			local iterate "iterate(0)" 
			local mlopts "`mlopts' nowarning"
		}
	}

/* Adjust -from()- constant values and, if necessary, remetric to
   accelerated time.
*/
	if "`from'" != "" {
		if `chascns' < 1 { 
			`vv' ///
			AdjFrom `b0' `lntmean' `t' "`hazard'" `from'
			local initopt "init(`b0',`s(copy)' `s(skip)')"
		}
		else { local initopt "init(`from')"	}
	}

/* Estimate full model. */

	if "`log'"=="" { di _n in gr "Fitting full model:" }
	
	global GLIST : all globals "EREG*"
	
	#delimit ;
	`vv'
	ml model `mm' `proglf' (`t': `t'=`rhs') /ln_p
		[`weight'`exp'] if `touse',
		`initopt' `mlopts' `iterate' `robust' `clopt'
		`scopt' `lf0' `contin' `mllog'
		noout missing collinear nopreserve obs(`nobs')
		maximize search(off) 
		diparm(ln_p, exp label(p))
		diparm(ln_p, f(exp(-@)) d(exp(-@)) label("1/p"))
		`negh' `moptobj' ;
	#delimit cr
	est local cmd
	global S_E_cmd

/* Adjust _cons, scores, and, if necessary, remetric into accelerated time. */

	if "`hazard'"=="" {
		Remetric `lntmean' `score1' `score2'
		if _caller() < 15 {
			est local title2 "accelerated failure-time form"
		}
	}
	else {
		if `chascns' < 1 {
			AdjCons `lntmean' `score1' `score2'	
		}
		if _caller() < 15 {
			est local title2 "log relative-hazard form"
		} 
	}

/* Make scores real by renaming tempvars if this option was specified. */

	if "`score'"!="" {
		local sc1 : word 1 of `score'
		local sc2 : word 2 of `score'
		rename `score1' `sc1'
		rename `score2' `sc2'
		est local scorevars `score'
	}

/* Set saved results. */

	est local t0 "`t0'"
	est scalar aux_p = exp(_b[/ln_p])
	est local stcurve="stcurve"

	if "`hazard'"=="" {
		est local frm2 "time"
	}
	else	est local frm2 "hazard"

	est local dead `sdead'

	if (1) /* _caller() < 6 */ { /* double save */
		global S_E_t0 `e(t0)'
		global S_E_chi2 = e(chi2)
		global S_E_mdf = e(df_m)
		global S_E_frm2 "`e(frm2)'"

		global S_E_ll = e(ll)
		global S_E_nobs = e(N)
		global S_E_depv `e(depvar)'
		global S_E_tdf .

		global S_E_cmd weibull
	}

	cap est hidden scalar converged_cons = `convcnt'
	est local predict weibul_p
	est scalar k_aux = 1
	est local cmd weibull

/* Display output. */

	if "`coef'" == "" {
		Di_Weib, level(`level') `header' `hr' `tr' `diopts'
		error `e(rc)'
	}
end

program define Di_Weib /* [, level(cilevel) noHEADer HR TR] */
	if "`e(frm2)'"=="hazard" {
		local options "HR"
	}
	else    local options "TR"

	syntax [, Level(cilevel) noHEADer `options' *]

	_get_diopts diopts, `options'
	if "`hr'"!="" {
		local eform "eform(Haz. Ratio)"
	}
	else if "`tr'"!="" {
		local eform "eform(Time Ratio)"
	}
	if "`header'"=="" {
		if `"`e(frm2)'"'=="time" {
			local metric "AFT"
		}
		else local metric "PH"

	di _n in gr "Weibull `metric' regression -- entry time `e(t0)'" _c
	}
	version 9: ///
	ml di, `header' `eform' level(`level') title(`e(title2)') `diopts'
end

program define WeibCons, rclass
/* Syntax:
                 lnt dead [lnt0] [weight] if `touse', nfail() [...]

   Assumptions:
   		 lnt  <. for all obs
		 lnt0 <. for at least one obs
*/
	local itmax 20  /* maximum allowed number of iterations */

	syntax varlist(min=2 max=3) [fw pw aw iw/] if/ , NFAIL(string) /*
	*/ [ noLOg TRace DETail LTOLerance(real 1e-7) OFFset(string) /*
	*/ robust * ]

	if `"`robust'"' == "" {
		local crtype "log likelihood"
	}
	else	local crtype "log pseudolikelihood"

	local touse "`if'"
	tokenize "`varlist'"
	args lnt d lnt0

	if `ltolera' < 0 {
		di in red "ltolerance(`ltolera') must be >= 0"
		exit 198
	}

	if "`trace'"=="" { local tr "*" }
	else {
		tempname coef
		mat `coef' = (0,0)
		local eqname : variable label `lnt'
		if _caller() < 15 {
			mat colnames `coef' = `eqname':_cons ln_p:_cons
		}
		else {
			mat colnames `coef' = `eqname':_cons /ln_p
		}
	}
	if "`detail'"=="" { local det "*" }
	if "`trace'`detail'"=="" { local trdet "*" }
	if "`log'"=="" {
		di _n in gr "Fitting constant-only model:" _n
	}
	if "`log'`trace'`detail'"!="" { local log "*" }

	if "`exp'"!="" { local wt "(`exp')*" }

/* Compute fixed terms. */

	tempname dlnt lnp step ll llold

	quietly {
		summarize `lnt' [aw=`wt'`d'] if `touse', meanonly
		scalar `dlnt' = r(sum)

		if "`offset'"!="" {
			tempname doff
			summarize `offset' [aw=`wt'`d'] if `touse', meanonly
			scalar `doff' = r(sum)
			local doff   "+`doff'"
			local offset "+`offset'"
		}
	}

/* Do Newton-Raphson iterations to get ln(p). */

	scalar `ll' = 0
	scalar `lnp' = 0
	scalar `step' = 0
	local conv 0
	local i 0
	while !`conv' & `i' <= `itmax' {
		scalar `llold' = `ll'
		scalar `lnp' = `lnp' + `step'

		Cal_f_p `lnp' `touse' `lnt' "`lnt0'" "`wt'" "`offset'"

		scalar `ll' = `nfail'*(ln(`nfail'/r(tp))+`lnp'-1) /*
		*/            + exp(`lnp')*`dlnt' `doff'

		scalar `step' = (`dlnt'/`nfail' - r(df))/r(ddf)

		`log' di in gr "Iteration `i':   `crtype' = " /*
		*/ in ye %10.0g `ll'
		`trdet' di _n in gr in smcl "{hline 13}{c +}{hline 64}" _n /*
		*/ "Iteration `i':"
		`tr' di in gr "Coefficient vector:"
		`tr' mat `coef'[1,1] = ln(`nfail'/r(tp))
		`tr' mat `coef'[1,2] = `lnp'
		`tr' mat list `coef', noheader noblank format(%9.0g)
		`trdet' di in gr _col(52) "`crtype' = " /*
		*/ in ye %10.0g `ll'
		`det' di in gr "Gradient w.r.t. ln_p = "  in ye %9.0g /*
		*/ `dlnt'/`nfail' - r(df)
		`det' di in gr "Step for ln_p        = "   in ye %9.0g `step'

		local conv = ( reldif(`ll',`llold') <= `ltolera' /*
		*/ | abs(`step') < 1e-15 ) & `i' >= 2

		local i = `i' + 1
	}

	`trdet' di _n in gr in smcl "{hline 13}{c +}{hline 64" _n

	if !`conv' { error 430 }

	return scalar lnp = `lnp'
	return scalar _cons = ln(`nfail'/r(tp))
	return scalar ll = `ll'
end

program define Cal_f_p, rclass
	args lnp touse lnt lnt0 wt offset

	tempname p
	scalar `p' = exp(`lnp')

	qui summarize `lnt' [aw=`wt'exp(`p'*`lnt'`offset')] if `touse'

	if "`lnt0'"=="" {
		return scalar df  = r(mean) - 1/`p'
		return scalar ddf = `p'*((r(N)-1)/r(N))*r(Var) + 1/`p'
		return scalar tp  = r(sum_w)
		exit
	}

	tempname mean1 ss1 ss2 sum1 sumw1 sumw12
	scalar `mean1' = r(mean)
	scalar `sum1'  = r(sum)
	scalar `ss1'   = ((r(N)-1)/r(N))*r(sum_w)*r(Var)
	scalar `sumw1' = r(sum_w)

	qui summarize `lnt0' [aw=`wt'exp(`p'*`lnt0'`offset')] if `touse'
	scalar `ss2'    = ((r(N)-1)/r(N))*r(sum_w)*r(Var)
	scalar `sumw12' = `sumw1' - r(sum_w)

	return scalar df  = (`sum1' - r(sum))/`sumw12' - 1/`p'
	return scalar ddf = `p'*(`ss1' -`ss2' /*
	*/                  -`sumw1'*r(sum_w)*(`mean1'-r(mean))^2/`sumw12') /*
	*/                  /`sumw12' + 1/`p'
	return scalar tp  = `sumw12'
end

program define Remetric, eclass
	args lntmean score1 score2
	tempname b V lnp s J A

	mat `b' = get(_b)
	mat `V' = get(VCE)

	local dim  = colsof(`b')
	mat `lnp' = `b'[1,`dim'..`dim']
	local icons = `dim' - 1
	mat `b' = `b'[1,1..`icons']

	if "`score1'"!="" {
		quietly {
			tempvar xb
			tempname p
			mat score double `xb' = `b' if e(sample)
			scalar `p' = exp(_b[/ln_p])
			replace `score2' = `xb'*`score1' + `score2'
			replace `score1' = -`p'*`score1'
		}
	}

	scalar `s' = -exp(-_b[/ln_p])
	mat `b' = `s'*`b'
	mat `J' = (`s'*I(`icons'), -`b'') \ /*
	*/        (J(1,`icons',0), 1)
	mat `V' = `J'*`V'*`J''

	mat `b'[1,`icons'] = `b'[1,`icons'] + `lntmean'
	mat `b' = (`b' , `lnp')
	est repost _b=`b' VCE=`V'

	if "`e(chi2type)'"=="Wald" {
		mat `b' = get(_b)
		local dim = `dim' - 2
		if `dim' >= 1 {
			mat `b' = `b'[1,1..`dim']
			local rhs : colnames(`b')

			est scalar df_m = .
			est scalar chi2 = .
			est scalar p = .

			capture test `rhs', min

			est scalar df_m = r(df)
			est scalar chi2 = r(chi2)
			est scalar p = r(p)
		}
	}
end

program define AdjCons, eclass
	args lntmean score1 score2
	tempname b V p J
	mat `b' = get(_b)
	mat `V' = get(VCE)
	local dim = colsof(`b')
	local icons = `dim' - 1
	scalar `p' = exp(_b[/ln_p])
	mat `b'[1,`icons'] = `b'[1,`icons'] - `p'*`lntmean'

	mat `J' = I(`dim')
	mat `J'[`icons',`dim'] = - `p'*`lntmean'
	mat `V' = `J'*`V'*`J''
	est repost _b=`b' VCE=`V'

	if "`score1'"!="" {
		qui replace `score2' = `p'*`lntmean'*`score1' + `score2'
	}
end

program define AdjFrom
	local vv : di "version " string(_caller()) ":"
	version 6
	args b0 lntmean t hazard
	macro shift 4

	`vv' ///
	_mkvec `b0', from(`*')
	local dim `s(k)'
	if "`s(copy)'"=="copy" {
		local ilnp `dim'
		local icons = cond(`dim'>1,`dim'-1,.)
	}
	else {
		local ilnp = colnumb(`b0',"/ln_p")
		local icons = colnumb(`b0',"`t':_cons")
		if `icons'>=. {
			local icons = colnumb(`b0',"_:_cons")
		}
	}
	if `ilnp'>=. {
		di in red "must specify a value of " /*
		*/ "/ln_p in from()"
		exit 498
	}
	if "`hazard'"!="" {
		if `icons'<. {
			mat `b0'[1,`icons'] = `b0'[1,`icons'] /*
			*/ + exp(`b0'[1,`ilnp'])*`lntmean'
		}
		exit
	}

	tempname lnp s
	mat `lnp' = `b0'[1,`ilnp'..`ilnp']

	if `ilnp' > 1 {
		local i1 = `ilnp' - 1
		tempname b1
		mat `b1' = `b0'[1,1..`i1']
	}
	if `ilnp' < `dim' {
		local i1 = `ilnp' + 1
		tempname b2
		mat `b2' = `b0'[1,`i1'...]
	}
	if "`b1'"!="" & "`b2'"!="" {
		local comma ","
	}

	mat `b0' = (`b1' `comma' `b2')
	if `icons'<. {
		if `icons' > `ilnp' { local icons = `icons' - 1 }

		mat `b0'[1,`icons'] = `b0'[1,`icons'] - `lntmean'
	}
	scalar `s' = -exp(`lnp'[1,1])
	mat `b0' = (`s'*`b0', `lnp')
end
