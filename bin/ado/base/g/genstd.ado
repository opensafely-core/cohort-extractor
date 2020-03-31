*! version 2.0.0  07/23/91
program define genstd
	version 3.0
	mac def _varlist "req new max(1)"
	mac def _exp "req noprefix"
	mac def _options "Mean(real 0) Std(real 1)"
	mac def _if "opt"
	mac def _in "opt"
	tempvar RESULT
	parse "%_*"
	rename %_varlist %_RESULT
	quietly {
		replace %_RESULT = %_exp %_in %_if
		quietly sum %_RESULT
		#delimit ;
		replace %_RESULT =
			 ((%_RESULT-_result(3))/sqrt(_result(4)))*(%_std)
			 + (%_mean) ;
		#delimit cr
		label var %_RESULT "Standardized values of %_exp"
	}
	rename %_RESULT %_varlist
end
