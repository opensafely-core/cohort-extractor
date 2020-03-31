*! version 1.3.0  12apr2019
program tnbreg, eclass byable(onecall) prop(irr ml_score svyb svyj svyr bayes)
	version 11.0

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	`BY' _vce_parserun tnbreg, mark(EXPosure OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"tnbreg `0'"'
		 exit
	}

	local version : di "version " string(_caller()) ":"
	if replay() {
		if ("`e(cmd)'" != "tnbreg") error 301
		if (_by()) error 190
		global S_1 = e(chi2_c)
		Display `0'
		error `e(rc)'
		exit
	}

	`version' `BY' Estimate `0'
	ereturn local cmdline `"tnbreg `0'"'
end

program Estimate, eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local mm d2
	}

	version 11.0
/* Parse. */

	syntax varlist(numeric fv ts) [fw pw iw] [if] [in] [, IRr /*
	*/ FROM(string) Level(cilevel) OFFset(varname numeric ts) /*
	*/ Exposure(varname numeric ts) noCONstant Robust CLuster(varname) /*
	*/ SCore(string) NOLOg LOg noDISPLAY noLRtest Dispersion(string) /*
	*/ LL(string) CRITTYPE(passthru) VCE(passthru) moptobj(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `log' `nolog'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopts `mlopts' `crittype'

	Dispers, `dispersion'
	local title "Truncated negative binomial regression"
	local dispersion `s(dispers)'
	if "`dispersion'"!="constant" {
		local prog   "tnbreg_mean"
		local parm   "alpha"
		local LLprog "LLalpha"
	}
	else {
		local prog   "tnbreg_cons"
		local parm   "delta"
		local LLprog "LLdelta"
	}

/* Check syntax. */

	if `"`score'"'!="" {
		local nword : word count `score'
		if `nword'==1 & bsubstr("`score'",-1,1)=="*" {
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2
			local nword 2
		}
		cap confirm new variable `score'
		if `nword' != 2 | _rc>0 {
			di as err "{cmd: score()} must contain the name of " /*
			*/ "two new variables"
			exit 198
		}
		local scname1 : word 1 of `score'
		local scname2 : word 2 of `score'
		tempvar scvar1 scvar2
		local scopt "score(`scvar1' `scvar2')"
	}
	if "`offset'"!="" & "`exposure'"!="" {
		di as err "only one of {cmd:offset()} or " ///
		"{cmd:exposure()} can be specified"
		exit 198
	}
	if "`constant'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			di as err "independent variables required with " /*
			*/ "{cmd:noconstant} option"
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
	local vceopt  `r(vceopt)'
	local cluster `r(cluster)'
	local robust `r(robust)'
	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
	}
	tokenize "`ll'", parse(" ,")
	if "`2'" != "" {
		di as error "must specify only one argument in ll()"
		error 200
	}
	local isvar = 0
	cap confirm numeric variable `ll'
	if _rc==0 {
		unab ll : `ll', max(1)
		markout `touse' `ll'
		local isvar = 1
	}
	else {
		cap noisily
	}

/* check syntax and grab ll() */
	local tp = 0
	if ("`ll'" != ""){
		cap confirm names `ll'
		if _rc!=0 {
		/* it is not a name, should be a number */
			cap confirm number `ll'
			if _rc!=0 {
				di as error "{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
				exit 200
			}
			else{
				local tp = `ll'
				capture noisily
			}
		}
		else{
		/* ll() does not contain a number */
			cap confirm variable `ll'
			if `isvar'==0 {
			/* ll() contains a name that is not a variable */
			/* possibly it is a scalar			 */
				local tp = `ll'
				cap confirm number `tp'
				if _rc!=0{
					di as error "{cmd:ll(`ll')} must " ///
						"specify a nonnegative value"
					exit 200
				}
			}
			else {
			/* ll() contains the name of a variable */
				local tp `ll'
				qui summarize `tp' if `touse', meanonly
				if r(min) < 0 {
					di as error "{cmd:ll(`ll')} " ///
						"must contain all " ///
						"nonnegative values"
					exit 200
				}
				if r(max) > 0 local mm e2
				tempvar _d _n
				qui gen double `_d'  = `tp' - int(`tp') ///
					if `touse'
				qui gen int `_n'  = 1 if `_d'!=0 & `touse'
				qui sum `_n' if `touse', meanonly
				local m = r(N)
				if `m' > 0 {
					local s
					if `m' > 1 {
						local s s
					}
					di as error "{cmd:ll(`ll')} " ///
					"contains `m' noninteger value`s'"
					exit 200
				}
			}
		}

		if `isvar'==0 {
			if `tp' < 0{
				di as error "{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
				exit 200
			}
			local a = `ll'
			cap confirm integer number `a'
			if _rc!=0 {
				di as error "{cmd:ll(`ll')} " ///
					"must specify an integer"
				exit 200
			}
			if `tp' > 0 local mm e2
		}
	}
	ereturn local llopt `tp'

/* Process offset/exposure. */

	if "`exposure'"!="" {
		capture assert `exposure' > 0 if `touse'
		if _rc!=0 {
			di as err "{cmd:exposure()} must be greater than zero"
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

	if r(N) == 0  error 2000
	if r(N) == 1  error 2001

	tempname mean
	scalar `mean' = r(mean)
	local   min   = r(min)
	if `min' < 0 {
		di as error "`y' must be greater than zero"
		exit 459
	}
	if `min' == 0 {
		di as error ///
			"{p 0 4 2}some observations on `y' are zero, "   ///
			"truncated negative binomial model is "          ///
			"inappropriate{p_end}"
			exit 459
	}
	if `isvar'==0 {
		if `min' <= `tp' {
			di as error "{p 0 4 2}truncation value specified " ///
				"in {cmd:ll()} must be " ///
				"less than `min', the smallest value " ///
				"in `y'{p_end}"
			exit 459
		}
	}
	else {
		tempvar _dif
		quietly gen  double `_dif' = `y' - `tp' if `touse'
		quietly summarize `_dif' if `touse', meanonly
		if r(min) <= 0 {
			di as error ///
				"{p 0 4 2}values in `y' must be greater " ///
				"than their truncation value specified "  ///
				"in {cmd:ll(`tp')}{p_end}"
			exit 459
		}
		drop `_dif'
	}

/* Check whether `y' is integer-valued. */

	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc!=0 {
			di in gr "{p 0 4 2}note: you are responsible for " /*
			*/ "interpretation of noncount dep. variable{p_end}"
			capture noisily
		}
	}


/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
	}
	else	local rmcoll _rmcoll
	`rmcoll' `xvars' [`weight'`exp'] if `touse', `constant' `coll'
	local xvars `r(varlist)'

/* Run comparison Truncated Poisson model. */

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if ("`log'"!="" | "`display'"!="") local nohead "*"

	if `"`from'"'=="" & "`lrtest'"=="" {
		if "`robust'`cns'`cluster'"!="" | "`weight'"=="pweight" {
			local lrtest "nolrtest"
		}
		`nohead' di in gr _n "Fitting truncated Poisson model:"

		tpoisson `y' `xvars' [`weight'`exp'] if `touse', ll(`tp') /*
		*/ nodisplay `offopt' `constant' `mlopts' `robust'

		tempname bp
		mat `bp' = e(b)

		if "`lrtest'"=="" {
			tempname llp
			scalar `llp' = e(ll)
		}
	}
	else if `"`from'"'=="" { /* nolrtest */
		cap tpoisson `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ `offopt' `constant' iter(1)

		tempname bp
		mat `bp' = e(b)
	}

/* Fit constant-only model. */

	if "`constant'"=="" & `"`from'"'=="" {

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

		if _caller() < 15 {
			mat colnames `b0' = `yname':_cons ln`parm':_cons
		}
		else {
			mat colnames `b0' = `yname':_cons /ln`parm'
		}


		if "`weight'"!="" {
			local wt `"[iw`exp']"'
		}

		`nohead' di in gr _n "Fitting constant-only model:"
		global ZTNB_tp_ `tp'
		global GLIST : all globals "ZTNB_*"
		`vv' ///
		ml model `mm' `prog' (`yname': `y'=, `constant' `offopt') /*
		*/ /ln`parm' if `touse' `wt', /*
		*/ collinear missing max nooutput nopreserve wald(0) /*
		*/ init(`b0') search(off) `mlopts' `robust' /*
		*/ nocnsnotes `negh'
		macro drop ZTNB_tp_

		mat `b0' = e(b)
		scalar `ll0' = e(ll)
		local continu "continue"
	}

/* Get starting values for full model. */

	if `"`from'"'=="" {
		if "`constant'"=="" {
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

				mat `bp'[1,`dim'] = `bp'[1,`dim'] + /*
				*/ `b0'[1,1] - r(mean)

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
	else	local initopt `"init(`from')"'

/* Fit full model. */

	/* `nohead' di in gr _n "`title'" */
	ml clear
	global ZTNB_tp_ `tp'
	`vv' ///
	ml model `mm' `prog' (`yname': `y'=`xvars', `constant' `offopt') /*
	*/ /ln`parm' if `touse' [`weight'`exp'], collinear missing max /*
	*/ nooutput nopreserve `initopt' search(off) `mlopts' /*
	*/ `scopt' `vceopt' `continu' title("`title'") /*
	*/ diparm(ln`parm', exp label("`parm'")) `negh' `moptobj'
	macro drop ZTNB_tp_
	if `isvar' == 0 {
		local tle = abbrev("`tp'", 12)
		eret hidden local title2 "Truncation point: {res:`tle'}"
	}
	else {
		local tle = abbrev("`ll'", 12)
		eret hidden local title2 "Truncation points: {res:`tle'}"
	}
	eret local title "Truncated negative binomial regression"
	eret local cmd

	if "`score'"!="" {
		label var `scvar1' "Score index for x*b from nbreg"
		rename `scvar1' `scname1'
		label var `scvar2' /*
		   */ "Score index for /ln`parm' from nbreg"
		rename `scvar2' `scname2'
		eret local scorevars `scname1' `scname2'
	}

	if "`llp'"!="" {
		eret local chi2_ct "LR"
		eret scalar ll_c = `llp'
		if (e(ll) < e(ll_c)) | (_b[/ln`parm'] < -20) {
			eret scalar chi2_c = 0
				/* otherwise, let it be negative when
				   it does not converge
				*/
		}
		else	eret scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	matrix `pclass'[1,`dim'] = `PCAUX'
	eret hidden matrix b_pclass `pclass'

	eret scalar r2_p = 1 - e(ll)/e(ll_0)


	eret scalar k_aux = 1
	eret hidden local diparm_opt2 noprob
	eret scalar `parm' = exp(_b[/ln`parm'])
	eret local dispers "`dispersion'"
	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "tnbreg_p"
	eret local cmd	 "tnbreg"
	eret local llopt "`tp'"
	if "`display'"=="" {
		Display, `irr' level(`level') `diopts'
	}
	eret hidden local title2 "Truncation points: `tle'"
	eret local title "Truncated negative binomial regression"
	error `e(rc)'
end

program Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
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

	if "`e(chi2_ct)'"!="LR"  exit

	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e4)) | (ln(e(`parm')) < -20) {
		local fmt "%8.2f"
	}
	else	local fmt "%8.2e"

	tempname pval
	scalar `pval' =  chiprob(1, e(chi2_c))*0.5
	if (ln(e(`parm')) < -20)  scalar `pval'= 1

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
	version 11.0
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
	if (`lnalpha' < `bound')  scalar `lnalpha' = `bound'
	scalar `m' = exp(-`lnalpha')

	qui replace `z' = lngamma(`m'+`y') - lngamma(`y'+1) /*
	*/ - lngamma(`m') - `m'*ln1p(exp(`z'+`lnalpha')) /*
	*/ - `y'*ln1p(exp(-`z'-`lnalpha'))		/*
	*/ - ln(nbinomialtail(`m',$ztnb_tp+1,1/(1+exp(`z')/ `m'))) `if'

	summarize `z' `wt' `if', meanonly
	if (r(N) != `nobs')  exit
	ret scalar lnf = r(sum)
end

program LLdelta, rclass
	version 11.0
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
	tempname lndelta lnoned mudelta
	scalar `lndelta' = `b0'
	local bound -20
	if (`lndelta' < `bound')  scalar `lndelta' = `bound'
	scalar `lnoned' = ln1p(exp(`lndelta'))
	qui gen double `mudelta'=exp(`z'-`lndelta')
	qui replace `z' = lngamma(`y'+exp(`z')) - lngamma(`y'+1) /*
	*/ - lngamma(exp(`z')) + `lndelta'*`y' - (`y'+exp(`z'))*`lnoned' /*
	*/ - ln(nbinomialtail(exp(`z'),$ztnb_tp+1,(1+exp(`mudelta')) )) `if'

	summarize `z' `wt' `if', meanonly
	if r(N) != `nobs'  exit

	ret scalar lnf = r(sum)
end

program Dispers, sclass
	version 8.0
	sret clear
	syntax [, Mean Constant ]
	if "`constant'"==""  {
		sret local dispers "mean"
		exit
	}
	if "`mean'"!="" {
		di as err "{p 0 4 2}must choose either mean or constant" /*
		*/ " for {cmd:dispersion()}{p_end}"
		exit 198
	}
	sret local dispers "constant"
end

exit

