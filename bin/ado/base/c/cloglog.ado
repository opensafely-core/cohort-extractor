*! version 1.13.1  19feb2019
program define cloglog, eclass byable(onecall)	///
			prop(ml_score swml svyb svyj svyr mi bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun cloglog, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"cloglog `0'"'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 6, missing
	if replay() {
		if "`e(cmd)'" != "cloglog" { error 301 }
		if _by() { error 190 }
		Display `0'
		error `e(rc)'
		exit
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"cloglog `0'"'
end

program Estimate, eclass byable(recall)
	version 6, missing
/* Parse. */

	syntax varlist(numeric ts fv) [if] [in] [fw iw pw] [, ASIS doopt /* 
	*/ FROM(string)  Level(cilevel) noCONstant Robust CLuster(varname) /*
	*/ OFFset(varname numeric) SCore(string) NOLOg LOg noDISPLAY EForm /*
	*/ moptobj(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 

	if `"`robust'"' != "" | `"`cluster'"' != "" | /*
	*/ `"`weight'"' == "pweight" {
		local crtype crittype("log pseudolikelihood")
	}
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `log' `nolog'
	local coll `s(collinear)'
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
		local cnsopt "`s(constraints)'"
		if `:length local cnsopt' {
			local cnsopt constraints(`cnsopt') `coll'
		}
		local nowarn nowarn
	}
	else {
		local vv "version 8.1:"
		local mm d2
		local doopt	// ignore this option
	}

/* Check syntax. */

	if `"`score'"'!="" {
		confirm new variable `score'
		local nword : word count `score'
		if `nword' > 1 {
			di in red "score() must contain the name of only" /*
			*/ " one new variable"
			exit 198
		}
		tempvar scvar
		local scopt "score(`scvar')"
	}
	if "`constan'"!="" {
		local nvar : word count `varlist'"
		if `nvar' == 1 {
			di in red "independent variables required with " /*
			*/ "noconstant option"
			exit 102
		}
	}

/* Mark sample. */

	marksample touse

	if `"`cluster'"'!="" {
		markout `touse' `cluster', strok
		local clopt cluster(`cluster')
	}
	if "`offset'"!="" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
	}

/* Count obs and check values of `y'. */

	gettoken y xvars : varlist
	_fv_check_depvar `y'
	
	tsunab yname : `y'
	loc yname : subinstr local yname "." "_"

	qui count if `touse'
	local n `r(N)'

	if `n' == 0 { error 2000 }
	if `n' == 1 { error 2001 }

	qui count if `y'==0 & `touse'
	local n0 `r(N)'
	if `n0'==0 | `n0'==`n' {
		di in red "outcome does not vary; remember:"
		di in red _col(35) "0 = negative outcome,"
		di in red _col(9) /*
		*/ "all other nonmissing values = positive outcome"
                exit 2000
        }

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" | "`display'"!="" {
		local qui "quietly"
	}

/* If there are negative iweights, -logit- cannot be used. */

	local nonegwt 1

	if "`weight'"!="" {
		if "`weight'"=="pweight" { /* pweights create unneeded
		                              extra work when getting
					      initial values, etc.
					   */
			local wtype "iweight"
		}
		else local wtype "`weight'"

		if "`weight'"=="iweight" {
			tempname sumw
			tempvar w
			qui gen double `w' `exp' if `touse'
			summarize `w' if `touse', meanonly
			scalar `sumw' = r(sum)
			if `sumw' <= 0 {
				di in red "sum of weights less than " /*
				*/ "or equal to zero"
				exit 402
			}
			if r(min) < 0 { local nonegwt 0 }
		}
	}

/* Remove collinearity. */

	`vv' ///
	_rmcoll `xvars' [`weight'`exp'] if `touse', `constan' `coll'
	local xvars `r(varlist)' 

/* Run logit to drop any variables and observations. */
	
	if "`asis'`coll'"=="" & `nonegwt' {
		`vv' ///
		logit `y' `xvars' [`wtype'`exp'] if `touse', /*
		*/ iter(0) `offopt' nocoef nolog `constan' `nowarn'
		qui replace `touse' = e(sample)
		_evlist
		local xvars `s(varlist)'
	}

/* Estimate logit model for starting values. */

	if `"`from'`coll'"'=="" & "`xvars'"!="" & `nonegwt' {
		`vv' ///
		quietly logit `y' `xvars' [`wtype'`exp'] if `touse', /*
		*/ `offopt' asis `constan' iter(3) `cnsopt' nocoef /*
		*/ `doopt'

		tempname b0
		mat `b0' = e(b)
		mat coleq `b0' = `y'
	}

/* Compute constant-only model. */

	if "`constan'"=="" {
		if "`offset'"=="" { /* analytic solution */
			tempname z lnf
			if "`weight'"=="" {
				scalar `z' = ln(ln(`n'/`n0'))
			}
			else {
				if "`w'"=="" {
					tempname sumw
					tempvar w
					qui gen double `w' `exp' if `touse'
					summarize `w' if `touse', meanonly
					scalar `sumw' = r(sum)
				}
				summarize `w' if `y'==0 & `touse', meanonly
				scalar `z' = ln(ln(`sumw'/r(sum)))
				if `z'>=. {
					di in red "impossible to compute " /*
					*/ "likelihood because of " /*
					*/ "negative weights"
					exit 402
				}
				local w "`w'*"
			}

			qui gen double `lnf' = `w'cond(`y', cond(`z'>100, 0, /*
			*/ cond(`z'<-12, `z'-(exp(`z')/2)*(-expm1(`z')/12), /*
			*/ ln(-expm1(-exp(`z'))))), -exp(`z')) if `touse'

			summarize `lnf', meanonly
			local lf0 "lf0(1 `r(sum)')"

			if "`xvars'"=="" {
				tempname b0
				mat `b0' = (0)
				mat `b0'[1,1] = `z'
				mat colnames `b0' = `y':_cons
			}
		}
		else if `"`from'"'=="" {
			`qui' di in gr _n "Fitting constant-only model:"

			`vv' ///
			ml model `mm' clog_lf 				    /*
			*/ (`yname': `y'=, `constan' `offopt') 		    /*
			*/ if `touse' [`wtype'`exp'], collinear missing max /*
			*/ nooutput nopreserve wald(0) search(off) `mlopts' /*
			*/ `crtype' nocnsnotes `negh'

			local continu "continue"

			`qui' di in gr _n "Fitting full model:"
		}
	}

/* Fit full model. */

	if `"`from'"'!=""  { local initopt `"init(`from')"' }
	else if "`b0'"!="" { local initopt "init(`b0', copy)" }

	`vv' ///
	ml model `mm' clog_lf (`yname': `y'=`xvars', `constan' `offopt')/*
	*/ if `touse' [`weight'`exp'], collinear missing max nooutput 	/*
	*/ nopreserve `initopt' `lf0' search(off) `mlopts'	 	/*
	*/ `scopt' `robust' `clopt' `continu' 				/*
	*/ title(Complementary log-log regression) `negh' `moptobj'

	est local cmd

        if "`score'" != "" {
		label var `scvar' "Score index for x*b from cloglog"
		rename `scvar' `score'
		est local scorevars `score'
	}

	if "`weight'" == "fweight" {
		tempvar tmpsum
		qui gen double `tmpsum' `exp' if `touse' & `y' == 0
		summarize `tmpsum' if `touse' & `y' == 0 , meanonly
		est scalar N_f = r(sum)
	}
	else {
		qui count if `touse' & `y' == 0
		est scalar N_f = r(N)
	}
	est scalar N_s = e(N) - e(N_f)

	est local offset1
	est local offset  "`offset'"
	est local marginsnotok stdp SCore
	est local marginsok default Pr
	est hidden local marginsderiv default Pr
	est local predict "clog_p"
	est local cmd     "cloglog"

	if "`display'"=="" {
		Display, level(`level') `eform' `diopts'
	}
	error `e(rc)'
end

program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, EForm *]

	_get_diopts diopts, `options'
	if "`eform'"!="" {
		local eopt "eform(exp(b))"
	}

	if e(chi2) < 1e5 {
		local fmt "%9.2f"
	}
	else 	local fmt "%9.2e"

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)
	if !missing(e(df_r)) {
        	di in gr _n "`e(title)'" _col(49) "Number of obs     =" /*
		*/ in ye _col(69) %10.0fc e(N) _n /*
		*/ in gr _col(49) "Zero outcomes     =" /*
        	*/ in ye _col(69) %10.0fc e(N_f) _n /*
		*/ in gr _col(49) "Nonzero outcomes  =" /*
        	*/ in ye _col(69) %10.0fc e(N_s) _n(2) /*
        	*/ in gr _col(49) "F(" in ye %4.0f `e(df_m)' /*
        	*/ in gr " ," in ye %7.0f e(df_r) /*
        	*/ in gr ")" _col(67) "=" in ye _col(70) %9.2f e(F) _n /*
        	*/ in gr "`crtype' = " in ye %10.0g e(ll) /*
        	*/ in gr _col(49) "Prob > F" _col(67) "=" in ye _col(70) /*
        	*/ in ye %9.4f Ftail(e(df_m),e(df_r),e(F)) _n
	}
	else {
        	di in gr _n "`e(title)'" _col(49) "Number of obs     =" /*
		*/ in ye _col(69) %10.0fc e(N) _n /*
		*/ in gr _col(49) "Zero outcomes     =" /*
        	*/ in ye _col(69) %10.0fc e(N_f) _n /*
		*/ in gr _col(49) "Nonzero outcomes  =" /*
        	*/ in ye _col(69) %10.0fc e(N_s) _n(2) /*
        	*/ in gr _col(49) "`e(chi2type)' chi2(" in ye `e(df_m)' /*
        	*/ in gr ")" _col(67) "=" in ye _col(70) `fmt' e(chi2) _n /*
        	*/ in gr "`crtype' = " in ye %10.0g e(ll) /*
        	*/ in gr _col(49) "Prob > chi2" _col(67) "=" in ye _col(70) /*
        	*/ in ye %9.4f chiprob(e(df_m),e(chi2)) _n
	}

	version 9: ml di, noheader first `diopts' nofootnote `eopt'
	_prefix_footnote
end
