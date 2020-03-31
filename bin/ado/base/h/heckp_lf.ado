*! version 1.1.0  19feb2019
program define heckp_lf
        version 6.0
	args 		lf	/* to be filled in with the likelihood
		*/ 	xb1	/* x*b1
		*/	xb2	/* x*b2
		*/	xb3	/* x*b3 */

        /* Calculate the log-likelihood */

	local rho (expm1(2*`xb3')) / (exp(2*`xb3')+1)

	qui replace `lf' = binorm(`xb1',`xb2',`rho')   if $ML_y1 & $ML_y2
	qui replace `lf' = binorm(-`xb1',`xb2',-`rho') if !$ML_y1 & $ML_y2
	qui replace `lf' = 1 - normprob(`xb2')         if !$ML_y2
	qui replace `lf' = ln(`lf') if $ML_samp

end
