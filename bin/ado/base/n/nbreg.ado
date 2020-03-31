*! version 3.10.2  15oct2019
program nbreg, eclass byable(onecall) ///
		prop(irr ml_score svyb svyj svyr swml mi bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun nbreg, mark(Exposure OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"nbreg `0'"'
		exit
	}

	version 6, missing
	local version : di "version " string(_caller()) ":"
	if replay() {
		if "`e(cmd)'" != "nbreg" { error 301 }
		if _by() { error 190 }
		global S_1 = e(chi2_c)
		Display `0'
		error `e(rc)'
		exit
	}

	`version' `BY' Estimate `0'
	version 10: ereturn local cmdline `"nbreg `0'"'
end

program Estimate, eclass byable(recall)
/* Parse. */
	local vvpoi : di "version " string(_caller()) ", missing:"
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	version 6, missing
	local awopt = cond(_caller()<7, "aw", "")
	syntax varlist(numeric fv ts) [fw `awopt' pw iw] [if] [in] [, IRr /*
	*/ FROM(string) Level(cilevel) OFFset(varname numeric ts) /*
	*/ Exposure(varname numeric ts) noCONstant Robust CLuster(varname) /*
	*/ SCore(string) NOLOg LOg noDISPLAY noLRtest Dispersion(string) /*
	*/ CRITTYPE(passthru) VCE(passthru) moptobj(passthru) * ]
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `log' `nolog'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopts `mlopts' `crittype'

	Dispers , `dispers'
	local dispers `s(dispers)'
	if "`dispers'"=="mean" {
		local prog   "nbreg_lf"
		local parm   "alpha"
		local LLprog "LLalpha"
	}
	else {
		local prog   "nbreg_al"
		local parm   "delta"
		local LLprog "LLdelta"
	}
	local title  "Negative binomial regression"
	

/* Check syntax. */

	if `"`score'"'!="" {
		local nword : word count `score'
		if `nword'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2
			local nword 2
		}
		confirm new variable `score'
		if `nword' != 2 {
			version 7: di as err "option {bf:score()} must contain the name of " /*
			*/ "two new variables"
			exit 198
		}
		local scname1 : word 1 of `score'
		local scname2 : word 2 of `score'
		tempvar scvar1 scvar2
		local scopt "score(`scvar1' `scvar2')"
	}
	if "`offset'"!="" & "`exposur'"!="" {
		version 7: di as err "options {bf:offset()} and {bf:exposure()} may not be specified together"
		exit 198
	}
	if "`constan'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			version 7: di as err "independent variables required with " /*
			*/ "option {bf:noconstant}"
			exit 102
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse

        if `"`cluster'"'!="" {
                local clopt cluster(`cluster')
        }
        _vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                [`weight'`exp'], `vce' `clopt' `robust'
        local cluster `r(cluster)'
        local robust `r(robust)'
	local vce `"`r(vceopt)'"'
	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
	}

/* Process offset/exposure. */

	if "`exposur'"!="" {
		capture assert `exposur' > 0 if `touse'
		if _rc {
			version 7: di as err "option {bf:exposure()} must be greater than zero"
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
	tsunab y : `y'
	local yname : subinstr local y "." "_"
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
		version 7: di as err "{bf:`y'} must be greater than or equal to zero"
		exit 459
	}
	if r(min) == r(max) & r(min) == 0 {
		version 7: di as err "{bf:`y'} is zero for all observations"
		exit 498
	}

	tempname mean
	scalar `mean' = r(mean)

/* Check whether `y' is integer-valued. */

	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc {
			di in gr "note: you are responsible for " /*
			*/ "interpretation of non-count dep. variable"
		}
	}

/* Print out aweight message. */

	if "`display'"=="" & "`weight'"=="aweight" {
		di in gr "note: you are responsible for interpretation " /*
		*/ "of analytic weights"
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
	}
	else	local rmcoll _rmcoll
	if "`display'"!="" & "`weight'"=="aweight" {
		`rmcoll' `xvars' [iw`exp'] if `touse', `constan' `coll'
			/* aweights produce "sum of wgt" message,
			   which is not wanted for -nodisplay-
			*/
	}
	else	`rmcoll' `xvars' [`weight'`exp'] if `touse',	///
		`constan' `coll'
	local xvars `r(varlist)'

/* Run comparison Poisson model. */
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" | "`display'"!="" { local nohead "*" }

	if `"`from'"'=="" & "`lrtest'"=="" {
		if "`robust'`cns'`cluster'"!="" | "`weight'"=="pweight" {
			local lrtest "nolrtest"
		}
		`nohead' di in gr _n "Fitting Poisson model:"

		`vvpoi' ///
		poisson `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ nodisplay `offopt' `constan' `mlopts' `robust'

		tempname bp
		mat `bp' = e(b)

		if "`lrtest'"=="" {
			tempname llp
			scalar `llp' = e(ll)
		}
	}
	else if `"`from'"'=="" { /* nolrtest */
		`vvpoi' ///
		capture poisson `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ `offopt' `constan' iter(1)

		tempname bp
		mat `bp' = e(b)
	}

/* Fit constant-only model. */

	if "`constan'"=="" & `"`from'"'=="" {

	/* Get starting values for constant-only model. */

		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ mean(`mean')
			local c = r(_cons)
		}
		else	local c = ln(`mean')

		tempname b0 ll0
		if `c'<. {
			mat `b0' = (`c', 0)
		}
		else	mat `b0' = (0, 0)

		mat colnames `b0' = `y':_cons ln`parm':_cons

		if "`weight'"=="aweight" {
			local wt `"[aw`exp']"'
		}
		else if "`weight'"!="" {
			local wt `"[iw`exp']"'
		}

		`nohead' di in gr _n "Fitting constant-only model:"

		`vv' ///
		ml model `mm' `prog' (`yname': `y'=, `constan' `offopt') /*
		*/ /ln`parm' if `touse' `wt', /*
		*/ collinear missing max nooutput nopreserve wald(0) /*
		*/ init(`b0', copy) search(off) `mlopts' `robust' /*
		*/ nocnsnotes `negh'

		mat `b0' = e(b)
		scalar `ll0' = e(ll)
		local continu "continue"
	}

/* Get starting values for full model. */

	if `"`from'"'=="" {
		if "`constan'"=="" {
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

			/* Compute log likelihood and compare with
			   constant-only model.
			*/
				mat `bp' = (`bp', `b0'[1,2..2])

				`LLprog' `y' `xb' `b0'[1,2] [`weight'`exp'] /*
				*/ if `touse', nobs(`r(N)')

				if r(lnf) > `ll0' & r(lnf)<. {
					local initopt "init(`bp')"
				}
			}

			if "`initopt'"=="" {
				local initopt "init(`b0')"
			}
		}
		else {
			tempname b0
			mat `b0' = (0)
			if _caller() < 15 {
				mat colnames `b0' = ln`parm':_cons
			}
			else {
				mat colnames `b0' = /ln`parm'
			}
			mat `bp' = (`bp',`b0')
			local initopt "init(`bp')"
		}

		`nohead' di in gr _n "Fitting full model:"
	}
	else    local initopt `"init(`from')"'

/* Fit full model. */

	`vv' ///
	ml model `mm' `prog' (`yname': `y'=`xvars', `constan' `offopt') /*
	*/ /ln`parm' if `touse' [`weight'`exp'], collinear missing max /*
	*/ nooutput nopreserve `initopt' search(off) `mlopts' /*
	*/ `scopt' `robust' `vce' `continu' /*
	*/ title(`title') diparm(ln`parm', exp label("`parm'")) `negh' /*
	*/ `moptobj'

	est local cmd

        if "`score'"!="" {
		label var `scvar1' "Score index for x*b from nbreg"
		rename `scvar1' `scname1'
		label var `scvar2' /*
			*/ "Score index for /ln`parm' from nbreg"
		rename `scvar2' `scname2'
		est local scorevars `scname1' `scname2'
	}

	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	matrix `pclass'[1,`dim'] = `PCAUX'
	est hidden matrix b_pclass `pclass'

	if "`llp'"!="" {
		est local chi2_ct "LR"
		est scalar ll_c = `llp'
		if (e(ll) < e(ll_c)) | (_b[/ln`parm'] < -20) {
			est scalar chi2_c = 0
				/* otherwise, let it be negative when
				   it does not converge
				*/
		}
		else	est scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	est scalar r2_p = 1 - e(ll)/e(ll_0)

	est scalar k_aux = 1
	est hidden local diparm_opt2 noprob
	est scalar `parm' = exp(_b[/ln`parm'])
	est local dispers "`dispers'"
	est local offset  "`offvar'"
	est local offset1 /* erase; set by -ml- */
	est hidden local marginsderiv default N IR
	est local predict "nbreg_p"
        est local cmd     "nbreg"

/* Double save. */

	global S_E_ll    = e(ll)
	global S_E_ll0   `e(ll_0)'
	global S_E_llc   `e(ll_c)'
	global S_1       `e(chi2_c)'
	global S_E_chi2  = e(chi2)
	global S_E_mdf   = e(df_m)
	global S_E_pr2   `e(r2_p)'
	global S_E_nobs  = e(N)
	global S_E_tdf   = e(N)
	global S_E_off   `e(offset)'
	global S_E_depv  `e(depvar)'
	global S_E_cmd   `e(cmd)'

	if "`display'"=="" {
		Display, `irr' level(`level') `diopts'
	}
	error `e(rc)'
end

program Display
	syntax [, Level(cilevel) IRr *]
	_get_diopts diopts, `options'
	if "`irr'"!="" {
		local eopt "eform(IRR)"
	}

	if "`e(dispers)'"=="mean" {
		local parm alpha
	}
	else	local parm delta

	version 9: ml di, level(`level') `eopt' nofootnote `diopts'

	if "`e(chi2_ct)'"!="LR" { exit }

	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e4)) | (ln(e(`parm')) < -20) {
                local fmt "%8.2f"
	}
	else 	local fmt "%8.2e"

	tempname pval
        scalar `pval' =  chiprob(1, e(chi2_c))*0.5
        if ln(e(`parm')) < -20 { scalar `pval'= 1 }

	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")

	di in smcl as txt "LR test of `parm'=0: " as txt ///
		"{help j_chibar##|_new:chibar2(01) = }" as res "`chi'" ///
		_col(56) as txt "Prob >= chibar2 = " as res %5.3f `pval'
        
	_prefix_footnote
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
		if r(max) > 709 { scalar `shift' =  709 - r(max) }
		else		  scalar `shift' = -709 - r(min)
		local shift "+`shift'"
	}
	tempvar expoff
	qui gen double `expoff' = exp(`xb'`shift') `if'
	summarize `expoff' [`weight'`exp'], meanonly
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program LLalpha, rclass
	gettoken y  0 : 0
	gettoken z  0 : 0
	gettoken b0 0 : 0
	syntax [fw aw pw iw] [if], Nobs(string)
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempname lnalpha m
	scalar `lnalpha' = `b0'
	local bound -20
	if `lnalpha' < `bound' { scalar `lnalpha' = `bound' }
	scalar `m' = exp(-`lnalpha')

	qui replace `z' = lngamma(`m'+`y') - lngamma(`y'+1) /*
	*/ - lngamma(`m') - `m'*ln1p(exp(`z'+`lnalpha')) /*
	*/ - `y'*ln1p(exp(-`z'-`lnalpha')) `if'

	summarize `z' `wt' `if', meanonly
	if r(N) != `nobs' { exit }
	if "`weight'"=="aweight" {
		ret scalar lnf = r(N)*r(mean)
				/* weights not normalized in r(sum) */
	}
	else	ret scalar lnf = r(sum)
end

program LLdelta, rclass
	gettoken y  0 : 0
	gettoken z  0 : 0
	gettoken b0 0 : 0
	syntax [fw aw pw iw] [if], Nobs(string)
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempname lndelta lnoned
	scalar `lndelta' = `b0'
	local bound -20
	if `lndelta' < `bound' { scalar `lndelta' = `bound' }
	scalar `lnoned' = ln1p(exp(`lndelta'))

	qui replace `z' = lngamma(`y'+exp(`z')) - lngamma(`y'+1) /*
	*/ - lngamma(exp(`z')) + `lndelta'*`y' - (`y'+exp(`z'))*`lnoned' `if'

	summarize `z' `wt' `if', meanonly
	if r(N) != `nobs' { exit }
	if "`weight'"=="aweight" {
		ret scalar lnf = r(N)*r(mean)
				/* weights not normalized in r(sum) */
	}
	else	ret scalar lnf = r(sum)
end

program Dispers, sclass
	sret clear
	syntax [, Mean Constant ]
	if "`constan'"==""  {
		sret local dispers "mean"
		exit
	}
	if "`mean'"!="" {
		version 7: di as err "must choose either {bf:mean} or {bf:constant} for option {bf:dispersion()}"
		exit 198
	}
	sret local dispers "constant"
end

exit

Notes:

    Model            Starting values
-------------   -------------------------
nbreg, cons     best of

		1.  b0 = (c0, lnparm0) constant-only estimates

		2.  (bp=poisson coefficients, c, lnparm0),
		    where c is such that mean(bp + c + offset) =
		    mean(c0 + offset); i.e., adjusted to constant-
		    only value

nbreg, nocons   (bp=poisson, 0)

<end of file>

