*! version 4.2.7  28jan2015  
program define gprobit, eclass byable(onecall)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}

	if _caller() < 9 {
		`BY' gprobit_8 `*'
		exit
	}

	`BY' _vce_parserun gprobit, jkopts(eclass) numdepvars(2): `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"gprobit `0'"'
		exit
	}

	local vv : display "version " string(_caller()) ", missing:"
	version 6.0, missing
	if `"`*'"'==`""' | bsubstr(`"`1'"',1,1)==`","' { 
		if `"`e(cmd)'"'!=`"gprobit"' { error 301 } 
		if _by() { error 190 }
		Replay `0'
		exit
	}
	else { 
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"gprobit `0'"'
end

program Estimate, eclass byable(recall)
	version 6.0, missing
	syntax varlist(min=2 fv) [if] [in] [, Level(cilevel) vce(passthru) *]
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
	tempvar S P PROBIT xb wt
	quietly {
		gen long `S'=`1' if `1'>=0
		gen long `P'=`2' if `2'>=0 & `1'<=`2'
		gen double `PROBIT'=invnorm(`S'/`P') if `touse'
		mac shift 2
		/* Stage one OLS to get weights */
		`vv' noi ///
		_regress `PROBIT' `*' if `touse', notable noheader
		predict double `xb', xb
		gen double `wt' = norm(`xb')
		replace `wt' = `P'*(normden(`xb'))^2 / (`wt'*(1-`wt'))
		`vv' ///
		_regress `PROBIT' `*' [aw=`wt'] if `touse', depname(`lhs1')
		if `fvops' {
			est repost, buildfvinfo
		}
	}
	est local cmd
	est local estat_cmd "" 		/* override what _regress set */
	est local wexp
	est local wtype 
	est local ll
	est local ll_0
	est local vce ols
	est local depvar "`lhs'"
	est local predict "gprobi_p"
	est local marginsok "N Pr XB default"
	est local title ///
		`"Weighted LS probit regression for grouped data"'
	est local cmd "gprobit"
	global S_E_cmd "gprobit"   /* double save */
	_post_vce_rank

	Replay, level(`level') `diopts'
end

program Replay
	syntax [, Level(cilevel) *]
	_get_diopts diopts, `options'
	if "`e(prefix)'" == "" {
		di _n as txt `"`e(title)'"'
	}
	regress, level(`level') `diopts'
end

exit

/*
Prior to version 9 of Stata, the weights were calculated using the
observed proportions in the formula n*p*(1-p).  Now we run a first-
stage OLS regression to get predicted p's and use those in the weights
instead.  See Greene (3rd ed., p. 896, fn. 24). BPP
*/
