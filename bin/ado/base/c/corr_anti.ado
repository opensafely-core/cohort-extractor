*! version 1.0.1  22may2007
program corr_anti, rclass
	version 8

	syntax anything(name=C) [, noCORR noCOV FORmat(passthru) ]
	confirm matrix `C'

	if "`corr'" != "" & "`cov'" != "" {
		dis as txt "(nothing to display)"
	}

	tempname ICorr  ACov ACorr D

	matrix `ICorr' = syminv(corr(`C'))
	if diag0cnt(`ICorr') > 0 {
		dis as err "correlation matrix is singular"
		exit 498
	}

	local nv = colsof(`ICorr')
	matrix `D' = diag(vecdiag(`ICorr'))
	forvalues i = 1 / `nv' {
		matrix `D'[`i',`i']  = 1/sqrt(`D'[`i',`i'])
	}
	matrix `ACorr' = `D' * `ICorr' * `D'
	matrix `ACov'  = `D' * `ACorr' * `D'

	matrix `ACorr' = 0.5*(`ACorr' + `ACorr'')
	matrix `ACov' = 0.5*(`ACov' + `ACov'')

// anti-image correlation = minus - partial correlation

	local mopt border(row) left(4) tindent(0) rowtitle(Variable)
	
	if "`corr'" == "" {
		if `"`format'"' == "" {
			local format format(%8.4f)
		}	
		matlist `ACorr' , `format' `mopt' ///
		   title(Anti-image correlation coefficients {hline 3} ///
		   	 partialing out all other variables)
	}

// anti-image covariance  = minus - partial covariances

	if "`cov'" == "" {
		if `"`format'"' == "" {
			local format format(%9.0g) 
		}	
		matlist `ACov' , `format' `mopt' ///
		   title(Anti-image covariance coefficients {hline 3} ///
		         partialing out all other variables)
	}

	return matrix acov  = `ACov'
	return matrix acorr = `ACorr'
end
exit
