*! version 1.11.0  21jun2018
program define xtnbreg, eclass byable(onecall) prop(irr xt xtbs mi)
        local vv : display "version " string(_caller()) ", missing:"
	version 6, missing
	if replay() {
		if "`e(cmd)'"!="xtnbreg" & "`e(cmd2)'"!="xtnbreg" {
			error 301
		}
		if _by() { error 190 }
		if "`e(cmd)'" == "xtgee" {
			syntax [, IRr EForm Level(cilevel) *]
			if "`irr'"!="" {
				local eform "eform"
			}
			xtgee , `eform' level(`level') `options'
			exit
		}
		Display `0'
		error `e(rc)'
		exit
	}

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`vv' `by' _vce_parserun xtnbreg, panel mark(I EXPosure OFFset) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtnbreg `0'"'
		exit
	}
	nobreak {
        	capture noisily break {
			`vv' `by' Estimate `0'
		}
		version 10: ereturn local cmdline `"xtnbreg `0'"'
		macro drop S_XT*
		exit _rc
	}
end

program define Estimate, eclass byable(recall) sort
	version 6, missing
	qui q born
	local afwgt = cond($S_1<14679, "aweight", "fweight") 
	syntax varlist(numeric ts fv) [if] [in] [iweight `afwgt' pweight] /*
	*/ [, I(varname num) RE FE PA IRr EForm noCONstant noSKIP/*undoc*/ /*
	*/ LRMODEL noDIFficult EXPosure(varname num) OFFset(varname num) /*
	*/ vce(passthru) Robust CLuster(passthru) /*
	*/ FROM(string) Level(cilevel) noLOg * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	local tsops = "`s(tsops)'" == "true"
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local negh negh
		local fvexp expand
	}
	else {
		local vv "version 8.1:"
	}

	if length("`fe'`re'`pa'") > 2 {
		di in red "choose one of re, fe, or pa"
		exit 198
	}

/* Mark sample except for offset/exposure. */

	marksample touse
        _xt, i(`i')
        local ivar "`r(ivar)'"
	markout `touse' `ivar' /* iis does not allow string */

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`pa'"!="" {
		if "`lrmodel'" != "" {
			_check_lrmodel, `skip' `constan' ///
				options(`pa')
		}
		if "`i'"!="" { local iarg "i(`i')" }
		if "`offset'"!="" {
			local offset "offset(`offset')"
		}
		if "`exposur'"!="" {
			local exposur "exposure(`exposur')"
		}
                if `"`from'"' != "" {
                        local farg "from(`from')"
                }
		if "`irr'"!="" {
			local eform "eform"
		}
		xtgee `varlist' if `touse' [`weight'`exp'], /*
		*/ fam(nbinom) link(log) rc0 level(`level') /*
		*/ `farg' `iarg' `constan' `offset' `exposur' /*
		*/ `eform' `mllog' `options' `vce' `robust' `cluster'
		est local predict xtnbreg_pa_p
		if e(rc) == 0 | e(rc) == 430 {
			est local estat_cmd ""	// reset from xtgee
			est local cmd2 "xtnbreg"
			if _caller()>=11.1 {
				est local model    "pa"
			}
		}
		error `e(rc)'
		exit
	}

	if `"`vce'`robust'`cluster'"' != "" {
		_vce_parse, opt(OIM) old				///
			: [`weight'`exp'], `vce' `robust' `cluster'
	}
/* If here, we are doing re (default) or fe. */

	if "`fe'`re'"=="" { local re "re" }

	_get_diopts diopts options, `options'
        mlopts mlopts, `options'
	local coll `s(collinear)'
	local constr `s(constraints)'

	local difficu = cond("`difficu'"=="", "difficult", "")

        if "`weight'"!="" & "`weight'"!="iweight" {
                noi di in red /*
		*/ "`weight' not allowed with fixed- and random-effects models"
                exit 101
        }
	if "`offset'"!="" & "`exposur'"!="" {
		di in red "only one of offset() or exposure() can be specified"
		exit 198
	}
	if "`constan'"!="" {
		local nvar : word count `varlist'"
		if `nvar' == 1 {
			di in red "independent variables required with " /*
			*/ "noconstant option"
			exit 102
		}
	}
	if "`fe'"!="" {
		local title "Conditional FE negative binomial regression"
		local prog  "xtnb_fe"
	}
	else {
		local title "Random-effects negative binomial regression"
		local prog  "xtnb_lf"
		local distr "Beta"
		local eqaux "/ln_r /ln_s"
	}


/* Process offset/exposure. */

	if "`exposur'"!="" {
		capture assert `exposur' > 0 if `touse'
		if _rc {
			di in red "exposure() must be greater than zero"
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

	gettoken y xvars : varlist
	_fv_check_depvar `y'

	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constan' constraints(`constr') ///
			options(`cluster' `robust') indep(`xvars')
		local skip "noskip"
	}
	else if "`skip'"=="" | "`constan'"!="" {
                local skip "skip"
        }

/* Count obs, check for negative values of `y', and compute mean. */
	
	local yname `y'
	local ystr : subinstr local yname "." "_"

	if `tsops' {
		tsrevar `y'
		local y `r(varlist)'
	}

	summarize `y' if `touse', meanonly

	if r(N) == 0 { error 2000 }
	if r(N) == 1 { error 2001 }

	if r(min) < 0 {
		di in red "`y' must be greater than or equal to zero"
		exit 459
	}

	tempname mean
	scalar `mean' = r(mean)

/* Issue warning if `y' is not an integer. */

	capture assert `y' == int(`y') if `touse'
	if _rc {
		di in gr "note: you are responsible for " /*
		*/ "interpretation of non-count dep. variable"
	}

/* Sort. */

	tempvar nn
	gen `c(obs_t)' `nn' = _n
	sort `touse' `ivar' `nn' /* deterministic sort */

/* Check weights. */

	if "`weight'"!="" {
		tempvar w
		qui gen double `w' `exp'
		_crcchkw `ivar' `w' `touse'
		drop `w'
	}

/* For fe model, drop any groups with `y' all zeros or those of size 1. */

	if "`fe'"!="" {
		DropOne  `touse' `ivar' `nn' `y' `mean'
		DropZero `touse' `ivar' `nn' `y' `mean'
	}

	drop `nn'

/* Remove collinearity. */

	if `tsops' {
		qui tsset, noquery
	}
	`vv' _rmcoll `xvars' [`weight'`exp'] if `touse', ///
		`constan' `coll' `fvexp'
	local xvars `r(varlist)'
	local xvarsnm `xvars'

	local oxvars : copy local xvars
	if `tsops' {
		fvrevar `xvars', tsonly
		local xvars `r(varlist)'
	}
	local p : list sizeof oxvars
	forval i = 1/`p' {
		gettoken x oxvars : oxvars
		local NAMES `NAMES' `yname':`x'
	}
	if "`constan'" == "" {
		local NAMES `NAMES' `yname':_cons
	}
	if "`re'" != "" {
		if _caller() < 15 {
			local NAMES `NAMES' ln_r:_cons ln_s:_cons
		}
		else {
			local NAMES `NAMES' `eqaux'
		}
	}

/* Set up global for use by likelihood program. */

	global S_XTby "`touse' `ivar'"

	quietly {
                tempvar nn
                gen `c(obs_t)' `nn' = _n
                sort `touse' `ivar' `nn' /* deterministic sort */
		drop `nn'

	/* Check weights. */

		if "`weight'"!="" {
			tempvar w
			gen double `w' `exp'
                        _crcchkw `ivar' `w' `touse'
			drop `w'
                }

	/* Get number of groups and group size min, mean, and max. */

                tempvar T
                by `touse' `ivar': gen `c(obs_t)' `T' = _N if _n==1 & `touse'
                summarize `T' if `touse', meanonly
                local ng = r(N)
                local g1 = r(min)
                local g2 = r(mean)
                local g3 = r(max)
	}

	if "`log'"!="" { local qui "quietly" }

/* Get comparison/starting values:

       nbreg, disp(con)  for re model
       poisson, iter(1)  for fe model
*/

	if `"`from'"'=="" {
		if "`re'"!="" {
			`qui' di in gr _n "Fitting negative " /*
			*/ "binomial (constant dispersion) model:"
			`vv' ///
			`qui' nbreg `y' `xvars' if `touse' [`weight'`exp'], /*
			*/ `constan' `offopt' `mlopts' nodisplay disp(con)  /*
			*/ `mllog'

			tempname llp b0
			scalar `llp'  = e(ll)
			mat `b0' = e(b)
			local init0 "init(`b0',skip)"
		}
		else {
			`vv' ///
			capture poisson `y' `xvars' if `touse' /*
			*/ [`weight'`exp'], `constan' `offopt' iter(1)
			if _rc {
				di as err ///
				"could not find feasible starting values"
				exit _rc
			}
			tempname b0
			mat `b0' = e(b)
			local init0 "init(`b0')"
		}
		local b0n : colfullnames `b0'
		local b0n : subinstr local b0n "`y'" "`ystr'", all
		`vv' ///
		mat colnames `b0' = `b0n'
	}
	else	local init0 `"init(`from')"'

/* Fit constant-only model. */

	if "`skip'"=="noskip" {

	/* Get starting values for constant-only model. */

		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ mean(`mean')
			local c = r(_cons)
		}
		else	local c = ln(`mean')

		if `c'>=. { local c 0 }

		tempname b00
		if "`re'"!="" {
			mat `b00' = (`c', 0, 0)
			if _caller() < 15 {
				mat colnames `b00' = `y':_cons	///
						     ln_r:_cons	///
						     ln_s:_cons
			}
			else {
				mat colnames `b00' = `y':_cons `eqaux'
			}
		}
		else {
			mat `b00' = (`c')
			mat colnames `b00' = `y':_cons
		}

		`qui' di _n in gr "Fitting constant-only model:"

		`vv' ///
		ml model d2 `prog' (`ystr': `y' = , `offopt') `eqaux' /*
		*/ if `touse' [`weight'`exp'], /*
		*/ collinear missing max nooutput nopreserve wald(0) /*
		*/ init(`b00') search(off) `mlopts' `mllog' `difficu' /*
		*/ nocnsnotes `negh'

		if "`xvars'"=="" { local init0 /* erase macro */ }

		local continu "continue"

		`qui' di in gr _n "Fitting full model:"
	}
	else if `"`from'"'=="" & "`re'"!="" {
		`qui' di in gr _n "Fitting full model:"
	}

/* Fit full model. */

	`vv' ///
	ml model d2 `prog' (`ystr': `y' = `xvars', `constan' `offopt') `eqaux'/*
	*/ if `touse' [`weight'`exp'], /*
	*/ collinear missing max nooutput nopreserve `init0' search(off) /*
	*/ `mlopts' `mllog' `difficu' `continu' title(`title') `negh'

	est local cmd

/* Redo matrix stripes on b and V, removing names of tempvars due to TS ops */
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	`vv' mat colnames `b' = `NAMES'
	`vv' mat colnames `V' = `NAMES'
	`vv' mat rownames `V' = `NAMES'
	_ms_op_info `b'
	if r(tsops) {
		quietly tsset, noquery
	}
	est repost b = `b' V = `V', rename buildfvinfo

	if "`llp'"!="" {
		est local chi2_ct "LR"
		est scalar ll_c = `llp'
		if e(ll) < e(ll_c) {
	        		est scalar chi2_c = 0
		}
		else	est scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	if "`re'" != "" {
		_b_pclass PCDEF : default
		_b_pclass PCAUX : aux
		tempname pclass
		matrix `pclass' = e(b)
		local dim = colsof(`pclass')
		matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
		matrix `pclass'[1,`dim'-1] = `PCAUX'
		matrix `pclass'[1,`dim'] = `PCAUX'
		est hidden matrix b_pclass `pclass'
	}

	est local depvar "`yname'"
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
	if "`re'"!="" {
		est scalar r = exp(_b[/ln_r])
		est scalar s = exp(_b[/ln_s])
	}
        est local method  "ml"
        est local distrib "`distr'"

	est local ivar    "`ivar'"
	est local offset1 /* erase from ml */
	est local offset  "`offvar'"
	est local predict "xtnbreg_refe_p"
	if _caller()<11.1 {
		est local cmd2    "xtn_`re'`fe'"
	}
	else {
		est local model    "`re'`fe'"
	}
	if "`re'" == "re" {
		est scalar k_aux = 2
		local i 0
		est hidden local diparm`++i' ln_r, exp label("r")
		est hidden local diparm`++i' ln_s, exp label("s")
	}
	est local cmd	  "xtnbreg"

	Display , level(`level') `irr' `eform' `diopts' 
	error `e(rc)'
end

program define Display
	syntax [, Level(cilevel) IRr EForm *]
        if "`eform'"!="" { local irr "irr" }

	if "`irr'"!="" { local irr "eform(IRR)" }
	_get_diopts diopts, `options'

	_crcphdr
	if "`e(model)'"=="" {
		local cmd2mac cmd2
		local cmd2val xtn_re
	}
	else {
		local cmd2mac model
		local cmd2val re
	}
	if "`e(`cmd2mac')'"=="`cmd2val'" { local plus "plus" }

	version 10: ///
	ml display, level(`level') `irr' nohead nofootnote `diopts' notest
	if "`e(`cmd2mac')'"=="`cmd2val'" {
		Footnote
	}
	_prefix_footnote
end

program Footnote
	if e(chi2_c)>=. { exit }
	_lrtest_note_xt, msg("LR test vs. pooled")
end

program define DropOne /* drop groups of size one */
	args touse ivar nn y mean

	tempvar one
	qui by `touse' `ivar': gen byte `one' = (_N==1) if `touse'

	qui count if `one' & `touse'
	local ndrop `r(N)'

	if `ndrop' == 0 { exit } /* no groups with all zeros */

	if `ndrop' > 1 { local s "s" }
	di in gr "note: `ndrop' group`s' " /*
	*/ "(`ndrop' obs) dropped because of only one obs per group"

	qui replace `touse' = 0 if `one' & `touse'

	sort `touse' `ivar' `nn' /* redo sort */

	summarize `y' if `touse', meanonly
	if r(N) == 0 { error 2000 }
	if r(N) == 1 { error 2001 }
	scalar `mean' = r(mean)
end

program define DropZero /* drop groups with all zero counts */
	args touse ivar nn y mean

	tempvar sumy
	qui by `touse' `ivar': gen double `sumy' = /*
	*/ cond(_n==_N, sum(`y'), .) if `touse'

	qui count if `sumy'==0
	local ngrp `r(N)'

	if `ngrp' == 0 { exit } /* no groups with all zeros */

	qui by `touse' `ivar': replace `sumy' = `sumy'[_N] if `touse'

	qui count if `sumy'==0
	local ndrop `r(N)'

	if `ngrp' > 1 { local s "s" }
	di in gr "note: `ngrp' group`s' " /*
	*/ "(`ndrop' obs) dropped because of all zero outcomes"

	qui replace `touse' = 0 if `sumy'==0 & `touse'

	sort `touse' `ivar' `nn' /* redo sort */

	summarize `y' if `touse', meanonly
	if r(N) == 0 { error 2000 }
	if r(N) == 1 { error 2001 }
	scalar `mean' = r(mean)
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

exit

Notes:

1.  Uses -difficult- optimizer by default.  Specify -nodifficult- to get
    standard optimizer.

2.  Skips the constant-only model by default.  Specify -noskip- to estimate
    constant-only model.

3.            Model                Starting values
    --------------------------     ----------------
    xtnbreg, fe (full model)       poisson, iter(0)
    xtnbreg, fe (constant only)    ln(mean) or SolveC
    xtnbreg, re (full model)       nbreg, disp(con) and ln_r = ln_s = 0
    xtnbreg, re (constant only)    ln(mean) or SolveC with ln_r = ln_s = 0

<end of file>

