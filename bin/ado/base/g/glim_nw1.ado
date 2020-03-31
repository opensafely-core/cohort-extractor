*! version 1.0.0  16may2000
program define glim_nw1, rclass
	version 7
	args lag j 
	return scalar wt = 1.0 - `j'/(`lag'+1.0)
	return local setype  "Newey-West"
	return local sewtype "Bartlett (Truncation lag `lag')"
end
exit

Newey-West estimator uses Bartlett window weights
