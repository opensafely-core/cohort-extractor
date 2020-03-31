*! version 1.4.1  22nov2016
program define tobit_14, eclass byable(onecall) prop(swml svyb svyj svyr)
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
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
		if _caller() < 9 | missing(e(version)) {
			_tobit `0'
		}
		else	Display `0'
		exit
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"tobit `0'"'
end

program Estimate, byable(recall) eclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"
	if _caller() > 9.2 {
		local wtypes iw pw
		local robopts VCE(passthru) Robust CLuster(varname)
	}
	quietly syntax varlist(ts fv) [aw fw `wtypes'] [if] [in] 	///
		[, Level(cilevel) 				///
		  NOCOEF 					///
		  `robopts' 					///
		   CRITTYPE(passthru) 				///
		   NOCONstant					///
		   * ]

	_get_diopts diopts options, `options'
	gettoken depvar rhs : varlist
	_fv_check_depvar `depvar'
	if "`noconstant'"!="" & "`rhs'"=="" {
                di as err /*
                */ "independent variables required with noconstant option"
                exit 100
	}

	if "`weight'" != "" {
		local wt [`weight'`exp']
		if "`weight'" == "pweight" {
			local iwt [iweight`exp']
			local robust robust
		}
		else	local iwt "`wt'"
	}
	marksample touse
	if _caller() > 9.2 {
		if `:length local vce' {
			// vce(oim) is the default
			_vce_parse `touse', old ///
				argopt(CLuster) opt(OIM Robust) ///
				: `wt', `vce' `robust' cluster(`cluster')
			if "`robust'" == "" {
				local robust `r(robust)'
			}
			local cluster `r(cluster)'
			local vce = cond("`r(vce)'" != "", "`r(vce)'", "oim")
		}
		else	local vce oim
		if "`robust'`cluster'" != "" & `"`crittype'"' == "" {
			local critopt crittype(log pseudolikelihood)
			local vce robust
		}
	}
	capture noisily `version' _tobit `varlist' `iwt' if `touse', ///
		nocoef `crittype' `critopt' `options' `noconstant'
	local rc = c(rc)
	if `rc' & `rc' != 430 {
		exit `rc'
	}
	if "`noconstant'" != "" {
		eret local constant "`noconstant'"
	}
	if "`nocoef'" == "" {
		if _caller() < 9 {
			_tobit, level(`level')
		}
		else {
			ereturn local marginsok	default		///
						XB		///
						Pr(passthru)	///
						E(passthru)	///
						YStar(passthru)
			ereturn local vce `vce'
			NewStripes `rc'
			if "`robust'`cluster'" != "" {
				_robust3 `wt', cluster(`cluster')
			}
			Display, level(`level') `diopts'
		}
	}
	exit `rc'
end

program Display
	version 9
	syntax [, Level(cilevel) *]
	_get_diopts options, `options'
	_coef_table_header
	di
	_coef_table, level(`level') notest `options'
	_prefix_footnote
end

program NewStripes, eclass
	version 11
	args rc
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	local depvar `e(depvar)'
	local colna : colna `b'
	local len : length local colna
	local colna : piece 1 `=`len'-3' of "`colna'"
	local colna `"`colna' _cons"'
	local dim = colsof(`b')
	forval i = 1/`=`dim'-1' {
		local coleq `coleq' model
	}
	local coleq `coleq' sigma
	matrix colname `b' = `colna'
	matrix coleq   `b' = `coleq'
	matrix colname `V' = `colna'
	matrix coleq   `V' = `coleq'
	matrix rowname `V' = `colna'
	matrix roweq   `V' = `coleq'
	_e2r
	tempvar touse
	gen byte `touse' = e(sample)
	ereturn post `b' `V' [`e(wtype)'`e(wexp)'],	///
		esample(`touse') depname(`depvar') buildfvinfo
	_r2e
	ereturn local title "Tobit regression"
	ereturn scalar k_aux = 1
	ereturn hidden scalar version = 2
	if !inlist("`e(wtype)'", "", "iweight") {
		local wt [`e(wtype)'`e(wexp)']
	}
	else if `"`e(wtype)'"' == "iweight" {
		quietly count if e(sample)
		ereturn scalar N = r(N)
		ereturn scalar df_r = r(N) - e(df_m)
	}
	if !missing(e(llopt)) {
		sum `depvar' `wt' if `depvar' <= e(llopt) & e(sample), mean
		ereturn scalar N_lc = r(N)
	}
	else	ereturn scalar N_lc = 0
	sum `depvar' `wt' if `depvar' >= e(ulopt) & e(sample), mean
	ereturn scalar N_rc = r(N)
	ereturn scalar N_unc = e(N) - e(N_lc) - e(N_rc)
	if missing(e(llopt)) {
		ereturn hidden local limit_l "-inf"
	}
	else {
		ereturn hidden local limit_l `e(llopt)'
	}
	if missing(e(ulopt)) {
		ereturn hidden local limit_u "+inf"
	}
	else {
		ereturn hidden local limit_u `e(ulopt)'
	}
	ereturn scalar chi2 = e(F)
	ereturn local chi2type LR
	ereturn local F
	if `rc' == 430 {
		ereturn scalar converged = 0
	}
	else	ereturn scalar converged = 1
	_post_vce_rank
	local df_m = `e(rank)' - 1 - cond("`e(constant)'"=="",1,0)
	ereturn scalar df_m = `df_m'
	ereturn scalar df_r = e(N) - e(df_m)
end

program CheckCollinear
	syntax varlist
	gettoken depvar xvars : varlist
	local coef : colna e(b)
	local cl : list xvars - coef
	if "`cl'" != "" {
		di as txt "note: `cl' dropped because of collinearity"
	}
end

exit
