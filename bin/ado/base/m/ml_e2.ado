*! version 6.1.0  02may2007
program define ml_e2 /* 0 */
	version 7
	if "$ML_nosc" == "" {
		local sclist $ML_sclst
	}
	$ML_vers $ML_user `1' $ML_b $ML_f $ML_g $ML_V `sclist'
	ml_count_eval $ML_f `2'
end
