*! version 1.0.0  06/23/93  (anachronism)
program define _crcause /* varname [varlist_of_numeric_vars] */
	version 3.1
	local touse "`1'"
	mac shift 
	if "`*'"=="" { exit }
	local varlist "req ex"
	parse "`*'"
	parse "`varlist'", parse(" ")
	quietly {
		local i 1
		while "``i''"!="" {
			replace `touse'=0 if ``i''==.
			local i=`i'+1
		}
	}
end
