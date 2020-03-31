*! version 1.4.1  19feb2019
program define clog_p
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
	local myopts "Pr d1(string) d2(string)"

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

	if "`pr'"=="" {
		di in smcl in gr "(option {bf:pr} assumed; Pr(`e(depvar)'))"
	}
	tempvar xb
	_predict double `xb' `if' `in', `offset' xb

	if `"`d2'"' != "" {
		tempvar exb
		qui gen double `exb' = exp(`xb') `if' `in'
		qui gen `vtyp' `varn' = exp(`xb'-`exb')*(1-`exb') `if' `in'
		label var `varn' "d2 Pr(`e(depvar)') / d xb d xb"
	}
	else if `"`d1'"' != "" {
		qui gen `vtyp' `varn' = exp(`xb'-exp(`xb')) `if' `in'
		label var `varn' "d Pr(`e(depvar)') / d xb"
	}
	else {
		qui gen `vtyp' `varn' =  -expm1(-exp(`xb')) `if' `in'
		label var `varn' "Pr(`e(depvar)')"
	}

end
