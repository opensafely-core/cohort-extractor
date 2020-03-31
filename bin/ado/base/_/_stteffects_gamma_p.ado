*! version 1.0.0  07jan2015

program define _stteffects_gamma_p
	version 14.0
	syntax newvarname [if], [ mean time Surv ]
	
	tempvar xb

	tempname b
	mat `b' = e(b)

	qui mat score double `xb' = `b' `if', eq(_t)

	qui replace `xb' = exp(`xb') `if'
	if "`mean'"!="" & "`time'"!="" {
		gen double `varlist' = `xb' `if'
		label variable `varlist' "mean survival time"
		exit
	}
	tempvar zg t1
	local t : char _dta[st_t]
	qui mat score double `zg' = `b' `if', eq(lnshape)
	qui replace `zg' = exp(-2*`zg') `if'

	qui gen double `t1' = `zg'*`t'/`xb' `if'
	qui replace `t1' = 1-gammap(`zg',`t1') `if'

	qui gen double `varlist' = `t1' `if'
	label variable `varlist' "survival probability"
end

exit
