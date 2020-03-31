*! version 11.4.1  11nov2019
program oprobit, properties(svyb svyj svyr swml mi bayes) eclass byable(onecall)
	if replay() {
		version 11
		if "`e(cmd)'" != "oprobit" {
			error 301
		}
		if _by() {
			error 190
		}
		if `"`e(opt)'"' == "" {
			oprobit_10 `0'
		}
		else	Replay `0'
		exit
	}
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if _caller() < 11 {
		`BY' oprobit_10 `0'
		exit
	}
	version 11
	local version : di "version " string(_caller()) ":"

	`version' `BY' _vce_parserun oprobit, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"oprobit `0'"'
		exit
	}

	`version' `BY' Estimate `0'
	ereturn local cmdline `"oprobit `0'"'
end

program Estimate, eclass byable(recall)
	local vv : di "version " string(_caller()) ":"
	version 11
	syntax varlist(ts fv) [if] [in]		///
		[fw pw iw aw] [,		///
		FROM(string)			///
		NOLOg LOg			///
		OFFset(varname numeric)		/// -ml model- options
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
	mlopts mlopts, `options' `technique' `vce' `tolerance' `ltolerance' ///
		`log' `nolog'
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

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if `:length local log' {
		local skipline noskipline
	}
	`vv'					///
	_rmcoll `varlist' `wgt' if `touse',	///
		`coll'				///
		`skipline'			///
		oprobit				///
		`offopt'			///
		expand
	if `:length local coll' {
		local mlopts : list mlopts - coll
	}
	local varlist `"`r(varlist)'"'
	tempname cat b0
	matrix `cat' = r(cat)
	matrix `b0' = r(b0)
	local ncat = r(k_cat)
	local lf0 = r(ll_0)
	if (`ncat' == 1) {
		error 148
	}
	local ncut = `ncat' - 1
	forval i = 1/`ncut' {
		local cuteq `cuteq' /cut`i'
	}
	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'

	// initial value
	if `"`from'"' == "" {
		tempname bb
		local k :list sizeof rhs
		if `k' {
			matrix `bb' = J(1,`k',0)
			matrix colna `bb' = `rhs'
			matrix coleq `bb' = `lhs'
		}
		matrix `bb' = nullmat(`bb'), `b0'
		local initopt init(`bb')
	}
	else {
		local initopt `"init(`from')"'
	}

	if !missing(`lf0') & "`offset'" == "" {
		local initopt `initopt' lf0(`=`ncat'-1' `lf0')
	}

	if `:length local vce' |	///
	   `:length local technique' |	///
	   `:length local score' {
	 	local evaltype e2
		local myeval mopt__oprobit_e2()
	}
	else {
	 	local evaltype d2
		local myeval mopt__oprobit_d2()
	}

nobreak {

	// note: `ord' will contain the tempname for a global Mata object
	mata: mopt__ordpl_init("ord")

capture noisily break {

	if `:list sizeof rhs' {
		local xb (`lhs': `lhs' = `rhs', noconstant `offopt' `expopt')
	}
	else {
		local xb (cut1: `lhs' =, `offopt' `expopt')
		gettoken drop cuteq : cuteq
	}

	// fit the full model
	`vv'					///
	ml model `evaltype' `myeval'		///
		`xb'				///
		`cuteq'				///
		`wgt' if `touse',		///
		`doopt'				///
		`initopt'			///
		`mlopts'			///
		`crittype'			///
		`score'				///
		`warning'			///
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

	mata: mopt__ordpl_post("`ord'")
	if "`rhs'" == "" & _caller() >= 15 {
		tempname b
		matrix `b' = e(b)
		local colna : colfullna `b'
		local colna : subinstr local colna "cut1:_cons" "/cut1"
		matrix colna `b' = `colna'
		ereturn repost b=`b', rename buildfvinfo ADDCONS
		ereturn scalar k_eq_model = 0
	}
	else	ereturn repost, buildfvinfo ADDCONS

	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	local pos = colnumb(`pclass', "/cut1")
	matrix `pclass'[1,`pos'] = J(1,`ncut',`PCAUX')
	ereturn hidden matrix b_pclass `pclass'

	// save a title for -Replay- and the name of this command
	if !missing(e(ll_0)) {
		ereturn scalar r2_p = 1 - e(ll)/e(ll_0)
	}
	ereturn local offset `e(offset1)'
	ereturn local offset1
	ereturn local title "Ordered probit regression"
	ereturn hidden local marginsprop addcons
	ereturn hidden local marginsderiv default Pr OUTcome(passthru)
	forval i = 1/`ncat' {
		local j = `cat'[1,`i']
	    if `j' != floor(`j') {
		local mdflt `mdflt' predict(pr outcome(#`i'))
	    }
	    else {
		local mdflt `mdflt' predict(pr outcome(`j'))
	    }
		local depvar_outcomes `"`depvar_outcomes' `j'"'
	}
	ereturn local marginsdefault `"`mdflt'"'
	ereturn hidden local depvar_outcomes `"`:list retok depvar_outcomes'"'
	ereturn matrix cat `cat'
	ereturn local predict oprobi_p
	ereturn hidden scalar version = 3
	ereturn local cmd oprobit

	Replay , `table' `header' `diopts'
end

program Replay
	syntax [, notable noHeader NOCOEF *]
	_get_diopts diopts, `options'
	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}
	_prefix_display, notest `table' `header' `diopts'
end

exit
