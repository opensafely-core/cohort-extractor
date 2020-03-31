*! version 4.0.2  25may1998
*  Usage:  _crcar1 rho_scalar method_macro : resids_var , method [K(# vars)]
program define _crcar1
	version 6.0
	parse `"`0'"', parse(" ,")
	args         rho     /*  scalar name to hold rho
		*/   fullopt /*  macro name to hold full rho-method name
		*/   colon   /*  : 
		*/   resids  /*  variable name containing residuals */

	mac shift 4
	local 0 `"`*'"'

	capture syntax [if] [in]    /*
		*/ [, K(integer -1) Check DW FREG NAGar REGress THeil TSCorr ]

	/* NOTE:  K only required of nager and theil options */

	if _rc != 0 {
		di in red "Invalid option for rho(rho_method):  `0'"
		exit 198
	}

	if "`dw'`freg'`nagar'`regress'`theil'`tscorr'" == "" {
		c_local `fullopt' "regress"
	}
	else    c_local `fullopt' "`dw'`freg'`nagar'`regress'`theil'`tscorr'"

	if "`check'" != "" { exit }

	tempvar vals

	if "`regress'" != "" | "`dw'`freg'`nagar'`theil'`tscorr'" == "" {
		/* default regression rho */
		quietly {
			tempname numer
			gen double `vals' = `resids'*l.`resids'  `if' `in'
			sum `vals', meanonly
			scalar `numer' = r(sum)
			replace `vals' = l.`resids'^2 if `vals' != .
			sum `vals', meanonly 
			scalar `rho' = `numer' / r(sum)
			exit
		}
/*
		qui regress `resids' l.`resids' `if' `in' , nocons
		scalar `rho' = _b[l.`resids']
		exit
*/
	}

	if "`freg'" != "" {
		/* forward regression rho */
		quietly {
			tempname numer
			gen double `vals' = `resids'*f.`resids' `if' `in'
			sum `vals', meanonly
			scalar `numer' = r(sum) 
			replace `vals' = f.`resids'^2 if `vals' != .
			sum `vals', meanonly 
			scalar `rho' = `numer' / r(sum)
			exit
		}
/*
		qui regress `resids' f.`resids' `if' `in' , nocons
		scalar `rho' = _b[f.`resids']
		exit
*/
	}

												/* SSE */
	if "`dw'`nagar`theil'`tscorr'" != "" {
		tempname sse
		qui gen double `vals' = `resids'*`resids'
		sum `vals'  `if' `in' , meanonly
		scalar `sse' = r(sum)
		local  sse_n = r(N)
		drop `vals'
	}

	if "`dw'`nagar'" != "" {
		tempname dwval
		qui gen double `vals' = (`resids' - l.`resids')^2
		sum `vals'  `if' `in' , meanonly
		scalar `dwval' = r(sum) / `sse'
		drop `vals'

		if "`dw'" != "" {
												/* durbin-watson rho */
			scalar `rho' = 1 - `dwval' / 2
		}
		else {
												/* theil-nager rho */
			if `k' == -1 {
				di in red /*
					*/ "nagar option requires an integer k() option, _crcar2"
				exit 198
			}
			scalar `rho' = (`sse_n'^2 * (1 - `dwval'/2) + `k'^2) /*
				*/     / (`sse_n'^2 - `k'^2)
		}

		exit
	}

											/* e'e_(t-1)  */
	if "`tscorr'`theil'" != "" {
		tempname cov
		qui gen double `vals' = `resids' * l.`resids'
		sum `vals'  `if' `in' , meanonly
		scalar `cov' = r(sum)
		drop `vals'

		if "`tscorr'" != "" {
											/* "standard" TS rho */
			scalar `rho' = `cov' / `sse'
		}
		else {
											/* theil's rho */
			if `k' == -1 {
				di in red /*
					*/ "theil option requires an integer k() option, _crcar2"
				exit 198
			}
			scalar `rho' = /*
				*/ ( (`sse_n'-`k') * `cov' ) / ( r(N) * `sse' )
		}
	}

end


exit


