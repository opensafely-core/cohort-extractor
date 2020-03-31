*! version 3.5.0  19feb2019
program ztp, eclass byable(onecall) prop(irr ml_score svyb svyj svyr)
        if _by() {
        	local BY `"by `_byvars'`_byrc0':"'
        }
        `BY' _vce_parserun ztp, mark(EXPosure OFFset CLuster) : `0'
        if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"ztp `0'"'
                exit
        }

	version 8.1
        local version : di "version " string(_caller()) ":"
        if replay() {
                if ("`e(cmd)'" != "ztp") error 301
                if (_by()) error 190
                Display `0'
                error `e(rc)'
                exit
        }

        `version' `BY' Estimate `0'
	ereturn local cmdline `"ztp `0'"'
end

program Estimate, eclass byable(recall)
	version 8.1

/* Parse. */
      
	syntax varlist(numeric fv ts) [fw pw iw] [if] [in] [, IRr /*
	*/ FROM(string) Level(cilevel) OFFset(varname numeric ts) /*
	*/ Exposure(varname numeric ts) noCONstant Robust CLuster(varname) /*
	*/ SCore(string) noLOg noDISPLAY CRITTYPE(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local mlopts `mlopts' `crittype'

/* Check syntax. */

	if `"`score'"'!="" {
		confirm new variable `score'
		local nword : word count `score'
		if `nword' > 1 {
			di as error "score() must contain the name of only " /*
			*/ "one new variable"
			exit 198
		}
		tempvar scvar
		local scopt score(`scvar')
	}
	if "`offset'"!="" & "`exposure'"!="" {
		di as error "only one of offset() or exposure() can be " /* 
		*/"specified"
		exit 198
	}
	if "`constant'"!="" {
		local nvar : word count `varlist'
		if `nvar' == 1 {
			di as error "independent variables required with " /*
			*/ "noconstant option"
			exit 100
		}
	}

/* Mark sample except for offset/exposure. */

	marksample touse

	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
		local clopt cluster(`cluster')
	}

/* Process offset/exposure. */

	if "`exposure'"!="" {
		capture assert `exposure' > 0 if `touse'
		if _rc {
			di as error "exposure() must be greater than zero"
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

/* Count obs and check for no-positive values of `y'. */

	gettoken y xvars : varlist
	_fv_check_depvar `y'
	tsunab y : `y'
        local yname : subinstr local y "." "_"

	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else local wt `"[aw`exp']"'
	}

	summarize `y' `wt' if `touse', meanonly

	if (r(N) == 0)  error 2000 
	if (r(N) == 1)  error 2001 

	if r(min) <= 0 {
		di as error "`y' must be greater than zero"
		exit 459
	}

	tempname mean nobs
	scalar `mean' = r(mean)
	scalar `nobs' = r(N) /* #obs for checking #missings in calculations */

/* Check whether `y' is integer-valued. */

	if "`display'"=="" {
		capture assert `y' == int(`y') if `touse'
		if _rc {
			di in gr "note: you are responsible for " /*
			*/ "interpretation of non-count dep. variable"
		}
	}


/* Get lf0 = constant-only model log likelihood. */

	if "`constant'`cns'"=="" & "`cluster'"=="" & "`weight'"!="pweight" {
				/* pseudo-R2 is OK for robust */
		tempname c
		if "`offset'"!="" {
			SolveC `y' `offset' [`weight'`exp'] if `touse', /*
			*/ n(`nobs') mean(`mean')
			scalar `c' = r(_cons)
			if `c'>=. {
				di in gr /*
		                */ "note: exposure = exp(`offvar') overflows;"/*				*/ _n /*
	                	*/ "      could not estimate constant-only " /*
                                */ "model" _c
				if "`exposure'"=="" {
					di in gr _n /*
	       				*/ "      use exposure() option for "/*
                                        */ "exposure = `offvar'"
				}
				else 	di in gr 
				local cfail 1
			}
			local c "`c'+`offset'"
		}
		else	scalar `c' = ln(`mean')

		if "`cfail'"=="" {
			LikePois `y' `c' [`weight'`exp'] if `touse', n(`nobs')
			if r(lnf)<. {
				local ll0 "lf0(1 `r(lnf)')"
			}
			else {
				di in gr "note: could not compute " /*
				*/ "constant-only model log likelihood"
			}
		}
	}

/* Remove collinearity. */

	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local vv : di "version " string(max(11,_caller())) ", missing:"
		local mm e2
		local negh negh
	}
	else {
		local rmcoll _rmcoll
		local mm d2
	}
	`rmcoll' `xvars' [`weight'`exp'] if `touse', `constant' `coll'
	local xvars `r(varlist)'

/* Get initial values. */

	if "`from'"=="" {
		`vv' ///
		Ipois `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ n(`nobs') mean(`mean') `constant' `offopt'

		if "`r(b0)'"!="" {
			tempname from
			mat `from' = r(b0)
		}
	}
	if "`from'"!="" {
		local initopt `"init(`from') search(off)"'
	}
	else local initopt "search(on) maxfeas(50)"

	`vv' ///
	ml model `mm' trpoiss_d2 /*
	*/ (`yname': `y' = `xvars', `constant' `offopt') /*
	*/ [`weight'`exp'] if `touse', collinear missing max nooutput /*
	*/ nopreserve `mlopts' title(Zero-truncated Poisson regression) /*
        */ `scopt' `robust' /*
	*/ `clopt' `log' `initopt' `ll0' `negh'

	if "`score'" != "" {
		label var `scvar' "Score index from poisson"
		rename `scvar' `score'
		eret local scorevars `score'
	}

	eret scalar r2_p = 1 - e(ll)/e(ll_0)
	eret local offset  "`offvar'"
	eret local offset1 /* erase; set by -ml- */
	eret local predict "ztp_p"
	eret local cmd     "ztp"


	if "`display'"=="" {
		Display, `irr' level(`level') `diopts'
	}
	error `e(rc)'

end

program Display
	syntax [, Level(cilevel) IRr *]
	if "`irr'"!="" {
		local eopt "eform(IRR)"
	}
	_get_diopts diopts, `options'

	version 9: ml di, level(`level') `eopt' nofootnote `diopts'
	_prefix_footnote
end

program LikePois, rclass
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string)
	if "`weight'"!="" {
		if "`weight'"=="fweight" {
			local wt `"[fw`exp']"'
		}
		else	local wt `"[aw`exp']"'
	}
	tempvar lnf
	qui gen double `lnf' = `y'*(`xb')-exp(`xb')-lngamma(`y'+1) /*
           */ -ln1m(exp(-exp(`xb'))) `if'
	summarize `lnf' `wt' `if', meanonly
	if (r(N) != `nobs')  exit
 
	ret scalar lnf = r(sum)
end

program SolveC, rclass /* note: similar code is found in nbreg.ado */
	gettoken y  0 : 0
	gettoken xb 0 : 0
	syntax [fw aw pw iw] [if] , Nobs(string) Mean(string)
	if "`weight'"=="pweight" | "`weight'"=="iweight" {
		local weight "aweight"
	}
	capture confirm variable `xb'
	if _rc {
		tempvar xbnew
		qui gen double `xbnew' = (`xb') `if'
		local xb `xbnew'
	}
	summarize `xb' [`weight'`exp'] `if', meanonly
	if (r(N) != `nobs') exit 
	if (r(max) - r(min) > 2*709 ) { /* unavoidable exp() over/underflow */
		exit /* r(_cons) is missing */
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
	if (r(N) != `nobs')  exit  /* should not happen */
	return scalar _cons = ln(`mean')-ln(r(mean))`shift'
end

program Ipois, rclass
	syntax varlist(fv ts) [fw aw pw iw/] [if] , Nobs(string) Mean(string) /*
	*/ [ noCONstant OFFset(string) ]
	gettoken y xvars : varlist

	tempvar xb z
	tempname b1 b2 lnf1

	if "`weight'"!="" {
		local awt `"[aw=`exp']"'
		local wt  `"(`exp')*"'
		local exp `"=`exp'"'
	}

	quietly {

	/* Initial values: b1 = b/mean, where b are coefficients
	   from reg `y' `xvars' and mean is mean of `y'.
	*/
		if "`offset'"!="" {
			tempvar ynew
			gen double `ynew' = `y' - `offset'*`mean' `if'
			local poff "+`offset'"
		}
		else	local ynew `y'

		`vv' ///
		_regress `ynew' `xvars' `awt' `if', `constant'
		mat `b1' = (1/`mean')*e(b)
		mat score double `xb' = `b1' `if'

		LikePois `y' `xb'`poff' [`weight'`exp'] `if', n(`nobs')
		scalar `lnf1' = r(lnf)
	}

	/* Solve for _cons (change) for poisson likelihood given b1. */

	if "`constant'"=="" {
		SolveC `y' `xb'`poff' [`weight'`exp'] `if', /*
		*/ n(`nobs') mean(`mean')
		tempname c
		scalar `c' = r(_cons)
		if `c'<. {
			local c "+`c'"
		}
		else	local c /* erase macro */

		LikePois `y' `xb'`poff'`c' [`weight'`exp'] `if', n(`nobs')
		tempname lnf1c
		scalar `lnf1c' = r(lnf)
	}
	else	local lnf1c .

	/* Take iteratively reweighted least-squares step to get b2. */

	capture {
		gen double `z' = `y'*exp(-(`xb'`poff'`c'))-1 /*
		*/ +`xb'`c' `if'

		`vv' ///
		_regress `z' `xvars' [aw=`wt'exp(`xb'`poff'`c')] `if', /*
		*/ `constant'
		mat `b2' = e(b)
		drop `xb'
		_predict double `xb' `if'

		LikePois `y' `xb'`poff' [`weight'`exp'] `if', n(`nobs')
		tempname lnf2
		scalar `lnf2' = r(lnf)
	}
	if _rc  local lnf2 . 
	if (`lnf1'>=. & `lnf1c'>=. & `lnf2'>=.)  exit 

	if `lnf2'<.&(`lnf2'>`lnf1'|`lnf1'>=.)&(`lnf2'>`lnf1c'|`lnf1c'>=.) {
		ret matrix b0 `b2' /* `lnf2' best */
		exit
	}
	if `lnf1'<.&(`lnf1'>`lnf1c'|`lnf1c'>=.)&(`lnf1'>`lnf2'|`lnf2'>=.) {
		ret matrix b0 `b1' /* `lnf1' best */
		exit
	}

	local dim = colsof(`b1')
	mat `b1'[1,`dim'] = `b1'[1,`dim']`c'
	ret matrix b0 `b1' /* `lnf1c' best */
end
