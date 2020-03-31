*! version 11.4.0  31jul2018
program mlogit, properties(rrr svyb svyj svyr swml mi bayes) eclass ///
			byable(onecall)
	if replay() {
		version 11
		if "`e(cmd)'" != "mlogit" {
			error 301
		}
		if _by() {
			error 190
		}
		if `"`e(opt)'"' == "" {
			mlogit_10 `0'
		}
		else	Replay `0'
		exit
	}
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 11 {
		`BY' mlogit_10 `0'
		exit
	}
	version 11
	local version : di "version " string(_caller()) ":"

	`version' `BY' _vce_parserun mlogit, mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"mlogit `0'"'
		exit
	}

	`version' `BY' Estimate `0'
	ereturn local cmdline `"mlogit `0'"'
end

program Estimate, eclass byable(recall)
	local vv : di "version " string(_caller()) ":"
	version 11
	syntax varlist(ts fv) [if] [in]		///
		[fw pw iw aw] [,		///
		FROM(string)			///
		NOLOg LOg			///
		noCONStant			/// -ml model- options
		Constraints(passthru)		///
		TECHnique(passthru)		///
		VCE(passthru)			///
		LTOLerance(passthru)		///
		TOLerance(passthru)		///
		noWARNing			///
		Robust CLuster(passthru)	/// old options
		CRITtype(passthru)		///
		SCORE(passthru)			///
		DOOPT				/// NOT DOCUMENTED
		Level(cilevel)			/// -Replay- options
		notable				///
		noHeader			///
		RRr				///
		Baseoutcome(passthru)		///
		moptobj(passthru)		/// NOT DOCUMENTED
		*				/// -mlopts- options
	]

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

	if _caller() >= 14 {
		local CNSOPT : copy local constraints
		local constraints
	}

	// check syntax
	_get_diopts diopts options, `options'
	mlopts mlopts,	`options'	///
			`constraints'	///
			`technique'	///
			`vce'		///
			`tolerance'	///
			`ltolerance'	///
			`log' `nolog'
	local coll `s(collinear)'
	if "`weight'" != "" {
		local wgt "[`weight'`exp']"
	}

	// mark the estimation sample
	marksample touse
	if `:length local clustvar' {
		markout `touse' `clustvar', strok
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if `:length local log' {
		local skipline noskipline
	}
	_rmcoll `varlist' `wgt' if `touse',	///
		`constant'			///
		`coll'				///
		`skipline'			///
		mlogit				///
		`baseoutcome'			///
		expand
	if `:length local coll' {
		local mlopts : list mlopts - coll
	}
	local varlist `"`r(varlist)'"'
	tempname out
	matrix `out' = r(out)
	local ibase = r(ibaseout)
	if !`:length local constant' {
		tempname b0
		matrix `b0' = r(b0)
		local lf0 = r(ll_0)
	}
	else	local lf0 = .
	local nout = r(k_out)
	if (`nout' == 1) {
		error 148
	}
	local neq = `nout' - 1
	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'
	local nx : list sizeof rhs
	if !`:length local constant' {
		local ++nx
	}
	if `nout'*`nx' > c(max_matdim) {
		error 915
	}
	local yeq "`lhs'="
	_labels2eqnames `lhs', values(`out') stub(_eq_)
	local eqlist0 `"`r(eqlist)'"'
	forval i = 1/`nout' {
		gettoken eq eqlist0 : eqlist0
		if `i' == `ibase' {
			local baseeq : copy local eq
			local val = `out'[1,`i']
			local baselab : label (`lhs') `val'
			if `:list baselab == val' {
				local baselab
			}
			local eqlist1 `eqlist1' `baseeq'
		}
		else {
			local xb `xb' (`eq': `yeq'`rhs', `constant')
			local eqlist1 `eqlist1' `eq'
			local eqlist `eqlist' `eq'
			local yeq
		}
	}

	if `"`CNSOPT'"' != "" {
		_mult_makecns,	eqlist(`eqlist1')	///
				`constant'		///
				rhs(`rhs')		///
				ibase(`ibase')		///
				outcomes(`out')		///
				`CNSOPT'
		if "`r(Cns)'" == "matrix" {
			tempname Cns
			matrix `Cns' = r(Cns)
			local cnsopt constraints(`Cns') `r(nocnsreport)'
		}
	}

	// initial value
	if `"`from'"' == "" {
		if `:length local b0' {
			matrix coleq `b0' = `eqlist'
			local initopt init(`b0')
		}
	}
	else {
		local initopt `"init(`from')"'
	}

	if !missing(`lf0') {
		local initopt `initopt' lf0(`=`nout'-1' `lf0')
	}

	if `:length local vce' |	///
	   `:length local technique' |	///
	   `:length local score' {
	 	local evaltype e2
		local myeval mopt__mlogit_e2()
	}
	else {
	 	local evaltype d2
		local myeval mopt__mlogit_d2()
	}

nobreak {

	// note: `ord' will contain the tempname for a global Mata object
	mata: mopt__mu_init("ord", `ibase')

capture noisily break {

	// fit the full model
	`vv'					///
	ml model `evaltype' `myeval'		///
		`xb'				///
		`wgt' if `touse',		///
		`doopt'				///
		`initopt'			///
		`mlopts'			///
		`crittype'			///
		`score'				///
		`warning'			///
		`cnsopt'			///
		wald(-`neq')			///
		search(off)			///
		userinfo(`ord')			///
		noskipline			///
		collinear			///
		missing				///
		nopreserve			///
		maximize			///
		`moptobj'

} // capture noisily break
	local rc = c(rc)

	if `rc' {
		capture mata: rmexternal("`ord'")
		exit `rc'
	}

} // nobreak

	mata: mopt__mu_post("`ord'")

	// save a title for -Replay- and the name of this command
	ereturn local baselab `"`baselab'"'
	ereturn local eqnames `"`:list retok eqlist1'"'
	if !missing(e(ll_0)) {
		ereturn scalar r2_p = 1 - e(ll)/e(ll_0)
	}
	ereturn local title "Multinomial logistic regression"
	ereturn local predict mlogit_p
	ereturn local marginsnotok stdp stddp SCores
	ereturn hidden local marginsderiv default Pr OUTcome(passthru)
	forval i = 1/`nout' {
		local j = `out'[1,`i']
		local mdflt `mdflt' predict(pr outcome(`j'))
		local depvar_outcomes `"`depvar_outcomes' `j'"'
	}
	ereturn local marginsdefault `"`mdflt'"'
	ereturn hidden local depvar_outcomes `"`:list retok depvar_outcomes'"'

	tempname b v C
	matrix `b' = e(b)
	matrix `v' = e(V)
	local xvars : copy local rhs
	if !`:length local constant' {
		local xvars `xvars' _cons
	}
	local nx : list sizeof xvars
	local pos = (`ibase'-1)*`nx' + 1
	_mat_fill0 `b', k(`nx') col(`pos')
	_mat_fill0 `v', k(`nx') col(`pos') row(`pos')
	if "`e(Cns)'" == "matrix" {
		matrix `C' = e(Cns)
		_mat_fill0 `C', k(`nx') col(`pos')
		local Cns "C=`C'"
	}
	forval i = 1/`nout' {
		gettoken eq eqlist1 : eqlist1
		forval j = 1/`nx' {
			local coleq `coleq'  `eq'
		}
		local colna `colna' `xvars'
	}
	if "`e(V_modelbased)'" == "matrix" {
		tempname vmb
		matrix `vmb' = e(V_modelbased)
		_mat_fill0 `vmb', k(`nx') col(`pos') row(`pos')
		matrix colna `vmb' = `colna'
		matrix rowna `vmb' = `colna'
		ereturn matrix V_modelbased `vmb'
	}
	matrix colna `b' = `colna'
	matrix coleq `b' = `coleq'
	local fveq = `nout' - (`nout' == `ibase')
	ereturn repost b=`b' V=`v' `Cns' [`e(wtype)'`e(wexp)'], ///
		resize eqvalues(`out') buildfvinfo		///
		findomitted fvinfoeq(`fveq')
	ereturn scalar k_eq = `nout'
	ereturn hidden scalar k_eform = `nout'
	ereturn scalar k_eq_model = `nout'
	ereturn scalar k_eq_base = `ibase'	// used by -_coef_table-
	ereturn hidden local k_eq_model_skip `ibase'

	ereturn local cmd mlogit

	Replay , level(`level') `table' `header' `rrr' `diopts'
end

program Replay
	syntax [, notable noHeader RRr noCNSReport *]
	if `"`e(opt)'"' == "" {
		mlogit_10 `0'
		exit
	}

	_get_diopts diopts, `options'
	_prefix_display, `table' `header' `rrr' `cnsreport' `diopts'
end

exit
