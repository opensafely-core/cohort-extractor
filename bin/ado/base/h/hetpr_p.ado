*! version 1.2.2  15oct2019
program define hetpr_p
	version 6, missing

	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		ml score `0'
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat 
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR CONstant(varname) 
			SE:
				Index XB STDP CONstant(varname)
		*/
	local myopts "Pr Sigma"

		/* Step 2:
			call _propts, exit if done, 
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' { exit }
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'


		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]

	if "`sigma'" != "" {
		tempvar lnvar
		_predict double `lnvar' `if' `in', xb eq(#2) `offset'
		qui gen `vtyp' `varn' = exp(`lnvar')
		label var `varn' "Sigma"
	}
	else {
		if "`pr'"=="" {
		   version 7: noi di in gr "(option {bf:pr} assumed; Pr(`e(depvar)'))"
		}
		tempvar num denom
	        _predict double `num' `if' `in', xb eq(#1) `offset'
		_predict double `denom' `if' `in', xb eq(#2) `offset'
		qui replace `denom' = exp(`denom')
		qui gen `vtyp' `varn' = normprob(`num'/`denom')
		label var `varn' "Pr(`e(depvar)')"
	}
end
