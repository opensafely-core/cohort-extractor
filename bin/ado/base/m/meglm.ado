*! version 1.1.7  16aug2018
program meglm, eclass byable(onecall) prop(or irr svyg bayes xtbs)
	version 13
	local vv : di "version " string(_caller()) ", missing:"

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd)'" != "meglm" & "`e(cmd2)'" != "meglm" {
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

	_me_parse `0'
	local 0_new `s(newsyntax)'
	local diopts `s(diopts)'
	
	`vv' _me_estimate "`bytouse'" `0_new'
	
	ereturn local cmdline meglm `0'
	
	_me_display, `diopts'
end
exit
