*! version 1.0.2  19oct2004
program define clogit_lf
        version 6
	args todo b lnf g negH g1

	if `todo'>0 {
		local gopt grad(`g')
		if `todo' == 2 {
			local hopt h(`negH')
		}
	}

	if "$ML_wtyp" != "" {
		local wgt `"[$ML_wtyp$ML_wexp]"'
	}

	if "$ML_xo1" != "" {
		local off "offset($ML_xo1)"
	}
	if "`g1'" != "" {
		capture drop `g1'
		local scopt score(`g1')
	}

	qui _clogit_lf $ML_y1 $ML_x1 if $ML_samp `wgt', group($CLOG_gr) /// 
		`off' beta(`b') lnf(`lnf') `gopt' `hopt' `scopt' sorted
end
