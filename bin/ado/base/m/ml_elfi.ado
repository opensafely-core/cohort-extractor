*! version 3.0.0  20nov1997
program define ml_elfi
	version 6
	if "`1'"=="close" {
		exit
	}
	/* otherwise it is an -init- call */
	local i 1
	while `i' <= $ML_n { 
		scalar ${ML_tn`i'} = 1		/* default Scale */
		local i = `i' + 1
	}
end
exit
/*
	ML_lf globals:

	scalar ${ML_tn`i'}	scale, i = 1, ..., $ML_n
*/

