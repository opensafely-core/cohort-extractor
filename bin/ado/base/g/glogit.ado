*! version 4.2.6  03jul2012
program define glogit, eclass byable(onecall) properties(or)

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if _caller() < 9 {
		`BY' glogit_8 `*'
		exit
	}

	`BY' _vce_parserun glogit, jkopts(eclass) numdepvars(2): `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"glogit `0'"'
		exit
	}

	local vv : display "version " string(_caller()) ", missing:"
	version 6.0, missing
	if replay() {
		if `"`e(cmd)'"'!=`"glogit"' { error 301 } 
		if _by() { error 190 }
		Replay `0'
		exit
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"glogit `0'"'
end

program Estimate, eclass byable(recall)
	version 6.0, missing
	syntax varlist(min=2 fv) [if] [in] [, ///
		or Level(cilevel) vce(passthru) *]
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}
	else	local vv : display "version " string(_caller()) ", missing:"
	_get_diopts diopts, `options'
	if `"`vce'"' != "" {
		_vce_parse, opt(OLS) :, `vce'
	}
	marksample touse
	tokenize `varlist'
	_fv_check_depvar `1', depname(pos_var)
	_fv_check_depvar `2', depname(pop_var)
	local lhs1 "`1'"
	local lhs "`1' `2'"
	tempvar S F LOGIT xb L
	quietly {
		gen double `S'=`1' if `1'>=0 /* NB: S+F = n(i) */
		gen double `F'=`2'-`1' if `2'>=0 & `2'>`1'
		gen double `LOGIT'=log(`S'/`F') if `touse'
		mac shift 2
		/* Stage one to get consistent estimates of weights */
		`vv' noisily ///
		_regress `LOGIT' `*' if `touse', notable noheader
		predict double `xb', xb
		gen double `L' = exp(`xb') / ( 1 + exp(`xb'))
		replace `L' = `L'*(1-`L')*(`S'+`F')
		`vv' ///
		_regress `LOGIT' `*' [aw=`L'] if `touse', depname(`lhs1')
		if `fvops' {
			est repost, buildfvinfo
		}
	}
	est local cmd
	est local estat_cmd "" 		/* override what _regress set */
	est local depvar "`lhs'"
	est local wexp
	est local wtype
	est local ll
	est local ll_0
	est local vce ols
	est local predict "glogit_p"
	est local marginsok "N Pr XB default"
	est local title ///
		`"Weighted LS logistic regression for grouped data"'
	est local cmd "glogit"   /* double save in e() and S_E_ */
	global S_E_cmd "glogit"
	_post_vce_rank

	Replay, level(`level') `or' `diopts'
end

program Replay
	syntax [, or Level(cilevel) *]
	_get_diopts diopts, `options'
	if `"`or'"'!=`""' { local or `"eform(Odds Ratio)"' }
	if "`e(prefix)'" == "" {
		di _n as txt `"`e(title)'"'
	}
	regress, level(`level') `or' `diopts'
end

exit

/*
Prior to version 9 of Stata, the weights were calculated using the
observed proportions in the formula n*p*(1-p).  Now we run a first-
stage OLS regression to get predicted p's and use those in the weights
instead.  See Greene (3rd ed., p. 896, fn. 24). BPP
*/
