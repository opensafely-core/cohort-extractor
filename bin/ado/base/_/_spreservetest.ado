*! version 1.0.0  04feb2013
program _spreservetest
	version 12

	args n rest

	if `"`rest'"' != "" {
		error 101
	}

	confirm integer num `n'

	forvalues i = 1/`n' {
		preserve
		drop _all
		restore
	}
end
