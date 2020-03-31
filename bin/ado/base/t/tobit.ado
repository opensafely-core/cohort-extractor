*! version 2.1.0  03dec2018
program define tobit, eclass byable(onecall) prop(swml svyb svyj svyr bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 15 {
		`BY' tobit_14 `0'
		exit
	}

	version 15
	local version : di "version " string(_caller()) ":"
	syntax [anything] [aw fw iw pw] [if] [in] [, VCE(passthru) * ]
	if `:length local vce' {
		`version' ///
		`BY' _vce_parserun tobit, mark(OFFset) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"tobit `0'"'
			exit
		}
	}
	if replay() {
		if "`e(cmd)'" != "tobit" {
			error 301
		}
		if _by() {
			error 190
		}
		else	Display `0'
		exit
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"tobit `0'"'
end

program Estimate, byable(recall) eclass
	version 15
	syntax varlist(ts fv) [fw iw pw aw] [if] [in] 		///
		[, ll(string) ul(string) LL1 UL1 noCONstant 	///
		FROM(passthru) CONSTraints(passthru) vce(passthru) *]

	gettoken depvar rhs : varlist
	_fv_check_depvar `depvar'
	
	if "`ll'" != "" & "`ll1'" != "" {
		di as err "only one of {bf:ll} or {bf:ll()} is allowed"
		exit 198
	}
	if "`ul'" != "" & "`ul1'" != "" {
		di as err "only one of {bf:ul} or {bf:ul()} is allowed"
		exit 198
	}
	
	marksample touse
	
	if "`ll1'" != "" | "`ul1'" != "" {
		qui su `depvar' if `touse', meanonly
		if "`ll1'" != "" local ll `r(min)'
		if "`ul1'" != "" local ul `r(max)'
	}
	
	_chk_limit "`ll'" "ll()"
	local ll `s(lmt)'
	_chk_limit "`ul'" "ul()"
	local ul `s(lmt)'
	
	if "`ll'" != "" & "`ul'" != "" {
		capture assert `ll' <= `ul'
		if _rc {
			di as err "observations with {bf:ll()} > {bf:ul()}" ///
				" not allowed"
			exit 198
		}
	}
	
	if "`weight'" != "" local wopt [`weight'`exp']

	local rr = !("`weight'" == "pweight")
	local vceopt = `:length local vce'
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(OIM OPG Robust) ///
			: [`weight'`exp'], `vce'
		local rr = `rr' & !("`r(robust)'" == "robust")
	}
	
	local hascons = cond("`constant'"=="",1,0)
	local xs : list sizeof rhs
	local lr = `hascons' & `xs' & `rr'
	tempname est0
	qui gsem `depvar' <- `wopt' if `touse', `constant' ///
		family(gaussian, lc(`ll') rc(`ul')) `options' nocapslatent
	local ll_0 `e(ll)'
	est store `est0'
	
	gsem `depvar' <- `rhs' `wopt' if `touse', `constant'	///
		family(gaussian, lc(`ll') rc(`ul')) `from'	///
		`constraints' `vce' `options' notable noheader nocapslatent

	local df_m = `e(rank)' - 1 - `hascons'
	ereturn scalar df_m = `df_m'
	ereturn scalar df_r = e(N) - e(df_m)
	ereturn hidden scalar k_eq_model = 1
	ereturn local margins_check_est
	ereturn local covariates
	
	if !missing("`e(ll)'") & !missing("`ll_0'") {
		ereturn scalar r2_p = 1 - e(ll)/`ll_0'
		ereturn scalar ll_0 = `ll_0'
	}

	if `lr' {		
		capture lrtest `est0' .
		if !_rc {
			ereturn scalar p = r(p)
			ereturn scalar chi2 = r(chi2)
		}
		ereturn local chi2type LR
	}
	else {
		_prefix_model_test
	}
	
	ereturn local title "Tobit regression"
	ereturn local cmd tobit
	ereturn local predict tobit_p
	ereturn local estat_cmd
	ereturn local llopt `ll'
	ereturn local ulopt `ul'
	if missing("`ll'") {
		ereturn hidden local limit_l "-inf"
	}
	else {
		ereturn hidden local limit_l `ll'
	}
	if missing("`ul'") {
		ereturn hidden local limit_u "+inf"
	}
	else {
		ereturn hidden local limit_u `ul'
	}
	ereturn local marginsok	default	XB		///
					Pr(passthru)	///
					E(passthru)	///
					YStar(passthru)
	ereturn local marginsnotok
	ereturn local marginsdefault
	ereturn local marginsprop
	
	ereturn scalar k_aux = 1
	ereturn hidden scalar version = 3
	
	if missing("`ul'`ll'") {
		ereturn scalar N_unc = `e(N)'
		ereturn scalar N_lc  = 0
		ereturn scalar N_rc  = 0
	}
	else {
		tempname cmat
		mat `cmat' = e(yinfo1_cens_info)
		ereturn scalar N_unc = `cmat'[1,1]
		ereturn scalar N_lc  = `cmat'[1,2]
		ereturn scalar N_rc  = `cmat'[1,3]
	}
	
	ereturn hidden scalar k_rc = 0
	ereturn hidden scalar k_rs = 1
	ereturn hidden scalar N_groups = 1
	ereturn hidden local link1 "identity"
	local family1 `e(family1)'
	ereturn hidden local family1 "`family1'"
	tempname m
	mat `m' = e(_N)
	ereturn hidden matrix _N = `m'
	mat `m' = e(b_pclass)
	ereturn hidden matrix b_pclass = `m'
	
	ereturn local offset `e(offset1)'
	ereturn hidden local offset1 `e(offset1)'
	ereturn hidden local eqnames `e(eqnames)'
	ereturn hidden local eqnames `e(footnote)'
	
	_get_diopts diopts options, `options'
	Display, `diopts'
end

program _chk_limit, sclass
	args limit name
	if missing("`limit'") | "`limit'"=="." {
		sreturn local lmt
		exit
	}
	capture confirm numeric variable `limit'
	local rc1 = _rc
	if `rc1' {
		capture confirm number `limit'
		local rc2 = _rc
		capture local x = `limit'
		capture confirm number `x'
		local rc3 = _rc
		if `rc2' & `rc3' {
			di "{err}invalid option {bf:`name'}"
			exit 198
		}
		else {
			if `rc2' local lmt `x'
			else	 local lmt `limit'
			local rc1 0
		}
		if `rc1' {
			di `"{err}variable {bf:`limit'} not found"'
			exit 198
		}
	}
	else local lmt `limit'
	sreturn local lmt "`lmt'"
end

program Display
	syntax [, Level(cilevel) *]
	_get_diopts options, `options'
	_coef_table_header
	di
	_coef_table, level(`level') notest `options'
	_prefix_footnote
end

exit
