*! version 1.0.1  07may2019
program u_mi_impute_chained_labelvars
	version 12
	args fname ivarsincord
	preserve
	use `"`fname'"', clear
	qui compress
	local ind 1
	foreach ivar in `ivarsincord' {
		cap unab vars : `ivar'_*
		if _rc { // long variable names
			cap unab vars : _mi_`ind'_*
			local ++ind
		
			gettoken var vars : vars
			label variable `var' "Mean of `ivar'"
			gettoken var vars : vars
			label variable `var' "Std. Dev. of `ivar'"
			if ("`vars'"!="") {
			    gettoken var vars : vars
			    label variable `var' "Minimum of `ivar'"
			    gettoken var vars : vars
			    label variable `var' "25th percentile of `ivar'"
			    gettoken var vars : vars
			    label variable `var' "Median of `ivar'"
			    gettoken var vars : vars
			    label variable `var' "75th percentile of `ivar'"
			    gettoken var vars : vars
			    label variable `var' "Maximum of `ivar'"
			}
		}
		else {
			cap confirm variable `ivar'_mean
			if !_rc {
			    label variable `ivar'_mean "Mean of `ivar'"
			}
			cap confirm variable `ivar'_sd
			if !_rc {
			    label variable `ivar'_sd "Std. Dev. of `ivar'"
			}
			cap confirm variable `ivar'_min
			if !_rc {
			    label variable `ivar'_min "Minimum of `ivar'"
			}
			cap confirm variable `ivar'_p25
			if !_rc {
			label variable `ivar'_p25 "25th percentile of `ivar'"
			}
			cap confirm variable `ivar'_p50
			if !_rc {
			label variable `ivar'_p50 "Median of `ivar'"
			}
			cap confirm variable `ivar'_p75
			if !_rc {
			label variable `ivar'_p75 "75th percentile of `ivar'"
			}
			cap confirm variable `ivar'_max
			if !_rc {
			    label variable `ivar'_max "Maximum of `ivar'"
			}
		}
	}
	label variable iter "Iteration numbers"
	label variable m "Imputation numbers"
	qui label data "Summaries of imputed values from -mi impute chained-"
	qui save, replace
end
