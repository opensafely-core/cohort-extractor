*! version 1.0.8  04may2017
*! parse Mata optimize() options
*! mlopts macro is expanded to a mata vector.  
*! Mata function _optimize_options_init() constructs a _optimize_options
*!  structure using the contents of the vector.

program _parse_optimize_options, sclass
	syntax , [ 				///
		TRace				///
		SHOWSTEP			///
		ITERate(string)		 	///
		TOLerance(string)		///
		LTOLerance(string)		///
		NONRTOLerance			///
		SHOWNRtolerance			///
		NRTOLerance(string)		///
		DIFficult			///
		COLlinear			///
		TECHnique(string)		///
		noLog				///
		debug(integer 0)		///
		vce(string)			///
		GTOLerance(numlist max=1 >0)	///
		GRADient			///
		HESSian				///
 		* ]

	sreturn clear

	if "`gtolerance'" != "" {
		di "{p 0 6 2}note: {bf:gtolerance()} ignored because it is " ///
		 "not supported by {help mf_optimize:Mata optimize()}{p_end}"
	}	
	if "`iterate'" != "" {
		ParseInt, int(`iterate') which(iterate)
		local iterate = `s(int)'
	}
	else local iterate = -1

	if "`tolerance'" != "" {
		ParseReal, real(`tolerance') which(tolerance)
		local tolerance = `s(real)'
	}
	else local tolerance = -1

	if "`ltolerance'" != "" {
		ParseReal, real(`ltolerance') which(ltolerance)
		local ltolerance = `s(real)'
	}
	else local ltolerance = -1

	if "`nrtolerance'" != "" {
		ParseReal, real(`nrtolerance') which(nrtolerance)
		local nrtolerance = `s(real)'
	}
	else local nrtolerance = -1

	sreturn clear

	local shownr = "`shownrtolerance'"!=""
	if "`nonrtolerance'"!="" {
		if `shownr' {
			di as err "{p}options {bf:nonrtolerance} and " ///
			 "{bf:shownrtolerance} may not be combined{p_end}"
			exit 184
		}
		if `nrtolerance' > 0 {
			di as err "{p}options {bf:nonrtolerance} and " ///
			 "{bf:nrtolerance()} may not be combined{p_end}"
			exit 184
		}
		local shownr = -1
	}
	local log = "`log'"!=""
	local hybrid = "`difficult'"!=""
	// maximize options: _stateSpace::MLE expects them in this order
	/*               1            2          3         4          5	*/
	local mlopts (`iterate',`nrtolerance',`shownr',`tolerance',`ltolerance'
	/* 		       6       7       8			*/
	local mlopts `mlopts',`log',`hybrid',`debug'
	/* positions 9-12						*/
	if "`technique'" != "" {
		ParseTechnique `technique'
		local mtech `s(mtech)'
		if `iterate'==0 {
			if "`s(tech2)'" != "" {
				di as err "{p}optimization switching " ///
				 "algorithm may not be used with "     ///
				 "{bf:iteration(0)}{p_end}"
				exit 184
			}
			if "`s(tech1)'" != "nr" {
				di as err "{p}{bf:technique(`s(tech)')} "    ///
				 "may not be combined with {bf:iterate(0)} " ///
				 "{p_end}"
				exit 184
			}
		}
	}
	else if `iterate' == 0 {
		local mtech ,4,0,0,0
		sreturn local tech1 nr
	}
	else {
		local mtech ,0,0,0,0
	}
	local mlopts `mlopts'`mtech'

	VCEparse, `vce'
	/*                      13					*/
	local mlopts `mlopts'`s(mvce)'

	local trace = ("`trace'"!="")
	local gradient = ("`gradient'"!="")
	local hessian = ("`hessian'"!="")
	local showstep = ("`showstep'"!="")
	
	/*                      14       15         16         17	*/
	local mlopts `mlopts',`trace',`showstep',`gradient',`hessian'

	sreturn local mlopts "`mlopts')"
	sreturn local iterate `iterate'

	/* other options						*/
	if ("`options'"!="") sreturn local rest `"`options'"'

	sreturn local trace `trace'
	sreturn local showstep	`showstep'
	sreturn local tolerance `tolerance'
	sreturn local ltolerance `ltolerance'
	sreturn local nonrtolerance `nonrtolerance'
	sreturn local shownrtolerance `shownrtolerance'
	sreturn local nrtolerance `nrtolerance'
	sreturn local difficult `difficult'
	sreturn local collinear `collinear'
	sreturn local nolog `nolog'
	sreturn local debug `debug'
	sreturn local gtolerance `gtolerance'
	sreturn local gradient `gradient'
	sreturn local hessian `hessian'
end

program ParseTechnique, sclass
	syntax anything(name=tech id="technique")

	local technique `tech'
	local opttech bhhh bfgs dfp nr

	tempname iter
	
	forvalues i=1/2 {
		gettoken val tech: tech
	
		local val = lower(trim("`val'"))
		if "`val'" == "" {
			local mtech `mtech',0,0
			continue, break
		}
		local techi : list posof "`val'" in opttech
		if `techi' == 0 {
			di as err "{p}{bf:`val'} in " 			    ///
			 "{bf:technique(`technique')} is not allowed; "     ///
			 "expected one of {bf:bhhh}, {bf:bfgs}, {bf:dfp}, " ///
			 "or {bf:nr}{p_end}"
			exit 198 
		}
		sreturn local tech`i' `val'
		local mtech `mtech',`techi'
		local tech = trim("`tech'")
		if "`tech'" == "" {
			local mtech `mtech',0
		}
		else {
			gettoken val tech: tech
			cap scalar `iter' = `val'
			if _rc {
				di as err "{p}{bf:`val'} in " 		 ///
				 "{bf:technique(`technique')} is not " 	 ///
				 "allowed; expected a positive integer " ///
				 "or nothing{p_end}"
				exit 198 
			}
			if `iter' <= 0 | float(`iter')!=`iter' {
				di as err "{p}{bf:`val'} in " 		 ///
				 "{bf:technique(`technique')} is not " 	 ///
				 "allowed; expected a positive integer " ///
				 "or nothing{p_end}"
				exit 198 
			}
			local mtech `mtech',`=`iter''
			local tech = trim("`tech'")
		}
	}
	if "`tech'" != "" {
		di as err "{p} {bf:`tech'} in {bf:technique(`technique')} " ///
		 "is not allowed; only one technique is allowed{p_end}"
		exit 198 
	}
	sreturn local mtech `mtech'
end

program define VCEparse, sclass
	version 11

	capture syntax , [ oim Robust ]
	if _rc {
		gettoken comma rest : 0, parse(",")
		local rest : list retokenize rest
		di as err "{p}{bf:vce(`rest')} is not allowed; use " ///
		 "{bf:vce(oim)} or {bf:vce(robust)}{p_end}"
		exit 198
	}
	if ("`oim'`robust'"=="") local oim oim
	else if "`oim'" != "" & "`robust'" != "" {
		di as err "{p}only one of {bf:oim} or {bf:robust} is " ///
		 "allowed in option {bf:vce()}{p_end}"
		exit 184
	}
	if ("`oim'"!="") sreturn local mvce ",0"
	else sreturn local mvce ",1"

	sreturn local vce `oim'`robust'
end

program ParseInt, sclass
	cap syntax, which(string) int(integer)

	local rc = c(rc)
	if `rc' {
		di as err "{bf:`which'({it:#})} must be a nonnegative " ///
		 "integer"
		exit `rc'
	}
	if `int' < 0 {
		di as err "{bf:`which'(`int')} must be a nonnegative " ///
		 "integer"
		exit 198
	}
	sreturn local int = `int'
end

program ParseReal, sclass
	cap syntax, which(string) real(real)

	local rc = c(rc)
	if `rc' {
		di as err "{bf:`which'({it:#})} must be in (0,1)"
		exit 198
	}
	if `real'<=0 | `real'>=1 {
		di as err "{bf:`which'(`real')} must be in (0,1)"
		exit 198
	}
	sreturn local real = `real'
end

exit
