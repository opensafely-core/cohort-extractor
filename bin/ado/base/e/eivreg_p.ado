*! version 1.0.1  30may2019
program eivreg_p, properties(default_xb)

	version 15

	if `"`e(cmd)'"' != "eivreg" {
		error 301
	}

	syntax [anything] [if] [in] [, XB * ]

	local type "`xb' `options'"
	if (`:word count `type'' > 1) {
		di as err "only one option may be specified"
		exit 198
	}
	
	if "`options'" != "" {
		di as err "option {bf:`options'} is not allowed"
		exit 198
	}

	tobit_p `0'
	di as txt "(predictions assume covariates measured without error)"

end
