*! version 1.0.5  31aug2016
program twoway__fpfit_serset

	// Creates a serset for a fractional polynomial fit view.  Runs from an 
	// immediate log.

	syntax , SERSETNAME(string) X(string) Y(string) TOUSE(string)	///
		 CMD(string) [ PREDOPTS(string) REGOPTS(string)		///
		 MOREVARS(string) WEIGHT(string)			///
		 LEVEL(real `c(level)') STD(string) ]

	tempname esthold
	_estimates hold `esthold' , nullok restore

	preserve
	qui keep if `touse'

	tempvar yhat
	capture fracpoly `cmd' `y' `x' [`weight'] , `regopts'
	sort `x' `y'
	qui keep if `x' != `x'[_n-1]
	if _rc {
		di in green "(note:  fracpoly could not fit model)"
		qui gen `yhat' = . in 1
		local failed 1
	}
	else	qui fracpred `yhat' , `predopts'

	local ylist `yhat'

	if "`std'" != "" {
		tempvar se lcl ucl

		if 0`failed' {
			qui gen `lcl' = . in 1
			qui gen `ucl' = . in 1
		}
		else {
			tempname tval
			if e(df_r) < . {
				scalar `tval' = 			///
					invttail(e(df_r), ((100-`level')/200))
			}
			else {
				scalar `tval' =	- invnormal(((100-`level')/200))
			}
			qui fracpred `se' , `std'
			qui gen `lcl' = `yhat' - `tval' * `se'
			qui gen `ucl' = `yhat' + `tval' * `se'
		}
		label variable `lcl' "`level'% CI"
		label variable `ucl' "`level'% CI"

		local ylist `ylist' `lcl' `ucl'
	}

	.`sersetname' = .serset.new `ylist' `x' `morevars' ,		///
		`.omitmethod' `options' nocount

	if "`std'" != "" {
		.`sersetname'.sers[2].name = "lower_limit"
		.`sersetname'.sers[3].name = "upper_limit"
	}

	.`sersetname'.sort `x'
	.`sersetname'.sers[1].name = "`y'"

end

