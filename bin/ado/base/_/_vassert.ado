*! version 1.0.1  16aug2017

program _vassert
	syntax anything(id="variables") [if] [in], [ tol(real 1e-8) ///
		scale(real 0.0) noSTOP ]

	gettoken v1 v2 : anything, bind

	confirm numeric variable `v1'
	
	marksample touse, novarlist

	if `scale' > 0.0 {
		local ty : type `v1'
		tempvar sv1
		qui gen `ty' `sv1' = `scale'*`v1'
	}
	else local sv1 `v1'

	tempvar diff
	cap confirm variable `v2'
	if c(rc) {
		tempname s

		cap scalar `s' = `v2'
		if c(rc) {
			di as err "second argument must be a numeric " ///
			 "variable or scalar"
			exit 198
		}
		qui gen `diff' = reldif(`sv1',`s') if `touse'
	}
	else {
		confirm numeric variable `v2'
		unab v1 : `v1'
		unab v2 : `v2'
		if "`v1'" == "`v2'" {
			di as err "{p}you are comparing variable {bf:`v1'} " ///
			 `"with itself; be aware of Stata's short cut "'     ///
			 "mechanism{p_end}"
			exit 498
		}
		qui gen `diff' = reldif(`sv1',`v2') if `touse'
	}
	qui count if `touse' & `diff'>`tol'
	if r(N) > 0 {
		di as err "assertion failure: " r(N) " differences >" ///
		 %7.1g `tol'
		summarize `diff' if `touse', meanonly
		di "N           = " %9.0g r(N)
		di "min(reldif) = " %9.3g r(min)
		di "max(reldif) = " %9.3g r(max)
		qui count if missing(`diff') & `touse'
		di "# missing reldif = " %4.0g r(N) 
		if ("`stop'"=="") exit 9
	}
end

exit
