*! version 1.0.0  20jun2004

program ivprob_1_lf

	version 8.0
	args lf xb1 xb2 athrho lnsigma
	tempvar rho sigma
	qui gen double `rho' = tanh(`athrho')
	qui gen double `sigma' = exp(`lnsigma')
	tempvar w
	qui gen double `w' = 1/sqrt(1-`rho'^2) * ///
	                     (`xb1' + `rho'/`sigma'*($ML_y2 - `xb2'))
	qui replace `lf' = norm(`w')^$ML_y1 * (norm(-`w'))^(1-$ML_y1) * ///
			   1/`sigma'*normden(($ML_y2 - `xb2') / `sigma')
	qui replace `lf' = ln(`lf')

end
