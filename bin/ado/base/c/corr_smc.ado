*! version 1.0.0  24jun2004
program corr_smc, rclass
	version 8
	
	syntax anything(name=C) [, FORmat(str) ]
	confirm matrix `C'

	if `"`format'"' == "" { 
		local format %7.4f
	}
	else {
		local junk : display `format' 0.5
	}
	
	tempname ICorr Smc

	matrix `ICorr' = syminv(corr(`C'))
	if diag0cnt(`ICorr') > 0 {
		dis as err "correlation matrix is singular"
		exit 498
	}

	matrix `Smc' = vecdiag(`ICorr')'
	forvalues j = 1 / `=rowsof(`Smc')' {
		matrix `Smc'[`j',1] = 1 - 1/`Smc'[`j',1]
	}
	matrix colnames `Smc' = smc

	matlist `Smc', /// 
	   format(`format') left(4) rowtitle(Variable) ///
	   border(row) tindent(0) ///
	   title(Squared multiple correlations of variables ///
	   	 with all other variables)

	return matrix smc = `Smc'
end
