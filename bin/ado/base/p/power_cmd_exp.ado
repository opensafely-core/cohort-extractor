*! version 1.1.0  19feb2019
program power_cmd_exp
	version 14

	syntax [anything] [, test * ]
	local type `test'
	pss_exp_`type' `anything', `options'
end

program pss_exp_test

	_pss_syntax SYNOPTS : twotest	
	syntax [anything] , 	pssobj(string) 	///
			   [ 	`SYNOPTS'	///
				HRatio(string)	///
				LNHRatio(string) ///
				Time(string)	///
				effect(string)  ///
				p1(string)	///	//undocumented
				DIFFerence(string) ///
				HDIFFerence(string) ///
				FPeriod(string) ///
				APeriod(string) ///
				STUDYTime(string) ///
				APRob(string)	///
				ATime(string)	///
				APTime(string)	///
				ASHape(string)	///
				LOSSPRob(string) ///
				lossprob1(string) ///
				lossprob2(string) ///
				LOSSTime(string) ///
				LOSSHaz(string) ///
				losshaz1(string) ///
				losshaz2(string) ///
				initshape(real 0.5) ///
				*		///
			   ]
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything
		
	if ("`studytime'"!="") { 
 		if ("`aperiod'`fperiod'"=="") {
 			local fperiod = `studytime'
 			local aperiod = 0
 		}
 		else if ("`aperiod'"!="") {
			if (`aperiod' >`studytime') {
				di as err "{p}{bf:aperiod()} should be " ///
				"no greater than {bf:studytime()} {p_end}"
				exit 198
			}		
 			local fperiod = `studytime'-`aperiod'
 		}
 		else if ("`fperiod'"!="") {
			if (`fperiod' > `studytime') {
				di as err "{p}{bf:fperiod()} should be " ///
				"no greater than {bf:studytime()} {p_end}"
				exit 198
			}
 			local aperiod = `studytime' - `fperiod'
 		}

 	}
	
	if (`"`fperiod'`studytime'`aperiod'"'!= "") {
		if (`"`aperiod'"' == "") local aperiod = 0
		if (`"`fperiod'"' == "") local fperiod = 0
		cap assert `aperiod'+`fperiod' > 1e-4
		if _rc {
			di as err "duration of study is too small (<= 1.0e-4)"
			exit 198
		}
	}

	/* aprob(), aptime() and atime() */
	local recruit `aprob' `atime' `aptime'
	if (`"`aperiod'"' != "") {
		if `"`recruit'"' == "" {
			if `"`ashape'"' != "" {	
			/* compute z with aprob=0.5 and specified ashape() */
				local aprob = 0.5
				if (abs(`ashape') < 1E-8) {
					local atime = `aperiod'/2
					local aptime = 0.5
				}
				else {
					local aprob = 0.5
					local atime = `aprob'* ///
				(-expm1(-`ashape'*`aperiod'))
					local atime = -ln1m(`atime')/`ashape'
					local aptime = `atime'/`aperiod'
				}				
			}
		}
		else {
			if `"`aprob'"' != "" {
				ChkOpts aprob `aprob' 1 1 1 0.01 0.99
			}
			else local aprob = 0.5
			if `"`aptime'"' != "" {
				ChkOpts aptime `aptime' 1 1 1 0.01 0.99
				local atime = `aptime'*`aperiod'
			}
			else if `"`atime'"' != "" {
				local lb = 0.01*`aperiod'
				local ub = 0.99*`aperiod'
				cap ChkOpts atime `atime' 1 1 1 `lb' `ub'
				if _rc {
di as err "{p}{bf:atime()} must be a number between" %9.2g `lb' " and " ///
    %9.2g `ub' " (1% and 99% of the accrual period of length `aperiod'){p_end}"
exit _rc
				}
				local aptime = `atime'/`aperiod'
			}
			else {
				local aptime = 0.5
				local atime = 0.5*`aperiod'
			}
			/* get accrual rate */
			if `"`recruit'"'!="" & (`aprob'!=0.5 | ///
					`atime'!=`aperiod'/2) {
				qui GetRate, pr(`aprob') z(`atime') ///
					act(`aperiod') initshape(`initshape')
					
				local ashape = r(rate)
				if r(rate) == . {
					di as err "shape is missing; adjust" ///
						" values of {bf:aprob()}, " ///
						"{bf:atime()} or {bf:aptime()}"
					exit 198
				}
				/* check computed rate */
				local pr = (-expm1(-`ashape'*`atime')) ///
						/(-expm1(-`ashape'*`aperiod'))
				cap assert reldif(`aprob', `pr') < 1.0e-4
				if _rc {
				di as err ///
				"{p}the computed rate" %8.4f `ashape' ///
				" does not agree with specified" ///
				" accrual options; try different" ///
				" values of {bf:aprob()} and " ///
				"{bf:atime()}{p_end}"
				exit 198
				}
			}
			else if `"`recruit'"'!="" & (`aprob'==0.5 | ///
					`atime'==`aperiod'/2) {
				local ashape = 0
			}		
		}
		
	}
	
	
	
	if (`"`arg1'"'=="") local arg1 .
	if (`"`arg2'"'=="") local arg2 .
	if (`"`hratio'"'=="") local hratio .
	if (`"`lnhratio'"'=="") local lnhratio .
	if (`"`difference'`hdifference'"'=="") local difference .


	if ("`p1'"=="") local p1 .
	if ("`time'"=="") local time .

 	if "`aperiod'" == "" local aperiod .
 	if "`fperiod'" == "" local fperiod .
	if "`ashape'" == "" local ashape .
	if "`aprob'" == "" local aprob .
	if "`aptime'" == "" local aptime .
	if "`atime'" == "" local atime .
	if "`losshaz1'" == "" local losshaz1 .
	if "`losshaz2'" == "" local losshaz2 .
	if "`losshaz'" == "" local losshaz .
	if "`lossprob1'" == "" local lossprob1 .
	if "`lossprob2'" == "" local lossprob2 .
	if "`lossprob'" == "" local lossprob .
	if "`losstime'" == "" local losstime . 
		   
	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", 		///
				"`n'", "`n1'", "`n2'", "`nratio'", 	///
				`arg1', `arg2',	`hratio', `lnhratio',	///
				`difference'`hdifference', `p1', `time', ///
				`fperiod',		///
				   `aperiod',		///
				   `aprob',		///
				   `aptime',		///
				   `atime',		///
				   `ashape',		///
				   `losstime',		///
				   `lossprob1',		///	
				   `lossprob2',		///	
				   `lossprob',		///	
				   `losshaz1',		///
				   `losshaz2',		///
				   `losshaz');			///
		`pssobj'.compute();				///
		`pssobj'.rresults()
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
local errmsg "{bf:`optname'()} must be a number between `pnt1' and `pnt2'"
	}
	else {
local errmsg "{bf:`optname'()} must be a positive number"
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

/* computes accrual rate based on the truncated exponential probability */
program GetRate, rclass
	version 10
	syntax [, PR(real 0.5) Z(real 0.5) ACT(real 1) initshape(real 0.5) ]
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
				"_stpower_getrate" "rate" `initshape' ///
				1e-6 50 1e-6
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
