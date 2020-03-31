*! version 1.0.1  04apr2014

program define _teffects_label2value, rclass
	syntax varname(numeric), label(string)

	cap confirm integer number `label'
	if !c(rc) {
		return local value = `label'
		exit
	}
	local lab : value label `varlist'
	if "`lab'" == "" {
		di as err "variable {bf:`varlist'} has no label"
		exit 459
	}
	cap label list `lab'
	local k = r(k)
	if (missing(`k')) local k = 0

	local k1 = r(min)
	local k2 = r(max)
	local found = 0

	forvalues i=`k1'/`k2' {
		local levi : label `lab' `i', strict
		if "`levi'" == "`label'" {
			return local value = `i'
			local found = 1
			continue, break
		}
	}
	if (`found') exit
	
	di as err "{p}label {bf:`label'} cannot be found in value label " ///
	 "{bf:`lab'} for variable {bf:`varlist'}{p_end}"
	exit 459
end
exit
