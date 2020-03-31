*! version 1.1.1  28jan2015  
program define dwstat, rclass
	version 6
	syntax [if] [in] [, noDetail noSample ]

	if "`e(cmd)'" == "prais" {
		di as err "not available after prais"
		exit 321
	}

	marksample touse
	if "`sample'" == "" { qui replace `touse' = 0 if !e(sample) }

					/* get time variables */
	_ts timevar panelvar if `touse', sort onepanel
	markout `touse' `timevar'

	/* Refuse if e(b) has tempvars -- no way 
	   to ensure residuals are correct.	*/
	local bnames : colnames e(b)
	foreach name of local bnames {
		if bsubstr("`name'", 1, 2) == "__" {
			di as error ///
				"temporary variable used in previous regression"
			di as error "cannot compute residuals"
			exit 498
		}
	}
					/* fetch residuals */
	tempname res dw
	qui predict double `res' if `touse' , res

	tsreport if `touse',  report
	return scalar N_gaps = r(N_gaps)
	qui count if `touse'
	return scalar N = r(N)
	return scalar k = e(N) - e(df_r)

	DW `dw' : `res'
	return scalar dw = `dw'

	di _n in gr "Durbin-Watson d-statistic("   /*
		*/ in ye %3.0f return(k) in gr "," in ye %6.0f return(N) /*
		*/ in gr ") = " in ye %9.0g `dw'

end


/* Compute Durbin-Watson statistic -- over all resids */

program define DW 
	args        scl_dw	/*  scalar name to hold DW result 
		*/  colon	/*  :
		*/  resids	/*  residuals */

	tempvar tres
	tempname esqlag

	qui gen double `tres' = (`resids' - l.`resids')^2
	sum `tres', meanonly
	scalar `esqlag' = r(sum)

	drop `tres'
	qui gen double `tres' = `resids' * `resids'
	sum `tres', meanonly

	scalar `scl_dw' = `esqlag' / r(sum)

end


exit

Durbin-Watson d-statistic(  #,    #):  1.2345678

Note:  sample has gaps, statistic may not follow exact
       d-statistic distribution.
---------------------------------------------------------------
                                      | Numerator   Denominator
--------------------------------------+------------------------
Observations used                     |    65          64
Observations with assumed 0 elements  |     0           0
--------------------------------------+------------------------

