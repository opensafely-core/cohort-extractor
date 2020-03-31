*! version 1.0.0  24jun2004
program corr_kmo, rclass
	version 8
	
	syntax anything(id="corr/cov matrix" name=C) [, noVar FORmat(str)  ]
	confirm matrix `C'
	
	if `"`format'"' == "" { 
		local format %7.4f
	}
	else {
		// forces error message
		local junk : display `format' 0.5
	}

// get ICorr = inv(correlation)

	tempname ICorr D ACorr Coff ACoff Kmo

	// get inverse of the correlation matrix
	matrix `ICorr' = syminv(corr(`C'))
	if diag0cnt(`ICorr') > 0 {
		dis as err "correlation matrix is singular"
		exit 498
	}
	local nv = colsof(`ICorr')

// anti-image correlation = minus - partial correlation

	matrix `D' = diag(vecdiag(`ICorr'))
	forvalues i = 1 / `nv' {
		matrix `D'[`i',`i']  = 1/sqrt(`D'[`i',`i'])
	}
	matrix `ACorr' = `D' * `ICorr' * `D'

// compute KMO (overall)

	scalar `Coff'  = 0
	scalar `ACoff' = 0
	forvalues i = 1 / `nv' {
		forvalues j = 1 / `=`i'-1' {
			scalar `Coff'  = `Coff'  + el(`C',`i',`j')^2
			scalar `ACoff' = `ACoff' + el(`ACorr',`i',`j')^2
		}
	}
	scalar `Kmo' = `Coff'/(`Coff' + `ACoff')
	return scalar kmo = `Kmo'

	if "`var'" == "" {
		tempname KMOV
		matrix `KMOV' = J(`nv'+1,1,1)
		forvalues i = 1 / `nv' {
			scalar `Coff'  = 0
			scalar `ACoff' = 0
			forvalues j = 1 / `nv' {
				if (`i' == `j') continue

				scalar `Coff'  = `Coff'  + el(`C',`i',`j')^2
				scalar `ACoff' = `ACoff' + el(`ACorr',`i',`j')^2
			}
			matrix `KMOV'[`i',1]  = `Coff'/(`Coff' + `ACoff')
		}
		matrix `KMOV'[`nv'+1,1] = `Kmo'
		matrix rownames `KMOV' = `:rownames `D'' Overall
		matrix colnames `KMOV' = kmo

		matlist `KMOV' , lines(rowtotal) border(row) ///
		   format(`format') tindent(0) left(4) rowt(Variable)   ///
 		   title(Kaiser-Meyer-Olkin measure of sampling adequacy) 

		return matrix kmow = `KMOV'
	}
	else {
		dis as txt _n ///
		  "Kaiser-Meyer-Olkin measure of sampling adequacy " ///
	          "(overall) = " as res `format' `Kmo'
	}
end
