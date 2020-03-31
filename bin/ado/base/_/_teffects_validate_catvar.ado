*! version 1.0.2  03jun2015

program _teffects_validate_catvar, rclass sortpreserve
	syntax varname, argname(string) touse(varname) ///
		        [ binary frac(integer 0)]
	
	tempvar kvar 

	local dvar `varlist'

	qui count if trunc(`dvar')!=`dvar' & `touse'
	local n = r(N)
	qui count if `dvar' < 0
	local n = `n' + r(N)

	if (`frac' == 0) {
		if `n' > 0 {
			di as err "{p}`argname' {bf:`dvar'} must contain " ///
			 "nonnegative integers{p_end}"
			exit 459
		}
	}
	
	sort `touse' `dvar'
	qui gen byte `kvar' = 0
	qui by `touse' `dvar': replace `kvar' = 1 if _n==1
	summarize `kvar' if `touse', meanonly
	local klev = r(sum)

	qui count if `touse'
	local n = r(N)

	if `klev' == 1 {
		di as err "{p}there is only one level in `argname' " ///
		 "{bf:`dvar'}; this is not allowed{p_end}"
		exit 459
	}
	if ("`binary'"!="" & `klev'!=2 & `frac'==0){
		di as err "{p}`argname' {bf:`dvar'} must have 2 " ///
		 "levels, but `klev' were found{p_end}"
		exit 459
	}
	/* limit of 20 categories					*/
	if (`klev' > 20 & `frac'==0) {
		di as err "{p}`argname' {bf:`dvar'} has `klev' " ///
		 "levels exceeding the maximum of 20{p_end}"
		exit 459
	}
	return local klev = `klev'
end

exit
