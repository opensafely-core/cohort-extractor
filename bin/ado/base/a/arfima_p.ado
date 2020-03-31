*! version 1.0.3  11apr2019

program define arfima_p, sortpreserve
	version 12
	if "`e(cmd)'" != "arfima" {
		di as err "{p}{help arfima##|_new:arfima} estimation " ///
		 "results not found{p_end}"
		exit 301
	}

	syntax newvarlist(max=1 ts) [if][in] [, xb Residuals RSTAndard ///
			FDIFference rmse(string) DYNamic(passthru) ]

	local which `xb' `fdifference' `residuals' `rstandard' 
	local k : word count `which'
	if `k' > 1 {
		di as err "{p}only one of {bf:xb}, {bf:residuals}, " ///
		 "{bf:rstandard}, or {bf:fdifference} is allowed{p_end}"
		exit 198
	}
	else if `k' == 0 {
		if ("`y'"=="") di "{txt}(option {bf:xb} assumed)"

		local which xb
	}
	if "`rmse'" != "" {
		ParseRMSE `rmse'

		local rmselist `"`s(varlist)'"'
		local rtyplist `"`s(typlist)'"'

		if "`which'"=="fdifference" | "`which'"=="rstandard" {
			di as err "{p}options {bf:rmse()} and {bf:`which'} " ///
			 "may not be combined{p_end}"
			exit 184
		}
		local rmse rmse
	}
	else local rmse

	marksample touse, novarlist
	_ts tvar panvar if `touse', sort onepanel

	if ("`e(covariates)'"!="_NONE") local indep `e(covariates)'

	markout `touse' `indep' `tvar'
	cap count if `touse'
	if (r(N)==0) error 2000

	_check_ts_gaps `tvar', touse(`touse')

	if "`dynamic'" != "" {
		if "`which'" != "xb" {
			di as err "{p}options {bf:dynamic()} and " ///
			 "{bf:`which'} may not be combined{p_end}"
			exit 184
		}
		CheckDynamic `tvar', touse(`touse') `dynamic'

		local idyn = `r(index)'
		local vdyn = `r(value)'
	}
	else {
		markout `touse' `e(depvar)'

		local idyn = 0
	}
	cap count if `touse'
	local N = r(N)
	if (`N'==0) error 2000

	tempname b bx
	tempvar z xb

	mat `b' = e(b)
	cap mat `bx' = `b'[1,"`e(depvar)':"]
	if (c(rc)) local k = 0
	else local k = colsof(`bx')

	if (`k') qui mat score double `xb' = `b' if `touse', eq(`e(depvar)')
	else qui gen double `xb' = 0 if `touse'

	qui gen double `z' = `e(depvar)'-`xb' if `touse'

	tempname ar ma d

	cap mat `d' = _b[ARFIMA:d]
	if (c(rc)) {
		local kd = 0
		if "`which'" == "fdifference" {
			di as err "{p}option {bf:fdifference} is not " ///
			 "allowed; there is no fractional difference " ///
			 "parameter in the model{p_end}"
			exit 322
		}
	}
	else local kd = 1

	local var `e(ar)'
	if "`var'" != "" {
		local var: subinstr local var " " "\", all
		local var (`var')
	}
	else local var J(0,1,0)

	local vma `e(ma)'
	if "`vma'" != "" {
		local vma: subinstr local vma " " "\", all
		local vma (`vma')
	}
	else local vma J(0,1,0)

	tempvar v

	qui gen double `v' = .

	mata: _arfima_entry_p(("`which'","`rmse'"), "`touse'", "`z'", ///
		"`v'", `k', `var', `vma', `kd', `idyn')

	qui gen `typlist' `varlist' = `z' if `touse'
	if "`which'" == "residuals" {
		local label "innovations"
	}
	else if "`which'" == "rstandard" {
		local label "standardized innovations"
		qui replace `varlist' = `varlist'/`v' if `touse'
	}
	else {
		qui replace `varlist' = `varlist'+`xb' if `touse'
	
		if "`which'" == "fdifference" {
			local label "`e(depvar)' fractionally differenced"
		}
		else { // "`which'" == "xb"
			local label "xb prediction"
			if "`dynamic'" != "" {
				local label "`label', `dynamic'"
			}
		}
	}
	label variable `varlist' `"`label'"'

	if "`rmselist'" != "" {
		cap count if missing(`v') & `touse'
		if r(N) > 0 {
			di as txt "{p 0 7 2} note: computation of the RMSE " ///
			 "failed; the {bf:`which'} predictions may not be "  ///
			 "valid{p_end}"
		}
		qui gen `rtyplist' `rmselist' = `v'
		label variable `rmselist' `"`label', RMSE"'
	}
end

program ParseRMSE, sclass
	syntax newvarlist(max=1)

	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
end

program CheckDynamic, rclass
	syntax varname, touse(varname) dynamic(string) 

	local tvar `varlist'

	summarize `tvar' if `touse' & !missing(`e(depvar)'), meanonly
	if `dynamic'<r(min) | `dynamic'>r(max)+1 {
		local fmt : format `tvar'
		di as err "{p}{bf:dynamic(}" `fmt' `dynamic' "{bf:)} is " ///
		 "invalid; {bf:dynamic()} must be in [" `fmt' r(min) ", " ///
		 `fmt' r(max)+1 "]{p_end}"

		exit 459
	}
	tempvar dy
	/* with delta > 1 dynamic may not be equal to any of the 	*/
	/*  elements in tvar						*/
	cap gen byte `dy' = (`tvar'<`dynamic') 
	if _rc {
		di as err "{bf:dynamic(`dynamic')} is invalid"
		exit 198
	}
	qui count if `dy'
	local index = r(N) + 1
	local value = `tvar'[`index']

	qui replace `touse' = (`touse'&!missing(`e(depvar)')) if `dy' 
	qui count if `touse' & `tvar'>=`dynamic'
	if r(N) == 0 {
		di as err "{p}there are no valid observations beyond "  ///
		 `"{bf:dynamic(`dynamic')}; check for missing values "' ///
		 "in your variables{p_end}"
		exit 459
	}
	/* index of dynamic after dropping all missings			*/
	qui count if `touse' & `dy'
	local index = r(N)+1

	if (`index'<=0) local index = 1

	return local index = `index'
	return local value = `value'
end

exit

	
