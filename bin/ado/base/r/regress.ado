*! version 1.3.2  28feb2018
program define regress, eclass byable(onecall) ///
		prop(svyb svyj svyr swml mi bayes)
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"

	if replay() {
		if _by() {
			error 190
		}
		`version' Display `0'
		exit
	}
	syntax [anything] [if] [in] [aw fw iw pw] [,		///
		VCE(passthru) Robust CLuster(passthru)		///
		HC2 HC3						///
		beta						///
		EForm(passthru)					///
		noHEader					///
		noTABle						///
		plus						///
		*						///
	]
	local diopts0 `beta' `eform' `header' `table' `plus'
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if `:length local vce' {
		`version' `BY' _vce_parserun regress,		///
			mark(CLuster) eq(NOConstant) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"regress `0'"'
			exit
		}
		_vce_parse, argopt(CLuster) opt(OLS Robust HC2 HC3) old	///
			: [`weight'`exp'], `vce' `robust' `cluster'
		if "`r(cluster)'" != "" {
			local cluster cluster(`r(cluster)')
		}
		else if "`r(vce)'" != "ols" {
			local robust = "`r(vce)'"
		}
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "ols")
		if "`hc2'`hc3'" != "" {
			if !inlist("`vce'", "ols", "`robust'", "`hc2'`hc3'") {
				opts_exclusive "vce(`vce') `hc2' `hc3'"
			}
			local vce `hc2' `hc3'
			local options `options' `vce'
		}
	}
	else if "`cluster'" != "" {
		local vce cluster
	}
	else if "`weight'" == "pweight" | "`robust'" != "" {
		local vce robust
	}
	else if "`hc2'`hc3'" != "" {
		local vce `hc2' `hc3'
		local options `options' `vce'
	}
	else	local vce ols
	_get_diopts diopts options, `options'
	if _by() {
		`version' `BY' BYREG `anything' `if' `in'	///
			[`weight'`exp'], `options'		///
			`diopts0' `diopts' `robust' `cluster'
	}
	else {
		`version' _regress `anything' `if' `in'		///
			[`weight'`exp'], `diopts0' `diopts' 	///
			`options' `robust' `cluster'
	}
	ereturn local vce `vce'
	ereturn local marginsok "XB default"
        ereturn hidden local marginsprop minus 
	ereturn local title "Linear regression"
	ereturn local cmdline `"regress `0'"'
	_post_vce_rank, checksize
end

program BYREG, byable(recall)
	local version : di "version " string(_caller()) ", missing :"
	version 9
	syntax varlist(ts fv) [if] [in] [aw fw iw pw] [, *]
	marksample touse
	`version' _regress `varlist' if `touse' [`weight'`exp'], `options'
end

program Display
	version 9
	local version : di "version " string(_caller()) ":"
	syntax [, Level(cilevel) noHEader * ]
	_get_diopts diopts options , `options'
	if "`e(prefix)'" != "" {
		_prefix_display, level(`level') `header' `diopts' `options'
	}
	else {
		`version' _regress, level(`level') `header' `diopts' `options'
		_prefix_footnote
	}
end

exit
