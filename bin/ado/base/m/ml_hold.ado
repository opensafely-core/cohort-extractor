*! version 1.0.0  19sep2003
program ml_hold, rclass
	version 8.1

	syntax	[, NOIsily ]

	if "`noisily'" == "" {
		local noisily quietly
	}

	if "$MLhold" != "" {
		local hold = $MLhold+1
	}
	else	local hold 1

	local globals   : all globals  "ML_*"
	local scalars   : all scalars  "ML_*"
	local matrices  : all matrices "ML_*"
	local 0 _ML*
	capture syntax varlist

	if `"`globals'`scalars'`matrices'`varlist'"' == "" {
		// nothing to do
		exit
	}

	local hglobals  : subinstr local globals  "ML_" "ML`hold'_", all
	local hscalars  : subinstr local scalars  "ML_" "ML`hold'_", all
	local hmatrices : subinstr local matrices "ML_" "ML`hold'_", all
	local hvarlist  : subinstr local varlist  "_ML" "_ML`hold'", all

	// rename the globals
	forval i = 1/`:word count `globals'' {
		local cur : word `i' of `globals'
		local new : word `i' of `hglobals'
		global `new' `"${`cur'}"'
		global `cur'
		`noisily' di as txt "global: `cur' to `new', clearing `cur'"
	}

	// rename the scalars
	forval i = 1/`:word count `scalars'' {
		local cur : word `i' of `scalars'
		local new : word `i' of `hscalars'
		scalar `new' = `cur'
		scalar drop `cur'
		`noisily' di as txt "scalar: `cur' to `new', dropping `cur'"
	}

	// rename the matrices
	forval i = 1/`:word count `matrices'' {
		local cur : word `i' of `matrices'
		local new : word `i' of `hmatrices'
		matrix rename `cur' `new'
		`noisily' di as txt "matrix: rename `cur' to `new'"
	}

	// rename the variables
	forval i = 1/`:word count `varlist'' {
		local cur : word `i' of `varlist'
		local new : word `i' of `hvarlist'
		rename `cur' `new'
		`noisily' di as txt "variable: `cur' to `new'"
	}

	global MLhold `hold'

	return local globals `"`globals'"'
	return local scalars `"`scalars'"'
	return local matrices `"`matrices'"'
end
