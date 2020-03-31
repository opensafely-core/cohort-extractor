*! version 1.0.2  20jan2015
program manova_estat, rclass
	version 9

	if "`e(cmd)'" != "manova" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		if 0`e(version)' < 2 {
			// old manova has generic name stripes
			ManovaSumm `rest'
		}
		else {
			estat_default `0'
		}
	}
	else {
		estat_default `0'
	}

	return add
end

program ManovaSumm, rclass
	// handle the varlist since names are not on the e(b) matrix stripe

	syntax [anything(name=vlist)] [, * ]

	if `"`vlist'"' == "" {
		local vlist `e(depvars)' `e(indepvars)'
	}

	estat_summ `vlist', `options'

	return add
end
