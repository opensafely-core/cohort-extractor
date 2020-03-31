*! version 1.2.0  19feb2019
program _stpower
	version 10
	/* check cmds */
	gettoken cmd 0 : 0, parse(" ,")
	if `"`cmd'"' == "log" {
		local cmd Logrank
		local argnames survival probabilities
	}
	else if `"`cmd'"' == "exp" {
		local cmd Exponential
		syntax [anything] [, T(string) * ]
		if `"`t'"' == "" {
			local argnames hazard rates
		}
		else {
			local argnames survival probabilities
		}
	}
	else if `"`cmd'"' == "cox" {
		local cmd Cox
		local argnames coefficients
	}
	syntax [anything] [, HRATio(string) Power(string) Alpha(string)	 ///
			     p1(string) NRATio(string) Beta(string)	 ///
			     N(string) ONESIDed	TABLECOL(string) TABle 	 ///
			     noHEADer CONTinue noTItle SEPARATOR DETAIL	 ///
			     noLEGend COLWidth(numlist)			 ///
			     SAVing(string) POSTNAME(string) FIRSTCALL   ///
			     FIRSTPART LASTCALL REPLACE noOUTPUT DIVider * ]
	/* check opts */
	if `"`header'"' != "" {
		local title notitle
		if `"`cmd'"' != "Cox" {
			local note note(qui)
		}
	}
	/* tablecol(), columns() */
	if `"`table'"' == "" & `"`tablecol'"' == "" {
		if `"`separator'`header'`continue'`title'`legend'"'!= "" | ///
						    `"`colwidth'"' != ""  {
			di as err "{p 0 0 30}noheader, notitle, "	///
				  "continue, nolegend, separator(), "	///
				  "and colwidth() require "		///
				  "table or columns(){p_end}"
			exit 198
		}
	}
	if `"`cmd'"' != "Cox" & (`"`title'"' != "" | `"`firstcall'"' == "") {
		local note note(qui)
	}
	if `"`colwidth'"' == "" {
		local colwidth 9
	}
	local tabopts `separator' `header' `continue' `legend' `title' `output' 
	local tabopts `tabopts' colwidth(`colwidth') saving(`"`saving'"') 
	local tabopts `tabopts' `replace'
	local tabopts `tabopts' postname(`postname') `firstcall' `lastcall'
	local tabopts `tabopts' `firstpart' `divider'
	/* p1(), nratio() */
	if `"`p1'"' != "" {
		local nratio = (1-`p1')/`p1'
	}
	else if `"`nratio'"' != "" {
		local p1 = 1/(`nratio'+1)
	}
	else {
		local p1 = 0.5
		local nratio = 1
	}
	/* alpha() */
	if `"`alpha'"' == "" {
		local alpha = 0.05
	}
	/* beta(), power() */
	if `"`beta'"' != "" {
		if `"`n'"' != "" {
			local solve solve(hr)
		}
		local power = 1 - `beta' 
	}
	else {
		if `"`power'"' != "" {
			if `"`n'"' != "" {
				local solve solve(hr)
			}
			local beta = 1 - `power' 
		}
		else if `"`n'"' == "" {
			local beta = 0.2
			local power = 0.8
		}
	}
	/* n() */
	if `"`n'"' == "" {
		local sampsi sampsi
	}
	/* hratio() */
	if `"`hratio'"' != "" {
		cap assert `hratio' != 1
		if _rc {
			di as err "hratio() values must be positive "	///
				  "numbers different from 1" 
			exit 198
		}
		cap assert `hratio' > 1.0e-6
		if _rc {
di as err "hazard ratio is too small (<= 1.0e-6)"
exit 198
		}
		cap assert reldif(`hratio',1) > 1.0e-6 
		if _rc {
di as err "hazard ratio is too close to 1; reldif(hratio,1) <= 1.0e-6"
exit 198
		}
	}
	else {
		local hratio = 0.5
	}
	gettoken args: 0, parse(",")
	if `"`args'"' == "," {
		local args ""
	}
	local k: word count `args'
	tempname arg1 arg2
	if `k' == 0 {
		scalar `arg1' = 0
		scalar `arg2' = 0
	}
	else if `k' == 1 {
		scalar `arg2' = 0
		scalar `arg1' = `args'
	}
	else {
		tokenize `args'
		cap assert `1' != `2'
		if _rc {
			di as err `"{p}`argnames' in the control and the "' ///
				  "experimental groups must be different{p_end}"
			exit 198
		}
		scalar `arg1' = `1'
		scalar `arg2' = `2'
	}
	mata: _stpower_struct = _stpower_setup_base(`=`arg1'',`=`arg2'')
	cap noi `cmd' `args', `options' `sampsi' `note' `solve'
	local rc = _rc
	if `rc' {
		cap mata mata drop _stpower_struct
		exit `rc'
	}
	else {
		if `"`table'`tablecol'"' != "" { /* table */
			cap noi DiTable, table(`tablecol'`table') `tabopts' ///
		 				cmd(`=usubstr(`"`cmd'"',1,3)')
			local rc = _rc
		}
		else if `"`output'"' == ""{ /* output */
			mata: _stpower_checkexist("_stpower_struct")
			cap noi mata: ///
		   _stpower_display("`=usubstr(`"`cmd'"',1,3)'", _stpower_struct)
			local rc = _rc
		}
		cap mata mata drop _stpower_struct
		exit `rc'
	}
end

program Cox, rclass
	version 10
	syntax [anything] [, SD(real 0.5) FAILProb(real 1) r2(real 0) HR ///
			     WDProb(real 0) SAMPSI SOLVE(string) ]
	/* check input argument */	
	local k: word count `anything'
	if "`anything'" != "" {
		if `anything' == 0 {
			di as err "coefficients must not be equal to 0"
			exit 198
		}
		if reldif(`anything',0) <= 1.0e-6 {
			di as err "coefficient value is too close to 0; " ///
				  "reldif(b1,0) <= 1.0e-6 "
			exit 198
		}
	}
	/* sd() */
	ChkOpts sd `sd' 0
	cap assert `sd' > 1e-6
	if _rc {
		di as err "standard deviation is too small (<= 1.0e-6)"
		exit 198
	}
	/* r2() */
	cap assert `r2'>=0 & `r2'<1
	if _rc {
		di as err "r2() must be a number between 0 and 1"
		exit 198
	}
	/* failprob() */
	cap assert `failprob'>0 & `failprob'<=1
	if _rc {
		di as err "failprob() must be a number between 0 and 1"
		exit 198
	}
	/* wdprob() */
	if `wdprob' != 0 {
		if `"`sampsi'"' == "" {
			di as err "wdprob() may not be combined with n()"
			exit 198
		}
		cap assert `wdprob'>=0 & `wdprob'<1
		if _rc {
			di as err "wdprob() must be a number between 0 and 1"
			exit 198
		}
	}
	mata: _stpower_checkexist("_stpower_struct")
	mata: _stpower_setup_cox(_stpower_struct)
	mata: _stpower_work_cox(_stpower_struct)
	ret add
end

program Logrank, rclass
	version 10
	syntax [anything] [, SCHoenfeld WDProb(real 0) SIMPson(string)  ///
			     st1(varlist numeric min=2 max=2) SAMPSI ///
			     NOTE(string) SOLVE(string) ]
	/* check input arguments */	
	local k: word count `anything'
	tokenize `"`anything'"'
	if `k' > 0 {
		if `"`simpson'"' != "" | `"`st1'"' != "" {
			di as err "survival probabilities may not be " ////
				  "specified if simpson() or st1() is specified"
			exit 198
		}
		ChkArgs 1 `1' `2'
	}
	/* schoenfeld <=> log */
	if `"`schoenfeld'"' != "" {
		local log log
	}
	/* wdprob() */
	if `wdprob' != 0 {
		if `"`sampsi'"' == "" {
			di as err "wdprob() may not be combined with n()"
			exit 198
		}
		cap assert `wdprob'>=0 & `wdprob'<1
		if _rc {
			di as err "wdprob() must be a number between 0 and 1"
			exit 198
		}
	}
	/* simpson() */
	if `"`simpson'"' != "" {
		if `"`st1'"' != "" {
			di as err "st1() and simpson() may not be combined"
			exit 198
		}
		if `"`solve'"' == "hr" {
			di as err "simpson() is not allowed with " ///
				  "effect-size computation"
			exit 198
		}
		cap confirm matrix `simpson'
		if _rc {
			local k: word count `simpson'
			if `k' != 3 {
di as err "{p}simpson(): matrix name or numlist with three numbers "	///
	  "between 0 and 1 is required{p_end}" 
exit 198
			}
			tokenize `"`simpson'"'
			forvalues i = 1/3 {
				cap confirm number ``i''
				if _rc {
di as err "{p}simpson(): matrix name or numlist with three numbers "	///
	  "between 0 and 1 is required{p_end}" 
exit 198
				}
				cap assert ``i''>0 & ``i''<=1
				if _rc {
di as err "{p}simpson(): matrix name or numlist with three numbers " /// 
	  "between 0 and 1 is required{p_end}" 
exit 198
				}
			}	
			tempname simmat
			mat `simmat' = (`1', `2', `3')
		}
		else {
			tempname simmat
			if rowsof(`simpson') == 3 {
				mat `simmat' = `simpson''
			}
			else {
				mat `simmat' = `simpson'
			}
		}
		forvalues i = 1/3 {
			cap assert `simmat'[1,`i']>0 & `simmat'[1,`i']<=1
			if _rc {
				di as err `"simpson(): matrix `simpson' "' ///
					"must contain values between 0 and 1"
				exit 198
			}
		}
		cap assert `simmat'[1,1] >= `simmat'[1,2] & ///
			   `simmat'[1,2] >= `simmat'[1,3]
		if _rc {
			di as err "{p}simpson(): values of the survivor " ///
				 "function should not increase with time{p_end}"
			exit 198
		}
	}
	/* st1() */
	if `"`st1'"' != "" {
		if `"`solve'"' == "hr" {
			di as err "st1() is not allowed with " ///
				  "effect-size computation"
			exit 198
		}
		tokenize `"`st1'"'
		local tvar `2'
		local surv1 `1'
		cap confirm numeric variable `tvar'
		if _rc {
			di as err `"st1(): time variable `tvar' must "'	///
				   "contain nonnegative values"
			exit 198
		}
		cap confirm numeric variable `surv1'
		if _rc {
			di as err `"st1(): survival variable `surv1' "'	///
				  "must contain values between 0 and 1"
			exit 198
		}
		qui summ `tvar', meanonly
		cap assert r(min)>=0
		if _rc {
			di as err `"st1(): time variable `tvar' must "'	///
				   "contain nonnegative values"
			exit 198
		}
		cap assert r(max)-r(min) > 0
		if _rc {
			di as err "st1(): length of the accrual period " ///
				  "must be greater than 0;"
			di as err `"check values of time variable `tvar'"'
			exit 198
		}
		cap assert `surv1'>0 & `surv1'<=1 if `surv1'<.
		if _rc {
			di as err "st1(): survival variable `surv1' must " ///
				  "contain values between 0 and 1"
			exit 198
		}
		/* survival function must be decreasing */
		qui query sortseed
		local sortseed = r(sortseed)
		tempvar id
		qui gen byte `id' = _n
		qui sort `tvar' `surv1', stable
		cap assert `surv1'[_n]<=`surv1'[_n-1] if _n>1 & `surv1'<.
		qui sort `id'
		set sortseed `sortseed'
		if _rc {
			di as err "st1(): values of the survivor "	///
				  "function should not increase with time"
			exit 198
		}
	}
	mata: _stpower_checkexist("_stpower_struct")
	mata: _stpower_setup_log(_stpower_struct, "`simmat'")
	mata: _stpower_work_log(_stpower_struct)
	ret add
end

program Exponential, rclass
	version 10
	syntax [anything] [, T(string) FPeriod(string) LOGHazard	  ///
			     APeriod(string) ASHape(string) APRob(string) ///
			     APTime(string) ATime(string) UNConditional	  ///
			     LOSSHaz(string) LOSSPRob(string) SAMPSI	  ///
			     LOSSTime(string) NOTE(string) INIT(real 0.5) ]
	if `"`t'"' == "" {
		local argnames hazard rates
		local argname hazard rate
	}
	else {
		local argnames survival probabilities
		local argname survival probability
	}
	/* loghazard <=> log */
	if `"`loghazard'"' != "" {
		local log log
	}
	/* check input arguments */	
	local k: word count `anything'
	if `k' == 0 {
		if `"`t'"' != "" {
			di as err "t() requires specifying survival "	///
				"probability in the control group"
			exit 198
		}
		if `"`aperiod'`fperiod'"' != "" {
			di as err  `"{p}`argname' in the control group "' ///
				   "must be specified if aperiod() or "	  ///
				   "fperiod() are specified{p_end}"
			exit 198
		}
		else if "`log'" == "" {
			di as err `"loghazard is required if no `argnames'"' ///
				  " are specified"
			exit 198
		}
	}
	tokenize `"`anything'"'
	if `k' > 0 {
		if `"`t'"' == "" { /* assume hazards */
			`note' di as txt ///
				"Note: Input parameters are hazard rates."
			ChkArgs 0 `1' `2'
		}
		else { /* assume survival probabilities */
			`note' di as txt "{p 0 6}Note: Input parameters " ///
					 "are survival probabilities.{p_end}"
			/* t() */
			ChkOpts t `t' 0
			cap assert `t' > 1e-6
			if _rc {
				di as err "t(): time is too small (<= 1.0e-6)"
				exit 198
			}
			ChkArgs 1 `1' `2'
		}
	}
	/* fperiod(), aperiod() */
	if `"`fperiod'"' == "" & `"`aperiod'"' == "" & ///
	   (`"`losshaz'"' != "" | `"`lossprob'"' != "") {
		di as err "losshaz() and lossprob() require specifying " ///
			  "fperiod() or aperiod()"
		exit 198
	}
	if `"`fperiod'"' != "" {
		cap confirm number `fperiod'
		if _rc { 
			di as err "fperiod() must be a nonnegative number"
			exit 198
		}
		cap assert `fperiod' >= 0
		if _rc {
			di as err "fperiod() must be a nonnegative number"
			exit 198
		}
	}
	if `"`aperiod'"' != "" {
		cap confirm number `aperiod'
		if _rc { 
			di as err "aperiod() must be a nonnegative number"
			exit 198
		}
		cap assert `aperiod' >= 0
		if _rc {
			di as err "aperiod() must be a nonnegative number"
			exit 198
		}
	}
	else if `"`ashape'`aprob'`atime'`aptime'"' != "" {
			di as err "ashape(), aprob(), atime(), and " ///
				  "aptime() require specifying aperiod()"
			exit 198
	}
	if `"`fperiod'"' == "" & `"`aperiod'"' == "" {
		local fperiod = 0
		local aperiod = 0
	}
	else {
		if `"`fperiod'"' != "" & `"`aperiod'"' == "" {
			local aperiod = 0
		}
		else if `"`aperiod'"' != "" & `"`fperiod'"' == "" {
			local fperiod = 0
		}
		cap assert `aperiod'+`fperiod' > 1e-4
		if _rc {
			di as err "duration of study is too small (<= 1.0e-4)"
			exit 198
		}
	}
	/* ashape() */
	tempname ar
	scalar `ar' = 0
	if "`log'"!="" & "`ashape'`aprob'`atime'`aptime'"!="" {
			di as err "{p}ashape(), aprob(), atime(), and " ///
				  "aptime() may not be combined with "	///
				  "loghazard{p_end}"
			exit 198
	}
	if `"`ashape'"' != "" {
		cap confirm number `ashape'
		if _rc {
			di as err "ashape() must be numeric"
			exit 198
		}
		cap assert reldif(`ashape', 0) > 1e-8
		if _rc {
			local ashape = 0
		}
		scalar `ar' = `ashape'
	}
	/* aprob(), aptime() and atime() */
	local recruit `aprob' `atime' `aptime'
	tempname acrprob at
	if (`aperiod' != 0) {
		scalar `acrprob' = 0.5
		scalar `at' = `aperiod'/2
		if `"`recruit'"' == "" {
			if `"`ashape'"' != "" {	
			/* compute z with aprob=0.5 and specified ashape() */
				scalar `at' = `acrprob'*(-expm1(-`ar'*`aperiod'))
				scalar `at' = -ln1m(`at')/`ar'
			}
		}
		else {
			if `"`ashape'"' != "" {
				di as err "ashape() may not be combined " ///
				  	"with aprob(), atime() or aptime()"
				exit 198
			}
			if `"`aprob'"' != "" {
				ChkOpts aprob `aprob' 1 1 1 0.01 0.99
				scalar `acrprob' = `aprob'
			}
			if `"`aptime'"' != "" {
				if `"`atime'"' != "" {
					di as err "aptime() and atime() " ///
						"may not be combined"
					exit 198
				}
				ChkOpts aptime `aptime' 1 1 1 0.01 0.99
				scalar `at' = `aptime'*`aperiod'
			}
			else if `"`atime'"' != "" {
				local lb = 0.01*`aperiod'
				local ub = 0.99*`aperiod'
				cap ChkOpts atime `atime' 1 1 1 `lb' `ub'
				if _rc {
di as err "{p}atime() must be a number between" %9.2g `lb' " and " ///
    %9.2g `ub' " (1% and 99% of the accrual period of length `aperiod'){p_end}"
exit _rc
				}
				scalar `at' = `atime'
			}
		}
		if `"`aptime'"' == "" {
			local aptime = `at'/`aperiod'
		}
	}
	else {
		scalar `acrprob' = 0
		scalar `at' = 0
		local aptime = 0
	}
	/* losshaz(), lossprob(), and losstime() */
	if `"`losshaz'"' != "" {
		cap numlist `"`losshaz'"', range(>=0) min(2) max(2)
		if _rc {
			di as err "losshaz() requires specifying two "	///
				  "nonnegative numbers"
			exit 198
		}
	}
	if `"`lossprob'"' != "" {
		cap numlist `"`lossprob'"', range(>=0 <1) min(2) max(2)
		if _rc {
			di as err "lossprob() requires specifying two "	///
				  "numbers between 0 and 1"
			exit 198
		}
	}
	if `"`losstime'"' != "" {
		if `"`lossprob'"' == "" {
			di as err "losstime() requires specifying lossprob()"
			exit 198
		}
		ChkOpts losstime `losstime' 0
	}
	else {
		local losstime = 1
	}
	tempname ltfh1 ltfh2
	if `"`losshaz'"' == "" {
		if `"`lossprob'"' == "" {
			scalar `ltfh1' = 0
			scalar `ltfh2' = 0
		}
		else {
			tokenize `lossprob'
			scalar `ltfh1' = -ln1m(`1')/`losstime'
			scalar `ltfh2' = -ln1m(`2')/`losstime'
		}
	}
	else {
		if `"`lossprob'"' != "" {
			di as err "losshaz() and lossprob() may not be combined"
			exit 198
		}
		tokenize `losshaz'
		scalar `ltfh1' = `1'
		scalar `ltfh2' = `2'
	}
	local meth = (`"`log'"'!="")
	local uncond = (`"`unconditional'"'!="")
	/* get accrual rate */
	if `"`recruit'"'!="" & (`=`acrprob''!=0.5 | `=`at''!=`aperiod'/2) {
		qui GetRate, pr(`=`acrprob'') z(`=`at'') act(`aperiod') ///
			     init(`init')
		scalar `ar' = r(rate)
		if r(rate) == . {
			di as err "shape is missing; adjust values of "	///
				  "aprob(), atime() or aptime()"
			exit 198
		}
		/* check computed rate */
		tempname pr
		scalar `pr' = (-expm1(-`ar'*`at'))/(-expm1(-`ar'*`aperiod'))
		cap assert reldif(`acrprob', `pr') < 1.0e-4
		if _rc {
			di as err "{p}the computed rate" %8.4f `=`ar'' ///
				   " does not agree with specified" ///
				   " accrual options; try different" ///
				   " values of aprob() and atime(){p_end}"
			exit 198
		}
	}
	mata: _stpower_checkexist("_stpower_struct")
	mata: _stpower_setup_exp(_stpower_struct, `=`ltfh1'',	///
				   `=`ltfh2'', `=`ar'',		///
				   `=`at'', `=`acrprob'', `meth', `uncond')
	if `"`lossprob'"' != "" {
		ret scalar lt = `losstime'
	}
	mata: _stpower_work_exp(_stpower_struct)
	/* return results */
	return add
	if `"`unconditional'"' == "" {
		return local type = "conditional"
	}
	else {
		return local type = "unconditional"
	}
	if `aperiod' != 0 {
		if `=`ar'' != 0 {
			return local accrual = "exponential"
		}
		else {
			return local accrual = "uniform"
		}
	}
	if "`log'" == "" {
		return local method hazard difference
	}
	else {
		return local method log-hazard difference
	}
end

/*----------------------- subprograms -------------------------------*/
/* computes the probability of a failure using numerical integration */
program GetPrF, rclass
	version 10
	syntax [, st1(varlist min=1 max=2) HR(real 0.5) ]
	tokenize `"`st1'"'
	local tvar `2'
	local sdf1 `1'
	qui query sortseed
	local sortseed = r(sortseed)
	qui preserve
	tempvar touse sdf2
	qui gen double `sdf2' = `sdf1'^`hr'
	qui gen byte `touse' =  (`tvar'<. & `sdf1'<. & `sdf2'<.)
	qui summ `tvar' if `touse', meanonly
	local ap = r(max)-r(min)
	qui integ `sdf1' `tvar' if `touse'
	tempname pF1 pF2
	scalar `pF1' = 1 - r(integral)/`ap'
	qui integ `sdf2' `tvar' if `touse'
	scalar `pF2' = 1 - r(integral)/`ap'
	qui summ `tvar' if `touse', meanonly
	return scalar Pr_F1 = `pF1'
	return scalar Pr_F2 = `pF2'
	return scalar fp = r(min)
	return scalar t = r(max)
	qui restore
	qui set sortseed `sortseed'
end

/* computes the estimate of the HR using iterative search */
program GetHR, rclass
	version 10
	syntax [, CV(string) AR(string) N(string) s1(string) LOG ]
	if "`log'" != "" {
		local fncname _stpower_gethr_log
	}
	else {
		local fncname _stpower_gethr
	}
	global STPOW_N   = `n'
	global STPOW_LMB = `ar'
	global STPOW_CV  = `cv'
	global STPOW_S1  = `s1'
	tempname loghr fval it_ct
	cap noi _linemax `loghr' `fval' `it_ct' : 	///
				"`fncname'" "loghr" -0.1 1e-6 50 1e-6
	local rc = _rc
	if `rc' {
		cap macro drop STPOW_N STPOW_LMB STPOW_CV STPOW_S1
		exit `rc'
	}
	else {
		if reldif(`fval', 0) > 1.0e-8 { /* iterate more */
			cap noi _linemax `loghr' `fval' `it_ct' : 	///
				"`fncname'" "loghr" `loghr' 1e-6 50 1e-6
		}
		local rc = _rc
		cap macro drop STPOW_N STPOW_LMB STPOW_CV STPOW_S1
		cap ret scalar lnhr = -abs(`loghr')
		exit `rc'
	}
end

/* computes accrual rate based on the truncated exponential probability */
program GetRate, rclass
	version 10
	syntax [, PR(real 0.5) Z(real 0.5) ACT(real 1) INIT(real 0.5) ]
	if (`pr'< 0.05 & `z'/`act'>0.98) { 
	/* difficult region: use respective convex distribution instead */
		global GR_Pr = 1-`pr'
		global GR_R  = `act'
		global GR_Z  = `act'-`z'
		local sign  = -1
	}
	else {
		global GR_Pr = `pr'
		global GR_R  = `act'
		global GR_Z  = `z'
		local sign  = 1
	}
	tempname rate fval it_ct
	cap noi _linemax `rate' `fval' `it_ct' : 	///
				"_stpower_getrate" "rate" `init' 1e-6 50 1e-6
	local rc = _rc
	if `rc' {
		cap macro drop GR_Pr GR_R GR_Z
		exit `rc'
	}
	else {
		if reldif(`fval', 0) > 1.0e-8 { /* iterate more */
			cap noi _linemax `rate' `fval' `it_ct' : 	///
				"_stpower_getrate" "rate" `rate' 1e-6 50 1e-6
		}
		local rc = _rc
		cap macro drop GR_Pr GR_R GR_Z
		cap ret scalar rate = `sign'*`rate'
		exit `rc'
	}
end

program DiTable
	version 10
	syntax [, TABLE(string) CMD(string) noHEADer Continue SEParator ///
		  noLegend noTitle COLWidth(numlist) noOUTput LASTCALL ///
		  SAVing(string) REPLACE POSTNAME(string) FIRSTCALL    ///
		  FIRSTPART DIVider ]
	if `"`table'"' == bsubstr("table", 1, length(`"`table'"')) {
		if `"`cmd'"' == "Log" {
			if r(method) == "Schoenfeld" {
				local efct loghr
			}
			else {
				local efct hr
			}
			if r(s1) != . {
				local s s1 s2
			}
			if r(w) != . {
				local w w
			}
			local table power n n1 n2 e `s' `efct' alpha `w'
		}
		else if `"`cmd'"' == "Exp" {
			if r(fperiod) != . {
				local durat fp
			}
			if r(aperiod) != . {
				local durat `durat' ap
			}
			if r(lh1) != . {
				if r(lt) == . {
					local durat `durat' lh1 lh2
				}
				else {
					local durat `durat' lpr1 lpr2
				}
			}
			if r(method) == "log-hazard difference" {
				local efct loghr
			}
			else {
				local efct diff
			}
			if r(h1) != . {
				if r(t) != . {
					local args s1 s2
				}
				else {
					local args h1 h2
				}
			}
			local table power n n1 n2 `args' `efct' alpha `durat'
		}
		else if `"`cmd'"' == "Cox" {
			if r(metric) == "log-hazard" {
				local efct coef
			}
			else {
				local efct hr
			}
			if r(Pr_E) != . {
				local pr pr
			}
			if r(r2) != . {
				local r2 r2
			}
			if r(w) != . {
				local w w
			}
			local table power n e `efct' sd alpha `pr' `r2' `w'
		}
	}
	ChkTableOpts`cmd', `table'
	mata: _stpower_checkexist("_stpower_struct")
	if `"`saving'"' != "" {
		if (`"`firstcall'"' != "") {
			global STPOW_holdtab `table'
		}
		if `"`firstpart'"' != "" {
			/* post results to the file when the first part */
			/* of the table is being displayed (unless nooutput)*/
			local table $STPOW_holdtab
			mata: _stpower_post("`cmd'", _stpower_struct)
		}
	}
	if `"`output'"' == "" {
		local ncols: word count `table'
		local linesize: set linesize
		local ncolw: word count `colwidth'
		if `ncolw' > `ncols' {
			di as err "colwidth(): too many values specified"
			exit 198
		}
		else {
			local last: word `ncolw' of `colwidth'
			while `ncolw' < `ncols' {
				local colwidth `colwidth' `last'
				local ++ncolw
			}
		}
		/* check if need to display base time */
		if `"`firstcall'"' != "" & `"`header'"' == "" {
			local dibasetime `s(basetime)'
			local dibaseltime `s(baseltime)'
		}
		else {
			local title notitle
		}
		local tabopts `table'
		local colwvals `colwidth'
		gettoken colw colwvals: colwvals 
		local sumcolw = 1
		local table
		local colwidth
		while `"`colw'"' != "" {
			if `sumcolw'+`colw'+1>`linesize' {
				// clear lastcall if not all columns displayed
				local lastcall
				mata: _stpower_table("`cmd'", _stpower_struct)
				local sumcolw = 1
				local table
				local colwidth
				global STPOW_colw `colw' `colwvals'
				global STPOW_cols `tabopts'
				exit 0
			}
			else {
				local sumcolw = `sumcolw' + `colw' + 1
				local colwidth `colwidth' `colw'
				gettoken col tabopts: tabopts
				local table `table' `col'
				gettoken colw colwvals: colwvals 
			}
		}
		mata: _stpower_table("`cmd'", _stpower_struct)
		global STPOW_colw
		global STPOW_cols
	}
end

program ChkTableOptsLog, sclass
	version 10
	cap syntax [, N n1 n2 E p1 Power Alpha s1 s2 Beta W HR LOGHR NRATio ]
	if _rc == 198 {
		di as err "columns(): invalid or repeated column name"
		exit 198
	}
	else if _rc!=0 {
		exit _rc
	}
	if `"`alpha'"' != "" {
		sreturn local alpha alpha
	}
end

program ChkTableOptsCox, sclass
	version 10
	cap syntax [, N E Power Alpha Beta W HR SD PR r2 Coef ]
	if _rc == 198 {
		di as err "columns(): invalid or repeated column name"
		exit 198
	}
	else if _rc != 0 {
		exit _rc
	}
	if `"`alpha'"' != "" {
		sreturn local alpha alpha
	}
end

program ChkTableOptsExp, sclass
	version 10
	cap syntax [, N n1 n2 EA EO Power Alpha h1 h2 Beta lh1 lh2	///
			  APeriod FPeriod ASHape HR p1 APTime APRob DIFF     ///
			  ea1 ea2 eo1 eo2 LA la1 la2 LO lo1 lo2 LOGHR NRATio ///
			  lpr1 lpr2 T LOSSTime ATime s1 s2 ]
	if _rc == 198 {
		di as err "columns(): invalid or repeated column name"
		exit 198
	}
	else if _rc != 0 {
		exit _rc
	}
	if r(method) == "log-hazard difference" {
		if (`"`ashape'"'!="") | (`"`aprob'"'!="") | ///
		   (`"`atime'"'!="") | (`"`aptime'"'!="") {
			di as err "{p 0 11 0}columns(): ashape, " ///
				   "aprob, aptime and atime are not " ///
				   "allowed if loghazard is specified{p_end}"
			exit 198
		}
	}
	if `"`t'"' == "" & (`"`s1'"' != "" | `"`s2'"' != "") {
		sreturn local basetime t
	}
	if `"`losstime'"' == "" & (`"`lpr1'"' != "" | `"`lpr2'"' != "") {
		sreturn local baseltime ltime
	}
	if `"`aperiod'"' != "" {
		sreturn local aperiod aperiod
	}
	if `"`alpha'"' != "" {
		sreturn local alpha alpha
	}
end

program ChkOpts
* case  = 0 - check if positive
* case  = 1 - check if between pnt1 and pnt2
* ifl	= 1 - include lower end point
* ifu	= 1 - include upper end point
	version 10
	args optname optval case ifl ifu pnt1 pnt2
	if `"`pnt1'"' == "" {
		local pnt1 = 0
	}
	if `"`pnt2'"' == "" {
		local pnt2 = 1
	}
	if `case' {
local errmsg "`optname'() must be a number between `pnt1' and `pnt2'"
	}
	else {
local errmsg "`optname'() must be a positive number"
	}
	local less <
	local gr >
	if "`ifl'" == "1" {
		local gr >=
	}
	if "`ifu'" == "1" {
		local less <=
	}
	cap confirm number `optval'
	if _rc {
		di as err `"`errmsg'"'
		exit 198
	}
	if `case' {
		cap assert `optval' `gr' `pnt1' & `optval' `less' `pnt2'
		if _rc {
			di as err `"`errmsg'"'
			exit 198
		}
	}
	else {
		cap assert `optval' `gr' 0
		if _rc {
			di as err `"`errmsg'"'
			exit 198
		}
	}
end

program ChkArgs
* case = 0 - check hazards
* case = 1 - check survival probabilities
	version 10
	args case arg1 arg2
	if `case' {
		cap assert `arg1' > 1.0e-6 
		if _rc {
di as err "survival probability is too small (<= 1.0e-6)"
exit 198
		}
		if `"`arg2'"' != "" {
			cap assert `arg2' > 1.0e-6 
			if _rc {
di as err "survival probability is too small (<= 1.0e-6)"
exit 198
			}
		}
	}
	else {
		cap assert `arg1' > 1.0e-6 
		if _rc {
di as err "hazard rate is too small (<= 1.0e-6)"
exit 198
		}
		if `"`arg2'"' != "" {
			cap assert `arg2' > 1.0e-6 
			if _rc {
di as err "hazard rate is too small (<= 1.0e-6)"
exit 198
			}
		}
	}
end

version 10
local GETLINE tborder, jborder, bborder, tlast, jlast, blast, divider, 
local GETLINE `GETLINE' header, strcols, cellw
mata:

/* displays output */
void _stpower_display(string scalar cmd, struct _stpower_base scalar base)
{
	real scalar   eqpos, pos1, lt, type
	string scalar sides, argname, effect
	string scalar fmt, fmtn, accrual, newl

	fmt = "%9.4f"
	fmtn = "%9.0f"
	if (base.onesid) sides = "one sided"
	else sides = "two sided"
	if (cmd == "Exp") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_display(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_exp scalar st_exp
		st_exp	= *(base.cmdp)
		eqpos	= 2 + strlen("accrued(%) = ")
		argname	= "h"
		type  = st_exp.uncond
		if (base.meth) {
			effect = sprintf("{txt}{ralign %g:ln(h2/h1) = }{res}"+
						fmt+"\n",eqpos,base.lnhr)
		}
		else {
			effect = sprintf("{txt}{ralign %g:h2-h1 = }{res}"+fmt+
					"\n", eqpos, (base.arg2-base.arg1))
		}
		if (st_exp.ar == 0) accrual = "uniform"
		else accrual = "exponential"
		lt = st_exp.lt
	}
	else if (cmd == "Log") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_display(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_log scalar st_log
		st_log	= *(base.cmdp)
		eqpos	= 1 + strlen("withdrawal = ")
		argname = "s"
		type 	= 0
		if (base.meth) {
			effect = sprintf("{txt}{ralign %g:ln(hratio) = }{res}"+
						fmt+"\n", eqpos, base.lnhr)
		}
		else {
			effect  = sprintf("{txt}{ralign %g:hratio = }{res}"+
						fmt+"\n", eqpos, base.hr)
		}
	}
	else if (cmd == "Cox") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_display(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_cox scalar st_cox
		st_cox	= *(base.cmdp)
		eqpos	= 1 + strlen("withdrawal(%) = ")
		type 	= 0
		if (base.nohr) {
			effect = sprintf("{txt}{ralign %g:b1 = }{res}"+fmt+
							"\n", eqpos, base.lnhr)
		}
		else {
			effect = sprintf("{txt}{ralign %g:hratio = }{res}"+fmt+
							"\n", eqpos, base.hr)
		}
	}
	if (st_local("title") == "") { /* display title */
		_stpower_dititle(cmd, base, type)
	}
	/* display output */
	printf("\n{txt}Input parameters:\n\n")
	printf("{txt}{ralign %g:alpha = }{res}"+fmt+"  {txt}(%s)\n",
						eqpos,base.alpha,sides)
	if (base.arg1 != 0) { /* log and exp */
		if (cmd == "Exp" & st_exp.t != .) {
printf("{txt}{ralign %g:s1 = }{res}"+fmt+"\n", eqpos, exp(-base.arg1*st_exp.t))
printf("{txt}{ralign %g:s2 = }{res}"+fmt+"\n", eqpos, exp(-base.arg2*st_exp.t))
printf("{txt}{ralign %g:t = }{res}" +fmt+"\n", eqpos, st_exp.t)
		}
		else {
printf("{txt}{ralign %g:%s1 = }{res}"+fmt+"\n", eqpos, argname, base.arg1)
printf("{txt}{ralign %g:%s2 = }{res}"+fmt+"\n", eqpos, argname, base.arg2)
		}
	}
	if (base.sampsi==1) { /* sample size */
printf(effect)
if (cmd == "Cox") printf("{txt}{ralign %g:sd = }{res}"+fmt+"\n",eqpos,st_cox.sd)
printf("{txt}{ralign %g:power = }{res}"+fmt+"\n", eqpos, base.power)
	}
	else if (base.sampsi==2) { /* HR, not for exp */
if (cmd == "Cox") printf("{txt}{ralign %g:sd = }{res}"+fmt+"\n",eqpos,st_cox.sd)
printf("{txt}{ralign %g:N = }{res}"+fmtn+"\n", eqpos, base.n)
printf("{txt}{ralign %g:power = }{res}"+fmt+"\n", eqpos, base.power)
	}
	else { /* power */ 
printf(effect)
if (cmd == "Cox") printf("{txt}{ralign %g:sd = }{res}"+fmt+"\n",eqpos,st_cox.sd)
printf("{txt}{ralign %g:N = }{res}"+fmtn+"\n", eqpos, base.n)
	}
	if (cmd == "Cox") { /* cox output */
if (st_cox.pr != 1) {
	printf("{txt}{ralign %g:Pr(event) = }{res}"+fmt+"\n", eqpos, st_cox.pr)
}
if (st_cox.r2 != 0) {
	printf("{txt}{ralign %g:R2 = }{res}"+fmt+"\n", eqpos, st_cox.r2)
}
if (base.sampsi == 1) {
	if (st_cox.w != 0) 
		printf("{txt}{ralign %g:withdrawal(%s) = }{res}%9.2f\n", 
				   		       eqpos, "%", 100*st_cox.w)
	printf("\n{p}{txt}Estimated number of events and sample size:{p_end}\n")
	printf("\n{txt}{ralign %g:E = }{res}" +fmtn, eqpos, st_cox.e)
	printf("\n{txt}{ralign %g:N = }{res}" +fmtn+"\n", eqpos, base.n)
}
else if (base.sampsi == 2) {
	if (base.nohr) {
printf("\n{txt}{p}Estimated number of events and coefficient:{p_end}\n")
printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_cox.e)
printf("\n{txt}{ralign %g:b1 = }{res}"+fmt+"\n", eqpos, base.lnhr)
	}
	else {
printf("\n{p}{txt}Estimated number of events and hazard ratio:{p_end}\n")
printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_cox.e)
printf("\n{txt}{ralign %g:hratio = }{res}"+fmt+"\n", eqpos, base.hr)
	}
}
else {
	printf("\n{p}{txt}Estimated number of events and power:{p_end}\n")
	printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_cox.e)
	printf("\n{txt}{ralign %g:power = }{res}"+fmt+"\n", eqpos, base.power)
}
	} /* end cox output */
	else if (cmd == "Log") { /* logrank output */
printf("{txt}{ralign %g:p1 = }{res}"+fmt+"\n", eqpos, base.p1)
if (base.sampsi == 1) {
	if (st_log.w != 0) { 
		printf("{txt}{ralign %g:withdrawal = }{res}%9.2f{txt}%s\n", 
				   		       eqpos, 100*st_log.w,"%")
	}
	printf("\n{p}{txt}Estimated number of events and sample sizes:{p_end}")
	printf("\n")
	printf("\n{txt}{ralign %g:E = }{res}" +fmtn, eqpos, st_log.e)
	printf("\n{txt}{ralign %g:N = }{res}" +fmtn, eqpos, base.n)
	printf("\n{txt}{ralign %g:N1 = }{res}"+fmtn, eqpos, base.n1)
	printf("\n{txt}{ralign %g:N2 = }{res}"+fmtn+"\n", eqpos, base.n-base.n1)
}
else if (base.sampsi == 2) {
	if (base.meth) {
printf("\n{p}{txt}Estimated number of events and log hazard ratio:{p_end}\n")
printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_log.e)
printf("\n{txt}{ralign %g:ln(hratio) = }{res}"+fmt+"\n", eqpos, base.lnhr)
	}
	else {
printf("\n{p}{txt}Estimated number of events and hazard ratio:{p_end}\n")
printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_log.e)
printf("\n{txt}{ralign %g:hratio = }{res}"+fmt+"\n", eqpos, base.hr)
	}
}
else {
	printf("\n{p}{txt}Estimated number of events and power:{p_end}\n")
	printf("\n{txt}{ralign %g:E = }{res}"+fmtn, eqpos, st_log.e)
	printf("\n{txt}{ralign %g:power = }{res}"+fmt+"\n", eqpos, base.power)
}

	} /* end logrank output */
	else if (cmd == "Exp") { /* exponential output */
printf("{txt}{ralign %g:p1 = }{res}"+fmt+"\n", eqpos, base.p1)
if (st_exp.fp != 0 | st_exp.ap >= 1.0e-6) { /* accrual and follow-up */ 
	printf("\n{txt} Accrual and follow-up information:\n\n")
	printf("{txt}{ralign %g:duration = }{res}"+fmt+"\n", 
						eqpos, st_exp.ap+st_exp.fp)
	if (st_exp.fp > 0) { /* fperiod() is specified */
		printf("{txt}{ralign %g:follow-up = }{res}"+fmt+"\n", 
							eqpos, st_exp.fp)
	}
	if (st_exp.ap >= 1.0e-6) { /* aperiod() is specified */
		printf("{txt}{ralign %g:accrual = }{res}"+fmt, eqpos, st_exp.ap)
		printf("{txt}  (%s)\n", accrual)
		if (accrual == "exponential") {
			printf("{txt}{ralign %g:accrued(%s) = }{res}%9.2f{txt}"
					,eqpos, "%",round(st_exp.apr*100,1e-2))
			printf("{txt}  (%s)\n", "by time t*")
			printf("{txt}{ralign %g:t* = }{res}"+fmt, 
							eqpos, st_exp.at)
			printf("{txt}  ({res}%3.2f{txt}%s of accrual)\n", 
						100*st_exp.at/st_exp.ap, "%")
		}
	}
	if (st_exp.lh1!=0 | st_exp.lh2!=0) {
		if (st_numscalar("r(lt)") == J(0,0,.)) {
printf("{txt}{ralign %g:lh1 = }{res}"+fmt+"\n",eqpos,st_exp.lh1)
printf("{txt}{ralign %g:lh2 = }{res}"+fmt+"\n",eqpos,st_exp.lh2)
		}
		else {
printf("{txt}{ralign %g:lpr1 = }{res}"+fmt+"\n", eqpos, -expm1(-st_exp.lh1*lt))
printf("{txt}{ralign %g:lpr2 = }{res}"+fmt+"\n", eqpos, -expm1(-st_exp.lh2*lt))
printf("{txt}{ralign %g:lt = }{res}"+fmt+"\n", eqpos, lt)
		}
	}
}
if (base.sampsi) {
	printf("\n{txt}Estimated sample sizes:\n")
	printf("\n{txt}{ralign %g:N = }{res}" +fmtn     , eqpos, base.n)
	printf("\n{txt}{ralign %g:N1 = }{res}"+fmtn     , eqpos, base.n1)
	printf("\n{txt}{ralign %g:N2 = }{res}"+fmtn+"\n", eqpos, base.n-base.n1)
}
else {
	printf("\n{txt}Estimated power:\n")
	printf("\n{txt}{ralign %g:power = }{res}"+fmt+"\n", eqpos, base.power)
}
if (st_local("detail") != "") { /* detailed output */
	pos1 = strlen("E1|Ha = ")+5
	stata("local linesize: set linesize")
	if (strtoreal(st_local("linesize"))<50) {
		newl = "\n"
		pos1 = eqpos
	}
	else newl = ""
	printf("\n{txt}Estimated expected number of events:\n")
	printf("\n{txt}{ralign %g:E|Ha = }{res}" +fmtn, eqpos, st_exp.ea)
	printf(sprintf("%s{txt}{ralign %g:E|Ho = }{res}" +fmtn, newl, pos1, 
								   st_exp.eo))
	printf("\n{txt}{ralign %g:E1|Ha = }{res}"+fmtn, eqpos, st_exp.ea1)
	printf(sprintf("%s{txt}{ralign %g:E1|Ho = }{res}" + fmtn, newl, pos1, 
								   st_exp.eo1))
	printf("\n{txt}{ralign %g:E2|Ha = }{res}"+fmtn, 
						eqpos, st_exp.ea-st_exp.ea1)
	printf(sprintf("%s{txt}{ralign %g:E2|Ho = }{res}"+fmtn+"\n", newl, 
						pos1,st_exp.eo-st_exp.eo1))
	if (st_exp.lh1!=0 | st_exp.lh2!=0) {
		printf("\n")
		printf("{txt}{p}Estimated expected number of losses ")
		printf("to follow-up:{p_end}\n")
		printf("\n{txt}{ralign %g:L|Ha = }{res}" +fmtn, eqpos,st_exp.la)
		printf(sprintf("%s{txt}{ralign %g:L|Ho = }{res}"+fmtn, newl, 
							     pos1, st_exp.lo))
		printf("\n{txt}{ralign %g:L1|Ha = }{res}"+fmtn,eqpos,st_exp.la1)
		printf(sprintf("%s{txt}{ralign %g:L1|Ho = }{res}"+fmtn, newl, 
							      pos1,st_exp.lo1))
		printf("\n{txt}{ralign %g:L2|Ha = }{res}"+fmtn, 
						eqpos,st_exp.la - st_exp.la1)
		printf(sprintf("%s{txt}{ralign %g:L2|Ho = }{res}"+fmtn, newl, 
						pos1, st_exp.lo - st_exp.lo1))
	}
	printf("\n\n")
}
	} /* end exp output */
}

/* displays table */
void _stpower_table(string scalar cmd, struct _stpower_base scalar base)
{
	real scalar   i, ncols, lt, len, cellw, type
	string scalar sides, accrual, colname
	string scalar header, strcols, star, plus, islgnd
	string scalar tborder, jborder, bborder, tlast, jlast, blast, divider
	string rowvector tabopts
	real rowvector colwidth

	if (base.onesid) sides = "one sided"
	else sides = "two sided"
	if (cmd == "Exp") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_table(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_exp scalar st_exp
		st_exp	= *(base.cmdp)
		type	= st_exp.uncond
		if (st_exp.ar == 0) accrual = "uniform"
		else accrual = "exponential"
		lt = st_exp.lt
	}
	else if (cmd == "Log") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_table(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_log scalar st_log
		st_log	= *(base.cmdp)
		type 	= 0
	}
	else if (cmd == "Cox") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_table(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_cox scalar st_cox
		st_cox	= *(base.cmdp)
		type 	= 0
	}
	/* display title */
	if (st_local("title") == "") {
		_stpower_dititle(cmd, base, type)
	}
	/* table options */
	tabopts = tokens(st_local("table"))
	islgnd	= st_local("legend")
	ncols 	= cols(tabopts)
	colwidth = strtoreal(tokens(st_local("colwidth")))
	plus = "+"
	star = "*"
	header = strcols = tborder = jborder = bborder = ""
	if (st_local("divider") == "") {
		tlast	= ""
		jlast	= ""
		blast	= ""
		divider = ""
	}
	else {
		tlast	= "{c TT}"
		jlast	= "{c +}"
		blast	= "{c BT}"
		divider = "{txt}{c |}"
	}
	if (islgnd != "") star = plus = " "
	for (i=1; i<=ncols; i++) {
		cellw = colwidth[i]
		len = strlen(tabopts[i])
		if (i == ncols) {
			tlast = "{c TRC}\n"
			jlast = "{c RT}\n"
			blast = "{c BRC}\n"
			divider = "{txt}{c |}"
		}
		if (tabopts[i] == "n") {
			_stpower_getline(`GETLINE', "N ", base.n)
		}
		else if (tabopts[i] == bsubstr("power",1,len)) {
			_stpower_getline(`GETLINE', "Power ", base.power)
		}
		else if (tabopts[i] == bsubstr("beta",1,len)) {
			_stpower_getline(`GETLINE', "Beta ", base.beta)
		}
		else if (tabopts[i] == bsubstr("alpha",1,len)) {
			_stpower_getline(`GETLINE', sprintf("Alpha%s", star), 
								     base.alpha)
		}
		else if (tabopts[i] == "hr") {
			_stpower_getline(`GETLINE', "HR ", base.hr)
		}
		else if (tabopts[i] == "loghr" | 
			 tabopts[i] == bsubstr("coef",1,len)) {
			if (cmd == "Cox") colname = "B1 "
			else {
				if (cmd == "Exp") colname = "ln(H2/H1)"
				else colname = "ln(HR) "
			}
			_stpower_getline(`GETLINE', colname, base.lnhr)
		}
		if (cmd == "Cox") { /* cox only colnames */
			if (tabopts[i] == "e") {
				_stpower_getline(`GETLINE', "E ", st_cox.e)
			}
			else if (tabopts[i] == "sd") {
				_stpower_getline(`GETLINE', "SD ", st_cox.sd)
			}
			else if (tabopts[i] == "pr") {
				_stpower_getline(`GETLINE', "Pr(E) ", st_cox.pr)
			}
			else if (tabopts[i] == "r2") {
				_stpower_getline(`GETLINE', "R2 ", st_cox.r2)
			}
			else if (tabopts[i] == "w") {
				_stpower_getline(`GETLINE', "W ", st_cox.w)
			}
		} /* end cox only colnames */
		else { 
			if (tabopts[i] == "n1") { /* log and exp colnames */
				_stpower_getline(`GETLINE', "N1 ", base.n1)
			}
			else if (tabopts[i] == "n2") {
				_stpower_getline(`GETLINE',"N2 ",base.n-base.n1)
			}
			else if (tabopts[i] == "p1") {
				_stpower_getline(`GETLINE', "P1 ", base.p1)
			}
			else if (tabopts[i]==bsubstr("nratio", 1, len) & len>3) {
				_stpower_getline(`GETLINE', "N2/N1 ",
							(1-base.p1)/base.p1)
			}
			if (cmd == "Log") { /* log only colnames */
if (tabopts[i] == "e") {
	_stpower_getline(`GETLINE', "E ", st_log.e)
}
else if (tabopts[i] == "s1") {
	_stpower_getline(`GETLINE', "S1 ", base.arg1)
}
else if (tabopts[i] == "s2") {
	_stpower_getline(`GETLINE', "S2 ", base.arg2)
}
else if (tabopts[i] == "w") {
	_stpower_getline(`GETLINE', "W ", st_log.w)
}
			}
			else if (cmd == "Exp") { /* exp only colnames */
if (tabopts[i] == "h1") {
	if (base.arg1 == 0) {
		errprintf("{p}columns(): h1, h2, and diff require ")
		errprintf("specifying hazard rates or survival ")
		errprintf("probabilities{p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "H1 ", base.arg1)
}
else if (tabopts[i] == "h2") {
	if (base.arg1 == 0) {
		errprintf("{p}columns(): h1, h2, and diff require ")
		errprintf("specifying hazard rates or survival ")
		errprintf("probabilities{p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "H2 ", base.arg2)
}
else if (tabopts[i] == "s1") {
	if (st_exp.t == .) {
		errprintf("{p}columns(): s1 and s2 require ")
		errprintf("specifying t(){p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "S1 ", exp(-base.arg1*st_exp.t))
}
else if (tabopts[i] == "s2") {
	if (st_exp.t == .) {
		errprintf("{p}columns(): s1 and s2 require ")
		errprintf("specifying t(){p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "S2 ", exp(-base.arg2*st_exp.t))
}
else if (tabopts[i] == "t") {
	if (st_exp.t == .) {
		errprintf("{p}columns(): t requires ")
		errprintf("specifying t(){p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "T ", st_exp.t)
}
else if (tabopts[i] == "diff") {
	if (base.arg1 == 0) {
		errprintf("{p}columns(): h1, h2, and diff require ")
		errprintf("specifying hazard rates or survival ")
		errprintf("probabilities{p_end}\n")
		exit(198)
	}
	_stpower_getline(`GETLINE', "H2-H1 ", base.arg2-base.arg1)
}
else if (tabopts[i]==bsubstr("fperiod",1,len) & len>1) {
	_stpower_getline(`GETLINE', "FP ", st_exp.fp)
}
else if (tabopts[i]==bsubstr("aperiod",1,len) & len>1) {
	_stpower_getline(`GETLINE', sprintf("AP%s", plus), st_exp.ap)
}
else if (tabopts[i]==bsubstr("ashape",1,len) & len>1) {
	_stpower_getline(`GETLINE', "Gamma ", st_exp.ar)
}
else if (tabopts[i] == bsubstr("aprob",1,len) & len>2) {
	_stpower_getline(`GETLINE', "APr(%) ", 100*st_exp.apr)
}
else if (tabopts[i] == bsubstr("aptime",1,len) & len>2) {
	_stpower_getline(`GETLINE', "AT(%) ", 100*st_exp.apt)
}
else if (tabopts[i] == bsubstr("atime",1,len) & len>1) {
	_stpower_getline(`GETLINE', "AT ", st_exp.at)
}
else if (tabopts[i] == "lh1") {
	_stpower_getline(`GETLINE', "LH1 ", st_exp.lh1)
}
else if (tabopts[i] == "lh2") {
	_stpower_getline(`GETLINE', "LH2 ", st_exp.lh2)
}
else if (tabopts[i] == "lpr1") {
	_stpower_getline(`GETLINE', "LPr1 ", -expm1(-st_exp.lh1*lt))
}
else if (tabopts[i] == "lpr2") {
	_stpower_getline(`GETLINE', "LPr2 ", -expm1(-st_exp.lh2*lt))
}
else if (tabopts[i] == bsubstr("losstime",1,len) & len>4 ) {
	_stpower_getline(`GETLINE', "LT ", lt)
}
else if (tabopts[i] == "ea") {
	_stpower_getline(`GETLINE', "E|Ha ", st_exp.ea)
}
else if (tabopts[i] == "ea1") {
	_stpower_getline(`GETLINE', "E1|Ha ", st_exp.ea1)
}
else if (tabopts[i] == "ea2") {
	_stpower_getline(`GETLINE', "E2|Ha ", st_exp.ea-st_exp.ea1)
}
else if (tabopts[i] == "eo") {
	_stpower_getline(`GETLINE', "E|Ho ", st_exp.eo)
}
else if (tabopts[i] == "eo1") {
	_stpower_getline(`GETLINE', "E1|Ho ", st_exp.eo1)
}
else if (tabopts[i] == "eo2") {
	_stpower_getline(`GETLINE', "E2|Ho ", st_exp.eo-st_exp.eo1)
}
else if (tabopts[i] == "la") {
	_stpower_getline(`GETLINE', "L|Ha ", st_exp.la)
}
else if (tabopts[i] == "la1") {
	_stpower_getline(`GETLINE', "L1|Ha ", st_exp.la1)
}
else if (tabopts[i] == "la2") {
	_stpower_getline(`GETLINE', "L2|Ha ", st_exp.la-st_exp.la1)
}
else if (tabopts[i] == "lo") {
	_stpower_getline(`GETLINE', "L|Ho ", st_exp.lo)
}
else if (tabopts[i] == "lo1") {
	_stpower_getline(`GETLINE', "L1|Ho ", st_exp.lo1)
}
else if (tabopts[i] == "lo2") {
	_stpower_getline(`GETLINE', "L2|Ho ", st_exp.lo-st_exp.lo1)
}
			} /* end exp columns */
		} /* end log and exp columns */	
	} /* end for loop */
	if (cmd == "Exp") {
		if (st_local("dibasetime") != "") 
printf("{txt}\n  Reference survival time: {res}%5.4f", st_exp.t)
		if (st_local("dibaseltime") != "") 
printf("{txt}\n  Reference loss to follow-up time: {res}%5.4f",lt)
	}
	/* display table */
	tborder = "  {txt}{c TLC}" + tborder
	jborder = "  {txt}{c LT}"  + jborder
	bborder = "  {txt}{c BLC}" + bborder
	header  = "  {txt}{c |}"   + header
	strcols = "  {txt}{c |}"   + strcols
	if (st_local("header") == "") { /* display header if requested */
		printf("\n")
		printf(tborder)
		/* display column headers */
		printf("%s\n", header)
		/* joint border */
		printf(jborder)
	}
	/* display column values */
	printf("%s\n", strcols)
	if (st_local("continue") == "") { /* bottom border */
		printf(bborder)
		/* display legend */
		if (islgnd == "" & st_local("lastcall") != "") {
			if (st_global("s(alpha)") != "") 
						printf("  * %s\n", sides)
			if (cmd == "Exp" & st_global("s(aperiod)") != "") {
				printf("{p 2}+ %s accrual; ", accrual)
				printf("{res}%3.2f{txt}%% accrued by ",	
								100*st_exp.apr)
				printf("{res}%3.2f{txt}%% of AP{p_end}\n", 
								100*st_exp.apt)
			}
		} 
	}
	else if (st_local("separator") != "") { /* joint border */
		printf(jborder)
	}
}


/* posts tabular results to a file */
void _stpower_post(string scalar cmd, struct _stpower_base scalar base)
{
	real scalar i, lt, ncols, len
	string scalar tofile, varnames, quote, coquote, ccoquote
	string rowvector tabopts

	quote = `"""'
	coquote = "`" + quote
	ccoquote = quote + "'"

	if (cmd == "Exp") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_post(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_exp scalar st_exp
		st_exp	= *(base.cmdp)
		lt = st_exp.lt
	}
	else if (cmd == "Log") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_post(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_log scalar st_log
		st_log	= *(base.cmdp)
	}
	else if (cmd == "Cox") {
		if (base.cmdp == NULL) {
			errprintf("_stpower_post(): base.cmdp is NULL\n")
			exit(198)
		}
		struct _stpower_cox scalar st_cox
		st_cox	= *(base.cmdp)
	}
	
	tabopts = tokens(st_local("table"))
	ncols 	= cols(tabopts)
	varnames = tofile = ""
	
	for (i=1; i<=ncols; i++) {
		len = strlen(tabopts[i])
		if (tabopts[i] == "n") {
			_stpower_tofile(tofile, varnames, "n", base.n)
		}
		else if (tabopts[i] == bsubstr("power",1,len)) {
			_stpower_tofile(tofile, varnames, "power", base.power)
		}
		else if (tabopts[i] == bsubstr("beta",1,len)) {
			_stpower_tofile(tofile, varnames, "beta", base.beta)
		}
		else if (tabopts[i] == bsubstr("alpha",1,len)) {
			_stpower_tofile(tofile, varnames, "alpha", base.alpha)
		}
		else if (tabopts[i] == "hr") {
			_stpower_tofile(tofile, varnames, "hr", base.hr)
		}
		else if (tabopts[i] == "loghr" | 
			 tabopts[i] == bsubstr("coef",1,len)) {
			if (cmd == "Cox") 
			     _stpower_tofile(tofile,varnames,"coef",base.lnhr)
			else _stpower_tofile(tofile,varnames,"loghr",base.lnhr)
		}
		if (cmd == "Cox") { /* cox only colnames */
if (tabopts[i] == "e") {
	_stpower_tofile(tofile, varnames, "e", st_cox.e)
}
else if (tabopts[i] == "sd") {
	_stpower_tofile(tofile, varnames, "sd", st_cox.sd)
}
else if (tabopts[i] == "pr") {
	_stpower_tofile(tofile, varnames, "pr", st_cox.pr)
}
else if (tabopts[i] == "r2") {
	_stpower_tofile(tofile, varnames, "r2", st_cox.r2)
}
else if (tabopts[i] == "w") {
	_stpower_tofile(tofile, varnames, "w", st_cox.w)
}
		} /* end cox only colnames */
		else { 
if (tabopts[i] == "n1") { /* log and exp colnames */
	_stpower_tofile(tofile, varnames, "n1", base.n1)
}
else if (tabopts[i] == "n2") {
	_stpower_tofile(tofile, varnames, "n2", base.n - base.n1)
}
else if (tabopts[i] == "p1") {
	_stpower_tofile(tofile, varnames, "p1", base.p1)
}
else if (tabopts[i] == bsubstr("nratio", 1, len) & len>3) {
	_stpower_tofile(tofile, varnames, "nratio", (1-base.p1)/base.p1)
}
if (cmd == "Log") { /* log only colnames */
	if (tabopts[i] == "e") {
		_stpower_tofile(tofile, varnames, "e", st_log.e)
	}
	else if (tabopts[i] == "s1") {
		_stpower_tofile(tofile, varnames, "s1", base.arg1)
	}
	else if (tabopts[i] == "s2") {
		_stpower_tofile(tofile, varnames, "s2", base.arg2)
	}
	else if (tabopts[i] == "w") {
		_stpower_tofile(tofile, varnames, "w", st_log.w)
	}
}
else if (cmd == "Exp") { /* exp only colnames */
	if (tabopts[i]==bsubstr("aperiod",1,len) & len>1) {
		_stpower_tofile(tofile, varnames, "aperiod", st_exp.ap)
	}
	else if (tabopts[i]==bsubstr("fperiod",1,len) & len>1) {
		_stpower_tofile(tofile, varnames, "fperiod", st_exp.fp)
	}
	else if (tabopts[i]==bsubstr("ashape",1,len) & len>1) {
		_stpower_tofile(tofile, varnames, "ashape", st_exp.ar)
	}
	else if (tabopts[i] == "ea") {
		_stpower_tofile(tofile, varnames, "ea", st_exp.ea)
	}
	else if (tabopts[i] == "ea1") {
		_stpower_tofile(tofile, varnames, "ea1", st_exp.ea1)
	}
	else if (tabopts[i] == "ea2") {
		_stpower_tofile(tofile, varnames, "ea2", st_exp.ea-st_exp.ea1)
	}
	else if (tabopts[i] == "h1" & base.arg1 != 0) {
		_stpower_tofile(tofile, varnames, "h1", base.arg1)
	}
	else if (tabopts[i] == "h2" & base.arg1 != 0) {
		_stpower_tofile(tofile, varnames, "h2", base.arg2)
	}
	else if (tabopts[i] == "s1" & base.arg1 != 0) {
		if (st_exp.t == .) {
			errprintf("{p}columns(): s1 and s2 require ")
			errprintf("specifying t(){p_end}\n")
			exit(198)
		}
		_stpower_tofile(tofile, varnames, "s1",exp(-base.arg1*st_exp.t))
	}
	else if (tabopts[i] == "s2" & base.arg1 != 0) {
		if (st_exp.t == .) {
			errprintf("{p}columns(): s1 and s2 require ")
			errprintf("specifying t(){p_end}\n")
			exit(198)
		}
		_stpower_tofile(tofile, varnames, "s2",exp(-base.arg2*st_exp.t))
	}
	else if (tabopts[i] == "t") {
		if (st_exp.t == .) {
			errprintf("{p}columns(): t requires ")
			errprintf("specifying t(){p_end}\n")
			exit(198)
		}
		_stpower_tofile(tofile, varnames, "t", st_exp.t)
	}
	else if (tabopts[i] == "diff") {
		_stpower_tofile(tofile, varnames, "diff", base.arg2-base.arg1)
	}
	else if (tabopts[i] == "lh1") {
		_stpower_tofile(tofile, varnames, "lh1", st_exp.lh1)
	}
	else if (tabopts[i] == "lh2") {
		_stpower_tofile(tofile, varnames, "lh2", st_exp.lh2)
	}
	else if (tabopts[i] == "lpr1") {
		_stpower_tofile(tofile, varnames, "lpr1", -expm1(-st_exp.lh1*lt))
	}
	else if (tabopts[i] == "lpr2") {
		_stpower_tofile(tofile, varnames, "lpr2", -expm1(-st_exp.lh2*lt))
	}
	else if (tabopts[i] == bsubstr("aprob", 1, len) &  len>2) {
		_stpower_tofile(tofile, varnames, "aprob", 100*st_exp.apr)
	}
	else if (tabopts[i] == bsubstr("aptime",1,len) & len>2) {
		_stpower_tofile(tofile, varnames, "aptime",
							100*st_exp.at/st_exp.ap)
	}
	else if (tabopts[i] == bsubstr("atime",1,len) & len>1) {
		_stpower_tofile(tofile, varnames, "atime", st_exp.at)
	}
	else if (tabopts[i] == bsubstr("losstime",1,len) & len>4 ) {
		_stpower_tofile(tofile, varnames, "losstime", lt)
	}
	else if (tabopts[i] == "eo") {
		_stpower_tofile(tofile, varnames, "eo", st_exp.eo)
	}
	else if (tabopts[i] == "eo1") {
		_stpower_tofile(tofile, varnames, "eo1", st_exp.eo1)
	}
	else if (tabopts[i] == "eo2") {
		_stpower_tofile(tofile, varnames, "eo2", st_exp.eo-st_exp.eo1)
	}
	else if (tabopts[i] == "lo") {
		_stpower_tofile(tofile, varnames, "lo", st_exp.lo)
	}
	else if (tabopts[i] == "lo1") {
		_stpower_tofile(tofile, varnames, "lo1", st_exp.lo1)
	}
	else if (tabopts[i] == "lo2") {
		_stpower_tofile(tofile, varnames, "lo2", st_exp.lo-st_exp.lo1)
	}
	else if (tabopts[i] == "la") {
		_stpower_tofile(tofile, varnames, "la", st_exp.la)
	}
	else if (tabopts[i] == "la1") {
		_stpower_tofile(tofile, varnames, "la1", st_exp.la1)
	}
	else if (tabopts[i] == "la2") {
		_stpower_tofile(tofile, varnames, "la2", st_exp.la-st_exp.la1)
	}
} /* end exp columns */
		} /* end log and exp columns */	
	} /* end for loop */
	/* post to a file */
	if (st_local("firstcall") != "") {
		stata("postfile " + st_local("postname") + " " + varnames + 
		      " using " + coquote + st_local("saving") + ccoquote +
		      ", double " + st_local("replace"))
	}
	tofile = "post " + st_local("postname") + " " + tofile
	stata(tofile)
}
/* displays output and table titles */
void _stpower_dititle(string scalar cmd, struct _stpower_base scalar base,
		      real scalar uncond)
{
	string scalar name, type, sampsi, method, hypoth, metric, title
	if (cmd == "Exp") {
		name 	= "Exponential test"
		if (base.meth) {
			method = ", log-hazard difference"
			hypoth = "ln(h2/h1) = 0"
		}
		else {
			method = ", hazard difference"
			hypoth = "h2-h1 = 0"
		}
		if (uncond) type = ", unconditional"
		else type = ", conditional"
	}
	else if (cmd == "Log") {
		name 	= "Log-rank test"
		if (base.meth) method = ", Schoenfeld method"
		else method = ", Freedman method"
		hypoth	= "S1(t) = S2(t)"
		type 	= ""
	}
	else if (cmd == "Cox") {
		name 	= "Wald test"
		method	= ""
		hypoth	= "[b1, b2, ..., bp] = [0, b2, ..., bp]"
		type 	= ""
		if (base.nohr) metric = ", log-hazard metric"
		else metric = ", hazard metric"
	}
	if (base.sampsi==1) {
		if (cmd == "Cox") sampsi = "sample size"
		else sampsi = "sample sizes"
	}
	else if (base.sampsi==2) {
		sampsi = "hazard ratio"
		if (base.nohr == 1) {
			if (cmd == "Cox") sampsi = "coefficient"
			else if (base.meth) sampsi = "log hazard ratio"
		}
	}
	else sampsi = "power"
	/* display title */
	if (cmd == "Cox") {
		title = sprintf("{p}{txt}Estimated %s ", sampsi)
		title = title + sprintf("{txt}for Cox PH regression{p_end}")
	}
	else {
		title = sprintf("{p}{txt}Estimated %s for two-sample", sampsi)
		title = title + 
		     sprintf("{txt} comparison of survivor functions{p_end}")
	}
	printf("\n%s\n", title)
	printf("{p}{txt}%s%s%s%s{p_end}\n", name, method, metric, type)	
	printf("{txt}Ho: %s\n", hypoth)
}

void _stpower_getline(	string scalar tborder, string scalar jborder,
			string scalar bborder, string scalar tlast,
			string scalar jlast,   string scalar blast,
			string scalar divider, string scalar header, 
			string scalar strcols, real scalar colw, 
			string scalar colname, real scalar colval )
{
	string scalar space, strval, fmt
	real scalar lencol, lencolval
	lencol = strlen(strtrim(colname))
	if (colval < 0) {
		if (colw > 5) fmt = sprintf("%%%g.0g", colw-2)
		else if (colw <= 5) fmt = sprintf("%%%g.0g", 4)
	}
	else {
		if (colw > 5) fmt = sprintf("%%%g.0g", colw-1)
		else if (colw <= 5) fmt = sprintf("%%%g.0g", 5)
	}
	strval = strtrim(sprintf(fmt,colval))
	lencolval = strlen(strval)
	if (colw < lencol) {
		errprintf("{p}colwidth(): specified width %3.0f ", colw)
		errprintf("is too small for column label %s{p_end}\n", colname)
		exit(198)
	}
	else if (colw <=lencol+1) {
		colname = strrtrim(colname)
	}
	if (colw <= lencolval+1) space = ""
	else space = " "
	tborder = tborder + sprintf("{txt}{hline %g}%s", colw, tlast)
	jborder = jborder + sprintf("{txt}{hline %g}%s", colw, jlast)
	bborder = bborder + sprintf("{txt}{hline %g}%s", colw, blast)
	header = header + sprintf("{txt}{ralign %g:%s}%s",colw,colname,divider)
	strcols = strcols + sprintf("{res}{ralign %g:%s%s}"+"%s", colw, 
							strval, space, divider)
}

void _stpower_tofile(string scalar tofile, string scalar varnames,
		     string scalar varname, real scalar val)
{
	string scalar holdscalar
	varnames = varnames + varname + " "
	holdscalar = st_tempname()
	st_numscalar(holdscalar, val)
	tofile  = tofile + "(" + holdscalar + ") "
}
end
