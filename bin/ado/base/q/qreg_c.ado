*! version 3.0.1  09feb2015
*  (see documentation below)
program qreg_c, eclass
	version 13
	syntax varlist(numeric fv) [if] [in] [,	Quantile(real 0.5)	///
						WLSiter(integer 1)	///
						WVAR(string)		///
						* ]
	local quant "`quantile'"
	if `wlsiter'<1 {
		error 198
	}
	tempvar r s2 p wt touse adev rdev
	gen `c(obs_t)' `s2' = _n
	mark `touse' [fweight=`wvar'] `if' `in'
	qui reg `varlist' if `touse' [fweight=`wvar']
	if e(N)==0 | e(N)>=. {
		error 2000
	}
	qui predict double `r' if `touse', resid
	qui replace `touse'=0 if `r'>=.
	drop `r'
	local i 0
	while (`i'<`wlsiter') {
		capture drop `r'
		capture drop `wt'
		qui predict double `r' if `touse', resid
		qui gen double `wt' = cond(`r'>=0,`quant',1-`quant')
		qui reg `varlist' if `touse' [aw=`wt'*`wvar']
		drop `r'
		qui predict double `r' if `touse', resid
		qui replace `r'=cond(`r'>=0,`quant',`quant'-1)*`r'
		local i = `i'+1
	}
	sort `r' `s2'
	drop `r' `s2'

	qui _qreg `varlist' if `touse' [fweight=`wvar'], quant(`quant') ///
			`options'
	if (r(convcode)!=1) {
		error 430 /* convergence not achieved */
	}
	scalar `adev' = r(sum_adev)
	scalar `rdev' = r(sum_rdev)

	qui predict double `p' if `touse'
	tokenize "`varlist'"
	local dv "`1'"
	mac shift
	qui _regress `p' `*' if `touse' [fweight=`wvar'], dep(`dv')

	ereturn scalar sum_adev = `adev'
	ereturn scalar sum_rdev = `rdev'
end

exit

DOCUMENTATION:


	qreg_c depvar [varlist] [if exp] [in range], wvar(varname|#)
						     ----
		[ quantile(#) wlsiter(#) _qreg-options ]
                  -           ---

	Defaults:	quantile(.5)
			wlsiter(1)


Description
-----------

qreg_c provides a fast way to estimate quantile regressions when all that 
is desired is the coefficient vector.

qreg_c is intended for use in bootstrapping situations.

Note that wvar is required and assumed to be a frequency weight.  wvar=0 is
allowable in some observations.  This allows bootstrap estimation to proceed
quickly.


Also see
--------

comments following bsamplew.ado.

<end>
