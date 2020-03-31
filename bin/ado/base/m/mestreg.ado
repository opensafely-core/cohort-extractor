*! version 1.2.0  03dec2018
program mestreg, eclass byable(onecall) prop(or irr svyg bayes)
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	local 0_orig `0'

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if _by() {
			error 190
		}

		_parse expand eq opt : 0
		if `eq_n' local 0 `eq_`eq_n''
		else local 0 , `opt_op'
		syntax [anything] [, Distribution(string) *]
		if "`distribution'"=="" {
			if "`e(cmd)'" != "mestreg" & "`e(cmd2)'" != "mestreg" {
				error 301
			}
			local 0 `0_orig'
			_me_display `0'
			exit
		}
	}

	capture noisily `vv' `by' Estimate `0_orig'
	local rc = _rc
	exit `rc'
end

program Estimate, sortpreserve eclass byable(recall)
	version 14
	local vv : di "version " string(_caller()) ", missing:"

	st_is 2 analysis
	local st_wt : char _dta[st_wt]
	
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	
	local 0_orig `0'
	_parse expand eq opt : 0
	if `eq_n'==0 {
		local 0 _t `0'
		_parse expand eq opt : 0
	}
	local gopts `opt_op'	
	local gif `opt_if'
	local gin `opt_in'

	local fe_ix 0

	// if fe_eq has no covariates, process fe_eq first
	if `eq_n'==1 {
		local re = strpos(`"`0'"',":")
		if `re' {
			_get_diopts diopts gopts, `gopts'
			
			_more_diopts, `gopts'
			local diopts `diopts' `s(more)'
			local gopts `s(options)'
			
			local eqs _t `gif' `gin', `gopts' ||
			local ++fe_ix
			local gopts
		}
	}
	
	forvalues i=1/`=`eq_n'-1' {
		local 0 `eq_`i''
		
		local fe = !strpos(`"`0'"',":")
		
		syntax [anything] [if] [in] [fw pw iw] [, noHR TRatio 	///
			eform EFORM1(string) or irr *]
		_me_chk_opts, eform(`eform'`eform1') or(`or') irr(`irr')
		if "`weight'" != "" local wopt [`weight'`exp']
		else local wopt
		
		if `fe' {
			local ++fe_ix
			if `fe_ix' > 1 {
				di "{err}only one fixed-effects equation allowed"
				exit 198
			}
			local hast : list posof "_t" in anything
			if !`hast' local anything _t `anything'
			local gif `gif' `if'
			local gin `gin' `in'
		}
		
		_get_diopts dis options, `options' `hr' `tratio'
		local diopts `diopts' `dis'
		
		_more_diopts, `options'
		local diopts `diopts' `s(more)'
		local options `s(options)'
		
		if `fe' {
			local eqs `eqs' `anything' `gif' `gin' `wopt', `options' ||
		}
		else 	local eqs `eqs' `anything' `wopt', `options' ||
		local me_wt `me_wt'`weight'
		local ifin
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
		local hast : list posof "_t" in anything
		if !`hast' local anything _t `anything'
	}

	if "`weight'" != "" {
		local eqn `anything' `if' `in' [`weight'`exp']
		local me_wt `me_wt'`weight'
	}
	else {
		local eqn `anything' `if' `in'
	}

	local 0 , `options' `gopts'
	syntax [anything] [, TIme /* documented abbrev. -time- */ ///
		EXPosure(passthru) noSHow xtcmd ///
		Family(passthru) Link(passthru) ///
		Distribution(passthru) /*documented abbrev. -dist- */ ///
		noHR TRatio eform EFORM1(string) or irr *]

	if !missing("`st_wt'") & missing("`xtcmd'") & missing("`me_wt'") {
		di "{err}{bf:stset} weights not allowed"
		exit 459
	}

	_get_diopts dis options, `options' `hr' `tratio'
	local diopts `diopts' `dis'
	
	_more_diopts, `options'
	local diopts `diopts' `s(more)'
	local options `s(options)'
	local diopts : list uniq diopts
	
	_me_chk_opts, `family' `link' `exposure' eform(`eform'`eform1') ///
		or(`or') irr(`irr')
	_chk_dist, `distribution'
	local dist `s(dist)'
	local model `s(model)'
	if "`dist'" == "exponential" | "`dist'" == "weibull" {
		if "`time'"=="time" {
			local aft aft
			local frm2 time
		}
		else local frm2 hazard
	}
	else local frm2 time

	_chk_diopts, dist(`dist') `time' `diopts'

	local family family(`dist', failure(_d) ltruncated(_t0) `aft')
	local stopts `family' `exposure' streg

	st_show `show'

	if !`fe_ix' local eqs _t `gif' `gin' || `eqs'

	local 0 `eqs' `eqn', `options' `diopts' `stopts' `xtcmd'

	`vv' _me_estimate "`bytouse'" `0'

	ereturn local distribution `dist'
	ereturn hidden local family `dist'
	ereturn hidden local link log

	if "`frm2'"=="time" {
		local tt "AFT "
	}
	else local tt "PH "

	if e(k_r) ereturn local title `"Mixed-effects `model' `tt'regression"'
	else ereturn local title `"`=proper("`model'")' regression`tf'"'
	ereturn local model `model'

	ereturn local frm2 `frm2'
	ereturn local cmd2 mestreg
	ereturn local cmdline mestreg `0_orig'

	ereturn local marginsnotok	stdp		///
					reffects	///
					scores
	ereturn local predict mestreg_p
	ereturn hidden local marginsfootnote _multirecordcheck
	ereturn local estat_cmd mestreg_estat
	ereturn local cmd gsem
	ereturn hidden local cmdline2

	ereturn hidden local stcurve stcurve

	_me_display , `diopts'
	
	if !missing("`st_wt'") & !missing("`me_wt'") {
		di "{txt}Note: {bf:stset} weights ignored."
	}
end

program _chk_dist, sclass
	syntax , Distribution(string)

	gettoken 0 rest : distribution, parse(",")
	local 0 , `0'
	capture syntax [, Exponential LOGLogistic LLogistic Weibull 	///
		LOGNormal LNormal GAMma ]
	local rc _rc
	
	local dist `exponential' `loglogistic' `llogistic' `weibull'	///
		`lognormal' `lnormal' `gamma'
	opts_exclusive "`dist'" distribution
	
	if `rc' {
		di "{err}option {bf:distribution()} invalid"
		exit 198
	}
	
	if !missing("`llogistic'") local dist loglogistic
	if !missing("`lnormal'") local dist lognormal
	
	local model `dist'
	if "`model'"=="weibull" local model "Weibull"
	
	sreturn local dist `dist'
	sreturn local model `model'
end

program _more_diopts, sclass
	syntax [, noTABle noLRtest noGRoup noHEADer NOLOg LOg noESTimate ///
		COEFLegend noHR TRatio *]
	
	sreturn clear
	sreturn local more `table' `lrtest' `group' `header' `log' `nolog' ///
		`estimate' `coeflegend' `hr' `tratio'
	sreturn local options `options'
end

program _chk_diopts
	syntax, dist(string) [ TIme TRatio noHR *]
	
	local t1 = inlist("`dist'","weibull","exponential")
	local t2 = "`time'"=="time"

	if `t1' {
		if `t2' {
			if "`hr'"=="nohr" {
				di "{err}option {bf:nohr} not allowed"
				exit 198
			}
		}
		else {
			if "`tratio'"!="" {
				di "{err}option {bf:tratio} not allowed"
				exit 198
			}
		}
	}
	else {
		if "`hr'"=="nohr" {
			di "{err}option {bf:nohr} not allowed"
			exit 198
		}
	}
end

exit
