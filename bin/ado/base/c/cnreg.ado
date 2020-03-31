*! version 1.5.0  24oct2017
program define cnreg, eclass byable(onecall) prop(swml svyb svyj svyr)
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	syntax [anything] [aw fw iw pw] [if] [in] [, VCE(passthru) * ]
	if `:length local vce' {
		`BY' _vce_parserun cnreg, mark(CENsored OFFset) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"cnreg `0'"'
			exit
		}
	}
	if replay() {
		if "`e(cmd)'" != "cnreg" {
			error 301
		}
		if _by() {
			error 190
		}
		if _caller() < 9 | missing(e(version)) {
			_cnreg `0'
		}
		else	Display `0'
		exit
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"cnreg `0'"'
end

program Estimate, byable(recall) eclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"
	if _caller() > 9.2 {
		local wtypes iw pw
		local robopts VCE(passthru) Robust CLuster(varname)
	}
	quietly syntax varlist [aw fw `wtypes'] [if] [in] 	///
		[, Level(cilevel) 				///
		   NOCOEF 					///
		   `robopts' 					///
		   CRITTYPE(passthru) 				///
		   NOCONstant					///
		   * ]

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
	capture noisily `version' _cnreg `varlist' `iwt' if `touse', ///
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
			_cnreg, level(`level')
		}
		else {
			ereturn local vce `vce'
			NewStripes `rc'
			if "`robust'`cluster'" != "" {
				_robust3 `wt', cluster(`cluster')
			}
			Display, level(`level')
		}
	}
	exit `rc'
end

program Display
	version 9
	syntax [, Level(cilevel) ]
	_coef_table_header
	di
	_coef_table, level(`level') notest
	_prefix_footnote
end

program NewStripes, eclass
	version 9
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
	ereturn post `b' `V', esample(`touse') depname(`depvar')
	_r2e
	ereturn local title "Censored-normal regression"
	ereturn scalar k_aux = 1
	ereturn scalar version = 2
	if !inlist("`e(wtype)'", "", "iweight") {
		local wt [`e(wtype)'`e(wexp)']
	}
	else if `"`e(wtype)'"' == "iweight" {
		quietly count if e(sample)
		ereturn scalar N = r(N)
		ereturn scalar df_r = r(N) - e(df_m)
	}
	sum `depvar' `wt' if `e(censored)' == -1 & e(sample), mean
	ereturn scalar N_lc = r(N)
	sum `depvar' `wt' if `e(censored)' == 1 & e(sample), mean
	ereturn scalar N_rc = r(N)
	ereturn scalar N_unc = e(N) - e(N_lc) - e(N_rc)
	ereturn local footnote censobs_table e(N_unc) e(N_lc) e(N_rc)
	ereturn scalar chi2 = e(F)
	if ("`e(p)'" == "") {
		ereturn scalar p = chi2tail(e(df_m),e(chi2))
	}
	ereturn local chi2type LR
	ereturn local F
	ereturn local predict cnreg_p
	if `rc' == 430 {
		ereturn scalar converged = 0
	}
	else	ereturn scalar converged = 1
	_post_vce_rank
	local df_m = `e(rank)' - 1 - cond("`e(constant)'"=="",1,0)
	ereturn scalar df_m = `df_m'
	ereturn scalar df_r = e(N) - e(df_m)
end

exit
