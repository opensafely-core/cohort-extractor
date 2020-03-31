*! version 1.0.0  12mar2015
program _mcmc_diparams
	args tomac colon frommac
	local frommac = subinstr(`"`frommac'"',"{","{c -(",.)
	local frommac = subinstr(`"`frommac'"',"}","{c )-}",.)
	local frommac = subinstr(`"`frommac'"',"-(","-(}",.)
	c_local `tomac' `"`frommac'"'
end
