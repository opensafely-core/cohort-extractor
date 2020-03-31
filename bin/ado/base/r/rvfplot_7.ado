*! version 3.0.6  05sep2001
program define rvfplot_7	/* residual vs. fitted */
	version 6
	_isfit cons anovaok
	syntax [, *]
	tempvar resid hat
	quietly _predict `resid' if e(sample), resid
	quietly _predict `hat' if e(sample)
	label var `resid' "Residuals"
	label var `hat' "Fitted values"
	gr7 `resid' `hat', `options'
end
