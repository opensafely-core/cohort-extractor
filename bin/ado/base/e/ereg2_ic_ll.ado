*! version 1.1.0  19feb2019
program ereg2_ic_ll 
	
	version 15

	args todo b lnfj g H
	
	local t0 "$ML_y1"
	local t1 "$ML_y2"
	local f  "$ML_y3"

	tempvar xb 
	mleval `xb' = `b', eq(1)

	tempvar lambda et0 et1
	qui gen double `lambda' = exp(-1*`xb')
	qui gen double `et0' = -`t0'*`lambda'
	qui gen double `et1' = -`t1'*`lambda'

	qui replace `lnfj' = -`xb' + `et0' + log(`t0') if `f' == 1
	qui replace `lnfj' = `et0'  if `f' == 2
	qui replace `lnfj' = log(-expm1(`et1')) if `f' == 3
	qui replace `lnfj' = log(exp(`et0')-exp(`et1')) if `f'==4

	if (`todo'==0 | missing(`lnfj')) exit

	qui replace `g' = -1 - `et0' if `f' == 1
	qui replace `g' = -`et0' if `f' == 2
	qui replace `g' = exp(`et1')*`et1'/(-expm1(`et1')) if `f' == 3
	qui replace `g' = (-exp(`et0')*`et0' + exp(`et1')*`et1') /  ///
			  (exp(`et0')-exp(`et1')) if `f' == 4

	if (`todo'==1) exit

	tempvar F mF G
	qui gen double `F' = `et0'*exp(`et0')- `et1'*exp(`et1') if `f' == 4
	qui gen double `mF' = `et0'*exp(`et0')*(1+`et0')- ///
			    `et1'*exp(`et1')*(1+`et1') if `f' == 4
	qui gen double `G' = exp(`et0')- exp(`et1') if `f' == 4

	tempvar h
	qui gen double `h' = `et0' if `f' == 1 | `f' == 2
	qui replace `h' = (-`et1'*exp(`et1')*(-expm1(`et1')+`et1')) / ///
			  ((-expm1(`et1'))^2) if `f' == 3
	qui replace `h' = (`mF' * `G' - `F'^2 ) / `G'^2 if `f' == 4

	mlmatsum `lnfj' `H' = `h'

end
