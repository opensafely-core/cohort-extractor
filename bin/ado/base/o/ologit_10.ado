*! version 1.1.0  03nov2008
program define ologit_10, eclass byable(onecall) prop(or svyb svyj svyr swml)
	version 9
	local version : di "version " string(_caller()) ", missing :"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	syntax [anything] [fw iw pw aw] [if] [in] [, VCE(passthru) * ]
	if `:length local vce' {
		`BY' _vce_parserun ologit, mark(OFFset CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"`version' ologit `0'"'
			exit
		}
	}
	if replay() {
		if "`e(cmd)'" != "ologit" {
			error 301
		}
		if _by() {
			error 190
		}
		if missing(e(version)) {
			_ologit `0'
		}
		else	Display `0'
		exit
	}
	`version' `BY' Estimate `0'
	ereturn local cmdline `"`version' ologit `0'"'
end

program Estimate, byable(recall) eclass
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"
	if _caller() < 9 {
		local oldopt Table
	}
	quietly syntax varlist [fw iw pw aw] [if] [in] ///
		[, Level(cilevel) NOCOEF OR `oldopt' ///
		VCE(passthru) Robust CLuster(passthru) * ]
	if "`weight'" != "" {
		local wt [`weight'`exp']
	}
	marksample touse
	if `:length local vce' {
		_vce_parse `touse', argopt(CLuster) opt(OIM Robust) old	///
			: `wt', `vce' `robust' `cluster'
		if "`r(cluster)'" != "" {
			local cluster cluster(`r(cluster)')
		}
		local robust `r(robust)'
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "oim")
	}
	else if "`weight'" == "pweight" | "`robust'`cluster'" != "" {
		local vce robust
	}
	else	local vce oim
	capture noisily `version' _ologit `varlist' `wt' if `touse', ///
		nocoef `robust' `cluster' `options'
	local rc = c(rc)
	if `rc' & `rc' != 430 {
		exit `rc'
	}
	if e(k_cat) == 1 {
		tempname b
		capture matrix `b' = e(b)
		if c(rc) | colsof(`b') == 0 {
			error 148
		}
	}
	if "`nocoef'" == "" {
		if _caller() < 9 {
			_ologit, `or' `table' level(`level')
		}
		else {
			ereturn local vce "`vce'"
			NewStripes `rc'
			Display, `or' level(`level')
		}
	}
	exit `rc'
end

program Display
	version 9
	syntax [, Level(cilevel) OR ]
	_coef_table_header
	di
	_coef_table, level(`level') `or' notest
	_prefix_footnote
end

program NewStripes, eclass
	version 9
	args rc
	local depvar `e(depvar)'
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	_e2r
	tempvar touse
	quietly gen byte `touse' = e(sample)
	_prefix_relabel_eqns `b' `V'
	local k_eq = s(k_eq)
	local k_aux = s(k_aux)
	ereturn post `b' `V', esample(`touse') depname(`depvar')
	_r2e
	if "`e(chi2type)'" == "Wald" & `k_eq' > `k_aux' {
		quietly test [#1]
		ereturn scalar chi2 = r(chi2)
		ereturn scalar df_m = r(df)
	}
	ereturn local title "Ordered logistic regression"
	ereturn scalar k_eq = `k_eq'
	ereturn scalar k_aux = `k_aux'
	ereturn scalar version = 2
	if `rc' == 430 {
		ereturn scalar converged = 0
	}
	else	ereturn scalar converged = 1
end

exit
