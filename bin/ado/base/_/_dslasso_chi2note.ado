*! version 1.0.3  17jun2019
program _dslasso_chi2note
	version 16.0

	di "{p 0 6 2 78}"
	di as txt "Note: Chi-squared test is a Wald test of "             ///
		"the coefficients of the variables of interest jointly "  ///
		"equal to zero. "					  ///
		"Lassos {help j_lasso_inferential:select controls} "	  ///
		"for model estimation. "				  ///
		"Type {stata lassoinfo} to see number of selected "	  ///
		"variables in each lasso."
	di "{p_end}"
end
