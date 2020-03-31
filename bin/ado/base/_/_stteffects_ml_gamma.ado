*! version 1.0.0  28jan2015

program define _stteffects_ml_gamma
	version 14.0
	args todo b lf g1 g2 H

	/* survival time variable					*/
	local t : char _dta[st_t]
	/* failure event variable					*/
	local f : char _dta[st_d]
	
	tempvar xb zg a lbd s z

	mleval `zg' = `b', eq(2)
	mleval `xb' = `b', eq(1)
	qui gen double `s' = exp(`xb'+2*`zg') if $ML_samp
	qui gen double `lbd' = exp(`xb')
	qui gen double `a' = exp(-2*`zg')
	qui gen double `z' = `t'/`s' if $ML_samp

	qui replace `lf' = cond(`f',log(gammaden(`a',`s',0,`t')), ///
		log(gammaptail(`a',`z'))) if $ML_samp

	if `todo' {
		tempvar ti e

		qui gen byte `ti' = 1 if $ML_samp

		if `todo' > 1 {
			forvalues i=1/7 {
				tempvar d`i'
				qui gen double `d`i'' = . 

				local dlist `dlist' `d`i''
			}
		}
		qui gen double `e' = .

		_stteffects_gamma_moments `e' `g1' `g2' if $ML_samp, ///
			xb(`xb') zg(`zg') ti(`ti') to(`t') do(`f')  ///
			deriv(`dlist')

		if `todo' > 1 {
			tempname d11 d12 d21 d22
			mlmatsum `lf' `d11' = `d4', eq(1)
			mlmatsum `lf' `d12' = `d5', eq(1,2)
			mlmatsum `lf' `d21' = `d6', eq(2,1)
			mlmatsum `lf' `d22' = `d7', eq(2)
			mat `H' = (`d11',`d12' \ `d21',`d22')
		}
	}
end

exit
