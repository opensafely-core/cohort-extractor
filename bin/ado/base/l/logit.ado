*! version 11.3.0  08mar2018
program logit, properties(or svyb svyj svyr swml mi bayes) eclass ///
 			byable(onecall)
	if replay() {
		version 11
		if !inlist("`e(cmd)'", "logit", "blogit", "logistic") {
			error 301
		}
		if _by() {
			error 190
		}
		if `"`e(opt)'"' == "" {
			version 10.1: logit_10 `0'
		}
		else	Replay `0'
		exit
	}
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 11 {
		`BY' logit_10 `0'
		exit
	}
	version 11
	local version : di "version " string(_caller()) ":"

	`version' `BY' _vce_parserun logit, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"logit `0'"'
		exit
	}

	`version' `BY' Estimate `0'
	ereturn local cmdline `"logit `0'"'
end

program Estimate, eclass byable(recall)
	version 11
	syntax varlist(ts fv) [if] [in]		///
		[fw pw iw] [,			///
		FROM(string)			///
		NOLOg LOg			///
		noCONstant			/// -ml model- options
		OFFset(varname numeric)		///
		ASIS				///
		TECHnique(passthru)		///
		VCE(passthru)			///
		LTOLerance(passthru)		///
		TOLerance(passthru)		///
		noWARNing			///
		Robust CLuster(passthru)	/// old options
		CRITtype(passthru)		///
		SCORE(passthru)			///
		DOOPT				/// NOT DOCUMENTED
		notable				/// -Replay- options
		noHeader			///
		NOCOEF				///
		OR				///
		GROUPED				///
		moptobj(passthru)		/// NOT DOCUMENTED
		*				/// -mlopts- options
	]

	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}

	if `:length local doopt' {
		opts_exclusive "doopt `robust'"
		opts_exclusive "doopt `cluster'"
		opts_exclusive "doopt `score'"
		opts_exclusive "doopt `technique'"
		if `:length local ltolerance' == 0 {
			local ltolerance ltol(0)
		}
		if `:length local tolerance' == 0 {
			local tolerance tol(1e-4)
		}
		local doopt doopt halfsteponly
	}

	local vceopt =	`:length local vce'		|	///
	   		`:length local weight'		|	///
	   		`:length local cluster'		|	///
	   		`:length local robust'
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(OIM OPG Robust) old	///
			: [`weight'`exp'], `vce' `robust' `cluster'
		local vce
		if "`r(cluster)'" != "" {
			local clustvar `r(cluster)'
			local vce vce(cluster `r(cluster)')
		}
		else if "`r(robust)'" != "" {
			local vce vce(robust)
		}
		else if "`r(vce)'" != "" {
			local vce vce(`r(vce)')
		}
		if !inlist(`"`vce'"', "", "vce(oim)") {
			opts_exclusive "`doopt' `vce'"
		}
	}

	// check syntax
	_get_diopts diopts options, `options'
	* mlopts contains `log' and `nolog', passed to -ml model-
	mlopts mlopts, `options' `technique' `vce' ///
			`tolerance' `ltolerance' `log' `nolog'
	local coll `s(collinear)'
	if "`weight'" != "" {
		local wgt "[`weight'`exp']"
	}
	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}

	// mark the estimation sample
	marksample touse
	if `:length local offset' {
		markout `touse' `offset'
	}
	if `:length local clustvar' {
		markout `touse' `clustvar', strok
	}

	tempname rules mns
	mat `rules' = J(1,4,0)

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if `:length local log' {
		local skipline noskipline
	}
	_rmcoll `varlist' `wgt' if `touse',	///
		`coll'				///
		`skipline'			///
		`constant'			///
		logit				///
		`offopt'			///
		touse(`touse')			///
		`asis'				///
		expand
	if `:length local coll' {
		local mlopts : list mlopts - coll
	}
	local varlist `"`r(varlist)'"'
	matrix `rules' = r(rules)
	matrix `mns' = r(mns)
	tempname b0
	scalar `b0' = r(b0)
	local n0 = r(n0)
	local n1 = r(n1)
	if `n0' + `n1' == 0 {
		exit 2000
	}
	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'

	// initial value
	if `"`from'"' == "" {
		if "`constant'" == "" {
			tempname bb
			local k :list sizeof rhs
			local ++k
			matrix `bb' = J(1,`k',0)
			matrix `bb'[1,`k'] = `b0'
			matrix colna `bb' = `rhs' _cons
			local initopt init(`bb')
		}
	}
	else {
		local initopt `"init(`from')"'
	}

	if "`n0'" != "" {
		local lf0 = `n1'*ln(invlogit(`b0'))+`n0'*ln(invlogit(-`b0'))
		if !missing(`lf0') & "`constant'`offset'" == "" {
			local initopt `initopt' lf0(1 `lf0')
		}
	}

	if `:length local vce' |	///
	   `:length local technique' |	///
	   `:length local score' {
	 	local evaltype e2
		local myeval mopt__logit_e2()
	}
	else {
	 	local evaltype d2
		local myeval mopt__logit_d2()
	}

nobreak {

	// note: `perfect' will contain the tempname for a global Mata object
	mata: mopt__pl_init("perfect")

capture noisily break {

	// fit the full model
	ml model `evaltype' `myeval'		///
		(`lhs': `lhs' = `rhs',		///
			`constant'		///
			`offopt'		///
			`expopt'		///
		)				///
		`wgt' if `touse',		///
		`doopt'				///
		`initopt'			///
		`mlopts'			///
		`crittype'			///
		`score'				///
		`warning'			///
		search(off)			///
		userinfo(`perfect')		///
		noskipline			///
		collinear			///
		missing				///
		nopreserve			///
		maximize			///
		`moptobj'

} // capture noisily break
	local rc = c(rc)

	if `rc' {
		capture mata: rmexternal("`perfect'")
		exit `rc'
	}

} // nobreak

	mata: mopt__pl_post("`perfect'")

	// save a title for -Replay- and the name of this command
	ereturn matrix rules `rules'
	ereturn matrix mns `mns'
	if !missing(e(ll_0)) {
		ereturn scalar r2_p = 1 - e(ll)/e(ll_0)
	}
	ereturn local offset `e(offset1)'
	ereturn local offset1
	ereturn local title "Logistic regression"
	ereturn local marginsnotok	stdp		///
					DBeta		///
					DEviance	///
					DX2		///
					DDeviance	///
					Hat		///
					Number		///
					Residuals	///
					RStandard	///
					SCore
	ereturn local marginsok default Pr
	ereturn hidden local marginsderiv default Pr
	ereturn local predict logit_p
	ereturn local estat_cmd logit_estat
	ereturn local cmd logit

	Replay , `table' `header' norules `or' `grouped' `diopts'
end

program Replay
	syntax [, notable noHeader NOCOEF noRULES OR GROUPED *]
	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}
	if "`grouped'" != "" {
		local title title(Logistic regression for grouped data)
	}
	if "`e(cmd)'" == "logistic" & "`or'" == "" {
		local or coef
	}
	_get_diopts diopts, `options'
	_prefix_display, `table' `header' `rules' `or' `title' `diopts'
end

exit
