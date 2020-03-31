*! version 1.0.1  17jun2019
program _lasso_dta_notes
	version 16.0
	notes lambda   : Lambda -- lasso penalty

	notes alpha    : Alpha -- elastic net penalty

	notes l1norm01 : The L1-norm (l1nrom) for each id divided by 	///
		the maximum L1-norm over all searched ids. 		///
		A rescaled norm between 0 and 1.

	notes l1normraw01 : The L1-norm (l1nromraw) for each id divided ///
		by the maximum L1-norm over all searched ids. 		///
		A rescaled norm between 0 and 1.

	notes l2normraw01 : The L2-norm (l2normraw) for each id 	///
		divided by the maximum L2-norm over all searched ids.  	///
		A rescaled norm between 0 and 1.

	notes ll       : Log-likelihood of model that is fit using the 	///
		variables selected by the current lambda and associated ///
		penalty weights
	
	local cv : char _dta[cv]

	local cvm_note The cross-validation mean is also called the 	///
		out-of-sample mean prediction deviance.  Where, for 	///
		cross-validation, out-of-sample means that the deviance ///
		is computed on each cross-validation fold using the 	///
		model fit on the remaining folds.  

	local cvratio_note Out-of-sample proportion of deviance explained  ///
		over the cross-validation folds compared to a 		///
		constant-only model.  For linear models this is the 	///
		out-of-sample (or more correctly, cross-validation 	///
		samples) R-squared.

	if (`cv') {
		notes cvm  : `cvm_note'
		notes cvratio  : `cvratio_note'
	}
end
