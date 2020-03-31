*! version 1.3.2  16aug2018
program meoprobit, eclass byable(onecall) prop(svyg bayes xtbs)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd2)'" != "meoprobit" {
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
	_me_parse `0'
	if "`s(family)'" != "" {
		di as err "option {bf:family()} not allowed"
		exit 198
	}
	if "`s(link)'" != "" {
		di as err "option {bf:link()} not allowed"
		exit 198
	}
	local 0_new `s(newsyntax)'
	local diopts `s(diopts)'
	
	_parse expand eq opt : 0_new	
	local 0 `eq_`eq_n''
	
	syntax [anything] [if] [in] [fw pw iw] [, or irr ///
		Family(string) Link(string) EXPosure(string) *]
	_me_chk_opts, family(`family') link(`link') exposure(`exposure') ///
		or(`or') irr(`irr') binomial(`binomial')
	
	local 0_new `0_new' link(probit) fam(ordinal)

	`vv' _me_estimate "`bytouse'" `0_new'
	
	ereturn local family ordinal
	ereturn local link probit
	
	if e(k_r) ereturn local title "Mixed-effects oprobit regression"
	else ereturn local title "Ordered probit regression"
	ereturn local model oprobit
	
	ereturn local predict meoprobit_p
	ereturn local estat_cmd meoprobit_estat
	ereturn local cmd2 meoprobit
	ereturn local cmdline meoprobit `0_orig'
	
	ereturn local cmd meglm
	ereturn hidden local cmdline2
	
	_me_display, `diopts'
end
exit
