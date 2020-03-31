*! version 1.0.1  15oct2019
program define hetregress_p
	version 15

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		if "`e(method)'" == "twostep" {
			di as err "{p}option {bf:scores} is not allowed " ///
				"with two-step results{p_end}"
			exit 198
		}
		ml score `0'
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
		*/
	local myopts "sigma stdp"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' { 
		exit 
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' * ]

	if "`sigma'" != "" {
		tempvar lnvar
		_predict double `lnvar' `if' `in', xb eq(#2) 
		qui gen `vtyp' `varn' = exp(0.5 * `lnvar')
		label var `varn' "Heteroskedastic standard deviation"
	}
	else if "`stdp'" != "" {
		_predict `vtyp' `varn', stdp	
	}
	else {
		if "`options'" == "" {
			noi di in gr "(option {bf:xb} assumed)"
			predict `vtyp' `varn', xb
		}
	}
end
