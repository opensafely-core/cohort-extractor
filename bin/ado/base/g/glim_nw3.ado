*! version 1.0.0  16may2000
program define glim_nw3, rclass
	version 7
	args lag j 
	tempname z 
	scalar `z' = `j'/(`lag'+1.0)*6.0*_pi/5.0

	if `z' == 0 {
		return scalar wt = 1.0
	}
	else {
		return scalar wt = 3.0 * /*
			*/ (sin(`z')/`z'-cos(`z')) / (`z'*`z') 
	}
	return local setype  "Anderson"
	return local sewtype "Quadratic Spectral"
end
exit

Anderson estimator uses quadratic spectral window weights
