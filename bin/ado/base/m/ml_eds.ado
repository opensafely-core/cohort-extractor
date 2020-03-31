*! version 6.0.1  18may2004
program define ml_eds /* list of score variables to be created */
	version 6

	if inlist("ml_e1","$ML_eval","$ML_evalf") {
		// evaluate scores at solution
		if "$ML_evalf" != "" {
			$ML_evalf 1
		}
		else	$ML_eval 1
	}

	local i 1 
	while `i' <= $ML_n { 
		rename ${ML_sc`i'} ``i''
		local i = `i' + 1
	}
end
exit
/*
Explanation:

The filled-in scores by the user-written routine are $ML_sc1, $ML_sc2, 
etc.  This routine is called when estimation has completed.
It simply renames the scores that have ben filled in to what the 
maximizer now wants them named (${ML_sc`i'} are tempvars right now).
*/
