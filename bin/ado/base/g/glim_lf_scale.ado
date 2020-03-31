*! version 1.0.0  02mar2017
program define glim_lf_scale
        version 6
	args todo b lnf g H score

	local VV : di "version " string(_caller()) ":"

        tempvar eta mu dmu v 
	tempname sig2
	mleval `eta' = `b', eq(1)
	mleval `sig2' = `b', eq(2) scalar

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
	local model $SGLM_V
	local model `model'_scale
	global SGLM_scale = `sig2'
	qui `VV' `model' 5 `eta' `mu' `lli'
	mlsum `lnf' = `lli'

	if `todo' == 0 | `lnf'==. { exit }
end
exit
