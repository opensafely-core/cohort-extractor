*! version 3.6.2  15oct2019
program define gnbreg, eclass sort prop(svyb svyj svyr irr ml_score mi bayes)
	_vce_parserun gnbreg, mark(LNAlpha Exposure OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"gnbreg `0'"'
		exit
	}

	version 6, missing
	if _caller() <= 5 {
		gnbreg_5 `0'
		exit
	}
	if replay() {
		if "`e(cmd)'"!="gnbreg" { error 301 }
		Display `0'
		error `e(rc)'
		exit
	}

/* Parse. */
	local cmdline : copy local 0
	local awopt = cond(_caller()<9, "aw", "")
	syntax varlist(numeric fv) [fw `awopt' pw iw] [if] [in] [, IRr /*
	*/ FROM(string) Level(cilevel) OFFset(varname numeric) 		/*
	*/ Exposure(varname numeric) noCONstant Robust CLuster(varname) /*
	*/ SCore(string) NOLOg LOg LNAlpha(varlist numeric fv)		/*
	*/ CRITTYPE(passthru) moptobj(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ":"
	}
	else {
		local vv "version 8.1:"
	}
	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopts `mlopts' `crittype'
	local lrtest nolrtest  /* rgg: I'm leaving in the code for the */
			       /* lrtest for when the dist. becomes known */

/* Check syntax. */

	if "`score'" != "" { 
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local n 2
		}
		confirm new variable `score'
		if `n' != 2 {
			version 7: di in red "option {bf:score()} must contain the names of " /*
			*/ "two new variables"
			exit 198
		}
		local scname1 : word 1 of `score'
		local scname2 : word 2 of `score'
		tempvar scvar1 scvar2
		local scopt "score(`scvar1' `scvar2')"
	}
	if "`offset'"!="" & "`exposur'"!="" {
		version 7: di in red "options {bf:offset()} and {bf:exposure()} may not be specified together"
		exit 198
	}
	if "`constan'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			version 7: di in red "independent variables required with " /*
			*/ "option {bf:noconstant}"
			exit 100
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse

	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
		local clopt cluster(`cluster')
		local robust robust
	}
	if `"`weight'"' == "pweight" {
		local robust robust
	}

	markout `touse' `lnalpha'

/* Process offset/exposure. */

	if "`exposur'"!="" {
		capture assert `exposur' > 0 if `touse'
		if _rc {
			version 7: di in red "option {bf:exposure()} must be greater than zero"
			exit 459
		}
		tempvar offset
		qui gen double `offset' = ln(`exposur')
		local offvar "ln(`exposur')"
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
	_fv_check_depvar `y'

	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}

	summarize `y' `wt' if `touse', meanonly

	if r(N) == 0 { error 2000 }
	if r(N) == 1 { error 2001 }

	if r(min) < 0 {
		version 7: di in red "{bf:`y'} must be greater than or equal to zero"
		exit 459
	}
	if r(min) == r(max) & r(min) == 0 {
		version 7: di in red "{bf:`y'} is zero for all observations"
		exit 498
	}

	tempname mean
	scalar `mean' = r(mean)

/* Check whether `y' is integer-valued. */

	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc {
			di in blu "note: you are responsible for " /*
			*/ "interpretation of non-count dep. variable"
		}
	}

/* Print out aweight message. */

	if "`weight'"=="aweight" {
		di in blu "note: you are responsible for interpretation " /*
		*/ "of analytic weights"
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
	}
	else	local rmcoll _rmcoll
	`rmcoll' `xvars' [`weight'`exp'] if `touse', `constan' `coll'
	local xvars `r(varlist)'

	if "`weight'"=="aweight" {
		`rmcoll' `lnalpha' [iw`exp'] if `touse', `coll'
			/* aweights produce "sum of wgt" message,
			   which should not be repeated
			*/
	}
	else	`rmcoll' `lnalpha' [`weight'`exp'] if `touse', `coll'
	local lnalpha `r(varlist)'

/* Run comparison Poisson model. */
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" { local nohead "*" }

	if "`from'"=="" {
		if "`lrtest'"!="" {
				    /* we do not do comparison LR test,
		                       but we get starting values from
				       poisson, iterate(0)
				    */
			if "`weight'"!="" {
				local wt `"[iw`exp']"'
			}
			`vv' ///
			quietly poisson `y' `xvars' `wt' /*
			*/ if `touse', iterate(0) nodisplay /*
			*/ `offopt' `constan'
		}
		else {
			if "`robust'`cns'`cluster'"!="" | /*
			*/ "`weight'"=="pweight" {
				local lrtest "nolrtest"
			}
			`nohead' di in gr _n "Fitting Poisson model:"

			`vv' ///
			poisson `y' `xvars' [`weight'`exp'] if `touse', /*
			*/ nodisplay `offopt' `constan' `mllog'
		}

		tempname bp
		mat `bp' = e(b)

		if "`lrtest'"=="" {
			tempname llp
			scalar `llp' = e(ll)
			local kp `e(k)'
		}
	}

/* Fit constant-only model. */

	tempname lna

	if "`constan'"=="" & "`from'"=="" {

	/* Get starting values for constant-only model. */

		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ mean(`mean')
			local c = r(_cons)
		}
		else	local c = ln(`mean')

		tempname b0 ll0
		if `c'< . {
			mat `b0' = (`c', 0)
		}
		else	mat `b0' = (0, 0)

		mat colnames `b0' = `y':_cons lnalpha:_cons

		if "`weight'"=="aweight" {
			local wt `"[aw`exp']"'
		}
		else if "`weight'"!="" {
			local wt `"[iw`exp']"'
		}

		`nohead' di in gr _n "Fitting constant-only model:"

		`vv' ///
		ml model lf gnbre_lf (`y': `y'=, `constan' `offopt') /*
		*/ (lnalpha: `lnalpha') if `touse' `wt', /*
		*/ collinear missing max nooutput nopreserve wald(0) /*
		*/ init(`b0') search(off) `mlopts' `mllog' `robust' nocnsnotes

		local cont continue
		mat `b0' = e(b)
		mat `lna' = `b0'[1,"lnalpha:"]
		scalar `ll0' = e(ll)
	}
	else {
		mat `lna' = (0)
		mat colnames `lna' = lnalpha:_cons
	}

	if "`from'"=="" {
		mat `bp' = `bp' , `lna'

		if "`constan'"=="" {
			LLnbreg `y' `bp' [`weight'`exp'] if `touse', `offopt'
			if `ll0' > r(lnf) | r(lnf)>=. {
				local initopt "init(`b0')"
			}
		}
		if "`initopt'"=="" {
			local initopt "init(`bp')"
		}

		if "`constan'"=="" | "`lrtest'"=="" {
			`nohead' di in green _n "Fitting full model:"
		}
	}
	else    local initopt `"init(`from')"'

	`vv' ///
	ml model lf gnbre_lf (`y': `y'=`xvars', `constan' `offopt') /*
	*/ (lnalpha: `lnalpha') if `touse' [`weight'`exp'], collinear /*
	*/ missing max nooutput nopreserve `initopt' search(off) `mlopts' /*
	*/ `mllog' `scopt' `robust' `clopt' `cont' /*
	*/ title(Generalized negative binomial regression) `moptobj'

	est local cmd

        if "`score'"!="" {
		label var `scvar1' "Score index for x*b from gnbreg"
		rename `scvar1' `scname1'
		label var `scvar2' "Score index for lnalpha from gnbreg"
		rename `scvar2' `scname2'
		est local scorevars `score'
	}

	if "`llp'"!="" {
		est local chi2_ct "LR"
		est scalar ll_c = `llp'
		est scalar k_c = `kp'
		if e(ll) < e(ll_c) & reldif(e(ll),e(ll_c)) < 1e-5 {
			est scalar chi2_c = 0
				/* otherwise, let it be negative when
				   it does not converge
				*/
		}
		else	est scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	est scalar r2_p = 1 - e(ll)/e(ll_0)

	est local offset1 "`offvar'"
	est local predict "gnbreg_p"
	version 10: ereturn local cmdline `"gnbreg `cmdline'"'
        est local cmd     "gnbreg"
	
	Display, `irr' level(`level') `diopts'
	error `e(rc)'
end

program define Display, eclass
	syntax [, Level(cilevel) IRr *]
	_get_diopts diopts, `options'
	if "`irr'"!="" {
		est hidden scalar noconstant = 1
		version 9: ///
		ml di, level(`level') eform(IRR) first plus nofootnote ///
			`idopts'

		di in smcl in gr /*
		*/ "     lnalpha {c |}  (type gnbreg to see ln(alpha) " /*
		*/ "coefficient estimates)" _n  /*
		*/ "{hline 13}{c BT}{hline 64}"
		ml_footnote
	}
	else	version 9: ml di, level(`level') nofootnote `diopts'
	
	local cln: colfullnames e(b)
	local consn "`e(depvar)':_cons"	

	if "`e(consonly)'"=="0" & ustrpos(`"`cln'"', "`consn'") & "`irr'"!="" {
		di in smcl "{p 0 6 2}Note: {res:_cons} estimates baseline" ///
			  " incidence rate.{p_end}"
	}

	DispLr  /* Note: This is not a chi-square, chibar-square, or */
		/* anything known to man.*/
	_prefix_footnote
end

program define DispLr
	if "`e(chi2_ct)'"!="LR" { exit }
	if e(chi2_c) < 1e5 {
		local fmt "%9.2f"
	}
	else 	local fmt "%9.2e"
	
	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")
	
        di in gr "LR test of alpha=0: " ///
		in gr "chi2(" in ye e(k)-e(k_c) in gr ") = " in ye "`chi'" ///
		in gr _col(59) "Prob > chi2 = " in ye %6.4f ///
		chiprob(e(k)-e(k_c), e(chi2_c))
end

program define SolveC, rclass /* modified from poisson.ado */
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
		if r(max) > 709 { scalar `shift' =  709 - r(max) }
		else		  scalar `shift' = -709 - r(min)
		local shift "+`shift'"
	}
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program define LLnbreg, rclass
	gettoken y 0 : 0
	gettoken b 0 : 0
	syntax [fw aw pw iw] [if] [, offset(string)]
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempvar z lnalpha m
	tempname m b1 b2
	mat `b1' = `b'[1,"`y':"]
	mat `b2' = `b'[1,"lnalpha:"]

	quietly {
		mat score double `z' = `b1' `if'
		summarize `z' `wt' `if', meanonly
		local nobs `r(N)'

		if "`offset'"!="" {
			local zo "(`z'+`offset')"
		}
		else	local zo "`z'"

		mat score double `lnalpha' = `b2' `if'
		local bound -30
		replace `lnalpha' = `bound' if `lnalpha'<`bound' & `lnalpha'< .

		gen double `m' = exp(-`lnalpha')

		replace `z' = lngamma(`m'+`y') - lngamma(`y'+1) /*
		*/ - lngamma(`m') - `m'*ln1p(exp(`zo'+`lnalpha')) /*
		*/ - `y'*ln(1+exp(-`zo'-`lnalpha')) `if'

		summarize `z' `wt' `if', meanonly
		if r(N) != `nobs' { exit }
		if "`weight'"=="aweight" {
			ret scalar lnf = r(N)*r(mean)
				/* weights not normalized in r(sum) */
		}
		else	ret scalar lnf = r(sum)
	}
end
