*! version 6.1.0  02may2007
program define ml_e1 /* 0 */
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	if "$ML_nosc" == "" {
		local sclist $ML_sclst
	}
	tempname tr
	if `calltype'==0 | `calltype'==1 { 
		$ML_vers $ML_user `calltype' $ML_b $ML_f $ML_g `tr' `sclist'
		ml_count_eval $ML_f `dottype'
		exit
	}
	$ML_vers $ML_user 1 $ML_b $ML_f $ML_g `tr' `sclist'
	ml_count_eval $ML_f input

	local f $ML_f
	local d $ML_g
	local v $ML_V
	local b $ML_b
	tempname bb dd1 ff h dd2
	local epsf 1e-4			/* was 1e-3, ought to adjust itself */
	capture mat drop `v'
	local i 1
	while (`i' <= colsof(matrix(`b'))) {
		scalar `h' = float((abs(`b'[1,`i'])+`epsf')*`epsf')
		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] + `h'
		$ML_vers $ML_user 1 `bb' `ff' `dd1' `tr' `sclist'
		ml_count_eval `ff' input

		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] - `h'
		$ML_vers $ML_user 1 `bb' `ff' `dd2' `tr' `sclist'
		ml_count_eval `ff' input

		scalar `h' = 1/(2*`h')
		mat    `dd2' = `dd2' - `dd1'
		mat    `dd2' = `h' * `dd2'
		mat    `v' = nullmat(`v') \ `dd2'

		local i = `i' + 1
	}
	/* symmetrize */
	mat `v' = (`v' + `v'')*.5
end
