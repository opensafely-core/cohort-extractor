*! version 1.0.1  21oct2019

program define meta__parse_varlist
	version 16
	syntax varlist [, touse(varname) civartol(real 1E-6)]
	
	confirm numeric variable `varlist'
		
	if missing("`touse'") {
		tempvar touse
		gen `touse' = 1
	}
	local nvar : word count `varlist'
	
	if `nvar' == 6 {
		syntax varlist [,  touse(varname)]
		gettoken n1  varlist : varlist 
		gettoken m1  varlist : varlist 
		gettoken sd1 varlist : varlist 
		gettoken n2  varlist : varlist 
		gettoken m2  varlist : varlist 
		gettoken sd2 : varlist 
				
		tempvar isint
		
		qui gen `isint' = floor(`n1') if `touse'
		cap assert `isint' == `n1' & `n1' > 0 if `touse'
		if _rc  {
			di as error "{p}variable {bf:`n1'} must contain " ///
				"positive integers{p_end}"
			exit 459 
		}
		qui replace `isint' = floor(`n2') if `touse'
		cap assert `isint' == `n2' & `n2' > 0 if `touse'
		if _rc  {
			di as error "{p}variable {bf:`n2'} must contain " ///
				"positive integers{p_end}"
			exit 459 
		}
		cap assert `sd1' > 0 if `touse'
		if _rc {
			di as error "variable {bf:`sd1'} must be positive"
			exit 459 
		}
		cap assert `sd2' > 0 if `touse'
		if _rc {
			di as error "variable {bf:`sd2'} must be positive"
			exit 459 
		}
	}
	else if `nvar' == 4 {		
		
		tempvar isint
		
		foreach var of varlist `varlist' {
			cap assert `var' >= 0 if `touse'
			if _rc {
				di as err "variable {bf:`var'} must be positive"
				exit 459
			}
			cap drop `isint'
			qui gen `isint' = floor(`var') if `touse'
			cap assert `isint' == `var' if `touse'
			if _rc {
				di as txt "{p}Warning: variable {bf:`var'}" /// 
				  " contains non-integer values; " ///
				  "continuity correction is assumed{p_end}"
			} 
		}		
	}
	else  {
		if `nvar' == 2 {
			tokenize `varlist'
			cap assert `2' > 0 if `touse'
			if _rc {
				di as err "standard-error variable {bf:`2'}" _c
				di as err " must be positive"
				exit 459
			}
		}
		if `nvar' == 3 {
			tokenize `varlist'
			cap assert `1' < `3' if `touse'
			if _rc {
				di as err "{p}effect size variable {bf:`1'}" /// 
				  " must be <= CI upper limit, {bf:`3'}{p_end}"
				exit 459
			}
			cap assert `1' > `2' if `touse'
			if _rc {
				di as err "{p}effect size variable {bf:`1'}" ///
				  " must be >= CI lower limit, {bf:`2'}{p_end}"
				exit 459
			}
			
			meta__parse_maxopts, civartol(`civartol')
			
			tempvar width1 width2
			gen double `width1' = `1' - `2'
			gen double `width2' = `3' - `1'
			cap assert reldif(`width1', `width2') < `civartol'
			if _rc {
	di as err "confidence intervals not symmetric"
	di as err "{p 4 4 2}CIs defined by variables {bf:`2'} and {bf:`3'} " ///
		"must be symmetric and based on a normal distribution. If "  ///
		"you are working with effect sizes in the original metric, " ///
		"such as odds ratios or hazard ratios, with {bf:meta set}, " ///
		"you should specify the effect sizes and CIs in a "          ///
		"normalizing metric, such as the log metric.{p_end}" 
	di _n as err "{p 4 4 2}The default tolerance to determine the CI "   ///
		"asymmetry is 1e-6. Effect sizes and their CIs are often "   ///
		"reported with "  					     ///
		"limited precision that, after the normalizing "	     ///
		"transformation, may lead to asymmetric CIs. In that case, " ///
		"the default of 1e-6 may be too stringent. You may loosen "  ///
		"the tolerance by specifying option {bf:civartolerance()}."  ///
		"{p_end}"
	exit 459
			}
		}
	}				
end
