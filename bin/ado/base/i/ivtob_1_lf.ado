*! version 1.2.0  19feb2019

program ivtob_1_lf

	version 8.0
	args lnf xb1 xb2 alpha lns lnv
	
	tempvar s v
	qui gen double `s' = exp(`lns')
	qui gen double `v' = exp(`lnv')
	
	tempvar eq2resid w
	qui gen double `eq2resid' = $ML_y2 - `xb2'
	qui gen double `w' = `xb1' + `eq2resid'*`alpha'
	
	qui replace `lnf' = -0.5*ln(2*_pi) - 0.5*ln(`v'^2) - ///
		`eq2resid'^2 / (2*`v'^2)
	qui replace `lnf' = `lnf' - 0.5*ln(2*_pi) - 0.5*ln(`s'^2) - ///
		(($ML_y1-`w')^2 / (2*`s'^2)) ///
		if $ML_y1 > $IVT_ll & $ML_y1 < $IVT_ul
	qui replace `lnf' = `lnf' + ln1m(norm((`w'-$IVT_ll) / `s')) ///
		if $ML_y1 <= $IVT_ll
	qui replace `lnf' = `lnf' + ln(norm((`w'-$IVT_ul)/`s')) 	///
		if $ML_y1 >= $IVT_ul
	
end
