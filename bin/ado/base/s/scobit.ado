*! version 1.12.1  19dec2018
program define scobit, eclass byable(onecall) ///
		prop(ml_score or swml svyb svyj svyr)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun scobit, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"scobit `0'"'
		exit
	}

	version 6, missing
	if replay() {
		if "`e(cmd)'"!="scobit" { error 301 }
		if _by() { error 190 }
		Display `0'
		error `e(rc)'
		exit
	}
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"scobit `0'"'
end

program define Estimate, eclass byable(recall)
	version 6, missing
	syntax varlist(numeric fv) [if] [in] [fw iw pw] [, OR ASIS /*
	*/ FROM(string) Level(cilevel) noCONstant Robust CLuster(varname) /*
	*/ OFFset(varname numeric) SCore(string) NOLOg LOg doopt /*
	*/ VCE(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() { 
		_byoptnotallowed score() `"`score'"'
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local cns `s(constraints)'

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
		local nword : word count `score'
		if `nword' != 2 {
			di in red "score() must contain the name of " /*
			*/ "two new variables"
			exit 198
		}
		local scname1 : word 1 of `score'
		local scname2 : word 2 of `score'
		tempvar scvar1 scvar2
		local scopt "score(`scvar1' `scvar2')"
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
	if "`offset'"!="" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
	}
	if "`robust'" != "" {
		/* probit does not allow iweights and robust so use crittype
		 * instead of robust option */
		local crtype crittype("log pseudolikelihood")
	}

/* Count obs and check values of `y'. */

	gettoken y xvars : varlist
	_fv_check_depvar `y'

	qui count if `touse'
	local N `r(N)'

	if `N' == 0 { error 2000 }
	if `N' == 1 { error 2001 }

	qui count if `y'==0 & `touse'
	if r(N)==0 | r(N)==`N' {
		di in red "outcome does not vary; remember:"
		di in red _col(35) "0 = negative outcome,"
		di in red _col(9) /*
		*/ "all other nonmissing values = positive outcome"
                exit 2000
        }

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"!="" {
		local qui "quietly"
	}

	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
		local NOWARN nowarn
		if "`cns'" != "" {
			local cnsopt constraint(`cns') `coll'
		}
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}

/* Run logistic to drop any variables and observations. */

	if "`asis'"=="" {
		`vv' ///
		`qui' logit `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ iter(0) `offopt' nocoef nolog `constan' `crtype' /*
		*/ `cnsopt' `NOWARN'
		qui replace `touse' = e(sample)
		_evlist
		local xvars `s(varlist)'
		tempname lb
	}

/* Estimate logistic model. */

	if "`from'"=="" {
		if "`robust'`cns'`cluster'"!="" | "`weight'"=="pweight" {
			local nowarn  "nowarn"
		}
		else {
			tempname llp
		}
		`qui' di _n in gr "Fitting logistic model:"

		`vv' ///
		`qui' logit `y' `xvars' [`weight'`exp'] if `touse', /*
		*/ `offopt' nocoef asis `constan' `crtype' /*
		*/ iter(`=min(1000,c(maxiter))') `cnsopt' `doopt' `mllog'

		if "`llp'"!="" { scalar `llp' = e(ll) }

		tempname from
		mat `from' = e(b)
		mat coleq `from' = `y'
	}

/* Estimate full model. */

	`qui' di _n in gr "Fitting full model:"

	`vv' ///
	ml model `mm' scob_lf (`y': `y' = `xvars', `constan' `offopt') /*
	*/ /lnalpha /*
	*/ [`weight'`exp'] if `touse', collinear missing max nooutput /*
	*/ nopreserve init(`from') search(off) `vceopt' `scopt' /*
	*/ `mllog' waldtest(0) `mlopts' title(Skewed logistic regression)	/*
	*/ diparm(lnalpha, label(alpha) exp) `negh'

	est local cmd

	qui count if `y'==0 & `touse'
	est scalar N_f = r(N)
	est scalar N_s = e(N) - e(N_f)
	est scalar k_aux = 1
	est scalar alpha = exp(_b[/lnalpha])
	
	if (`"`e(k_eq_model)'"' != "") {
		est hidden scalar k_eq_model = `e(k_eq_model)'
	}
	if "`score'"!="" {
		label var `scvar1' "Score index for x*b from scobit"
		rename `scvar1' `scname1'
		label var `scvar2' /*
			*/ "Score index for /lnalpha from scobit"
		rename `scvar2' `scname2'
		est local scorevars `scname1' `scname2'
	}

	if "`llp'"!="" {
		est local chi2_ct "LR"
		est scalar ll_c = `llp'
		if e(ll) < e(ll_c) & reldif(e(ll),e(ll_c)) < 1e-5 {
			est scalar chi2_c = 0
				/* otherwise, let it be negative when
				   it does not converge
				*/
		}
		else	est scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	est local offset1
	est local offset "`offset'"
	est local footnote scobit_footnote

	est local predict "scob_p"
        est local cmd     "scobit"
	_post_vce_rank

	Display, `or' level(`level') `nowarn' `diopts'
	error `e(rc)'
end

program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) OR NOwarn *]

	_get_diopts diopts, `options'
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

       	di in gr _n "`e(title)'" _col(49) "Number of obs     =" /*
	*/ in ye _col(69) %10.0gc e(N) _n /*
	*/ in gr _col(49) "Zero outcomes     =" /*
       	*/ in ye _col(69) %10.0gc e(N_f) _n /*
       	*/ in gr "`crtype' = " in ye %9.0g e(ll) /*
       	*/ in gr _col(49) "Nonzero outcomes  =" /*
       	*/ in ye _col(69) %10.0gc e(N_s) _n

	version 12:	///
	ml di, noheader level(`level') `or' nofootnote `diopts'
	_prefix_footnote, `nowarn'
end
