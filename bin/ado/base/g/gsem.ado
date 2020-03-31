*! version 1.3.5  19dec2017
program gsem, eclass byable(onecall) properties(svyb svyj svyg)
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	if replay() {
		if "`e(cmd)'" != "gsem" & "`e(cmd2)'" != "gsem" & ///
		  "`e(cmd2)'" != "meglm" {
			error 301
		}
		if _by() {
			error 190
		}
		gsem_display `0'
		exit
	}

	quietly ssd query
	if r(isSSD) {
		di as err "gsem not allowed with summary statistic data"
		exit 111
	}

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	_parse expand lc lg : 0 , common(moptobj(string)) gweight
	_parse canon 0 : lc lg, gweight
	syntax [anything(equalok)] [if] [in] [fw pw aw iw] [, moptobj(string) *]
	tempname GSEM
	if `"`moptobj'"' != "" {
		local GSEM `moptobj'`GSEM'
	}
	capture noisily `vv' `BY' Estimate `GSEM' `0'
	local rc = c(rc)
	if `"`moptobj'"' == "" {
		capture mata: rmexternal("`GSEM'")
		capture drop `GSEM'*
	}
	if (`rc') exit `rc'
	ereturn local cmdline `"gsem `0'"'
end

program Estimate, byable(recall) eclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	gettoken GSEM : 0

	if _by() {
		tempname bytouse
		mark `bytouse'
	}

	// Fit sets the following local macros:
	//
	//	diopts

	`vv' `BY' Fit "`bytouse'" `0'

	`vv' gsem_ereturn `GSEM'

	if e(k_eq_model) {
		_prefix_model_test
	}

	if `"`e(lcgof_model)'"' != "" & `"`e(lcgof_sat_df)'"' != "" {
		tempname ll cp
		capture noisily quietly LCgof `ll' `cp'
		local rc = c(rc)
		capture drop `ll'*
		capture drop `cp'*
		if `rc' {
			exit `rc'
		}
	}

	gsem_display, `diopts'
end

program Fit, eclass sortpreserve
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	gettoken bytouse 0 : 0
	gettoken GSEM 0 : 0

	tempname touse b
	`vv' gsem_parse `GSEM', touse(`touse') bytouse(`bytouse') : `0'
	local mltype	`"`r(mltype)'"'
	local mleval	`"`r(mleval)'"'
	local mlspec	`"`r(mlspec)'"'
	local mlopts	`"`r(mlopts)'"'
	local mlvce	`"`r(mlvce)'"'
	local mlwgt	`"`r(mlwgt)'"'
	local nolog	`"`r(nolog)'"'
	local mlprolog	`"`r(mlprolog)'"'
	local mlextra	`"`r(mlextra)'"'
	local mlgroup	`"`r(mlgroup)'"'
	local mlclust	`"`r(mlclust)'"'
	local moptobj	`"`r(moptobj)'"'
	c_local diopts	`"`r(diopts)'"'
	local est	= r(estimate)
	local full	= r(full_msg)
	matrix `b' = r(b)
	if "`r(Cns)'" != "" {
		tempname Cns
		matrix `Cns' = r(Cns)
		local cnsopt constraint(`Cns')
	}

	if `est' {
		if `full' & "`nolog'" == "" {
			di
			di as txt "Fitting full model:"
		}
		set buildfvinfo off			// auto-reset on exit
		ml model `mltype' `mleval'		///
			`mlspec'			///
			`mlwgt'				///
			if `touse',			///
			`mlopts'			///
			`mlvce'				///
			`mlprolog'			///
			`mlextra'			///
			`mlgroup'			///
			`cnsopt'			///
			collinear			///
			init(`b', copy)			///
			maximize			///
			missing				///
			nopreserve			///
			search(off)			///
			userinfo(`GSEM')		///
			wald(0)				///
			`moptobj'			///
							 // blank
		ereturn hidden scalar estimates = 1
	}
	else {
		di
		di as txt "Posting starting values:"
		tempname V grad
		local dim = colsof(`b')
		matrix `V' = J(`dim',`dim',0)
		local colna : colful `b'
		matrix colna `V' = `colna'
		matrix rowna `V' = `colna'
		matrix `grad' = J(1,`dim',.)
		matrix colna `grad' = `colna'
		ereturn post `b' `V' `Cns', esample(`touse')
		ereturn matrix gradient `grad'
		ereturn hidden scalar estimates = 0
		quietly count if e(sample)
		ereturn scalar N = r(N)
		ereturn scalar k_autoCns = 0
	}

	ereturn local footnote	gsem_footnote
	ereturn local estat_cmd	gsem_estat
	ereturn local predict	gsem_p
end

program LCgof, eclass
	args ll cp

	tempname touse E G2 last
	gen byte `touse' = e(sample)

	if `"`e(wexp)'"' != "" {
		local wexp `"`e(wexp)'"'
		gettoken EQUALS wexp : wexp, parse("= ")
	}
	else	local wexp 1

	local groupvar `"`e(groupvar)'"'
	local dv `"`e(depvar)'"'
	local dv : list uniq dv
	local by `groupvar' `dv' `touse'
	sort `by'
	quietly by `by' : gen `last' = _n == _N if `touse'

	quietly predict double `ll'* if `last' == 1, likelihood
	unab llvars : `ll'*
	local cdim : list sizeof llvars

	quietly predict double `cp'* if `last' == 1, classpr
	unab cpvars : `cp'*

	quietly gen double `E' = `ll'1*`cp'1 if `last' == 1
	forval i = 2/`cdim' {
		quietly replace `E' = `E' + `ll'`i'*`cp'`i' if `last' == 1
	}

	if `"`groupvar'"' == "" {
		quietly replace `E' = e(N)*`E' if `last' == 1
	}
	else {
		tempname nobs nn
		matrix `nobs' = e(nobs)
		quietly matrix score `nn' = `nobs' if `last' == 1
		quietly replace `E' = `nn'*`E' if `last' == 1
	}

	quietly by `by' : gen `G2' = sum(`wexp') if `touse'
	quietly replace `G2' = 2*`G2'*log(`G2'/`E') if `last' == 1
	sum `G2' if `last' == 1, meanonly
	if (r(sum) >= 0 & e(lcgof_sat_df) > e(rank)) {
		ereturn hidden scalar chi2_ms = r(sum)
		ereturn hidden scalar df_ms = e(lcgof_sat_df) - 1 - e(rank)
		ereturn hidden scalar p_ms = chi2tail(e(df_ms), e(chi2_ms))
	}
end

exit
