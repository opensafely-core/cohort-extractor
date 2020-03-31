*! version 2.3.0  03dec2018
program areg, eclass byable(onecall) prop(mi)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 12 {
		`BY' areg_11 `0'
		exit
	}
	version 12

	quietly syntax [anything] [aw fw pw] [if] [in] [, VCE(passthru) *]
	if `"`vce'"' != "" {
		`BY' _vce_parserun areg, mark(Absorb CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"areg `0'"'
			exit
		}
	}
	quietly syntax [anything] [aw fw pw] [if] [in] [, Absorb(varname) *]
	_get_diopts diopts options, `options'
	_vce_parse, argopt(CLuster) opt(OLS Robust) old	///
		: [`weight'`exp'], `options'
	if !inlist(`"`r(cluster)'"', "", "`absorb'") {
		// we cannot quickly tell that the absorb groups are
		// strictly nested within clusters, call the
		// older/slower implementation
		`BY' areg_11 `0'
		ereturn local cmdline `"areg `0'"'
		exit
	}

	if replay() {
		if `"`e(cmd)'"' != "areg" {
			error 301
		}
		if _by() { 
			error 190 
		}
		Replay `0'
		exit
	}

	`BY' Estimate `0'
	ereturn local cmdline `"areg `0'"'
end

program Estimate, eclass byable(recall)
	version 12
	syntax varlist(ts fv) [aw fw pw] [if] [in], Absorb(varname) [*]

	_fv_check_depvar `varlist', k(1)
	_get_diopts diopts options, `options'

	_vce_parse, argopt(CLuster) opt(OLS Robust) old	///
		: [`weight'`exp'], `options'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "ols")
	local robust "`r(robust)'"
	local cluster "`r(cluster)'"
	if "`cluster'" != "" {
		if "`cluster'" != "`absorb'" {
			exit 459
		}
		local clopt cluster(`cluster')
	}

	marksample touse
	markout `touse' `absorb', strok
	quietly count if `touse'
	if      r(N) == 0 { 
		error 2000 
	}
	else if r(N) == 1 { 
		error 2001 
	}

	_regress `varlist' [`weight'`exp'] if `touse',	///
		noheader				///
		notable					///
		`robust'				///
		`clopt'					///
		absorb(`absorb')

	// comparison model
	local y `e(depvar)'
	local xvars : colna e(b)
	local cons _cons
	local xvars : list xvars - cons
	tempname hold
	set buildfvinfo off
	_est hold `hold'
	quietly _regress `y' `xvars' [`weight'`exp'] if `touse'
	local r2c = e(r2)
	_est unhold `hold'

	if "`robust'" == "" {
		ereturn scalar F_absorb =	///
			((e(r2)-`r2c')/e(df_a))/((1-e(r2))/e(df_r))
		ereturn scalar p_absorb = 	///
			fprob(e(df_a),e(df_r),e(F_absorb))
	}
	else {
		_prefix_model_test
	}
	_post_vce_rank

	ereturn local vce "`vce'"
	ereturn historical(9.2) scalar ar2 = e(r2_a)

	if e(F) == 0 {
		ereturn scalar df_m = 0
		ereturn scalar F = .
	}
	if "`e(clustvar)'" != "" {
		ereturn scalar rmse = sqrt(e(rss)/(e(N)-e(df_a)-e(df_m)-1))
	}

	/* Find e(p) */
	if ("`e(p)'" == "") {
		ereturn scalar p = Ftail(e(df_m),e(df_r),e(F))
	}

	ereturn scalar k_absorb = e(df_a) + 1
	unopvarlist `varlist'
	local varlist `r(varlist)'
	signestimationsample `varlist' `absorb' `e(clustvar)' 

	ereturn local marginsnotok Residuals SCore
	ereturn hidden local marginsprop nolinearize
	ereturn local predict areg_p
	ereturn local title "Linear regression, absorbing indicators"
	ereturn hidden local title2 "Absorbed variable: `absorb'"
	ereturn local footnote areg_footnote
	ereturn local estat_cmd
	ereturn local cmd  "areg"

	// duplicates for old results
	global S_E_mdf	= e(df_m)
	global S_E_f	= e(F)
	global S_E_f2	= e(F_absorb)

	global S_E_nobs	= e(N)
	global S_E_sse	= e(rss)
	global S_E_sst	= e(tss)
	global S_E_r2	= e(r2)
	global S_E_tdf	= e(df_r)
	global S_E_abs	`"`absorb'"'
	global S_E_dfa	= e(df_a)
	global S_E_depv `"`e(depvar)'"'
	global S_E_cmd	`"`e(cmd)'"'

	Replay, `diopts'
end

program Replay
	syntax [, *]

	_get_diopts diopts, `options'
	if "`e(prefix)'" != "" {
		_prefix_display, `diopts'
		exit
	}
	_coef_table_header
	di
	_coef_table, `diopts'
	_prefix_footnote
end
exit
