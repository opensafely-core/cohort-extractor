*! version 3.5.7  03jul2012
program define bprobit, eclass by(onecall)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun bprobit, jkopts(nocount)	///
		numdepvars(2)	///
		mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"bprobit `0'"'
		exit
	}

	version 6, missing
	local vv : display "version " string(_caller()) ", missing:"
	if replay() {
		if "`e(cmd)'"!="bprobit" { error 301 }
		if _by() { error 190 }
		syntax [, Level(cilevel) *]
		_get_diopts diopts, `options'
		loc dep "`e(depvar)'"
		est local depvar "_outcome"
		`vv' probit, level(`level') `diopts'
		est local depvar "`dep'"
		exit
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"bprobit `0'"'
end

program Estimate, eclass byable(recall)
	version 6, missing
	local vv : display "version " string(_caller()) ", missing:"
	syntax varlist(min=2 fv) [if] [in] [, CLuster(varname) /*
		*/ OFFset(varname) Level(cilevel) /*
		*/ LOg SCore(string) *]
	
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	marksample touse 

	qui count if `touse'
	if r(N)==0 { error 2000 }

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
	if "`cluster'"~= "" { local clopt "cluster(`cluster')" }
 
 	if `"`score'"'~= "" {
 		di as err "score() not allowed with bprobit"
 		exit 198
 	}

	preserve
	quietly {
		keep if `touse'
		unopvarlist `varlist'
		keep `r(varlist)' `cluster' `offset'
		confirm new var _outcome
		tokenize `varlist'
		local lhs "`1' `2'"

		local k = _N
		local k1 = _N + 1

		tempvar pop
		quietly expand =2, clear
		gen byte _outcome=0 in 1/`k'
		replace _outcome=1 in `k1'/l
		gen `pop'=`2'-`1' in 1/`k'
		qui count if `pop'<0
		if `r(N)' {
			qui sum `2' if `pop'<0
			version 10:     ///
			noi di as txt _n ///
"{p 0 7 4}Note:  `r(sum)' observations with `2' < `1' were dropped.{p_end}"
			replace `pop' =  . if `pop'<0
		}
		replace `pop'=`1' in `k1'/l if `2' >= `1'
		mac shift 2
	}

	if `fvops' & _caller() < 11 {
		local vv "version 11:"
	}

	`vv' ///
	probit _outcome `*' [freq=`pop'], level(`level') `options' `log' /*
		*/ `clopt' `offopt' grouped

	/* the e() stuff is inherited from -probit- except e(cmd) */
	/* double save in S_E_<stuff> and e() */
	est local cmd
	est local estat_cmd ""	/* override what probit set */
	est local wexp
	est local wtype
	est local depvar "`lhs'"
	est local predict "gprobi_p"
	est local marginsok "N Pr XB default"
	est local marginsnotok
	est local title "Probit regression for grouped data"
	
	global S_E_nobs=e(N)
	global S_E_ll=e(ll)
	global S_E_mdf=e(df_m)
	global S_E_cmd "bprobit"
	restore
	est repost, esample(`touse') buildfvinfo
	est local cmd "bprobit"
end
