*! version 1.2.0  18jun2009
program define glim_lf
        version 6
	args todo b lnf g H score

	local VV : di "version " string(_caller()) ":"

        tempvar eta mu dmu v
	mleval `eta' = `b'
	qui $SGLM_L 1 `eta' `mu'
	qui $SGLM_mu `mu'
	qui $SGLM_L 2 `eta' `mu' `dmu'
	qui $SGLM_V 1 `eta' `mu' `v'

	/* Calculate log-likelihood */

	if "$ML_off" == "" {
		global ML_off 0 
	}

	tempname phi
	if "$SGLM_ph" == "" { global SGLM_ph = 1 }
	scalar `phi' = $SGLM_ph
	if $SGLM_s1 { scalar `phi' = $SGLM_s1 }
	tempvar lli 
	qui `VV' $SGLM_V 5 `eta' `mu' `lli'
	mlsum `lnf' = `lli'

	if `todo' == 0 | `lnf'==. { exit }

	/* Calculate gradient */

	qui replace `score' = ($ML_y1 - `mu')/(`phi'*`v')*`dmu' if $ML_samp
$ML_ec	mlvecsum `lnf' `g' = `score'

	if `todo' == 1 | `lnf'==.  { exit }

	/* Re-calculate phi */

	tempvar tt
	qui gen double `tt' = sum($ML_w*($ML_y1-`mu')*($ML_y1-`mu')/`v')
	
	if _caller() >= 11 {
		global SGLM_ph = `tt'[_N]/($ML_N-$ML_kCns)
	}
	else {
		global SGLM_ph = `tt'[_N]/($ML_N-$ML_k)
	}
	/* Calculate user-specified ancillary parameters */
	qui $SGLM_A

	/* Calculate negative Hessian */

	tempvar t1
	qui gen double `t1' = `dmu'*`dmu'/`v' if $ML_samp

	if "$SGLM_f" == "" {
		global SGLM_f = -1        
	}

	if $SGLM_f >= $ML_ic {		/* Fisher Scoring */
		mlmatsum `lnf' `H' = (`t1')/`phi'
		exit
	}
						/* Newton-Raphson */
	tempvar dv d2mu
	qui $SGLM_V 2 `eta' `mu' `dv'
	qui $SGLM_L 3 `eta' `mu' `d2mu' 
	tempvar t2 t3
	qui gen double `t2' = `t1'/`v'*`dv' if $ML_samp
	qui gen double `t3' = `d2mu'/`v'    if $ML_samp
	mlmatsum `lnf' `H' = (`t1'-(`mu'-$ML_y1)*(`t2'-`t3'))/`phi'
end
exit
