*! version 1.0.1  07feb2012
program svymarkout_8, rclass
	version 8.1
	syntax varname

	// retrieve the variables that identify the survey design
	// characteristics
	quietly svyset
	local wvar `r(`r(wtype)')'
	local strata `r(strata)'
	local psu `r(psu)'
	local fpc `r(fpc)'

	// markout observations containing missing values
	local touse `varlist'
	markout `touse' `wvar' `fpc'
	markout `touse' `strata' `psu', strok

	// return the name of the weight var
	return local weight `wvar'
end
exit
