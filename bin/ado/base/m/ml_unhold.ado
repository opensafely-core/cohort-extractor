*! version 1.0.1  31oct2003
program ml_unhold, rclass
	version 8.1

	syntax	[, NOIsily ]

	if "`noisily'" == "" {
		local noisily quietly
	}

	if "$MLhold" == "" {
		exit
	}
	local hold = $MLhold

	local globals   : all globals  "ML`hold'_*"
	local scalars   : all scalars  "ML`hold'_*"
	local matrices  : all matrices "ML`hold'_*"
	local 0 _ML`hold'*
	capture syntax varlist

	if `"`globals'`scalars'`matrices'`varlist'"' == "" {
		// nothing to do
		exit
	}

	local hglobals  : subinstr local globals  "ML`hold'_" "ML_", all
	local hscalars  : subinstr local scalars  "ML`hold'_" "ML_", all
	local hmatrices : subinstr local matrices "ML`hold'_" "ML_", all
	local hvarlist  : subinstr local varlist  "_ML`hold'" "_ML", all

	// rename the globals
	forval i = 1/`:word count `globals'' {
		local cur : word `i' of `globals'
		local new : word `i' of `hglobals'
		global `new' `"${`cur'}"'
		global `cur'
		`noisily' di as txt "global: `cur' to `new'"
	}

	// rename the scalars
	forval i = 1/`:word count `scalars'' {
		local cur : word `i' of `scalars'
		local new : word `i' of `hscalars'
		scalar `new' = `cur'
		capture scalar drop `cur'
		`noisily' di as txt "scalar: `cur' to `new'"
	}

	// rename the matrices
	forval i = 1/`:word count `matrices'' {
		local cur : word `i' of `matrices'
		local new : word `i' of `hmatrices'
		capture matrix drop `new'
		matrix rename `cur' `new'
		`noisily' di as txt "matrix: `cur' to `new'"
	}

	// rename the variables
	forval i = 1/`:word count `varlist'' {
		local cur : word `i' of `varlist'
		local new : word `i' of `hvarlist'
		rename `cur' `new'
		`noisily' di as txt "variable: `cur' to `new'"
	}

	global MLhold `--hold'
	if $MLhold <= 0 {
		global MLhold
	}

	return local globals `"`globals'"'
	return local scalars `"`scalars'"'
	return local matrices `"`matrices'"'
end
