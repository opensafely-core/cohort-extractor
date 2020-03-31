*! version 1.0.0  16may2000
program define glim_nw2, rclass
	version 7
	args lag j 
	tempname z
	scalar `z' = `j'/(`lag'+1.0)

	if `z' <= .5 {
		return scalar wt = 1 - 6*`z'*`z'+6*`z'*`z'*`z'
	}
	else {
		return scalar wt = 2.0*(1.0-`z')^3 
	}
	return local setype  "Gallant"
	return local sewtype "Parzen (Truncation lag `lag')"
end
exit

Gallant estimator uses Parzen window weights
Note: |z| is always positive in our code

