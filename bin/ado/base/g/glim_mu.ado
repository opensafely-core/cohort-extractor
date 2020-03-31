*! version 1.0.0  28apr2000
program define glim_mu
	version 7
	args min max mu

	tempname eps
	scalar `eps' = 1e-8
	replace `mu' = `min'+`eps' if `mu'<=`min'+`eps'
	replace `mu' = `max'-`eps' if `mu'>=`max'-`eps'
end
