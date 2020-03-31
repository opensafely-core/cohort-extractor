*! version 1.0.0 11oct1999
program define treat_ll
	version 6.0
	args lnf beta gamma athrho lnsigma
	tempvar tmp1 tmp2 rho
	qui gen double `rho' = (exp(2*`athrho') - 1)/(exp(2*`athrho') + 1) 
	qui gen double `tmp1' = /*
	*/	(`rho'*($ML_y1 - `beta')/exp(`lnsigma') + `gamma') /*
	*/     /sqrt(1 - `rho'^2)
	qui gen double  /*
	*/	`tmp2'= normd(($ML_y1 - `beta')/exp(`lnsigma'))/exp(`lnsigma')  
	qui replace `lnf' = ln(normprob(`tmp1')) + ln(`tmp2') if $ML_y2 == 1
	qui replace `lnf' = ln(normprob(-`tmp1'))+ ln(`tmp2') if $ML_y2 == 0
end
