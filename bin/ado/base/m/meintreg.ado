*! version 1.1.0  16aug2018
program meintreg, eclass byable(onecall) prop(or svyg bayes xtbs)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd2)'" != "meintreg" {
			error 301
		}
		if _by() {
			error 190
		}
		_me_display `0'
		exit
	}
	
	capture noisily `vv' `by' Estimate `0'
	local rc = _rc
	exit `rc'
end

program Estimate, sortpreserve eclass byable(recall)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	
	local 0_orig `0'
	_parse expand eq opt : 0
	local gopts `opt_op'
	local fe_ix 0
	
	forvalues i=1/`=`eq_n'-1' {
		local 0 `eq_`i''

		local fe = !strpos(`"`0'"',":")

		syntax [anything] [if] [in] [fw pw iw] [, or irr eform 	///
			BINomial(string) Family(string) Link(string) 	///
			EXPosure(string) *]
		_me_chk_opts, binomial(`binomial') exposure(`exposure')  ///
			irr(`irr') family(`family') link(`link')
		
		if "`weight'" != "" local wopt [`weight'`exp']
		else local wopt
		if `i' == 1 {
			if `"`opt_if'"' != "" {
				local if `if' `opt_if'
			}
			if `"`opt_in'"' != "" {
				local if `in' `opt_in'
			}
		}
		
		if `fe' {
			local ++fe_ix
			if `fe_ix' > 1 {
				di "{err}only one fixed-effects equation allowed"
				exit 198
			}
			fvunab vars : `anything'
			gettoken dv1 vars : vars
			gettoken ull vars : vars
			if missing("`ull'") {
				di "{err}two dependent variables required"
				exit 198
			}
			fvexpand `dv1' `ull'
			if "`r(fvops)'"=="true" {
				di "{err}depvar may not be a factor variable"
				exit 198
			}
			local anything `dv1' `vars'
		}
		
		local 0 `anything' `if' `in', family(`family') link(`link') ///
			binomial(`binomial') exposure(`exposure') `options'
		quietly ///
		syntax [anything] [if] [in] [, family(passthru) ///
			link(passthru) binomial(passthru) exposure(passthru) *]
		local eq_`i' `anything' `if' `in' `wopt', `family' `link' ///
			`binomial' `exposure' `options'
		
		local eqs `eqs' `eq_`i'' ||
		local dixtra `dixtra' `or' `eform'
	}

	local 0 `eq_`eq_n''

	local fe = !strpos(`"`0'"',":")

	syntax [anything] [if] [in] [fw pw iw] [, *]

	if `fe' {
		local ++fe_ix
		if `fe_ix' > 1 {
			di "{err}only one fixed-effects equation allowed"
			exit 198
		}
		fvunab vars : `anything'
		gettoken dv1 vars : vars
		gettoken ull vars : vars
		if missing("`ull'") {
			di "{err}two dependent variables required"
			exit 198
		}
		fvexpand `dv1' `ull'
		if "`r(fvops)'"=="true" {
			di "{err}depvar may not be a factor variable"
			exit 198
		}
		if "`r(tsops)'"=="true" {
			di "{err}depvar may not contain time-series operators"
			exit 198
		}
		local anything `dv1' `vars'
	}

	if `eq_n' == 1 {
		if `"`opt_if'"' != "" {
			local if `if' `opt_if'
		}
		if `"`opt_in'"' != "" {
			local if `in' `opt_in'
		}
	}
	if "`weight'" != "" {
		local eqn `anything' `if' `in' [`weight'`exp']
	}
	else {
		local eqn `anything' `if' `in'
	}
	local 0 , `options' `gopts'
	syntax [anything] [, BINomial(string) noTABle noLRtest noGRoup 	///
		noHEADer NOLOg LOg or irr eform Family(string) Link(string) ///
		EXPosure(string) noESTimate COEFLegend * ]
	
	_me_chk_opts, family(`family') link(`link') exposure(`exposure') ///
		irr(`irr') binomial(`binomial')
	local dixtra `dixtra' `or' `eform'
	local dixtra : list uniq dixtra
	opts_exclusive "`dixtra'"
	
	_get_diopts diopts opts, `options'
	local diopts `diopts' `table' `lrtest' `group' `header' ///
		`log' `nolog' 	///
		`estimate' `coeflegend' `dixtra'
	
	local family family(gaussian)
	
	local 0 , `opts'
	syntax [, ul(string) ll(string) *]
	if !missing("`ul'") {
		di as err "option {bf:ul()} not allowed"
		exit 198
	}
	if !missing("`ll'") {
		di as err "option {bf:ll()} not allowed"
		exit 198
	}	
	local opts `options' udepvar(`ull')
	
	local 0 `eqs' `eqn' , link(identity) `family' `opts' ///
		`log' `nolog' `estimate' ///
		`coeflegend'

	`vv' _me_estimate "`bytouse'" `0'
	
	ereturn local family gaussian
	ereturn local link identity
	
	if e(k_r) ereturn local title "Mixed-effects interval regression"
	else ereturn local title "Interval regression"
	ereturn local model interval
	
	tempname cmat
	mat `cmat' = e(yinfo1_cens_info)
	ereturn scalar N_unc = `cmat'[1,1]
	ereturn scalar N_lc  = `cmat'[1,2]
	ereturn scalar N_rc  = `cmat'[1,3]
	ereturn scalar N_int = `cmat'[1,4]
	
	local off `e(offset1)'
	ereturn local offset `off'
	ereturn hidden local offset1 `off'
	ereturn hidden local footnote `e(footnote)'
	
	ereturn local depvar `dv1' `ull'
	
	ereturn local cmd2 meintreg
	ereturn local cmdline meintreg `0_orig'
	
	ereturn local predict meintreg_p
	ereturn local estat_cmd meintreg_estat
	ereturn local cmd meglm
	ereturn hidden local cmdline2

	_me_display , `diopts'
		
end
exit
