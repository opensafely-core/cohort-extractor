*! version 1.0.0  21may2019
program _lasso_get_lchar, sclass
	syntax [, subspace(passthru)]

	esrf get coef_name : _dta[coef_name], `subspace'
	esrf get sd_X : _dta[sd_X], `subspace'
	esrf get indeps : _dta[indeps], `subspace'
	
	sret local coef_name `coef_name'
	sret local sd_X `sd_X'
	sret local indeps `indeps'
end
