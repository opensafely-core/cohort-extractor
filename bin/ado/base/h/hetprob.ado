*! version 3.15.0  08mar2017
program define hetprob, eclass byable(onecall) prop(ml_score svyb svyj svyr)
	if (_caller() < 13) {
		if _by() {
			local BY `"by `_byvars'`_byrc0':"'
		}
		`BY' _vce_parserun hetprob, mark(CLuster) : `0'
		if "`s(exit)'" != "" {
			version 10: ereturn local cmdline `"hetprob `0'"'
			exit
		}
		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		version 6, missing
		if replay() {
			if "`e(cmd)'" != "hetprob" {
				error 301
			}
			if _by() { error 190 }
			Display `0'
			exit
		}
		est clear
		`vv' `BY' Estimate `0'
		version 10: ereturn local cmdline `"hetprob `0'"'
	}
	else {
		if _by() {
			local BY `"by `_byvars'`_byrc0':"'
		}
		`BY' _vce_parserun hetprobit, mark(OFFset CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"hetprobit `0'"'
			ereturn local cmd hetprobit
			exit
		}
		if replay() {
			if _by() {
				error 190
			}
			if("`e(cmd)'"=="hetprob") {
				Display `0'
				exit
			}
			if("`e(cmd)'"!="hetprobit" ) {
				error 301
			}
			hetprobit `0'
			exit
		}
		`BY' hetprobit `0'
		ereturn local cmdline `"hetprobit `0'"'
		ereturn local cmd hetprobit
	}
end

program define Estimate, eclass byable(recall)
	version 6, missing
	syntax varlist(ts fv) [if] [in] [fweight pweight iweight] , /*
		*/ het(string)  [Robust CLuster(varname numeric) /*
		*/ SCore(string) OFFset(varname numeric) /*
		*/ FROM(string) noCONstant NOLOg LOg noSKIP noLRtest /*
		*/ Level(cilevel) MLMethod(string) ASIS DIFficult /*
		*/ DOOPT VCE(passthru) * ]
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}


	/* force difficult option in full model */
	local diff "difficult"
	local p_vars `varlist'
	_get_diopts diopts options, `options'
	mlopts mlopt, `options'
	local coll `s(collinear)'
	local cns `s(constraints)'
	local p_off `offset'
	local p_cons `constan' 

	marksample touse

	if "`weight'" != "" { local wgt [`weight'`exp'] }
	if "`cluster'" != "" { local clopt "cluster(`cluster')" }
        _vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                [`weight'`exp'], `vce' `clopt' `robust'
        local cluster `r(cluster)'
        local robust `r(robust)'
	if "`cluster'" != "" { local clopt "cluster(`cluster')" }
	if "`score'" != "" {
		local wcount : word count `score'
		if `wcount'==1 & bsubstr("`score'",-1,1)=="*" { 
			local score = /*
			*/ bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 
			local wcount 2
		}
		if `wcount' != 2 {
			di in red "score() requires two new variable names"
			exit 198
		}
		local s1 : word 1 of `score'
		local s2 : word 2 of `score'
		confirm new var `s1' `s2'
		tempvar sc1 sc2
		local scopt "score(`sc1' `sc2')"
	}

	local 0 `het'
	syntax varlist(numeric min=1 ts fv) [, OFFset(varname numeric) /*
			*/	noCONstant *]
	
	if !`fvops' {
		local fvops = "`s(fvops)'" == "true"
	}
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
		local fvexp expand
		if "`cns'" != "" {
			local cnsopt constraint(`cns') `coll'
		}
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	if "`mlmethod'" == "" {
		local mlmetho `mm'
	}

	local heti `varlist'
	local hetf `offset'
	local offset ""

	markout `touse' `cluster' `offset' `heti' `hetf', strok
	`vv' ///
	_rmcoll `heti' if `touse', constant `coll' `fvexp'
	local heti "`r(varlist)'"

/* Check hetero arguments */
	if "`constan'`options'" != "" {
		noi di in red "Heteroskedastic option(s) not permitted: " _c
		noi di in red "`constan' `options'"
		exit 101
	}

/* process hetero offset */
	if "`hetf'" != "" {
		local hetoff "offset(`hetf')"
		markout `touse' `hetf'
	}

/* Check predictor equation */
	tokenize `p_vars'
	local dep `1'
	_fv_check_depvar `dep'
	tsunab dep : `dep'
	local depn : subinstr local dep "." "_"
	mac shift
	local ind `*'
	if "`p_cons'" == "noconstant" & "`ind'" == "" {
		noi di in red "independent varlist required with " _c
		noi di in red "noconstant option."
		exit 100
	}

/* process predictor offset */
	if "`p_off'" != "" {
		local offset "offset(`p_off')"
		markout `touse' `p_off'
	}


/* check independent variables for collinearity */
	`vv' ///
	noi _rmcoll `ind' if `touse', `p_cons' `coll' `fvexp'
	local ind "`r(varlist)'"
 
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" { 
		local log quietly 
	}
	else {
		local log noisily
	}

	if "`asis'`coll'" == "" {
		`log' di
		if _caller() >= 11 {
			local warn nowarning
		}
		`vv' ///
		`log' probit `dep' `ind' `wgt' if `touse', ///
			iter(0) nocoef nolog `doopt' `warn'
		qui replace `touse' = e(sample)
		tempname lb
		mat `lb' = e(b)
		local ind : colnames(`lb')
		tokenize `ind'
		local last : word count `ind'
		if "``last''" == "_cons" { local `last' }
		local ind "`*'"
	}
	else {
		`log' di
	}

	qui count if `touse'
	local nobs = r(N)
	qui count if `dep' == 0 & `touse'
	local nneg = r(N)
	local npos = `nobs' - `nneg'
	if r(N) == 0 | r(N) == `nobs' {
		noi di in red "outcome does not vary; remember:"
		noi di in red _col(35) "0 = negative outcome,"
		noi di in red _col(9) /*
		*/ "all other nonmissing values = positive outcome"
		exit 2000
	}

/* output options */
	if "`robust'`cluster'" != "" | "`weight'" == "pweight" {
		local robust "robust"
	}

	if "`ind'" == "" | "`robust'`p_cons'" != "" {
		local skip ""
	}

	if "`robust'" != "" {
		local lrtest nolrtest
	}


	if "`from'" != "" {
		local init "init(`init')"
	}

/* code for LR test of full model with hetero vs. full model no hetero */
	local lr_OK 0
	if "`lrtest'" == "" {
		tempname ll_c chi2_c
		* compute full probit without heteroskedastic equation

		`log' di in gr "Fitting probit model:"
		`vv' ///
		`log' capture `log' probit `dep' `ind' `wgt' if `touse', /*
				*/ `p_cons' `offset' nocoef asis /*
				*/ iter(`=min(1000,c(maxiter))') `doopt' /*
				*/ `cnsopt' `mllog'
		if _rc == 0 {
			scalar `ll_c' = e(ll)        
			scalar `chi2_c' = e(chi2)    
			if "`init'" == "" & `ll_c' < . { 
				local lr_OK 1
				tempname myb 
				mat `myb' = get(_b)
				mat coleq `myb' = `depn'
				local init "init(`myb', skip)"
			}
		}
	}

/* constant only model */
	if "`skip'" != "" {
		local continu "continue"

		/* starting values from nonhetero probit */
		tempname p_1 p_2 Ival
		`vv' ///
		quietly probit `dep' if `touse' `wgt', `offset' `doopt' /*
			*/ `cnsopt'
		local fulll = e(ll)
		capture matrix `p_1' = e(b)
		if _rc {
			local confrom ""
		}
		else {
			matrix coleq `p_1' = `dep':
			local rcount : word count `heti'
			matrix `p_2' = J(1,`rcount',0)
			`vv' ///
			mat colnames `p_2' = `heti'
			mat coleq `p_2' = lnsigma2
			mat `Ival' = `p_1', `p_2'
			local confrom "init(`Ival', copy)"
		}
        
		`log' di _n in gr "Fitting constant-only model:"
		#delimit ;
		`vv'
		`log' ml model `mlmethod' hetpr_lf 
			(`depn': `dep' = , `offset') 
			(lnsigma2: = `heti', nocons `hetoff') 
			if `touse' `wgt', 
			`confrom' max missing nopreserve wald(0) `mlopt'
			nooutput search(off) `diff' nocnsnotes `negh' `mllog';
		#delimit cr

		/* use info for good starting values */
		if "`init'" == "" { 
			tempname myh
			mat `myh' = e(b)
			local init "init(`myh')"
		}

	}
	else {
		local continu "wald(1)"
	}

	if "`from'" != "" {
		local init "init(`from')"
	}


	`log' display _n in gr "Fitting full model:"
	#delimit ;
	`vv'
	`log' ml model `mlmethod' hetpr_lf 
		(`depn': `dep' = `ind', `p_cons' `offset') 
		(lnsigma2: `heti', nocons `hetoff') if `touse' `wgt', 
		max missing nopreserve `mlopt'
		`continu' search(off)
		`clopt' `scopt' `robust' nooutput `init'
		title(Heteroskedastic probit model) `diff' `negh' `mllog';
	#delimit cr
	* if "`log'" == "quietly" { di _n }

	if "`scopt'" != "" {
		rename `sc1' `s1'
		if "`s2'" != "" {
			rename `sc2' `s2'
		}
		est local scorevars `s1' `s2'
	}

	if "`lrtest'`cns'" == "" {
		est scalar ll_c =  `ll_c'       
		est scalar chi2_c = 2*(e(ll) - e(ll_c)) 
		if "`p_cons'" == "noconstant" {
			local fulldof = e(rank)-e(df_m)
		}
		else{ 
			local fulldof = e(rank)-e(df_m)-1
		}
		est scalar df_m_c = `fulldof'
		est scalar p_c = chiprob(e(df_m_c),e(chi2_c))
		est local chi2_ct "LR"
	}
	else {
		qui test [lnsigma2]
		est scalar chi2_c = r(chi2)
		est scalar df_m_c = r(df)
		est scalar p_c    = r(p)
		est local chi2_ct "Wald"
	}

	est scalar N_s = `npos'
	est scalar N_f = `nneg'

	est local method "ml"
	est local predict "hetpr_p"
	est local cmd "hetprob"

	Display, level(`level') `lrtest' `diopts'
end

program define Display
	if "`e(prefix)'" == "svy" {
		_prefix_display `0'
		exit
	}
	syntax [, Level(cilevel) noLRtest *]

	_get_diopts diopts, `options'
	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

	di in gr _n "Heteroskedastic probit model" _col(49) /*
		*/ "Number of obs     =" in ye _col(70) %9.0g e(N)
	di in gr _col(49) "Zero outcomes     =" /*
		*/ in ye _col(70) %9.0g e(N_f) 
	di in gr _col(49) "Nonzero outcomes  =" /*
		*/ in ye _col(70) %9.0g e(N_s) _n
	if !missing(e(df_r)) {
		di in gr _col(49) "F(" %4.0f in ye `e(df_m)' /*
			*/ in gr "," in ye %7.0f e(df_r) /*
			*/ in gr ")" _col(67) "=" in ye _col(70) %9.2f e(F) 
		di in gr "`crtype' = " in ye %9.0g e(ll) /*
			*/ in gr _col(49) "Prob > F" _col(67) "=" /*
			*/ in ye _col(70) /*
			*/ in ye %9.4f Ftail(e(df_m),e(df_r),e(F)) _n
	}
	else {
		if "`e(chi2type)'" == "Wald" & missing(e(chi2)) {
			di in smcl _col(49) 				/*
*/ "{help j_robustsingular##|_new:Wald chi2(`e(df_m)'){col 67}= }"	/*
*/				in ye _col(70) %9.2f e(chi2)
		}
		else {
		      di in gr _col(49) "`e(chi2type)' chi2(" in ye `e(df_m)' /*
			*/ in gr ")" _col(67) "=" in ye _col(70) %9.2f e(chi2) 
		}
		di in gr "`crtype' = " in ye %9.0g e(ll) /*
			*/ in gr _col(49) "Prob > chi2" _col(67) "=" /*
			*/ in ye _col(70) /*
			*/ in ye %9.4f chiprob(e(df_m),e(chi2)) _n
	}

	version 10: ml di, noheader level(`level') `diopts'
	
	if "`e(chi2_ct)'" == "LR" {
		local txt "LR"
	}
	else {
		local txt Wald
	}
	
	local chi : di %8.2f e(chi2_c)
	local chi = trim("`chi'")
	
	di in green "`txt' test of lnsigma2=0: " _c ///
		"chi2(" in ye "`e(df_m_c)'" in gr ") = " in ye `chi' _c ///
		in green _col(59) "Prob > chi2 = " in ye %6.4f ///
		chiprob(e(df_m_c),e(chi2_c)) _n
end
exit

Note:  The above could be coupled with the _crcshdr.ado code if we save some
       additional words -- right now that program uses "Censored" and 
       "Uncensored" instead of what we want here "Positive" and "Negative".
