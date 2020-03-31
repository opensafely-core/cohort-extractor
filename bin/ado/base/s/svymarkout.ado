*! version 2.0.0  03jan2005
program svymarkout
	if _caller() < 9 {
		svymarkout_8 `0'
	}
	else	SvyMarkout `0'
end

program SvyMarkout, rclass
	version 9
	syntax varname
	local touse `varlist'

	tempvar subuse
	_svy_setup `touse' `subuse', svy
	// return the name of the weight var
	if `"`r(wexp)'"' != "" {
		return local weight = `"`: word 2 of `r(wexp)''"'
	}
end

exit
