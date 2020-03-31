*! version 1.0.4  12dec2018

program define menl_validate_byvars, sortpreserve
	syntax varlist(numeric min=1 max=2), touse(varname) ///
		[ cbyvar(varname) vbyvar(varname) rescov(string) ///
		rescor(string) resvar(string) touse2(varname) ]
	version 15.0

	gettoken sorder panels: varlist

	if "`panels'" != "" {
		local withinpanels " within panels"
	}
	tempvar touse1
	gen byte `touse1' = 1-`touse'
	sort `touse1' `panels' `sorder'
	tempvar check isint
	if "`cbyvar'" != "" {
		gen `isint' = floor(`cbyvar')
		local cbyvar1 : char `cbyvar'[name]
		if "`cbyvar1'" == "" {
			local cbyvar1 `cbyvar'
		}
		cap assert `isint' == `cbyvar' & `cbyvar' >= 0
		if _rc & "`rescov'" != "" {
			di as error "{p}by-variable {bf:`cbyvar1'} in " ///
			 "option {bf:rescovariance()} must contain "    ///
			 "nonnegative integers{p_end}"
			exit 459
		}
		if _rc & "`rescor'" != "" {
			di as error "{p}by-variable {bf:`cbyvar1'} in " ///
			 "option {bf:rescorrelation()} must contain "   ///
			 "nonnegative integers{p_end}"
			exit 459
		}	
		gen byte `check' = 1
		qui by `touse1' `panels' (`sorder'): replace `check' = ///
			`cbyvar'[_n]==`cbyvar'[_n+1] if _n<_N & `touse'
		qui count if `check'==0
		if r(N) & "`rescov'" != "" {
			di as err "{p}by-variable {bf:`cbyvar1'} in option " ///
			 "{bf: rescovariance()} varies`withinpanels'; this " ///
			 "is not allowed{p_end}"
			exit 459
		}
		if r(N) & "`rescor'" != "" {
			di as err "{p}by-variable {bf:`cbyvar1'} in option " ///
			 "{bf: rescorrelation()} varies`withinpanels'; "     ///
			 "this is not allowed{p_end}"
			exit 459
		}
		cap drop `check' `isint'
	}
	if "`vbyvar'"!="" & "`vbyvar'"!="`cbyvar'" {
		gen `isint' = floor(`vbyvar')
		local vbyvar1 : char `vbyvar'[name]
		if "`vbyvar1'" == "" {
			local vbyvar1 `vbyvar'
		}
		cap assert `isint' == `vbyvar' & `vbyvar' >= 0
		if _rc & "`rescov'" != "" {
			di as error "{p}by-variable {bf:`vbyvar1'} in " ///
			 "option {bf: rescovariance()} must contain "   ///
			 "nonnegative integers{p_end}"
			exit 459 
		}
		if _rc & "`resvar'" != "" {
			di as error "{p}stratum-variable {bf:`vbyvar1'} in " ///
			 "option {bf: resvariance()} must contain "          ///
			 "nonnegative integers{p_end}"
			exit 459
		}	
		gen byte `check' = 1
		qui by `touse1' `panels' (`sorder'): replace `check' = ///
			`vbyvar'[_n]==`vbyvar'[_n+1] if _n<_N & `touse'
		qui count if `check'==0
		if r(N) & "`rescov'" != "" {
			di as err "{p}by-variable {bf:`vbyvar1'} in option"  ///
			 " {bf: rescovariance()} varies`withinpanels'; this" ///
			 " is not allowed{p_end}"
			exit 459
		}
		if r(N) & "`resvar'" != "" {
			di as err "{p}stratum-variable {bf:`vbyvar1'} in "   ///
			 "option {bf: resvariance()} varies`withinpanels'; " ///
			 "this is not allowed{p_end}"
			exit 459
		}
		cap drop `check'
	}
	if "`touse2'" != "" {
		gen byte `check' = 0
		qui by `touse1' `panels' (`tvar'): replace `check' = 1 ///
			if `touse2'
		qui by `touse1' `panels' (`tvar'): replace `check' = ///
			sum(`check')  if `touse'
		cap by `touse1' `panels' (`tvar'): assert `check'[_N]>0 ///
			if `touse'
		local rc = c(rc)
		if `rc' {
			di as err "{p}second estimation sample generated " ///
			 "for the {bf:tsmissing} option leaves at least "  ///
			 "one panel with no observations{p_end}"
			exit 459
		}
	}
end

exit
