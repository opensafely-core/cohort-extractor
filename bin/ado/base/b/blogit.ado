*! version 3.6.1  03jul2012
program define blogit, eclass byable(onecall) properties(or)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun blogit, jkopts(nocount)	///
		numdepvars(2)	///
		mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"blogit `0'"'
		exit
	}

	version 6, missing
	local vv : display "version " string(_caller()) ", missing:"
	if replay() {
		if "`e(cmd)'"!="blogit" { error 301 }
		if _by() { error 190 }
		syntax [, Level(cilevel) or *]
		_get_diopts diopts, `options'
		loc dep "`e(depvar)'"
		est local depvar "_outcome"
		`vv' logit, level(`level') `or' `diopts'
		est local depvar "`dep'"
		exit
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"blogit `0'"'
end

program Estimate, eclass byable(recall)
	version 6, missing
	local vv : display "version " string(_caller()) ", missing:"
	syntax varlist(min=2 fv) [if] [in] [, 	///
		CLuster(passthru) 		///
		Robust				///
		VCE(passthru)			/// 
		OFFset(varname) 		///
		Level(cilevel) 			///
		or 				///
		LOg 				///
		SCore(string) 			///
		*				///
	]
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	marksample touse

	qui count if `touse'
	if r(N)==0 { error 2000 } 

	
	local vceopt =	`:length local vce'		|	///
	   		`:length local cluster'		|	///
	   		`:length local robust'
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(OIM OPG Robust) old	///
			: [`weight'`exp'], `vce' `robust' `cluster'
		local vce
		if "`r(cluster)'" != "" {
			local clvar `r(cluster)'
			local vce vce(cluster `r(cluster)')
		}
		else if "`r(robust)'" != "" {
			local vce vce(robust)
		}
		else if "`r(vce)'" != "" {
			local vce vce(`r(vce)')
		}
	}
	tokenize `varlist'
	_fv_check_depvar `1', depname(pos_var)
	_fv_check_depvar `2', depname(pop_var)
	cap assert `1' == int(`1') if `touse'
	if _rc {
		di as err "`1' is not integer valued"
		exit 459
	}
	cap assert `2' == int(`2') if `touse'
	if _rc {
		di as err "`2' is not integer valued"
		exit 459
	}

	if "`log'"=="" { local log "nolog" } 

	if "`offset'" ~= "" { local offopt "offset(`offset')" }

	if `"`score'"'~= "" {
		di as err "score() not allowed with blogit"
		exit 198
	}

	preserve 
	quietly { 
		keep if `touse'
		unopvarlist `varlist'
		keep `r(varlist)' `clvar' `offset'
		confirm new var _outcome
		tokenize `varlist'
		local lhs "`1' `2'"

		local k = _N
		local k1 = _N + 1
		expand =2, clear

		tempvar pop
		gen byte _outcome=0 in 1/`k'
		replace _outcome=1 in `k1'/l
		gen `pop'=`2'-`1' in 1/`k'
		qui count if `pop'<0
		if `r(N)' {
			qui sum `2' if `pop'<0
			version 10:	///
			noi di as txt _n "{p 0 7 4} Note:  `r(sum)' " /*
		*/ "observations with `2' < `1' were dropped.{p_end}"
			replace `pop' =  . if `pop'<0
		}
		replace `pop'=`1' in `k1'/l if `2'>=`1'
		mac shift 2
	}

	if `fvops' & _caller() < 11 {
		local vv "version 11:"
	}

	`vv' ///
	logit _outcome `*' [freq=`pop'], level(`level') `or' /*
		*/ `options' `log' `offopt' `vce' grouped

	/* the e() stuff is inherited from -logit- except e(cmd) */
	/* double save in S_E_<stuff> and e() */
	est local cmd
	est local wexp
	est local wtype
	est local depvar "`lhs'"
	est local predict "glogit_p"
	est local marginsok "N Pr XB default"
	est local marginsnotok
	est local estat_cmd ""		/* override what logit set */
	est local title "Logistic regression for grouped data"
	
	global S_E_nobs = e(N)
	global S_E_ll = e(ll)
	global S_E_mdf = e(df_m)
	global S_E_cmd "blogit"
	restore
	est repost, esample(`touse') buildfvinfo
	est local cmd "blogit"
end
