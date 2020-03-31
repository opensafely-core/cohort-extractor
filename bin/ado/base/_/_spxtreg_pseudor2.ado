*! version 1.0.1  10feb2017
					//----------------------------//
					//_spxtreg_pseudor2 : compute the pseudo
					//R^2 and comparison test statistics
					//----------------------------//
program _spxtreg_pseudor2, rclass
	
	PostCommand	
	local y `e(depvar)'
	tempvar yp
	_spxtreg_p double `yp' if e(sample), rform
	qui corr `yp' `y' if e(sample)
	local r	= r(rho)
	ret scalar r2_p	= (`r')^2
end

program PostCommand, rclass
	ret local cmd _spxtreg_pseudor2
end
