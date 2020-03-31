*! version 1.0.0  27jun2014
program _power_st_getfailprob, rclass
	version 14
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
	tempname ap
	scalar `ap' = r(max)-r(min)
	qui integ `sdf1' `tvar' if `touse'
	tempname pF1 pF2
	scalar `pF1' = 1 - r(integral)/`ap'
	qui integ `sdf2' `tvar' if `touse'
	scalar `pF2' = 1 - r(integral)/`ap'
	qui summ `tvar' if `touse', meanonly
	return scalar fprob1 = `pF1'
	return scalar fprob2 = `pF2'
	return scalar t_min = r(min)
	return scalar t_max = r(max)
	qui restore
	qui set sortseed `sortseed'
end
