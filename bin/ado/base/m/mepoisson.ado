*! version 1.2.2  16aug2018
program mepoisson, eclass byable(onecall) prop(irr svyg bayes xtbs)
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd2)'" != "mepoisson" {
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
	
	syntax [anything] [if] [in] [fw pw iw] [, or ///
		Family(string) Link(string) *]
	_me_chk_opts, family(`family') link(`link') or(`or')
	
	local 0_new `0_new' link(log) fam(poisson)

	`vv' _me_estimate "`bytouse'" `0_new'
	
	ereturn local family poisson
	ereturn local link log
	
	if e(k_r) ereturn local title "Mixed-effects Poisson regression"
	else ereturn local title "Poisson regression"
	ereturn local model Poisson
	
	ereturn local cmd2 mepoisson
	ereturn local cmdline mepoisson `0_orig'
	
	ereturn local predict mepoisson_p
	ereturn local estat_cmd mepoisson_estat
	ereturn local cmd meglm
	ereturn hidden local cmdline2
	
	_me_display, `diopts'	
end
exit
