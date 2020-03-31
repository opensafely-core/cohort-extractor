*! version 1.0.6  19mar2018
program stcrreg_p, sort 
	version 11

	if `"`e(cmd)'"' != "stcrreg" {
		error 301
	}

	syntax [anything] [if] [in] [,	XB		///
					Index		///
					STDP		///
					SHR		///
					HR		/// (undocumented)
					SCores		///
					SCHoenfeld	///
					esr		///
					BASECSHazard	///
					BASECIF		///
					BASECH		/// (undocumented)
					KMCensor	///
					DFBeta		///
					PARTial		///
					noOFFset 	///
				    ]

	local type "`xb' `index' `stdp' `hr' `shr'"
	local type "`type' `scores' `schoenfeld' `esr' `basech' `basecif'"
	local type "`type' `basecshazard' `kmcensor' `dfbeta'"

	if `:word count `type'' > 1 {
		di as err "{p 0 4 2}only one of "
		di as err "`: list uniq type' "
		di as err "may be specified{p_end}"
		exit 198
	}
	local type : word 1 of `type'

	if "`type'" == "basecshazard" {
		local type basech
	}

	if inlist("`type'", "scores", "esr", "dfbeta") {
		if "`partial'" == "" {
			local type c`type'
		}
	}
	else if "`partial'" != "" {
		di as err "{p 0 4 2}option partial not allowed{p_end}"
		exit 198
	}

	tempname b
	mat `b' = e(b)
	if !inlist("`type'", "basech", "kmcensor", "basecif") & /// 
   	   !colsof(`b') {
		di as err "{p 0 4 2}prediction not valid after "
		di as err "fitting null model{p_end}"
		exit 498
	}

	if inlist("`type'", "scores", 		/// 
			    "cscores", 		///
			    "esr", 		///
			    "cesr", 		///
			    "dfbeta",		///
			    "cdfbeta",		///
			    "schoenfeld") {
		GetScoreLike `anything' `if' `in', type(`type') `offset'
		exit
	}

	if inlist("`type'", "basech", "kmcensor", "basecif") {
		GetPrediction `anything' `if' `in', type(`type') `offset'
		exit
	}

	// handle other prediction types
	
	if "`e(mainvars)'" == "" {
		di as err "{p 0 4 2}prediction not valid when main equation "
		di as err "is empty{p_end}"
		exit 498
	}
	
	local myopts "XB Index STDP SHR HR"

	_pred_se "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtyp `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'

	syntax [if] [in] [, `myopts' noOFFset]

	marksample touse

	if inlist("`type'", "xb", "index", "stdp") {
	 	_predict `vtyp' `varn' if `touse', `type' `offset'
		exit
	}

	st_is 2 full

	if "`type'" == "" | "`type'" == "shr" | "`type'" == "hr" {
		if "`type'" == "" {
			di as txt ///
		"(option {bf:shr} assumed; predicted relative subhazard)"
		}
		tempvar xb
		qui _predict double `xb' if `touse', xb `offset'
		gen `vtyp' `varn' = exp(`xb')
		label var `varn' "Predicted relative subhazard"
		exit
	}

	// nooffset not allowed for anything below
	
	if "`offset'" != "" {
		di as err "option nooffset not allowed"
	}

	error 198
end

program GetScoreLike, eclass
	syntax [anything] [if] [in], type(string)

	marksample touse

	tempvar esamp
	qui gen byte `esamp' = e(sample)
	if "`type'" == "cesr" {
		local type esr
		local cumulative cumulative
	}
	if "`type'" == "cscores" {
		local type scores
		local cumulative cumulative
	}
	if "`type'" == "cdfbeta" {
		local type dfbeta
		local cumulative cumulative
	}
	
	if "`type'" == "dfbeta" {
		local type esr
		local scaled scaled
	}

	if "`e(offset1)'" != "" {
		local offopt offset(`e(offset1)')
	}

	if `"`e(tvc)'"' != "" {
		local tvcopt `"tvc(`e(tvc)') texp(`e(texp)')"'
	}

	tempname b V
	mat `b' = e(b)
	mat `V' = e(V_modelbased)		// Need the Hessian here
	local dim = colsof(`b')
	local xvars `e(mainvars)'
	if "`e(tvc)'" != "" {
		local xnames : colf `b'
	}
	else {
		local xnames : coln `b'
	}

	GetVarNames `anything', dim(`dim')
	local svars `s(varlist)'
	local styps `s(typlist)'

	forval i = 1/`dim' {
		tempvar v`i'
		local tvars `tvars' `v`i''
	}

	local cmdline `"`e(cmdline)'"'
	// Remember, stcrreg picks up weights from stset
	tempname ehold
	version 11: _est hold `ehold', copy restore
	qui stcrreg `xvars' if e(sample), compete(`e(compete)') ///
		`offopt' `tvcopt' scorelike(`tvars') scoretype(`type') 

	if "`cumulative'" != "" {
		if "`_dta[st_id]'" != "" {
			sort `esamp' `_dta[st_id]' _t
			foreach vv of local tvars {
				qui by `esamp' `_dta[st_id]': replace ///
					`vv' = cond(_n==_N,sum(`vv'),.) ///
					if `esamp'
			}
		}
	}

	if "`scaled'" != "" {
		tempvar useme
		qui gen byte `useme' = `touse' & `esamp' 
		if "`cumulative'" != "" & "`_dta[st_id]'" != "" {
			sort `esamp' `_dta[st_id]' _t
			qui by `esamp' `_dta[st_id]': replace /// 
				 `useme' = `useme' & (_n==_N)
		}
		ScaleScores `tvars', touse(`useme') var(`V')
	}

	if "`type'" == "scores" {
		if "`cumulative'" == "" & "`_dta[st_id]'" != "" {
			local part "partial "
		}
		if "`part'" != "" {
			local vlab Partial pseudolikelihood score
		}
		else {
			local vlab Pseudolikelihood score
		}
	}
	else if "`type'" == "esr" {
		if "`cumulative'" == "" & "`_dta[st_id]'" != "" {
			local part "Partial "
		}
		if "`scaled'" == "" {
			if "`part'" != "" {
				local vlab Partial efficient score
			}
			else {
				local vlab Efficient score
			}
		}
		else {
			local vlab `part'DFBETA 
		}
	}
	else if "`type'" == "schoenfeld" {
		local vlab Schoenfeld residual
	}

	forval i = 1/`dim' {
		gettoken xname xnames : xnames
		gettoken svar svars : svars
		gettoken tvar tvars : tvars
		gettoken type styps : styps
		qui gen `type' `svar' = `tvar' if `touse'
		label var `svar' "`vlab' - `xname'"
	}
	version 11: _est unhold `ehold'	
end

program GetPrediction, eclass
	syntax [newvarname] [if] [in], type(string)

	marksample touse, novarlist

	if "`e(offset1)'" != "" {
		local offopt offset(`e(offset1)')
	}
	if `"`e(tvc)'"' != "" {
		local tvcopt `"tvc(`e(tvc)') texp(`e(texp)')"'
	}

	tempname b
	mat `b' = e(b)
	local dim = colsof(`b')
	local xvars `e(mainvars)'

	preserve

	tempname save
	
	tempvar pp

	local cmdline `"`e(cmdline)'"'
	// Remember, stcrreg picks up weights from stset
	tempname ehold
	version 11: _est hold `ehold', copy restore
	qui stcrreg `xvars' if e(sample), compete(`e(compete)') ///
		`offopt' `tvcopt' predict(`pp') predtype(`type')

	if "`type'" == "kmcensor" {
		local vlab Kaplan-Meier, censoring dist.
	}
	else if "`type'" == "basech" {
		local vlab Baseline cumulative subhazard
	}
	else if "`type'" == "basecif" {
		local vlab Baseline cumulative incidence
	}

	gen `typlist' `varlist' = `pp' if `touse'
	label var `varlist' "`vlab'"
	version 11: _est unhold `ehold'	

	qui keep `varlist'
	qui save `save', replace
	restore

	qui merge 1:1 _n using `save', nogen norep sorted
	qui rm `save'.dta
end

program GetVarNames, sclass
	syntax [anything], dim(integer)

	cap _score_spec `anything', ignoreeq 
	local rc = _rc
	if `rc' & `rc' != 103 { 
		_score_spec `anything', ignoreeq
	}
	if (`:word count `s(varlist)'' < `dim') & (`rc' != 103) {
		local rc 102
	}
	if `rc' == 102 | `rc' == 103 {
		di as err "{p 0 4 2}you must specify `dim' new "
		di as err "variables {p_end}"
		exit `rc'
	}
	sreturn local varlist `s(varlist)'
	sreturn local typlist `s(typlist)'
end

program ScaleScores
	syntax varlist, touse(varname) var(name)

	capture noi mata: _stcrr_scale_the_scores()
	if _rc {
		di as err "{p 0 4 2}error scaling efficient score residuals"
		di as err "{p_end}"
		exit 459
	}
end

exit


