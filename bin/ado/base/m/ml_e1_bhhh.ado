*! version 1.3.0  30jun2008
program define ml_e1_bhhh
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	tempname tr	
	if `calltype' == 0 | `calltype' == 1 {
		$ML_user `calltype' $ML_b $ML_f $ML_g `tr' $ML_sclst
		ml_count_eval $ML_f `dottype'
		exit
	}
	$ML_user 1 $ML_b $ML_f $ML_g `tr' $ML_sclst
	ml_count_eval $ML_f input

	if "$ML_wtyp" == "" {
		local wt [fw=$ML_w]
	}
	else	local wt [$ML_wtyp=$ML_w]

					/* Estimate Hessian as outer
					 * product of gradients_t */
	mat $ML_V = I($ML_k)
	version 11: _cpmatnm $ML_b, square($ML_V)
	capture _robust2 $ML_sclst `wt' if $ML_samp, variance($ML_V) minus(0)
	if c(rc) {
		di as err "bhhh requires observation level scores"
		exit 504
	}
end
exit

