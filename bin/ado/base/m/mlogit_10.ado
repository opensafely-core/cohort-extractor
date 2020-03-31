*! version 1.3.0  17apr2018
program define mlogit_10, eclass byable(onecall) ///
		prop(rrr svyb svyj svyr)
	version 9, missing
	local version : di "version " string(_caller()) ", missing :"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	syntax [anything] [if] [in] [fw iw pw aw] [,		///
		VCE(passthru) Robust CLuster(passthru) NOLOg LOg * ///
	]
	if `:length local vce' {
		`version' `BY' _vce_parserun mlogit, mark(OFFset CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"`version' mlogit `0'"'
			exit
		}
		_vce_parse, argopt(CLuster) opt(OIM Robust) old		///
			: [`weight'`exp'], `vce' `robust' `cluster'
		if "`r(cluster)'" != "" {
			local cluster cluster(`r(cluster)')
		}
		local robust `r(robust)'
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "oim")
	}
	else if "`weight'" == "pweight" | "`robust'`cluster'" != "" {
		local vce robust
	}
	else local vce oim
	if replay() {
		if "`e(cmd)'" != "mlogit" {
			error 301
		}
		if _by() {
			error 190
		}
		`version' Display `0'
		exit
	}
	
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	`version' `BY' _mlogit `anything' `if' `in'		///
		[`weight'`exp'], `options' `robust' `cluster' `log'
	ereturn local vce "`vce'"
	ereturn local title "Multinomial logistic regression"
	ereturn local footnote "mlogit_footnote"
	ereturn local baselab : label (`e(depvar)') `e(baseout)'
	ereturn scalar k_eq_model = e(k_out) - 1
	ereturn local cmdline `"`version' mlogit `0'"'
end

program Display
	version 9
	syntax [, Level(cilevel) * ]
	local version : di "version " string(_caller()) ":"
	if "`e(prefix)'" != "" {
		_prefix_display, level(`level') `options'
	}
	else	`version' _mlogit, level(`level') `options'
end

exit
